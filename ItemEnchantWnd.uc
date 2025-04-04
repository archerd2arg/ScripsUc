class ItemEnchantWnd extends UICommonAPI;

///////////////////////////////////////////////////////////////////////////////////////////
//	ItemEnchantWnd 2.0																//
///////////////////////////////////////////////////////////////////////////////////////////
// 	Designed by Oxyzen
// 	UIAPI by ttMarine 
//	UC coded by Oxyzen

const C_ANIMLOOPCOUNT = 1;
var bool bEnchantbool, bEnchantedbool;
var int mEnchantLevel;
var int 			mEnchantItemType;
var bool bIsShopping;

var WindowHandle Me;
var TextureHandle BackPattern;
var TextBoxHandle InstructionTxt;
var ItemWindowHandle EnchantScriptSlot;
var ItemWindowHandle EnchantItemSlot;
var ItemWindowHandle CloverItemSlot;
var ItemWindowHandle EnchantedItemSlot;
var ButtonHandle EnchantBtn;
var ButtonHandle ExitBtn;
var TextureHandle Groupbox2;
var TextureHandle Groupbox1;
var TextureHandle EnchantScriptSlotBackTex;
var TextureHandle EnchantItemSlotBackTex;
var TextureHandle CloverItemSlotBackTex;
var TextureHandle EnchantedItemSlotBackTex;
var TextureHandle DropHighlight_enchantitem;
var TextureHandle DropHighlight_enchantscript;
var TextureHandle DropHighlight_CloverItem;


var AnimTextureHandle EnchantProgressAnim;


var ProgressCtrlHandle	m_hItemEnchantWndEnchantProgress;



// 변수 목록
var ItemInfo 		SelectItemInfo;		// 선택한 아이템
var ItemInfo		SelectHelperItemInfo;
var ItemID	 		SupportID;
var int 			ScrollCID;			// 스크롤의 종류를 저장한다. 
var int 			mEnchantScrollID;

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		
		Me = GetHandle( "ItemEnchantWnd" );
		EnchantProgressAnim = AnimTextureHandle ( GetHandle( "ItemEnchantWnd.EnchantProgressAnim" ) );
		BackPattern = TextureHandle ( GetHandle( "ItemEnchantWnd.BackPattern" ) );
		InstructionTxt = TextBoxHandle ( GetHandle( "ItemEnchantWnd.InstructionTxt" ) );
		EnchantScriptSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantScriptSlot" ) );
		EnchantItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantItemSlot" ) );
		CloverItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.CloverItemSlot" ) );
		EnchantedItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantedItemSlot" ) );
		EnchantBtn = ButtonHandle ( GetHandle( "ItemEnchantWnd.EnchantBtn" ) );
		ExitBtn = ButtonHandle ( GetHandle( "ItemEnchantWnd.ExitBtn" ) );
		Groupbox2 = TextureHandle ( GetHandle( "ItemEnchantWnd.Groupbox2" ) );
		Groupbox1 = TextureHandle ( GetHandle( "ItemEnchantWnd.Groupbox1" ) );
		EnchantScriptSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantScriptSlotBackTex" ) );
		EnchantItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantItemSlotBackTex" ) );
		CloverItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.CloverItemSlotBackTex" ) );
		EnchantedItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantedItemSlotBackTex" ) );
		DropHighlight_enchantitem = TextureHandle ( GetHandle( "ItemEnchantWnd.DropHighlight_enchantitem" ) );
		DropHighlight_enchantscript = TextureHandle ( GetHandle( "ItemEnchantWnd.DropHighlight_enchantscript" ) );
		DropHighlight_CloverItem = TextureHandle ( GetHandle( "ItemEnchantWnd.DropHighlight_CloverItem" ) );
	}
	else
	{
		Me = GetWindowHandle( "ItemEnchantWnd" );
		EnchantProgressAnim = GetAnimTextureHandle (  "ItemEnchantWnd.EnchantProgressAnim"  );
		BackPattern = GetTextureHandle (  "ItemEnchantWnd.BackPattern"  );
		InstructionTxt = GetTextBoxHandle (  "ItemEnchantWnd.InstructionTxt"  );
		EnchantScriptSlot = GetItemWindowHandle (  "ItemEnchantWnd.EnchantScriptSlot"  );
		EnchantItemSlot = GetItemWindowHandle (  "ItemEnchantWnd.EnchantItemSlot"  );
		CloverItemSlot = GetItemWindowHandle (  "ItemEnchantWnd.CloverItemSlot"  );
		EnchantedItemSlot = GetItemWindowHandle (  "ItemEnchantWnd.EnchantedItemSlot"  );
		EnchantBtn = GetButtonHandle (  "ItemEnchantWnd.EnchantBtn"  );
		ExitBtn = GetButtonHandle (  "ItemEnchantWnd.ExitBtn"  );
		Groupbox2 = GetTextureHandle (  "ItemEnchantWnd.Groupbox2"  );
		Groupbox1 = GetTextureHandle (  "ItemEnchantWnd.Groupbox1"  );
		EnchantScriptSlotBackTex = GetTextureHandle (  "ItemEnchantWnd.EnchantScriptSlotBackTex"  );
		EnchantItemSlotBackTex = GetTextureHandle (  "ItemEnchantWnd.EnchantItemSlotBackTex"  );
		CloverItemSlotBackTex = GetTextureHandle (  "ItemEnchantWnd.CloverItemSlotBackTex"  );
		EnchantedItemSlotBackTex = GetTextureHandle (  "ItemEnchantWnd.EnchantedItemSlotBackTex"  );
		DropHighlight_enchantitem = GetTextureHandle (  "ItemEnchantWnd.DropHighlight_enchantitem"  );
		DropHighlight_enchantscript = GetTextureHandle (  "ItemEnchantWnd.DropHighlight_enchantscript"  );
		DropHighlight_CloverItem = GetTextureHandle (  "ItemEnchantWnd.DropHighlight_CloverItem"  );
		
		m_hItemEnchantWndEnchantProgress=GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress");
	}
	Initialize();
	Load();
}

function Initialize()
{
	bEnchantbool = false;
	bEnchantedbool = false;
	bIsShopping = false;
	
	//~ Me = GetHandle( "ItemEnchantWnd" );
	//~ EnchantProgressAnim = AnimTextureHandle ( GetHandle( "ItemEnchantWnd.EnchantProgressAnim" ) );
	//~ BackPattern = TextureHandle ( GetHandle( "ItemEnchantWnd.BackPattern" ) );
	//~ InstructionTxt = TextBoxHandle ( GetHandle( "ItemEnchantWnd.InstructionTxt" ) );
	//~ EnchantScriptSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantScriptSlot" ) );
	//~ EnchantItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantItemSlot" ) );
	//~ CloverItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.CloverItemSlot" ) );
	//~ EnchantedItemSlot = ItemWindowHandle ( GetHandle( "ItemEnchantWnd.EnchantedItemSlot" ) );
	//~ EnchantBtn = ButtonHandle ( GetHandle( "ItemEnchantWnd.EnchantBtn" ) );
	//~ ExitBtn = ButtonHandle ( GetHandle( "ItemEnchantWnd.ExitBtn" ) );
	//~ Groupbox2 = TextureHandle ( GetHandle( "ItemEnchantWnd.Groupbox2" ) );
	//~ Groupbox1 = TextureHandle ( GetHandle( "ItemEnchantWnd.Groupbox1" ) );
	//~ EnchantScriptSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantScriptSlotBackTex" ) );
	//~ EnchantItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantItemSlotBackTex" ) );
	//~ CloverItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.CloverItemSlotBackTex" ) );
	//~ EnchantedItemSlotBackTex = TextureHandle ( GetHandle( "ItemEnchantWnd.EnchantedItemSlotBackTex" ) );
	//~ DropHighlight_enchantitem = TextureHandle ( GetHandle( "ItemEnchantWnd.DropHighlight_enchantitem" ) );
	//~ DropHighlight_enchantscript = TextureHandle ( GetHandle( "ItemEnchantWnd.DropHighlight_enchantscript" ) );
}

function OnRegisterEvent()
{
	RegisterEvent( EV_EnchantShow );
	RegisterEvent( EV_EnchantHide );
	RegisterEvent( EV_EnchantItemList );
	RegisterEvent( EV_EnchantResult );
	RegisterEvent( EV_EnchantPutTargetItemResult );
	RegisterEvent( EV_EnchantPutSupportItemResult );
}

function Load()
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "EnchantBtn":
		OnEnchantBtnClick();
		EnchantBtn.DisableWindow();
		break;
	case "ExitBtn":
		if (!bEnchantedbool)
		{
			class'EnchantAPI'.static.RequestExCancelEnchantItem();
			ProcCancel();
		}
		else
		{
			Me.HideWindow();
		}
		break;
	}
	
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_EnchantShow)
	{
		if(!bIsShopping)
		{
			HandleEnchantShow(param);
		}
		else
		{
			class'EnchantAPI'.static.RequestExCancelEnchantItem();
		}
	}
	else if (Event_ID == EV_EnchantResult)
	{
		HandleEnchantResult(param);
	}
	else if ( Event_ID == EV_EnchantPutTargetItemResult)
	{
		HandlePutTargetItemResult(param);
		//~ debug ("EnchantLevel" @ mEnchantLevel);
	}
	else if ( Event_ID ==  EV_EnchantPutSupportItemResult )
	{
		//debug ("Support Item Received" @ param);
		HandletPutSupportItemResult(param);
	}
	
	 
}

function OnEnchantBtnClick()
{
	local Rect Item1Rect;
	local Rect Item2Rect;
	local Rect Item3Rect;
	local Rect ResultRect;
	
	DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
	EnchantProgressAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.Play();
	Playsound("ItemSound3.enchant_process");
	EnchantProgressAnim.ShowWindow();
	bEnchantbool = true;
	
	m_hItemEnchantWndEnchantProgress.Start();
		
	Item1Rect = EnchantScriptSlot.GetRect();
	Item2Rect = EnchantItemSlot.GetRect();
	Item3Rect = CloverItemSlot.GetRect();
	ResultRect = EnchantedItemSlot.GetRect();

	EnchantScriptSlot.Move( ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 1.5f );
	EnchantItemSlot.Move( ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 1.5f );
	CloverItemSlot.Move( ResultRect.nX - Item3Rect.nX, ResultRect.nY - (Item3Rect.nY), 1.5f );	

	CloverItemSlotBackTex.HideWindow();
	EnchantItemSlotBackTex.HideWindow();
	EnchantedItemSlotBackTex.HideWindow();
	CloverItemSlotBackTex.HideWindow();

	ExitBtn.SetNameText( GetSystemString(141) );
	EnchantBtn.SetNameText( GetSystemString(428) );
}

function ProcCancel()
{
	bEnchantbool = false;
	m_hItemEnchantWndEnchantProgress.Stop();
	EnchantProgressAnim.Stop();
}


function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	//~ local ItemID SupportID;
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	switch ( a_WindowHandle )
	{
		case EnchantProgressAnim:
			//~ EnchantProgressAnim.Stop();
			//~ EnchantProgressAnim.HideWindow();
			if (bEnchantbool)
			{
				bEnchantbool = false;
				class'EnchantAPI'.static.RequestEnchantItem(SelectItemInfo.ID, SupportID);
			}
			else
			{
			}
					
		break;
	}
	EnchantProgressAnim.HideWindow();
}


//~ function OnExitBtnClick()
//~ {
	//~ OnCancelClick();
//~ }

function HandleEnchantShow(string param)
{
	local ItemID cID;
	local ItemInfo cItemInfo;

	//branch - 서버에서 동시에 못열게 막은듯 하지만 남겨둔다.
	local WindowHandle m_WarehouseWnd;
	local WindowHandle m_DeliverWnd;

	m_WarehouseWnd = GetWindowHandle( "WarehouseWnd" );	//창고의 윈도우 핸들을 얻어온다.
	m_DeliverWnd = GetWindowHandle( "DeliverWnd" );

	if ( m_WarehouseWnd.IsShowWindow() || m_DeliverWnd.IsShowWindow() )			//창고 오픈시 활성화 안한다.
	{
		class'EnchantAPI'.static.RequestExCancelEnchantItem();
		ProcCancel();
	} 
	else
	{
	//end of branch
		ParseItemID(param, cID);
		ScrollCID = cID.ClassID;	
		class'UIDATA_ITEM'.static.GetItemInfo(cID, cItemInfo );
	
		bEnchantedbool = false;
	
		ResetUI();
		Me.ShowWindow();
		//~ EnchantBtn.ShowWindow();
		Me.SetFocus();
		ExitBtn.SetNameText( GetSystemString(646) );
		EnchantBtn.SetNameText( GetSystemString(428) );
		cItemInfo.ItemNum = IntToInt64(1);
		EnchantScriptSlot.SetItem( 0, cItemInfo );
		EnchantScriptSlot.AddItem( cItemInfo );
		//~ mEnchantScrollID = cItemInfo.Id;
		Playsound("ItemSound3.enchant_input");
		//~ DropHighlight_enchantitem.ShowWindow();
		// 인챈트 할 아이템을 올려놓으십시오.
		InstructionTxt.SetText(GetSystemMessage(2339));
		//~ BackPattern.ShowWindow();
		mEnchantLevel = 0;
		DropHighlight_CloverItem.HideWindow();
	//branch
	}
	//end of branch	
}

function ResetUI()
{
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
	EnchantProgressAnim.HideWindow();
	BackPattern.HideWindow();
	InstructionTxt.SetText( "" );

	EnchantedItemSlot.Clear();

	EnchantedItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 116, 90 );
	EnchantedItemSlot.SetWindowSize(34,34);
	EnchantedItemSlot.ClearAnchor();
	EnchantedItemSlot.ShowWindow();


	EnchantBtn.DisableWindow();
	
	EnchantItemSlot.SetAlpha(255,0);

	EnchantScriptSlot.Clear();

	EnchantScriptSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 78, 90 );
	EnchantScriptSlot.SetWindowSize(34,34);
	EnchantScriptSlot.ClearAnchor();
	EnchantScriptSlot.ShowWindow();

	EnchantItemSlot.Clear();	

	EnchantItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 157, 90 );
	EnchantItemSlot.SetWindowSize(34,34);
	EnchantItemSlot.ClearAnchor();
	EnchantItemSlot.ShowWindow();

	CloverItemSlot.Clear();

	EnchantScriptSlotBackTex.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 77, 90 );
	EnchantScriptSlotBackTex.ClearAnchor();
	EnchantScriptSlotBackTex.ShowWindow();
	
	EnchantItemSlotBackTex.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 156, 90 );
	EnchantItemSlotBackTex.ClearAnchor();
	EnchantItemSlotBackTex.ShowWindow();
	
	CloverItemSlot.Clear();
	
	CloverItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 116, 100);
	CloverItemSlot.SetWindowSize(34,34);
	CloverItemSlot.ClearAnchor();

	CloverItemSlotBackTex.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 115, 100 );
	CloverItemSlotBackTex.ClearAnchor();
	CloverItemSlotBackTex.ShowWindow();

	EnchantedItemSlotBackTex.HideWindow();
	CloverItemSlotBackTex.HideWindow();
	CloverITemSlot.HideWindow();
	
	m_hItemEnchantWndEnchantProgress.SetProgressTime(1500);
	m_hItemEnchantWndEnchantProgress.SetPos(0);
		
	m_hItemEnchantWndEnchantProgress.Reset();
}      

function EnableCloverSlot()
{
	EnchantScriptSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 78, 60 );
	EnchantScriptSlot.SetWindowSize(34,34);
	EnchantScriptSlot.ClearAnchor();
	EnchantScriptSlot.ShowWindow();
	EnchantItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 157, 60 );
	EnchantItemSlot.SetWindowSize(34,34);
	EnchantItemSlot.ClearAnchor();
	EnchantItemSlot.ShowWindow();
	CloverItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 116, 100);
	CloverItemSlot.ClearAnchor();
	CloverItemSlot.ShowWindow();
	CloverItemSlotBackTex.ShowWindow();
	DropHighlight_CloverItem.ShowWindow();
	InstructionTxt.SetText(GetSystemMessage(2940));
}

/* 강화 주문서 슬롯은 안보이게 하고 (주문서 + 무기, 방어구) 두가지만 나오는 형태 */
function DisableCloverSlot()
{
	EnchantScriptSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 78, 90 );
	EnchantScriptSlot.SetWindowSize(34,34);
	EnchantScriptSlot.ClearAnchor();
	EnchantScriptSlot.ShowWindow();

	EnchantItemSlot.SetAnchor( "ItemEnchantWnd", "TopLeft", "TopLeft", 157, 90 );
	EnchantItemSlot.SetWindowSize(34,34);
	EnchantItemSlot.ClearAnchor();
	EnchantItemSlot.ShowWindow();
	
	CloverItemSlot.Clear();
	CloverItemSlot.HideWindow();
	CloverItemSlotBackTex.HideWindow();
	DropHighlight_CloverItem.HideWindow();
	InstructionTxt.SetText(GetSystemMessage(2339));
}



function OnHide()
{
	bEnchantbool = false;

}


function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local int XX;
	local int YY;
	switch (a_WindowID)
	{
		case "EnchantItemSlot":
			SelectItemInfo = a_ItemInfo;
			mEnchantLevel = a_ItemInfo.Enchanted;
			mEnchantItemType = a_ItemInfo.SlotBitType;
			//Debug ("EnchantItemID" @  a_ItemInfo.ID.ServerID @ a_ItemInfo.ID.ClassID);
			class'EnchantAPI'.static.RequestExTryToPutEnchantTargetItem( a_ItemInfo.ID );
		break;
		case "CloverItemSlot":
			XX = SelectItemInfo.ID.ServerID;
			YY = a_ItemInfo.ID.ServerID;
			//debug ("Clover Item Slot Received" @ XX @ SelectItemInfo.ID.ClassID @ YY @ a_ItemInfo.ID.ClassID);
			class'EnchantAPI'.static.RequestExTryToPutEnchantSupportItem( a_ItemInfo.ID,  SelectItemInfo.ID );
			SelectHelperItemInfo = a_ItemInfo;
			SupportID = a_ItemInfo.ID;
		break;

	}
}


function HandlePutTargetItemResult(string param)
{
	local int ResultID;
	ParseInt(Param, "Result", ResultID);
	
	debug ("EnchantLevel" @ mEnchantLevel);
	if (ResultID==0)
	{
		class'EnchantAPI'.static.RequestExCancelEnchantItem();
	}
	else
	{
		
		EnchantItemSlot.SetItem( 0, SelectItemInfo );
		EnchantItemSlot.AddItem( SelectItemInfo );
		InstructionTxt.SetText(GetSystemMessage(2341));
		//~ DropHighlight_enchantitem.HideWindow();
		DropHighlight_enchantitem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		//~ DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		// debug("====> " @ mEnchantItemType);
		// debug("ScrollCID ==>" @ ScrollCID);
		if (!CheckScrollType(ScrollCID))
		{
			// debug("mEnchantItemType =========> " @ mEnchantItemType);
		
			if (mEnchantItemType == 32768)
			{

				// debug("GetSystemMessage(3149) ==>" @ GetSystemMessage(3149));

				if (mEnchantLevel > 3 && mEnchantLevel <= 9)
				{
					EnableCloverSlot();
					// 상하의 일체형 방어구에는 4~9 인첸트를 할수 있다는 맨트
					InstructionTxt.SetText(GetSystemMessage(3149));
				}
				else
				{
					DisableCloverSlot();
				}
			}
			else
			{
				if (mEnchantLevel > 2 && mEnchantLevel <= 9)
				{
					EnableCloverSlot();
				}
				else
				{
					DisableCloverSlot();
				}
			}
		}

	
		EnchantBtn.EnableWindow();
		
		
		EnchantScriptSlotBackTex.HideWindow();
		EnchantItemSlotBackTex.HideWindow();
		//~ CloverItemSlotBackTex.HideWindow();
		//~ EnchantedItemSlotBackTex.HideWindow();
	}
}

function bool CheckScrollType(int ID)
{
	switch (ID)
	{
		case 6569:
		case 6570:
		case 6571:
		case 6572:
		case 6573:
		case 6574:
		case 6575:
		case 6576:
		case 6577:
		case 6578:
		// 월드컵 이벤트에 사용되는 축복받은 강화 주문서 사용 시에도 처리 - gorillazin 10.06.14.
		case 17255:
		case 17256:
		case 17257:
		case 17258:
		case 17259:
		case 17260:
		case 17261:
		case 17262:
		case 17263:
		case 17264:
		// 7주년 기념 티셔츠 강화 주문서 사용 시에도 처리 - gorillazin 10.07.27.
		case 21581:
		case 21582:
		// 2010 추석 프로모션 복구용 티셔츠 - gorillazin 10.09.10.
		case 21707:
		// 2011 초롱 이벤트 관련 추가 주문서 - enyheid 11.01.06
		case 22221:
		case 22222:
		case 22223:
		case 22224:
		case 22225:
		case 22226:
		case 22227:
		case 22228:
		case 22229:
		case 22230:
			return true;
			break;
		default:
			return false;
			break;
	}
}

function HandletPutSupportItemResult(string param)
{
	local int ResultID;
	ParseInt(Param, "Result", ResultID);
	
	if (ResultID==0)
	{
	}
	else
	{
		CloverITemSlot.SetItem( 0, SelectHelperItemInfo );
		CloverITemSlot.AddItem( SelectHelperItemInfo );
		//~ DropHighlight_enchantitem.HideWindow();
		
		EnchantScriptSlotBackTex.HideWindow();
		EnchantItemSlotBackTex.HideWindow();
		CloverItemSlotBackTex.HideWindow();
	}
	
}

function HandleEnchantResult(string param)
{
	local int IntResult;
	local ItemID ItemID;
	local int64 Count;
	local int CountInt;
	local ItemInfo ResultItem;
	local string EndTxt;
	EnchantProgressAnim.HideWindow();
	//결과에 상관없이 무조건 Hide
	//~ Me.HideWindow();
	//~ Clear();
	//debug (param);
	ParseInt(Param, "Result", IntResult );
	ParseItemID(param, ItemID );
	Parseint64(param, "Count", Count );
	ParseInt(param, "Count", CountInt );
	//debug ("count:" @ string(int(Count)));
	class'UIDATA_ITEM'.static.GetItemInfo(ItemID, ResultItem );
	
	CloverItemSlotBackTex.HideWindow();
	EnchantItemSlotBackTex.HideWindow();
	EnchantedItemSlotBackTex.HideWindow();
	CloverItemSlotBackTex.HideWindow();

	switch (IntResult)
	{
		case 0:
			bEnchantedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
			EnchantProgressAnim.SetLoopCount( 1 );
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			Playsound("ItemSound3.enchant_success");
			EnchantProgressAnim.ShowWindow();
		
			BackPattern.SetAlpha(0, 0);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2);
		
			SelectItemInfo.Enchanted = SelectItemInfo.Enchanted+1;
		
			EnchantedItemSlot.SetItem( 0, SelectItemInfo );
			EnchantedItemSlot.AddItem( SelectItemInfo );
			EndTxt = MakeFullSystemMsg(GetSystemMessage(2342), "+"$string(SelectItemInfo.Enchanted) @ SelectItemInfo.Name, "");
			InstructionTxt.SetText(EndTxt);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255,2);
			CloverItemSlot.HideWindow();
			//~ EnchantItemSlot.SetAlpha(0, 2);
			EnchantItemSlot.HideWindow();
			EnchantScriptSlot.HideWindow();
			CloverItemSlot.HideWindow();
			break;
		
		case 1:
			bEnchantedbool = true; 
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount( C_ANIMLOOPCOUNT );
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			Playsound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
		
			BackPattern.SetAlpha(0, 0);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2);
		
			//~ ResultItem.
			ResultItem.ItemNum = Count;
			//debug ("Count2" @ string(int(Count)));
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.SetItem( 0, ResultItem );
			EnchantedItemSlot.AddItem( ResultItem );
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255,2);
			EndTxt = MakeFullSystemMsg(GetSystemMessage(2343), ResultItem.Name, String(CountInt));
			InstructionTxt.SetText(EndTxt);
		
			CloverItemSlot.HideWindow();
			EnchantItemSlot.HideWindow();
			//~ EnchantItemSlot.SetAlpha(0, 3);
			//~ EnchantItemSlot.HideWindow();
			EnchantScriptSlot.HideWindow();
			CloverItemSlot.HideWindow();
			break;
		case 2:
			EnchantProgressAnim.HideWindow();
			if (!bEnchantedbool)
				Me.HideWindow();
			break;
		case 3:
			bEnchantedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount( C_ANIMLOOPCOUNT );
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			Playsound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
		
			BackPattern.SetAlpha(0, 0);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2);
		
			//~ ResultItem.
			ResultItem.ItemNum = IntToInt64(1);
			EnchantedItemSlot.SetAlpha(0);
			SelectItemInfo.Enchanted = 0;
			EnchantedItemSlot.SetItem( 0, SelectItemInfo );
			EnchantedItemSlot.AddItem( SelectItemInfo );
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255,2);
			EndTxt = MakeFullSystemMsg(GetSystemMessage(2343), SelectItemInfo.Name, "1");
			InstructionTxt.SetText(EndTxt);
		
			CloverItemSlot.HideWindow();
			EnchantItemSlot.HideWindow();
			//~ EnchantItemSlot.SetAlpha(0, 3);
			//~ EnchantItemSlot.HideWindow();
			EnchantScriptSlot.HideWindow();
			CloverItemSlot.HideWindow();
			break;
			
		case 4:
			bEnchantedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount( C_ANIMLOOPCOUNT );
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			Playsound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
		
			BackPattern.SetAlpha(0, 0);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2);
		
			//~ ResultItem.
			ResultItem.ItemNum = IntToInt64(0);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.SetItem( 0, ResultItem );
			EnchantedItemSlot.AddItem( ResultItem );
			//~ EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255,2);
			EndTxt = MakeFullSystemMsg(GetSystemMessage(64), SelectItemInfo.Name,"");
			InstructionTxt.SetText(EndTxt);
		
			CloverItemSlot.HideWindow();
			EnchantItemSlot.HideWindow();
			//~ EnchantItemSlot.SetAlpha(0, 3);
			//~ EnchantItemSlot.HideWindow();
			EnchantScriptSlot.HideWindow();
			break;
			
		//branch
		case 5:			// case IER_ANCIENT_BLESSED_FAIL -> ItemEnchantResult 상수가 추가되어 번호가 변경되진 않는지 확인.
			bEnchantedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount( C_ANIMLOOPCOUNT );
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			Playsound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
		
			BackPattern.SetAlpha(0, 0);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2);
		
			//~ ResultItem.
			ResultItem.ItemNum = IntToInt64(1);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.SetItem( 0, SelectItemInfo );
			EnchantedItemSlot.AddItem( SelectItemInfo );
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255,2);
			EndTxt = GetSystemMessage(6004);
			InstructionTxt.SetText(EndTxt);
		
			CloverItemSlot.HideWindow();
			EnchantItemSlot.HideWindow();
			//~ EnchantItemSlot.SetAlpha(0, 3);
			//~ EnchantItemSlot.HideWindow();
			EnchantScriptSlot.HideWindow();
			CloverItemSlot.HideWindow();
			break;
		//end of branch
		
	}

	ExitBtn.SetNameText( GetSystemString(646) );
	EnchantBtn.DisableWindow();
	ExitBtn.EnableWindow();
}

function SetIsShopping(bool isShopping)
{
	bIsShopping = isShopping;

	debug("=============isShopping : " $ bIsShopping);
}
defaultproperties
{
}
