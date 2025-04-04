class NPCDialogWnd extends UICommonAPI;


var string m_WindowName;

var WindowHandle	m_hNPCDialogWnd;
var HtmlHandle		m_hHtmlViewer;

var bool	m_bPressCloseButton;
var bool	m_bReShowWndMode;
var bool	m_bReShowNPCDialogWnd;	

function OnRegisterEvent()
{
	RegisterEvent(EV_NPCDialogWndShow);
	RegisterEvent(EV_NPCDialogWndHide);
	RegisterEvent(EV_NPCDialogWndLoadHtmlFromString);
	RegisterEvent(EV_QuestIDWndLoadHtmlFromString);
	
	// register gamingstate enter/exit event 
	// - 등록하지 않으면, 처음 호출될때 OnEnter와 OnExit가 호출되지 않음.
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);	
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hNPCDialogWnd=GetHandle(m_WindowName);
		m_hHtmlViewer=HtmlHandle(GetHandle(m_WindowName$".HtmlViewer"));
	}
	else
	{
		m_hNPCDialogWnd=GetWindowHandle(m_WindowName);
		m_hHtmlViewer=GetHtmlHandle(m_WindowName$".HtmlViewer");
	}
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
	case EV_NPCDialogWndShow :
		ShowNPCDialogWnd();
		break;
		
	case EV_NPCDialogWndHide :
		HideNPCDialogWnd();
		break;
		
	case EV_NPCDialogWndLoadHtmlFromString :
		m_hNpcDialogWnd.SetWindowTitle(GetSystemString(1));	 //타이틀을 "대화"로 바꿔준다. 
		//m_hNpcDialogWnd.SetWindowTitle(param);	 //Muestra el titulo del NPC
		HandleLoadHtmlFromString(param);
		break;
	case EV_QuestIDWndLoadHtmlFromString:
		m_hNPCDialogWnd.HideWindow();
		break;
	}
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if(a_HtmlHandle==m_hHtmlViewer)
	{
		HideNPCDialogWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	local string htmlString;
	ParseString(param, "HTMLString", htmlString);

	m_hHtmlViewer.LoadHtmlFromString(htmlString);
}



function OnHide()
{
	ProcCloseNPCDialogWnd();
}

function OnClickButton( string Name )
{
	PressCloseButton();
}

function OnExitState(name a_NextStateName )
{
	
	if( a_NextStateName == 'NpcZoomCameraState')
	{
		Clear();
		m_bReShowWndMode = true;
	}
}

function OnEnterState( name a_PreStateName )
{
	
	if( a_PreStateName == 'NpcZoomCameraState' )
	{
		ReShowNPCDialogWnd();
		Clear();
	}	
}

function Clear()
{
	//
	m_bReShowWndMode	= false;	
	m_bPressCloseButton = false;
	m_bReShowNPCDialogWnd = false;
}

function ShowNPCDialogWnd()
{
	local PrivateShopWnd kPrivateShop;

	ExecuteEvent(EV_QuestHtmlWndHide);

	kPrivateShop = PrivateShopWnd(GetScript("PrivateShopWnd"));
	if (IsShowWindow("PrivateShopWnd"))
	{
		kPrivateShop.RequestQuit();
		HideWindow("PrivateShopWnd");
	}
	m_hNPCDialogWnd.ShowWindow();
	m_hNPCDialogWnd.SetFocus();
	m_bReShowNPCDialogWnd = true;
}

function HideNPCDialogWnd()
{
	m_hNpcDialogWnd.HideWindow();
	m_bReShowNPCDialogWnd = false;
}


function PressCloseButton()
{
	// press close button
	if( m_bReShowWndMode )
	{
		m_bPressCloseButton = true;
	}
}

function ProcCloseNPCDialogWnd()
{
	if( m_bPressCloseButton && m_bReShowWndMode && m_bReShowNPCDialogWnd)
	{
		// must first m_bReShowNPCDialogWnd be false because calling recursive function.	
		m_bReShowWndMode = false;		
		RequestFinishNPCZoomCamera();		
	}
}

function ReShowNPCDialogWnd()
{
	if( m_bReShowWndMode && m_bReShowNPCDialogWnd )
	{
		ShowNPCDialogWnd();			
	}	
}

defaultproperties
{
    m_WindowName="NPCDialogWnd"
}
