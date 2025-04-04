class LobbyMenuWnd extends UICommonAPI;

const DLG_ID_DELETE=0;
const DLG_ID_RESTORE=1;

// 활력 시스템 개선 - gorillazin 10. 05. 12.
const	BLINK_TIMER_ID1	=	1314;
const 	BLINK_TIMER_DELAY1	=	500;	

const 	BLINK_ANIM_MIN_ALPHA	=	39;
const 	BLINK_ANIM_MAX_ALPHA	=	197;
const	BLINK_ANIM_SPEED		=	0.40f;

const	VITALITY_POINT_MAX				=	20000;
const	VITALITY_POINT_BOUNDARY_LEVEL4	=	17000;
const	VITALITY_POINT_BOUNDARY_LEVEL3	=	13000;
const	VITALITY_POINT_BOUNDARY_LEVEL2	=	2000;
const	VITALITY_POINT_BOUNDARY_LEVEL1	=	240;

var WindowHandle	m_hBtnCreateCharacter;
var WindowHandle	m_hBtnDeleteCharacter;
var WindowHandle	m_hBtnStartGame;

var CharacterPasswordHelpHtmlWnd   CharacterPasswordHelpHtmlWndScript;
var CharacterPasswordWnd           CharacterPasswordWndScript;

var ComboBoxHandle	m_hCbCharacterName;

var TextBoxHandle	m_hTbLevel;
var TextBoxHandle	m_hTbClassName;
var TextBoxHandle	m_hTbSP;
var TextBoxHandle	m_hTbPropensity;
var TextBoxHandle 	m_sbtxtPropensity;

var StatusBarHandle m_hSbHP;
var StatusBarHandle m_hSbMP;
var StatusBarHandle m_hSbEXP;

// 활력 시스템 개선 - gorillazin 10. 05. 10.
var BarHandle		m_hVitalityPointBar;
var TextureHandle	m_hVitalityLevelTexture;
var WindowHandle	m_hVitalityPointTooltip;
var TextureHandle	m_hVitalityBlinkAnimTexture_Left;
var TextureHandle	m_hVitalityBlinkAnimTexture_Right;
var TextureHandle	m_hVitalityBlinkAnimTexture_Center;
var bool			m_bIsBlink;

function OnRegisterEvent()
{
	RegisterEvent(EV_LobbyMenuButtonEnable);
	RegisterEvent(EV_LobbyAddCharacterName);
	RegisterEvent(EV_LobbyCharacterSelect);
	RegisterEvent(EV_LobbyClearCharacterName);
	RegisterEvent(EV_LobbyShowDialog);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DIalogCancel);
	RegisterEvent(EV_LobbyGetSelectedCharacterIndex);
	RegisterEvent(EV_LobbyStartButtonClick);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hBtnCreateCharacter=(GetHandle("LobbyMenuWnd.LobbyCreateMenuWnd.btnCreateCharacter"));
		m_hBtnDeleteCharacter=(GetHandle("LobbyMenuWnd.LobbyCreateMenuWnd.btnDeleteCharacter"));
		m_hBtnStartGame=(GetHandle("LobbyMenuWnd.LobbyStartWnd.btnStartGame"));	
		
		m_hCbCharacterName=ComboBoxHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.cbCharacterName"));
		m_hTbLevel=TextBoxHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarLevel"));
		m_hTbClassName=TextBoxHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarClassName"));
		m_hTbSP=TextBoxHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarSP"));
		m_hTbPropensity=TextBoxHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarPropensity"));

		m_hSbHP=StatusBarHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbHPBar"));
		m_hSbMP=StatusBarHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbMPBar"));
		m_hSbEXP=StatusBarHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbEXPBar"));

		// 활력 시스템 개선 - gorillazin 10. 05. 10.
		m_hVitalityPointBar = BarHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityPointBar"));
		m_hVitalityLevelTexture = TextureHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityLevelTex"));
		m_hVitalityPointTooltip = GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityPointTooltip");
		m_hVitalityBlinkAnimTexture_Left = TextureHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Left"));
		m_hVitalityBlinkAnimTexture_Right = TextureHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Right"));
		m_hVitalityBlinkAnimTexture_Center = TextureHandle(GetHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Center"));
	}
	else
	{
		m_hBtnCreateCharacter=GetWindowHandle("LobbyMenuWnd.LobbyCreateMenuWnd.btnCreateCharacter");
		m_hBtnDeleteCharacter=GetWindowHandle("LobbyMenuWnd.LobbyCreateMenuWnd.btnDeleteCharacter");
		m_hBtnStartGame=GetWindowHandle("LobbyMenuWnd.LobbyStartWnd.btnStartGame");	
		
		m_hCbCharacterName=GetComboBoxHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.cbCharacterName");
		m_hTbLevel=GetTextboxHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarLevel");
		m_hTbClassName=GetTextboxHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarClassName");
		m_hTbSP=GetTextBoxHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarSP");
		m_hTbPropensity=GetTextBoxHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.txtVarPropensity");

		m_hSbHP=GetStatusBarHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbHPBar");
		m_hSbMP=GetStatusBarHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbMPBar");
		m_hSbEXP=GetStatusBarHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.sbEXPBar");

		// 활력 시스템 개선 - gorillazin 10. 05. 10.
		m_hVitalityPointBar = GetBarHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityPointBar");
		m_hVitalityLevelTexture = GetTextureHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityLevelTex");
		m_hVitalityPointTooltip = GetWindowHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityPointTooltip");
		m_hVitalityBlinkAnimTexture_Left = GetTextureHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Left");
		m_hVitalityBlinkAnimTexture_Right = GetTextureHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Right");
		m_hVitalityBlinkAnimTexture_Center = GetTextureHandle("LobbyMenuWnd.LobbyCharacterSelectWnd.VitalityAnimTex_Center");
	}
	
	m_hBtnDeleteCharacter.DisableWindow();
	m_hBtnStartGame.DisableWindow();
	//~ m_sbtxtPropensity = TextBoxHandle(GetHandle("LobbyCharacterSelectWnd.sbtxtPropensity"));
	//~ m_sbtxtPropensity.setText(GetSystemMessage(1743));

	// 활력 시스템 개선 - gorillazin 10. 05. 12.
	StopBlinkAnimation();	

	CharacterPasswordHelpHtmlWndScript = CharacterPasswordHelpHtmlWnd( GetScript("CharacterPasswordHelpHtmlWnd") );
	CharacterPasswordWndScript = CharacterPasswordWnd( GetScript("CharacterPasswordWnd") );
}

function OnShow()
{
	m_hBtnStartGame.SetFocus();
	hidePasswordWndAll();
}

function OnTimer(int TimerID)
{
	if(TimerID == BLINK_TIMER_ID1)
	{
		PlayBlinkAnimation();
	}
}

function OnClickButton(string strID)
{
	local WindowHandle Handle1;

	if(CREATE_ON_DEMAND==0)	
		Handle1 = GetHandle("DialogBox");
	else
		Handle1 = GetWindowHandle("DialogBox");
	Handle1.HideWindow();
	switch(strID)
	{
	case "btnCreateCharacter" :
		hidePasswordWndAll();
		StopBlinkAnimation();
		CreateNewCharacter();
		break;
	case "btnDeleteCharacter" :
		hidePasswordWndAll();
		OnClickDeleteCharacter();
		break;
	case "btnCancel" :
		StopBlinkAnimation();
		GotoLogin();
		break;
	case "btnStartGame" :
		hidePasswordWndAll();
		OnClickStartButton();
		break;
	}
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey Key)
{
	local string MainKey;
	MainKey = class'InputAPI'.static.GetKeyString(Key);
		//~ debug (MainKey);
	if (MainKey == "ENTER")
	{
		
		StartGame(m_hCbCharacterName.GetSelectedNum());
	}
}

function OnClickStartButton()
{
	StartGame(m_hCbCharacterName.GetSelectedNum());
	StopBlinkAnimation();
}

function OnClickDeleteCharacter()
{
	local int index;
	index=m_hCbCharacterName.GetSelectedNum();

	// 삭제예정이거나 제재 대상이면 패스
	if(IsScheduledToDeleteCharacter(index) || IsDisciplineCharacter(index))
		return;

	ShowDeleteDialog(index);
}

function ShowDeleteDialog(int index)
{
	local string Msg;
	DialogSetID( DLG_ID_DELETE );
	DialogSetReservedInt(index);
	Msg=MakeFullSystemMsg(GetSystemMessage( 78 ), m_hCbCharacterName.GetString(index));
	DialogShow(DIALOG_Modal, DIALOG_OKCancel, Msg);
}


function OnEvent(int Event_ID, string a_param)
{
	switch(Event_ID)
	{
	case EV_LobbyMenuButtonEnable :
		HandleMenuButtonEnable(a_Param);
		// debug(":::::HandleMenuButtonEnable : " @ a_Param);
		break;
	case EV_LobbyAddCharacterName :
		
		HandleAddCharacterName(a_Param);
		
		break;
	case EV_LobbyCharacterSelect :
		HandleCharacterSelect(a_Param);
		break;
	case EV_LobbyClearCharacterName :
		ResetCharacterSelectWindow();
		m_hCbCharacterName.Clear();
		break;
	case EV_LobbyShowDialog :
		HandleShowDialog(a_param);
		break;
	case EV_DialogOK :
		HandleDialogResult(true);
		break;
	case EV_DialogCancel :
		HandleDialogResult(false);
		break;
	case EV_LobbyGetSelectedCharacterIndex :
		SetSelectedCharacter(m_hCbCharacterName.GetSelectedNum());
		break;
	case EV_LobbyStartButtonClick :
		OnClickStartButton();
		break;
	}
}

function HandleMenuButtonEnable(string a_Param)
{
	local string ButtonName;
	local string EnableString;
	local bool bEnable;
	
	ParseString(a_Param, "Name", ButtonName);
	ParseString(a_Param, "Enable", EnableString);
	
	if(EnableString=="True")
		bEnable=true;
	else
		bEnable=false;

	switch(ButtonName)
	{
	case "Create" :
		if(bEnable)
			m_hBtnCreateCharacter.EnableWindow();
		else
			m_hBtnCreateCharacter.DisableWindow();
		break;
	case "Delete" :
		if(bEnable)
			m_hBtnDeleteCharacter.EnableWindow();
		else
			m_hBtnDeleteCharacter.DisableWindow();
		break;
	case "Start" :
		if(bEnable)
			m_hBtnStartGame.EnableWindow();
		else
			m_hBtnStartGame.DisableWindow();
		break;
	}
}

// 패스워드 윈도우가 나와 있다면 사라지게 한다.
function hidePasswordWndAll()
{
	 CharacterPasswordHelpHtmlWndScript.Me.HideWindow();
	 CharacterPasswordWndScript.Me.HideWindow();
}

function HandleAddCharacterName(string param)
{
	local string Name;

	ParseString(param, "Name", Name);
	m_hCbCharacterName.AddString(Name);
}

function HandleCharacterSelect(string param)
{
	local int index;
	ParseInt(param, "index", index);
	m_hCbCharacterName.SetSelectedNum(index);

	if(index==-1)
		return;

	OnComboBoxItemSelected("cbCharacterName", index);
}

function HandleShowDialog(string param)
{
	local string type;
	local int SelectedCharacter;

	ParseString(param, "Type", type);

	switch(type)
	{
	case "restore" :
		ParseInt(param, "SelectedCharacter", SelectedCharacter);
		ShowRestoreDialog(SelectedCharacter);
		break;
	}
}


function ShowRestoreDialog(int SelectedCharacter)
{
	DialogSetID( DLG_ID_RESTORE );
	DialogSetReservedInt(SelectedCharacter);
	DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 1555 ) );
}

function HandleDialogResult(bool bOk)
{
	local int DlgID;
	local int Reserved;

	if(!DialogIsMine())
		return;

	DlgID=DialogGetID();
	Reserved=DialogGetReservedInt();

	switch(DlgID)
	{
		case DLG_ID_RESTORE :
			HandleDialogRestore(bOk, Reserved);
			break;
		case DLG_ID_DELETE :
			HandleDialogDelete(bOk, Reserved);
			break;
	}
}

function HandleDialogRestore(bool bOk, int SelectedCharacter)
{
	if(bOk)
		RequestRestoreCharacter(SelectedCharacter);

	ResetCharacterPosition();

	ResetCharacterSelectWindow();

	m_hBtnCreateCharacter.EnableWindow();
	m_hBtnDeleteCharacter.EnableWindow();
	m_hBtnStartGame.EnableWindow();


}

function HandleDialogDelete(bool bOk, int SelectedCharacter)
{
	if(bOk)
		RequestDeleteCharacter(SelectedCharacter);

	// 2차 비번 사용 하지 않는다면.. 이전 처럼 아래 코드 실행
	if (IsUseSecondaryAuth() == false)
	{
	
		// 2차 비번 넣으면서 삭제.
		ResetCharacterPosition();

		ResetCharacterSelectWindow();

		m_hBtnCreateCharacter.EnableWindow();
		m_hBtnDeleteCharacter.EnableWindow();
		m_hBtnStartGame.EnableWindow();
	}
}

function ResetCharacterSelectWindow()
{
	m_hCbCharacterName.SetSelectedNum(-1);

	m_hTbLevel.SetText("");
	m_hTbClassName.SetText("");
	m_hTbSP.SetText("");
	m_hTbPropensity.SetText("");

	m_hSbHP.SetPoint(0,0);
	m_hSbMP.SetPoint(0,0);

	m_hSbEXP.SetPointExpPercentRate(0.0);

	StopBlinkAnimation();
}


function OnComboBoxItemSelected( String strID, int index )
{
	local UserInfo info;
//	local int Vitality;

	switch(strID)
	{
	case "cbCharacterName" :
		RequestCharacterSelect(index);
		// 캐릭터 정보 채워준다
		GetSelectedCharacterInfo(index, info);
		
		m_hTbLevel.SetText(string(info.nLevel));
		m_hTbClassName.SetText(GetClassType(info.nSubClass));
		m_hTbSP.SetText(string(info.nSP));
		if(info.nCriminalRate>999999)
			m_hTbPropensity.SetText(string(info.nCriminalRate)$"+");
		else
			m_hTbPropensity.SetText(string(info.nCriminalRate));

		m_hSbHP.SetPoint(info.nCurHP,info.nMaxHP);
		m_hSbMP.SetPoint(info.nCurMP,info.nMaxMP);
		m_hSbEXP.SetPointExpPercentRate(info.fExpPercentRate);
		
		// 활력 시스템 개선
		// 활력 정보 추가. 이미 user info에 포함되어있는 활력 포인트. - gorillazin 10. 05. 10.
		SetVitalityGauge(info.nVitality);

		break;			 
	}
}
	
function SetVitalityGauge(int vitalityPoint)
{
	StopBlinkAnimation();

	if(vitalityPoint > VITALITY_POINT_MAX)
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_01");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		m_hVitalityPointBar.SetValue(0 , 0);
	}
	else if(vitalityPoint >= VITALITY_POINT_BOUNDARY_LEVEL4) 	//활력 4단계. 경험치 보너스 300%. 사이값 3000
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_05");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"4",MakeFullSystemMsg(GetSystemMessage(2330),"300%",""))));
		m_hVitalityPointBar.SetValue(VITALITY_POINT_MAX - VITALITY_POINT_BOUNDARY_LEVEL4, vitalityPoint - VITALITY_POINT_BOUNDARY_LEVEL4); 
	}
	else if(vitalityPoint >= VITALITY_POINT_BOUNDARY_LEVEL3)	// 활력 3단계. 경험치 보너스 250%. 사이값 4000
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_04");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"3",MakeFullSystemMsg(GetSystemMessage(2330),"250%",""))));
		m_hVitalityPointBar.SetValue(VITALITY_POINT_BOUNDARY_LEVEL4 - VITALITY_POINT_BOUNDARY_LEVEL3, vitalityPoint - VITALITY_POINT_BOUNDARY_LEVEL3); 
	}
	else if(vitalityPoint >= VITALITY_POINT_BOUNDARY_LEVEL2)		//활력 2단계. 경험치 보너스 200%. 사이값 11000 
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_03");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"2",MakeFullSystemMsg(GetSystemMessage(2330),"200%",""))));
		m_hVitalityPointBar.SetValue(VITALITY_POINT_BOUNDARY_LEVEL3 - VITALITY_POINT_BOUNDARY_LEVEL2, vitalityPoint - VITALITY_POINT_BOUNDARY_LEVEL2); 
	}
	else if(vitalityPoint >= VITALITY_POINT_BOUNDARY_LEVEL1)		//활력 1단계. 경험치 보너스 150%. 사이값 1760
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_02");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"1",MakeFullSystemMsg(GetSystemMessage(2330),"150%",""))));
		m_hVitalityPointBar.SetValue(VITALITY_POINT_BOUNDARY_LEVEL2 - VITALITY_POINT_BOUNDARY_LEVEL1 , vitalityPoint - VITALITY_POINT_BOUNDARY_LEVEL1); 
	}
	else	// 활력 0단계. 경험치 보너스 없음. 사이값 240.
	{
		m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_01");
		m_hVitalityPointTooltip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0%",""))));
		m_hVitalityPointBar.SetValue(240 , vitalityPoint);
	}

	if(vitalityPoint == VITALITY_POINT_MAX)
	{
		m_hOwnerWnd.KillTimer(BLINK_TIMER_ID1);
		m_hOwnerWnd.SetTimer(BLINK_TIMER_ID1, BLINK_TIMER_DELAY1);
	}
}

// 활력 시스템 개선 - gorillazin 10. 05. 12.
function PlayBlinkAnimation()
{
	if(m_bIsBlink)
	{
		m_hVitalityBlinkAnimTexture_Left.SetAlpha(BLINK_ANIM_MAX_ALPHA, BLINK_ANIM_SPEED);
		m_hVitalityBlinkAnimTexture_Center.SetAlpha(BLINK_ANIM_MAX_ALPHA, BLINK_ANIM_SPEED);
		m_hVitalityBlinkAnimTexture_Right.SetAlpha(BLINK_ANIM_MAX_ALPHA, BLINK_ANIM_SPEED);
		m_bIsBlink = false;
	}
	else
	{
		m_hVitalityBlinkAnimTexture_Left.SetAlpha(BLINK_ANIM_MIN_ALPHA, BLINK_ANIM_SPEED);
		m_hVitalityBlinkAnimTexture_Center.SetAlpha(BLINK_ANIM_MIN_ALPHA, BLINK_ANIM_SPEED);
		m_hVitalityBlinkAnimTexture_Right.SetAlpha(BLINK_ANIM_MIN_ALPHA, BLINK_ANIM_SPEED);

		m_bIsBlink = true;
	}
}

function StopBlinkAnimation()
{
	m_bIsBlink = true;

	m_hOwnerWnd.KillTimer(BLINK_TIMER_ID1);
	m_hVitalityBlinkAnimTexture_Left.SetAlpha(0, 0f);
	m_hVitalityBlinkAnimTexture_Center.SetAlpha(0, 0f);
	m_hVitalityBlinkAnimTexture_Right.SetAlpha(0, 0f);
	m_hVitalityLevelTexture.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_01");

	m_hVitalityPointBar.SetValue(0 , 0);

	debug("reset blink ui");
}
defaultproperties
{
}
