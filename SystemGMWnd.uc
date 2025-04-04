class SystemGMWnd extends UICommonAPI;

var WindowHandle ShowModWnd;//окно с модами
var WindowHandle m_hOptionWnd;
var WindowHandle m_hUserPetitionWnd;
var WindowHandle m_hNewUserPetitionWnd;
var WindowHandle PostBoxWnd;
var TextBoxHandle m_hTbBBS;
var TextBoxHandle m_hTbMacro;
var ButtonHandle btnUi;
var HtmlHandle	m_hBoardWndHtmlViewer;
var ItemInfo 		SelectItemInfo;		// 선택한 아이템
var int mEnchantLevel;
var int 			mEnchantItemType;
var ItemInfo		SelectHelperItemInfo;
var ItemID	 		SupportID;
var int 			ScrollCID;			// 스크롤의 종류를 저장한다. 
var int 			mEnchantScrollID;


var WindowHandle ProductInventoryWnd;

var int IsPeaceZone;		//현재 지역 PeaceZone인가

const DIALOGID_Gohome = 0;

function OnRegisterEvent()
{
	RegisterEvent( EV_LanguageChanged );
	RegisterEvent( EV_SetRadarZoneCode );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hBoardWndHtmlViewer=GetHtmlHandle("SystemGMWnd.HtmlViewer");
		ShowModWnd=GetWindowHandle("xRen");//окно с модами
		m_hOptionWnd=GetHandle("OptionWnd");
		m_hUserPetitionWnd=GetHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetHandle("NewUserPetitionWnd");
		m_hTbBBS=TextBoxHandle(GetHandle("SystemGMWnd.txtBBS"));
		m_hTbMacro=TextBoxHandle(GetHandle("SystemGMWnd.txtMacro"));
		PostBoxWnd=GetHandle("PostBoxWnd");
		ProductInventoryWnd = GetHandle("ProductInventoryWnd");
	}
	else
	{
	ShowModWnd=GetWindowHandle("xRen");//окно с модами
		m_hOptionWnd=GetWindowHandle("OptionWnd");
		m_hUserPetitionWnd=GetWindowHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetWindowHandle("NewUserPetitionWnd");
		m_hTbBBS=GetTextBoxHandle("SystemGMWnd.txtBBS");
		m_hTbMacro=GetTextBoxHandle("SystemGMWnd.txtMacro");
		PostBoxWnd=GetWindowHandle("PostBoxWnd");
		ProductInventoryWnd = GetWindowHandle("ProductInventoryWnd");
	}

	SetMenuString();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnUi" :
		HandleReloadUi();
		break;
	case "btnPost":
		HandleShowPostBoxWnd();
		break;
	case "btnBBS":
		HandleShowBoardWnd();
		break;
	case "btnMacro":
		HandleShowMacroListWnd();
		break;
	case "btnHelpHtml":
		HandleShowHelpHtmlWnd();
		break;
	case "btnPetition":
		HandleShowPetitionBegin();
		break;
	case "btnOption":
		HandleShowOptionWnd();
		break;
	//홈페이지 링크(10.1.18 문선준 추가)
	case "btnHomepage":
		linkHomePage();
		break;
	//
	case "btnRestart":
		ExecuteEvent(EV_OpenDialogRestart);
		break;
	case "btnQuit":
		ExecuteEvent(EV_OpenDialogQuit);
		break;
	case "ShowMod"://Откроем окно с модами
        ShowModOpen();
		break;
	}
}

//Откроем окно с модами
function ShowModOpen(){

if (ShowModWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		ShowModWnd.HideWindow();
		AddSystemMessageString("HideWindow"); //Текст в чат что скрипт сработал
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		ShowModWnd.ShowWindow();
		//ShowModWnd.SetFocus();
		AddSystemMessageString("ShowWindow"); //Текст в чат что скрипт сработал
	}

}

function OnEvent(int Event_ID, String param)
{
	local int zonetype;
	
	if( Event_ID == EV_LanguageChanged )
	{
		SetMenuString();
	}
	else if ( Event_ID == EV_SetRadarZoneCode )
	{
		ParseInt( param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_DialogCancel )
	{
		
	}
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


//HandleReloadUi
function HandleReloadUi()
{
ExecuteCommand("///reloadui");
}

//상품 인벤토리 열기
function HandleShowProductInventory()
{
	if( ProductInventoryWnd.IsShowWindow() )
	{
		ProductInventoryWnd.HideWindow();
	}
	else
	{
		if( ! class'UIAPI_WINDOW'.static.IsShowWindow("ShopWnd") )	
		{
			ProductInventoryWnd.ShowWindow();
			ProductInventoryWnd.SetFocus();
		}
	}
}


//홈페이지 링크(10.1.18 문선준 추가)
function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}

function linkHomePage()
{
	DialogSetID( DIALOGID_Gohome );
	DialogShow( DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 3208 ) );
}




function HandleShowPostBoxWnd()
{
	if( PostBoxWnd.isShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	else
	{
		RequestRequestReceivedPostList();
		if (IsPeaceZone == 0)
			AddSystemMessage(3066);
	}

}


function HandleShowBoardWnd()
{
	local string strParam;
	ParamAdd(strParam, "Init", "1");
	ExecuteEvent(EV_ShowBBS, strParam);
}

function HandleShowHelpHtmlWnd()
{
	local  AgeWnd script1;	// 등급표시 스크립트 가져오기
	
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
	
	script1 = AgeWnd( GetScript("AgeWnd") );
	
	if(script1.bBlock == false)	script1.startAge();	//등급표시를 켜준다. 
}

function HandleShowMacroListWnd()
{
	ExecuteEvent(EV_MacroShowListWnd);
}

function HandleShowPetitionBegin()
{
	local bool useNewPetition;
	useNewPetition = GetUseNewPetitionBool();

	if(useNewPetition)
	{
		if(m_hNewUserPetitionWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hNewUserPetitionWnd.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowNewUserPetition();
		}
	}
	else
	{
		if (m_hUserPetitionWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hUserPetitionWnd.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			m_hUserPetitionWnd.ShowWindow();
			m_hUserPetitionWnd.SetFocus();
		}
	}
}

function HandleShowOptionWnd()
{
	if (m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
}

function SetMenuString()
{
	//단축키 붙여주기
	m_hTbBBS.SetText(GetSystemString(387) $ "(Alt+B)");
	m_hTbMacro.SetText(GetSystemString(711) $ "(Alt+R)");
}
defaultproperties
{
}
