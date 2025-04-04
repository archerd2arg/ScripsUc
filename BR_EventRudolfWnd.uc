class BR_EventRudolfWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";

const DIALOG_PETNAME		= 1111;				// 펫이름적기
const DIALOG_GIVEITEMTOPET	= 2222;				// 인벤에서 펫인벤으로 아이템 옮기기

const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
//~ const PET_EVOLUTIONIZED_ID = 16025;
const PET_EVOLUTIONIZED_ID = 1210114602;

var int			m_PetID;
var bool		m_bShowNameBtn;
var string		m_LastInputPetName;
var int 		EvolutionizedAction;

var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
var TextBoxHandle txtLvName;
var ItemWindowHandle PetActionWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_PetWndShow );
	RegisterEvent( EV_PetWndShowNameBtn );
	RegisterEvent( EV_PetWndRegPetNameFailed );
	RegisterEvent( EV_PetSummonedStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionPetListStart );
	RegisterEvent( EV_ActionPetList );
	
	RegisterEvent( EV_PetInventoryItemStart );
	RegisterEvent( EV_PetInventoryItemList );
	RegisterEvent( EV_PetInventoryItemUpdate );
	
	RegisterEvent( EV_LanguageChanged );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
}

function InitHandle()
{
	Me = GetHandle( "BR_EventRudolfWnd" );
	btnName = ButtonHandle ( GetHandle( "BR_EventRudolfWnd.btnName" ) );
	texPetHP = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetHP" ) );
	texPetMP = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetMP" ) );
	texPetFatigue = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetFatigue" ) );
	txtLvName = TextBoxHandle ( GetHandle( "BR_EventRudolfWnd.txtLvName" ) );
	PetActionWnd = ItemWindowHandle ( GetHandle( "BR_EventRudolfWnd.PetWnd_Action.PetActionWnd" ) );
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "BR_EventRudolfWnd" );
	btnName = GetButtonHandle ( "BR_EventRudolfWnd.btnName" );
	texPetHP = GetStatusBarHandle( "BR_EventRudolfWnd.texPetHP" );
	texPetMP = GetStatusBarHandle( "BR_EventRudolfWnd.texPetMP" );
	texPetFatigue = GetStatusBarHandle( "BR_EventRudolfWnd.texPetFatigue" );
	txtLvName = GetTextBoxHandle( "BR_EventRudolfWnd.txtLvName" );
	PetActionWnd = GetItemWindowHandle ( "BR_EventRudolfWnd.PetWnd_Action.PetActionWnd" );
}

function OnShow()
{
	class'ActionAPI'.static.RequestPetActionList();
}

function HandleLanguageChanged()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		//~ debug("펫정보 업데이트 이벤트로 받음");
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetSummonedStatusClose();
	}
	else if (Event_ID == EV_PetWndShow)
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	}
	else if (Event_ID == EV_PetWndShowNameBtn)
	{
		HandlePetShowNameBtn(param);
	}
	else if (Event_ID == EV_PetWndRegPetNameFailed)
	{
		HandleRegPetName(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if (Event_ID == EV_ActionPetListStart)
	{
		//~ debug("액션항목을 지운다.:");
		HandleActionPetListStart();
	}
	else if (Event_ID == EV_ActionPetList)
	{
		HandleActionPetList(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		class'ActionAPI'.static.RequestPetActionList();
	}

}

function HandleDialogOK()
{
	local int ID;
	local ItemID sID;
	local INT64 Number;
	
	if( DialogIsMine() )
	{
		ID = DialogGetID();
		sID = DialogGetReservedItemID();
		Number = StringToInt64(DialogGetString());
		
		if( id == DIALOG_PETNAME )
		{
			m_LastInputPetName = DialogGetString();
			RequestChangePetName(m_LastInputPetName);	//등록 결과가 EV_PetWndRegNameXXX로 날라온다.
		}
		else if( id == DIALOG_GIVEITEMTOPET )
		{
			class'PetAPI'.static.RequestGiveItemToPet(sID, Number);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnName":
		OnNameClick();
		break;
	}
}

function OnNameClick()
{
	DialogSetID(DIALOG_PETNAME);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
}

//액션의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetActionWnd" && index>-1)
	{
		if (PetActionWnd.GetItem(index, infItem))
			DoAction(infItem.ID);
	}
}

//초기화
function Clear()
{
	txtLvName.SetText("");
		
	texPetHP.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
	texPetMP.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
	texPetFatigue.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
}
function ClearActionWnd()
{
	PetActionWnd.Clear();
}

//펫이름 등록 결과 처리
function HandleRegPetName(string param)
{
	local int MsgNo;
	
	ParseInt(param, "ErrMsgNo", MsgNo);
		
	AddSystemMessage(MsgNo);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
	
	//펫이름이 제한글자수를 초과하였을 때는, 전에 입력한 이름을 다시 출력한다.
	if (MsgNo==80)
	{
		DialogSetString(m_LastInputPetName);
	}
}

//펫이름 버튼 처리
function HandlePetShowNameBtn(string param)
{
	local int ShowFlag;
	ParseInt(param, "Show", ShowFlag);
	
	if (ShowFlag==1)
	{
		SetVisibleNameBtn(true);
	}
	else
	{
		SetVisibleNameBtn(false);
	}
}

function SetVisibleNameBtn(bool bShow)
{
	if (bShow)
	{
		btnName.ShowWindow();
	}
	else
	{
		btnName.HideWindow();
	}
	m_bShowNameBtn = bShow;
}

//종료처리
function HandlePetSummonedStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//펫Info패킷 처리
function HandlePetInfoUpdate()
{
	local string	Name;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Fatigue;
	local int		MaxFatigue;
	local int		SP;
	local int		Level;
	//local float		fExpRate;
	//local float		fTmp;
	local int 		nEvolutionID;
	local int		iTemp;
	
	local PetInfo	info;
	
	if( !Me.IsShowWindow() )
		return;
	
	if (GetPetInfo(info))
	{
		//Check Is Pet?
		if( info.bIsPetOrSummoned )
			return;
			
		m_PetID = info.nID;
		Name = info.Name;
		SP = info.nSP;
		Level = info.nLevel;
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		Fatigue = info.nFatigue;
		MaxFatigue = info.nMaxFatigue;
		nEvolutionID = info.nEvolutionID;
	}
	
	if (Level==1) {
		txtLvName.SetText( "[" $ GetSystemString(5051) $ "] " $ Name);
	} else if (Level==2) {
		txtLvName.SetText( "[" $ GetSystemString(5052) $ "] " $ Name);
	} else if (Level==3) {
		txtLvName.SetText( "[" $ GetSystemString(5053) $ "] " $ Name);
	} else if (Level==4) {
		txtLvName.SetText( "[" $ GetSystemString(5054) $ "] " $ Name);
	} else if (Level==5) {
		txtLvName.SetText( "[" $ GetSystemString(5055) $ "] " $ Name);
	} else if (Level==6) {
		txtLvName.SetText( "[" $ GetSystemString(5056) $ "] " $ Name);
	} else if (Level==7) {
		txtLvName.SetText( "[" $ GetSystemString(5057) $ "] " $ Name);
	}		
	
	iTemp = (SP/10000)%100;
	texPetHP.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	iTemp = (SP/100)%100;
	texPetMP.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	iTemp = SP%100;
	texPetFatigue.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	
	//진화형 펫에 따른 특별 액션 처리
	EvolutionizedAction = nEvolutionID;
	//~ debug("진화아이디:"@ EvolutionizedAction @ nEvolutionID);
	
}

//펫창을 표시
function HandlePetShow()
{
	//branch
	local UserInfo	a_UserInfo;
	local PetInfo	info;
	if (GetPetInfo(info)) {
		if (GetUserInfo( info.nID, a_UserInfo )) {
			if (a_UserInfo.nClassID != 1538) {
				return;
			}
		}
	}
	//end of branch
	
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	//~ debug("펫정보 이벤트를 임의로 실행함");
	HandlePetInfoUpdate();
	
	//이름버튼
	SetVisibleNameBtn(m_bShowNameBtn);
}

///////////////////////////////////////////////////////////////////////////////////////
// 액션 아이템 처리
///////////////////////////////////////////////////////////////////////////////////////
function HandleActionPetListStart()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
}

function HandleActionPetList(string param)
{
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	local int intClassID;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "ClassID", intClassID);
	
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//~ ClearActionWnd();
	
	//ItemWnd에 추가
	Type = EActionCategory(Tmp);

	//펫의 레벨별 액션 추가 기능 
	if (Type==ACTION_PET)
	{
		if (intClassID == 16 || intClassID == 18)
		{
			//~ debug("걸러짐2");
		}
		else
		{
			PetActionWnd.AddItem(infItem);
		}
	}
}
defaultproperties
{
}
