class RadarOptionWnd extends UICommonAPI;

const TIMER_ID=123;

var WindowHandle Me;
var TextBoxHandle txtRadarOption;
var CheckBoxHandle checkPartyView;
var CheckBoxHandle checkMonsterView;
var CheckBoxHandle checkMyPos;
var CheckBoxHandle checkFixView;
var TextureHandle checkBg;
var ButtonHandle btnClose;

var WindowHandle	m_RadarMapWnd;

var bool showMonster;
var bool hideParty;
var bool showMe;	// 내 위치 표시 보이기/ 감추기
var bool fixRadar;	// 레이더 고정

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

	Load();
}

function Initialize()
{
	Me = GetHandle( "RadarOptionWnd" );
	txtRadarOption = TextBoxHandle ( GetHandle( "RadarOptionWnd.txtRadarOption" ) );
	checkPartyView = CheckBoxHandle ( GetHandle( "RadarOptionWnd.checkPartyView" ) );
	checkMonsterView = CheckBoxHandle ( GetHandle( "RadarOptionWnd.checkMonsterView" ) );
	checkMyPos = CheckBoxHandle ( GetHandle( "RadarOptionWnd.checkMyPos" ) );
	checkFixView = CheckBoxHandle ( GetHandle( "RadarOptionWnd.checkFixView" ) );
	checkBg = TextureHandle ( GetHandle( "RadarOptionWnd.checkBg" ) );
	btnClose = ButtonHandle ( GetHandle( "RadarOptionWnd.btnClose" ) );
	
	m_RadarMapWnd =  GetHandle( "RadarMapWnd" );
}

function InitializeCOD()
{
	Me = GetWindowHandle( "RadarOptionWnd" );
	txtRadarOption = GetTextBoxHandle ("RadarOptionWnd.txtRadarOption" );
	checkPartyView = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" );
	checkMonsterView = GetCheckBoxHandle ( "RadarOptionWnd.checkMonsterView" );
	checkMyPos = GetCheckBoxHandle ( "RadarOptionWnd.checkMyPos" );
	checkFixView = GetCheckBoxHandle ( "RadarOptionWnd.checkFixView" );
	checkBg = GetTextureHandle ( "RadarOptionWnd.checkBg" );
	btnClose = GetButtonHandle ( "RadarOptionWnd.btnClose" );
	
	m_RadarMapWnd =  GetWindowHandle( "RadarMapWnd" );
	//checkMonsterView.disableWindow();
}

function Load()
{
	showMonster = GetOptionBool("Game", "radarShowMonster");
	hideParty = GetOptionBool("Game", "radarHideParty");
	showMe = GetOptionBool("Game", "radarShowMe");
	fixRadar = GetOptionBool("Game", "radarFix");
	
	if(showMonster == true)	checkMonsterView.SetCheck(true);
	else	checkMonsterView.SetCheck(false);
		
	if(hideParty == true)	checkPartyView.SetCheck(true);
	else	checkPartyView.SetCheck(false);
		
	if(showMe == true)	checkMyPos.SetCheck(true);
	else	checkMyPos.SetCheck(false);
		
	if(fixRadar == true)	checkFixView.SetCheck(true);
	else	checkFixView.SetCheck(false);
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnClose":
		HandleBtnClose();		
		break;
	}
}

// 닫기 버튼을 눌렀을 경우 처리.
function HandleBtnClose()
{
	local  RadarMapWnd script1;	// 레이더 스크립트 가져오기
	script1 = RadarMapWnd( GetScript("RadarMapWnd") );
	
	if( IsShowWindow("RadarOptionWnd"))	//닫을 경우 설정을 저장해준다. 
	{
		if(checkPartyView.IsChecked())		// 파티원 보이기 체크박스 처리
		{
			hideParty = true;
			SetOptionBool( "Game", "radarHideParty", true );
		}
		else 
		{
			hideParty = false;
			SetOptionBool( "Game", "radarHideParty", false );
		}
		
		if(checkMonsterView.IsChecked())		// 몬스터 보이기 체크박스 처리
		{
			showMonster = true;
			SetOptionBool( "Game", "radarShowMonster", true );
		}
		else 
		{
			showMonster = false;
			SetOptionBool( "Game", "radarShowMonster", false );
		}
		
		if(checkMyPos.IsChecked())			// 내표시 감추기 체크박스 처리
		{
			showMe = true;
			SetOptionBool( "Game", "radarShowMe", true );
		}
		else 
		{
			showMe = false;
			SetOptionBool( "Game", "radarShowMe", false );
		}
		
		if(checkFixView.IsChecked())		// 레이더 고정 처리
		{
			fixRadar = true;
			SetOptionBool( "Game", "radarFix", true );
		}
		else 
		{
			fixRadar = false;
			SetOptionBool( "Game", "radarFix", false );
		}
		script1.showMonster = showMonster;		// 레이더 창에 옵션을 옮겨준다. 
		script1.hideParty = hideParty;
		script1.showMe = showMe;
		script1.fixRadar = fixRadar;
		
		script1.HandleOntimer();
		script1.CheckTimer();
		script1.OptionApply();
		HideWindow("RadarOptionWnd");
		//debug("close option wnd");
	}
}

// 체크박스를 클릭하였을 경우 이벤트
function OnClickCheckBox( string CheckBoxID)
{
	switch( CheckBoxID )
	{
	case "checkPartyView":
		if(checkPartyView.IsChecked())		// 파티원 보이기 체크박스 처리
		{
			hideParty = true;
			SetOptionBool( "Game", "radarHideParty", true );
		}
		else 
		{
			hideParty = false;
			SetOptionBool( "Game", "radarHideParty", false );
		}
	case "checkMonsterView":
		if(checkMonsterView.IsChecked())		// 몬스터 보이기 체크박스 처리
		{
			showMonster = true;
			SetOptionBool( "Game", "radarShowMonster", true );
		}
		else 
		{
			showMonster = false;
			SetOptionBool( "Game", "radarShowMonster", false );
		}
		break;
	case "checkMyPos":
		if(checkMyPos.IsChecked())			// 내표시 감추기 체크박스 처리
		{
			showMe = true;
			SetOptionBool( "Game", "radarShowMe", true );
		}
		else 
		{
			showMe = false;
			SetOptionBool( "Game", "radarShowMe", false );
		}
		break;
	case "checkFixView":
		if(checkFixView.IsChecked())		// 레이더 고정 처리
		{
			fixRadar = true;
			SetOptionBool( "Game", "radarFix", true );
		}
		else 
		{
			fixRadar = false;
			SetOptionBool( "Game", "radarFix", false );
		}
		break;
	}
}
defaultproperties
{
}
