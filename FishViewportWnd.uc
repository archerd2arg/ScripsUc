class FishViewportWnd extends UICommonAPI;


const EFFECT_TIMER_ID=2;
const EFFECT_TIMER_DELAY=1000;
const STATUS_TIMER_ID=3;
const STATUS_TIMER_DELAY=0;


var string m_WindowName;

var WindowHandle m_hFishViewportWnd;
var WIndowHandle m_hFishHPBarEffect;
var BarHandle m_hFishHPBar;
var BarHandle m_hFishHPBarFake;
var TextBoxHandle m_hTbSec;
var WindowHandle m_hTexClock;

var WindowHandle m_hWndStatus;
var TextBoxHandle m_hTbStatus;
var TextBoxHandle m_hTbDeltaHP;

var int m_OriginalFishHP;
var int m_OriginalFishTime;
var int m_CurrentFishHP;

function OnRegisterEvent()
{
	RegisterEvent( EV_FishViewportWndShow );
	RegisterEvent( EV_FishViewportWndHide );
	RegisterEvent( EV_FishRankEventButtonShow );
	RegisterEvent( EV_FishRankEventButtonHide );

	RegisterEvent( EV_FishViewportWndFinalAction );
	RegisterEvent( EV_FishViewportWndInitFishStatus );
	RegisterEvent( EV_FishViewportWndSetFishStatus );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	HideHPBarNEtc();

	m_hFishHPBarEffect.HideWindow();

	m_OriginalFishHP=0;
}

function InitHandle()
{
	m_hFishHPBar = BarHandle(GetHandle( m_WindowName $ ".barFishHp" ));
	m_hFishHPBarFake= BarHandle(GetHandle( m_WindowName $ ".barFishHpFake" ));
	m_hFishHPBarEffect = GetHandle( m_WindowName$".wndEffect" );
	m_hFishViewportWnd = GetHandle( m_WindowName );
	m_hTbSec=TextBoxHandle(GetHandle(m_WindowName$".txtVarSec"));
	m_hTexClock=GetHandle(m_WindowName$".texClock");

	m_hWndStatus=GetHandle(m_WindowName$".wndStatus");
	m_hTbStatus=TextBoxHandle(GetHandle(m_WindowName$".wndStatus.txtVarStatus"));
	m_hTbDeltaHP=TextBoxHandle(GetHandle(m_WindowName$".wndStatus.txtVarDeltaHP"));
}

function InitHandleCOD()
{
	m_hFishHPBar = GetBarHandle( m_WindowName $ ".barFishHp" );
	m_hFishHPBarFake= GetBarHandle( m_WindowName $ ".barFishHpFake" );
	m_hFishHPBarEffect = GetWindowHandle( m_WindowName$".wndEffect" );
	m_hFishViewportWnd = GetWindowHandle( m_WindowName );
	m_hTbSec=GetTextBoxHandle(m_WindowName$".txtVarSec");
	m_hTexClock=GetWindowHandle(m_WindowName$".texClock");

	m_hWndStatus=GetWindowHandle(m_WindowName$".wndStatus");
	m_hTbStatus=GetTextBoxHandle(m_WindowName$".wndStatus.txtVarStatus");
	m_hTbDeltaHP=GetTextBoxHandle(m_WindowName$".wndStatus.txtVarDeltaHP");
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
	case EV_FishViewportWndShow :
		m_hFishViewportWnd.ShowWindow();
		m_hFishViewportWnd.SetFocus();

		HideHPBarNEtc();

		m_hFishHPBarEffect.HideWindow();
		break;

	case EV_FishViewportWndHide :
		m_hFishViewportWnd.HideWindow();
		break;

	case EV_FishViewportWndFinalAction :
		if(m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow())
			ShowEffect();
		break;

	case EV_FishViewportWndInitFishStatus :
		HandleInitFishStatus(param);
		break;

	case EV_FishViewportWndSetFishStatus :
		HandleSetFishStatus(param);
		break;

	case EV_FishRankEventButtonShow :
		ShowWindow("FishViewportWnd.btnRanking");
		break;
	case EV_FishRankEventButtonHide :
		HideWindow("FishViewportWnd.btnRanking");
		break;
	}
}

function ShowHPBarNEtc()
{
	m_hFishHPBar.ShowWindow();
	m_hTexClock.ShowWindow();
	m_hTbSec.ShowWindow();
}

function HideHPBarNEtc()
{
	m_hFishHPBar.HideWindow();
	m_hFishHPBarFake.HideWindow();
	m_hTexClock.HideWindow();
	m_hTbSec.HideWindow();
}

function HandleInitFishStatus(string param)
{
	ParseInt(param, "OriginalFishHP", m_OriginalFishHP);
	ParseInt(param, "OriginalFishTime", m_OriginalFishTime);
	m_CurrentFishHP=m_OriginalFishHP;
}

function HandleSetFishStatus(string param)
{
	local int FishHP;
	local int TimeCount;
	local int DeltaHP;
	local int ShowType;
	local int Effect;
	local int Penalty;
	local int Fake;

	ParseInt(param, "CurrentFishHP", FishHP);
	ParseInt(param, "TimeCount", TimeCount);
	ParseInt(param, "ShowType", ShowType);
	ParseInt(param, "Effect", Effect);
	ParseInt(param, "Penalty", Penalty);
	ParseInt(param, "Fake", Fake);

	DeltaHP=FishHP-m_CurrentFishHP;

	// ShowType == 4 이면 낚시성공이므로 물고기HP와 시간을 업데이트할 필요가 없다.
	if(ShowType!=4)
	{
		m_CurrentFishHP=FishHP;

		m_hFishHPBar.SetValue(m_OriginalFishHP*2, FishHP);
		m_hFishHPBarFake.SetValue(m_OriginalFishHP*2, FishHP);
		m_hTbSec.SetText(string(TimeCount));
	}

	// 입질 시작후 3초가 지나면 HP바와 설명(초보 물고기인 경우)을 보여준다.
	if( !m_hFishHPBar.IsShowWindow() &&  (m_OriginalFishTime-TimeCount)>=3 )
	{
		ShowHPBarNEtc();
	}

	if(ShowType==3)		// 입질성공
	{
		ShowFishString(1261, 0);
	}
	else if(ShowType == 4)	// 낚시성공
	{
		ShowFishString(1264, 0);
	}

	if(m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow())
	{
		if(Effect != 0)
		{
			ShowEffect();
		}
		if(ShowType == 1)
		{
			if(DeltaHP < 0)	// 펌핑성공
			{
				if(Penalty > 0)
					ShowFishStringWithPenalty(1672, DeltaHP, Penalty);
				else
					ShowFishString(1256, DeltaHP);
			}
			else				// 펌핑실패
				ShowFishString(1258, DeltaHP);
		}
		else if(ShowType == 2)
		{
			if(DeltaHP < 0)	// 릴링성공
			{
				if(Penalty > 0)
					ShowFishStringWithPenalty(1671, DeltaHP, Penalty);
				else
					ShowFishString(1257, DeltaHP);
			}
			else				// 릴링실패
				ShowFishString(1259, DeltaHP);
		}

		if(Fake!=0)
		{
			m_hFishHPBarFake.ShowWindow();
			m_hFishHPBar.HideWindow();
		}
		else
		{
			m_hFishHPBarFake.HideWindow();
			m_hFishHPBar.ShowWindow();
		}
	}
}

function ShowEffect()
{
	m_hFishHPBarEffect.ShowWindow();
	m_hFishHPBarEffect.SetTimer(EFFECT_TIMER_ID,EFFECT_TIMER_DELAY);
}

function ShowFishString(INT StrID, INT DeltaHP)
{
	local color col;

	if(DeltaHP > 0)
	{
		col.R=255;
		col.G=0;
		col.B=0;
	}
	else
	{
		col.R=220;
		col.G=220;
		col.B=220;
	}

	m_hTbStatus.SetTextColor(col);
	m_hTbDeltaHP.SetTextColor(col);

	m_hTbStatus.SetText(GetSystemString(StrID));
	if(DeltaHP!=0)
		m_hTbDeltaHP.SetText(string(DeltaHP));
	else
		m_hTbDeltaHP.SetText("");


	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(STATUS_TIMER_ID, STATUS_TIMER_DELAY);
}

function ShowFishStringWithPenalty(INT StrID, INT DeltaHP, INT Penalty)
{
	local color col;

	col.R=255;
	col.G=0;
	col.B=0;

	m_hTbStatus.SetTextColor(col);
	m_hTbDeltaHP.SetTextColor(col);

	m_hTbStatus.SetText(GetSystemMessageWithParamNumber(StrID, Penalty));
	if(DeltaHP!=0)
		m_hTbDeltaHP.SetText(string(DeltaHP));
	else
		m_hTbDeltaHP.SetText("");

	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(STATUS_TIMER_ID, STATUS_TIMER_DELAY);
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "btnRanking" :
		RequestFishRanking();
		break;
	}
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
	case EFFECT_TIMER_ID :
		m_hFishHPBarEffect.KillTimer(TimerID);
		m_hFishHPBarEffect.HideWindow();
		break;
	case STATUS_TIMER_ID :
		m_hWndStatus.Killtimer(TimerID);
		m_hWndStatus.HideWindow();
		break;
	}
}

defaultproperties
{
    m_WindowName="FishViewportWnd"
}
