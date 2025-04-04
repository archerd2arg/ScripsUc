class ExpBarWnd extends UICommonAPI;

const 	NAVIT_TIMER_ID_TOOLTIP		= 7000;						// 네비트 발동 시 툴팁에 사용하는 타이머
const 	NAVIT_TIMER_ID_ICON			= 7001;						// 네비트 발동 시 아이콘 애니메이션에 사용하는 타이머
const 	NAVIT_TIMER_ID_GAUGE		= 7002;						// 네비트 단계 변화 시 효과에 사용하는 타이머
const 	NAVIT_TIMER_DELAY_TOOLTIP	= 1000;	
const 	NAVIT_TIMER_DELAY_ICON		= 500;	
const 	NAVIT_TIMER_DELAY_GAUGE		= 500;	
const 	NAVIT_MAX_POINT				= 7200;						// 네비트 강림 효과 발동 포인트
const 	NAVIT_MAX_TIME				= 14400;					// 네비트 보너스 시간 최대치
const 	ANIM_MIN_ALPHA				= 39;
const 	ANIM_MAX_ALPHA				= 197;
const 	ANIM_SPEEDFLOAT				= 0.40f;

const TIMER_ID = 1050;                                            // ID (일정한 타이머 규칙은 없는듯, 없는 것을 검색해서 지정)
const TIMER_DELAY = 1000;  

const TIMER_ID_LF1 = 1051;
const TIMER_DELAY_LF1 = 500;

const TIMER_ID_LF2 = 1052;
const TIMER_DELAY_LF2 = 20000;

const TIMER_ID_IS_FOCUSED = 1053;                                            // ID (일정한 타이머 규칙은 없는듯, 없는 것을 검색해서 지정)
const TIMER_DELAY_IS_FOCUSED = 1000; 

const TIMER_ID_AUTO_CLEAN = 1054;

var WindowHandle Me;

var BarHandle		bar_ExpBar;
var BarHandle		bar_VitalityBar;

var TextBoxHandle	txt_ExpBarPercentValue;
var TextBoxHandle	txt_ExpBarInventoryValue;
var TextBoxHandle	txt_ExpBarAdenaValue;
var TextBoxHandle	txt_ExpBarAdenaHide;
var TextBoxHandle	txt_ExpBarPCValue;
var TextBoxHandle	txt_ExpBarPCChangeValue;

var TextBoxHandle	txt_ExpBarNavitProgress;

var TextBoxHandle	txt_ExpBarBonusExpValue;
var TextBoxHandle 	txt_ExpBarBonusTimerValue;

var TextBoxHandle	txt_ExpBarVitalityValue;
var TextureHandle	tex_ExpBarVitalityValue;

var TextBoxHandle	txt_ExpBarPartyValue;

var TextureHandle	tex_ExpBarNavitGauge;

var TextureHandle	tex_ExpBarNavitIcon;
var TextureHandle	tex_ExpBarNavitIconGlow;

var TextureHandle	tex_LFAnimLeft;
var TextureHandle	tex_LFAnimCenter;
var TextureHandle	tex_LFAnimRight;


var TextureHandle	tex_ExpPartyIconGlow;

var ButtonHandle	btn_ExpBarAdena;
var ButtonHandle	btn_ExpBarInventory;
var ButtonHandle	btn_ExpBarPartyMatch;
var ButtonHandle	btn_ExpBarMail;

var ButtonHandle	btn_ExpBarAutoCleanStart;
var ButtonHandle	btn_ExpBarAutoCleanStop;
var ButtonHandle	btn_ExpBarAutoCleanRefresh;
var ButtonHandle	btn_ExpBarAutoCleanValue;
var EditBoxHandle	edt_ExpBarAutoCleanValue;
var TextBoxHandle	txt_ExpBarAutoCleanValue;

var int m_Vitality;
var int currentRemainTimeValue;  
var int m_Navit_Level; 
var	int	m_NavitGaugeFactor;	
var	int	m_NavitIConFactor;
var int m_NavitEffectRemainSec;
var int IsPeaceZone;

var	bool m_bNavit;
var bool isHideAdena;

var bool GlobalAlphaBool; 
var bool AnimTexKill;

var	color		White, Red, Yellow, Orange;
var	int			autoCleanDelay, autoCleanRemaining;
var	bool		autoClean;

var string NavitProgressText;

//////////////////// AdenaExpometer Block///////////////// 
var INT64 AdenaSum,ExpSum;
var float exp,expprev, expstart, expshow, percentexp;
var int startLvl,currentLvl, counttimer;
var CustomTooltip TooltipAdena;
var array<INT64> adenatimer, exptimer;
var bool isFirst;
//////////////////// AdenaExpometer Block///////////////// 

function OnLoad ()
{
	local string temp;
	
	Me = GetWindowHandle("ExpBarWnd");
	
	bar_ExpBar = GetBarHandle("ExpBarWnd.barExpBar");
	bar_VitalityBar = GetBarHandle("ExpBarWnd.barVitalityBar");
	txt_ExpBarPercentValue = GetTextBoxHandle("ExpBarWnd.txtExpBarPercentValue");
	txt_ExpBarInventoryValue = GetTextBoxHandle("ExpBarWnd.txtExpBarInventoryValue");
	txt_ExpBarAdenaValue = GetTextBoxHandle("ExpBarWnd.txtExpBarAdenaValue");
	txt_ExpBarAdenaHide = GetTextBoxHandle("ExpBarWnd.txtExpBarAdenaHide");
	txt_ExpBarPCValue = GetTextBoxHandle("ExpBarWnd.txtExpBarPCValue");
	txt_ExpBarPCChangeValue = GetTextBoxHandle("ExpBarWnd.txtExpBarPCChangeValue");
	
	txt_ExpBarVitalityValue = GetTextBoxHandle("ExpBarWnd.txtExpBarVitalityValue");
	tex_ExpBarVitalityValue = GetTextureHandle("ExpBarWnd.texExpBarVitalityValue");
	
	tex_LFAnimLeft = GetTextureHandle("ExpBarWnd.texLFAnimLeft");
	tex_LFAnimCenter = GetTextureHandle("ExpBarWnd.texLFAnimCenter");
	tex_LFAnimRight = GetTextureHandle("ExpBarWnd.texLFAnimRight");	
	
	tex_ExpBarNavitGauge = GetTextureHandle("ExpBarWnd.texExpBarNavitGauge");
	tex_ExpBarNavitIconGlow = GetTextureHandle("ExpBarWnd.texExpBarNavitIconGlow");
	tex_ExpBarNavitIcon = GetTextureHandle("ExpBarWnd.texExpBarNavitIcon");
	
	txt_ExpBarNavitProgress = GetTextBoxHandle("ExpBarWnd.txtExpBarNavitProgress");
	
	txt_ExpBarPartyValue = GetTextBoxHandle("ExpBarWnd.txtExpBarPartyValue");
	
	txt_ExpBarBonusExpValue = GetTextBoxHandle("ExpBarWnd.txtExpBarBonusExpValue");
	txt_ExpBarBonusTimerValue = GetTextBoxHandle("ExpBarWnd.txtExpBarBonusTimerValue");
	
	tex_ExpPartyIconGlow = GetTextureHandle("ExpBarWnd.texExpPartyIconGlow");

	btn_ExpBarAdena = GetButtonHandle("ExpBarWnd.btnExpBarAdena");
	btn_ExpBarInventory = GetButtonHandle("ExpBarWnd.btnExpBarInventory");
	btn_ExpBarPartyMatch = GetButtonHandle("ExpBarWnd.btnExpBarPartyMatch");
	btn_ExpBarMail = GetButtonHandle("ExpBarWnd.btnExpBarMail");

	btn_ExpBarInventory.SetTooltipCustomType(MakeTooltipSimpleText("Inventory"));
	btn_ExpBarPartyMatch.SetTooltipCustomType(MakeTooltipSimpleText("Party"));
	btn_ExpBarMail.SetTooltipCustomType(MakeTooltipSimpleText("Mail"));
	
	btn_ExpBarAutoCleanStart = GetButtonHandle("ExpBarWnd.btnExpBarAutoCleanStart");
	btn_ExpBarAutoCleanStop = GetButtonHandle("ExpBarWnd.btnExpBarAutoCleanStop");
	btn_ExpBarAutoCleanRefresh = GetButtonHandle("ExpBarWnd.btnExpBarAutoCleanRefresh");
	btn_ExpBarAutoCleanValue = GetButtonHandle("ExpBarWnd.btnExpBarAutoCleanValue");
	edt_ExpBarAutoCleanValue = GetEditBoxHandle("ExpBarWnd.edtExpBarAutoCleanValue");
	txt_ExpBarAutoCleanValue = GetTextBoxHandle("ExpBarWnd.txtExpBarAutoCleanValue");
	
	btn_ExpBarAutoCleanStart.SetTooltipCustomType(MakeTooltipSimpleText("Start autoclean timer"));
	btn_ExpBarAutoCleanStop.SetTooltipCustomType(MakeTooltipSimpleText("Stop autoclean timer"));
	btn_ExpBarAutoCleanRefresh.SetTooltipCustomType(MakeTooltipSimpleText("Refresh autoclean timer"));
	btn_ExpBarAutoCleanValue.SetTooltipCustomType(MakeTooltipSimpleText("Change autoclean timer"));
	
	edt_ExpBarAutoCleanValue.HideWindow();
	btn_ExpBarAutoCleanStop.HideWindow();
	
	txt_ExpBarAdenaHide.HideWindow();

	tex_ExpBarNavitIconGlow.SetAlpha(0);
	tex_ExpBarNavitGauge.SetAlpha(0);
	tex_ExpPartyIconGlow.SetAlpha(0);

	InitAnimation();
	
	GlobalAlphaBool = true;
	
	m_Vitality = -1;
	m_Navit_Level = -1;
	m_NavitEffectRemainSec = -1;
	isHideAdena = false;
	
	autoClean = false;
	
	White.R = 255;
	White.G = 255;
	White.B = 255;	
	
	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	
	Yellow.R = 255;
	Yellow.G = 215;
	Yellow.B = 0;
	
	Orange.R = 255;
	Orange.G = 125;
	Orange.B = 0;	
	
	temp = "";
	GetINIString("AutoCleanMemory", "AutoCleanEnable", temp, "PatchSettings");
	if (temp == "True")
		autoClean = true;
	
	
	autoCleanDelay = 0;
	GetINIInt("AutoCleanMemory", "AutoCleanDelay", autoCleanDelay, "PatchSettings");
	if (autoCleanDelay == 0)
	{
		autoCleanDelay = 30;
		SetINIInt("AutoCleanMemory", "AutoCleanDelay", autoCleanDelay, "PatchSettings");
	}
	edt_ExpBarAutoCleanValue.SetString(string(autoCleanDelay));
	
}


function OnRegisterEvent ()
{
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_NavitAdventTimeChange);
	RegisterEvent(EV_NavitAdventEffect);
	RegisterEvent(EV_NavitAdventPointInfo);
	RegisterEvent(EV_ReceiveNewVoteSystemInfo);
	RegisterEvent(EV_SetRadarZoneCode);
	
	//////////////////// AdenaExpometer Block///////////////// 
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_SystemMessage);
	RegisterEvent(EV_GamingStateExit);
	RegisterEvent(EV_GamingStateEnter);
}


function OnEvent (int a_EventID, string a_Param)
{
	local UserInfo	info;
	local int i;
	
	switch (a_EventID)
	{
		case EV_UpdateUserInfo:
			UpdateUserInfo();
			//////////////////// AdenaExpometer Block///////////////// 
			GetPlayerInfo(info);		
			currentLvl = info.nLevel;						 
			if (expstart == -1) 
			{	 
				expstart = class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
				startLvl = info.nLevel;	
				expprev = expstart;
			}
			exp = class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
			expshow = exp - expstart;
			//////////////////// AdenaExpometer Block///////////////// 
			break;
		case EV_PCCafePointInfo:
			HandlePCCafePointInfo(a_Param);
			break;
			
		case EV_ReceiveNewVoteSystemInfo: 
			getDataByServer(a_param);
			break;
			
		case EV_NavitAdventPointInfo:
			HandleNavitPointInfo(a_Param);
			break;
			
		case EV_NavitAdventEffect:
			HandleNavitEffect(a_Param);
			break;
			
		case EV_NavitAdventTimeChange:
			HandleNavitTimeChange(a_Param);
			break;
			
		case EV_SetRadarZoneCode:
			ParseInt(a_Param, "ZoneCode", IsPeaceZone);		
			if (IsPeaceZone == 12)
			{
				IsPeaceZone = 1;
			}
			else
			{
				IsPeaceZone = 0;
			}
			break;
	
///////////////// AdenaExpometer Block///////////////// 
		case EV_GamingStateEnter:
				SetAutoCleanInfo();
				isFirst = true;
				counttimer = 0;
				percentexp = 0;
				for (i=0; i<40;++i)
				{
					exptimer[i]=IntToInt64(0);
				}
				AdenaSum = IntToInt64(0);
				ExpSum = IntToInt64(0);
				Me.SetTimer(1120,50);
			break;
					
			case EV_SystemMessage:
				HandleSystemmsg(a_Param);	
			break;
			
			case EV_GamingStateExit:
			case EV_Restart:	
				Me.KillTimer(1120);
				Me.KillTimer(TIMER_ID_AUTO_CLEAN);
				AdenaSum = IntToInt64(0);
				ExpSum = IntToInt64(0);		
				expshow = 0;
				expstart = -1;
			break;		
	}
}


function InitAnimation()
{
	Me.KillTimer(TIMER_ID_LF1);
	Me.KillTimer(TIMER_ID_LF2);	
	tex_LFAnimLeft.SetAlpha(0);
	tex_LFAnimCenter.SetAlpha(0);
	tex_LFAnimRight.SetAlpha(0);
}


function PlayAnimation()
{
	Me.KillTimer(TIMER_ID_LF1);
	Me.KillTimer(TIMER_ID_LF2);	
	AnimTexKill = false;
	Me.SetTimer(TIMER_ID_LF1,TIMER_DELAY_LF1);
	Me.SetTimer(TIMER_ID_LF2,TIMER_DELAY_LF2);
}


function OnClickButton( string a_strButtonName )
{
	local WindowHandle TaskWnd;
	local PartyMatchRoomWnd p2_script;
	
	switch( a_strButtonName )
	{
/////////////////////////
		case "btnExpBarPartyMatch":	
			p2_script = PartyMatchRoomWnd( GetScript( "PartyMatchRoomWnd" ) );
			TaskWnd = GetWindowHandle("PartyMatchRoomWnd");

			if (TaskWnd.IsShowWindow())
			{
				TaskWnd.HideWindow();
				
				TaskWnd = GetWindowHandle("PartyMatchWnd");

				p2_script.OnSendPacketWhenHiding();
				
				TaskWnd = GetWindowHandle("ChatWnd");

				TaskWnd.SetTimer(2992, 500);
			}
			else
			{
				TaskWnd = GetWindowHandle("PartyMatchWnd");
				class'PartyMatchAPI'.static.RequestOpenPartyMatch();
			}		
			break;
			
/////////////////////////	
		case "btnExpBarMail":
			TaskWnd = GetWindowHandle("PostBoxWnd");
			
			if( TaskWnd.isShowWindow())
			{
				TaskWnd.HideWindow();
			}
			else
			{
				RequestRequestReceivedPostList();
				if (IsPeaceZone == 0)
					AddSystemMessage(3066);
			}
			break;

///////////////////////
		case "btnExpBarInventory":
			if(IsShowWindow("InventoryWnd"))
			{
				HideWindow("InventoryWnd");
				PlaySound("InterfaceSound.inventory_close_01");
			}
			else
			{
				ExecuteEvent(EV_InventoryToggleWindow);
				PlaySound("InterfaceSound.inventory_open_01");
			}
			break;

///////////////////////
		case "btnExpBarAdena":
			if (isHideAdena)
			{
				isHideAdena = false;
				txt_ExpBarAdenaHide.HideWindow();
				txt_ExpBarAdenaValue.ShowWindow();
			}
			else
			{
				isHideAdena = true;
				txt_ExpBarAdenaValue.HideWindow();
				txt_ExpBarAdenaHide.ShowWindow();
			}
			break;
			

///////////////////////
		case "btnExpBarAutoCleanValue":
			btn_ExpBarAutoCleanValue.HideWindow();
			txt_ExpBarAutoCleanValue.HideWindow();
			edt_ExpBarAutoCleanValue.ShowWindow();
			edt_ExpBarAutoCleanValue.SetFocus();
			Me.SetTimer(TIMER_ID_IS_FOCUSED, 50);
			break;
			
		case "btnExpBarAutoCleanStop":
			OnClickAutoCleanStop();
			break;
			
		case "btnExpBarAutoCleanStart":
			OnClickAutoCleanStart();
			break;

		case "btnExpBarAutoCleanRefresh":
			if (autoClean)
			{
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("FLUSH");
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("OBJ GARBAGE");
				OnClickAutoCleanStart();
			}
			else
			{
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("FLUSH");
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("OBJ GARBAGE");
			}
			break;
	}
}


function getDataByServer (string param)
{ 
	local int voteCount;
	local int bonusCount;
	local int leftBonusTime;
	local int bonusRate;
	local int isOverTime;

	Parseint(Param, "voteCount", voteCount) ;
	Parseint(Param, "bonusCount", bonusCount) ;
	Parseint(Param, "leftBonusTime", leftBonusTime);
	Parseint(Param, "bonusRate", bonusRate);
	Parseint(Param, "isOverTime", isOverTime);


	Me.KillTimer(TIMER_ID);	
		
	UpdateTime(leftBonusTime);

	// 타이머 작동 
	if (isOverTime ==1 || leftBonusTime > 0 && isOverTime == 10 || isOverTime == 11) // TTP 41591
	{
		txt_ExpBarBonusTimerValue.SetText (GetSystemString(2275));
		txt_ExpBarBonusExpValue.SetText (bonusRate $ "%");
	}
	else 
	{
		if (0 < leftBonusTime)
		{
			txt_ExpBarBonusExpValue.SetText (bonusRate $ "%");
			currentRemainTimeValue = leftBonusTime;

			//  타이머 시작 		
			Me.SetTimer( TIMER_ID, TIMER_DELAY );
		}
		else
		{
			txt_ExpBarBonusExpValue.SetText ("0%");
		}
	}
}


function UpdateTime(int iRemainSecond)
{
	local int temp1;
	local int m_timeHour;
	local int m_timeMin;
	local int m_timeSec;

	temp1 = iRemainSecond / 60;
	
	m_timeHour = temp1 / 60;
	m_timeMin = temp1 % 60;	
	m_timeSec = iRemainSecond % 60;
	
	
	if(m_timeHour > 0)
	{
		if (m_timeHour < 10 )
			txt_ExpBarBonusTimerValue.setText( "0" $ string( m_timeHour ));
		else
			txt_ExpBarBonusTimerValue.setText( string( m_timeHour ));
	}
	else
	{
		txt_ExpBarBonusTimerValue.setText("00");
	}
	
	txt_ExpBarBonusTimerValue.SetText(txt_ExpBarBonusTimerValue.GetText() $ ":");


	if( m_timeMin > 0)
	{
		if (m_timeMin < 10 ) 
			txt_ExpBarBonusTimerValue.setText(txt_ExpBarBonusTimerValue.GetText() $ "0" $ string( m_timeMin ));
		else 
			txt_ExpBarBonusTimerValue.setText(txt_ExpBarBonusTimerValue.GetText() $ string( m_timeMin ));		
	}
	else
	{
		txt_ExpBarBonusTimerValue.setText(txt_ExpBarBonusTimerValue.GetText() $ "00");
	}
	
	if(m_timeHour <= 0 && m_timeMin <= 0 && m_timeSec <= 0)
	{
		me.KillTimer( TIMER_ID );
	}
	
	if (iRemainSecond <= 0)
	{
		txt_ExpBarBonusExpValue.SetText ("0%");
		txt_ExpBarBonusTimerValue.SetText(GetSystemString(908));
	}
}


function HandleNavitPointInfo( String a_Param )
{
	local int point;
	local int level;
	local int percent;
	
	
	ParseInt( a_Param, "NavitPoint", point );
	level = point / ( NAVIT_MAX_POINT / 12 );
	percent = ( point * 100.0 ) / NAVIT_MAX_POINT;

	if( percent > 100 ) percent = 100;

	if( !m_bNavit )
	{
		NavitProgressText = String( percent )$"%";
		txt_ExpBarNavitProgress.SetText(NavitProgressText);
		NavitGaugeChange( level, false );
	//	Navit_Tooltip_Gauge.SetTooltipCustomType( MakeTooltipSimpleText( 
	//		MakeFullSystemMsg( GetSystemMessage(3271), String( percent )$"%", "" ) ) );
	}
}

function HandleNavitEffect( String a_Param )
{
	ParseInt( a_Param, "RemainSeconds", m_NavitEffectRemainSec );
	
	if( m_NavitEffectRemainSec > 0 )
	{
		m_bNavit = true;
		NavitGaugeChange( 12, true );

		txt_ExpBarVitalityValue.SetText("300%");
		Me.KillTimer( NAVIT_TIMER_ID_TOOLTIP );
		Me.SetTimer( NAVIT_TIMER_ID_TOOLTIP, NAVIT_TIMER_DELAY_TOOLTIP );

		m_NavitIConFactor = 0;
		Me.KillTimer( NAVIT_TIMER_ID_ICON );
		Me.SetTimer( NAVIT_TIMER_ID_ICON, NAVIT_TIMER_DELAY_ICON );
	}
	else
	{
		m_bNavit = false;
		NavitGaugeChange( m_Navit_Level, true );
		
		if (m_Vitality > 20000)
			txt_ExpBarVitalityValue.SetText("0%");
		else if (m_Vitality > 17000)
			txt_ExpBarVitalityValue.SetText("300%");
		else if (m_Vitality > 13000)
			txt_ExpBarVitalityValue.SetText("250%");
		else if (m_Vitality > 2000)
			txt_ExpBarVitalityValue.SetText("200%");
		else if (m_Vitality > 240)
			txt_ExpBarVitalityValue.SetText("150%");
		else
			txt_ExpBarVitalityValue.SetText("0%");
		
		Me.KillTimer( NAVIT_TIMER_ID_TOOLTIP );
		Me.KillTimer( NAVIT_TIMER_ID_ICON );

		tex_ExpBarNavitIconGlow.SetAlpha( 0, ANIM_SPEEDFLOAT );
	}
}


function NavitGaugeChange( int level, bool forceChange )
{
	local string texName;

	if (level>12) level = 12;
	
	texName = "MonIcaEssence.ExpBarWnd.NevitPoint"$level;
	
	if ((forceChange == true) || (m_Navit_Level != level))
	{
			
		tex_ExpBarNavitGauge.SetTexture( texName );
		tex_ExpBarNavitGauge.SetAlpha(255);
		
		if( level != 0 && level != 12 )	
		{
			// play animation
			m_NavitGaugeFactor = 0;
			Me.KillTimer( NAVIT_TIMER_ID_GAUGE );
			Me.SetTimer( NAVIT_TIMER_ID_GAUGE, NAVIT_TIMER_DELAY_GAUGE );
		}
	}

	m_Navit_Level = level;
}

function HandleNavitTimeChange( String a_Param )
{
	local int bStart;
	local int navitTime;
	local string tooltip;

	ParseInt( a_Param, "bStart", bStart );
	ParseInt( a_Param, "navitTime", navitTime );
	
	if( navitTime > NAVIT_MAX_TIME )
	{
		tooltip = MakeFullSystemMsg( GetSystemMessage(3277), GetSystemString(908), "" );
		tex_ExpBarNavitIcon.SetTexture( "MonIcaEssence.ExpBarWnd.NevitIconB" );
	}
	else
	{
		if( bStart == 1 )
		{
			tooltip = MakeFullSystemMsg( GetSystemMessage(3277), NavitUpdateTime( NAVIT_MAX_TIME - navitTime ), "" );
			tex_ExpBarNavitIcon.SetTexture( "MonIcaEssence.ExpBarWnd.NevitIconN" );
		}
		else
		{
			tooltip = MakeFullSystemMsg( GetSystemMessage(3277), GetSystemString(2320), "" );
			tex_ExpBarNavitIcon.SetTexture( "MonIcaEssence.ExpBarWnd.NevitIconB" );
		}	
	}

	tex_ExpBarNavitIcon.SetTooltipCustomType( MakeTooltipSimpleText( tooltip ) );
}


function UpdateVitalityInfo (int Vitality )
{
	
	local int now_vp_lv;
	local int pre_vp_lv;
	
	now_vp_lv = LevelOfVitality(Vitality);
	pre_vp_lv = LevelOfVitality(m_Vitality);
	
	m_Vitality = Vitality;
	
	if( Vitality > 20000)
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_0");		
		//debug("ERROR!! - Vitality can not be over 20000");
		bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("0%");
		bar_VitalityBar.SetValue(0,0);
	}
	else if (Vitality >= 17000) 	//활력 4단계. 경험치 보너스 300%. 사이값 3000
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_4");
		bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"4",MakeFullSystemMsg(GetSystemMessage(2330),"300%",""))));
		bar_VitalityBar.SetValue(3000,Vitality-17000);
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("300%");
	}
	else if (Vitality >=13000)	// 활력 3단계. 경험치 보너스 250%. 사이값 4000
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_3");
        bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"3",MakeFullSystemMsg(GetSystemMessage(2330),"250%",""))));
        bar_VitalityBar.SetValue(4000,Vitality-13000);
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("250%");
	}
	else if (Vitality >= 2000)		//활력 2단계. 경험치 보너스 200%. 사이값 11000 
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_2");
        bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"2",MakeFullSystemMsg(GetSystemMessage(2330),"200%",""))));
        bar_VitalityBar.SetValue(11000,Vitality-2000);
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("200%");
	}
	else if(Vitality >= 240)		//활력 1단계. 경험치 보너스 150%. 사이값 1760
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_1");
        bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"1",MakeFullSystemMsg(GetSystemMessage(2330),"150%",""))));
        bar_VitalityBar.SetValue(1760,Vitality-240);
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("150%");
	}
	else	// 활력 0단계. 경험치 보너스 없음. 사이값 240.
	{
		tex_ExpBarVitalityValue.SetTexture("MonIcaEssence.ExpBarWnd.Vitality_Value_0");
        bar_VitalityBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
        bar_VitalityBar.SetValue(240,Vitality);
		if (!m_bNavit) txt_ExpBarVitalityValue.SetText("0%");
	}
	
	if(now_vp_lv != pre_vp_lv)	PlayAnimation();	
}


function int LevelOfVitality ( int Vitality)
{
	if (Vitality > 20000)
		return 0;			
	else if (Vitality >= 17000)
		return 4;	//활력 4단계. 경험치 보너스 300%. 
	else if (Vitality >= 13000)
		return 3;	//활력 3단계. 경험치 보너스 250%.
	else if (Vitality >= 2000)
		return 2;	//활력 2단계. 경험치 보너스 200%.
	else if (Vitality >= 240)
		return 1;	//활력 1단계. 경험치 보너스 150%.
	else 
		return 0;	//활력 0단계. 경험치 보너스 없음.
}


function OnEnterState( name a_PreStateName )
{	
	//txt_ExpBarPCValue.SetText("asd");
	expstart = -1;
	PartyIconBlink();
}

function HandlePCCafePointInfo( String a_Param )
{
	local int Show;
	local Color TextColor;
	local String AddPointText;
	local String FullPointText;		//CT26P4_0323
	local int nDailyHour;
	local int nDailyMin;
	local int PCCafeTotalPoint;
	local int m_AddPoint;
	local int m_PointType;
	local int m_DailyPoint;	
	
	ParseInt( a_Param, "Show", Show );
	if (Show == 0) return;
	
	m_AddPoint = 0;
	
	ParseInt( a_Param, "TotalPoint", PCCafeTotalPoint );
	ParseInt( a_Param, "AddPoint", m_AddPoint );
	ParseInt( a_Param, "PointType", m_PointType );
	ParseInt( a_Param, "DailyPoint", m_DailyPoint);		//CT26P4_0323
	
	FullPointText = MakeCostString(String(PCCafeTotalPoint));

	//CT26P4_0323
	if (m_DailyPoint > 0)	// idk??
	{
		nDailyMin = m_DailyPoint / 20;
		nDailyHour = nDailyMin / 60;
		nDailyMin = nDailyMin - nDailyHour * 60;
		//FullPointText = FullPointText $ " [" $ GetFormattedTimeStrMMHH(nDailyHour, nDailyMin) $ "]";
	}
	
	//txt_ExpBarPCValue.SetText(FullPointText);

	if( 0 != m_AddPoint)
	{
		txt_ExpBarPCChangeValue.SetAlpha(0);
		
		if( 0 < m_AddPoint )
			AddPointText = "+" $ MakeCostString(String(m_AddPoint));
		else
			AddPointText = MakeCostString(String(m_AddPoint));

		switch (m_PointType)
		{
			case 0:	// Normal
				TextColor.R = 255;
				TextColor.G = 255;
				TextColor.B = 0;
				break;
			case 1:	// Bonus
				TextColor.R = 0;
				TextColor.G = 255;
				TextColor.B = 255;
				break;
			case 2:	// Decrease
			case 3:	// Decrease (on rpg club when buy smthn)
				TextColor.R = 255;
				TextColor.G = 0;
				TextColor.B = 0;
				break;
		}
		
		txt_ExpBarPCChangeValue.SetText(AddPointText );
		txt_ExpBarPCChangeValue.SetTextColor(TextColor);
		txt_ExpBarPCChangeValue.SetAnchor( "ExpBarWnd.txtExpBarPCValue", "BottomRight", "BottomRight", 0, 0);
		txt_ExpBarPCChangeValue.ClearAnchor();
		txt_ExpBarPCChangeValue.Move(0, -38, 2.f);
		txt_ExpBarPCChangeValue.SetAlpha(255);
		txt_ExpBarPCChangeValue.SetAlpha(0, 1.8f);
	}
}


function UpdateUserInfo()
{
	local UserInfo userinfo;
	local int curExp;
	
	if (GetPlayerInfo(userinfo))
	{
		curExp =  int(userinfo.fExpPercentRate * 100);
		txt_ExpBarPercentValue.SetText(string(class'UIDATA_PlAYER'.static.GetPlayerEXPRate() * 100.d) $ "%");
		bar_ExpBar.SetValue(100, curExp);
		
		if (userinfo.nVitality != m_Vitality)
		UpdateVitalityInfo(userinfo.nVitality);
	}
}


function TimerNavitToolTip()
{
	if (m_NavitEffectRemainSec > 0)
		m_NavitEffectRemainSec = m_NavitEffectRemainSec - 1;
	
	NavitProgressText = String( m_NavitEffectRemainSec );
	txt_ExpBarNavitProgress.SetText(NavitProgressText);
}


function TimerNavitIconBlink()
{
	if( m_NavitIConFactor % 2 == 0 )
		tex_ExpBarNavitIconGlow.SetAlpha( ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT );
	else 
		tex_ExpBarNavitIconGlow.SetAlpha( ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT );

	m_NavitIConFactor = m_NavitIConFactor + 1;
}


function TimerNavitGaugeBlink()
{
	if (m_NavitGaugeFactor % 2 == 0)
		tex_ExpBarNavitGauge.SetAlpha( ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT );
	else
		tex_ExpBarNavitGauge.SetAlpha( ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT );
	
	if( m_NavitGaugeFactor > 16 )
	{
		Me.KillTimer( NAVIT_TIMER_ID_GAUGE );
		tex_ExpBarNavitGauge.SetAlpha( 255, ANIM_SPEEDFLOAT );
	}
	
	m_NavitGaugeFactor = m_NavitGaugeFactor + 1;
}


function string NavitUpdateTime( int RemainSec )
{
	local	int		Hour;
	local	int		Min;
	local	int		tmpSec;
	local	String	strTime;
	
	if( RemainSec > 0 )
	{
		// Convert Time
		tmpSec = RemainSec / 60;
		Min = tmpSec % 60;
		Hour = tmpSec / 60;
		

		if( Hour < 10 )	strTime = "0" $ String( Hour );
		else			strTime =		String( Hour );
		
		strTime = strTime $ ":";
		
		if( Min < 10 )	strTime = strTime $ "0" $ String( Min );
		else			strTime = strTime $ String( Min );
	}
	else
	{
		strTime = "00:00";
	}
	
	return strTime;
}


function PartyIconBlink()
{
	if (tex_ExpPartyIconGlow.GetAlpha() == 215)
	{
		tex_ExpPartyIconGlow.SetAlpha( 0, ANIM_SPEEDFLOAT );
	}
	else if( tex_ExpPartyIconGlow.GetAlpha() == 0 )
	{
		tex_ExpPartyIconGlow.SetAlpha( 215, ANIM_SPEEDFLOAT );
	}
	
	Me.KillTimer(686868);
	Me.SetTimer(686868, NAVIT_TIMER_DELAY_ICON);
//	m_PartyIConFactor = m_NavitIConFactor + 1;
}


function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;
	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));

	TaskWnd = GetWindowHandle("PartyMatchWnd");

	TaskWnd.HideWindow();
	
	p_script.OnSendPacketWhenHiding();
}


function OnTimer(int TimerID)
{
	local int a,b;
	
	switch (TimerID)
	{
		case TIMER_ID:
			currentRemainTimeValue = currentRemainTimeValue - 1;
			UpdateTime(currentRemainTimeValue);
			break;
			
		case NAVIT_TIMER_ID_TOOLTIP:
			TimerNavitToolTip();
			break;
			
		case NAVIT_TIMER_ID_ICON:
			TimerNavitIconBlink();
			break;
			
		case NAVIT_TIMER_ID_GAUGE:
			TimerNavitGaugeBlink();
			break;
			
		case 686868:
			PartyIconBlink();
			break;
			
		case 2992:
			ClosePartyMatchingWnd();
			Me.KillTimer(2992); 
			break;
			
		case 1120:
			exptimer[counttimer]=ExpSum;
			adenatimer[counttimer]=AdenaSum;	
			Me.KillTimer(1120);				
			counttimer=counttimer+1;
			if (counttimer==40) {counttimer=0; isFirst = false;}
			Me.SetTimer(1120,15000);		
			if (counttimer == 0) {a = 39; b = 38;}
			if (counttimer == 1) {a = 0; b = 39;} 
			if ((counttimer!=0) && (counttimer!=1)) {a = counttimer-1; b = counttimer-2;}		
			
			if ((exp>expprev) && (exptimer[a]>IntToInt64(0)) && (exptimer[b]>IntToInt64(0)))
			{						
				percentexp = (INT64toInt((exptimer[a] - exptimer[b]) ) /  (exp - expprev))/100; // 0,01
			}
			expprev = exp;
			InitAdenaInfoTooltip();
			break;
			
		case TIMER_ID_LF1:
			if (GlobalAlphaBool)
			{
				tex_LFAnimLeft.SetAlpha(ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT);
				tex_LFAnimCenter.SetAlpha(ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT);
				tex_LFAnimRight.SetAlpha(ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT);
				GlobalAlphaBool = false;
			}
			else if (!GlobalAlphaBool)
			{
				 if (AnimTexKill)
				{
					Me.KillTimer(TIMER_ID_LF1);
					Me.KillTimer(TIMER_ID_LF2);
					tex_LFAnimLeft.SetAlpha(0, 1f);
					tex_LFAnimCenter.SetAlpha(0,1f);
					tex_LFAnimRight.SetAlpha(0, 1f);
				}
				else
				{
					tex_LFAnimLeft.SetAlpha(ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT);
					tex_LFAnimCenter.SetAlpha(ANIM_MIN_ALPHA,ANIM_SPEEDFLOAT);
					tex_LFAnimRight.SetAlpha(ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT);
				}
				GlobalAlphaBool = true;
			}
			break;
			
		case TIMER_ID_LF2:
			AnimTexKill = true;
			break;
			
		case TIMER_ID_IS_FOCUSED:
			Me.KillTimer(TIMER_ID_IS_FOCUSED);
			if (edt_ExpBarAutoCleanValue.IsFocused())
			{
				Me.SetTimer(TIMER_ID_IS_FOCUSED, TIMER_DELAY_IS_FOCUSED);
			}
			else
			{
				CheckAutoCleanEdit();
			}
			break;
			
		case TIMER_ID_AUTO_CLEAN:
			autoCleanRemaining--;
			if (autoCleanRemaining < 0)
			{
				autoCleanRemaining = autoCleanDelay * 60;
				txt_ExpBarAutoCleanValue.SetTextColor(White);
			}
			SetCleanTime();
			if (autoCleanRemaining == 0)
			{
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("FLUSH");
				class'UIDATA_PAWNVIEWER'.static.ExecuteCommand("OBJ GARBAGE");
			}			
			break;
	}
}


function SetAutoCleanInfo()
{
	if (autoClean)
	{
		OnClickAutoCleanStart();
	}
	else
	{
		OnClickAutoCleanStop();
	}
}


function OnClickAutoCleanStart()
{
	Me.KillTimer(TIMER_ID_AUTO_CLEAN);
	autoClean = true;
	SetINIBool("AutoCleanMemory", "AutoCleanEnable", autoClean, "PatchSettings");
	txt_ExpBarAutoCleanValue.SetTextColor(White);
	btn_ExpBarAutoCleanStart.HideWindow();
	btn_ExpBarAutoCleanStop.ShowWindow();
	autoCleanRemaining = autoCleanDelay * 60;
	SetCleanTime();
	Me.SetTimer(TIMER_ID_AUTO_CLEAN, 1000);
}


function OnClickAutoCleanStop()
{
	Me.KillTimer(TIMER_ID_AUTO_CLEAN);
	autoClean = false;
	SetINIBool("AutoCleanMemory", "AutoCleanEnable", autoClean, "PatchSettings");
	txt_ExpBarAutoCleanValue.SetTextColor(White);
	btn_ExpBarAutoCleanStart.ShowWindow();
	btn_ExpBarAutoCleanStop.HideWindow();
	autoCleanRemaining = autoCleanDelay * 60;
	SetCleanTime();
}


function SetCleanTime()
{
	local int min;
	local int sec;
	
	local string pad;
	
	min = autoCleanRemaining / 60;
	sec = autoCleanRemaining % 60;
	
	if (sec < 10)
		pad = "0";
	else
		pad = "";
	
        txt_ExpBarAutoCleanValue.SetText(min $ ":" $ pad $ sec);
		
		if (autoCleanRemaining == 40)
            txt_ExpBarAutoCleanValue.SetTextColor(Yellow);
		else if (autoCleanRemaining == 20)
            txt_ExpBarAutoCleanValue.SetTextColor(Orange);
		else if (autoCleanRemaining == 10)
            txt_ExpBarAutoCleanValue.SetTextColor(Red);
}


function OnCompleteEditBox( String strID )
{
	switch( strID )
	{
		case "edtExpBarAutoCleanValue":
			Me.KillTimer(TIMER_ID_IS_FOCUSED);
			CheckAutoCleanEdit();
			break;
	}
}


function CheckAutoCleanEdit()
{
	edt_ExpBarAutoCleanValue.HideWindow();
	txt_ExpBarAutoCleanValue.ShowWindow();
	btn_ExpBarAutoCleanValue.ShowWindow();	

	if (int(edt_ExpBarAutoCleanValue.GetString()) >= 1)
	{
		autoCleanDelay = int(edt_ExpBarAutoCleanValue.GetString());
		SetINIInt("AutoCleanMemory", "AutoCleanDelay", autoCleanDelay, "PatchSettings");
	}
	else
	{
		edt_ExpBarAutoCleanValue.SetString(string(autoCleanDelay));
	}
				
	if (autoClean)
	{
		OnClickAutoCleanStart();
	}
	else
	{
		autoCleanRemaining = autoCleanDelay * 60;
		txt_ExpBarAutoCleanValue.SetTextColor(White);
		SetCleanTime();
	}
}


function InitAdenaInfoTooltip()
{
	TooltipAdena.DrawList.length = 14;

	TooltipAdena.DrawList[0].eType = DIT_TEXTURE;
	TooltipAdena.DrawList[0].nOffSetY = 5;
	TooltipAdena.DrawList[0].u_nTextureWidth = 18;
	TooltipAdena.DrawList[0].u_nTextureHeight = 13;
	TooltipAdena.DrawList[0].u_strTexture = "L2UI_CT1.Icon_DF_Common_Adena";
	
	TooltipAdena.DrawList[1].eType = DIT_TEXT;
	TooltipAdena.DrawList[1].nOffSetX = 20;
	TooltipAdena.DrawList[1].t_bDrawOneLine = true;
	TooltipAdena.DrawList[1].nOffSetY = 6;
	TooltipAdena.DrawList[1].t_color.R = 163;
	TooltipAdena.DrawList[1].t_color.G = 163;
	TooltipAdena.DrawList[1].t_color.B = 163;
	TooltipAdena.DrawList[1].t_color.A = 255;
	TooltipAdena.DrawList[1].t_strText = "all:";	
														
	TooltipAdena.DrawList[2].eType = DIT_TEXT;
	TooltipAdena.DrawList[2].nOffSetX = 10;
	TooltipAdena.DrawList[2].t_bDrawOneLine = true;
	TooltipAdena.DrawList[2].nOffSetY = 6;
	TooltipAdena.DrawList[2].t_strText = MakeCostString( Int64ToString(AdenaSum));		
		
	TooltipAdena.DrawList[3].eType = DIT_TEXT;
	TooltipAdena.DrawList[3].t_bDrawOneLine = true;
	TooltipAdena.DrawList[3].nOffSetY = 6;
	TooltipAdena.DrawList[3].t_strText ="  ";	
			
	TooltipAdena.DrawList[4].eType = DIT_TEXT;
	TooltipAdena.DrawList[4].bLineBreak = true;
	TooltipAdena.DrawList[4].nOffSetX = 13;
	TooltipAdena.DrawList[4].t_bDrawOneLine = true;
	TooltipAdena.DrawList[4].nOffSetY = 1;
	TooltipAdena.DrawList[4].t_color.R = 163;
	TooltipAdena.DrawList[4].t_color.G = 163;
	TooltipAdena.DrawList[4].t_color.B = 163;
	TooltipAdena.DrawList[4].t_color.A = 255;
	TooltipAdena.DrawList[4].t_strText = "10 min:";	
															
	TooltipAdena.DrawList[5].eType = DIT_TEXT;
	TooltipAdena.DrawList[5].t_bDrawOneLine = true;
	TooltipAdena.DrawList[5].nOffSetY = 1;
	TooltipAdena.DrawList[5].nOffSetX = 10;
	if (isFirst) 
	{
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString(adenatimer[39]));
		}
		else
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString(adenatimer[counttimer-1]));
		}	
	}
	else 
	{
		if (counttimer == 0) 
		{	
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString((adenatimer[39]) - adenatimer[counttimer] ));
		}
		else 
		{
			TooltipAdena.DrawList[5].t_strText = MakeCostString( Int64ToString((adenatimer[counttimer-1]) - adenatimer[counttimer] ));
		}
	
	}
	
	TooltipAdena.DrawList[6].eType = DIT_TEXTURE;
	TooltipAdena.DrawList[6].bLineBreak = true;
	TooltipAdena.DrawList[6].nOffSetY = 5;
	TooltipAdena.DrawList[6].nOffSetX = 2;
	TooltipAdena.DrawList[6].u_nTextureWidth = 14;
	TooltipAdena.DrawList[6].u_nTextureHeight = 14;
	TooltipAdena.DrawList[6].u_nTextureUWidth = 32;
	TooltipAdena.DrawList[6].u_nTextureUHeight = 32;
	TooltipAdena.DrawList[6].u_strTexture = "br_cashtex.item.br_cash_rune_of_exp_i00";
		
	TooltipAdena.DrawList[7].eType = DIT_TEXT;
	TooltipAdena.DrawList[7].nOffSetX = 22;
	TooltipAdena.DrawList[7].t_bDrawOneLine = true;
	TooltipAdena.DrawList[7].nOffSetY = 6;
	TooltipAdena.DrawList[7].t_color.R = 163;
	TooltipAdena.DrawList[7].t_color.G = 163;
	TooltipAdena.DrawList[7].t_color.B = 163;
	TooltipAdena.DrawList[7].t_color.A = 255;
	TooltipAdena.DrawList[7].t_strText = "all:";	
			
	TooltipAdena.DrawList[8].eType = DIT_TEXT;
	TooltipAdena.DrawList[8].nOffSetX = 10;
	TooltipAdena.DrawList[8].nOffSetY = 6;
	TooltipAdena.DrawList[8].t_bDrawOneLine = true;
	TooltipAdena.DrawList[8].t_strText = MakeCostString( Int64ToString(ExpSum));
	
	if ((expshow != 0) && (startLvl == currentLvl))
	{			
		TooltipAdena.DrawList[9].eType = DIT_TEXT;
		TooltipAdena.DrawList[9].t_bDrawOneLine = true;
		TooltipAdena.DrawList[9].nOffSetX = 2;
		TooltipAdena.DrawList[9].nOffSetY = 6;
		TooltipAdena.DrawList[9].t_color.R = 163;
		TooltipAdena.DrawList[9].t_color.G = 163;
		TooltipAdena.DrawList[9].t_color.B = 163;
		TooltipAdena.DrawList[9].t_color.A = 255;
		TooltipAdena.DrawList[9].t_strText = "  (" $ string(expshow) $ "%)";
	}
	else
	{
		TooltipAdena.DrawList[9].eType = DIT_TEXT;
		TooltipAdena.DrawList[9].t_bDrawOneLine = true;
		TooltipAdena.DrawList[9].nOffSetY = 6;
		TooltipAdena.DrawList[9].t_strText ="  ";
	}


	
	if ((startLvl < currentLvl) && (expstart !=0) ) 
	{
		TooltipAdena.DrawList[10].eType = DIT_TEXT;
		TooltipAdena.DrawList[10].t_bDrawOneLine = true;
		TooltipAdena.DrawList[10].t_color.R = 163;
		TooltipAdena.DrawList[10].t_color.G = 163;
		TooltipAdena.DrawList[10].t_color.B = 163;
		TooltipAdena.DrawList[10].t_color.A = 255;
		TooltipAdena.DrawList[10].nOffSetY = 6;
		TooltipAdena.DrawList[10].t_strText = string(startLvl) $ "(" $ string(expstart) $ "%)  ";
	}
	else
	{
		TooltipAdena.DrawList[10].nOffSetY = 6;
		TooltipAdena.DrawList[10].t_strText ="";
	}
	
	TooltipAdena.DrawList[11].eType = DIT_TEXT;
	TooltipAdena.DrawList[11].bLineBreak = true;
	TooltipAdena.DrawList[11].nOffSetX = 13;
	TooltipAdena.DrawList[11].t_bDrawOneLine = true;
	TooltipAdena.DrawList[11].t_color.R = 163;
	TooltipAdena.DrawList[11].t_color.G = 163;
	TooltipAdena.DrawList[11].t_color.B = 163;
	TooltipAdena.DrawList[11].t_color.A = 255;
	TooltipAdena.DrawList[11].t_strText = "10 min:";	
	
	TooltipAdena.DrawList[12].eType = DIT_TEXT;
	TooltipAdena.DrawList[12].t_bDrawOneLine = true;
	TooltipAdena.DrawList[12].nOffSetX = 10;
	
	if (isFirst) 
	{
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString(exptimer[39]));
		}
		else
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString(exptimer[counttimer-1]));
		}	
	}
	else 
	{
		if (counttimer == 0) 
		{	
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString((exptimer[39]) - exptimer[counttimer] ));
		}
		else 
		{
			TooltipAdena.DrawList[12].t_strText = MakeCostString( Int64ToString((exptimer[counttimer-1]) - exptimer[counttimer] ));
		}
	
	}
	
	if (percentexp>0)
	{	
		TooltipAdena.DrawList[13].eType = DIT_TEXT;
		TooltipAdena.DrawList[13].t_bDrawOneLine = true;
		TooltipAdena.DrawList[13].nOffSetX = 10;
		TooltipAdena.DrawList[13].t_color.R = 163;
		TooltipAdena.DrawList[13].t_color.G = 163;
		TooltipAdena.DrawList[13].t_color.B = 163;
		TooltipAdena.DrawList[13].t_color.A = 255;
		if (counttimer == 0) 
		{
			TooltipAdena.DrawList[13].t_strText = "(" $string(( (Int64ToInt(exptimer[39] - exptimer[counttimer]) / percentexp) / 100)) $"%)";
		}
		else
		{
			TooltipAdena.DrawList[13].t_strText = "(" $string(( (Int64ToInt(exptimer[counttimer-1] - exptimer[counttimer]) / percentexp) / 100)) $"%)";
		}
	}
	else
	{
		TooltipAdena.DrawList[13].t_strText = "";
	}

	btn_ExpBarAdena.SetTooltipCustomType(TooltipAdena);
}


function HandleSystemmsg(string param) 
{
	local int i;
    local int msg_idx;
    local int adenadrop;
	local int expgain;
	
	ParseInt(param, "Index", msg_idx);
	
	switch (msg_idx)
	{
		case 28:	//loot adena
		case 52:
			ParseInt(param, "Param1", adenadrop);
			AdenaSum = AdenaSum + IntToInt64(adenadrop);
			break;
			
		case 3259: // exp
			ParseInt(param, "Param1", expgain);
			ExpSum = ExpSum + IntToInt64(expgain);	
			break;	
			
		case 1269: // sub
		case 1270: 
			expstart = -1;	
			AdenaSum = IntToInt64(0);
			ExpSum = IntToInt64(0);		
			isFirst = true;
			counttimer = 0;
			percentexp = 0;
			for (i=0; i<40;++i)
			{
				exptimer[i]=IntToInt64(0);
				adenatimer[i]=IntToInt64(0);
			}
			break;	
	}
}


defaultproperties
{
}
