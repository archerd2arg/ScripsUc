class TestWnd extends UICommonAPI;

const TimerValue1 = 777;
const TimerValue2 = 888;
const TimerValue3 = 999;
const TimerValue4 = 666;

var WindowHandle Me1;
var WindowHandle Me2;
var ButtonHandle btnRotate1;
var ButtonHandle btnRotate2;

var WindowHandle m_hSystemTestWnd;
//var WindowHandle m_hSystemGMWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowWindow );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me1 = GetHandle( "TestWnd" );
		m_hSystemTestWnd=GetHandle("SystemTestWnd");
	}
	else
	{
		Me1 = GetWindowHandle( "TestWnd" );
		m_hSystemTestWnd=GetWindowHandle("SystemTestWnd");
	}
	
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "BtnCharInfo" :
		ToggleOpenCharInfoWnd();
		ProcessChatMessage("DinastyShop ",1);//Используем скил /target
		break;
	case "BtnInventory" :
		ToggleOpenInventoryWnd();
		break;
	case "BtnMap" :
		ToggleOpenMinimapWnd();
		break;
	case "BtnSystemMenu" :
		ToggleOpenSystemTestWnd();
		break;
	case "BtnSkill" :
		ToggleOpenSkillWnd();
		break;
	case "BtnAction" :
		ToggleOpenActionWnd();
		break;
	case "BtnClan" :
		ToggleOpenClanWnd();
		break;
	case "BtnQuest" :
		ToggleOpenQuestWnd();
		break;
	case "BtnGm" :
		ToggleOpenGmWnd();
		break;
	case "RotateButton1":
		OnRotate1();
		break;
	case "RotateButton2":
		OnRotate2();
		break;
	}
}

function OnShowProcess()
{
	Me2.SetAlpha(0);
	Me2.HideWindow();
//	Me2.Rotate(False, 210000);
}

function OnRotate1()
{
	//~ debug ("Rotate1");
	Me2.SetAlpha(0);
	Me2.ShowWindow();
	class'UIAPI_WINDOW'.static.SetUITimer("TestWnd", TimerValue1, 150);
//	Me2.Rotate(False, 1800);
//	Me1.Rotate(False, 1800);
	

}

function OnRotate2()
{
	//~ debug ("Rotate2");
	Me1.SetAlpha(0);
	Me1.ShowWindow();
	class'UIAPI_WINDOW'.static.SetUITimer("TestWnd", TimerValue2, 150);
//	Me2.Rotate(False, 1800);
//	Me1.Rotate(False, 1800);
}


function OnTimer(int TimerID)
{
	//~ debug ("TimerID" @ TimerID);
	if (TimerID==TimerValue1)	
	{	
		//~ debug("윈도우 지음1");
		class'UIAPI_WINDOW'.static.KillUITimer("TestWnd", TimerValue1);
		Me2.SetAlpha(255, 0.4f);
		Me1.SetAlpha(0);
		class'UIAPI_WINDOW'.static.SetUITimer("TestWnd", TimerValue3,300);
	} 
	
	if(TimerID==TimerValue3)	
	{	
		class'UIAPI_WINDOW'.static.KillUITimer("TestWnd", TimerValue3);
			//~ debug("윈도우 지음");
		Me1.HideWindow();
	}
	
	if (TimerID==TimerValue2)	
	{	
		//~ debug("윈도우 지음10");
		class'UIAPI_WINDOW'.static.KillUITimer("TestWnd", TimerValue2);
		Me1.SetAlpha(255, 0.4f);
		Me2.SetAlpha(0,);
		class'UIAPI_WINDOW'.static.SetUITimer("TestWnd", TimerValue4,300);
	} 
	
	if(TimerID==TimerValue4)	
	{	
		class'UIAPI_WINDOW'.static.KillUITimer("TestWnd", TimerValue4);
		//~ debug("윈도우 지음ㅌㅌㅌ");
		Me2.HideWindow();
	}
}


 function OnEvent(int Event_ID, string param)
 {
//ForceToMoveMousePos( 1,200, 2,200 );

}

function ToggleOpenSkillWnd()
{
	if(IsShowWindow("MagicSkillWnd"))
	{
		HideWindow("MagicSkillWnd");
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		ShowWindowWithFocus("MagicSkillWnd");
		PlaySound("InterfaceSound.charstat_open_01");			
	}
}

function ToggleOpenActionWnd()
{
	if(IsShowWindow("ActionWnd"))
	{
		HideWindow("ActionWnd");
		PlaySound("InterfaceSound.charstat_close_01");
		
	}
	else
	{
		ShowWindowWithFocus("ActionWnd");
		ExecuteEvent(EV_ActionListStart);
		ExecuteEvent(EV_ActionList);
		ExecuteEvent(EV_LanguageChanged);
		ExecuteEvent(EV_ActionListNew);
		PlaySound("InterfaceSound.charstat_open_01");		
		
	}
}

function ToggleOpenClanWnd()
{
	if(IsShowWindow("ClanWnd"))
	{
		HideWindow("ClanWnd");
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		ShowWindowWithFocus("ClanWnd");
		PlaySound("InterfaceSound.charstat_open_01");			
	}
}

function ToggleOpenQuestWnd()
{
	if(IsShowWindow("QuestTreeWnd"))
	{
		HideWindow("QuestTreeWnd");
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		ShowWindowWithFocus("QuestTreeWnd");
		PlaySound("InterfaceSound.charstat_open_01");			
	}
}

function ToggleOpenGmWnd()
{
	if(IsShowWindow("SystemGMWnd"))
	{
		HideWindow("SystemGMWnd");
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		ShowWindowWithFocus("SystemGMWnd");
		ExecuteCommand(".user");
		PlaySound("InterfaceSound.charstat_open_01");			
	}
	//ExecuteCommand("///reloadui");
}


function ToggleOpenCharInfoWnd()
{
	if(IsShowWindow("DetailStatusWnd"))
	{
		HideWindow("DetailStatusWnd");
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		ShowWindowWithFocus("DetailStatusWnd");
		PlaySound("InterfaceSound.charstat_open_01");			
	}
}

function ToggleOpenInventoryWnd()
{
	if(IsShowWindow("InventoryWnd"))
	{
		HideWindow("InventoryWnd");
		PlaySound("InterfaceSound.inventory_close_01");
	}
	else
	{
		//~ ShowWindowWithFocus("InventoryWnd");
		ExecuteEvent(EV_InventoryToggleWindow);
		PlaySound("InterfaceSound.inventory_open_01");
	}
}

function ToggleOpenMinimapWnd()
{
	RequestOpenMinimap();
}


function ToggleOpenSystemTestWnd()
{
	if(m_hSystemTestWnd.IsShowWindow())
	{
		m_hSystemTestWnd.HideWindow();
		PlaySound("InterfaceSound.system_close_01");
	}
	else
	{
		m_hSystemTestWnd.ShowWindow();
		m_hSystemTestWnd.SetFocus();
		PlaySound("InterfaceSound.system_open_01");
	}
}
defaultproperties
{
}
