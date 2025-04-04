class ShaderBuild extends UIScriptEx;

var OptionWnd m_OptionWndScript;
var String m_PreStateName;
var int m_StartBuild;
var int m_OrgAntialiasing;
var WindowHandle GametipWnd;
var WindowHandle LoadingWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_ResetDevice );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_OptionWndScript = OptionWnd( GetScript( "OptionWnd" ) );
		GametipWnd = GetHandle("GametipWnd");
		LoadingWnd = GetHandle("LoadingWnd");
	}
	else
	{
		m_OptionWndScript = OptionWnd( GetScript( "OptionWnd" ) );
		GametipWnd = GetWindowHandle("GametipWnd");
		LoadingWnd = GetWindowHandle("LoadingWnd");
	}

	m_hOwnerWnd.EnableTick();
}

function OnEnterState( name a_PreStateName )
{
	m_PreStateName = String( a_PreStateName );
	LoadingWnd.ShowWindow();
	GametipWnd.ShowWindow();
	m_StartBuild = 1;
}

function OnTick()
{
	local int OrgAntialiasing;

	switch( m_StartBuild )
	{
	case 0:	// Do nothing
		break;
	case 1:	// Wait one tick to show LoadingWnd
		// Set AA 0 to reset device before showing loading screen
		m_OrgAntialiasing = GetOptionInt( "Video", "AntiAliasing" );
		if( 0 == OrgAntialiasing )
		{
			SetOptionInt( "Video", "AntiAliasing", 0 );
			m_StartBuild++;
		}
		else
			m_StartBuild = 3;
		break;
	case 2:	// If device is reset wait one more tick for precache
		m_StartBuild++;
		break;
	case 3:
		m_StartBuild = 0;
		SetShaderWaterEffect( m_OptionWndScript.m_bShaderWater );
		SetDepthBufferShadow( m_OptionWndScript.m_bDepthBufferShadow );
		SetDOF( m_OptionWndScript.m_bDOF );
		SetL2Shader( m_OptionWndScript.m_bL2Shader );
		// recover original AA value after shader is on.
		SetOptionInt( "Video", "AntiAliasing", m_OrgAntialiasing );
		LoadingWnd.HideWindow();
		GametipWnd.HideWindow();
		SetUIState( m_PreStateName );
		break;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	if( a_EventID == EV_ResetDevice )
	{
	}
}
defaultproperties
{
}
