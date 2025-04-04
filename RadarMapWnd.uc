class RadarMapWnd extends UICommonAPI;

const OBJ_TYPE_MONSTER=1;
const OBJ_TYPE_PARTYMEMBER=2;
const OBJ_TYPE_CLANMEMBER=3;
const OBJ_TYPE_ALLIANCEMEMBER=4;
const OBJ_TYPE_ITEM=5;
const OBJ_TYPE_ADENA=6;

const MAX_HIDE_POS=79;

const TIMER_ID=123;
const TIMER_DELAY=1700;			    // 정보 갱신을 요청하는 것은 이 micro second의 영향을 받는다. 

const TIMER_ID2=124;
const TIMER_ID3=125;
const TIMER_DELAY2=1000;			// 돌리는 타이머

const TIMER_ID4=126;		        //표시 불가 지역 텍스트를 보여줄 타이머
const TIMER_DELAY4=3000;	

const TARGET_RADAR_ID=7777;			//타겟 아이디를 미리 하나 할당해둠

const DX = 3130;
const DY = 3130;

const MAX_MONSTER=20;
const MAX_PARTY= 8;

const MAG_1= 1.5;	
const MAG_2= 1.3;
const MAG_3= 1.0;
const MAG_4= 0.7;
//const MAG_5= 0.5;

const MIN_MAG= 1;
const MAX_MAG= 4;

const REQUEST_DISTANCE = 4000;	        // 위치정보 요청 반경
const REQUEST_PARTY_DISTANCE = 5000;	// 위치정보 요청 반경
const REQUEST_PARTY_DISTANCE_1 = 14000;	// 축적에 따른 파티원 위치 정보 표시 반경	// MAG_1 ~4 와 1:1로 매칭된다.
const REQUEST_PARTY_DISTANCE_2 = 12000;	
const REQUEST_PARTY_DISTANCE_3 = 9000;	
const REQUEST_PARTY_DISTANCE_4 = 6000;	
const REQUEST_HEIGHT = 800;         	// 위치정보 요청 높이

const LIGHT_ALPHA = 250;     	        // 테두리가 엷어지는 알파값

const ROTATE_TIME = 500;	            // 회전 시간
const ROTATE_TIMER_ID = 127;	        // 회전 종료시 처리해 줄 것들을 처리해주는 타이머

const ALPHA_TIME = 100;              	// 회전 후 알파가 시작되는 시간
const ALPHA_TIMER_ID = 128;

const FS_TIME = 45000;	                // 시스템 튜토리얼이 랜덤하게 보이는 시간	//45초에 1회씩
const FS_TIMER_ID = 151;	            // 타이머 아이디

const EDGE_GRAY = 15;
const EDGE_BLUE = 12;
const EDGE_ORANGE = 11;
const EDGE_BUFFRED = 9;
const EDGE_RED = 8;
const EDGE_SSQGRAY = 13;
const EDGE_PVPGREEN = 14;

var string Name; // мобы функция HandleNotifyObject

var bool isRotating;	            	// 로테이션이 되는 동안 모든 액션을 막는다.

var RadarMapCtrlHandle	m_hRadarMapCtrl;

var WindowHandle		m_hRadarMapWnd;
var WindowHandle		m_radarOptionWnd;
var WindowHandle		m_hRadarMapRotationWnd;
var WindowHandle		m_RadarMapForWnd;
var WindowHandle		m_RadarMapBackWnd;
var WindowHandle		m_raderBack;

var TextureHandle		m_seaBg;
var TextureHandle		m_compas;
var TextureHandle		m_TexMyPosition;

var ButtonHandle		m_optionWnd;

var CheckBoxHandle      checkPartyView;
var CheckBoxHandle      checkMonsterView;
var CheckBoxHandle      checkMyPos;
var CheckBoxHandle      checkFixView;

// 비행정 관련 핸들
var WindowHandle FlightStatusGauges;
var StatusBarHandle barFuel;
var BarHandle barMP;
var BarHandle barHP;
var TextBoxHandle ShipNameTxt;	     // 비행정 이름 "%s 혈맹의 비행정"

// 비행정 고도 관련 핸들
var WindowHandle FlightStatusAltitude;
var TextureHandle FlightAltitudeGaugeTex;

var string m_WindowName;
var vector MyPosition;

var string m_TargetName;		     // 타겟 정보를 임시 저장한다. 
var vector m_TargetPosition;
var int m_TargetID;
var int m_MyID;


var int arr_MonsterID[MAX_MONSTER];	 // 몬스터의 ID를 저장하는 배열
var int arr_PartyID[MAX_PARTY];		 // 파티원의 ID를 저장하는 배열
var int arr_PartyLocX[MAX_PARTY];	 // 파티원의 위치정보
var int arr_PartyLocY[MAX_PARTY];	 // 파티원의 위치정보
var int arr_PartyLocZ[MAX_PARTY];	 // 파티원의 위치정보
var string arr_PartyName[MAX_PARTY]; // 파티원의 이름

var float mag;
var float arrMag[6];
var int magStep;					//단계를 저장한다. 

var int arrPartyDistWithMag[6];		// 축적에 따른 파티원 표시 반경

var bool bLockClick;

// 레이더 색상 관련
var bool onshowstat1;
var bool onshowstat2;
var int globalAlphavalue1;
var int globalyloc;
var float numberstrange;
var int global_move_val;

var bool showMonster;
var bool hideParty;
var bool inParty;		    // 현재 파티에 속해있는지 확인
var bool inGamingState;		// 현재 게임 스테이트인지 확인
var bool showMe;	        // 내 위치 표시 보이기/ 감추기
var bool fixRadar;	        // 레이더 고정

var bool isFrontSide;	    // 앞쪽인가
var bool isOnFSTimer;	    // 시스템 튜토리얼이 켜져있는지 확인
var bool isFreeShip;	    // 자유 비행정인가?  true 이면 자유,  false 이면 정기 비행정

//var TextBoxHandle	m_movingText;
var TextBoxHandle	m_textboxmove;
var TextBoxHandle	m_textNoMap;
var TextureHandle	m_texZone;

// PC방, 추천 정보 창 을 뷰 , 토글 
//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
var RecommendBonusWnd	RecommendBonusWndScript;	// 추천 정보창 
var PCCafeEventWnd	PCCafeEventWndScript;	    // PC방 포인트 창

var ButtonHandle	m_hRecommendBonusWndToggleButton;
var ButtonHandle	m_hPCCafeEventWndToggleButton;

var TextureHandle	m_hRecommendBonusToggleButtonRingTex;
var TextureHandle	m_hPCCafeEventWndToggleButtonRingTex;
//end of branch

function OnRegisterEvent()
{
	RegisterEvent(EV_SetRadarZoneCode);
	RegisterEvent( EV_BeginShowZoneTitleWnd );		//존네임이 바뀔 때, 레이더를 가려줄지 말지를 결정해야한다. 
	RegisterEvent( EV_ShowMinimap );	
	RegisterEvent( EV_NotifyObject);
	
	RegisterEvent( EV_PartyAddParty); 
	RegisterEvent( EV_PartyDeleteParty);
	RegisterEvent( EV_PartyDeleteAllParty);
	RegisterEvent( EV_NotifyPartyMemberPosition);
	
	registerEvent( EV_GamingStateEnter );
	registerEvent( EV_GamingStateExit );
	
	RegisterEvent( EV_TargetUpdate );				//타겟 업데이트 될 경우 타겟을 표시해준다.
	RegisterEvent( EV_TargetHideWindow );			//타겟이 하이드 될경우 타겟 삭제
	
	RegisterEvent( EV_FinishRotate);	//회전 종료시 들어오는 이벤트
	
	RegisterEvent( EV_AirShipState );	// 비행정 스테이트가 들어왔을 경우
	RegisterEvent( EV_AirShipUpdate );	// 비행정 정보 업데이트 이벤트
	RegisterEvent( EV_AirShipAltitude);	// 비행정 고도가 변경되었을 경우
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	RegisterEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_ReceiveNewVoteSystemInfo);
	//end of branch
}

function OnLoad()
{
	RegisterState( "RadarMapWnd", "DebugState");

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hRadarMapWnd=GetHandle(m_WindowName);
		m_hRadarMapCtrl=RadarMapCtrlHandle(GetHandle(m_WindowName$".RadarMapCtrl"));
		m_radarOptionWnd=GetHandle("RadarOptionWnd");
		m_hRadarMapRotationWnd = GetHandle("RadarMapWnd.RadarMapRotationWnd");

		m_RadarMapForWnd = GetHandle("RadarMapWnd.RadarMapForWnd");
		m_RadarMapBackWnd = GetHandle("RadarMapWnd.RadarMapBackWnd");
		
		m_textboxmove = TextBoxHandle(GetHandle(m_WindowName$".textboxmove"));
		m_texZone = TextureHandle(GetHandle(m_WindowName$".texZone"));	
		m_seaBg = TextureHandle(GetHandle(m_WindowName$".texSeaBg"));
		m_compas = TextureHandle(GetHandle(m_WindowName$".texHighLight"));
		m_TexMyPosition = TextureHandle(GetHandle(m_WindowName$".TexMyPosition"));
		m_textNoMap = TextBoxHandle(GetHandle(m_WindowName$".textNoMap"));
		m_optionWnd = ButtonHandle(GetHandle(m_WindowName$".btnOption"));
			
		checkPartyView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkPartyView" ) );
		checkMonsterView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkMonsterView" ) );
		checkMyPos = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkMyPos" ) );
		checkFixView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkFixView" ) );
		
		// 비행정 관련 핸들 초기화
		FlightStatusGauges = GetHandle( "RadarMapWnd.FlightStatusGauges" );
		barFuel = StatusBarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barFuel" ) );		
		barMP = BarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barMP" ) );
		barHP = BarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barHP" ) );	
		ShipNameTxt = TextBoxHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.ShipNameTxt" ) );
		
		FlightStatusAltitude = GetHandle( "RadarMapWnd.FlightStatusAltitude" );
		FlightAltitudeGaugeTex = TextureHandle( GetHandle("RadarMapWnd.FlightStatusAltitude.FlightAltitudeGaugeTex" ));

		//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
		m_hPCCafeEventWndToggleButton = GetButtonHandle("RadarMapWnd.pcCafeEventWndToggleButton");
		m_hRecommendBonusWndToggleButton = GetButtonHandle("RadarMapWnd.recommendBonusWndToggleButton");
		
		m_hRecommendBonusToggleButtonRingTex = GetTextureHandle("RadarMapWnd.recommendBonusWndToggleButtonRing");
		m_hPCCafeEventWndToggleButtonRingTex = GetTextureHandle("RadarMapWnd.pcCafeEventWndToggleButton_Ring");
		//end of branch
	}
	else
	{
		m_hRadarMapWnd=GetWindowHandle(m_WindowName);
		m_hRadarMapCtrl=GetRadarMapCtrlHandle(m_WindowName$".RadarMapCtrl");
		m_radarOptionWnd=GetWindowHandle("RadarOptionWnd");
		m_hRadarMapRotationWnd = GetWindowHandle("RadarMapWnd.RadarMapRotationWnd");

		m_RadarMapForWnd = GetWindowHandle("RadarMapWnd.RadarMapForWnd");
		m_RadarMapBackWnd = GetWindowHandle("RadarMapWnd.RadarMapBackWnd");
		
		m_textboxmove = GetTextBoxHandle(m_WindowName$".textboxmove");
		m_texZone = GetTextureHandle (m_WindowName$".texZone");	
		m_seaBg = GetTextureHandle (m_WindowName$".texSeaBg");
		m_compas = GetTextureHandle (m_WindowName$".texHighLight");
		m_TexMyPosition = GetTextureHandle (m_WindowName$".TexMyPosition");
		m_textNoMap = GetTextBoxHandle(m_WindowName$".textNoMap");
		m_optionWnd = GetButtonHandle(m_WindowName$".btnOption");
			
		checkPartyView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkPartyView" );
		checkMonsterView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkMonsterView" );
		checkMyPos = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkMyPos" );
		checkFixView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkFixView" );
		
		// 비행정 게이지 관련 핸들 초기화
		FlightStatusGauges = GetWindowHandle( "RadarMapWnd.FlightStatusGauges" );
		barFuel = GetStatusBarHandle( "RadarMapWnd.FlightStatusGauges.barFuel" );
		barMP = GetBarHandle( "RadarMapWnd.FlightStatusGauges.barMP" );
		barHP = GetBarHandle( "RadarMapWnd.FlightStatusGauges.barHP" );
		ShipNameTxt = GetTextBoxHandle ( "RadarMapWnd.FlightStatusGauges.ShipNameTxt" );
		
		FlightStatusAltitude = GetWindowHandle( "RadarMapWnd.FlightStatusAltitude" );
		FlightAltitudeGaugeTex = GetTextureHandle( "RadarMapWnd.FlightStatusAltitude.FlightAltitudeGaugeTex" );
		
		//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
		m_hPCCafeEventWndToggleButton = GetButtonHandle("RadarMapWnd.pcCafeEventWndToggleButton");
		m_hRecommendBonusWndToggleButton = GetButtonHandle("RadarMapWnd.recommendBonusWndToggleButton");
		
		m_hRecommendBonusToggleButtonRingTex = GetTextureHandle("RadarMapWnd.recommendBonusWndToggleButtonRing");
		m_hPCCafeEventWndToggleButtonRingTex = GetTextureHandle("RadarMapWnd.pcCafeEventWndToggleButton_Ring");
		//end of branch
	}
	
	inGamingState = false;
	
	bLockClick = false;
	InitDatas();
	m_hOwnerWnd.EnableTick();
	
	isFreeShip = false;
	FlightGaugesClear();	// 비행정 관련 게이지 초기화

	RecommendBonusWndScript = RecommendBonusWnd( GetScript("RecommendBonusWnd") );
	PCCafeEventWndScript = PCCafeEventWnd( GetScript("PCCafeEventWnd") );	
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	m_hPCCafeEventWndToggleButton.HideWindow();
	m_hPCCafeEventWndToggleButtonRingTex.HideWindow();
	
	m_hRecommendBonusWndToggleButton.HideWindow();
	m_hRecommendBonusToggleButtonRingTex.HideWindow();
	//end of branch
}

function InitDatas()
{
	local int i;
	local UserInfo	MyInfo;
	
	local vector vec;
	vec.x=-1.0;
	vec.y=-1.0;
	vec.z=0.0;

	// 비행정 관련 초기화
	isOnFSTimer = false;
	m_hRadarMapWnd.KillTimer( FS_TIMER_ID );
	
	init_textboxmove();
	//class'UIAPI_WINDOW'.static.HideWindow("movingtext");
	onshowstat1 = false;
	onshowstat2 = false;
	globalAlphavalue1 = 0;
	globalyloc = 0;
	numberstrange =0;
	global_move_val =0;
	
	//inParty = false;
	
	//MyPosition = GetPlayerPosition();
	//m_hRadarMapCtrl.AddObject(1, "Self", "", MyPosition.x, MyPosition.y, MyPosition.z);
	
	// 기본적으로 보이는것으로 표시  // 옵션에서 가져온다. 
	showMonster = GetOptionBool("Game", "radarShowMonster");
	hideParty = GetOptionBool("Game", "radarHideParty");
	showMe = GetOptionBool("Game", "radarShowMe");
	fixRadar = GetOptionBool("Game", "radarFix");
	inParty = false;
	
	if(showMonster == true)	checkMonsterView.SetCheck(true);
	else	checkMonsterView.SetCheck(false);
		
	if(hideParty == true)	checkPartyView.SetCheck(true);
	else	checkPartyView.SetCheck(false);
		
	if(showMe == true)	checkMyPos.SetCheck(true);
	else	checkMyPos.SetCheck(false);
		
	if(fixRadar == true)	checkFixView.SetCheck(true);
	else	checkFixView.SetCheck(false);
	
	for(i=0; i<MAX_MONSTER; i++)	arr_MonsterID[i] = -1;
	for(i=0; i<MAX_PARTY; i++)		
	{
		arr_PartyID[i] = -1;
		arr_PartyLocX[i]  = -1;
	}
	
	ClearObject();
	m_hRadarMapWnd.KillTimer( TIMER_ID );
	m_hRadarMapWnd.KillTimer( TIMER_ID2 );
	m_hRadarMapWnd.KillTimer( TIMER_ID3 );
	CheckTimer();
	OptionApply();
	
	arrMag[MIN_MAG] = MAG_1;
	arrMag[MIN_MAG + 1] = MAG_2;
	arrMag[MIN_MAG + 2] = MAG_3;
	arrMag[MIN_MAG + 3] = MAG_4;
	//arrMag[MIN_MAG + 4] = MAG_5;
	
	arrPartyDistWithMag[MIN_MAG] = REQUEST_PARTY_DISTANCE_1;
	arrPartyDistWithMag[MIN_MAG + 1] = REQUEST_PARTY_DISTANCE_2;
	arrPartyDistWithMag[MIN_MAG + 2] = REQUEST_PARTY_DISTANCE_3;
	arrPartyDistWithMag[MIN_MAG + 3] = REQUEST_PARTY_DISTANCE_4;
	
	mag=MAG_3;
	magStep = 3;
	m_hRadarMapCtrl.SetMagnification(mag);
	
	m_TargetName = "";
	m_TargetID = -1;
	
	GetPlayerInfo( MyInfo );
	
	m_MyID = MyInfo.nID;
	
	m_textNoMap.HideWindow();	// "표시 불가 지역" 텍스트는 기본적으로 가려진다. 
	
	m_textboxmove.SetText("");			//존 표시를 초기화해줌
	m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");	
	
	if(!showMe)	//이게false이면 내 위치를 감춰준다. 
	{
		m_TexMyPosition.HideWindow();
		m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");
	}
	else		//true 이면 보여줌
	{
		m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
		m_TexMyPosition.ShowWindow();
	}	
	
	if(isFrontSide == false )
	{
		vec.x=-1.0;
		vec.y=-1.0;
		vec.z=0.0;
		m_hRadarMapRotationWnd.SetAlpha(255);
		m_RadarMapBackWnd.SetAlpha(0);
		//m_RadarMapBackWnd.Rotate(false,1,vec, 0,0,false,0);	// 뒷면을 초기화 해준다.
		m_RadarMapBackWnd.HideWindow();	
	}
	
	isFrontSide = true;
}

function OnShow()
{

	
	//m_RadarMapBackWnd.HideWindow();
	//m_RadarMapBackWnd.ShowWindow();
}

function SetTexZoneColor(int type)
{
	switch (type)
	{
		//Ordinary Field: Grey
		case EDGE_GRAY:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");
		break;
		
		//Peace Zone: Blue
		case EDGE_BLUE:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_blue");
		break;
		
		//Siege Warfare Zone: Orange
		case EDGE_ORANGE:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_orange");
		break;
		
		//Buff Zone: Green
		case EDGE_BUFFRED:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_red");
		break;
		
		//DeBuff Zone: Red
		case EDGE_RED:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_red");
		break;
		
		//SSQZone: Grey
		case EDGE_SSQGRAY:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");	

		break;
		
		//PVPZone: Green
		case EDGE_PVPGREEN:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_green");	
		break;
	}
}
function SetTexZoneInfo(int type)
{
	switch (type)
	{
		//Ordinary Field: Grey
		case EDGE_GRAY:
		m_textboxmove.SetText(GetSystemString(1284));
		break;
		
		//Peace Zone: Blue
		case EDGE_BLUE:
		m_textboxmove.SetText(GetSystemString(1285));
		break;
		
		//Siege Warfare Zone: Orange
		case EDGE_ORANGE:
		m_textboxmove.SetText(GetSystemString(1286));
		break;
		
		//Buff Zone: Green
		case EDGE_BUFFRED:
		m_textboxmove.SetText(GetSystemString(1287));
		break;
		
		//DeBuff Zone: Red
		case EDGE_RED:
		m_textboxmove.SetText(GetSystemString(1288));
		break;
		
		//SSQZone: Grey
		case EDGE_SSQGRAY:
		m_textboxmove.SetText(GetSystemString(1289));

		break;
		
		//PVPZone: Green
		case EDGE_PVPGREEN:
		m_textboxmove.SetText( GetSystemString(1290));
		break;
	}

}
function CheckTimer()	// 현 상황에서 타이머를 돌릴 조건이 되는지 체크하고, 조건이 된다면 타이머 기동
{
	if(showMonster == true || (hideParty == false && inParty == true))	// 위치를 찍어줄 게 있으면 타이머 가동!
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID );
		m_hRadarMapWnd.SetTimer(TIMER_ID,TIMER_DELAY);
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	// 움직이는 텍스트 표시
	local int type;
	
	switch( a_EventID )
	{
	case EV_ShowMinimap:	
		break;
	
	case EV_NotifyObject :
		HandleNotifyObject(a_Param);
		break;
	
	case EV_SetRadarZoneCode:
		ParseInt( a_Param, "ZoneCode", type );
		HandleRadarZoneCode(type);
		break;
	
	case EV_PartyAddParty:
		HandlePartyAddParty(a_Param);
		break;
	
	case EV_PartyDeleteParty:
		HandlePartyDeleteParty(a_Param);
		break;
	
	case EV_PartyDeleteAllParty:
		HandlePartyDeleteAllParty();
		break;
	
	case EV_NotifyPartyMemberPosition:
		HandleNotifyPartyMemberPosition(a_Param);
		break;
	
	case EV_GamingStateEnter:
		inGamingState = true;
		break;
	
	case EV_GamingStateExit:
		inGamingState = false;	
		ClearObject();
		InitDatas();
		break;
	
	case EV_BeginShowZoneTitleWnd:
		HandleZoneTitle();
		break;
	
	case EV_TargetUpdate:
		HandleTargetUpdate();
		break;
	
	case EV_TargetHideWindow:
		HandleTargetHideWindow();
		break;
	
	case EV_FinishRotate:
		HandleFinishRotate(a_Param);
		break;
	
	case EV_AirShipState:
		OnAirShipState( a_Param );
		break;
	
	case EV_AirShipUpdate:
		OnAirShipUpdate( a_Param );
		break;
	
	case EV_AirShipAltitude:
		OnAirShipAltitude( a_Param );
		break;
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	case EV_PCCafePointInfo:
		OnShowPCCafeButton();
		break;
	
	case EV_ReceiveNewVoteSystemInfo: 
		OnShowNewVoteSystemButton();
		break;
	//end of branch
	
	}
}

function HandleTargetUpdate()
{
	local UserInfo	info;
	local UserInfo	MyInfo;
	
	//특정 거리를 벗어나게 되면 삭제해준다.
	GetTargetInfo(info);
	GetPlayerInfo( MyInfo );	// 	
	
	m_MyID = MyInfo.nID;
	
	if(info.nID == m_MyID)
	{
		 return;
	}
	
	m_TargetID = info.nID;
	m_TargetName =  info.Name;
	m_TargetPosition = info.Loc;
	
	m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//지운다.
	
	if (isFrontSide == true)	// 앞면일 경우에만 타겟을 찍어준다.
	{
		if( info.Name != "")
		{
			m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  info.Name, info.Loc.x, info.Loc.y,  info.Loc.z);	
		}
	}
}

function HandleTargetHideWindow()
{
	m_TargetName = "";
	m_TargetID = -1;
	m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//지운다.
}

function HandlePartyAddParty(String param )
{
	local int ID;
	local int idx;
	local string Name;	
	
	//debug("HandlePartyAddParty !!" $ param);
	inParty = true;

	// 필요한 데이터를 파싱한다. 
	ParseInt(param, "ID", ID);
	ParseString(Param, "Name", Name);
	
	//파티원 추가시 배열에 ID를 저장한다. 
	if( FindPartyIDX(ID) > -1)	// 이미 배열에 ID가 있으면 문제가 있는것
	{
		//debug("ERROR PartyID : " $ FindPartyIDX(ID) );
		return;
	}
	else
	{
		idx = findEmptyPartySlot();
		if(idx == -1)	//빈 파티원 슬롯이 없어도 문제
		{
			//debug("ERROR - No Empty Slot!! ");
			return;
		}
		else	// 파티원 서버 ID를 배열에 저장한다. 
		{
			//debug(" idx : " $ idx $ " ID : " $ ID);
			arr_PartyID[idx] = ID;
			arr_PartyName[idx] = Name;
		}
	}
	
	HandleOntimer();	//걍 한번 갱신해줌	
	CheckTimer();
}

function HandlePartyDeleteParty(String param )
{
	local int ID;
	local int idx;
	
	ParseInt(param, "ID", ID);
	
	//특정 파티원의 삭제
	idx = FindPartyIDX(ID);
	if( idx > -1)	
	{
		m_hRadarMapCtrl.DeleteObject( arr_PartyID[idx]);
		arr_PartyLocX[idx]  = -1;
		arr_PartyID[idx] = -1;		
	}
	else//  배열에 ID가없으면 문제가 있는것
	{
		//debug("ERROR NO PartyID : " $ ID );
		return;
	}
	
	HandleOntimer();	//걍 한번 갱신해줌
}

function HandlePartyDeleteAllParty()
{
	local int i;
	inParty = false;
	
	// 모든 파티원 정보 삭제
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		m_hRadarMapCtrl.DeleteObject( arr_PartyID[i]);
		arr_PartyLocX[i]  = -1;
		arr_PartyID[i] = -1;
	}
		
	ClearObject();	//모든 오브젝트 지워주기
	
	HandleOntimer();	//걍 한번 갱신해줌
}

// 파티원 정보 업데이트 패킷
function HandleNotifyPartyMemberPosition(String param )
{
	// 현재 사용하지 않는 이벤트
	// 거리가 멀면 무시한다. 
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{

}

function HandleOntimer()
{
	// 모든 오브젝트 지우기
	ClearObject();
	
	if (isFrontSide == true && isRotating == false)	// 정보 표시의 모든 것은 앞면일 경우에만 
	{
		if(inGamingState)	// 게임중일 경우에만
		{
			if(showMonster)
			{
				m_hRadarMapCtrl.RequestObjectAround(OBJ_TYPE_MONSTER, REQUEST_DISTANCE, REQUEST_HEIGHT);
			}
			if(hideParty == false && inParty == true)
			{
				//debug("request party!!");
				AddPartyObject();	//현재 가지고 있는 모든 파티원 데이터를 애드해준다. 
				GetPartyLocation();	//미니맵에 있는 파티원의 위치정보를 가져와서 저장한다.
				m_hRadarMapCtrl.RequestObjectAround(OBJ_TYPE_PARTYMEMBER, arrPartyDistWithMag[magStep] , REQUEST_HEIGHT);	
			}
		}
		
		if( showMonster == false && (hideParty == true || inParty == false) )	// 둘다 꺼져있으면 타이머를 죽여준다. 
		{
			//debug("kill timer");
			m_hRadarMapWnd.KillTimer( TIMER_ID );
			ClearObject();
		}
	}
}

//현재 가지고 있는 모든 파티원 데이터를 애드해준다. 
function AddPartyObject()
{
	local int i;
	local int distance;
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			distance = GetDistanceFromMe(arr_PartyLocX[i], arr_PartyLocY[i], arr_PartyLocZ[i]);
			
			//debug("arr_PartyLocX[i] : " $ arr_PartyLocX[i]);
			//debug("ID : " $ arr_PartyID[i]  $ " distance : " $ distance );
			
			if( distance < arrPartyDistWithMag[magStep]  && distance > -1)	// 특정 반경 이내의 파티원만 추가한다.  (음수는 무시)
			{
				m_hRadarMapCtrl.AddObject( arr_PartyID[i] , "PartyMember", arr_PartyName[i], arr_PartyLocX[i], arr_PartyLocY[i], arr_PartyLocZ[i]);
				
				if(m_TargetID != -1 && m_TargetID == arr_PartyID[i])	//타겟이 파티원일경우, 현재 최신의 위치정보를 갱신
				 {
					 m_TargetPosition.x = arr_PartyLocX[i];
					 m_TargetPosition.y = arr_PartyLocY[i];
					 m_TargetPosition.z = arr_PartyLocZ[i];
					 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//지운다.
					 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
				 }
			}
		}			
	}
}

// 미니맵 데이터가 가지고 있는 모든 파티원 정보를 저장한다. 
function GetPartyLocation()
{
	local int i;
	local Vector PartyMemberLocation;
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			if(GetPartyMemberLocationWithID( arr_PartyID[i], PartyMemberLocation ))	//값이 있을 경우에만
			{
				if(arr_PartyLocX[i] != -1)	// -1은 값이 없다는 뜻이져~
				{
					arr_PartyLocX[i] = PartyMemberLocation.x;
					arr_PartyLocY[i] = PartyMemberLocation.y;
					arr_PartyLocZ[i] = PartyMemberLocation.z;
				}
			}
		}			
	}
}

// 특정 좌표와 내 위치와의 거리를 잰다.
function int GetDistanceFromMe( int x, int y, int z)
{
	local int distance;
	local int distX;
	local int distY;
	MyPosition = GetPlayerPosition();	// 내 위치 갱신
	
	//distance = int( Sqrt ( ( x - MyPosition.x ) ^ 2 + (y - MyPosition.y) ^ 2 ));
	distX = x - MyPosition.x;
	distY = y - MyPosition.y;
	distance =  int( Sqrt (distX * distX + distY * distY ));
	return distance;
}

//옵션 관련 변환 처리 // 내위치 표시 및 레이더 고정
function OptionApply()
{
	local int nZoneID;
	
	nZoneID = GetCurrentZoneID();
	
	//if(inGamingState)	// 게임중일 경우에만
	//{		
		if(!showMe)	//이게false이면 내 위치를 감춰준다. 
		{
			m_TexMyPosition.HideWindow();
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");
		}
		else		//true 이면 보여줌
		{
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
			m_TexMyPosition.ShowWindow();
		}
		
		if(fixRadar)	//이게true이면레이더 회전 금지 
		{
			m_hRadarMapCtrl.ClearRotation();
			m_compas.ClearRotation();
			m_hRadarMapCtrl.SetEnableRotation(false);
			m_compas.SetAutoRotateType( ETART_None );		//나침반 기능도 정지
			m_TexMyPosition.SetRotatingDirection(1);
			m_TexMyPosition.SetAutoRotateType( ETART_Camera );	//내 표시는 카메라와 같은 방향
			//m_TexMyPosition.HideWindow();
		}
		else		//false 이면 레이더 회전
		{
			m_hRadarMapCtrl.SetEnableRotation(true);
			if(IsHidePositionZone(nZoneID) == false)	//나침반이 정지하는 곳이라면 회복시킬 필요가 없다. 
			{
				m_compas.SetAutoRotateType( ETART_Camera );		//나침반 기능도 회복
			}
			m_TexMyPosition.ClearRotation();
			m_TexMyPosition.SetAutoRotateType( ETART_None );
			//m_TexMyPosition.ShowWindow();
		}
	//}
}

// 정보가 도착할 경우
function HandleNotifyObject(string a_Param)
{
	local string Type;
	local int ID;
//Сделал глобальной local string Name;
	local int LocX;
	local int LocY;
	local int LocZ;
	local int idx;
	
	ParseString(a_Param, "Type", Type);
	ParseInt(a_Param, "ID", ID);
	ParseString(a_Param, "Name", Name);

	ParseInt(a_Param, "X", locX);
	ParseInt(a_Param, "Y", locY);
	ParseInt(a_Param, "Z", locZ);

	//debug("요구한것 - Type:"$Type$", ID:"$ID$", Name:"$Name$", X:%d"$locX$", Y:%d"$locY$", Z:%d"$locZ);
	
	// 오브젝트 추가하기
	if(Type == string(OBJ_TYPE_MONSTER))	// 몬스터일경우
	{	
		if( FindMonsterIDX(ID) > -1)
		{
			//debug("Update MonsterID : " $ FindMonsterIDX(ID) );
			m_hRadarMapCtrl.UpdateObject( ID , locX, locY, locZ);
		}
		else
		{
			idx = findEmptyMonsterSlot();
			if(idx == -1)
			{
				//debug("ERROR - overflow monster array!! ");
		return;
			}
			else
			{
				if( FindMonsterIDX(ID) == -1)
				{
					m_hRadarMapCtrl.AddObject( ID , "Monster", Name, locX, locY, locZ);
					  
			 
					 if(m_TargetID != -1 && m_TargetID == ID)
					 {
						 m_TargetPosition.x = locX;
						 m_TargetPosition.y = locY;
						 m_TargetPosition.z = locZ;
						 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//지운다.
						 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
					
					}
				}
				arr_MonsterID[idx] = ID;
				//debug("add idx : " $ idx $ " ID : " $ ID);
			}
		}
	}	
	else if(Type == string(OBJ_TYPE_PARTYMEMBER))	// 파티원일경우
	{	
		idx = FindPartyIDX(ID);
		if( idx > -1)	//파티원을 추가할 때 ID가 저장된다. 그외에는 무시.
		{
			//위치정보를 배열에 저장해둔다.
			arr_PartyLocX[idx] = locX;
			arr_PartyLocY[idx] = locY;
			arr_PartyLocZ[idx] = locZ;
			//debug("PartyID : "$  ID );
			//m_hRadarMapCtrl.UpdateObject( ID , locX, locY, locZ);
		}
		else	//이제 여기로 들어오면 안된다.	AddPartyObject() 에서 이미 add를 했기 때문에
		{
			//GetPartyMemberLocationWithID( ID, PartyMemberLocation );
			//debug("PartyMemberLocation : " $ PartyMemberLocation);
			
			if (m_MyID != ID)	//나 이외의 파티원이 이곳으로 들어오면 안됨.
			{
				//debug("ERROR - Can't Find Party Member with ID" $ ID $ " idx : " $ idx);
			}			
			/*
			idx = findEmptyPartySlot();
			if(idx == -1)
			{
				//debug("ERROR - overflow party array!! ");
				return;
			}
			else
			{
				if( FindPartyIDX(ID) == -1 && m_MyID != ID)	//자신일 경우 추가하지 않음
				{
					m_hRadarMapCtrl.AddObject( ID , "PartyMember", Name, locX, locY, locZ);
					
					if(m_TargetID != -1 && m_TargetID == ID)
					 {
						 m_TargetPosition.x = locX;
						 m_TargetPosition.y = locY;
						 m_TargetPosition.z = locZ;
						 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//지운다.
						 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
					 }
				}
				arr_PartyID[idx] = ID;
			}
			*/
		}
	}
	
	// 거리 밖에 있는 오브젝트를 지워준다.
	//removeFarObject();
}

function ClearObject()
{
	local int  i;
	for(i=0 ; i<MAX_MONSTER ; i++)
	{
		//debug("delete 22 ID : " $ arr_MonsterID[i] $ " delete i " $ i );
		if(arr_MonsterID[i] != -1)
		{
			//debug("delete ID : " $ arr_MonsterID[i] $ " delete i " $ i );
			m_hRadarMapCtrl.DeleteObject( arr_MonsterID[i]);
			arr_MonsterID[i] = -1;
		}	
			
	}
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			m_hRadarMapCtrl.DeleteObject( arr_PartyID[i]);
			//arr_PartyID[i] = -1;	//파티원의 삭제는 delete party에서만 가능
		}			
	}
}

function int findEmptyMonsterSlot()
{
	local int  i;
	for(i=0 ; i<MAX_MONSTER ; i++)
	{
		if(arr_MonsterID[i] == -1)
		{
			return i;
		}			
	}	
	return -1;
}

function int findEmptyPartySlot()
{
	local int  i;
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] == -1)
		{
			return i;
		}			
	}	
	return -1;
}

// 타이머 딜레이마다  위치정보를 요청한다. 
function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		HandleOntimer();
	}
	
	if(TimerID == TIMER_ID4)
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_textNoMap.SetAlpha( 0, 0.8f );		
	}
	
	if(TimerID == ROTATE_TIMER_ID)
	{
		RotateProcess();	//보여줄 창 안보여줄 창을 설정한다.
		m_hRadarMapWnd.KillTimer( ROTATE_TIMER_ID);
	}
	
	if(TimerID == ALPHA_TIMER_ID)
	{
		m_RadarMapForWnd.SetAlpha(0, 0.1f);	// 알파를 죽여준다.  -> 어재서인지 종료 이벤트에서는 알파가 동작하지 않음
		m_hRadarMapWnd.KillTimer( ALPHA_TIMER_ID);
	}
	
	if(TimerID == FS_TIMER_ID)
	{
		if(!GetOptionBool( "Game", "SystemTutorialBox" ))	// 시스템 튜토리얼 체크박스를 확인해 주어야 한다. 
		{	
			ShowAirShipTutorial(-1);	// 시스템 메세지 랜덤 추가
		}
		else
		{
			isOnFSTimer = false;
			m_hRadarMapWnd.KillTimer( FS_TIMER_ID );	// 타이머를 죽여준다.
		}

	}
}

function OnClickButton( String a_ButtonID )
{
	local  RadarOptionWnd script1;	// 레이더 스크립트 가져오기
	script1 = RadarOptionWnd( GetScript("RadarOptionWnd") );
	
	if(isRotating == true)	return;	//회전중이면 아무것도 하지 않는다.
	
	switch( a_ButtonID )
	{
		case "TargetButton":
			break;
		case "BtnOption":
			clickRotateButton();
			break;
		case "BtnPlus":
			if(magStep < MAX_MAG)
			{
				magStep++;
				mag = arrMag[magStep];
				//debug("now Mag : " $ mag);
				m_hRadarMapCtrl.SetMagnification(mag);
			}
			break;
		case "BtnMinus":
			if(magStep > MIN_MAG)
			{
				magStep--;
				mag = arrMag[magStep];
				//debug("now Mag : " $ mag);
				m_hRadarMapCtrl.SetMagnification(mag);
			}
			break;
		case "recommendBonusWndToggleButton" :  
			RecommendBonusWndScript.visibleToggleWnd();

			break;
		case "pcCafeEventWndToggleButton" :  
			// pc방 포인트 창을 보였다, 안보였다 토글 하기 
			PCCafeEventWndScript.HandleToggleShowPCCafeEventWnd();
			break;

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

// 뒤-> 앞으로 돌린 후 알파가 조정되는 간격의 처리
function RotateProcess()
{
	if (isFrontSide == true)
	{
		isFrontSide = false;		
		// 여기로 들어오면 안된다.
		//debug("ERROR!! ");
	}
	else	//다시 앞으로
	{			
		if(m_RadarMapBackWnd.isShowWindow())	m_RadarMapBackWnd.HideWindow();
		
		OptionApply();	//옵션적용
		CheckTimer();
		isFrontSide = true;		
	}
	
	isRotating = false;
}


// 돌리는 연출
function clickRotateButton()
{
	local vector vec;
	vec.x=-1.0;
	vec.y=-1.0;
	vec.z=0.0;

	isRotating = true;
	
	if (isFrontSide == true)		// 뒤로 돌리기 시작
	{	
		m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	// 타겟을 지워준다.
		
		// 돌리는 중에는 존 알파가 변하면 안된다.	
		if(globalAlphavalue1 < 500)
		{
			m_textboxmove.SetAlpha(  0);
			m_texZone.SetAlpha( LIGHT_ALPHA );
			onshowstat1 = true;
			onshowstat2 = false;
			globalAlphavalue1 = 500;
		}
		
		if(!m_RadarMapForWnd.isShowWindow()) m_RadarMapForWnd.ShowWindow();		
		if(!m_RadarMapBackWnd.isShowWindow())	m_RadarMapBackWnd.ShowWindow();
			
		m_hRadarMapRotationWnd.SetAlpha(0, 0.5f);
		
		m_RadarMapForWnd.Rotate(false, 400, vec, 255, 255, false, 5);
		//m_RadarMapBackWnd.Rotate(false, 400, vec, 0, 255, false, 6);		
	}
	else
	{	
		m_RadarMapBackWnd.SetAlpha(0, 0.5f);
		
		m_RadarMapForWnd.Rotate(false, 400, vec, 255, 255, false, 5);
		
		//m_RadarMapBackWnd.Rotate(false, 400, vec, 255, 0, false, 6);
	}
}

function HandleFinishRotate( string Param )
{
	local String	winName;
	
	ParseString(Param, "WindowName", winName);
	
	if( winName == "RadarMapForWnd")
	{
		if(isFrontSide == true)
		{			
			//isFrontSide = false;
			//isRotating = false;
			m_RadarMapBackWnd.SetAlpha(255, 0.1f);
			m_hRadarMapWnd.SetTimer(ALPHA_TIMER_ID,ALPHA_TIME);	// 알파값을 주는 타이머, 해당 시간 후  알파가 작동 된다.
			m_hRadarMapWnd.SetTimer(ROTATE_TIMER_ID,ROTATE_TIME);	// 알파가 돌아가는 동안의 타이머
		}
		else
		{	
			m_hRadarMapRotationWnd.SetAlpha(255, 0.1f);
			m_hRadarMapWnd.SetTimer(ALPHA_TIMER_ID,ALPHA_TIME);	// 알파값을 주는 타이머, 해당 시간 후  알파가 작동 된다.
			m_hRadarMapWnd.SetTimer(ROTATE_TIMER_ID,ROTATE_TIME);	// 알파가 돌아가는 동안의 타이머
		}
	}
	
}

// 레이더 색상 관련
function HandleRadarZoneCode( int type )
{
	local Color Red;
	local Color Blue;
	local Color Grey;
	local Color Orange;
	local Color Green;
	Red.R = 50;
	Red.G = 0;
	Red.B = 0;
	Blue.R = 0;
	Blue.G = 0;
	Blue.B = 50;
	Grey.R = 30;
	Grey.G = 30;
	Grey.B = 30;
	Orange.R = 60;
	Orange.G = 30;
	Orange.B = 0;
	Green.R = 0;
	Green.G = 50;
	Green.B = 0;
	resetanimloc();
	onshowstat2 = true;
	
	m_textboxmove.ShowWindow();
	m_textboxmove.SetAlpha( 0 );
	m_texZone.SetAlpha( 0 );
	m_textboxmove.SetAlpha( 255, 0.8f );
	m_texZone.SetAlpha( 255 , 0.8f );
	SetTexZoneInfo(type);

	SetTexZoneColor(type);
}

function SetRadarColor( Color a_RadarColor, float a_Seconds )
{
	//class'UIAPI_RADAR'.static.SetRadarColor( "RadarContainerWnd.Radar", a_RadarColor, a_Seconds );
}



function OnTick()
{
	if (onshowstat2 == true)
	{
		fadeIn();
	}
	if (onshowstat1 == true)
	{
		fadeOut();
	}	
}

function fadeIn()
{
	globalAlphavalue1 = globalAlphavalue1 + 3;
	if (globalAlphavalue1 >= 255 &&  globalAlphavalue1 < 500)	// 좀 떠있도록 딜레이를 준다. globalAlphavalue1는 더이상 알파가 아님 -_-;; 그저 타이머 체크 변수일뿐!!
	{
		m_textboxmove.SetAlpha( 255);
		m_texZone.SetAlpha( 255);
	}
	else if( globalAlphavalue1 >= 500 )
	{
		m_textboxmove.SetAlpha(  0, 0.8f );
		m_texZone.SetAlpha(  LIGHT_ALPHA, 0.8f );
			
		//class'UIAPI_WINDOW'.static.Move( "RadarMapWnd.textboxmove", -30, 0, 0.8f );
		onshowstat1 = true;
		onshowstat2 = false;
	}
}

function fadeOut()
{
	//global_move_val = move_value();
	globalAlphavalue1 = globalAlphavalue1 - 2;
	globalyloc = globalyloc + 1;
	
	if( globalAlphavalue1 <= 1)
	{
		m_textboxmove.SetAlpha( 0);
		m_textboxmove.HideWindow();
		globalyloc = 0;
		global_move_val =0;
		globalAlphavalue1 = 0;
		onshowstat1 = false;
		onshowstat2 = false;
	}
}

function int move_value()
{
	local int movevalue;
	numberstrange = numberstrange + 0.5;
	if (numberstrange < 1)
	{
		movevalue = 0;
		return movevalue;
	} 
	if (numberstrange == 1)
	{
		movevalue = -1;
		numberstrange = 0;
		return movevalue;
	}
}	

function resetanimloc()
{
	//class'UIAPI_WINDOW'.static.Move("movingtext", 0,globalyloc/2);
	onshowstat1 = false;
	onshowstat2 = false;
	globalyloc = 0;
	global_move_val =0;
	globalAlphavalue1 = 0;
}


function init_textboxmove()
{
	m_textboxmove.SetText("");
}

//ID로 배열의 인덱스를 구한다. 
function int FindPartyIDX(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_PARTY; idx++)
	{
		if (arr_PartyID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID로 배열의 인덱스를 구한다. 
function int FindMonsterIDX(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_MONSTER; idx++)
	{
		if (arr_MonsterID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

// 존타이틀이 바뀔때 ID로 현재 미니맵을 가려줄지 결정한다. 
function HandleZoneTitle()
{
	local int nZoneID;
	nZoneID = GetCurrentZoneID();
	
	//debug("nZoneID : " $ nZoneID);
	if(m_textNoMap. isShowWindow())	//존타이틀이 바뀔때는 항상 표시불가지역 텍스트를 가려준다. 
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_textNoMap.HideWindow();
	}
	
	if( IsHideRadarZone(nZoneID) )
	{
		//레이더를 가린다. 
		if(m_seaBg.IsShowWindow())
		{
			//m_hRadarMapCtrl.HideWindow();
			m_hRadarMapCtrl.SetMapInvisible(true);
			m_seaBg.HideWindow();
		}
		
		if(IsHidePositionZone(nZoneID))	//나침반을 정지시킬 위치인가 // 타겟 표시도 사라지게 된다.  // 헬바운드
		{
			m_compas.ClearRotation();
			m_compas.SetAutoRotateType( ETART_None );		//나침반 기능도 정지
			m_hRadarMapCtrl.HideWindow();
			m_optionWnd.DisableWindow();
			
			// 옵션 방향이 보여지고 있다면, 앞면으로 돌려준다. 
			if(isFrontSide == false)	clickRotateButton();
			
			//헬바운드는 옵션에 상관없이 내위치표시를 감춰준다.
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");	
			m_TexMyPosition.HideWindow();
		}
		else
		{
			if(fixRadar == false)	//이게true이면레이더 회전 금지이기 때문에 나침반 회전을 복구할 필요가 없다.
				m_compas.SetAutoRotateType( ETART_Camera );		//나침반 기능회복
			m_optionWnd.EnableWindow();
			if(!m_seaBg.IsShowWindow())
			{
				m_hRadarMapCtrl.ShowWindow();
			}
		}

		// 표시 불가 지역 텍스트를 보여준다.			
		m_textNoMap.SetAlpha( 0 );
		m_textNoMap.ShowWindow();			
		m_textNoMap.SetAlpha( 255, 0.8f );
		
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_hRadarMapWnd.SetTimer(TIMER_ID4,TIMER_DELAY4);
		
	}
	else
	{
		//레이더가 가려지는 지역에서 -> 보통 지역으로 이동했을 경우 레이더를 보여준다.  
		if(!m_seaBg.IsShowWindow())
		{
			
			if(!m_hRadarMapCtrl.IsShowWindow())	//맵컨트롤이 가려져 있다면 보여줌
			{
				m_hRadarMapCtrl.ShowWindow();
			}
			m_hRadarMapCtrl.SetMapInvisible(false);
			m_seaBg.ShowWindow();
			
			if(fixRadar == false)	//이게true이면레이더 회전 금지이기 때문에 나침반 회전을 복구할 필요가 없다.
				m_compas.SetAutoRotateType( ETART_Camera );		//나침반 기능 복구
			
			m_optionWnd.EnableWindow();
			
			//헬바운드에서 일반 필드로 나왔을 경우
			// 내 위치 감추기가 false 인데 m_TexMyPosition가 HIde 상태이면 다시 복구해준다.			
			if((showMe) && (!m_TexMyPosition.IsShowWindow()))
			{
				m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
				m_TexMyPosition.ShowWindow();
			}
		}
		
	}
}

// 비행정 관련 함수들
// 비행정 게이지 초기화
function FlightGaugesClear()
{
	barHP.SetValue(100, 100);
	barMP.SetValue(100, 100);
	
	barHP.SetAlpha(100);
	barMP.SetAlpha(100);
	barFuel.SetPoint(0, 0);
}

// 비행정 탑승 스테이트를 알려준다. 
function OnAirShipState( string a_Param )
{
	local int VehicleID;
	local int IsDriver;
	//~ local UserInfo info;
	//~ local string ClanName;
	local vehicle myAirShip;
	
	ParseInt( a_Param, "VehicleID", VehicleID );
	ParseInt( a_Param, "IsDriver", IsDriver );
	
	myAirShip = class'VehicleAPI'.static.GetVehicle( VehicleID );
	
	if(myAirShip.MaxFuel > 0)
	{
		isFreeShip = true;
		barFuel.SetPoint(myAirShip.CurFuel, myAirShip.MaxFuel);	// 연료를 업데이트 한다. 
		
		if(myAirShip.CurFuel == 0)	{	AddSystemMessage(2464);	}		//	바닥남
		else	if(myAirShip.CurFuel < 50)	{	AddSystemMessage(2463);	}	//	곧 바닥남
		
		ShipNameTxt.SetText(  GetSystemMessage(2454) );	//크레스니크급 비행선
		
		//if( GetPlayerInfo( info ) )	// 혈맹의 이름을 받아와서
		//{		
			//ClanName =  class'UIDATA_CLAN'.static.GetName(info.nClanID);			
			//ShipNameTxt.SetName(  MakeFullSystemMsg( GetSystemMessage(2454), ClanName ) , NCT_Normal,TA_Left);	// "%s 의 비행정이라고 적어준다.
		//}
	}
	else
	{
		isFreeShip = false;
	}
		
	if(VehicleID > 0)	// 비행정에 탑승했을 경우
	{
		if(isFreeShip)
		{
			if(!GetOptionBool( "Game", "SystemTutorialBox" ))
			{
				// 여기서 타이머를 켠다.
				if(!isOnFSTimer)	// 타이머가 켜져있지 않을때만 켠다.
				{	
					isOnFSTimer = true;
					ShowAirShipTutorial(2742);
					ShowAirShipTutorial(2741);
					m_hRadarMapWnd.SetTimer( FS_TIMER_ID,FS_TIME );
				}
				else
				{
					if(IsDriver > 0)
					{
						ShowAirShipTutorial(2494);	// 시스템 메세지로 간단히 설명해준다.
						ShowAirShipTutorial(2495);
					}
				}
			}		
		
			if(!FlightStatusGauges.isShowWindow()) FlightStatusGauges.ShowWindow();		//게이지들 보여주기
			if(!FlightStatusAltitude.isShowWindow()) FlightStatusAltitude.ShowWindow();		//고도 보여주기
		}
	}
	else	// 비행정에서 내렸을 경우
	{		
		isFreeShip = false;
		if(isOnFSTimer)	m_hRadarMapWnd.KillTimer( FS_TIMER_ID );		// 타이머가 켜져있으면 끈다.
		isOnFSTimer = false;

		
		if(FlightStatusGauges.isShowWindow()) FlightStatusGauges.HideWindow();		//게이지들 숨김
		if(FlightStatusAltitude.isShowWindow()) FlightStatusAltitude.HideWindow();		//고도 숨김
	}			
}

// 비행정 정보 업데이트
function OnAirShipUpdate( string a_Param )
{
	local vehicle myAirShip;
	local int VehicleID;
	
	ParseInt( a_Param, "VehicleID", VehicleID );
	
	myAirShip = class'VehicleAPI'.static.GetVehicle( VehicleID );
	
	//barHP.SetValue( myAirShip.CurHP, myAirShip.MaxHP);	// 추후 HP가 들어가면 주석을 해제!
	
	if(myAirShip.MaxFuel > 0)
	{		
		barFuel.SetPoint(myAirShip.CurFuel, myAirShip.MaxFuel);	// 연료를 업데이트 한다. 
		if(myAirShip.CurFuel == 0)	{	AddSystemMessage(2464);	}		//	바닥남
		else	if(myAirShip.CurFuel < 50)	{	AddSystemMessage(2463);	}	//	곧 바닥남
	}
}

// 고도 변경시 날라오는 업데이트 정보
function OnAirShipAltitude( string a_Param )
{
	local int m_nGodo;
	
	ParseInt( a_Param, "Z" , m_nGodo);
	
	updateAltitudeTex( m_nGodo );
	
}

function ShowAirShipTutorial( int SystemMsgID)
{
	local int RandVal;
	local int RandSystemMsgID;
	
	if(SystemMsgID < 0)	// 0보다 작으면 랜덤한 시스템 메세지를 보여준다. 
	{
		RandVal = Rand(8);
		
		RandSystemMsgID = 2494;	// 만약을 위해 디폴트값 -_-
		
		switch(RandVal)
		{
			case 0:	RandSystemMsgID = 2494;		break;		// 각각의 시스템 메세지 아이디를 적어준다
			case 1:	RandSystemMsgID = 2495;		break;
			case 2:	RandSystemMsgID = 2496;		break;
			case 3:	RandSystemMsgID = 2497;		break;
			case 4:	RandSystemMsgID = 2498;		break;
			case 5 :	RandSystemMsgID = 2741;		break;
			case 6:	RandSystemMsgID = 2742;		break;
			case 7:	RandSystemMsgID = 2422;		break;
		}
	}
	else
	{
		RandSystemMsgID = SystemMsgID;
	}
	
	if(!GetOptionBool( "Game", "SystemTutorialBox" ))	// 시스템 튜토리얼 체크박스를 확인해 주어야 한다. 
	{	
		AddSystemMessage(RandSystemMsgID);	// 시스템 메세지 추가
	}
	else
	{
		isOnFSTimer = false;
		m_hRadarMapWnd.KillTimer( FS_TIMER_ID );	// 타이머를 죽여준다.
	}
}

// 고도 텍스쳐를 업데이트 한다. 
function updateAltitudeTex( int altitude)
{
	local int m_nLayer;
	
	m_nLayer = 1;	//기본적으로는  1 (암것도 안보이는 단계 - 텍스쳐 네임에 맞추자는)	
	m_nLayer = LayerOfAltitude(altitude);	//레이어 단계를 가져온다.	레이어는 1~ 14까지 (텍스쳐 네임과 동일)
	
	if( m_nLayer < 10)
	{
		FlightAltitudeGaugeTex.SetTexture("L2UI_ct1.RadarMap.RadarMap_df_Altitude_Gage_0" $ m_nLayer);
	}
	else
	{
		FlightAltitudeGaugeTex.SetTexture("L2UI_ct1.RadarMap.RadarMap_df_Altitude_Gage_" $ m_nLayer);
	}
	
	//AltitudeTxt.SetText(string(m_nZ + 4000));	// 고도를 업데이트 해준다. 	
}

// 비행정의 고도 단계를 리턴한다. 단계는 1단계에서 14 단계까지 존재 
function int LayerOfAltitude ( int altitude )
{
	local int returnLayer;
		
	if(altitude  >= 6000 )	returnLayer = 14;
	else if(altitude  >= 5500 )	returnLayer = 13;
	else if(altitude  >= 5000 )	returnLayer = 12;
	else if(altitude  >= 4500 )	returnLayer = 11;
	else if(altitude  >= 4000 )	returnLayer = 10;
	else if(altitude  >= 3500 )	returnLayer = 9;
	else if(altitude  >= 3000 )	returnLayer = 8;
	else if(altitude  >= 2500 )	returnLayer = 7;
	else if(altitude  >= 2000 )	returnLayer = 6;
	else if(altitude  >= 1500 )	returnLayer = 5;
	else if(altitude  >= 1000 )	returnLayer = 4;
	else if(altitude  >= 500 )	returnLayer = 3;
	else if(altitude  >= 0 )	returnLayer = 2;
	else					returnLayer = 1;		
	
	return returnLayer;
}

//미니맵을 가릴 지역이면 true 리턴. 보여줄 지역이면 false 리턴
function bool IsHideRadarZone(int nZoneID)
{	
	//debug("nZoneID : " $ nZoneID);
	switch(nZoneID)
	{
		//레이더를 가릴 곳들
		case 17:
		case 28:
		case 32:
		case 33:
		case 45:
		case 54:
		case 55:
		case 56:
		case 60:
		case 65:
		case 66:
		case 69:
		case 79:
		case 80:
		case 81:
		case 82:
		case 83:
		case 84:
		case 85:
		case 86:
		case 87:
		case 88:
		case 89:
		case 90:
		case 91:
		case 92:
		case 110:
		case 114:
		case 119:
		case 121:
		case 125:
		case 126:
		case 127:
		case 128:
		case 129:
		case 130:
		case 131:
		case 132:
		case 133:
		case 134:
		case 135:
		case 136:
		case 137:
		case 138:
		case 139:
		case 140:
		case 142:
		case 143:
		case 145:
		case 152:
		case 159:
		case 162:
		case 164:
		case 165:
		case 177:
		case 178:
		case 185:
		case 273:
		case 274:
		case 275:
		case 276:
		case 278:
		case 279:
		case 281:		//4대영묘
		case 282:
		case 283:
		case 284:
		case 285:
		case 286:		// 4대영묘
		case 303:
		case 304:
		case 306:
		case 311:		// 올림피아드 경기장
		case 316:
		case 317:
		case 318:
		case 319:
		case 320:
		case 321:
		case 336:
		case 339:
		case 340:		// 대현자의 영묘
		case 341:
		case 358:
		case 359:
		case 360:
		case 363:		//헬바운드
		case 364:		//헬바운드
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:	
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:		//나이아의 탑
		case 379:		//강철의 성		//CT 1.5
		case 380:		//강철의 성		
		case 381:		//강철의 성		//CT 1.5
		case 387:		//암운의 저택		//CT 1.5
		case	390:		//수정의 신탁소
		case	392:		//산호의 정원
		case	393:		//암운의 저택
		case	394:		//에메랄드 광장
		case	396:		//증기의길
		case	398:		//산호의 정원
		case	400:		//산호의 정원
		case	401:		//에메랄드 광장
		case	410:		//노르닐의 동굴
		case	412:		//노르닐의 정원
		case 443:		//지하 수용소
		case	452:		//지하 콜로세움
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
		case 459:		//지하 수용소
		case 460:		//카마로카
		case 461:		
		case 462:		
		case 463:		
		case 464:		
		case 465:		
		case 466:		//카마로카
		case 467:		// TTP 27672
		case 472:		//악마섬
		case 473:		//해적들의 터널
		case 474:		//크라테의 큐브
		case 475:		//크라테의 큐브
		case 476:		//크라테의 큐브
		case 490:
			return true;
		
		default:
			return false;
	}		
}

//방향 표시를 가릴 지역이면 true 리턴. 보여줄 지역이면 false 리턴
function bool IsHidePositionZone(int nZoneID)
{	
	switch(nZoneID)
	{
		//레이더를 멈출 곳들
		case 311:		// 올림피아드 경기장
		case 363:		//헬바운드
		case 364:		//헬바운드
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:
		case 379:		//강철의 성		//CT 1.5
		case 380:		//강철의 성		//CT 1.5
		case 381:		//강철의 성		//CT 1.5
		case 443:		//지하 수용소
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
			return true;
		
		default:
			return false;
	}		
}



//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
function OnShowPCCafeButton()
{
	if(!m_hPCCafeEventWndToggleButton.IsShowWindow())
	{
		m_hPCCafeEventWndToggleButton.ShowWindow();
	}
	
	if(!m_hPCCafeEventWndToggleButtonRingTex.IsShowWindow())
	{
		m_hPCCafeEventWndToggleButtonRingTex.ShowWindow();
	}
}

function OnShowNewVoteSystemButton()
{
	if(!m_hRecommendBonusWndToggleButton.IsShowWindow())
	{
		m_hRecommendBonusWndToggleButton.ShowWindow();
	}
	
	if(!m_hRecommendBonusToggleButtonRingTex.IsShowWindow())
	{
		m_hRecommendBonusToggleButtonRingTex.ShowWindow();
	}
}
//end of branch
defaultproperties
{
    m_WindowName="RadarMapWnd"
}
