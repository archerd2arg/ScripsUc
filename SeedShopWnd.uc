class SeedShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW	= 333;

enum ShopType		// 지금 열고 있는 창이 판패창인지 구매창인지 나타낸다
{
	ShopNone,		// Invalid type
	ShopBuy,
	ShopSell,
	ShopPreview,
};

var String m_WindowName;		// 상속에 사용하려고 윈도우 이름 추가 - lancelot 2006. 11. 27.

var ShopType m_shopType;
var int		m_merchantID;
var int		m_npcID;	// only for shoppreveiw
var INT64	m_currentPrice;		// 구매/판매 목록에 올려놓은 아이템의 가격을 합산한 것

function OnRegisterEvent()
{
	registerEvent( EV_ShopOpenWindow );
	registerEvent( EV_ShopAddItem );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	m_currentPrice = IntToInt64(0);

	class'UIAPI_ITEMWINDOW'.static.Clear(m_WindowName$".TopList");
	class'UIAPI_ITEMWINDOW'.static.Clear(m_WindowName$".BottomList");

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".PriceText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".PriceText", "");

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".AdenaText", "");

	class'UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName$".InvenWeight");
}

function OnEvent(int Event_ID,string param)
{
	switch( Event_ID )
	{
	case EV_ShopOpenWindow:
		HandleOpenWindow(param);
		break;
	case EV_ShopAddItem:
		HandleAddItem(param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	}
}

function OnClickButton( string ControlName )
{
	local int index;
	if( ControlName == "UpButton" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum( m_WindowName$".BottomList" );
		MoveItemBottomToTop( index, false );
	}
	else if( ControlName == "DownButton" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum( m_WindowName$".TopList" );
		MoveItemTopToBottom( index, false );
	}
	else if( ControlName == "OKButton" )
	{
		HandleOKButton();
	}
	else if( ControlName == "CancelButton" )
	{
		Clear();
		HideWindow(m_WindowName);
	}
}

function OnDBClickItem( string ControlName, int index )
{
	if(ControlName == "TopList")
	{
		MoveItemTopToBottom( index, false );
	}
	else if(ControlName == "BottomList")
	{
		MoveItemBottomToTop( index, false );
	}

}

function OnDropItem( string strID, ItemInfo info, int x, int y)
{
	local int index;
	//debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	if( strID == "TopList" && info.DragSrcName == "BottomList" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );	// ClassID
		if( index >= 0 )
			MoveItemBottomToTop( index, info.AllItemCount > IntToInt64(0) );
	}
	else if( strID == "BottomList" && info.DragSrcName == "TopList" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".TopList", info.ID );	// ClassID
		if( index >= 0 )
			MoveItemTopToBottom( index, info.AllItemCount > IntToInt64(0) );
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".TopList", index, info) )
	{
		// 1일경우 수량을 입력하는 다이얼로그는 출력하지 않는다.
//		debug("info.ConsumeType:"$info.ConsumeType$", 갯수:"$info.ItemNum);
		if( !bAllItem && IsStackableItem( info.ConsumeType ) && (info.ItemNum!=IntToInt64(1)) )		// stackable?
		{
			DialogSetID( DIALOG_TOP_TO_BOTTOM );
			DialogSetReservedItemID( info.ID );
			DialogSetDefaultOK();
			if( m_shopType == ShopSell )
				DialogSetParamInt64( info.ItemNum );
			else
				DialogSetParamInt64( IntToInt64(-1) );
			
			DialogSetDefaultOK();	
			DialogShow( DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ) );
		}
		else
		{
			info.bShowCount = false;

			if( m_shopType == ShopSell )
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );	// ClassID
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
				}
				class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// 물건을 팔 경우 자신의 인벤토리 목록에서 아이템을 제거
			}
			else if( m_shopType == ShopBuy )												// 무게 바에 추가되는 무게만큼 더해 준다.
			{
				info.ItemNum = IntToInt64(1);				// 상점 구매의 경우 ItemNum이 세팅 되어 있지 않은 경우가 있기 때문에 일부러 1로 해 줘야한다.
				class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
				class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum );
			}
			else if( m_shopType == ShopPreview)	//미리보기
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );	// ClassID
				info.ItemNum = IntToInt64(1);
				class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );				
			}
			AddPrice( info.Price * info.ItemNum );

		}
	}
}

function MoveItemBottomToTop( int index, bool bAllItem )
{
	local ItemInfo info, info2;
	local int bottomIndex;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".BottomList", index, info) )
	{
		if( !bAllItem && IsStackableItem( info.ConsumeType )  && (info.ItemNum!=IntToInt64(1) ))		// stackable?
		{
			DialogSetID( DIALOG_BOTTOM_TO_TOP );
			DialogSetDefaultOK();
			DialogSetReservedItemID( info.ID );
			DialogSetParamInt64( info.ItemNum );
			DialogSetDefaultOK();	
			DialogShow( DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ) );
		}
		else
		{
			class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".BottomList", index );
			if( m_shopType == ShopSell )
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".TopList", info.ID );	// ServerID
				if( bottomIndex == -1 )
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );			// 물건을 판매하는 경우 다시 자신의 인벤토리 목록으로
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".TopList", bottomIndex, info2);
					info2.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName$".TopList", bottomIndex, info2);
				}
			}
			else if( m_shopType == ShopBuy )												// 무게 바에 추가되는 무게만큼 빼 준다.
			{
				class'UIAPI_INVENWEIGHT'.static.ReduceWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum );
			}
			AddPrice( -info.Price * info.ItemNum );
		}
	}
}

function HandleDialogOK()
{
	local int id, index, topIndex;
	local INT64 num;
	local ItemInfo info, topInfo;
	local string param;
	local ItemID cID;

	if( DialogIsMine() )
	{
		id = DialogGetID();
		num = StringToInt64( DialogGetString() );
		cID = DialogGetReservedItemID();
		if( id == DIALOG_TOP_TO_BOTTOM && num > IntToInt64(0) )
		{
			topIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".TopList", cID );	// ClassID
			if( topIndex >= 0 )
			{
				class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
				if( m_shopType == ShopSell )
				{
					// 다이얼로그에서 엉뚱한 숫자 입력하는 것 방지.
					if( topInfo.ItemNum < num )
						num = topInfo.ItemNum;
				}
				index = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", cID );	// ClassID
				if( index >= 0 )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", index, info );
					info.ItemNum += num;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", index, info );
					AddPrice( num * info.Price );
				}
				else
				{
					info = topInfo;
					info.ItemNum = num;
					info.bShowCount = false;
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
					AddPrice( num * info.Price );
				}

				if( m_shopType == ShopSell )		// 판매일 경우 자신의 인벤토리 목록의 개수를 조정해 준다(구매일 경우 상인이 가진 아이템 숫자는 의미가 없음)
				{
					topInfo.ItemNum -= num;
					if( topInfo.ItemNum <= IntToInt64(0) )
						class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", topIndex );
					else
						class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".TopList", topIndex, topInfo );
				}
				else if( m_shopType == ShopBuy )												// 무게 바에 추가되는 무게만큼 더해 준다.
				{
					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num );
				}
			}
		}
		else if( id == DIALOG_BOTTOM_TO_TOP && num > IntToInt64(0) )
		{
			index = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", cID );	// ClassID
			if( index >= 0 )
			{
				class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", index, info );
				info.ItemNum -= num;
				if( info.ItemNum > IntToInt64(0) )
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", index, info );
				else 
					class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".BottomList", index );

				if( m_shopType == ShopSell )
				{
					topIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".TopList", cID );	// ClassID
					if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )
					{
						class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
						topInfo.ItemNum += num;
						class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".TopList", topIndex, topInfo );
					}
					else
					{
						info.ItemNum = num;
						class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );
					}
				}
				else if( m_shopType == ShopBuy )												// 무게 바에 추가되는 무게만큼 빼 준다.
				{
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num );
				}
				
				if( info.ItemNum <= IntToInt64(0) )	// 가격이 음수가 되는 일을 방지하기 위해
					num = info.ItemNum + num;

				AddPrice( -num * info.Price );
			}
		}
		else if( id == DIALOG_PREVIEW )
		{
			num = IntToInt64(class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" ));

			if( num > IntToInt64(0) )
			{
				// pack every item in BottomList
				ParamAdd( param, "merchant", string(m_merchantID) );
				ParamAdd( param, "npc", string(m_npcID) );
				ParamAddINT64( param, "num", num );
				for( index=0 ; index < Int64ToInt(num); ++index )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", index, info);
					ParamAddItemIDWithIndex( param, info.ID, index );
				}

				RequestPreviewItem( param );
			}
		}
	}
}

function HandleOpenWindow( string param )
{
	local string type;
	local INT64 adena;
	local string adenaString;

	local WindowHandle m_inventoryWnd;	// 인벤토리 핸들 선언.

	if(CREATE_ON_DEMAND==0)
		m_inventoryWnd = GetHandle( "InventoryWnd" );	//인벤토리의 윈도우 핸들을 얻어온다.
	else
		m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//인벤토리의 윈도우 핸들을 얻어온다.

	Clear();

	ParseString( param, "type", type );
	ParseInt( param, "merchant", m_merchantID ); 
	ParseINT64( param, "adena", adena );

	if( type == "buy" )
		m_shopType = ShopBuy;
	else if( type == "sell" )
		m_shopType = ShopSell;
	else if( type == "preview" )
		m_shopType = ShopPreview;
	else
		m_shopType = ShopNone;

	adenaString = MakeCostStringInt64(adena);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".AdenaText", adenaString);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".AdenaText", ConvertNumToText(Int64ToString(adena)) );

	if( m_inventoryWnd.IsShowWindow() )			//인벤토리 창이 열려있으면 닫아준다. 
	{
		m_inventoryWnd.HideWindow();
	}
	ShowWindow( m_WindowName );
	class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);

	if( type == "buy" )
	{
		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".TopList", "InventoryPrice1HideEnchantStackable" );
		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".BottomList", "InventoryPrice1" );

		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 136);

		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".TopText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".BottomText", GetSystemString(139) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".PriceConstText", GetSystemString(142) );
	}
	else if( type == "sell" )
	{
		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".TopList", "InventoryPrice2" );
		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".BottomList", "InventoryPrice2" );

		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 136);

		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".TopText", GetSystemString(138) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".BottomText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".PriceConstText", GetSystemString(143) );
	}
	else if( type == "preview" )
	{
		ParseInt( param, "npc", m_npcID );

		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".TopList", "InventoryPrice1HideEnchantStackable" );
		class'UIAPI_WINDOW'.static.SetTooltipType( m_WindowName$".BottomList", "InventoryPrice1" );

		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 847);

		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".TopText", GetSystemString(811) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".BottomText", GetSystemString(812) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".PriceConstText", GetSystemString(813) );
	}
}

function HandleAddItem( string param )
{
	local ItemInfo info;
	
	ParamToItemInfo( param, info );
	if( m_shopType == ShopBuy && info.ItemNum > IntToInt64(0) )
		info.bShowCount = true;

	class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );
}

function AddPrice( INT64 price )
{
	local string adena;
	
	m_currentPrice = m_currentPrice + price;
	
	adena = MakeCostStringInt64( m_currentPrice );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".PriceText", adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".PriceText", ConvertNumToText(Int64ToString(m_currentPrice)));
}

function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local INT64		limitedItemCount;

	bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
//	debug("ShopWnd m_shopType:" $ m_shopType $ ", bottomCount:" $ bottomCount);
	if( m_shopType == ShopBuy )
	{
		// limited item check
		topCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".TopList" );
		for( topIndex=0 ; topIndex < topCount ; ++topIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
			if(	topInfo.ItemNum > IntToInt64(0) )		// this item can be purchased only by limited number
			{
				limitedItemCount = IntToInt64(0);
				// search in BottomList for same classID
				bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
				for( bottomIndex=0; bottomIndex < bottomCount ; ++bottomIndex )		// match found, then check whether the number exceeds limited number
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					if( IsSameClassID(bottomInfo.ID, topInfo.ID) )
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if( limitedItemCount > topInfo.ItemNum )
				{
					// warning dialog
					DialogShow(DIALOG_Modalless, DIALOG_WARNING, GetSystemMessage(1338) );
					return;
				}
			}
		}
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex );
			ParamAddINT64( Param, "Count_" $ bottomIndex, bottomInfo.ItemNum );
		}
		RequestBuyItem( param );
	}
	else if( m_shopType == ShopSell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex );
			//ParamAdd( Param, "Count_" $ bottomIndex, string(bottomInfo.ItemNum) );
			ParamAddINT64( Param, "Count_" $ bottomIndex, bottomInfo.ItemNum );
		}
		RequestSellItem( param );
	}
	else if( m_shopType == ShopPreview )
	{
		if( bottomCount > 0 )
		{
			DialogSetID( DIALOG_PREVIEW );
			DialogShow( DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1157) );
		}
	}

	HideWindow(m_WindowName);
}

defaultproperties
{
    m_WindowName="ShopWnd"
}
