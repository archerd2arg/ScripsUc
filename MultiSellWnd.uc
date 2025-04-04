class MultiSellWnd extends UICommonAPI;

const MULTISELLWND_DIALOG_OK=1122;
var TextBoxHandle PointItemName;
var TextBoxHandle txtPointItemDescription;
var ItemWindowHandle ItemList;

struct MultiSellInfo
{
	var int 				MultiSellInfoID;
	var int 				MultiSellType;
	var INT64 				NeededItemNum;
	var	ItemInfo			ResultItemInfo;
	var array< ItemInfo >	OutputItemInfoList;
	var array< ItemInfo >	InputItemInfoList;
};

var array< MultiSellInfo >	m_MultiSellInfoList;
var int						m_MultiSellGroupID;
var int						m_nSelectedMultiSellInfoIndex;
var int						m_nCurrentMultiSellInfoIndex;

function OnRegisterEvent()
{
	registerEvent( EV_MultiSellInfoListBegin );
	registerEvent( EV_MultiSellResultItemInfo );
	registerEvent( EV_MultiSellOutputItemInfo );
	registerEvent( EV_MultiSellInputItemInfo );
	registerEvent( EV_MultiSellInfoListEnd );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		PointItemName = TextBoxHandle ( GetHandle( "PointItemName" ) );
		txtPointItemDescription = TextBoxHandle ( GetHandle( "txtPointItemDescription" ) );
		ItemList = ItemWindowHandle( GetHandle( "MultiSellWnd.ItemList"));
	}
	else
	{
		PointItemName = GetTextBoxHandle ( "PointItemName" );
		txtPointItemDescription = GetTextBoxHandle ("txtPointItemDescription" );
		ItemList = GetItemWindowHandle("MultiSellWnd.ItemList");

	}

	m_nSelectedMultiSellInfoIndex = -1;
	
	PointItemName.HideWindow();
	txtPointItemDescription.HideWindow();
}

function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
	case EV_MultiSellInfoListBegin:
		HandleMultiSellInfoListBegin( param );
		break;
	case EV_MultiSellResultItemInfo:
		HandleMultiSellResultItemInfo( param );
		break;
	case EV_MultiSellOutputItemInfo:
		HandelMultiSellOutputItemInfo( param );
		break;
	case EV_MultiSellInputItemInfo:
		HandelMultiSellInputItemInfo( param );
		break;
	case EV_MultiSellInfoListEnd:
		HandleMultiSellInfoListEnd( param );
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	};
}

function OnShow()
{
	class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
}

function OnHide()
{
}

function OnClickButton( string ControlName )
{
	if( ControlName == "OKButton" )
	{
		HandleOKButton();
	}
	else if( ControlName == "CancelButton" )
	{
		Clear();
		HideWindow("MultiSellWnd");
	}
}
function OnSelectItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local int i;
	local string param;
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
	class'UIAPI_MULTISELLNEEDEDITEM'.static.Clear("MultiSellWnd.NeededItem");
	if (a_hItemWindow == ItemList )
	{
		if( index >= 0 && index < m_MultiSellInfoList.Length )
		{
			for( i=0 ; i < m_MultiSellInfoList[index].InputItemInfoList.Length ; ++i )
			{
				param = "";
				ParamAdd( param, "Name",		m_MultiSellInfoList[index].InputItemInfoList[i].Name );
				ParamAdd( param, "ID",			string(m_MultiSellInfoList[index].InputItemInfoList[i].Id.ClassID ));
				ParamAddInt64( param, "Num",	m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum);
				ParamAdd( param, "Icon",		m_MultiSellInfoList[index].InputItemInfoList[i].IconName );
				ParamAdd( param, "Enchant",		string(m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted) );
				ParamAdd( param, "CrystalType", string(m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType) );
				ParamAdd( param, "ItemType",	string(m_MultiSellInfoList[index].InputItemInfoList[i].ItemType) );
				ParamAdd( param, "IconPanel",	m_MultiSellInfoList[index].InputItemInfoList[i].IconPanel );			// -- 판넬 추가 -_-;;
				//debug("what the hell");

				//debug("AddData " $ param );
				class'UIAPI_MULTISELLNEEDEDITEM'.static.AddData("MultiSellWnd.NeededItem", param);
			}

			for( i=0 ; i < m_MultiSellInfoList[index].OutputItemInfoList.Length ; ++i )
			{
				class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.ItemInfo", i, m_MultiSellInfoList[index].OutputItemInfoList[i] );
					
				if (m_MultiSellInfoList[index].OutputItemInfoList[i].IconName == "icon.pvp_point_i00")
				{
					class'UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.PointItemName");
					class'UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.txtPointItemDescription");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName",GetSystemString(102)$"x"$Int64ToString(m_MultiSellInfoList[index].OutputItemInfoList[i].ItemNum));
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription",GetSystemMessage(2334));
				}
				else
				{
					class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.PointItemName");
					class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.txtPointItemDescription");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName","");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription","");
				}
				
				
				
			}

			class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
			
			if( m_MultiSellInfoList[index].MultiSellType == 0 )
			{
				class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", "1");
				class'UIAPI_WINDOW'.static.DisableWindow("MultiSellWnd.ItemCountEdit");
			}
			else if( m_MultiSellInfoList[index].MultiSellType == 1 )
			{
				class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", "1");
				class'UIAPI_WINDOW'.static.EnableWindow("MultiSellWnd.ItemCountEdit");
			}
			
			if(m_nSelectedMultiSellInfoIndex != index)	//다이얼로그를 없애준다. - innowind
			{
				if( DialogIsMine() )
				{
					DialogHide();
				}
			}
		}
	}
}

function Print()
{
	local int i,j;
	for( i = 0; i<m_MultiSellInfoList.Length ; ++i)
	{
		for( j =0 ; j < m_MultiSellInfoList[i].InputItemInfoList.Length ; ++j )
		{
			//debug("Print ("$i$","$j$"), " $ m_MultiSellInfoList[i].InputItemInfoList[j].Name);
		}
	}
}

function Clear()
{
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
	class'UIAPI_MULTISELLNEEDEDITEM'.static.Clear("MultiSellWnd.NeededItem");
	class'UIAPI_ITEMWINDOW'.static.Clear("MultiSellWnd.ItemList");
}

function HandleMultiSellInfoListBegin( string param )
{
	Clear();
	ParseInt( param, "MultiSellGroupID", m_MultiSellGroupID );
}

function HandleMultiSellResultItemInfo( string param)
{
	local int		nMultiSellInfoID;
	local int		nBuyType;
	local ItemInfo	info;
	
	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "BuyType",					nBuyType );
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1 );
	ParseInt( param, "RefineryOp2",				info.RefineryOp2 );
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );
	
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = m_nCurrentMultiSellInfoIndex + 1;
	
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID	= nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType		= nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo	= info;
}

function HandelMultiSellOutputItemInfo( string param )
{
	local int		nMultiSellInfoID;
	local int		nCurrentOutputItemInfoIndex;
	local ItemInfo	info;
	local int		nItemClassID;
	//~ local ItemInfo	info;
	//~ ParseItemID( param, info.Id );
	//~ class'UIDATA_ITEM'.static.GetItemInfo( info.Id, info );
	//~ ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	
	ParseItemID( param, info.ID );
	class'UIDATA_ITEM'.static.GetItemInfo( info.ID, info );
	ParseInt( param, "ClassID",					nItemClassID );
	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "SlotBitType",				info.SlotBitType );
	ParseInt( param, "ItemType",				info.ItemType );
	ParseInt64( param, "ItemCount",				info.ItemNum);
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1);
	ParseInt( param, "RefineryOp2",				info.RefineryOp2);
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );
	
	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellOutputItemInfo - Invalid nMultiSellInfoID");
		return;
	}

	if( nItemClassID == -300 )
	{
		info.Name = GetSystemString( 102 );
		info.IconName = "icon.pvp_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}

	// 투영병기의 경우 강제로, 100% Durability를 표시하게 합니다 - NeverDie
	if( 0 < info.Durability )
	{
		info.CurrentDurability = info.Durability;
	}

	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = info;
}

function HandelMultiSellInputItemInfo( string param )
{
	local int		nMultiSellInfoID;
	local int		nCurrentInputItemInfoIndex;
	local int		nItemClassID;
	local ItemInfo	info;

	ParseItemID( param, info.Id );
	class'UIDATA_ITEM'.static.GetItemInfo( info.Id, info );

	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "ClassID",					nItemClassID );
	ParseInt( param, "ItemType",				info.ItemType );
	ParseInt64( param, "ItemCount",				info.ItemNum);
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1);
	ParseInt( param, "RefineryOp2",				info.RefineryOp2);
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellInputItemInfo - Invalid nMultiSellInfoID");
		return;
	}
	
	if( nItemClassID == -100 )
	{
		info.Name = GetSystemString(1277);
		info.IconName = "icon.etc_i.etc_pccafe_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else if( nItemClassID == -200 )
	{
		info.Name = GetSystemString( 1311 );
		info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else if( nItemClassID == -300 )
	{
		info.Name = GetSystemString( 102 );
		info.IconName = "icon.pvp_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else
	{
		info.Name = class'UIDATA_ITEM'.static.GetItemName( info.Id );
		info.IconName = class'UIDATA_ITEM'.static.GetItemTextureName( info.Id );
	}

	info.ItemType = class'UIDATA_ITEM'.static.GetItemDataType( info.Id );
	info.CrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType( info.Id );
	
	//-400 필드사이클일 경우 아무 데이터도 삽입하지 안ㅅ는 식으로 처리 함. 
	if (nItemClassID != -400 )
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = info;
	}
}

function HandleMultiSellInfoListEnd( string param )
{
	local WindowHandle m_inventoryWnd;
	
	if(CREATE_ON_DEMAND==0)
		m_inventoryWnd = GetHandle( "InventoryWnd" );	//인벤토리
	else
		m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//인벤토리
	
	if( m_inventoryWnd.IsShowWindow() )			//인벤토리 창이 열려있으면 닫아준다. 
	{
		m_inventoryWnd.HideWindow();
	}	
	
	ShowWindow("MultiSellWnd");
	class'UIAPI_WINDOW'.static.SetFocus("MultiSellWnd");
	ShowItemList();
}

function ShowItemList()
{
	local ItemInfo info;
	local int i;

	for( i=0 ; i < m_MultiSellInfoList.Length ; ++i )
	{
		info = m_MultiSellInfoList[i].OutputItemInfoList[0];
		class'UIAPI_ITEMWINDOW'.static.AddItem( "MultiSellWnd.ItemList", info );
	}
}

function HandleOKButton()
{
	local int selectedIndex;
	local INT64 itemNum;

	selectedIndex = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("MultiSellWnd.ItemList");
	itemNum = StringToInt64(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
	//debug("HandleOKButton selectedIndex: " $ selectedIndex $ ", itemNum: " $ itemNum );
	if( selectedIndex >= 0 )
	{
		DialogSetReservedInt( selectedIndex );
		DialogSetReservedInt2( itemNum );
		DialogSetID( MULTISELLWND_DIALOG_OK );
		DialogShow(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(1383));
		m_nSelectedMultiSellInfoIndex = selectedIndex;
	}
}

function HandleDialogOK()
{
	local string param;
	local int SelectedIndex;

	if( DialogIsMine() )
	{
		SelectedIndex = DialogGetReservedInt();

		if( SelectedIndex >= m_MultiSellInfoList.Length )
		{
			//debug("MultiSellWnd::HandleDialogOK - Invalid SelectIndex(" $ SelectedIndex $ ")" );
			return;
		}
		
		ParamAdd( param, "MultiSellGroupID",		string( m_MultiSellGroupID ) );
		ParamAdd( param, "MultiSellInfoID",			string( m_MultiSellInfoList[SelectedIndex].MultiSellInfoID ) );
		ParamAddINT64( param, "ItemCount",			DialogGetReservedInt2() );
		ParamAdd( param, "Enchant",					string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted ) );
		ParamAdd( param, "RefineryOp1",				string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1 ) );
		ParamAdd( param, "RefineryOp2",				string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2 ) );
		ParamAdd( param, "AttrAttackType",			string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType ) );
		ParamAdd( param, "AttrAttackValue",			string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue ) );
		ParamAdd( param, "AttrDefenseValueFire",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire ) );
		ParamAdd( param, "AttrDefenseValueWater",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater ) );
		ParamAdd( param, "AttrDefenseValueWind",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind ) );
		ParamAdd( param, "AttrDefenseValueEarth",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth ) );
		ParamAdd( param, "AttrDefenseValueHoly",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly ) );
		ParamAdd( param, "AttrDefenseValueUnholy",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy ) );

		RequestMultiSellChoose( param );
	}
}
defaultproperties
{
}
