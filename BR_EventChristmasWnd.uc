class BR_EventChristmasWnd extends UICommonAPI;

var WindowHandle Me;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_EventChristmasShow );
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_EventChristmasWnd" );
	}
	else {
		Me = GetWindowHandle( "BR_EventChristmasWnd" );
		
	}
}

function OnEvent( int Event_ID, string param )
{
	local int Show;
	
	switch( Event_ID )
	{		
	case EV_BR_EventChristmasShow : 
		ParseInt(param, "Show", Show ); 
		debug("Christmas EEEEEEEEEEEEEEEvent! "$Show);
		if(Show==0)
		{
			if(Me.isShowWindow()){Me.HideWindow();}		
		}
		else
		{		
			if(!Me.isShowWindow()){Me.ShowWindow();}
			AddSystemMessage(6029); // [크리스마스 이벤트 기간입니다]
		}	
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "EventChristmasBtn1": 		
		OnEventHalloBtn1Click();
		break;
	case "EventChristmasBtn2":
		OnEventHalloBtn2Click();
		break;
	case "EventChristmasBtn3":
		OnEventHalloBtn3Click();
		break;
	}
}

function OnEventHalloBtn1Click()
{
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd1"))
	{
		HideWindow("BR_EventHtmlWnd1");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd1");		
		ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_rudolf000.htm");
		ParamAdd(strParam, "Title", GetSystemString(5043));
		ExecuteEvent(EV_BR_EventCommonHtml1, strParam);
	}

}

function OnEventHalloBtn2Click()
{
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd2"))
	{
		HideWindow("BR_EventHtmlWnd2");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd2");		
		ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_santa000.htm");
		ParamAdd(strParam, "Title", GetSystemString(5044));
		ExecuteEvent(EV_BR_EventCommonHtml2, strParam);
	}

}

function OnEventHalloBtn3Click()
{	
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd3"))
	{
		HideWindow("BR_EventHtmlWnd3");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd3");		
		ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_reward000.htm");
		ParamAdd(strParam, "Title", GetSystemString(5045));
		ExecuteEvent(EV_BR_EventCommonHtml3, strParam);
	}
}
defaultproperties
{
}
