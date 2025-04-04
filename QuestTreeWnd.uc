class QuestTreeWnd extends UICommonAPI;

const QUESTTREEWND_MAX_COUNT = 40;
const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -17;

const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT  = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

var String 		m_WindowName;
var int		m_QuestNum;	//현재 퀘스트 갯수

var int		m_OldQuestID;
var string		m_CurNodeName;

var int		m_DeleteQuestID;
var string		m_DeleteNodeName;
var string		m_CurTab;

var bool 		m_bDrawBg;
var bool 		m_bDrawBg2;
var bool		m_bDrawBg3;

var array<string>	m_arrItemNodeName;
var array<string>	m_arrItemString;
var array<int>		m_arrItemID;
var array<int>		m_arrItemQuestID;	//특정 아이템이 속해있는 퀘스트 아이디를 저장한다.
var array<int>		m_arrItemLevel;
var array<int>		m_arrItemNumList;
var array<LVDataRecord>	m_QuestTrackData;
var int	m_TrackID;

//Handle                                   사용할 핸들의 타입과 이름을 선언
var TextBoxHandle					m_txtQuestNum;
var WindowHandle					Me;
var WindowHandle 					Drawer;
var TextureHandle					m_QuestTooltip;
var QuestAlarmWnd 					m_scriptAlarm;
var TreeHandle						MainTree0;
var TreeHandle						MainTree1;
var TreeHandle						MainTree2;
var TreeHandle						MainTree3;
var TreeHandle						MainTree4;
var TreeHandle						CurTree;
var TabHandle						QuestTabCtrl;
var ButtonHandle						m_btnAddAlarm;
var ButtonHandle 					m_btnDeleteAlarm;
var CheckBoxHandle 					CheckAssignNotifier;
var CheckBoxHandle 					checkNpcPosBox;
var TextBoxHandle 					Drawer_txtQuestTitle;
var TextBoxHandle 					Drawer_txtQuestRecommandedLevel;
var TextBoxHandle 					Drawer_txtQuestType;
var TreeHandle 						Drawer_QuestDescriptionTree;
var TreeHandle 						Drawer_QuestDescriptionLargeTree;
var TreeHandle 						Drawer_QuestItemTree;
var TreeHandle 						Drawer_QuestRewardItemTree;

var ButtonHandle 					Drawer_btnGiveUpCurrentQuest;
var ButtonHandle 					Drawer_btnClose;
var TextBoxHandle 					Drawer_txtQuestItemTitle;
var TextBoxHandle					Drawer_txtQuestRewardItemTreeTitle;
var TextureHandle					Drawer_GroupBox_DescriptionTree;
var TextureHandle					Drawer_GroupBox_ItemTree;
var TextBoxHandle					Drawer_txtRecommandedLevelText;
var ListCtrlHandle 					ListTrackItem1;

var int QuestID_Alarm;
var int QuestLevel_Alarm;
var int QuestEnd_Alarm;

var bool	QuestAutoAlarm;
var bool	isRequestMonsterInfo;

function OnRegisterEvent()
{
	RegisterEvent( EV_QuestListStart );
	RegisterEvent( EV_QuestList );
	RegisterEvent( EV_QuestListEnd );
	RegisterEvent( EV_QuestSetCurrentID );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
	RegisterEvent( EV_LanguageChanged );
	registerEvent( EV_GamingStateEnter );
	registerEvent( EV_ExpandQuestAlarmKillMonster );
}

function OnLoad()              //창을 불러들일 때
{
	InitHandle();             

	m_scriptAlarm = QuestAlarmWnd( GetScript("QuestAlarmWnd"));

	InitQuestTooltip();

	m_QuestNum = 0;             //퀘스트 넘버 초기화                   

	m_btnAddAlarm.DisableWindow();         
	m_btnDeleteAlarm.DisableWindow();
	CurTree = MainTree0;         //카드스택 초기화: 첫번째 트리를 보여준다.
	m_bDrawBg = true;
	checkNpcPosBox.SetCheck(true);
	isRequestMonsterInfo = false;
}

function InitHandle()          //각 핸들에 대한 기능들을 정의해놓는다.
{
	m_txtQuestNum = GetTextBoxHandle(m_WindowName$".txtQuestNum");  //하나가 아닌 경우는 멤버함수를 뜻하는 m_의 이름으로 선언을~
	Me = GetWindowHandle(m_WindowName);
    Drawer = GetWindowHandle("QuestTreeDrawerWnd");    //드로우창의 윈도우 핸들을 불러오겠다는 것.
	m_QuestTooltip = GetTextureHandle(m_WindowName$".QuestTooltip");
	m_btnAddAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
	m_btnDeleteAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");

	MainTree0 = GetTreeHandle(m_WindowName$".MainTree1");
	MainTree1 = GetTreeHandle(m_WindowName$".MainTree2");
	MainTree2 = GetTreeHandle(m_WindowName$".MainTree3");
	MainTree3 = GetTreeHandle(m_WindowName$".MainTree4");
	MainTree4 = GetTreeHandle(m_WindowName$".MainTree5");

	Drawer_txtQuestTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestTitle");
	Drawer_txtQuestRecommandedLevel = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevel");
	Drawer_txtRecommandedLevelText = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevelText");
	Drawer_txtQuestType = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestType");
	Drawer_QuestDescriptionTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionTree");
	Drawer_QuestDescriptionLargeTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
	Drawer_QuestItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestItemTree");
	Drawer_QuestRewardItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestRewardItemTree");
	CheckAssignNotifier = GetCheckBoxHandle("QuestTreeWnd.chkAssignNotifier");
    checkNpcPosBox = GetCheckBoxHandle (  m_WindowName$".chkNpcPosBox" ) ;
	Drawer_btnGiveUpCurrentQuest = GetButtonHandle ( "QuestTreeDrawerWnd.btnGiveUpCurrentQuest" );
    Drawer_btnClose = GetButtonHandle ( "QuestTreeDrawerWnd.btnClose" );
	Drawer_txtQuestItemTitle = GetTextBoxHandle ( "QuestTreeDrawerWnd.txtQuestItemTitle" );
    Drawer_txtQuestRewardItemTreeTitle = GetTextBoxHandle ( "QuestTreeDrawerWnd.txtQuestRewardItemTreeTitle" );
	Drawer_GroupBox_DescriptionTree = GetTextureHandle ( "QuestTreeDrawerWnd.GroupBox_DescriptionTree" );
	Drawer_GroupBox_ItemTree = GetTextureHandle ( "QuestTreeDrawerWnd.GroupBox_ItemTree" );
	ListTrackItem1 = GetListCtrlHandle( "MiniMapDrawerWnd.ListTrackItem1" );

	QuestTabCtrl = GetTabHandle(m_WindowName$".QuestTreeTab" );

}


function OnDefaultPosition()
{
	QuestTabCtrl.MergeTab(QUEST_WINDOW_ONE);
	QuestTabCtrl.MergeTab(QUEST_WINDOW_REPEAT);
	QuestTabCtrl.MergeTab(QUEST_WINDOW_EPIC);
	QuestTabCtrl.MergeTab(QUEST_WINDOW_JOB);
	QuestTabCtrl.MergeTab(QUEST_WINDOW_SPECIAL);
	QuestTabCtrl.SetTopOrder(0, true);
}

function OnShow()
{
	QuestTabCtrl.InitTabCtrl();
	ShowQuestList();
	
	QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
	
	if(QuestAutoAlarm == true)
	{
		CheckAssignNotifier.SetCheck(true);
	}
	else
	{
		CheckAssignNotifier.SetCheck(false);
	}
	MainTree0.HideWindow();
	MainTree1.HideWindow();
	MainTree2.HideWindow();
	MainTree3.HideWindow();
	MainTree4.HideWindow();
	
	if (CurTree == MainTree0)
	{
		QuestTabCtrl.SetTopOrder(0,false);
	}
	else if (CurTree == MainTree1)
	{
		QuestTabCtrl.SetTopOrder(1,false);
	}
	else if (CurTree == MainTree2)
	{
		QuestTabCtrl.SetTopOrder(2,false);
	}
	else if (CurTree == MainTree3)
	{
		QuestTabCtrl.SetTopOrder(3,false);
	}
	else if (CurTree == MainTree4)
	{
		QuestTabCtrl.SetTopOrder(4,false);
	}

	//~ CurTree.ShowWindow();
	CurTree.Setfocus();
}

function OnHide()
{
}
function OnClickButton( string strID )
{	
	switch( strID )
	{
	case "btnClose":
		if (Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
		}
		else 
		{
			UpdateTargetInfo();
			Drawer.ShowWindow();
		}
		break;	
	case "QuestTreeTab0":
		m_txtQuestNum.ShowWindow();
		CurTree.HideWindow();
		CurTree = MainTree0;
		MainTree0.ShowWindow();
		Drawer_btnGiveUpCurrentQuest.DisableWindow();
		break;
	case "QuestTreeTab1":
		m_txtQuestNum.ShowWindow();
		CurTree.HideWindow();
		CurTree = MainTree1;
		MainTree1.ShowWindow();
		Drawer_btnGiveUpCurrentQuest.DisableWindow();
		break;
	case "QuestTreeTab2":
		m_txtQuestNum.ShowWindow();
		CurTree.HideWindow();
		CurTree = MainTree2;
		MainTree2.ShowWindow();
		Drawer_btnGiveUpCurrentQuest.DisableWindow();
		break;
	case "QuestTreeTab3":
		m_txtQuestNum.ShowWindow();
		CurTree.HideWindow();
		CurTree = MainTree3;
		MainTree3.ShowWindow();
		Drawer_btnGiveUpCurrentQuest.DisableWindow();
		break;
	case "QuestTreeTab4":
		m_txtQuestNum.HideWindow();
		CurTree.HideWindow();
		CurTree = MainTree4;
		MainTree4.ShowWindow();
		Drawer_btnGiveUpCurrentQuest.DisableWindow();
		break;
	case "btnDetailInfo":
		Drawer.ShowWindow();
		break;
	}
	
	if (Left(strID, 4) == "root")
	{
		UpdateTargetInfo();
		GetCurrentJournalID(strID);
		Drawer_btnGiveUpCurrentQuest.EnableWindow();
	}
}

function GetCurrentJournalID(string strID)
{
	local int SplitCount;
	local array<string>	arrSplit;
	//~ local int i;
	
	SplitCount = Split(strID, ".", arrSplit);
	
	if (SplitCount == 2)
	{
		Drawer.ShowWindow();
		SetCurrentQuestJournalOnDrawerWnd( int(arrSplit[1]),1,0);
		//~ CurTree.SetExpandedNode(arrSplit[1], true);
		//~ SetCurrentQuestJournalOnDrawerWnd( int(arrSplit[1]),1,0);
	}
	else if (SplitCount == 4)
	{
		
		Drawer.ShowWindow();
		SetCurrentQuestJournalOnDrawerWnd( int(arrSplit[1]), int(arrSplit[2]), int(arrSplit[3]));
	}
}


function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		 case "chkNpcPosBox":
		 if (checkNpcPosBox.IsChecked())
		 {
			 UpdateTargetInfo();
		 }		 
		 break;
		 
		 case "chkAssignNotifier":
		 if(CheckAssignNotifier.IsChecked())		//퀘스트 알림이 자동 해제가 체크되어 있을 경우
		 {
			 QuestAutoAlarm = true;
			 SetOptionBool("Game", "autoQuestAlarm",true);
		 }
		 else 
		 {
			 QuestAutoAlarm = false;
			 SetOptionBool("Game", "autoQuestAlarm",false);
		 }	
		 break;
	 }
}

function Clear()
{
	m_QuestNum = 0;
	UpdateQuestCount();
	m_OldQuestID = -1;
	m_CurNodeName = "";
	
	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	
	m_arrItemNodeName.Remove(0, m_arrItemNodeName.Length);
	m_arrItemString.Remove(0, m_arrItemString.Length);
	m_arrItemID.Remove(0, m_arrItemID.Length);
	m_arrItemQuestID.Remove(0, m_arrItemQuestID.Length);
	m_arrItemLevel.Remove(0, m_arrItemLevel.Length);
	m_arrItemNumList.Remove(0, m_arrItemNumList.Length);
	
	MainTree0.Clear();
	MainTree1.Clear();
	MainTree2.Clear();
	MainTree3.Clear();
	MainTree4.Clear();
	Drawer_QuestRewardItemTree.Clear();
}

//////////////////////
//Request Quest List
function ShowQuestList()
{
	class'QuestAPI'.static.RequestQuestList();		//EV_QuestListStart -> EV_QuestList -> EV_QuestListEnd
}


function InitTree()
{
	local XMLTreeNodeInfo	infNode;
	local string		strRetName;
	
	Clear();
	// 1. Add Root Item
	infNode.strName = "root";
	infNode.nOffSetX = 3;
	infNode.nOffSetY = 5;
	strRetName = MainTree0.InsertNode("", infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}
	strRetName = MainTree1.InsertNode("", infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}
	strRetName = MainTree2.InsertNode("", infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}	
	strRetName = MainTree3.InsertNode("", infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}
	strRetName = MainTree4.InsertNode("", infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}	
	strRetName = Drawer_QuestRewardItemTree.InsertNode("", infNode);
	
	//~ ListTrackItem1.DeleteAllItem();	
}

function HandleQuestListStart()
{
	//초기화
	InitTree();
	//~ debug ("Init");
	//~ ListTrackItem1.DeleteAllItem();
	m_TrackID = 0;
}

function HandleQuestList( String a_Param )
{
	local int QuestID;
	local int Level; 
	local int Completed;
	local int nQuestType;

	ParseInt( a_Param, "QuestID", QuestID );
	ParseInt( a_Param, "Level", Level );
	ParseInt( a_Param, "Completed", Completed );
	
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	
	if (m_OldQuestID != QuestID)
	{
		if (nQuestType != 4)
			m_QuestNum++;	//퀘스트 갯수 증가
		
		AddQuestInfo( "", QuestID, Level, Completed );
	}
	else
	{
		AddQuestInfo( m_CurNodeName, QuestID, Level, Completed );	
	}
	m_OldQuestID = QuestID;
}

function HandleQuestListEnd()
{
	local int		i, j;
	local bool		isExist;
	local int 		tempItemID;
	
	//아이템&퀘스트 갯수 갱신
	UpdateQuestCount();
	//UpdateItemCount(0);
	
	// 끝난 퀘스트 혹은 갱신된 저널에 대해 , 알리미 윈도우에도 업데이트를 해 주어야 한다. 
	
	// 알리미에는 있는데 퀘스트에 없으면 해당 알리미는 삭제하여준다.
	for(i=0; i< 25 ; i++)	// 하드코딩 죄송합니다. (__)    
	{
		isExist = false;
		tempItemID =  m_scriptAlarm.QuestItemNameID[i];
		if(tempItemID  != -1)
		{
			for (j=0; j<m_arrItemID.Length; j++)
			{	
				if(m_arrItemID[j] ==tempItemID)
				{
					isExist = true;
				}	
			}
			
			if(isExist == false)
			{
				m_scriptAlarm.DeleteQuestAlarm( m_scriptAlarm.QuestAlarmNameID[ i / 5] );
			}
		}
	}
	
	ButtonEnableCheck();
}

function OnEvent(int Event_ID,String param)
{
	local int ClassID;

	local int npcId;
	local int numOfKillMonsters;
	local int questId;
	local int RecentlyAddedQuestID;

	if( Event_ID == EV_QuestListStart )
	{
		HandleQuestListStart();
		//~ ListTrackItem1.DeleteAllItem();
	}
	else if( Event_ID == EV_QuestList )
	{
		HandleQuestList( param );
	}
	else if( Event_ID == EV_QuestListEnd )
	{		
		HandleQuestListEnd();
		InsertQuestTrackList();		
		ParseInt(param, "QuestID", RecentlyAddedQuestID);
	}
	else if( Event_ID == EV_QuestSetCurrentID )
	{
		HandleQuestSetCurrentID(param);
		CurTree.Setfocus();
		Me.SetFocus();
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		ParseInt( param, "classID", ClassID );	
		UpdateItemCount(ClassID);		
		if(Event_ID == EV_InventoryUpdateItem)
		{
			UpdateItemCountWhenAdd(ClassID);
		}
	}
	else if( Event_ID == EV_ExpandQuestAlarmKillMonster )
	{
		ParseInt( param, "questId", questId);
		ParseInt( param, "npcId", npcId );
		ParseInt( param, "numOfKillMonsters", numOfKillMonsters );
		
		UpdateItemCountExpand(npcId, numOfKillMonsters);
		UpdateMonsterCountWhenAdd( questId, npcId, numOfKillMonsters );
		ButtonEnableCheck();
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			//Cancel
			if (DialogGetID() == 0 )
			{
				m_scriptAlarm.DeleteQuestAlarm( m_DeleteQuestID );	// 알리미에서도 삭제
				
				class'QuestAPI'.static.RequestDestroyQuest(m_DeleteQuestID);
				SetQuestOff();
				
				//노드 삭제
				CurTree.DeleteNode(m_DeleteNodeName);
				
				m_DeleteQuestID = 0;
				m_DeleteNodeName = "";
				Drawer.HideWindow();
			}
			//Cannot Cancel
			else
			{
			}
		}
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if (Event_ID == EV_GamingStateEnter)	// 게임스테이트에 들어왔을때 창이 보여지고 있으면 가려준다.
	{
		if(Me.isShowWindow()) Me.HideWindow();
	}
}

//퀘스트Effect버튼을 클릭했을 때, 해당 퀘스트를 펼쳐서 보여준다
function HandleQuestSetCurrentID(string param)
{
	local string strNodeName;
	local string strChildList;
	local int RecentlyAddedQuestID;
	local int SplitCount;
	local int nQuestType;
	local array<string>	arrSplit;
	
	if (!ParseInt(param, "QuestID", RecentlyAddedQuestID))
		return;
		
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(RecentlyAddedQuestID, 1);
	
	
	switch(	nQuestType )
	{
		case 0 : CurTree = MainTree0; break;
		case 1 : CurTree = MainTree1; break;
		case 2 : CurTree = MainTree2; break;
		case 3 : CurTree = MainTree3; break;
		case 4 : CurTree = MainTree4; break;

		default : CurTree = MainTree0;

	}

	QuestTabCtrl.SetTopOrder(nQuestType, false);

	if (RecentlyAddedQuestID>0)
	{
		if(!Me.isShowWindow())	//이펙트 버튼을 누르면 창이 열리도록 한다.  (물론 창이 안떠있을 경우)
		{
			Me.ShowWindow();			
			PlayConsoleSound(IFST_WINDOW_OPEN);	// 사운드도 추가
		}
		
		// debug("nQuestType ::: " @ nQuestType);

		// 1. QuestNode Expand
		strNodeName = "root." $ RecentlyAddedQuestID;

		// debug("strNodeName::" @ strNodeName);
		CurTree.SetExpandedNode(strNodeName, true);
		
		// 2. JournalNode Expand
		strChildList = CurTree.GetChildNode(strNodeName);
		
		// debug("노드 수 : " @ Len(strChildList));

		// Child중에서 가장 마지막 Child가 Expand할 저널
		if (Len(strChildList)>0)
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			
			CurTree.SetExpandedNode(arrSplit[SplitCount-1], true);

			// debug("SplitCount : " @ SplitCount);
			// debug("arrSplit : " @ arrSplit[SplitCount - 1] );
		}
		
		//Target정보 갱신
		UpdateTargetInfo();

		// 2009 9.21 추가 , 퀘스트 알람 버튼을 클릭하면 자동으로 퀘스트 내용 나오도록 수정
		if (Left(strNodeName, 4) == "root")
		{
			// debug("update strNodeName::" @ strNodeName);
			UpdateTargetInfo();
			//	GetCurrentJournalID(strNodeName);
			GetCurrentJournalID(arrSplit[SplitCount - 1]);
			Drawer_btnGiveUpCurrentQuest.EnableWindow();
		}		
	}
}



//퀘스트Effect버튼을 클릭했을 때, 해당 퀘스트를 펼쳐서 보여준다
function HandleQuestSetCurrentIDfromMiniMap(int QuestID, int Level, int nQuestType)
{
	local string strNodeName;
	local string strChildList;
	local int RecentlyAddedQuestID;
	local int SplitCount;
	local array<string>	arrSplit;
	local  TreeHandle tempCurTree;	
	tempCurTree = CurTree; //백업
	RecentlyAddedQuestID = QuestID;

	switch (nQuestType)
	{
		case 0:
			CurTree = MainTree0;
			break;
		case 1:
			CurTree = MainTree1;
			break;
		case 2:
			CurTree = MainTree2;
			break;
		case 3:
			CurTree = MainTree3;
			break;
		case 4:
			CurTree = MainTree4;
			break;
	}
	
	QuestTabCtrl.SetTopOrder(nQuestType, false);

	if (RecentlyAddedQuestID>0)
	{
		// 1. QuestNode Expand
		strNodeName = "root." $ RecentlyAddedQuestID;
		CurTree.SetExpandedNode(strNodeName, true);
			
		
		// 2. JournalNode Expand
		strChildList = CurTree.GetChildNode(strNodeName);
		
		// Child중에서 가장 마지막 Child가 Expand할 저널
		if (Len(strChildList)>0)
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode(arrSplit[SplitCount-1], true);
		}
		
		//Target정보 갱신
		UpdateTargetInfo();
	}
	CurTree = tempCurTree; //restore 핸들
}

//퀘스트 아이템 갯수 갱신(ClassID=0이면 전체 아이템을 갱신)
function UpdateItemCount( int ClassID, optional INT64 a_ItemCount )
{
	local int i;
	local int nPos;
	local INT64 ItemCount;
	local string strTmp;
	
	for (i=0; i<m_arrItemID.Length; i++)
	{	
		if (ClassID==0 || ClassID==m_arrItemID[i])
		{
			ItemCount = a_ItemCount;
			if( a_ItemCount == IntToInt64(-1) )
			{
				ItemCount = IntToInt64(0);
			}
			else if( a_ItemCount == IntToInt64(0) )
			{
				ItemCount = GetInventoryItemCount(GetItemID(m_arrItemID[i]));
			}
			nPos = InStr(m_arrItemString[i], "%s");
			if (nPos>-1)
			{
				strTmp = Left(m_arrItemString[i], nPos) $ Int64ToString(ItemCount) $ Mid(m_arrItemString[i], nPos+2);
				CurTree.SetNodeItemText(m_arrItemNodeName[i], m_arrItemID.Length-i, strTmp);
					
				if(ItemCount < IntToInt64(0))	ItemCount = ItemCount * IntToInt64(-1);	// 음수일 경우 - ~이상이므로 양수로 바꿔준다.				
				m_scriptAlarm.UpdateAlarmItem(m_arrItemID[i], ItemCount);	//아이템 업데이트 해주기
			}
		}
	}	
}

function UpdateItemCountExpand( int npcId, int numOfKillMonsters )
{
	local int i;
	local int nPos;
	local int npcCount;
	local string strTmp;
	
	for( i = 0; i < m_arrItemID.Length; i++ )
	{	
		if( npcId == 0 || npcId == m_arrItemID[ i ])
		{
			npcCount = numOfKillMonsters;
			if( numOfKillMonsters == -1 )
			{
				npcCount = 0;
			}
			else
			{
				npcCount = numOfKillMonsters;
			}

			nPos = InStr( m_arrItemString[ i ], "%s" );
			if ( nPos > -1 )
			{
				strTmp = Left( m_arrItemString[ i ], nPos ) $ string( npcCount ) $ Mid( m_arrItemString[ i ], nPos + 2 );
				CurTree.SetNodeItemText( m_arrItemNodeName[ i ], m_arrItemID.Length-i, strTmp );
					
				if( npcCount < 0 )
				{
					npcCount = npcCount * -1;	// 음수일 경우 - ~이상이므로 양수로 바꿔준다.				
				}
				m_scriptAlarm.UpdateAlarmExpand( m_arrItemID[ i ], npcCount );	//아이템 업데이트 해주기
			}
		}
	}	
}

//아이템을 획득하였을경우 자동으로 퀘스트 알리미에 등록해주기
function UpdateItemCountWhenAdd( int ClassID)
{
	local int 						i, j;
	local int 						nPos;
	local INT64 					ItemCount;
	local array<string>				arrSplit;
	local int						SplitCount;
	
	// 옵션이 체크되어 있으면 그냥 리턴
	if (QuestAutoAlarm == true)	return;
	for (i=0; i<m_arrItemID.Length; i++)
	{	
		if (ClassID==0 || ClassID==m_arrItemID[i])
		{
			nPos = InStr(m_arrItemString[i], "%s");
			if (nPos>-1)
			{			
				if(ClassID != 0)
				{		
					arrSplit.Remove(0,arrSplit.Length);
					SplitCount = Split(m_arrItemNodeName[i], ".", arrSplit);
					for (j = 0; j<SplitCount; j++)
					{
						switch(j)
						{
						case 0:	//"root"
							break;
						case 1:	//"QuestID"
							QuestID_Alarm = int(arrSplit[j]);
							break;
						case 2:	//"QuestLevel"
							QuestLevel_Alarm = int(arrSplit[j]);
							break;
						}
					}	
					
					for (j=0; j<m_arrItemNodeName.Length; j++)
					{
						if(m_arrItemQuestID[j] == QuestID_Alarm)
						{
							ItemCount = GetInventoryItemCount(GetItemID(ClassID));
							
							if(ItemCount != IntToInt64(0))	// 0개이면 삭제라는 뜻이다.
							{
								m_scriptAlarm.AddQuestAlarm(QuestID_Alarm,  QuestLevel_Alarm, m_arrItemID[j], IntToInt64(m_arrItemNumList[j]));
							}
						}
					}
					ButtonEnableCheck();					
				}
			}
		}
	}	
}

function UpdateMonsterCountWhenAdd( int questId, int npcId, int numOfKillMonsters )
{
	local int 						i, j;
	local int 						nPos;
//	local INT64 					KillCount;
	local array<string>				arrSplit;
	local int						SplitCount;

	// 옵션이 체크되어 있으면 그냥 리턴
	if (QuestAutoAlarm == true)
	{
		return;
	}

	for ( i = 0; i < m_arrItemID.Length; i++ )
	{
		if( npcId == -1 || npcId == m_arrItemID[ i ] )
		{
			nPos = InStr( m_arrItemString[ i ], "%s" );

			if( nPos > -1 )
			{
				if( npcId != 0 )
				{
					arrSplit.Remove( 0, arrSplit.Length );
					SplitCount = Split( m_arrItemNodeName[i], ".", arrSplit );
					for( j = 0; j < SplitCount; j++ )
					{
						switch( j )
						{
						case 0:	//"root"
							break;
						case 1:	//"QuestID"
							QuestID_Alarm = int( arrSplit[ j ] );
							break;
						case 2:	//"QuestLevel"
							QuestLevel_Alarm = int( arrSplit[ j ] );
							break;
						}
					}	
					
					for( j = 0; j < m_arrItemNodeName.Length; j++ )
					{	
						if( m_arrItemQuestID[ j ] == QuestID_Alarm )
						{
							if(numOfKillMonsters != 0)	// 0개이면 삭제라는 뜻이다.
							{
								if( m_arrItemID[j] == npcId )
								{
									m_scriptAlarm.AddQuestAlarmExpand( QuestID_Alarm, QuestLevel_Alarm, npcId, numOfKillMonsters, IntToInt64(m_arrItemNumList[j]));
								}
								else
								{
									if( questId == QuestID_Alarm )
										m_scriptAlarm.AddQuestAlarmExpand( QuestID_Alarm, QuestLevel_Alarm, m_arrItemID[j], 0, IntToInt64(m_arrItemNumList[j]));
								}
							}
						}
					}
				}
			}
		}
	}
}

//현재 퀘스트 갯수 갱신
function UpdateQuestCount()
{
	m_txtQuestNum.SetText("(" $ m_QuestNum $ "/" $ QUESTTREEWND_MAX_COUNT $ ")");
}

//퀘스트 목적지 표시 관련
function UpdateTargetInfo()
{
	local int				i;
	local array<string>		arrSplit;
	local int				SplitCount;
	
	local int QuestID;
	local int Level;
	local int Completed;
	
	local string strChildList;
	local string strTargetNode;
	
	local string strNodeName;
	local string strTargetName;
	local vector vTargetPos;
	local bool bOnlyMinimap;
	
	//~ checkNpcPosBox.SetCheck();

	//위치표시 체크박스
	if (!checkNpcPosBox.IsChecked())
	{
		 SetQuestOff();
		 return;
	}
	
	strNodeName = GetExpandedNode();
	if (Len(strNodeName)<1)
	{
		SetQuestOff();
		//~ debug ("
		//~ strNodeName = m_CurNodeName $ ".1.0";
		//~ debug ("change" @ strNodeName);
		return;
	}	
	//~ debug ("change1" @ strNodeName);
	///////////////////////////////////////////////////////////////////////
	//Expanded된 노드가 가리키는 퀘스트의 Target표시용 저널을 찾아야함
	///////////////////////////////////////////////////////////////////////
	
	// 1. Child노드를 구한다.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child가 있으면, Child중에서 가장 마지막 Child가 Target표시용 저널
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	else
	{
		SetQuestOff();
		return;
	}
	// 3. 이름을 분석해서, QuestID와 Level을 취득
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split(strTargetNode, ".", arrSplit);
	for (i=0; i<SplitCount; i++)
	{
		switch(i)
		{
		//"root"
		case 0:
			break;
		//"QuestID"
		case 1:
			QuestID = int(arrSplit[i]);
			break;
		//"QuestLevel"
		case 2:
			Level = int(arrSplit[i]);
			break;
		//"IsCompleted"
		case 2:
			Completed = int(arrSplit[i]);
			break;
		}
	}
	if (QuestID>0 && Level>0)
	{
		//Target이름 취득
		strTargetName = class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
		vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		
		if (Completed==0 && Len(strTargetName)>0)
		{
			bOnlyMinimap = class'UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level);
			if (bOnlyMinimap)
			{
				class'QuestAPI'.static.SetQuestTargetInfo( true, false, false, strTargetName, vTargetPos, QuestID);
			}
			else
			{
				class'QuestAPI'.static.SetQuestTargetInfo( true, true, true, strTargetName, vTargetPos, QuestID);
			}
		}
		else
		{
			SetQuestOff();
		}
	}
	ButtonEnableCheck();
}

function SetQuestOff()
{
	local vector vVector;
	class'QuestAPI'.static.SetQuestTargetInfo( false, false, false, "", vVector, 0);
		
	QuestID_Alarm = -1;
	QuestLevel_Alarm = -1;
	QuestEnd_Alarm = -1;
}

function string GetExpandedNode()
{
	local array<string>	arrSplit;
	local int		SplitCount;
	local string	strNodeName;
	
	strNodeName = CurTree.GetExpandedNode("root");
	SplitCount = Split(strNodeName, "|", arrSplit);
	if (SplitCount>0)
	{
		strNodeName = arrSplit[0];
	}
	return strNodeName;
}


//퀘스트 중단
function HandleQuestCancel()
{
	local array<string>	arrSplit;
	local int		SplitCount;
	
	local string	strNodeName;
	
	local string	strDeleteQuestName;	
	local string	strDeleteQuestMessage;	
	
	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	
	//Expanded된 노드를 구한다.
	strNodeName = GetExpandedNode();
	SplitCount = Split(strNodeName, "|", arrSplit);
	if (SplitCount>0)
	{
		strNodeName = arrSplit[0];
		
		arrSplit.Remove(0,arrSplit.Length);
		SplitCount = Split(strNodeName, ".", arrSplit);
		if (SplitCount>1)
		{
			m_DeleteQuestID = int(arrSplit[1]);
			m_DeleteNodeName = strNodeName;
		}
	}
	
	if (Len(m_DeleteNodeName)<1)
	{
		//Set Delete Quest Message
		strDeleteQuestMessage = GetSystemMessage(1201);
		
		DialogShow(DIALOG_Modalless,DIALOG_Notice, strDeleteQuestMessage);
		DialogSetID(1);
	}
	else
	{				
		//Get Delete Quest Name
		strDeleteQuestName = class'UIDATA_QUEST'.static.GetQuestName(m_DeleteQuestID);
		
		//Set Delete Quest Message
		strDeleteQuestMessage = MakeFullSystemMsg( GetSystemMessage(182), strDeleteQuestName, "");
		
		DialogShow(DIALOG_Modalless,DIALOG_Warning, strDeleteQuestMessage );
		DialogSetID(0);
	}

}



//////////////////////////////
//Add QuestInfo to TreeItem
function AddQuestInfo(string strParentName, int QuestID, int Level, int Completed)
{
	local XMLTreeNodeInfo		infNode;					//트리 노드의 구조 자체를 정의
	local XMLTreeNodeItemInfo		infNodeItem;				//트리 노드에 들어가는 놈  - 빈칸. 텍스트. 텍스쳐 일수 있다. 
	local XMLTreeNodeInfo		infNodeClear;				//infNode를 Reset 하기 위한 놈. 
	local XMLTreeNodeItemInfo		infNodeItemClear;			//infNodeItem을 Reset 하기 위한놈. 
	
	local string		strRetName;
	local string		strTmp;
	local string		monsterName;
	
	//Quest Info
	local int			nQuestType;
	local string			strTexture1;
	local string			strTexture2;
	local int			ItemCount;
	local ItemID		cID;
	local array<int>		arrItemIDList;
	local array<int>		arrItemNumList;
	
	local int			i;
	
	local bool			bShowCompletionItem;
	local bool			bShowCompletionJournal;
	
	//~ ListTrackItem1.DeleteAllItem();
	
	bShowCompletionItem = class'UIDATA_QUEST'.static.IsShowableItemNumQuest(QuestID, Level);
	bShowCompletionJournal = class'UIDATA_QUEST'.static.IsShowableJournalQuest(QuestID, Level);
	if (Level ==1)
	{
		//Get Quest Name
		strTmp = class'UIDATA_QUEST'.static.GetQuestName(QuestID);
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node - with Button
		infNode = infNodeClear;
		infNode.strName = "" $ QuestID;
		infNode.bShowButton = 1;
		infNode.nTexBtnWidth = 15;
		infNode.nTexBtnHeight = 15;
		infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
		infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
		infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
		infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
		
		//Expand되었을때의 BackTexture설정
		//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
		infNode.nTexExpandedOffSetY = 1;					//OffSet
		infNode.nTexExpandedHeight = 13;					//Height
		infNode.nTexExpandedRightWidth = 32;				//오른쪽 그라데이션부분의 길이
		infNode.nTexExpandedLeftUWidth = 16; 				//스트레치로 그릴 왼쪽 텍스쳐의 UV크기
		infNode.nTexExpandedLeftUHeight = 13;
		infNode.nTexExpandedRightUWidth = 32; 				//스트레치로 그릴 오른쪽 텍스쳐의 UV크기
		infNode.nTexExpandedRightUHeight = 13;
		strRetName =  ProcInsertNode(  QuestID,  Level, "root", infNode);
		if (Len(strRetName) < 1)
		{
			return;
		}
		
		//Node Tooltip Clear
		
		//Insert Node Item - QuestName
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = strTmp;
		infNodeItem.nOffSetX = 3;
		infNodeItem.nOffSetY = 1;
		InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
		
		//Insert Node Item - QuestType
		nQuestType = 0;
		nQuestType = class'UIDATA_QUEST'.static.GetQuestType(QuestID, Level);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.bStopMouseFocus = true;
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 11;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_strTexture = strTexture1;
		if (Len(strTexture1)>0) InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
		infNodeItem.nOffSetX = 0;
		infNodeItem.u_strTexture = strTexture2;
		if (Len(strTexture2)>0) InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
		
		//Insert Node Item - QuestLevel
		//Insert Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.b_nHeight = 7;
		strParentName = strRetName;
		m_CurNodeName = strRetName;
	}
		
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - JounalName with Button
	
	//Get Quest Jounal Name
	strTmp = class'UIDATA_QUEST'.static.GetQuestJournalName(QuestID, Level);
	
	infNode = infNodeClear;
	infNode.strName = "" $ Level $ "." $ Completed;
	infNode.nOffSetX = 14;
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;
	
	
	//Expand되었을때의 BackTexture설정
	//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
	
	
	infNode.bTexBackHighlight = 0;
	infNode.nTexBackHighlightHeight  = 15;
	infNode.nTexBackWidth = 211; 
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = 3;
	infNode.nTexBackOffSetY = 0;
	infNode.nTexBackOffSetBottom =2;
	
	infNode.nTexExpandedOffSetX = 5;		//OffSet
	infNode.nTexExpandedOffSetY = 0;		//OffSet
	infNode.nTexExpandedHeight = 24;		//Height
	infNode.nTexExpandedRightWidth = 0;		//오른쪽 그라데이션부분의 길이
	infNode.nTexExpandedLeftUWidth = 29; 		//스트레치로 그릴 왼쪽 텍스쳐의 UV크기
	infNode.nTexExpandedLeftUHeight = 28;
	strRetName =  ProcInsertNode(  QuestID,  Level, strParentName, infNode);
	if (Len(strRetName) < 1)
	{
		return;
	}
	
	if (m_bDrawBg == true)
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 4;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 209;
		infNodeItem.u_nTextureHeight = 24;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 4;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureUHeight = 14;
		infNodeItem.u_nTextureWidth = 209;
		infNodeItem.u_nTextureHeight = 24;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
		m_bDrawBg = true;	
	}
	//Node Tooltip Clear
	//Insert Node Item - Journal Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strTmp;
	infNodeItem.nOffSetX = -202;
	infNodeItem.nOffSetY = 8;
	infNodeItem.t_color.R = 170;
	infNodeItem.t_color.G = 170;
	infNodeItem.t_color.B = 170;
	infNodeItem.t_color.A = 255;
	InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
	//Get Quest Target Name
	strTmp = class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
	if (Len(strTmp)>0)
	{
		//Insert Node Item - Show Target Icon
	}
	
	//Insert Node Item - Journal 완료
	if (Completed>0 && bShowCompletionJournal)
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "("$GetSystemString(898)$")";
		infNodeItem.t_color.R = 175;
		infNodeItem.t_color.G = 152;
		infNodeItem.t_color.B = 120;
		infNodeItem.t_color.A = 255;
		infNodeItem.nOffSetX = 4;
		infNodeItem.nOffSetY = 8;
		InsertNodeItem( QuestID, Level, strRetName, infNodeItem);
	}
	
	//Insert Node Item - Blank
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - Jounal Description
	
	//Get Quest Jounal Description
	//Insert Node Item - Item List
	strTmp = class'UIDATA_QUEST'.static.GetQuestItem(QuestID, Level);

	ParseInt( strTmp, "Max", ItemCount );
	arrItemIDList.Length = ItemCount;
	arrItemNumList.Length = ItemCount;
	
	for (i=0; i<ItemCount; i++)
	{
		ParseInt( strTmp, "ItemID_" $ i, arrItemIDList[i] );
		ParseInt( strTmp, "ItemNum_" $ i, arrItemNumList[i] );

		if (arrItemIDList[i] > 1000000)
		{   
			monsterName = class'UIDATA_NPC'.static.GetNPCName( arrItemIDList[i] - 1000000) $ GetSystemString(2240)  $ "(%s/" $ arrItemNumList[i] $ ")";

			m_arrItemNodeName.Insert(0, 1);	
			m_arrItemNodeName[0] = strRetName;
			m_arrItemID.Insert(0, 1);		
			m_arrItemID[0] = arrItemIDList[i];
			m_arrItemString.Insert(0, 1);		
			m_arrItemString[0] = monsterName;
			m_arrItemQuestID.Insert(0, 1);	
			m_arrItemQuestID[0] = QuestID;			//알리미용 추가
			
			m_arrItemLevel.Insert(0, 1);		
			m_arrItemLevel[0] = Level;				
			m_arrItemNumList.Insert(0, 1);	
			m_arrItemNumList[0] = arrItemNumList[i];	//알리미용 추가
			if(m_arrItemNumList[0] < 0)
			{
				m_arrItemNumList[0] = m_arrItemNumList[0] * -1;	// 음수이면 알리미에서는 그냥 양수처리
			}
			infNodeItem.t_nTextID = m_arrItemID.Length;	
		}
	}


	for (i=0; i<ItemCount; i++)
	{
		//Get Item Texture Name
		cID = GetItemID(arrItemIDList[i]);
		strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(cID);
		
		if (Len(strTmp)>0)
		{
			//Insert Node Item - Blank
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_BLANK;
			infNodeItem.b_nHeight = 4;
			
			//Insert Node Item - Icon BackTexture
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = 4;
			infNodeItem.u_nTextureWidth = 34;
			infNodeItem.u_nTextureHeight = 34;
			infNodeItem.u_strTexture = "L2UI_CH3.Etc.menu_outline";
			
			//Insert Node Item - Icon Texture
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -33;
			infNodeItem.nOffSetY = 1;
			infNodeItem.u_nTextureWidth = 32;
			infNodeItem.u_nTextureHeight = 32;
			infNodeItem.u_strTexture = strTmp;
			
			//Get Item Name
			strTmp = class'UIDATA_ITEM'.static.GetItemName(cID);
			
			//Insert Node Item - Item Name
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			infNodeItem.t_strText = strTmp;
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			infNodeItem.nOffSetX = 5;
			infNodeItem.nOffSetY = 1;
			
			//Insert Node Item - Item Count
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;

			if (arrItemNumList[i]>0)
			{
				if(Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ arrItemNumList[i] $ ")";
				}
				else
				{
					strTmp = "(%s/" $ arrItemNumList[i] $ ")";
					m_arrItemNodeName.Insert(0, 1);	m_arrItemNodeName[0] = strRetName;
					m_arrItemID.Insert(0, 1);		m_arrItemID[0] = arrItemIDList[i];
					m_arrItemString.Insert(0, 1);		m_arrItemString[0] = strTmp;
					m_arrItemQuestID.Insert(0, 1);	m_arrItemQuestID[0] = QuestID;			//알리미용 추가
					
					m_arrItemLevel.Insert(0, 1);		m_arrItemLevel[0] = Level;				
					m_arrItemNumList.Insert(0, 1);	m_arrItemNumList[0] = arrItemNumList[i];	//알리미용 추가
					if(m_arrItemNumList[0] < 0) m_arrItemNumList[0] = m_arrItemNumList[0] * -1;	// 음수이면 알리미에서는 그냥 양수처리
					infNodeItem.t_nTextID = m_arrItemID.Length;
				}
			}
			else if (arrItemNumList[i]==0)
			{
				if (Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ GetSystemString(858) $ ")";
				}
				else
				{
					strTmp = "(%s/" $ GetSystemString(858) $ ")";
					m_arrItemNodeName.Insert(0, 1);	m_arrItemNodeName[0] = strRetName;
					m_arrItemID.Insert(0, 1);		m_arrItemID[0] = arrItemIDList[i];
					m_arrItemString.Insert(0, 1);		m_arrItemString[0] = strTmp;
					m_arrItemQuestID.Insert(0, 1);	m_arrItemQuestID[0] = QuestID;
					m_arrItemLevel.Insert(0, 1);		m_arrItemLevel[0] = Level;	
					m_arrItemNumList.Insert(0, 1);	m_arrItemNumList[0] = arrItemNumList[i];	//알리미용 추가
					if(m_arrItemNumList[0] < 0) m_arrItemNumList[0] = m_arrItemNumList[0] * -1;	// 음수이면 알리미에서는 그냥 양수처리
					infNodeItem.t_nTextID = m_arrItemID.Length;
				}
			}
			else
			{
				if (Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ -arrItemNumList[i] $ GetSystemString(859) $ ")";
				}
				else
				{
					strTmp = "(%s/" $ -arrItemNumList[i] $ GetSystemString(859) $ ")";
					m_arrItemNodeName.Insert(0, 1);	m_arrItemNodeName[0] = strRetName;
					m_arrItemID.Insert(0, 1);		m_arrItemID[0] = arrItemIDList[i];
					m_arrItemString.Insert(0, 1);		m_arrItemString[0] = strTmp;
					m_arrItemQuestID.Insert(0, 1);	m_arrItemQuestID[0] = QuestID;
					m_arrItemLevel.Insert(0, 1);		m_arrItemLevel[0] = Level;	
					m_arrItemNumList.Insert(0, 1);	m_arrItemNumList[0] = arrItemNumList[i];	//알리미용 추가
					if(m_arrItemNumList[0] < 0) m_arrItemNumList[0] = m_arrItemNumList[0] * -1;	// 음수이면 알리미에서는 그냥 양수처리
					infNodeItem.t_nTextID = m_arrItemID.Length;
				}
			}
			infNodeItem.t_strText = strTmp;
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 42;
			infNodeItem.nOffSetY = -16;
		}	
	}
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 3;
}

function InitQuestTooltip()
{
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
		
	TooltipInfo.DrawList.length = 10;
	
	TooltipInfo.DrawList[0].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[0].u_nTextureWidth = 16;
	TooltipInfo.DrawList[0].u_nTextureHeight = 16;
	TooltipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
	
	TooltipInfo.DrawList[1].eType = DIT_TEXT;
	TooltipInfo.DrawList[1].nOffSetX = 5;
	TooltipInfo.DrawList[1].t_bDrawOneLine = true;
	TooltipInfo.DrawList[1].t_ID = 861;
	
	TooltipInfo.DrawList[2].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[2].nOffSetY = 2;
	TooltipInfo.DrawList[2].u_nTextureWidth = 16;
	TooltipInfo.DrawList[2].u_nTextureHeight = 16;
	TooltipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
	TooltipInfo.DrawList[2].bLineBreak = true;
	
	TooltipInfo.DrawList[3].eType = DIT_TEXT;
	TooltipInfo.DrawList[3].nOffSetY = 2;
	TooltipInfo.DrawList[3].nOffSetX = 5;
	TooltipInfo.DrawList[3].t_bDrawOneLine = true;
	TooltipInfo.DrawList[3].t_ID = 862;
	
	TooltipInfo.DrawList[4].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[4].nOffSetY = 2;
	TooltipInfo.DrawList[4].u_nTextureWidth = 16;
	TooltipInfo.DrawList[4].u_nTextureHeight = 16;
	TooltipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
	TooltipInfo.DrawList[4].bLineBreak = true;
	
	TooltipInfo.DrawList[5].eType = DIT_TEXT;
	TooltipInfo.DrawList[5].nOffSetY = 2;
	TooltipInfo.DrawList[5].nOffSetX = 5;
	TooltipInfo.DrawList[5].t_bDrawOneLine = true;
	TooltipInfo.DrawList[5].t_ID = 863;
	
	TooltipInfo.DrawList[6].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[6].nOffSetY = 2;
	TooltipInfo.DrawList[6].u_nTextureWidth = 16;
	TooltipInfo.DrawList[6].u_nTextureHeight = 16;
	TooltipInfo.DrawList[6].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_4";
	TooltipInfo.DrawList[6].bLineBreak = true;
	
	TooltipInfo.DrawList[7].eType = DIT_TEXT;
	TooltipInfo.DrawList[7].nOffSetY = 2;
	TooltipInfo.DrawList[7].nOffSetX = 5;
	TooltipInfo.DrawList[7].t_bDrawOneLine = true;
	TooltipInfo.DrawList[7].t_ID = 864;
	
	TooltipInfo.DrawList[8].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[8].nOffSetY = 2;
	TooltipInfo.DrawList[8].u_nTextureWidth = 16;
	TooltipInfo.DrawList[8].u_nTextureHeight = 16;
	TooltipInfo.DrawList[8].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_5";
	TooltipInfo.DrawList[8].bLineBreak = true;
	
	TooltipInfo.DrawList[9].eType = DIT_TEXT;
	TooltipInfo.DrawList[9].nOffSetY = 2;
	TooltipInfo.DrawList[9].nOffSetX = 5;
	TooltipInfo.DrawList[9].t_bDrawOneLine = true;
	TooltipInfo.DrawList[9].t_ID = 865;
}

//언어 변경 처리
function HandleLanguageChanged()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow(m_WindowName))
	{
		ShowQuestList();
	}	
}

// 퀘스트 알리미에 등록
function HandleAddAlarm()
{
	local int		i;
	local bool isRequestToServer;	
	isRequestToServer = true;
		
	GetNodeInfo_Alarm();
	
	// 퀘스트 아이디로 등록할 퀘스트 아이템을 등록한다. 
	
	for (i=0; i<m_arrItemNodeName.Length; i++)
	{	
		if(m_arrItemQuestID[i] == QuestID_Alarm)
		{
			m_scriptAlarm.isClickedAdd = true;
			//if( m_arrItemID[i] > 20000 && isRequestToServer)
			if( m_arrItemID[i] >= 1000000)
			{
				//m_scriptAlarm.AddQuestAlarmExpand( QuestID_Alarm, QuestLevel_Alarm, m_arrItemID[i], 0, m_arrItemNumList[i] );
				RequestAddExpandQuestAlarm(QuestID_Alarm);
				//isRequestToServer = false;
				
				continue;
			}
			else
			{
				m_scriptAlarm.AddQuestAlarm( QuestID_Alarm, QuestLevel_Alarm, m_arrItemID[i], IntToInt64(m_arrItemNumList[i]) );
			}
		}	
	}
	
	ButtonEnableCheck();
}

// 퀘스트 알리미에서 해제
function HandleDeleteAlarm()
{
	 local int		i;
		
	GetNodeInfo_Alarm();
	
	// 퀘스트 아이디로 등록할 퀘스트 아이템을 등록한다. 
	
	for (i=0; i<m_arrItemNodeName.Length; i++)
	{	
		if(m_arrItemQuestID[i] == QuestID_Alarm)
		{
			m_scriptAlarm.DeleteQuestAlarm( QuestID_Alarm );
		}	
	}
	
	ButtonEnableCheck();
}

//expanded 된 노드를 기준으로 버튼을 활성화 할 지 말지를 처리한다. 
function ButtonEnableCheck()
{
	
	local int i;
	
	local int QuestIDSlot;
	local bool isCanBeAddAlarm;
	GetNodeInfo_Alarm();
	
	// 퀘스트가 알림이를 표시할 수 있는지 검사한다.
	isCanBeAddAlarm = false;
	for (i=0; i<m_arrItemNodeName.Length; i++)
	{	
		if(m_arrItemQuestID[i] == QuestID_Alarm)
		{
			
			isCanBeAddAlarm = true;
			break;
		}	
	}	
	
	QuestIDSlot = m_scriptAlarm.QuestSlotIdx(QuestID_Alarm);
	
	if(QuestID_Alarm == 0 )
	{
	
		m_btnAddAlarm.DisableWindow();
		m_btnDeleteAlarm.DisableWindow();
	}
	else
	{
		// 등록되지 않은 퀘스트중 아이템 표시 가능할 경우  : 등록 버튼 enable, 등록 해제 버튼 disable
		if(QuestIDSlot < 0) 
		{
			if(isCanBeAddAlarm == true)	
				{	
					m_btnAddAlarm.EnableWindow();	
				}
			else					
				{	
					m_btnAddAlarm.DisableWindow();	
				}
			m_btnDeleteAlarm.DisableWindow();
		}
		else	// 이미 등록된 퀘스트를 검색. 등록버튼 disable, 등록 해제 버튼 enable
		{
			m_btnAddAlarm.DisableWindow();
			m_btnDeleteAlarm.EnableWindow();
		}
	}
}



// EXPand 노드에서 QuestID, QuestLevel, 완료 여부를 전역변수에 저장한다.
function GetNodeInfo_Alarm()
{	
	local string strNodeName;
	local string strTargetNode;
	
	local int		i;
	local array<string>	arrSplit;
	local int		SplitCount;
	
	local string strChildList;	
	

	strNodeName = GetExpandedNode();
	
	// 1. Child노드를 구한다.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child가 있으면, Child중에서 가장 마지막 Child가 Target표시용 저널
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	else
	{
		SetQuestOff();
		return;
	}
	// m_arrItemNodeName

// function ButtonEn
	// 3. 이름을 분석해서, QuestID와 Level을 취득
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split(strTargetNode, ".", arrSplit);
	for (i=0; i<SplitCount; i++)
	{
		switch(i)
		{
		//"root"
		case 0:
			break;
		//"QuestID"
		case 1:
			QuestID_Alarm = int(arrSplit[i]);
			break;
		//"QuestLevel"
		case 2:
			QuestLevel_Alarm = int(arrSplit[i]);
			break;
		//"IsCompleted"
		case 2:
			QuestEnd_Alarm = int(arrSplit[i]);
			break;
		}
	}	
}

function InsertNodeItem( int QuestID, int Level, string strRetName, XMLTreeNodeItemInfo infNodeItem)
{
	local int nQuestType;
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	switch (nQuestType)
	{
		case 0:
			MainTree0.InsertNodeItem(strRetName, infNodeItem);
			break;
		case 1:
			MainTree1.InsertNodeItem(strRetName, infNodeItem);
			break;
		case 2:
			MainTree2.InsertNodeItem(strRetName, infNodeItem);
			break;
		case 3:
			MainTree3.InsertNodeItem(strRetName, infNodeItem);
			break;
		case 4:
			MainTree4.InsertNodeItem(strRetName, infNodeItem);
			break;	
	}
}

function string ProcInsertNode( int QuestID, int Level, string strParentName, XMLTreeNodeInfo infNode)
{
	local string strRetName;
	local int nQuestType;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local array<string>	arrSplit;
	local string QuestName;
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	
	Split(strParentName,".", arrSplit);
	if ( strParentName == "")
	{
		strParentName = "root." $ string(QuestID) $ "." $ string(level) $ ".0";
	} 
	else if ( arrSplit[0] != "root" )
	{
		strParentName = "root." $ strParentName;
	}
	
	switch (nQuestType)
	{
		case 0:
				strRetName = MainTree0.InsertNode(strParentName, infNode);
			if (Len(strRetName) < 1)
			{
			}
			break;
		case 1:
				strRetName = MainTree1.InsertNode(strParentName, infNode);
			if (Len(strRetName) < 1)
			{
			}
			break;
		case 2:
				strRetName = MainTree2.InsertNode(strParentName, infNode);
			if (Len(strRetName) < 1)
			{
			}
			break;
		case 3:
				strRetName = MainTree3.InsertNode(strParentName, infNode);
			if (Len(strRetName) < 1)
			{
			}
			break;
		case 4:
				strRetName = MainTree4.InsertNode(strParentName, infNode);
			if (Len(strRetName) < 1)
			{
			}
			break;
	}
	
	QuestName = class'UIDATA_QUEST'.static.GetQuestName(QuestID);
	Split(strRetName,".", arrSplit);
	//~ if (Split(strRetName,".", arrSplit) > 0 && Split(strRetName,".", arrSplit) < 5 && int(arrSplit[1]) == 0 && int(arrSplit[2]) == 0 && Level == 1)
	
	// 2009.9.21 추가 , index 넘어가서 나는 에러 안나도록..
	if (arrSplit.Length > 3)
	{

		if ((arrSplit[3]) != "" &&(arrSplit[4]) != "" && Level == 1)
		{
			data1.nReserved1 = QuestID;
			data2.nReserved2 = Level;
			data1.nReserved3 = nQuestType;
			data1.szData = QuestName;
			Record.LVDataList[0] = data1;
			Record.LVDataList[1] = data2;
			//~ ListTrackItem1.InsertRecord( Record );
			m_QuestTrackData[m_TrackID] = Record;
			m_TrackID = m_TrackID + 1;
		}
	}
	return strRetName;
} 

function InsertQuestTrackList()
{
	local int i;
	ListTrackItem1.DeleteAllItem();	
	for (i= 0; i <m_TrackID; i++)
	{
		ListTrackItem1.InsertRecord( m_QuestTrackData[i] );
	}
}


function SetCurrentQuestJournalOnDrawerWnd(int QuestID, int QuestLevel, int Completed)
{
	local string 		strTmp;
	local int 		QuestType;
	local string 		QuestDescription;
	local string		QuestJournalName;
	local int		ItemCount;
	local int 		i;
	local string 		strRetName;
	
	local Array<int> rewardIDList;
	//~ local Array<int> rewardClear;
	local Array<int> rewardNumList;
	
	local Array<int> arrItemIDList;
	local Array<int> arrItemNumList;
	
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;
	
	local bool			bShowCompletionItem;
	local bool			bShowCompletionJournal;
	local Color QuestTypeColor;
	local Color QuestLevelColor;


	QuestLevelColor.R  = 175;
	QuestLevelColor.G = 152;
	QuestLevelColor.B  = 120;
	
	QuestTypeColor.R = 170;
	QuestTypeColor.G = 170;
	QuestTypeColor.B = 170;
	
	m_bDrawBg2 = true;
	m_bDrawBg3 = true;
	
	bShowCompletionItem = class'UIDATA_QUEST'.static.IsShowableItemNumQuest(QuestID, QuestLevel);
	bShowCompletionJournal = class'UIDATA_QUEST'.static.IsShowableJournalQuest(QuestID, QuestLevel);
	
	QuestJournalName = class'UIDATA_QUEST'.static.GetQuestJournalName(QuestID, QuestLevel);
	Drawer_txtQuestTitle.SetText(QuestJournalName);
	Drawer_txtQuestRecommandedLevel.SetTextColor(QuestTypeColor);
	Drawer_txtQuestRecommandedLevel.SetText(GetSystemString(922) @ ":");	
	Drawer_txtRecommandedLevelText.SetTextColor(QuestLevelColor);
	
	if (class'UIDATA_QUEST'.static.GetMaxLevel(QuestID,QuestLevel)>0 && class'UIDATA_QUEST'.static.GetMinLevel(QuestID,QuestLevel)>0)
	{
		strTmp = class'UIDATA_QUEST'.static.GetMinLevel(QuestID,QuestLevel) $ "~" $ class'UIDATA_QUEST'.static.GetMaxLevel(QuestID,QuestLevel);
	}
	else if (class'UIDATA_QUEST'.static.GetMinLevel(QuestID,QuestLevel)>0)
	{
		strTmp = class'UIDATA_QUEST'.static.GetMinLevel(QuestID,QuestLevel) $ " " $ GetSystemString(859);
	}
	else
	{
		//~ strTmp =  GetSystemString(922) $ ":" $ GetSystemString(866);
		strTmp =   GetSystemString(866);
	}
	
	Drawer_txtRecommandedLevelText.SetText(strTmp);
	Drawer_txtRecommandedLevelText.SetTextColor(QuestLevelColor);
	QuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(QuestID, QuestLevel);
	Drawer_txtQuestType.SetTextColor(QuestTypeColor);
	switch (QuestType)
	{
		case 0:
			Drawer_txtQuestType.SetText(GetSystemString(862));
			break;
		case 1:
			Drawer_txtQuestType.SetText(GetSystemString(861));
			break;
		case 2:
			Drawer_txtQuestType.SetText(GetSystemString(1998));
			break;
		case 3:
			Drawer_txtQuestType.SetText(GetSystemString(1999));
			break;
		case 4:
			Drawer_txtQuestType.SetText(GetSystemString(2000));
			break;
	}
	
	// Retrieve Quest Item Data;
	strTmp = class'UIDATA_QUEST'.static.GetQuestItem(QuestID, QuestLevel);
	ParseInt( strTmp, "Max", ItemCount );
	
	arrItemIDList.Length = ItemCount;
	arrItemNumList.Length = ItemCount;
	
	// 2009.09.21 
	// for (i=0; i <= ItemCount; i++) 이렇게 되어 있어서 0일때도 실행되어서 에러났다. 1일때만 실행해야 한다.
	for (i=0; i < ItemCount; i++)
	{
		ParseInt( strTmp, "ItemID_" $ i, arrItemIDList[i] );
		ParseInt( strTmp, "ItemNum_" $ i, arrItemNumList[i] );
	}
	
	// Retrieve Quest Rewarding Data 
	//~ rewardIDList.length = ItemCount;
	//~ rewardNumList.Length = ItemCount;
	
	//~ rewardIDList 	= 	rewardClear;
	//~ rewardNumList 	= 	rewardClear;
	
	rewardIDList.Remove(0, rewardIDList.Length);
	rewardNumList.Remove(0, rewardNumList.Length);
	
	class'UIDATA_QUEST'.static.GetQuestReward(QuestID, QuestLevel, rewardIDList, rewardNumList);
		
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Quest Description Insertion
	QuestDescription = class'UIDATA_QUEST'.static.GetQuestDescription(QuestID,QuestLevel);
	
	infNode = infNodeClear;
	infNode.strName = "QuestDescription";
	infNode.bFollowCursor = false;
	infNode.bShowButton = 0;
	
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = QuestDescription;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 0;
	
	//if 문으로 Quest Item이 있는지 여부를 확인 한 후 세팅한다.  추가 코딩 작업. 
	if (ItemCount != 0)
	{
	
		if (arrItemIDList[0] > 1000000)
		{
			Drawer_QuestDescriptionTree.HideWindow();
			Drawer_QuestDescriptionLargeTree.ShowWindow();
			Drawer_txtQuestItemTitle.HideWindow();
			Drawer_QuestItemTree.HideWindow();
			Drawer_GroupBox_DescriptionTree.HideWindow();
			Drawer_GroupBox_ItemTree.HideWindow();
			Drawer_QuestDescriptionLargeTree.Clear();
			Drawer_QuestDescriptionLargeTree.InsertNode("root", infNode);
			Drawer_QuestDescriptionLargeTree.InsertNodeItem("QuestDescription", infNodeItem);
		}
		else
		{
			Drawer_QuestDescriptionLargeTree.HideWindow();
			Drawer_QuestDescriptionTree.ShowWindow();
			Drawer_txtQuestItemTitle.ShowWindow();
			Drawer_GroupBox_DescriptionTree.ShowWindow();
			Drawer_GroupBox_ItemTree.ShowWindow();
			Drawer_QuestItemTree.ShowWindow();
			Drawer_QuestDescriptionTree.Clear();
			Drawer_QuestDescriptionTree.InsertNode("root", infNode);
			Drawer_QuestDescriptionTree.InsertNodeItem("QuestDescription", infNodeItem);
		}
	}
	else
	{
		Drawer_QuestDescriptionTree.HideWindow();
		Drawer_QuestDescriptionLargeTree.ShowWindow();
		Drawer_txtQuestItemTitle.HideWindow();
		Drawer_QuestItemTree.HideWindow();
		Drawer_GroupBox_DescriptionTree.HideWindow();
		Drawer_GroupBox_ItemTree.HideWindow();
		Drawer_QuestDescriptionLargeTree.Clear();
		Drawer_QuestDescriptionLargeTree.InsertNode("root", infNode);
		Drawer_QuestDescriptionLargeTree.InsertNodeItem("QuestDescription", infNodeItem);
	}                                            
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Quest Item Insertion
	if (ItemCount > 0 )
	{
		Drawer_QuestItemTree.Clear();
		infNode = infNodeClear;
		infNode.strName = "Root";
		Drawer_QuestItemTree.InsertNode("", infNode);
		//~ if (ItemCount > 3)
			//~ Drawer_QuestItemTree.ShowScrollBar(true);
		//~ else
			//~ Drawer_QuestItemTree.ShowScrollBar(false);
		
		for (i=0; i < ItemCount; i++)
		{
			infNode = infNodeClear;

			// 2009.11 퀘스트 파트에서 요청 
			// 100만 넘은 건 퀘스트 아이템에 등록 하지 않는다.
			// (예: 맹수 처치 퀘스트에서 몬스터를 몇마리 잡아라! 라고 한다면 , Item_id 는 100만 10 이라구 한다면 특정 몬스터를 10마리 잡아라
			// 이런식으러 퀘스트 파트에서 처리가 되어 있다. 그래서 들어 가는 코드이다.)
			// [ 가능하면 별도 속성으로 이런 것은 처리 했으면 좋을 것이다. ]
			/*
			if (arrItemIDList[i] > 1000000)
			{
				continue;
			}
			*/

			infNode.strName = "itemName" $ string(i);
			infNode.bShowButton = 0;
		
			//Expand되었을때의 BackTexture설정
			//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
			infNode.nTexExpandedOffSetX = -7;		//OffSet
			infNode.nTexExpandedOffSetY = 0;		//OffSet
			infNode.nTexExpandedHeight = 38;		//Height
			infNode.nTexExpandedRightWidth = 0;		//오른쪽 그라데이션부분의 길이
			infNode.nTexExpandedLeftUWidth = 32; 		//스트레치로 그릴 왼쪽 텍스쳐의 UV크기
			infNode.nTexExpandedLeftUHeight = 38;
			strRetName = class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestItemTree", "root", infNode);

			if (Len(strRetName) < 1)
			{
				return;
			}
			
			if (m_bDrawBg2 == true)
			{
				//Insert Node Item - 아이템 배경?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureUHeight = 14;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
				if ( i != ItemCount)
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);
				m_bDrawBg2 = false;
			}
			else
			{
				//Insert Node Item - 아이템 배경?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
				if ( i != ItemCount)
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);
				m_bDrawBg2 = true;	
			}
			
			//Insert Node Item - 아이템슬롯 배경
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -251;		// -4 // -2
			infNodeItem.nOffSetY = 2;			// -2 // -1
			infNodeItem.u_nTextureWidth = 36;
			infNodeItem.u_nTextureHeight = 36;
		
			infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
			if ( i != ItemCount)
			class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);
		
			//Insert Node Item - 아이템 아이콘
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -35;
			infNodeItem.nOffSetY = 3;
			infNodeItem.u_nTextureWidth = 32;
			infNodeItem.u_nTextureHeight = 32;

			infNodeItem.u_strTexture =  class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(arrItemIDList[i]));
		
			if ( i != ItemCount)
			class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);
		
			//Insert Node Item - 아이템 이름
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;

			infNodeItem.t_strText = class'UIDATA_ITEM'.static.GetItemName(GetItemID(arrItemIDList[i]));

			infNodeItem.t_bDrawOneLine = true;
			infNodeItem.nOffSetX = 8;
			infNodeItem.nOffSetY = 5;
		
			if ( i != ItemCount)
			class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);

			//Insert Node Item - Item Count
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			// [퀘스트 아이템 툴팁 추가] 퀘스트 아이템에 툴팁을 표시하기 위한 item class id를 저장.
			infNodeItem.nReserved = arrItemIDList[i];
			
			if (arrItemNumList[i]>0)
			{
				if(Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ arrItemNumList[i] $ ")";
				}
				else
				{
					strTmp = "(" $ arrItemNumList[i] $ ")";
				}
			}
			else if (arrItemNumList[i]==0)
			{
				if (Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ GetSystemString(858) $ ")";
				}
				else
				{
					strTmp = "(" $ GetSystemString(858) $ ")";
				}
			}
			else
			{
				if (Completed>0 && bShowCompletionItem)
				{
					strTmp = "(" $ GetSystemString(898) $ "/" $ -arrItemNumList[i] $ GetSystemString(859) $ ")";
				}
				else
				{
					strTmp = "(" $ -arrItemNumList[i] $ GetSystemString(859) $ ")";
				}
			}
			infNodeItem.t_strText = strTmp;
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 48;
			infNodeItem.nOffSetY = -20;
			if ( i != ItemCount)
			class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestItemTree", strRetName, infNodeItem);
		}	
	}		
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// Quest Reward Item Insertion
	
	//~ rewardIDList.Remove(0, rewardIDList.Length);
	//~ rewardNumList.Remove(0, rewardNumList.Length);
	//~ class'UIAPI_TREECTRL'.static.Clear("QuestTreeDrawerWnd.QuestRewardItemTree");
	Drawer_QuestRewardItemTree.Clear();
	infNode = infNodeClear;
	infNode.strName = "root";
		//~ Drawer_QuestRewardItemTree.InsertNode("", infNode);
	class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestRewardItemTree", "", infNode);
	//~ class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestRewardItemTree", "", infNode);
	if (rewardIDList.length > 0 )
	{
		//~ Drawer_QuestRewardItemTree.Clear();
		//~ class'UIAPI_TREECTRL'.static.Clear("QuestTreeDrawerWnd.QuestRewardItemTree");
		//~ infNode = infNodeClear;
		//~ infNode.strName = "root";
		//~ Drawer_QuestRewardItemTree.InsertNode("", infNode);
		//~ class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestRewardItemTree", "", infNode);
		//~ if (rewardIDList.length > 2)
			//~ Drawer_QuestRewardItemTree.ShowScrollBar(true);
		//~ else
			//~ Drawer_QuestRewardItemTree.ShowScrollBar(false);
		
		for (i=0; i<rewardIDList.length; i++)
		{
			infNode = infNodeClear;

			infNode.strName = "RewardItem" $ i;
			//infNode.Tooltip = MakeTooltipSimpleText(infNode.strName);
			infNode.bShowButton = 0;
			infNode.nTexExpandedOffSetX = 0;		//OffSet
			infNode.nTexExpandedOffSetY = 0;		//OffSet
			infNode.nTexExpandedHeight = 38;		//Height
			infNode.nTexExpandedRightWidth = 0;		//오른쪽 그라데이션부분의 길이
			infNode.nTexExpandedLeftUWidth = 30; 		//스트레치로 그릴 왼쪽 텍스쳐의 UV크기
			infNode.nTexExpandedLeftUHeight = 38;
			
			strRetName = class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestRewardItemTree", "root", infNode);
			if (Len(strRetName) < 1)
			{
				return;
			}
			else
			{
				//~ debug (strRetName);
			}
			
			if (m_bDrawBg3 == true)
			{
				//Insert Node Item - 아이템 배경?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureUHeight = 14;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
				if(i != rewardIDList.length)
					class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
				m_bDrawBg3 = false;
			}
			else
			{
				//Insert Node Item - 아이템 배경?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
				if(i != rewardIDList.length)
					class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
				m_bDrawBg3 = true;	
			}
			
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -251;		// -4 // -2
			infNodeItem.nOffSetY = 2;			// -2 // -1
			infNodeItem.u_nTextureWidth = 36;
			infNodeItem.u_nTextureHeight = 36;
		
			infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow_df_frame";
			if(i != rewardIDList.length)
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
		
			//Insert Node Item - 아이템 아이콘
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -35;
			infNodeItem.nOffSetY = 3;
			infNodeItem.u_nTextureWidth = 32;
			infNodeItem.u_nTextureHeight = 32;
			
			
			switch (rewardIDList[i])
			{
				/*
				case -1000:
					infNodeItem.u_strTexture = "icon.etc_exp_point_i00";
					break;
				case -1001:
					infNodeItem.u_strTexture = "icon.etc_sp_point_i00";
					break;
				case -1002:
					infNodeItem.u_strTexture = "L2UI_CH3.TutorialBtn";
					break;
				case -1003:
					infNodeItem.u_strTexture =  "icon.etc_vitality_point_i00";
					break;
				case -1004:
					infNodeItem.u_strTexture =  "icon.etc_pvp_point_i00";
					break;
				*/
				case 57:
					infNodeItem.u_strTexture =  class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));
					break;
				default:
					infNodeItem.u_strTexture =  class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
			}

			if(i != rewardIDList.length)
			{
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
				//~ debug ("2strRetName" @ strRetName);
				//~ debug ("infNodeItem" @ infNodeItem.u_strTexture);
			}
			
			//Insert Node Item - 아이템 이름
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;

			infNodeItem.t_bDrawOneLine = true;
			infNodeItem.nOffSetX = 8;
			infNodeItem.nOffSetY = 5;
			
			switch (rewardIDList[i])
			{
				/*
				case -1000:
					//~ infNodeItem.t_strText = "경험치";
					infNodeItem.t_strText = GetSystemString(89);
					break;
				case -1001:
					//~ infNodeItem.t_strText = "SP";
					infNodeItem.t_strText = GetSystemString(92);
					break;
				case -1002:
					//~ infNodeItem.t_strText = "보상시 결정";
					infNodeItem.t_strText = GetSystemString(1995);
					break;
				case -1003:
					//~ infNodeItem.t_strText = "활력";
					infNodeItem.t_strText = GetSystemString(1996);
					break;
				case -1004:
					//~ infNodeItem.t_strText = "PVP 포인트"; 
					infNodeItem.t_strText = GetSystemString(1997);
					break;
				*/
				case 57:
					//~ infNodeItem.t_strText = "아데나"; 
					infNodeItem.t_strText = GetSystemString(469);	
					break;
				default:
					infNodeItem.t_strText =  class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
					break;
			}
		
			if(i != rewardIDList.length)
			{
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
				//~ debug ("3strRetName" @ strRetName);
				//~ debug ("infNodeItem" @ infNodeItem.t_strText);
			}

			//Insert Node Item - Item Count
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;

			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 48 ;
			infNodeItem.nOffSetY = -20;
		
			switch (rewardIDList[i])
			{
				/*
				case -1000:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else 
						infNodeItem.t_strText = string(rewardNumList[i]);
					break;
				case -1001:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else 
						infNodeItem.t_strText = string(rewardNumList[i]);
					break;
				case -1002:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else 
						infNodeItem.t_strText = "";
					break;
				case -1003:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);	
					else 
						infNodeItem.t_strText = string(rewardNumList[i]);
					break;
				case -1004:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else 
						infNodeItem.t_strText = string(rewardNumList[i]);
					break;
				*/
				
				case 57:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else
						//~ infNodeItem.t_strText = string(rewardNumList[i]) $ " 아데나";
						infNodeItem.t_strText = MakeFullSystemMsg(GetSystemMessage(2932), string(rewardNumList[i]),"");
					break;
				//~ case 0:
					//~ infNodeItem.t_strText = "미정";
					//~ break;
				default:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "미정";
						infNodeItem.t_strText = GetSystemString(584);
					else
					{		
						// debug("=========> @ " @ rewardNumList[i]);

						// 아래에 해당하는 경우 몇 "개" 표시가 안되어야 한다.
						if (rewardIDList[i] == 15623 ||   // 경험치  
							rewardIDList[i] == 15624 ||   // 스킬 포인트
							rewardIDList[i] == 15625 ||   // 물음표        
							rewardIDList[i] == 15626 ||   // 활력 포인트
							rewardIDList[i] == 15627 ||   // 혈맹 포인트
							rewardIDList[i] == 15628 ||   // 랜덤 보상
							rewardIDList[i] == 15629 ||   // 정산형 보상
							rewardIDList[i] == 15630 ||   // 추가 보상
							rewardIDList[i] == 15631 ||   // 서브 클래스 권한 획득
							rewardIDList[i] == 15632 ||   // PK 카운트 하락 
							rewardIDList[i] == 15633)
						{
							infNodeItem.t_strText = string(rewardNumList[i]);
						}
						else
						{
							//~ infNodeItem.t_strText = string(rewardNumList[i]) $ "개";
							infNodeItem.t_strText = MakeFullSystemMsg(GetSystemMessage(1983), string(rewardNumList[i]),"");
						}
						// [퀘스트 아이템 툴팁 추가] 퀘스트 보상 아이템에 툴팁을 표시하기 위한 item class id를 저장.
						infNodeItem.nReserved = rewardIDList[i];
					}
					break;
			}
			
			if(i != rewardIDList.length)
			{
				class'UIAPI_TREECTRL'.static.InsertNodeItem("QuestTreeDrawerWnd.QuestRewardItemTree", strRetName, infNodeItem);
				//~ debug ("3strRetName" @ strRetName);
				//~ debug ("infNodeItem" @ infNodeItem.t_strText);
			}	
		}	
	}
}

function int GetSelectedJournalQuestID(string CurrentSelectedNodeID)
{
	local int i;
	local int temp;
	for (i=0;i<m_arrItemID.Length;i++)
	{
		if (m_arrItemNodeName[i] == CurrentSelectedNodeID)
		{
			temp = m_arrItemQuestID[i];
		}
	}
	return temp;
}



function int GetSelectedJournalLevelID(string CurrentSelectedNodeID)
{
	local int i;
	local int temp;
	for (i=0;i<m_arrItemID.Length;i++)
	{
		if (m_arrItemNodeName[i] == CurrentSelectedNodeID)
		{
			temp= m_arrItemLevel[i];
		}
	}
	return temp;
}
defaultproperties
{
    m_WindowName="QuestTreeWnd"
}
