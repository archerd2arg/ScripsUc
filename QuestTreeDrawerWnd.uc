class QuestTreeDrawerWnd extends UICommonAPI;
var WindowHandle 					Me;
var TextBoxHandle 					txtQuestTitle;
var TextBoxHandle 					txtQuestRecommandedLevel;
var TextBoxHandle 					txtQuestType;
var TreeHandle 						QuestDescriptionTree;
var TreeHandle 						QuestDescriptionLargeTree;
var TreeHandle 						QuestItemTree;
var TreeHandle 						QuestRewardItemTree;
var ButtonHandle 					btnGiveUpCurrentQuest;
var ButtonHandle 					btnClose;
var ButtonHandle					m_btnAddAlarm;
var ButtonHandle					m_btnDeleteAlarm;
var bool	IsCheckAssignNotifier;

var QuestTreeWnd 					m_scriptQuestTreeWnd;
function OnLoad()
{ 
	//~ Initialize();
	//~ Load();
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)
	{
		Initialize();
	}
	else
	{
		InitializeCOD();
	}
	
	m_scriptQuestTreeWnd = QuestTreeWnd( GetScript("QuestTreeWnd") );
	m_btnAddAlarm.DisableWindow();
	m_btnDeleteAlarm.DisableWindow();
	
}

function Initialize()
{
	Me = GetHandle( "QuestTreeDrawerWnd" );
	txtQuestTitle = TextBoxHandle ( GetHandle( "QuestTreeDrawerWnd.txtQuestTitle" ) );
	txtQuestRecommandedLevel = TextBoxHandle ( GetHandle( "QuestTreeDrawerWnd.txtQuestRecommandedLevel" ) );
	txtQuestType = TextBoxHandle ( GetHandle( "QuestTreeDrawerWnd.txtQuestType" ) );
	QuestDescriptionTree = TreeHandle ( GetHandle( "QuestTreeDrawerWnd.QuestDescriptionTree" ) );
	QuestDescriptionLargeTree = TreeHandle ( GetHandle( "QuestTreeDrawerWnd.QuestDescriptionLargeTree" ) );
	QuestItemTree = TreeHandle ( GetHandle( "QuestTreeDrawerWnd.QuestItemTree" ) );
	QuestRewardItemTree = TreeHandle ( GetHandle( "QuestTreeDrawerWnd.QuestRewardItemTree" ) );
	btnGiveUpCurrentQuest = ButtonHandle ( GetHandle( "QuestTreeDrawerWnd.btnGiveUpCurrentQuest" ) );
	btnClose = ButtonHandle ( GetHandle( "QuestTreeDrawerWnd.btnClose" ) );
	m_btnAddAlarm = ButtonHandle( GetHandle( "QuestTreeDrawerWnd.btnAddAlarm" ) );
	m_btnDeleteAlarm = ButtonHandle( GetHandle( "QuestTreeDrawerWnd.btnDeleteAlarm" ) );
}


function InitializeCOD()
{
	Me = GetWindowHandle( "QuestTreeDrawerWnd" );
	txtQuestTitle = GetTextBoxHandle (  "QuestTreeDrawerWnd.txtQuestTitle" ) ;
	txtQuestRecommandedLevel = GetTextBoxHandle (  "QuestTreeDrawerWnd.txtQuestRecommandedLevel" ) ;
	txtQuestType = GetTextBoxHandle (  "QuestTreeDrawerWnd.txtQuestType" ) ;
	QuestDescriptionTree = GetTreeHandle (  "QuestTreeDrawerWnd.QuestDescriptionTree" ) ;
	QuestDescriptionLargeTree = GetTreeHandle (  "QuestTreeDrawerWnd.QuestDescriptionLargeTree" ) ;
	QuestItemTree = GetTreeHandle (  "QuestTreeDrawerWnd.QuestItemTree" ) ;
	QuestRewardItemTree = GetTreeHandle (  "QuestTreeDrawerWnd.QuestRewardItemTree" ) ;
	btnGiveUpCurrentQuest = GetButtonHandle (  "QuestTreeDrawerWnd.btnGiveUpCurrentQuest"  );
	btnClose = GetButtonHandle (  "QuestTreeDrawerWnd.btnClose"  );
	m_btnAddAlarm = GetButtonHandle ( "QuestTreeDrawerWnd.btnAddAlarm" );
	m_btnDeleteAlarm = GetButtonHandle ( "QuestTreeDrawerWnd.btnDeleteAlarm" );
}



//function OnClickCheckBox( String strID )
//{
//	local QuestTreeWnd Script;
//	Script = QuestTreeWnd (GetScript("QuestDrawerWnd"));
//	switch( strID )
//	{
//		case "CheckAssignNotifier":
//			if(CheckAssignNotifier.IsChecked())		//퀘스트 알림이 자동 해제가 체크되어 있을 경우
//			{
//				IsCheckAssignNotifier = true;
//				SetOptionBool("Game", "autoQuestAlarm",true);
//			}
//			else
//			{
//				IsCheckAssignNotifier = false;
//				SetOptionBool("Game", "autoQuestAlarm",false);
//			}
	//			Script.HandleAddAlarm();
	//		else
	//			Script.HandleDeleteAlarm();
//			break;	
//		case "chkNpcPosBox":
		//		Script.UpdateTargetInfo();
//			break;
//	}
//}
// function OnClickCheckBox( String strID )
//~ {
	//~ switch( strID )
	//~ {
	//~ case "chkNpcPosBox":
		//~ UpdateTargetInfo();
		//~ break;
	//~ case "chkQuestAlarmBox":
		//~ if(chkQuestAlarmBox.IsChecked())		//퀘스트 알림이 자동 해제가 체크되어 있을 경우
		//~ {
			//~ QuestAutoAlarm = true;
			//~ SetOptionBool("Game", "autoQuestAlarm",true);
		//~ }
		//~ else 
		//~ {
			//~ QuestAutoAlarm = false;
			//~ SetOptionBool("Game", "autoQuestAlarm",false);
		//~ }	
	//~ }
//~ }

function Load()
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnAddAlarm":
		 m_scriptQuestTreeWnd.HandleAddAlarm();
		 break;
	case "btnDeleteAlarm":
		 m_scriptQuestTreeWnd.HandleDeleteAlarm();
		 break;		
	case "btnGiveUpCurrentQuest":
		OnbtnGiveUpCurrentQuestClick();
		break;
	case "btnClose":
		OnbtnCloseClick();
		break;
	}
}

function OnbtnGiveUpCurrentQuestClick()
{
	local QuestTreeWnd Script;
	Script = QuestTreeWnd(GetScript("QuestTreeWnd"));
	
	Script.HandleQuestCancel();
}

function OnbtnCloseClick()
{
	Me.HideWindow();
}

function OnShow()
{
	IsCheckAssignNotifier = GetOptionBool("Game", "autoQuestAlarm");
	
	if(IsCheckAssignNotifier == true)
	{
	//	CheckAssignNotifier.SetCheck(true);
	}
	else
	{
	//	CheckAssignNotifier.SetCheck(false);
	}
}
defaultproperties
{
}
