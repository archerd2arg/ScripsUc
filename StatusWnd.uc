class StatusWnd extends UICommonAPI;


const	TIMER_ID1	=	1310;	
const 	TIMER_DELAY1	=	500;	
const	TIMER_ID2	= 	1311;
const	TIMER_DELAY2	=	20000;
//branch
const	TIMER_PREM1	= 1312;
const	TIMER_PREM_DELAY1	= 600;
const	TIMER_PREM2	= 1313;
const	TIMER_PREM_DELAY2	= 30000;
//end of branch

const 	ANIMMINALPHA	=	39;
const 	ANIMMAXALPHA	=	197;
//~ const	ANIMSPEED		=	15;
const	ANIMSPEEDFLOAT	=	0.40f;

var int m_UserID;
var bool m_bReceivedUserInfo;
var int GlobalAlpha;
var bool GlobalAlphaBool; 
var bool AnimTexKill;
var int m_Vitality;

//branch
var bool AnimTexKillPremium;
var int m_CurPremiumState;
var bool m_AlphaIncrese;
//end of branch

var WindowHandle Me;
var StatusBarHandle CPBar;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;
var StatusBarHandle EXPBar;
var NameCtrlHandle UserName;
var TextBoxHandle StatusWnd_LevelTextBox;
var TextureHandle VitalityTex;
var TextureHandle LifeForceAnimTex_Left;
var TextureHandle LifeForceAnimTex_Center;
var TextureHandle LifeForceAnimTex_Right;
var WindowHandle Statustooltipwnd;
var BarHandle VpDetailBar;					// 활력 퍼센트를 표시해주는 게이지 추가 by innowind 2008년 CT2_Final

var BarHandle barFATIGUE;
//~ var ButtonHandle LifeForceBtn;

// #ifdef CT26P2_0825
// 네비트의 강림 - 2010.7.8 winkey
var TextureHandle 		texNavitGaugeLeft;
var TextureHandle 		texNavitGaugeMid;
var TextureHandle		texNavitGaugeRight;
var int					m_NavitEffectRemainSec;
var int					m_NavitGradeEffectFactor;		// 단계 변화 시에 깜빡일 횟수, 소멸에 관여

const NAVIT_TIMER_ID2						= 7001;		// 네비트 발동 시 Gauge Effect에 사용하는 타이머
const NAVIT_TIMER_DELAY2					= 500;	
// #endif // CT26P2_0825

//branch
var WindowHandle LevelBoxTex;
var WindowHandle LevelBoxTexPremium;
//end of branch

function OnRegisterEvent()
{
	RegisterEvent( EV_RegenStatus );
	
	//Level과 Exp는 UserInfo패킷으로 처리한다.
	RegisterEvent( EV_UpdateUserInfo );
	
	RegisterEvent( EV_UpdateHP );
	RegisterEvent( EV_UpdateMaxHP );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMaxMP );
	RegisterEvent( EV_UpdateCP );
	RegisterEvent( EV_UpdateMaxCP );
	
	RegisterEvent( EV_VitalityPointInfo );	// 활력 업데이트
	
	// #ifdef CT26P2_0825
	// 네비트의 강림 - 2010.7.8 winkey
	RegisterEvent( EV_NavitAdventEffect );
	// #endif // CT26P2_0825
	
	//branch
	RegisterEvent( EV_BR_PREMIUM_STATE );
	//end of branch
}

//이벤트 등록
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	
	GlobalAlpha = 0;
	GlobalAlphaBool = true;
	m_Vitality = 6;
	VpDetailBar.SetValue(0, 0);
	InitAnimation();
	
	// #ifdef CT26P2_0825
	texNavitGaugeLeft.HideWindow();
	texNavitGaugeMid.HideWindow();
	texNavitGaugeRight.HideWindow();
	// #endif // CT26P2_0825
	
	//branch
	LevelBoxTexPremium.HideWindow();
	//end of branch
}

function InitHandle()
{
	Me = GetHandle( "StatusWnd" );
	CPBar = StatusBarHandle( GetHandle( "StatusWnd.CPBar" ) );
	HPBar = StatusBarHandle( GetHandle( "StatusWnd.HPBar" ) );
	MPBar = StatusBarHandle( GetHandle( "StatusWnd.MPBar" ) );
	EXPBar = StatusBarHandle( GetHandle( "StatusWnd.EXPBar" ) );
	UserName = NameCtrlHandle( GetHandle( "StatusWnd.UserName" ) );
	StatusWnd_LevelTextBox = TextBoxHandle( GetHandle( "StatusWnd.StatusWnd_LevelTextBox" ) );
	VitalityTex = TextureHandle (GetHandle ("StatusWnd.LifeForceTex") );
	LifeForceAnimTex_Left= TextureHandle (GetHandle ("StatusWnd.LifeForceAnimTex_Left"));
	LifeForceAnimTex_Center= TextureHandle (GetHandle ("StatusWnd.LifeForceAnimTex_Center"));
	LifeForceAnimTex_Right= TextureHandle (GetHandle ("StatusWnd.LifeForceAnimTex_Right"));
	Statustooltipwnd = GetHandle( "StatusWnd.Statustooltipwnd" );
	VpDetailBar = BarHandle ( GetHandle( "StatusWnd.VpDetailBar" ) );
	
	// #ifdef CT26P2_0825		
	texNavitGaugeLeft	= TextureHandle( GetHandle( "StatusWnd.NavitGaugeLeft" ) );
	texNavitGaugeMid	= TextureHandle( GetHandle( "StatusWnd.NavitGaugeMid" ) );
	texNavitGaugeRight	= TextureHandle( GetHandle( "StatusWnd.NavitGaugeRight" ) );
	// #endif // CT26P2_0825	
	
	//branch
	LevelBoxTex = GetHandle ("StatusWnd.StatusWnd_LevelTextBox_back");
	LevelBoxTexPremium = GetHandle ("StatusWnd.WndLevelBackPremium");
	//end of branch
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "StatusWnd" );
	CPBar = GetStatusBarHandle( "StatusWnd.CPBar" );
	HPBar = GetStatusBarHandle( "StatusWnd.HPBar" );
	MPBar = GetStatusBarHandle( "StatusWnd.MPBar" );
	EXPBar = GetStatusBarHandle( "StatusWnd.EXPBar" );
	UserName = GetNameCtrlHandle( "StatusWnd.UserName" );
	StatusWnd_LevelTextBox = GetTextBoxHandle( "StatusWnd.StatusWnd_LevelTextBox" );
	VitalityTex = GetTextureHandle ( "StatusWnd.LifeForceTex");
	LifeForceAnimTex_Left= GetTextureHandle ( "StatusWnd.LifeForceAnimTex_Left");
	LifeForceAnimTex_Center= GetTextureHandle ( "StatusWnd.LifeForceAnimTex_Center");
	LifeForceAnimTex_Right= GetTextureHandle ( "StatusWnd.LifeForceAnimTex_Right");
	Statustooltipwnd = GetWindowHandle( "StatusWnd.Statustooltipwnd");
	VpDetailBar = GetBarHandle( "StatusWnd.VpDetailBar" );
	
	// #ifdef CT26P2_0825	
	texNavitGaugeLeft	= GetTextureHandle( "StatusWnd.NavitGaugeLeft" );
	texNavitGaugeMid	= GetTextureHandle( "StatusWnd.NavitGaugeMid" );
	texNavitGaugeRight	= GetTextureHandle( "StatusWnd.NavitGaugeRight" );
	// #endif // CT26P2_0825
	
	//branch
	LevelBoxTex = GetWindowHandle ("StatusWnd.StatusWnd_LevelTextBox_back");
	LevelBoxTexPremium = GetWindowHandle ("StatusWnd.WndLevelBackPremium");
	//end of branch
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID1)
	{
		if (GlobalAlphaBool)
		{
			LifeForceAnimTex_Left.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
			LifeForceAnimTex_Center.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
			LifeForceAnimTex_Right.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
			GlobalAlphaBool = false;
		}
		else if (!GlobalAlphaBool)
		{
			 if (AnimTexKill)
			{
				Me.KillTimer( TIMER_ID1 );
				Me.KillTimer( TIMER_ID2 );
				LifeForceAnimTex_Left.SetAlpha(0, 1f);
				LifeForceAnimTex_Center.SetAlpha(0,1f);
				LifeForceAnimTex_Right.SetAlpha(0, 1f);
			}
			else
			{
				LifeForceAnimTex_Left.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
				LifeForceAnimTex_Center.SetAlpha(ANIMMINALPHA,ANIMSPEEDFLOAT);
				LifeForceAnimTex_Right.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
			}
			GlobalAlphaBool = true;
		}
	}
	if(TimerID == TIMER_ID2)
	{
		AnimTexKill = true;
		//~ Me.KillTimer( TIMER_ID1 );
		//~ Me.KillTimer( TIMER_ID2 );
	}
// #ifdef CT26P2_0825	
	if( TimerID == NAVIT_TIMER_ID2 )
	{
		OnTimerNavit();
	}
// #endif // CT26P2_0825

	//branch
	if (TimerID == TIMER_PREM1)
	{
		if (m_AlphaIncrese)
		{
			LevelBoxTexPremium.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
			m_AlphaIncrese = false;
		}
		else if (!m_AlphaIncrese)
		{
			if (AnimTexKillPremium)
			{
				Me.KillTimer( TIMER_PREM1 );
				Me.KillTimer( TIMER_PREM2 );
				LevelBoxTexPremium.SetAlpha(255, 1f);
			}
			else
			{
				LevelBoxTexPremium.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
			}
			m_AlphaIncrese = true;
		}	
	}
	if (TimerID == TIMER_PREM2)
	{
		AnimTexKillPremium = true;
		//debug("on timer TIMER_PREM2");
	}
	//end of branch
}

function PlayAnimation()
{
	Me.KillTimer( TIMER_ID1 );
	Me.KillTimer( TIMER_ID2 );	
	AnimTexKill = false;
	Me.SetTimer(TIMER_ID1,TIMER_DELAY1);
	Me.SetTimer(TIMER_ID2,TIMER_DELAY2);
}

//branch
function PlayAnimationPrem()
{
	Me.KillTimer( TIMER_PREM1 );
	Me.KillTimer( TIMER_PREM2 );	
	AnimTexKillPremium = false;
	Me.SetTimer(TIMER_PREM1,TIMER_PREM_DELAY1);
	Me.SetTimer(TIMER_PREM2,TIMER_PREM_DELAY2);
	m_AlphaIncrese = true;
}
//end of branch

function InitAnimation()
{
	Me.KillTimer( TIMER_ID1 );
	Me.KillTimer( TIMER_ID2 );	
	LifeForceAnimTex_Left.SetAlpha(0);
	LifeForceAnimTex_Center.SetAlpha(0);
	LifeForceAnimTex_Right.SetAlpha(0);
	//branch
	Me.KillTimer( TIMER_PREM1 );
	Me.KillTimer( TIMER_PREM2 );
	LevelBoxTexPremium.SetAlpha(1);	
	//end of branch
}

function OnEnterState( name a_PreStateName )
{
	m_bReceivedUserInfo = false;
	UpdateUserInfo();
}

function UpdateUserGauge( int Type )
{
	local UserInfo userinfo;

	if( GetPlayerInfo( userinfo ) )
	{
		m_UserID = userinfo.nID;
		
		switch( Type )
		{
		case 0:
			HPBar.SetPoint(userinfo.nCurHP,userinfo.nMaxHP);
		break;
		case 1:
			MPBar.SetPoint(userinfo.nCurMP,userinfo.nMaxMP);
		break;
		case 2:
			CPBar.SetPoint(userinfo.nCurCP,userinfo.nMaxCP);
		break;
		}
	}
}

function UpdateUserInfo()
{
	local UserInfo userinfo;
	local int Vitality;
	
	if( GetPlayerInfo( userinfo ) )
	{
		m_UserID = userinfo.nID;
		Vitality = userinfo.nVitality;
		CPBar.SetPoint(userinfo.nCurCP,userinfo.nMaxCP);
		HPBar.SetPoint(userinfo.nCurHP,userinfo.nMaxHP);
		MPBar.SetPoint(userinfo.nCurMP,userinfo.nMaxMP);
		EXPBar.SetPointExpPercentRate(userinfo.fExpPercentRate);
		UserName.SetName(userinfo.Name,NCT_Normal,TA_Left);
		StatusWnd_LevelTextBox.SetInt(userinfo.nLevel);
		
		if (Vitality != m_Vitality)
		{
			UpdateVp( Vitality );	// 활력 게이지를 업데이트 한다.		
		}
	}
}

function UpdateVp (int Vitality )
{
	local int now_vp_lv;
	local int pre_vp_lv;
	
	// 기존 값과 비교하여 VP 단계의 변화가 있을 경우 애니메이션을 플레이해준다. 
	now_vp_lv = LevelOfVitality(Vitality);
	pre_vp_lv = LevelOfVitality(m_Vitality);
	
	m_Vitality = Vitality;
	
	if(Vitality > 20000)
	{
		//debug("ERROR!! - Vitality can not be over 20000");
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_01");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		VpDetailBar.SetValue(0 , 0);
	}
	else if(Vitality >= 17000) 	//활력 4단계. 경험치 보너스 300%. 사이값 3000
	{
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_05");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"4",MakeFullSystemMsg(GetSystemMessage(2330),"300%",""))));
		VpDetailBar.SetValue(3000 ,Vitality - 17000); 
	}
	else if(Vitality >=13000)	// 활력 3단계. 경험치 보너스 250%. 사이값 4000
	{
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_04");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"3",MakeFullSystemMsg(GetSystemMessage(2330),"250%",""))));
		VpDetailBar.SetValue(4000 ,Vitality - 13000 ); 
	}
	else if(Vitality >= 2000)		//활력 2단계. 경험치 보너스 200%. 사이값 11000 
	{
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_03");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"2",MakeFullSystemMsg(GetSystemMessage(2330),"200%",""))));
		VpDetailBar.SetValue(11000 , Vitality - 2000 ); 
	}
	else if(Vitality >= 240)		//활력 1단계. 경험치 보너스 150%. 사이값 1760
	{
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_02");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"1",MakeFullSystemMsg(GetSystemMessage(2330),"150%",""))));
		VpDetailBar.SetValue(1760 , Vitality - 240); 
	}
	else	// 활력 0단계. 경험치 보너스 없음. 사이값 240.
	{
		VitalityTex.SetTexture("l2ui_ct1.LifeForce.Icon_df_LifeForce_StatusWnd_01");
		Statustooltipwnd.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		VpDetailBar.SetValue(240 , Vitality);
	}
	
	if(now_vp_lv != pre_vp_lv)	PlayAnimation();	// 레벨이 변경되었을 경우에는 반짝반짝 애니메이션을 틀어준다. 
}

//들어오는 활력 값에 따라 활력 레벨을 리턴해준다. 
function int LevelOfVitality ( int Vitality)
{
	if(Vitality > 20000)		return 0;			
	else if(Vitality >= 17000) 	return 4;	//활력 4단계. 경험치 보너스 300%. 
	else if(Vitality >= 13000)	return 3;	//활력 3단계. 경험치 보너스 250%.
	else if(Vitality >= 2000)		return 2;	//활력 2단계. 경험치 보너스 200%.
	else if(Vitality >= 240)		return 1;	//활력 1단계. 경험치 보너스 150%.
	else					return 0;	//활력 0단계. 경험치 보너스 없음.
}

//창 클릭했을때 타겟되기
function OnLButtonDown(WindowHandle a_WindowHandle, int X,int Y)
{
	local Rect rectWnd;
	
	switch (a_WindowHandle)
	{
		case CPBar:
		case HPBar:
		case MPBar:
		case EXPBar:
		case UserName:
		case StatusWnd_LevelTextBox:
		case VitalityTex:
		case LifeForceAnimTex_Left:
		case LifeForceAnimTex_Center:
		case LifeForceAnimTex_Right:
		case Statustooltipwnd:
// #ifdef CT26P2_0825		
		case texNavitGaugeLeft :
		case texNavitGaugeMid :
		case texNavitGaugeRight :
// #endif // CT26P2_0825		
			rectWnd = a_WindowHandle.GetRect();
			if (X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth)
			{
				RequestSelfTarget();
			}
		break;
		case Me:
			rectWnd = Me.GetRect();
			if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
			{
				RequestSelfTarget();
			}
		break;
	}
}

function OnEvent( int a_EventID, string a_Param )
{
	switch( a_EventID )
	{
	case EV_GamingStateExit:
		InitAnimation();
		m_Vitality = 6;
		break;
	case EV_UpdateUserInfo:
		UpdateUserInfo();
		break;
	case EV_UpdateHP:
		HandleUpdateGauge(a_Param,0);
		break;
	case EV_UpdateMaxHP:
		HandleUpdateGauge(a_Param,0);
		break;
	case EV_UpdateMP:
		HandleUpdateGauge(a_Param,1);
		break;
	case EV_UpdateMaxMP:
		HandleUpdateGauge(a_Param,1);
		break;
	case EV_UpdateCP:
		HandleUpdateGauge(a_Param,2);
		break;
	case EV_UpdateMaxCP:
		HandleUpdateGauge(a_Param,2);
		break;
	case EV_RegenStatus:
		HandleRegenStatus(a_Param);
		break;
	case EV_VitalityPointInfo:
		HandleVitalityPointInfo( a_Param);
		break;
		
	// #ifdef CT26P2_0825
	case EV_NavitAdventEffect:
		HandleNavitAdventEffect(a_Param);
		break;
	// #endif // CT26P2_0825
	//branch
	case EV_BR_PREMIUM_STATE:
		HandlePremiumState(a_Param);
		//debug("get EV_BR_PREMIUM_STATE");
		break;
	//end of branch
	default:
		break;
	}
}

// #ifdef CT26P2_0825
// 네비트의 강림 - 2010.7.8 winkey
function HandleNavitAdventEffect( String a_Param )
{
	ParseInt( a_Param, "RemainSeconds", m_NavitEffectRemainSec );
	
	if( m_NavitEffectRemainSec > 0 )
	{
		// play animation	
		m_NavitGradeEffectFactor = 0;
		Me.KillTimer( NAVIT_TIMER_ID2 );
		Me.SetTimer( NAVIT_TIMER_ID2, NAVIT_TIMER_DELAY2 );

		texNavitGaugeLeft.ShowWindow();
		texNavitGaugeMid.ShowWindow();
		texNavitGaugeRight.ShowWindow();
		texNavitGaugeLeft.SetAlpha( 0 );
		texNavitGaugeMid.SetAlpha( 0 );
		texNavitGaugeRight.SetAlpha( 0 );
	}
	else
	{
		Me.KillTimer( NAVIT_TIMER_ID2 );
		texNavitGaugeLeft.HideWindow();
		texNavitGaugeMid.HideWindow();
		texNavitGaugeRight.HideWindow();
	}
}

function OnTimerNavit()
{
	if( m_NavitGradeEffectFactor % 2 == 0 )
	{
		texNavitGaugeLeft.SetAlpha( ANIMMINALPHA, ANIMSPEEDFLOAT );
		texNavitGaugeMid.SetAlpha( ANIMMINALPHA, ANIMSPEEDFLOAT );
		texNavitGaugeRight.SetAlpha( ANIMMINALPHA, ANIMSPEEDFLOAT );
	}
	else
	{
		texNavitGaugeLeft.SetAlpha( ANIMMAXALPHA, ANIMSPEEDFLOAT );	
		texNavitGaugeMid.SetAlpha( ANIMMAXALPHA, ANIMSPEEDFLOAT );	
		texNavitGaugeRight.SetAlpha( ANIMMAXALPHA, ANIMSPEEDFLOAT );	
	}
	m_NavitGradeEffectFactor = m_NavitGradeEffectFactor + 1;
}

// #endif // CT26P2_0825






// 활력 수치만 업데이트
function HandleVitalityPointInfo( string param )
{
	local int nVitality;
	
	ParseInt( param, "Vitality", nVitality );
	
	UpdateVp( nVitality );	// 활력 게이지를 업데이트 한다.
}

//게이지만 업데이트
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	
	if( !m_bReceivedUserInfo )
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
	else
	{
		ParseInt( param, "ServerID", ServerID );
		if( m_UserID == ServerID )
			UpdateUserGauge( Type );
	}
}

//전체정보 업데이트
function HandleUpdateInfo(string param)
{
	local int ServerID;
	ParseInt( param, "ServerID", ServerID );
	
	//아직 User에 대한 정보를 받지못했다면, 무조건 Update를 실시한다.
	if (m_UserID == ServerID || !m_bReceivedUserInfo)
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
}

function HandleRegenStatus( String a_Param )
{
	local int type;
	local int duration;
	local int ticks;
	local float amount;

	ParseInt( a_Param, "Type", type );

	//type이 1일 경우 : HP 리젠상태를 보여줌 =>현재 1만 서버에서 보내줌
	if( type==1 )
	{
		ParseInt( a_Param, "Duration", duration );
		ParseInt( a_Param, "Ticks", ticks );
		ParseFloat( a_Param, "Amount", amount );
		HPBar.SetRegenInfo(duration,ticks,amount);
	}
}

//branch
function HandlePremiumState( String a_Param )
{
	local int premiumstate;
	ParseInt( a_Param, "PREMIUMSTATE", premiumstate );
	
	if (m_CurPremiumState == premiumstate)
		return;
		
	m_CurPremiumState = premiumstate;
	
	if (m_CurPremiumState == 1) {
		//LevelBoxTex.HideWindow();
		LevelBoxTexPremium.ShowWindow();
		PlayAnimationPrem();
	}
	else {
		//LevelBoxTex.ShowWindow();
		LevelBoxTexPremium.HideWindow();
		InitAnimation();
	}
}
//end of branch

defaultproperties
{
}
