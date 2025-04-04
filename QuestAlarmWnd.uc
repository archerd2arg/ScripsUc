/////////////////////////////////////////////////////////////////////////////////////////////
//								퀘스트 알리미 창 									     //
//														- create by innowind 2007.10.17	     //
/////////////////////////////////////////////////////////////////////////////////////////////

class QuestAlarmWnd extends UICommonAPI;
	
// 디파인 지정
// 확장 타이머
const TIMER_ID=11;
const TIMER_DELAY=2000;			// 이 딜레이만큼 오버되면 창이 확장된다.
// 축소 타이머
const TIMER_ID2=12;
const TIMER_DELAY2=500;			// 이 딜레이만큼 오버되면 창이 축소된다.

const EXPEND_CONTRACT_GAP = 37;

const CONTRACT_WIN_WIDTH = 213;
const EXPEND_WIN_WIDTH = 250;		// 확장된 전체 윈도우 넓이

const CONTRACT_QUEST_NAME_WIDTH = 198;
const EXPEND_QUEST_NAME_WIDTH = 235;	// 퀘스트 이름 넓이

const CONTRACT_ITEM_NAME_WIDTH = 113;
const EXPEND_ITEM_NAME_WIDTH = 150;	// 아이템 이름 넓이

const QUEST_ITEM_NUM_DEFAULT = 85;		// 퀘스트 아이템 넓이


const TEXT_HEIGHT = 18;				// 텍스트 기본 높이
//const TEXT_HEIGHT_MARGIN = 2;			// 텍스트 간격

const WINDOW_HEIGHT_MARGIN = 10;		// 윈도우 사이의 간격

const MAX_ITEM = 5;				// 최대 아이템 수
const MAX_QUEST = 5;			// 최대 퀘스트 수
const MAX_QUEST_ALL = 25;		//위의 두 값을 곱한값 ;;

// 전역변수 선언부
var bool isWaitExpand;		// 창을 확장하기 위해 기다리고 있는가?
var bool isWaitContract;	// 창을 축소 되기 위해 기다리고 있는가?
var bool isExpand;		// 창이 현재 확장된 상태인가?

var bool isClickedAdd;		// 버튼 클릭으로 애드 했는지 확인하는 함수

var int m_NumOfQuest;		// 현재 보여지고 있는 퀘스트의 갯수

var int i, j;				// for 루프를 위한 변수

var Color Gold;
var Color White;
var Color Gray;

// 핸들 선언부
var WindowHandle Me;
var WindowHandle QuestWndOverCheck;
var ButtonHandle btnClose;

var WindowHandle QuestWnd[MAX_QUEST];
var NameCtrlHandle QuestAlarmName[MAX_QUEST];
var int QuestAlarmNameID[MAX_QUEST];
var NameCtrlHandle QuestItemName[MAX_QUEST_ALL];
var int QuestItemNameID[MAX_QUEST_ALL];
var TextBoxHandle QuestItemNum[MAX_QUEST_ALL];
var INT64 QuestItemNumInt[MAX_QUEST_ALL];

function OnRegisterEvent()
{
	RegisterEvent( EV_GamingStateExit );
	RegisterEvent( EV_MouseOver );
	RegisterEvent( EV_MouseOut );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
	Load();
	InitData();	//해당 윈도우의 초기화작업
	FitWindowSize();	//사이즈 조절작업
}

// 핸들 초기화
function Initialize()
{
	//핸들 생성부
	Me = GetHandle( "QuestAlarmWnd" );
	QuestWndOverCheck = GetHandle( "QuestWndOverCheck" );
	btnClose = ButtonHandle ( GetHandle( "QuestAlarmWnd.btnClose" ) );
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestWnd[i] =  GetHandle( "QuestAlarmWnd.QuestWnd" $ i+1 );
		QuestAlarmName[i] = NameCtrlHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestAlarmName1") );
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemName[i * 5 + j] = NameCtrlHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1) );
			QuestItemNum[i*5 + j] = TextBoxHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemNum" $ j + 1) );
			QuestItemNum[i*5 + j].SetAnchor("QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1, "TopRight", "TopLeft", 3, 0);
		}
	}	
}

function InitializeCOD()
{
	//핸들 생성부
	Me = GetWindowHandle( "QuestAlarmWnd" );
	QuestWndOverCheck = GetWindowHandle( "QuestWndOverCheck" );
	btnClose = GetButtonHandle ( "QuestAlarmWnd.btnClose" );
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestWnd[i] =  GetWindowHandle( "QuestAlarmWnd.QuestWnd" $ i+1 );
		QuestAlarmName[i] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestAlarmName1");
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemName[i * 5 + j] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1);
			QuestItemNum[i*5 + j] = GetTextBoxHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemNum" $ j + 1);
			QuestItemNum[i*5 + j].SetAnchor("QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1, "TopRight", "TopLeft", 3, 0);
		}
	}	
}

function Load()
{
	
	Gold.R = 175;
	Gold.G = 152;
	Gold.B = 120;
	Gold.A = 255;
	
	White.R = 250;
	White.G = 250;
	White.B = 250;
	White.A = 255;
	
	Gray.R = 135;
	Gray.G = 135;
	Gray.B = 135;
	Gray.A = 255;
}

function InitData()
{
	isWaitExpand = false;
	isExpand = false;
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestAlarmNameID[i] = -1;	// -1이면 빈슬롯
		QuestAlarmName[i].SetName("", NCT_Normal,TA_Left);
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemNameID[i*5 + j] = -1; 	// -1이면 빈슬롯
			QuestItemName[i*5 + j].SetName("", NCT_Normal,TA_Left);
			QuestItemNum[i*5 + j].SetText("");			
		}
	}	
	m_NumOfQuest= 0;
	
	isClickedAdd = false;
}

function OnEvent( int a_EventID, String a_Param )
{
	local string CurrentWndName;
	local string ParentWndName;
	
	switch( a_EventID )
	{
	case EV_MouseOver:
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse over!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{
			if(isExpand == false)	// 창이 축소된 상태에서만 확장된 상태로 만들 수 있음
			{
				Me.SetTimer(TIMER_ID,TIMER_DELAY);
				isWaitExpand = true;
			}
		}
		break;
	
	case EV_MouseOut:
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse out!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{			
			if(isExpand == true)	// 확장된 상태에서만 줄여줄 수 있다. 
			{
				ContractWindowSize();
				isExpand = false;
				isWaitContract = false;
			}
			isWaitExpand = false;
		}
		break;
	case EV_GamingStateExit:	//나갈때 초기화해주기
		InitData();
		break;
	}
}

// 타이머 기동
function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		if(isExpand == false && isWaitExpand == true )	// 창이 확장되지 않은 상태에서만 확장해준다.
		{
			ExpendWindowSize();
			
			isExpand = true;
			isWaitExpand = false;
		}
		Me.KillTimer( TIMER_ID );
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnClose":
		OnbtnCloseClick();
		break;
	}
}

function OnbtnCloseClick()
{
	InitData();
	if(Me.isShowWindow()) Me.HideWindow();
}

// 확장될 경우 윈도우 사이즈 변화들
function ExpendWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//넓이는 어짜피 사용하지 않기 때문에 그냥 변수(i) 재활용
	
	Me.SetWindowSize( EXPEND_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //넓이는 어짜피 사용하지 않기 때문에 그냥 변수(j) 재활용
		QuestWnd[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < EXPEND_ITEM_NAME_WIDTH && nWidth > 5)	// 5은 그냥 가라. (아이템 이름이 5픽셀 이하일 수 없기 때문에 ) 매우 작은 윈도우 사이즈 ("") 를 기준으로 사이즈를 맞추려고 하지 못하게 하기 위해
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( EXPEND_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(CONTRACT_WIN_WIDTH - EXPEND_WIN_WIDTH  ,0);	// 갭만큼 이동시켜 준다.
}

// 축소될 경우 윈도우 사이즈 변화들
function ContractWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//넓이는 어짜피 사용하지 않기 때문에 그냥 변수(i) 재활용	
	Me.SetWindowSize( CONTRACT_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //넓이는 어짜피 사용하지 않기 때문에 그냥 변수(j) 재활용
		QuestWnd[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < CONTRACT_ITEM_NAME_WIDTH  && nWidth > 5) // 5은 그냥 가라. (아이템 이름이 5픽셀 이하일 수 없기 때문에 ) 매우 작은 윈도우 사이즈 ("") 를 기준으로 사이즈를 맞추려고 하지 못하게 하기 위해
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( CONTRACT_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(EXPEND_WIN_WIDTH - CONTRACT_WIN_WIDTH   ,0);	// 갭만큼 이동시켜 준다.
}

// 현재 등록된 퀘스트들에 맞게 윈도우 사이즈를 조절한다.  (주로 세로 사이즈)
function FitWindowSize()
{

	local int Width, Height;
	
	local int totalHeight; //총 윈도우의 높이
	local int oneWinHeight;	// 윈도우 하나의 높이
	
	totalHeight = 0;
	m_NumOfQuest = 0;
	for(i = 0; i<MAX_QUEST ; i++)	// 퀘스트가 등록되었다면, 퀘스트 윈도우를 쇼우 해준다. 
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			if(QuestWnd[i].IsShowWindow())		//등록되지 않았는데 show 되고있다면 하이드 시켜준다.
			{
				QuestWnd[i].HideWindow();
			}
		}
		else
		{
			m_NumOfQuest++;	// 표시되고 있는 퀘스트의 수를 증가시킨다.
			if(!QuestWnd[i].IsShowWindow())
			{
				QuestWnd[i].showWindow();
			}
			
			oneWinHeight = 0;
			
			oneWinHeight = oneWinHeight + TEXT_HEIGHT;	//퀘스트 이름줄			
			
			for(j=0 ; j<MAX_ITEM ; j++)
			{
				if( QuestItemNameID[i * 5 + j] != -1)	
				{
					oneWinHeight = oneWinHeight + TEXT_HEIGHT;
				}
			}
			totalHeight = totalHeight + oneWinHeight +WINDOW_HEIGHT_MARGIN;
			
			QuestWnd[i].GetWindowSize(Width, Height);
			QuestWnd[i].SetWindowSize(Width, oneWinHeight);
		}
	}
	
	if(m_NumOfQuest == 0)	
	{
		if(Me.IsShowWindow()) Me.HideWindow();
	}
	else
	{
		//debug("totalHeight = " $ totalHeight);
		Me.GetWindowSize(Width, Height);
		Me.SetWindowSize(Width, totalHeight);
		if(!Me.IsShowWindow()) Me.ShowWindow();	
	}
}

// 퀘스트 알람에 등록한다.
function AddQuestAlarm(int QuestID, int Level, int ItemID, INT64 ItemNum)
{
	local string QuestName, ItemName;
	local int idx, idxItem, idxItemSomeID;
	local INT64 itemCount;
	local String tempStr;
	local int nWidth, nHeight;
	
	//local int nItemNumWidth, nItemNumHeight;
		
	QuestName = class'UIDATA_QUEST'.static.GetQuestName(QuestID);
	ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(ItemID));
	
	// 퀘스트 아이디로 이미 등록된 퀘스트인지 검색한다.	
	idx = QuestSlotIdx(QuestID);
	if( idx == -1) 	// 이미 등록되어 있지 않은 퀘스트임.
	{
		idx = FindEmptyQuestSlot();
		if(idx == -1)	// 빈슬롯이 없으면 꺼져!
		{
			// 5개 이상 등록할 수 없습니다. 시스템 메세지 보여주기.
			if(isClickedAdd == true)
			{
				AddSystemMessage(2279);
			}			
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[idx].SetNameWithColor(QuestName, NCT_Normal,TA_Left, Gold);
			QuestAlarmNameID[idx] = QuestID;
		}
	}	
	
	// 아이템 이름 넣어주기.	
	idxItem = FindEmptyItemSlot(idx);	// 특정 퀘스트의 아이템 슬롯중 남은 것을 체크
	if(idxItem == -1)	// 빈슬롯이 없으면 꺼져!
	{
		//버그는 아니고 같은거 또 ADD 하면 여리 들어옴	
		return;
	}
	else
	{
		idxItemSomeID = QuestItemSlotIdx(idx, ItemID);
		
		if(idxItemSomeID == -1)	//같은 아이템이 없다면 추가
		{
			itemCount = GetInventoryItemCount(GetItemID(ItemID));		
			
			//debug("itemcount  = " $ string(itemCount));
			
			if(itemCount < ItemNum || ItemNum == IntToInt64(0))
			{
				tempStr = "- " $ ItemName;
				GetTextSizeDefault(tempStr, nWidth, nHeight);
				QuestItemName[idx*5 + idxItem].SetNameWithColor( tempStr, NCT_Normal,TA_Left, White);
				QuestItemNum[idx*5 + idxItem].SetTextColor(White);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i는 사용하지 않는 변수. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
			}
			else
			{
				tempStr = "- " $ ItemName;
				GetTextSizeDefault(tempStr, nWidth, nHeight);
				QuestItemName[idx*5 + idxItem].SetNameWithColor(tempStr, NCT_Normal,TA_Left, Gray);
				QuestItemNum[idx*5 + idxItem].SetTextColor(Gray);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i는 사용하지 않는 변수. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
			}
			 
			// 아이템 숫자 표시
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ "∞ )");
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ GetSystemString(858) $ ")");
			if(ItemNum < IntToInt64(1))	{QuestItemNum[idx*5 + idxItem].SetText( "(" $ Int64ToString(itemCount) $ ")");}	// 무제한 퀘는 현재 아이템의 개수만 표시해준다.
			else				
			{				
				QuestItemNum[idx*5 + idxItem].SetText( "(" $ Int64ToString(itemCount) $ "/" $ Int64ToString(ItemNum) $ ")");
				//if( itemCount < ItemNum )		QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ ItemNum $ ")");
				//else 						QuestItemNum[idx*5 + idxItem].SetText( "(" $ ItemNum $ "/" $ ItemNum $ ")");
			}
				
			QuestItemNameID[idx*5 + idxItem] = ItemID;	
			QuestItemNumInt[idx*5 + idxItem] = ItemNum;
		}
	}
	
	 FitWindowSize();
	
	isClickedAdd = false;
}

function AddQuestAlarmExpand(int questID, int questLevel, int npcId, int numOfKillMonsters, INT64 npcMaxCount)
{
	local int npcCurrentCount;

	local string questName, npcName;
	local int existQuestIndex;//, emptySlotIndex;
	local int emptyNpcSlotIndex, existNpcSlotIndex;

	local string tempStr;
	local int nWidth, nHeight;

	questName = class'UIDATA_QUEST'.static.GetQuestName( questId );

	//if( questType == 0)
	//{
	npcName = class'UIDATA_NPC'.static.GetNPCName( npcId - 1000000 );
	//}

	// 처치 : 2240
	npcName = npcName $ " " $ GetSystemString(2240);

	npcCurrentCount = numOfKillMonsters;

	existQuestIndex = QuestSlotIdx( questId );
	if( existQuestIndex == -1 )
	{
		existQuestIndex = FindEmptyQuestSlot( );
		if( existQuestIndex == -1 )
		{
			if( isClickedAdd == true )
			{
				AddSystemMessage( 2279 );
			}	
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[existQuestIndex].SetNameWithColor( questName, NCT_Normal, TA_Left, Gold );
			QuestAlarmNameID[existQuestIndex] = questId;
		}
	}

	emptyNpcSlotIndex = FindEmptyItemSlot( existQuestIndex );
	if(emptyNpcSlotIndex == -1)	
	{
		return;
	}
	else
	{
		existNpcSlotIndex = QuestItemSlotIdx( existQuestIndex, npcId );

		if( existNpcSlotIndex == -1 )
		{
			if( IntToInt64(npcCurrentCount) < npcMaxCount || npcMaxCount == IntToInt64(0) )
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, White );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( White );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}
			else
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, Gray );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( Gray );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}

			if( npcMaxCount < IntToInt64(1) )
			{
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ ")" );
			}
			else				
			{		
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ "/" $ Int64ToString( npcMaxCount ) $ ")" );
			}
				
			QuestItemNameID[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcId;
			QuestItemNumInt[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcMaxCount;
		}
	}

	FitWindowSize();	
	isClickedAdd = false;	
}


// 퀘스트 알람에서 삭제
function DeleteQuestAlarm(int QuestID )	
{
	local int idx;
	local Color tempColor;
	local int nWidth, nHeight;
	
	idx = QuestSlotIdx(QuestID); 
	
	if( idx == -1) 	// 이미 등록되어 있지 않은 퀘스트라면 아무것도 하지 않는다.
	{
		return; 
	}
	else
	{		
		// 아래 퀘스트들 땡겨주기
		for(i = idx + 1 ;  i < MAX_QUEST ; i++)
		{
			QuestAlarmName[i -1].SetNameWithColor( QuestAlarmName[i].GetName(), NCT_Normal,TA_Left, Gold);
			QuestAlarmNameID[i-1] = QuestAlarmNameID[i];	
			for (j=0 ; j<MAX_ITEM ; j++)
			{		
				tempColor =  QuestItemNum[i*5 + j].GetTextColor();
				
				QuestItemName[(i-1)*5 + j].SetNameWithColor(QuestItemName[i*5 + j].GetName() , NCT_Normal,TA_Left, tempColor);
				QuestItemName[i*5 + j].GetWindowSize(nWidth, nHeight);			// 윈도우 사이즈를 옮겨준다.
				QuestItemName[(i-1)*5 + j].SetWindowSize(nWidth, nHeight);
				QuestItemNameID[(i-1)*5 + j] = QuestItemNameID[i*5 + j]; 	
				QuestItemNum[(i-1)*5 + j].SetText( QuestItemNum[i*5 + j].GetText() );
				QuestItemNum[(i-1)*5 + j].SetTextColor (tempColor);
				QuestItemNumInt[(i-1)*5 + j] = QuestItemNumInt[i*5 + j];
			}
		}
		
		idx = MAX_QUEST - 1;
		QuestAlarmName[idx].SetName("", NCT_Normal,TA_Left);
		QuestAlarmNameID[idx] = -1;	
		for (j=0 ; j<MAX_ITEM ; j++)
		{		
			QuestItemName[idx*5 + j].SetName("", NCT_Normal,TA_Left);			
			QuestItemNameID[idx*5 + j] = -1; 	// -1이면 빈슬롯
			QuestItemNum[idx*5 + j].SetText("");
			QuestItemNumInt[idx*5 + j] = IntToInt64(-1);
		}
	}
	
	 FitWindowSize();
}

// 특정 아이디에 해당하는 퀘스트 아이템의 개수를 갱신하여 준다.
function UpdateAlarmItem(int ItemID , INT64 Count)
{
	local string NameTemp1;
	
	for( i = 0; i < MAX_QUEST_ALL; i++ )
	{
		if( QuestItemNameID[ i ] == ItemID)	
		{			
			if( Count < QuestItemNumInt[ i ]  || QuestItemNumInt[ i ] == IntToInt64(0) )	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}

			if(QuestItemNumInt[i] == IntToInt64(0))
			{
				QuestItemNum[i].SetText( "(" $ Int64ToString( Count ) $ ")");
			}
			else				
			{	
				QuestItemNum[i].SetText( "(" $ Int64ToString( Count) $ "/" $ Int64ToString( QuestItemNumInt[ i ] )  $ ")");
			}				
		}
	}
}

function UpdateAlarmExpand(int npcId , int Count)
{
	local string NameTemp1;

	for( i = 0; i<MAX_QUEST_ALL ; i++ )
	{
		if( QuestItemNameID[ i ] == npcId )	
		{			
			if( IntToInt64(Count) < QuestItemNumInt[ i ]  || QuestItemNumInt[ i ] == IntToInt64(0))	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName( );
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}
			
			if( QuestItemNumInt[i] == IntToInt64(0) )	
			{
				QuestItemNum[ i ].SetText( " (" $ string(Count) $ ")");
			}
			else				
			{	
				QuestItemNum[i].SetText( " (" $ string(Count) $ "/" $ Int64ToString(QuestItemNumInt[i])  $ ")");
			}				
		}
	}
}

// 빈 퀘스트 슬롯을 찾는다. -1이면 꽉 찼음
function int FindEmptyQuestSlot()
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

//해당 퀘스트 아이디의 인텍스를 리턴한다. 
function int QuestSlotIdx(int QuestID)
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == QuestID)
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

// 빈 퀘스트 아이템 슬롯을 찾는다. -1이면 꽉 찼음
function int FindEmptyItemSlot(int QuestIdx)
{
	local int itemSlotID;
	
	itemSlotID = -1;
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if( QuestItemNameID[QuestIdx * 5 + i] == -1)	
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}

//해당 퀘스트 아이템의 아이디 인텍스를 리턴한다. 
function int QuestItemSlotIdx(int QuestIdx , int ItemID)
{
	local int itemSlotID;
	
	itemSlotID = -1;	
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if(QuestItemNameID[QuestIdx * 5 + i]== ItemID)
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}
defaultproperties
{
}
