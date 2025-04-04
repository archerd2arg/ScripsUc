class PCCafeEventWnd extends UICommonAPI;

var int m_TotalPoint;
var int m_AddPoint;
var int m_PeriodType;
var int m_RemainTime;
var int m_PointType;
var int m_DailyPoint;		//CT26P4_0323

//Handle
var WindowHandle Me;
var WindowHandle HelpButton;

//branch : gorillazin 10. 04. 14. - pc cafe event
var bool m_bIsPCCafeEvent;
//end of branch

function OnRegisterEvent()
{
	RegisterEvent( EV_PCCafePointInfo );
	RegisterEvent( EV_ToggleShowPCCafeEventWnd);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle("PCCafeEventWnd");
		HelpButton = GetHandle("PCCafeEventWnd.HelpButton");
	}
	else
	{
		Me = GetWindowHandle("PCCafeEventWnd");
		HelpButton = GetWindowHandle("PCCafeEventWnd.HelpButton");
	}
	//HideWindow( "PCCafeEventWnd.PointAddTextBox" );
	
	//branch : gorillazin 10. 04. 14. - pc cafe event
	m_bIsPCCafeEvent = false;
	//end of branch	
}

function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
	case "HelpButton":
		OnClickHelpButton();
		break;
	case "CloseButton":	HandleToggleShowPCCafeEventWnd();    
		break;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_PCCafePointInfo:
		HandlePCCafePointInfo( a_Param );
		break;
	case EV_ToggleShowPCCafeEventWnd:
		HandleToggleShowPCCafeEventWnd();
		break;
	}
}

function OnClickHelpButton()
{
	// TODO: When TTMayrin implements HTML Control, load proper HTML... - NeverDie
}

function HandlePCCafePointInfo( String a_Param )
{
	local int Show;

	ParseInt( a_Param, "TotalPoint", m_TotalPoint );
	ParseInt( a_Param, "AddPoint", m_AddPoint );
	ParseInt( a_Param, "PeriodType", m_PeriodType );
	ParseInt( a_Param, "RemainTime", m_RemainTime );
	ParseInt( a_Param, "PointType", m_PointType );
	ParseInt( a_Param, "Show", Show );
	ParseInt( a_Param, "DailyPoint", m_DailyPoint);		//CT26P4_0323
	
	//branch : gorillazin 10. 04. 14. - pc cafe event
	// EV_PCCafePointInfo 이벤트가 발생하면 PC Cafe 이벤트를 진행하고 있다는 뜻이므로 창을 띄워줘야 한다.
	// 이 function의 Show 변수와 같은 의미로 쓰일 수도 있음.
	if(!m_bIsPCCafeEvent)
	{
		Me.ShowWindow();
		m_bIsPCCafeEvent = true;
	}
	//end of branch	

	Refresh(Show);
}

function bool IsPCCafeEventOpened()
{
	if( 0 < m_PeriodType )
		return true;

	return false;
}

function OnEnterState( name a_PreStateName )
{	
	//branch : gorillazin 10. 04. 14. - pc cafe event
	Refresh(int(m_bIsPCCafeEvent));
	//end of branch	
	
	//Refresh(1);
}

function OnExitState( name a_NextStateName )
{
	Refresh(0);
}

function Refresh(int nShow)
{
	local Color TextColor;
	local String AddPointText;
	local String FullPointText;		//CT26P4_0323
	local int nDailyHour;
	local int nDailyMin;

	if( nShow == 0 )
	{
		Me.HideWindow();
	}
	
	//HelpButton.SetTooltipCustomType(SetTooltip(GetHelpButtonTooltipText()));

	HelpButton.SetTooltipCustomType(SetTooltip(GetSystemString(2256)));

	FullPointText = MakeCostString( String( m_TotalPoint ) );

	//CT26P4_0323
	if (m_DailyPoint > 0) {
		nDailyMin = m_DailyPoint / 20;
		nDailyHour = nDailyMin / 60;
		nDailyMin = nDailyMin - nDailyHour * 60;
		//FullPointText = FullPointText $ " [" $ GetFormattedTimeStrMMHH(nDailyHour, nDailyMin) $ "]";
	}
	
	class'UIAPI_TEXTBOX'.static.SetText( "PCCafeEventWnd.PointTextBox", FullPointText );
	class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 0 );
	if( 0 != m_AddPoint && nShow != 0 )
	{
		if( 0 < m_AddPoint )
			AddPointText = "+" $ MakeCostString( String( m_AddPoint ) );
		else
			AddPointText = MakeCostString( String( m_AddPoint ) );

		class'UIAPI_TEXTBOX'.static.SetText( "PCCafeEventWnd.PointAddTextBox", AddPointText );

		switch( m_PointType )
		{
		case 0:	// Normal
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 0;
			break;
		case 1:	// Bonus
			//TextColor.R = 255;
			//TextColor.G = 0;
			//TextColor.B = 0;
			TextColor.R = 0;
			TextColor.G = 255;
			TextColor.B = 255;
			break;
		case 2:	// Decrease
			//TextColor.R = 0;
			//TextColor.G = 255;
			//TextColor.B = 255;
			TextColor.R = 255;
			TextColor.G = 0;
			TextColor.B = 0;
			break;
		}

		class'UIAPI_TEXTBOX'.static.SetTextColor( "PCCafeEventWnd.PointAddTextBox", TextColor );
		class'UIAPI_WINDOW'.static.SetAnchor( "PCCafeEventWnd.PointAddTextBox", "PCCafeEventWnd", "TopRight", "TopRight", -5, 41 );
		class'UIAPI_WINDOW'.static.ClearAnchor( "PCCafeEventWnd.PointAddTextBox" );
		class'UIAPI_WINDOW'.static.Move( "PCCafeEventWnd.PointAddTextBox", 0, -18, 1.f );
		class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 255 );
		class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 0, 0.8f );
		m_AddPoint = 0;
	}
}

/** 현재 사용안함 정책이 바뀌었음 */
function String GetHelpButtonTooltipText()
{
	local String TooltipSystemMsg;

	if( 1 == m_PeriodType )
		TooltipSystemMsg = GetSystemMessage( 1705 );
	else if( 2 == m_PeriodType )
		TooltipSystemMsg = GetSystemMessage( 1706 );
	else
		return "";

	return MakeFullSystemMsg( TooltipSystemMsg, string( m_RemainTime ), "" );
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.MinimumWidth = 144;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_color.R = 178;
	info.t_color.G = 190;
	info.t_color.B = 207;
	info.t_color.A = 255;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}

// 빌더 명령어에 의해 창을 감추고 보여주는 함수
function HandleToggleShowPCCafeEventWnd()
{
	if(Me.isShowWindow())
	{
		Me.HideWindow();
	}
	else 
	{
		Me.ShowWindow();
	}
}

//branch : gorillazin 10. 04. 14. - pc cafe event
function bool IsPCCafeEvent()
{
	return m_bIsPCCafeEvent;
}
//end of branch
defaultproperties
{
}
