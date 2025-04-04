//class DetailStatusWnd extends UICommonAPI;
class DetailStatusWnd extends UIScriptEx;

const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;

var String m_WindowName;
var int m_UserID;
var HennaInfo m_HennaInfo;

//Handle
var TextBoxHandle txtSP;
var TextBoxHandle txtName1;
var TextBoxHandle txtName2;
var TextBoxHandle txtHeadPledge;
var TextBoxHandle txtPledge;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadRank;
var TextBoxHandle txtRank;
var StatusBarHandle texHP;
var StatusBarHandle texMP;
var StatusBarHandle texExp;
var StatusBarHandle texCP;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtGmMoving;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSTR;
var TextBoxHandle txtDEX;
var TextBoxHandle txtCON;
var TextBoxHandle txtINT;
var TextBoxHandle txtWIT;
var TextBoxHandle txtMEN;
var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtPVP;
var TextBoxHandle txtSociality;
var TextBoxHandle txtRemainSulffrage;
var TextureHandle texHero;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;

var TextBoxHandle txtAttrAttackType;
var TextBoxHandle txtAttrAttackValue;
var TextBoxHandle txtAttrDefenseValFire;
var TextBoxHandle txtAttrDefenseValWater;
var TextBoxHandle txtAttrDefenseValWind;
var TextBoxHandle txtAttrDefenseValEarth;
var TextBoxHandle txtAttrDefenseValHoly;
var TextBoxHandle txtAttrDefenseValUnholy;

function OnRegisterEvent()
{
	//Level과 Exp는 UserInfo패킷으로 처리한다.
	RegisterEvent( EV_UpdateUserInfo );
	RegisterEvent( EV_UpdateHennaInfo );
	
	RegisterEvent( EV_UpdateHP );
	RegisterEvent( EV_UpdateMaxHP );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMaxMP );
	RegisterEvent( EV_UpdateCP );
	RegisterEvent( EV_UpdateMaxCP );
	RegisterEvent( EV_ToggleDetailStatusWnd );
	
	RegisterEvent( EV_VitalityPointInfo );	// 활력 업데이트
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
}

function Initialize()
{
	txtSP = TextBoxHandle ( GetHandle( m_WindowName $ ".txtSP" ) );
	txtName1 = TextBoxHandle ( GetHandle( m_WindowName $ ".txtName1" ) );
	txtName2 = TextBoxHandle ( GetHandle( m_WindowName $ ".txtName2" ) );
	txtHeadPledge = TextBoxHandle ( GetHandle( m_WindowName $ ".txtHeadPledge" ) );
	txtPledge = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPledge" ) );
	txtLvHead = TextBoxHandle ( GetHandle( m_WindowName $ ".txtLvHead" ) );
	txtLvName = TextBoxHandle ( GetHandle( m_WindowName $ ".txtLvName" ) );
	txtHeadRank = TextBoxHandle ( GetHandle( m_WindowName $ ".txtHeadRank" ) );
	txtRank = TextBoxHandle ( GetHandle( m_WindowName $ ".txtRank" ) );
	texHP = StatusBarHandle ( GetHandle( m_WindowName $ ".texHP" ) );
	texMP = StatusBarHandle ( GetHandle( m_WindowName $ ".texMP" ) );
	texExp = StatusBarHandle ( GetHandle( m_WindowName $ ".texExp" ) );
	texCP = StatusBarHandle ( GetHandle( m_WindowName $ ".texCP" ) );
	txtPhysicalAttack = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPhysicalAttack" ) );
	txtPhysicalDefense = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPhysicalDefense" ) );
	txtHitRate = TextBoxHandle ( GetHandle( m_WindowName $ ".txtHitRate" ) );
	txtCriticalRate = TextBoxHandle ( GetHandle( m_WindowName $ ".txtCriticalRate" ) );
	txtPhysicalAttackSpeed = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPhysicalAttackSpeed" ) );
	txtMagicalAttack = TextBoxHandle ( GetHandle( m_WindowName $ ".txtMagicalAttack" ) );
	txtMagicDefense = TextBoxHandle ( GetHandle( m_WindowName $ ".txtMagicDefense" ) );
	txtPhysicalAvoid = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPhysicalAvoid" ) );
	txtGmMoving = TextBoxHandle ( GetHandle( m_WindowName $ ".txtGmMoving" ) );
	txtMovingSpeed = TextBoxHandle ( GetHandle( m_WindowName $ ".txtMovingSpeed" ) );
	txtMagicCastingSpeed = TextBoxHandle ( GetHandle( m_WindowName $ ".txtMagicCastingSpeed" ) );
	txtHeadMovingSpeed = TextBoxHandle ( GetHandle( m_WindowName $ ".txtHeadMovingSpeed" ) );
	txtHeadMagicCastingSpeed = TextBoxHandle ( GetHandle( m_WindowName $ ".txtHeadMagicCastingSpeed" ) );
	txtSTR = TextBoxHandle ( GetHandle( m_WindowName $ ".txtSTR" ) );
	txtDEX = TextBoxHandle ( GetHandle( m_WindowName $ ".txtDEX" ) );
	txtCON = TextBoxHandle ( GetHandle( m_WindowName $ ".txtCON" ) );
	txtINT = TextBoxHandle ( GetHandle( m_WindowName $ ".txtINT" ) );
	txtWIT = TextBoxHandle ( GetHandle( m_WindowName $ ".txtWIT" ) );
	txtMEN = TextBoxHandle ( GetHandle( m_WindowName $ ".txtMEN" ) );
	txtCriminalRate = TextBoxHandle ( GetHandle( m_WindowName $ ".txtCriminalRate" ) );
	txtPVP = TextBoxHandle ( GetHandle( m_WindowName $ ".txtPVP" ) );
	txtSociality = TextBoxHandle ( GetHandle( m_WindowName $ ".txtSociality" ) );
	txtRemainSulffrage = TextBoxHandle ( GetHandle( m_WindowName $ ".txtRemainSulffrage" ) );
	texHero = TextureHandle ( GetHandle( m_WindowName $ ".texHero" ) );
	texPledgeCrest = TextureHandle ( GetHandle( m_WindowName $ ".texPledgeCrest" ) );
	txtAttrAttackType = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrAttackType" ) );
	txtAttrAttackValue = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrAttackValue" ) );
	txtAttrDefenseValFire = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValFire" ) );
	txtAttrDefenseValWater = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValWater" ) );
	txtAttrDefenseValWind = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValWind" ) );
	txtAttrDefenseValEarth = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValEarth" ) );
	txtAttrDefenseValHoly = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValHoly" ) );
	txtAttrDefenseValUnholy = TextBoxHandle ( GetHandle( m_WindowName $ ".txtAttrDefenseValUnholy" ) );
	VitalityTex = TextureHandle (GetHandle ( m_WindowName $ ".LifeForceTex") );
}

function InitializeCOD()
{
	txtSP = GetTextBoxHandle( m_WindowName $ ".txtSP" );
	txtName1 = GetTextBoxHandle( m_WindowName $ ".txtName1" );
	txtName2 = GetTextBoxHandle( m_WindowName $ ".txtName2" );
	txtHeadPledge = GetTextBoxHandle( m_WindowName $ ".txtHeadPledge" );
	txtPledge = GetTextBoxHandle( m_WindowName $ ".txtPledge" );
	txtLvHead = GetTextBoxHandle( m_WindowName $ ".txtLvHead" );
	txtLvName = GetTextBoxHandle( m_WindowName $ ".txtLvName" );
	txtHeadRank = GetTextBoxHandle( m_WindowName $ ".txtHeadRank" );
	txtRank = GetTextBoxHandle( m_WindowName $ ".txtRank" );
	texHP = GetStatusBarHandle( m_WindowName $ ".texHP" );
	texMP = GetStatusBarHandle( m_WindowName $ ".texMP" );
	texExp = GetStatusBarHandle( m_WindowName $ ".texExp" );
	texCP = GetStatusBarHandle( m_WindowName $ ".texCP" );
	txtPhysicalAttack = GetTextBoxHandle( m_WindowName $ ".txtPhysicalAttack" );
	txtPhysicalDefense = GetTextBoxHandle( m_WindowName $ ".txtPhysicalDefense" );
	txtHitRate = GetTextBoxHandle( m_WindowName $ ".txtHitRate" );
	txtCriticalRate = GetTextBoxHandle( m_WindowName $ ".txtCriticalRate" );
	txtPhysicalAttackSpeed = GetTextBoxHandle( m_WindowName $ ".txtPhysicalAttackSpeed" );
	txtMagicalAttack = GetTextBoxHandle( m_WindowName $ ".txtMagicalAttack" );
	txtMagicDefense = GetTextBoxHandle( m_WindowName $ ".txtMagicDefense" );
	txtPhysicalAvoid = GetTextBoxHandle( m_WindowName $ ".txtPhysicalAvoid" );
	txtGmMoving = GetTextBoxHandle( m_WindowName $ ".txtGmMoving" );
	txtMovingSpeed = GetTextBoxHandle( m_WindowName $ ".txtMovingSpeed" );
	txtMagicCastingSpeed = GetTextBoxHandle( m_WindowName $ ".txtMagicCastingSpeed" );
	txtHeadMovingSpeed = GetTextBoxHandle( m_WindowName $ ".txtHeadMovingSpeed" );
	txtHeadMagicCastingSpeed = GetTextBoxHandle( m_WindowName $ ".txtHeadMagicCastingSpeed" );
	txtSTR = GetTextBoxHandle( m_WindowName $ ".txtSTR" );
	txtDEX = GetTextBoxHandle( m_WindowName $ ".txtDEX" );
	txtCON = GetTextBoxHandle( m_WindowName $ ".txtCON" );
	txtINT = GetTextBoxHandle( m_WindowName $ ".txtINT" );
	txtWIT = GetTextBoxHandle( m_WindowName $ ".txtWIT" );
	txtMEN = GetTextBoxHandle( m_WindowName $ ".txtMEN" );
	txtCriminalRate = GetTextBoxHandle( m_WindowName $ ".txtCriminalRate" );
	txtPVP = GetTextBoxHandle( m_WindowName $ ".txtPVP" );
	txtSociality = GetTextBoxHandle( m_WindowName $ ".txtSociality" );
	txtRemainSulffrage = GetTextBoxHandle( m_WindowName $ ".txtRemainSulffrage" );
	texHero = GetTextureHandle( m_WindowName $ ".texHero" );
	texPledgeCrest = GetTextureHandle( m_WindowName $ ".texPledgeCrest" );
	txtAttrAttackType = GetTextBoxHandle( m_WindowName $ ".txtAttrAttackType" );
	txtAttrAttackValue = GetTextBoxHandle( m_WindowName $ ".txtAttrAttackValue" );
	txtAttrDefenseValFire = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValFire" );
	txtAttrDefenseValWater = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValWater" );
	txtAttrDefenseValWind = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValWind" );
	txtAttrDefenseValEarth = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValEarth" );
	txtAttrDefenseValHoly = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValHoly" );
	txtAttrDefenseValUnholy = GetTextBoxHandle( m_WindowName $ ".txtAttrDefenseValUnholy" );
	VitalityTex = GetTextureHandle( m_WindowName $ ".LifeForceTex") ;
}

function OnEnterState( name a_PreStateName )
{
	HandleUpdateUserInfo();
}

function OnShow()
{
	HandleUpdateUserInfo();
	//~ debug ("ㅏ보이는 중");
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdateUserInfo)
	{
		HandleUpdateUserInfo();
	}
	else if (Event_ID == EV_UpdateHennaInfo)
	{
		HandleUpdateHennaInfo(param);
	}
	else if (Event_ID == EV_UpdateHP)
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if (Event_ID == EV_UpdateMaxHP)
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		HandleUpdateStatusGauge(param,1);
	}
	else if (Event_ID == EV_UpdateMaxMP)
	{
		HandleUpdateStatusGauge(param,1);
	}
	else if (Event_ID == EV_UpdateCP)
	{
		HandleUpdateStatusGauge(param,2);
	}
	else if (Event_ID == EV_UpdateMaxCP)
	{
		HandleUpdateStatusGauge(param,2);
	}
	else if(Event_ID == EV_ToggleDetailStatusWnd )
	{
		HandleToggle();
	}
	else if(Event_ID == EV_VitalityPointInfo)	// 활력 정보 업데이트
	{
		HandleVitalityPointInfo( param);
	}
	//~ else if (Event_ID == EV_ShowWindow)
	//~ {
		//~ if (param == DetailStatusWnd)
		//~ {
			//~ ToggleOpenCharInfoWnd();
		//~ }
	//~ }
}

function HandleToggle()
{
	if( m_hOwnerWnd.IsShowWindow() )
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
}

//~ function ToggleOpenCharInfoWnd()
//~ {
	//~ if(DetailStatusWnd.IsShowWindow() == true)
	//~ {
		//~ HideWindow("DetailStatusWnd");
		//~ PlaySound("InterfaceSound.charstat_close_01");
	//~ }
	//~ else
	//~ {
		//~ ShowWindowWithFocus("DetailStatusWnd");
		//~ PlaySound("InterfaceSound.charstat_open_01");			
	//~ }
//~ }

//게이지만 업데이트
function HandleUpdateStatusGauge(string param, int Type)
{
	local int ServerID;
	
	if( m_hOwnerWnd.IsShowWindow() )	// lpislhy
	{
		ParseInt( param, "ServerID", ServerID );
		if( m_UserID == ServerID )
			HandleUpdateUserGauge( Type );
	}
}

//플레이어의 문양 정보 처리
function HandleUpdateHennaInfo(string param)
{
	ParseInt(param, "HennaID", m_HennaInfo.HennaID);
	ParseInt(param, "ClassID", m_HennaInfo.ClassID);
	ParseInt(param, "Num", m_HennaInfo.Num);
	ParseInt(param, "Fee", m_HennaInfo.Fee);
	ParseInt(param, "CanUse", m_HennaInfo.CanUse);
	ParseInt(param, "INTnow", m_HennaInfo.INTnow);
	ParseInt(param, "INTchange", m_HennaInfo.INTchange);
	ParseInt(param, "STRnow", m_HennaInfo.STRnow);
	ParseInt(param, "STRchange", m_HennaInfo.STRchange);
	ParseInt(param, "CONnow", m_HennaInfo.CONnow);
	ParseInt(param, "CONchange", m_HennaInfo.CONchange);
	ParseInt(param, "MENnow", m_HennaInfo.MENnow);
	ParseInt(param, "MENchange", m_HennaInfo.MENchange);
	ParseInt(param, "DEXnow", m_HennaInfo.DEXnow);
	ParseInt(param, "DEXchange", m_HennaInfo.DEXchange);
	ParseInt(param, "WITnow", m_HennaInfo.WITnow);
	ParseInt(param, "WITchange", m_HennaInfo.WITchange);
}

function bool GetMyUserInfo( out UserInfo a_MyUserInfo )
{
	return GetPlayerInfo( a_MyUserInfo );
}

function String GetMovingSpeed( UserInfo a_UserInfo )
{
	local float MovingSpeed;
	local EMoveType	MoveType;
	local EEnvType	EnvType;

	// Moving Speed
	MoveType			= class'UIDATA_PLAYER'.static.GetPlayerMoveType();
	EnvType				= class'UIDATA_PLAYER'.static.GetPlayerEnvironment();

	debug("MovingSpeed : STEP 1" $a_UserInfo.fNonAttackSpeedModifier);
	if (MoveType == MVT_FAST)
	{
		MovingSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
		debug("MovingSpeed : STEP 2" $a_UserInfo.nGroundMaxSpeed);
		switch (EnvType)
		{
		case ET_UNDERWATER:
			MovingSpeed = float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			debug("MovingSpeed : STEP 3"$a_UserInfo.nWaterMaxSpeed );
			break;
		case ET_AIR:
			MovingSpeed = float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			debug("MovingSpeed : STEP 4" $a_UserInfo.nAirMaxSpeed $"  " $a_UserInfo.fNonAttackSpeedModifier);
			break;
		}
	}
	else if (MoveType == MVT_SLOW)
	{
		MovingSpeed = float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
		debug("MovingSpeed : STEP 5" );
		switch (EnvType)
		{
		case ET_UNDERWATER:
			MovingSpeed = float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			debug("MovingSpeed : STEP 6" $a_UserInfo.nWaterMinSpeed);
			break;
		case ET_AIR:
			MovingSpeed = float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			debug("MovingSpeed : STEP 7" $a_UserInfo.nAirMinSpeed);
			break;
		}
	}
	debug("MovingSpeed : STEP 8 : " $ MovingSpeed);
	return String( int(MovingSpeed));
}

function float GetMyExpRate()
{
	return class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
}

//플레이어 게이지 정보 처리
function HandleUpdateUserGauge( int Type )
{
	local int CurValue;
	local int MaxValue;
	local UserInfo info;
	
	if (GetMyUserInfo(info))
	{
		m_UserID = info.nID;
		
		switch( Type )
		{
		case 0:
			CurValue = info.nCurHP;
			MaxValue = info.nMaxHP;
			UpdateHPBar(CurValue, MaxValue);
		break;
		case 1:
			CurValue = info.nCurMP;
			MaxValue = info.nMaxMP;
			UpdateMPBar(CurValue, MaxValue);
		break;
		case 2:
			CurValue = info.nCurCP;
			MaxValue = info.nMaxCP;
			UpdateCPBar(CurValue, MaxValue);
		break;
		}
	}
}

//플레이어 정보 처리
function HandleUpdateUserInfo()
{
	if( m_hOwnerWnd.IsShowWindow() )	// lpislhy
		UpdateInterface();
}

function UpdateInterface()
{
	local Rect rectWnd;
	local int Width1;
	local int Height1;
	local int Width2;
	local int Height2;
	
	local string	Name;
	local string	NickName;
	local color	NameColor;
	local color	NickNameColor;
	local int		SubClassID;
	local string	ClassName;
	local string	UserRank;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		CP;
	local int		MaxCP;
	local int		SP;
	local int		Level;
	local float		fExpRate;
	
	local int		PledgeID;
	local string	PledgeName;
	local texture	PledgeCrestTexture;
	local bool		bPledgeCrestTexture;
	local color	PledgeNameColor;
	
	local string	HeroTexture;
	local bool		bHero;
	local bool		bNobless;
	
	local int		nSTR;
	local int		nDEX;
	local int		nCON;
	local int		nINT;
	local int		nWIT;
	local int		nMEN;
	local string	strTmp;
	
	local int		PhysicalAttack;
	local int		PhysicalDefense;
	local int		HitRate;
	local int		CriticalRate;
	local int		PhysicalAttackSpeed;
	local int		MagicalAttack;
	local int		MagicDefense;
	local int		PhysicalAvoid;
	local String	MovingSpeed;
	local int		MagicCastingSpeed;
	
	local int		CriminalRate;
	local int		CrimRate;
	local string	strCriminalRate;
	local int		DualCount;
	local int		PKCount;
	local int		PvPPoint;
	
	local int		Sociality;
	local int		RemainSulffrage;
	
	
	// 속성 수치 
	local int AttrAttackType;
	local int AttrAttackValue;
	local int AttrDefenseValFire;
	local int AttrDefenseValWater;
	local int AttrDefenseValWind;
	local int AttrDefenseValEarth;
	local int AttrDefenseValHoly;
	local int AttrDefenseValUnholy;
	local string AttrAttackTypeTxt;
	
	//변신 관련 데이터
	local int nTransformID;
	local bool m_bPawnChanged;
	
	local UserInfo	info;
	
	//활력 
	local int Vitality;
	
	//초기화
	texPledgeCrest.SetTexture("");
	rectWnd = m_hOwnerWnd.GetRect();
	
	if (GetMyUserInfo(info))
	{
		m_UserID = info.nID;
		
		Name = info.Name;
		NickName = info.strNickName;
		SubClassID = info.nSubClass;
		ClassName = GetClassType(SubClassID);
		SP = info.nSP;
		Level = info.nLevel;
		UserRank = GetUserRankString(info.nUserRank);
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		CP = info.nCurCP;
		MaxCP = info.nMaxCP;
		fExpRate = GetMyExpRate();
		
		PledgeID = info.nClanID;
		bHero = info.bHero;
		bNobless = info.bNobless;
		
		//플레이어 상세 정보
		nSTR	= info.nStr;
		nDEX	= info.nDex;
		nCON	= info.nCon;
		nINT		= info.nInt;
		nWIT		= info.nWit;
		nMEN	= info.nMen;
		
		PhysicalAttack			= info.nPhysicalAttack;
		PhysicalDefense		= info.nPhysicalDefense;
		HitRate				= info.nHitRate;
		CriticalRate			= info.nCriticalRate;
		PhysicalAttackSpeed	= info.nPhysicalAttackSpeed;
		MagicalAttack			= info.nMagicalAttack;
		MagicDefense			= info.nMagicDefense;
		PhysicalAvoid			= info.nPhysicalAvoid;
		MagicCastingSpeed		= info.nMagicCastingSpeed;
		
		MovingSpeed = GetMovingSpeed( info );
		
		CriminalRate		= info.nCriminalRate;
		DualCount		= info.nDualCount;
		PKCount			= info.nPKCount;
		PvPPoint			= info.PvPPoint;
		Sociality			= info.nSociality;
		RemainSulffrage	= info.nRemainSulffrage;
		
		Vitality = info.nVitality;
		
		if (CriminalRate>=999999)
		{
			strCriminalRate = CriminalRate $ "+";
		}
		else
		{
			strCriminalRate = CriminalRate $ "";
		}
		
		//속성정보 세팅
		
		AttrAttackType = info.AttrAttackType;
		//debug( "속성 타입 번호" @ info.AttrAttackType);
		AttrAttackValue= info.AttrAttackValue;
		AttrDefenseValFire = info.AttrDefenseValFire;
		AttrDefenseValWater = info.AttrDefenseValWater;
		AttrDefenseValWind = info.AttrDefenseValWind;
		AttrDefenseValEarth = info.AttrDefenseValEarth;
		AttrDefenseValHoly = info.AttrDefenseValHoly;
		AttrDefenseValUnholy = info.AttrDefenseValUnholy;

		//변신 정보 세팅
		nTransformID = info.nTransformID;
		m_bPawnChanged = info.m_bPawnChanged;
		

		
		//~ debug ("속성정보: " @ AttrAttackType );
		//~ debug ("속성정보: " @  AttrAttackValue);
		//~ debug ("속성정보: " @  AttrDefenseValFire);
		//~ debug ("속성정보: " @  AttrDefenseValWater );
		//~ debug ("속성정보: " @  AttrDefenseValWind );
		//~ debug ("속성정보: " @ AttrDefenseValEarth );
		//~ debug ("속성정보: " @ AttrDefenseValHoly );
		//~ debug ("속성정보: " @ AttrDefenseValUnholy);
		
		Switch(AttrAttackType)
		{
			case -2:
				AttrAttackTypeTxt = GetSystemString(27);
				break;
			case 0:
				AttrAttackTypeTxt = GetSystemString(1630);
				break;
			case 1:
				AttrAttackTypeTxt = GetSystemString(1631);
				break;
			case 2:
				AttrAttackTypeTxt = GetSystemString(1632);
				break;
			case 3:
				AttrAttackTypeTxt = GetSystemString(1633);
				break;
			case 4:
				AttrAttackTypeTxt = GetSystemString(1634);
				break;
			case 5:
				AttrAttackTypeTxt = GetSystemString(1635);
				break;
		}
		
		//debug ("활력도:" @ Vitality);
		UpdateVp (Vitality );
		
		//~ switch(Vitality)
		//~ {
			//~ case 0:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_01");
			//~ break;
			//~ case 1:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_02");
			//~ break;
			//~ case 2:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_03");
			//~ break;
			//~ case 3:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_04");
			//~ break;
			//~ case 4:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_05");
			//~ break;
			//~ case 5:
			//~ VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_01");
			//~ break;
		//~ }
	}     
	
	//닉네임,네임 색상 설정
	CrimRate = CriminalRate;
	if (CrimRate > 255)
	{
		CrimRate = 255;
	}
	if (CrimRate > 0)
	{
		CrimRate = Clamp(CrimRate, (100 + (CrimRate/16)), 255);
	}
	NameColor.R = 255;
	NameColor.G = 255 - CrimRate;
	NameColor.B = 255 - CrimRate;
	NameColor.A = 255;
	NickNameColor.R = 162;
	NickNameColor.G = 249;
	NickNameColor.B = 236;
	NickNameColor.A = 255;
	
	if (Len(NickName)>0)
	{
		GetTextSizeDefault(Name, Width1, Height1);
		GetTextSizeDefault(NickName, Width2, Height2);
		if (Width1 + Width2 > 220)
		{
			if (Width1 > 109)
			{
				Name = Left(Name, 8);
				GetTextSizeDefault(Name, Width1, Height1);
			}
			if (Width2 > 109)
			{
				NickName = Left(NickName, 8);
				GetTextSizeDefault(NickName, Width2, Height2);
			}
		}
		txtName1.SetText(NickName);
		txtName1.SetTextColor(NickNameColor);
		txtName2.SetText(Name);
		txtName2.SetTextColor(NameColor);
		txtName2.MoveTo(rectWnd.nX + 15 + Width2 + 6, rectWnd.nY +41);
			//~ debug("음..:rectWnd: " @ rectWnd.nY  );
	}
	else
	{
		txtName1.SetText(Name);
		txtName1.SetTextColor(NameColor);
		txtName2.SetText("");
	}
	
	txtLvName.SetText(Level $ " " $ ClassName);
	txtRank.SetText(UserRank);
	txtSP.SetText(string(SP));
	
	//혈맹
	if (PledgeID>0)
	{
		//텍스쳐
		bPledgeCrestTexture = class'UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
		PledgeName = class'UIDATA_CLAN'.static.GetName(PledgeID);
		PledgeNameColor.R = 176;
		PledgeNameColor.G = 155;
		PledgeNameColor.B = 121;
		PledgeNameColor.A = 255;
	}
	else
	{
		PledgeName = GetSystemString(431);
		PledgeNameColor.R = 255;
		PledgeNameColor.G = 255;
		PledgeNameColor.B = 255;
		PledgeNameColor.A = 255;
	}
	txtPledge.SetText(PledgeName);
	txtPledge.SetTextColor(PledgeNameColor);
	if (bPledgeCrestTexture)
	{
		texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
		txtPledge.MoveTo(rectWnd.nX + 88, rectWnd.nY + 25 + 35);
	}
	else
	{
		txtPledge.MoveTo(rectWnd.nX + 68, rectWnd.nY + 25 + 35);
	}
	
	//영웅,노블레스
	if (bHero)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";
	}
	else if (bNobless)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";
	}
	texHero.SetTexture(HeroTexture);
	
	//상세 정보
	if (m_HennaInfo.STRchange > 0)
	{
		strTmp = nSTR $ "(+" $ m_HennaInfo.STRchange $ ")";
	}
	else if (m_HennaInfo.STRchange < 0)
	{
		strTmp = nSTR $ "(" $ m_HennaInfo.STRchange $ ")";
	}
	else
	{
		strTmp = string(nSTR);
	}
	txtSTR.SetText(strTmp);
	
	if (m_HennaInfo.DEXchange > 0)
	{
		strTmp = nDEX $ "(+" $ m_HennaInfo.DEXchange $ ")";
	}
	else if (m_HennaInfo.DEXchange < 0)
	{
		strTmp = nDEX $ "(" $ m_HennaInfo.DEXchange $ ")";
	}
	else
	{
		strTmp = string(nDEX);
	}
	txtDEX.SetText(strTmp);
	
	if (m_HennaInfo.CONchange > 0)
	{
		strTmp = nCON $ "(+" $ m_HennaInfo.CONchange $ ")";
	}
	else if (m_HennaInfo.CONchange < 0)
	{
		strTmp = nCON $ "(" $ m_HennaInfo.CONchange $ ")";
	}
	else
	{
		strTmp = string(nCON);
	}
	txtCON.SetText(strTmp);
	
	if (m_HennaInfo.INTchange > 0)
	{
		strTmp = nINT $ "(+" $ m_HennaInfo.INTchange $ ")";
	}
	else if (m_HennaInfo.INTchange < 0)
	{
		strTmp = nINT $ "(" $ m_HennaInfo.INTchange $ ")";
	}
	else
	{
		strTmp = string(nINT);
	}
	txtINT.SetText(strTmp);
	
	if (m_HennaInfo.WITchange > 0)
	{
		strTmp = nWIT $ "(+" $ m_HennaInfo.WITchange $ ")";
	}
	else if (m_HennaInfo.WITchange < 0)
	{
		strTmp = nWIT $ "(" $ m_HennaInfo.WITchange $ ")";
	}
	else
	{
		strTmp = string(nWIT);
	}
	txtWIT.SetText(strTmp);
	
	if (m_HennaInfo.MENchange > 0)
	{
		strTmp = nMEN $ "(+" $ m_HennaInfo.MENchange $ ")";
	}
	else if (m_HennaInfo.MENchange < 0)
	{
		strTmp = nMEN $ "(" $ m_HennaInfo.MENchange $ ")";
	}
	else
	{
		strTmp = string(nMEN);
	}
	txtMEN.SetText(strTmp);
	
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(MovingSpeed);
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	
	txtCriminalRate.SetText( strCriminalRate);
	txtPVP.SetText(string(PvPPoint));
	txtSociality.SetText(DualCount $ " / " $ PKCount);
	txtRemainSulffrage.SetText(string(Sociality) $ " / " $  string(RemainSulffrage));
	
	UpdateHPBar(HP, MaxHP);
	UpdateMPBar(MP, MaxMP);
	UpdateCPBar(CP, MaxCP);
	UpdateEXPBar(info.fExpPercentRate);
	//UpdateEXPBar(int(fExpRate), 100);
	
	// 속성 데이터 세팅
	txtAttrAttackType.SetText(""$ AttrAttackTypeTxt);
	txtAttrAttackValue.SetText(""$ AttrAttackValue );
	txtAttrDefenseValFire.SetText(""$ AttrDefenseValFire );
	txtAttrDefenseValWater.SetText(""$ AttrDefenseValWater ); 
	txtAttrDefenseValWind.SetText(""$ AttrDefenseValWind );
	txtAttrDefenseValEarth.SetText(""$ AttrDefenseValEarth );
	txtAttrDefenseValHoly.SetText(""$ AttrDefenseValHoly );
	txtAttrDefenseValUnholy.SetText(""$ AttrDefenseValUnholy );
	
	// 변신 정보 세팅
	if (m_bPawnChanged) 
	{
		//~ iGender = info.nSex;
		//~ TransformedID = class'UIDATA_TRANSFORM'.static.GetNpcID( nTransformID, iGender);
		//~ debug ("변신아이디"@ TransformedID);
		//~ TransformedName = class'UIDATA_NPC'.static.GetNPCName(TransformedID);
		//~ txtLvName.SetText(Level $ " " $ TransformedName);
		//~ RunTransformManage();
	}
	else
	{
		RunUnTransformManage();
	}
	

	
}




//HP바 갱신
function UpdateHPBar(int Value, int MaxValue)
{
	/*
	local int Size;
	Size = 0;
	if (MaxValue>0)
	{
		Size = NSTATUS_SMALLBARSIZE;
		if (Value<MaxValue)
		{
			Size = NSTATUS_SMALLBARSIZE* Value / MaxValue;
		}
		
	}
	texHP.SetWindowSize(Size, NSTATUS_BARHEIGHT);*/
	texHP.SetPoint(Value, MaxValue);
}

//MP바 갱신
function UpdateMPBar(int Value, int MaxValue)
{
	/*
	local int Size;
	Size = 0;
	if (MaxValue>0)
	{
		Size = NSTATUS_SMALLBARSIZE;
		if (Value<MaxValue)
		{
			Size = NSTATUS_SMALLBARSIZE* Value / MaxValue;
		}
		
	}
	texMP.SetWindowSize(Size, NSTATUS_BARHEIGHT);*/
	texMP.SetPoint(Value, MaxValue);
}

//EXP바 갱신
function UpdateEXPBar(float ExpPercent)
{
	texEXP.SetPointExpPercentRate(ExpPercent);
}

//CP바 갱신
function UpdateCPBar(int Value, int MaxValue)
{
	/*local int Size;
	Size = 0;
	if (MaxValue>0)
	{
		Size = NSTATUS_SMALLBARSIZE;
		if (Value<MaxValue)
		{
			Size = NSTATUS_SMALLBARSIZE* Value / MaxValue;
		}
	}
	texCP.SetWindowSize(Size, NSTATUS_BARHEIGHT);*/
	texCP.SetPoint(Value, MaxValue);
}

function ToggleOpenCharInfoWnd()
{
	switch (m_hOwnerWnd.IsShowWindow())
	{
	case true:
		m_hOwnerWnd.HideWindow();
		PlaySound("InterfaceSound.charstat_close_01");
	break;
	case false:
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
		PlaySound("InterfaceSound.charstat_open_01");			
	break;
	}
}

function OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	//~ debug ("무슨윈도우" @ a_WindowHandle @ "무슨키?" @ nKey);
	if (nKey == IK_Escape )
	{
		//ToggleOpenCharInfoWnd();
		//debug("111");
	}
}

function HandleVitalityPointInfo( string param )	// 활력 수치만 업데이트
{
	local int nVitality;
	
	ParseInt( param, "Vitality", nVitality );
	
	UpdateVp( nVitality );	// 활력 게이지를 업데이트 한다.
}

function UpdateVp (int Vitality )
{	
	if(Vitality > 20000) // 여기는 에러
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_01");
	}
	else if(Vitality >= 17000) 		//활력 4단계. 경험치 보너스 300%. 사이값 3000
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_05");
	}
	else if(Vitality >=13000)	// 활력 3단계. 경험치 보너스 250%. 사이값 4000
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_04");
	}
	else if(Vitality >= 2000)		//활력 2단계. 경험치 보너스 200%. 사이값 11000 
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_03");
	}
	else if(Vitality >= 240)		//활력 1단계. 경험치 보너스 150%. 사이값 1760
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_02");
	}
	else// 활력 0단계. 경험치 보너스 없음. 사이값 240.
	{
		VitalityTex.SetTexture("l2ui_ct1.Icon_df_LifeForce_01");
	}	
}

function RunTransformManage()
{
	
}

function RunUnTransformManage()
{
	
}

defaultproperties
{
    m_WindowName="DetailStatusWnd"
}
