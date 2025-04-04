class GuideWnd extends UIScriptEx;
// Sets Max Value for Data Triger Loop 
const GUIDEICON_SIZE = 30;
const MAX_QUEST_NUM=500; 
const MAX_HUNTINGZONE_NUM=250;
const MAX_RAID_NUM=500;
// Sets Timer Value
const TIMER_ID=1; 
const TIMER_DELAY=4000; 
// Sets Domain Validation Number 
const HUNTING_ZONE_TYPE = 0;
// Sets Hunting Zone Validation Number
const HUNTING_ZONE_FIELDHUTINGZONE = 1;
const HUNTING_ZONE_DUNGEON = 2;
// Sets Area Info Validation Number 
const HUNTING_ZONE_CASTLEVILLE = 3;
const HUNTING_ZONE_HARBOR = 4;
const HUNTING_ZONE_Agit = 5;
const HUNTING_ZONE_COLOSSEUM = 6;
const HUNTING_ZONE_ETCERA = 7;
//안타라스 예외처리
const ANTARASMONID1 = 29066;
const ANTARASMONID2 = 29067;
const ANTARASMONID3 = 29068;
// 데이터 보여주기 33픽셀중심 오프셋
const REGIONINFO_OFFSETX = 3400;
const REGIONINFO_OFFSETY = 6400;
// Sets Global Value
var bool tabLoc; 
var string serverMaxRecord;
var int global_i;
var int g_modedID;
var bool bLock; 
var array<int> agitid1;
var array<int> agitid2;
var array<int> agitid3;

var string m_WindowName;

struct RAIDRECORD
{
	var int a;
	var int b;
	var int c;
};

var array<RAIDRECORD> RaidRecordList;
var array<string> currentmaprecord;
var array<int> g_CastleID;


var WindowHandle MinimapDrawerWnd;
var ListCtrlHandle m_hQuestListCtrl;
var ListCtrlHandle m_hHuntingZoneListCtrl;
var ListCtrlHandle m_hRaidListCtrl;
var ListCtrlHandle m_hAreaInfoListCtrl;
var ListCtrlHandle m_CastleListCtrl;
var ListCtrlHandle m_FortressListCtrl;
var ListCtrlHandle m_AgitListCtrl;
var ListCtrlHandle m_TerritoryListCtrl;

var TabHandle m_hTabCtrl;
var TabHandle m_hTabCtrl_Exp;
var ComboBoxHandle m_hQuestComboBox;
var WindowHandle m_QuestTab;
var WindowHandle m_HuntTab;
var WindowHandle m_RaidTab;
var WindowHandle m_AreaTab;
var WindowHandle m_SiegeCastleTab;
var WindowHandle m_SiegeFortressTab;
var WindowHandle m_AgitTab;
var WindowHandle m_TerritoryWarTab;
var MinimapCtrlHandle m_MiniMap;

var ButtonHandle ReduceButton;
var ButtonHandle ReduceButton_Expand;

var int m_DominionInfoCnt;

var MinimapWnd m_MiniMapWndScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_RaidRecord);
	RegisterEvent(EV_ShowGuideWnd);
	RegisterEvent(EV_ShowCastleInfo);
	RegisterEvent(EV_AddCastleInfo);
	RegisterEvent(EV_ShowFortressInfo);
	RegisterEvent(EV_AddFortressInfo);
	RegisterEvent(EV_ShowAgitInfo);
	RegisterEvent(EV_AddAgitInfo);
	RegisterEvent(EV_ShowFortressSiegeInfo);
	registerEvent( EV_DominionInfoCnt  );
	registerEvent( EV_DominionInfo );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hQuestListCtrl = ListCtrlHandle( GetHandle( "QuestListCtrl" ) );
		m_hHuntingZoneListCtrl = ListCtrlHandle( GetHandle( "HuntingZoneListCtrl" ) );
		m_hRaidListCtrl = ListCtrlHandle( GetHandle( "RaidListCtrl" ) );
		m_hAreaInfoListCtrl = ListCtrlHandle( GetHandle( "AreaInfoListCtrl" ) );
		m_hTabCtrl = TabHandle( GetHandle( "TabCtrl" ) );
		m_hTabCtrl_Exp = TabHandle( GetHandle( "TabCtrl_Exp" ) );
		m_hQuestComboBox = ComboBoxHandle( GetHandle( "QuestComboBox" ) );
		m_QuestTab = GetHandle( "QuestTab" );
		m_HuntTab = GetHandle( "HuntTab" );
		m_RaidTab = GetHandle( "RaidTab" );
		m_AreaTab = GetHandle( "AreaTab" );
		m_SiegeCastleTab = GetHandle( "SiegeCastleTab" );
		m_SiegeFortressTab = GetHandle( "SiegeFortressTab" );
		m_TerritoryWarTab = GetHandle ("TerritoryWarTab");
		m_AgitTab = GetHandle( "AgitTab" );
		m_MiniMap = MinimapCtrlHandle(GetHandle( "MinimapWnd.Minimap" ));
		m_CastleListCtrl = ListCtrlHandle( GetHandle( "CastleListCtrl" ) );
		m_FortressListCtrl = ListCtrlHandle( GetHandle( "FortressListCtrl" ) );
		m_AgitListCtrl = ListCtrlHandle( GetHandle( "AgitListCtrl" ) );
		m_TerritoryListCtrl = ListCtrlHandle( GetHandle( "TerritoryListCtrl"));
		
		MiniMapDrawerWnd = 			GetHandle( "MiniMapDrawerWnd" );
		
		ReduceButton = ButtonHandle( GetHandle("MinimapWnd.btnReduce"));
		ReduceButton_Expand = ButtonHandle( GetHandle("MinimapWnd_Expand.btnReduce"));
		
		m_MiniMapWndScript = MinimapWnd( GetScript("MinimapWnd" ) );
	}
	else
	{
		m_hQuestListCtrl = GetListCtrlHandle( m_WindowName$"."$"QuestTab.QuestListCtrl" );
		m_hHuntingZoneListCtrl = GetListCtrlHandle( m_WindowName$"."$"HuntTab.HuntingZoneListCtrl" );
		m_hRaidListCtrl = GetListCtrlHandle( m_WindowName$"."$"RaidTab.RaidListCtrl" );
		m_hAreaInfoListCtrl = GetListCtrlHandle( m_WindowName$"."$"AreaTab.AreaInfoListCtrl" );
		m_hTabCtrl = GetTabHandle( m_WindowName$"."$"TabCtrl" );
		m_hTabCtrl_Exp = GetTabHandle( m_WindowName$"."$"TabCtrl_Exp" );
		m_hQuestComboBox = GetComboBoxHandle( m_WindowName$"."$"QuestTab.QuestComboBox" );
		m_QuestTab 		= 			GetWindowHandle( m_WindowName$"."$"QuestTab" );
		m_HuntTab 		= 	GetWindowHandle( m_WindowName$"."$"HuntTab" );
		m_RaidTab 		= 	GetWindowHandle( m_WindowName$"."$"RaidTab" );
		m_AreaTab 		= 	GetWindowHandle( m_WindowName$"."$"AreaTab" );
		m_TerritoryWarTab 	= 	GetWindowHandle( m_WindowName$"."$"TerritoryWarTab");
		m_SiegeCastleTab 	= 	GetWindowHandle( m_WindowName$"."$"SiegeCastleTab" );
		m_SiegeFortressTab 	= 	GetWindowHandle( m_WindowName$"."$"SiegeFortressTab" );
		m_AgitTab = GetWindowHandle( m_WindowName$"."$"AgitTab" );
		m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );
		m_CastleListCtrl = GetListCtrlHandle( m_WindowName$"."$"SiegeCastleTab.CastleListCtrl" );
		m_FortressListCtrl = GetListCtrlHandle( m_WindowName$"."$"SiegeFortressTab.FortressListCtrl" );
		m_AgitListCtrl = GetListCtrlHandle( m_WindowName$"."$"AgitTab.AgitListCtrl" );
		m_TerritoryListCtrl = GetListCtrlHandle( m_WindowName$"."$"TerritoryListCtrl");
		
		MiniMapDrawerWnd = 			GetWindowHandle( "MiniMapDrawerWnd" );
		
		ReduceButton = GetButtonHandle( "MinimapWnd.btnReduce" );
		ReduceButton_Expand = GetButtonHandle( "MinimapWnd_Expand.btnReduce" );
		m_MiniMapWndScript = MinimapWnd( GetScript("MinimapWnd" ) );
	}

	SetCastleLocData();
}     

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		m_hTabCtrl.EnableWindow();
		m_hTabCtrl_Exp.EnableWindow();
	}
}

function DisableTabBtn()
{
	m_hOwnerWnd.SetTimer( TIMER_ID, TIMER_DELAY );
	m_hTabCtrl.DisableWindow();
	m_hTabCtrl_Exp.DisableWindow();
}

function OnShow()
{
	if (MiniMapDrawerWnd.IsShowWindow())
	{
		MiniMapDrawerWnd.HideWindow();
	}
	bLock = false;
	m_hHuntingZoneListCtrl.DeleteAllItem();
	m_hRaidListCtrl.DeleteAllItem();
	m_hAreaInfoListCtrl.DeleteAllItem();
	m_hTabCtrl.InitTabCtrl();
	m_hTabCtrl_Exp.InitTabCtrl();
	LoadQuestList();
	
	swaptab1();
	m_hQuestComboBox.SetSelectedNum( 0 );
	m_QuestTab.ShowWindow();
	m_HuntTab.HideWindow();
	m_RaidTab.HideWindow();
	m_AreaTab.HideWindow();
	m_SiegeCastleTab.HideWindow();
	m_SiegeFortressTab.HideWindow();
	m_TerritoryWarTab.HideWindow();
	m_AgitTab.HideWindow();
}

function OnHide()
{
	local MinimapWnd script;
	script = MinimapWnd( GetScript("MinimapWnd") );
	class'UIAPI_WINDOW'.static.KillUITimer("GuideWnd.RaidTab",Timer_ID); 
	m_MiniMap.EraseAllRegionInfo();
	bLock = false;
	if (script.m_Dominion == false)
	{
	}
	else 
	{
		script.DrawDominionTarget();
	}
}



function OnClickButton(string ID)
{
	local int QuestComboCurrentData;
	local int QuestComboCurrentReservedData;
	local int HuntingZoneComboboxCurrentData;
	local int HuntingZoneComboboxCurrentReservedData;
	local int RaidCurrentComboboxCurrentReservedData;
	local int AreaInfoComboBoxCurrentData;
	local int AreaInfoComboBoxCurrentReservedData;
	//~ m_MiniMap.EraseAllRegionInfo();
	if(ID == "TabCtrl0")
	{
		swaptab1();
		LoadQuestList();
		m_hQuestComboBox.SetSelectedNum( 0 );
		m_QuestTab.ShowWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_AgitTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		//~ m_TerritoryWarTab.HideWindow();
		DisableTabBtn();
		m_MiniMap.DeleteAllTarget(); 
	}else
	if(ID == "TabCtrl1")
	{
		swaptab1();
		LoadHuntingZoneList();
		class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.HuntingZoneComboBox",0);
		m_QuestTab.HideWindow();
		m_HuntTab.ShowWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_AgitTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		m_MiniMap.DeleteAllTarget(); 
		JustdisplayCurrentDataOnTheMap();
		DisableTabBtn();
	}else
	if(ID == "TabCtrl2")
	{
		swaptab1();
		
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.ShowWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_AgitTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		m_MiniMap.DeleteAllTarget(); 
		RequestRaidRecord();
		DisableTabBtn();
	}else
	if(ID == "TabCtrl3")
	{
		swaptab1();
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.ShowWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		m_AgitTab.HideWindow();
		LoadAreaInfoList();
		m_MiniMap.DeleteAllTarget(); 
		class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.AreaInfoComboBox",0);
		JustdisplayCurrentDataOnTheMap();
		DisableTabBtn();
	}
	if(ID == "TabCtrl_Exp0")
	{
		swaptab2();
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_TerritoryWarTab.ShowWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_AgitTab.HideWindow();
		m_MiniMap.DeleteAllTarget(); 
		m_CastleListCtrl.DeleteAllItem();
		m_TerritoryListCtrl.DeleteAllItem();
		//~ CastleInfo();
		//~ debug("RequestingDominionInfo");
		RequestDominionInfo();
		DisableTabBtn();
	}
	else
	if(ID == "TabCtrl_Exp1")
	{
		swaptab2();
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.ShowWindow();
		m_SiegeFortressTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		m_AgitTab.HideWindow();
		m_MiniMap.DeleteAllTarget(); 
		m_CastleListCtrl.DeleteAllItem();
		m_TerritoryListCtrl.DeleteAllItem();
		CastleInfo();
		DisableTabBtn();
	}
	else
	if(ID == "TabCtrl_Exp2")
	{
		swaptab2();
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.ShowWindow();
		m_TerritoryWarTab.HideWindow();
		m_AgitTab.HideWindow();
		bLock = true;
		m_FortressListCtrl.DeleteAllItem();
		m_TerritoryListCtrl.DeleteAllItem();
		FortressInfo();
		m_MiniMap.DeleteAllTarget(); 
		DisableTabBtn();
	}else
	if(ID == "TabCtrl_Exp3")
	{
		swaptab2();
		m_QuestTab.HideWindow();
		m_HuntTab.HideWindow();
		m_RaidTab.HideWindow();
		m_AreaTab.HideWindow();
		m_SiegeCastleTab.HideWindow();
		m_SiegeFortressTab.HideWindow();
		m_TerritoryWarTab.HideWindow();
		m_AgitTab.ShowWindow();
		bLock = true;
		m_AgitListCtrl.DeleteAllItem();
		m_TerritoryListCtrl.DeleteAllItem();
		AgitInfo();
		m_MiniMap.DeleteAllTarget(); 
		DisableTabBtn();
	}

	if (ID == "btn_search1")
	{
		QuestComboCurrentData = m_hQuestComboBox.GetSelectedNum();
		QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved( QuestComboCurrentData );
		LoadQuestSearchResult(QuestComboCurrentReservedData);
	}
	if (ID == "btn_search2")
	{
		HuntingZoneComboboxCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.HuntingZoneComboBox");
		HuntingZoneComboboxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox",HuntingZoneComboboxCurrentData);
		LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
	}
	if (ID == "btn_search3")
	{
		LoadRaidSearchResult(RaidCurrentComboboxCurrentReservedData);
	}
	if (ID == "btn_search4")
	{
		AreaInfoComboBoxCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.AreaInfoComboBox");
		AreaInfoComboBoxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.AreaInfoComboBox",AreaInfoComboBoxCurrentData);
		LoadAreaInfoListSearchResult(AreaInfoComboBoxCurrentReservedData);
	}
	if (ID == "QuestComboBox")
	{
		QuestComboCurrentData = m_hQuestComboBox.GetSelectedNum();
		QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved( QuestComboCurrentData );
		LoadQuestSearchResult(QuestComboCurrentReservedData);
	}
	if (ID == "HuntingZoneComboBox")
	{
		HuntingZoneComboboxCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.HuntingZoneComboBox");
		HuntingZoneComboboxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox",HuntingZoneComboboxCurrentData);
		LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
	}
	if (ID == "CloseButton")
	{
		class'UIAPI_WINDOW'.static.HideWindow( "MinimapWnd.GuideWnd" );
	}
}

function swaptab1()
{
	//1단탭을 아래로
	m_hTabCtrl.ClearAnchor();
	m_hTabCtrl_Exp.ClearAnchor();
	m_hTabCtrl.MoveTo(12,23);
	m_hTabCtrl_Exp.MoveTo(12,6);
	m_hTabCtrl.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 23);
	m_hTabCtrl_Exp.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 6 );
}

function swaptab2()
{
	//2단탭을 아래로
	m_hTabCtrl.ClearAnchor();
	m_hTabCtrl_Exp.ClearAnchor();
	m_hTabCtrl.MoveTo(12,6);
	m_hTabCtrl_Exp.MoveTo(12,23);
	m_hTabCtrl.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 6 );
	m_hTabCtrl_Exp.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 23 );
}
       
function swapReset()
{
	//~ ClearAnchor();
	//~ ClearAnchor();
	m_hTabCtrl.MoveTo(12,6);
	m_hTabCtrl_Exp.MoveTo(12,23);
}

function OnComboBoxItemSelected( string sName, int index )
{
	local int QuestComboCurrentReservedData;
	local int HuntingZoneComboboxCurrentReservedData;
	local int AreaInfoComboBoxCurrentReservedData;
	
	if( sName == "QuestComboBox")
	{
		QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved( index );
		LoadQuestSearchResult(QuestComboCurrentReservedData);
	}
	if (sName == "HuntingZoneComboBox")
	{
		HuntingZoneComboboxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox",index);
		LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
	}
	if (sName == "AreaInfoComboBox")
	{
		AreaInfoComboBoxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.AreaInfoComboBox",index);
		LoadAreaInfoListSearchResult(AreaInfoComboBoxCurrentReservedData);
	}
}

function OnClickListCtrlRecord(string ID)
{

	local LVDataRecord Record;
	local Vector loc;
	local int SelectedIndex;
	

	// On Click Quest List Control.
	if (ID == "QuestListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_hQuestListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_hQuestListCtrl.GetSelectedIndex();
		loc = class'UIDATA_QUEST'.static.GetStartNPCLoc(Record.LVDataList[0].nReserved1,1);		
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc); 
		//~ displayCurrentDataOnTheMap(loc);
		// 2006/12/07 Commended out by NeverDie
		//SetDetailView(Record.LVDataList[0].nReserved1);
	}
	// On Click Hunting Zone List Control.
	if (ID == "HuntingZoneListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_hHuntingZoneListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_hHuntingZoneListCtrl.GetSelectedIndex();
		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		displayCurrentDataOnTheMap(loc,0);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc); 
		
	}
	// On Click Raid Data List Control.
	if (ID == "RaidListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_hRaidListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_hRaidListCtrl.GetSelectedIndex();
		loc = class'UIDATA_RAID'.static.GetRaidLoc(Record.LVDataList[0].nReserved1);
		m_MiniMapWndScript.SetLocContinent(loc);
		//~ debug("보여줄 위치"@ loc.x @ loc.y @ loc.z);
		//~ class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget();
		LoadRaidList3();
		if (loc.x != 0.f && loc.y != 0.f && loc.z != 0.f)
		{
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
			displayCurrentDataOnTheMap(loc,0);
			class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc);
		// 2006/12/07 Commended out by NeverDie
		//SetRaidDetailView(Record.LVDataList[0].nReserved1);
		}
		else
		{
		//데이터가 없을때 아예 다른 곳에 찍도록 하는 코드이나 좀 산마이로 처리되었음--;;
			loc.x = -30000000;
			loc.y = -30000000;
			loc.z  = 0;
			//~ debug("임시처리ㅋ");
			displayCurrentDataOnTheMap(loc,0);
		}
	}
	// On Click Area Information List Control
	if (ID == "AreaInfoListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		//debug("Iaminuse");
		m_hAreaInfoListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_hAreaInfoListCtrl.GetSelectedIndex();
		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
		//debug("Iaminuse2: " $ loc);
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		displayCurrentDataOnTheMap(loc,0);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc);
		
	}
	// On Click Hunting Zone List Control.
	if (ID == "CastleListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_CastleListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_CastleListCtrl.GetSelectedIndex();
		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		displayCurrentDataOnTheMap(loc,0);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc);
	}
	// On Click Hunting Zone List Control.
	if (ID == "FortressListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_FortressListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_FortressListCtrl.GetSelectedIndex();
		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		displayCurrentDataOnTheMap(loc,1);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc);
	}
	// On Click Hunting Zone List Control.
	if (ID == "AgitListCtrl")
	{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_AgitListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_AgitListCtrl.GetSelectedIndex();
		loc.x = agitid1[Record.LVDataList[0].nReserved1];
		loc.y = agitid2[Record.LVDataList[0].nReserved1];
		loc.z = agitid3[Record.LVDataList[0].nReserved1];
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc); 
	}
	
	if (ID == "TerritoryListCtrl")
		{
		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		m_TerritoryListCtrl.GetSelectedRec(Record);
		SelectedIndex = m_TerritoryListCtrl.GetSelectedIndex();
		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
		m_MiniMapWndScript.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		displayCurrentDataOnTheMap(loc,1);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc);
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_ShowGuideWnd:
		m_hOwnerWnd.ShowWindow();
		break;
	case EV_RaidRecord:
		LoadRaidList( a_Param );
		// 2006/12/07 Commended out by NeverDie
		//class'UIAPI_MINIMAPCTRL'.static.InitPosition("GuideWnd.MinimapCtrl");
		JustdisplayCurrentDataOnTheMap();
		break;
	case EV_ShowCastleInfo:
		m_CastleListCtrl.DeleteAllItem();
		ResetArray();
		break;
	case EV_AddCastleInfo:
		LoadCastleInfo( a_Param);
		break;
	case EV_ShowFortressInfo:
		//~ debug("요새전 정보를 보여준대요.");
		m_FortressListCtrl.DeleteAllItem();
		ResetArray();
		break;
	case EV_AddFortressInfo:
		//~ debug("공성정보:"@ a_Param);
		LoadFortressInfo(a_Param);
		break;
	case EV_ShowAgitInfo:
		//~ debug("지트 정보를 보여준대요");
		m_AgitListCtrl.DeleteAllItem();
		ResetArray();
		global_i = 0;
		break;
	case EV_AddAgitInfo:
		//~ debug ("실행?");
		LoadAgitInfo( a_Param);
		break;
	case EV_ShowFortressSiegeInfo:
		//~ debug("Event Received");
		LoadFortressSeigeInfo(a_Param);
		//~ debug("요새전 현황 정보 보여주기");
		break;
	case EV_DominionInfoCnt:
		HandleDominionInfoCnt(a_Param);
		break;
	case EV_DominionInfo:
		HandleDominionInfo(a_Param);
		break;
	default:
		break;
	}
}

// Load Hunting Zone Data
function LoadHuntingZoneList()
{
	//사냥터 리스트 컨트롤에 사냥터 이름	추천레벨	사냥터유형 설명	소속 영지	위치좌표 가 필요하다
	local string HuntingZoneName; 
	local int MinLevel;   
	local int MaxLevel;  
	local string LevelLimit;	
	local int FieldType; 
	local string FieldType_Name;
	local int Zone; 
	//local string Description;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local int i;
	local Vector loc;
	local String DataforMap;
	
	ResetArray();
	
	m_hHuntingZoneListCtrl.DeleteAllItem();
	comboxFiller("HuntingZoneComboBox");
	class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.HuntingZoneComboBox",0);
	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{		
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			FieldType = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
			if( FieldType == 1 || FieldType == 2 )
			{
				
				//사냥터 데이터 얻어오기
				HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				MinLevel = class'UIDATA_HUNTINGZONE'.static.GetMinLevel(i); 
				MaxLevel = class'UIDATA_HUNTINGZONE'.static.GetMaxLevel(i); 
				Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
				//Description = class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i); 
					
				//데이터 가공
				if(MinLevel > 0 && MaxLevel > 0)
				{
			 		LevelLimit = MinLevel $ "~" $ MaxLevel;	
				}else if(minlevel > 0)
				{
					LevelLimit = MinLevel $ " " $ GetSystemString(859);
				}else
				{
					LevelLimit = GetSystemString(866);
				}	
				FieldType_Name = conv_zoneType(FieldType);
				
				//얻어온 데이터를 레코드로 만들기
				data1.nReserved1 = i;
				data1.szData = HuntingZoneName;
				Record.LVDataList[0] = data1;
				data2.szData = FieldType_Name;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(Zone);
				Record.LVDataList[2] = data3;
				data4.szData = LevelLimit;
				Record.LVDataList[3] = data4;
				//툴팁 정보 레코드에 넣기
				//Record.nReserved1 = Zone;
				//Record.szReserved = Description;
				//레코드를 리스트 컨트롤에 인서트 하기
				//debug(HuntingZoneName);
				m_hHuntingZoneListCtrl.InsertRecord( Record );
				
				loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(i);
				DataforMap = "";
				ParamAdd(DataforMap, "Index", string(i));
				ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
				ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
				ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
				ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
				ParamAdd(DataforMap, "Description", "" );
				ParamAdd(DataforMap, "DescOffsetX", "0");
				ParamAdd(DataforMap, "DescOffsetY", "0");
				ParamAdd(DataforMap, "Tooltip", HuntingZoneName);
				currentmaprecord[i] = DataforMap ;
			
			}
		}	
	}
	
}

// Load HuntingZone List
function LoadHuntingZoneListSearchResult(int SearchZone)
{
//사냥터 리스트 컨트롤에 사냥터 이름	추천레벨	사냥터유형 설명	소속 영지	위치좌표 가 필요하다
	local string HuntingZoneName; 
	local int MinLevel;   
	local int MaxLevel;  
	local string LevelLimit;	
	local int FieldType; 
	local string FieldType_Name;
	local int Zone; 
	local string Description; 
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local int i;

	
	
	if (SearchZone == 19989)
	{
		LoadHuntingZoneList();
	}
	else
	{	
		m_hHuntingZoneListCtrl.DeleteAllItem();
		for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
		{
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
			{
				if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == SearchZone)
				{
					FieldType = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
					if( FieldType == 1 || FieldType == 2 )
					{
						//사냥터 데이터 얻어오기
						HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
						MinLevel = class'UIDATA_HUNTINGZONE'.static.GetMinLevel(i); 
						MaxLevel = class'UIDATA_HUNTINGZONE'.static.GetMaxLevel(i); 
						Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
						Description = class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i); 
						//데이터 가공
						if(MinLevel > 0 && MaxLevel > 0)
						{
							LevelLimit = MinLevel $ "~" $ MaxLevel;	
						}else if(minlevel > 0)
						{
							LevelLimit = MinLevel $ " " $ GetSystemString(859);
						}else
						{
							LevelLimit = GetSystemString(866);
						}	
						FieldType_Name = conv_zoneType(FieldType);
						//얻어온 데이터를 레코드로 만들기
						data1.nReserved1 = i;
						data1.szData = HuntingZoneName;
						Record.LVDataList[0] = data1;
						data2.szData = FieldType_Name;
						Record.LVDataList[1] = data2;
						data3.szData = conv_zoneName(Zone);
						Record.LVDataList[2] = data3;
						data4.szData = LevelLimit;
						Record.LVDataList[3] = data4;
								
						//레코드를 리스트 컨트롤에 인서트 하기
						//debug(HuntingZoneName);
						m_hHuntingZoneListCtrl.InsertRecord( Record );
					}
				}
			}	
		}
	}
}

// Load Server Raid Data 
function LoadRaidRanking()
{
	
}
// Load Raid Data
function LoadRaidList( String a_Param )
{
	local int i;
	local int j;
	local int RaidMonsterID;
	local int RaidMonsterLevel;
	local int RaidMonsterZone;
	local string RaidPointStr;
	local string RaidMonsterPrefferedLevel;
	local string RaidMonsterName;
	local string RaidDescription;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;	
	local LVData data4;

	local int RaidRanking;
	local int RaidSeasonPoint;
	local int RaidNum;
//	local int RaidCount;
	local int ClearRaidMonsterID;
	local int ClearSeasonPoint;
	local int ClearTotalPoint;
	// 안타라스 예외처리 
	local int AntarasPoint;
	local string SeasonTotalString;
	
	local string DataforMap;
	local Vector loc;
	
	ResetArray();
	
	m_hRaidListCtrl.DeleteAllItem();
	//안타라스 예외처리
	AntarasPoint = 0;
	//comboxFiller("RaidInfoComboBox");
	//class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.RaidInfoComboBox",0);

	ParseInt( a_Param, "RaidRank", RaidRanking );
	ParseInt( a_Param, "SeasonPoint", RaidSeasonPoint );

	// Userbility Coding and Set Raid Point.
	if (RaidRanking == 0)
	{
		class'UIAPI_TEXTBOX'.static.SetText("GuideWnd.Ranking",GetSystemString(1454));
	}
	else 
	{
		class'UIAPI_TEXTBOX'.static.SetInt("GuideWnd.Ranking",RaidRanking);
	}
	SeasonTotalString = "" $ RaidSeasonPoint @ GetSystemString(1442);
	//raid 점수 세팅
	//class'UIAPI_TEXTBOX'.static.SetInt("GuideWnd.Ranking",RaidRanking);
	class'UIAPI_TEXTBOX'.static.SetText("GuideWnd.SeasonTotalPoint",SeasonTotalString);

	/*RaidNum = 3;
//	RaidCount = 0;
	
	RaidRecordList.Remove(0,RaidRecordList.Length);

	RaidRecordList.Insert(0,RaidNum);
	for(i=0;i<RaidNum;i++)
	{
		ClearRaidMonsterID = 10019;
		ClearSeasonPoint = 444;
		ClearTotalPoint = 333;
		RaidRecordList[i].a = ClearRaidMonsterID;
		RaidRecordList[i].b = ClearSeasonPoint;
		RaidRecordList[i].c = ClearTotalPoint;
		log("RaidRecord : " $ RaidRecordList[i].a $ "  " $ RaidRecordList[i].b $ "  " $ RaidRecordList[i].c);
	}*/
	
	ParseInt( a_Param, "Count", RaidNum );
//	RaidCount = 0;
	
	RaidRecordList.Remove(0,RaidRecordList.Length);
	RaidRecordList.Insert(0,RaidNum);
	for(i=0;i<RaidNum;i++)
	{
		ParseInt( a_Param, "MonsterID" $ i, ClearRaidMonsterID );
		ParseInt( a_Param, "CurrentPoint" $ i, ClearSeasonPoint );
		ParseInt( a_Param, "TotalPoint" $ i, ClearTotalPoint );
		RaidRecordList[i].a = ClearRaidMonsterID;
		RaidRecordList[i].b = ClearSeasonPoint;
		RaidRecordList[i].c = ClearTotalPoint;
		//log("RaidRecord : " $ RaidRecordList[i].a $ "  " $ RaidRecordList[i].b $ "  " $ RaidRecordList[i].c);
	}
	
	for(i = 0; i < MAX_RAID_NUM ; i++)
	{
		if(class'UIDATA_RAID'.static.IsValidData(i))
		{
			//Retrieving Raid data record.
			RaidMonsterID = class'UIDATA_RAID'.static.GetRaidMonsterID(i);
			RaidMonsterLevel = class'UIDATA_RAID'.static.GetRaidMonsterLevel(i);
			RaidMonsterZone = class'UIDATA_RAID'.static.GetRaidMonsterZone(i);
			RaidDescription = class'UIDATA_RAID'.static.GetRaidDescription(i);
			RaidMonsterName = class'UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
			//Process 
			
			//안타라스 특별예외처리
			if (RaidMonsterID == ANTARASMONID1)
			{
				if(RaidMonsterLevel > 0)
				{
					RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
				}else
				{
					RaidMonsterPrefferedLevel = GetSystemString(1415);				
				}	
				data1.nReserved1 = i;
				data1.szData = RaidMonsterName;
				Record.LVDataList[0] = data1;
				data2.szData = RaidMonsterPrefferedLevel;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(RaidMonsterZone);
				Record.LVDataList[2] = data3;
				//레이드 획득점수 
				RaidPointStr = "0";
				for(j=0;j<RaidNum;j++)
				{
					if(RaidRecordList[j].a == RaidMonsterID)
					{
						RaidPointStr = RaidRecordList[j].b$"";
						//log("RaidID : " $ RaidMonsterID $ "RaidPoint : " $ RaidPointStr );
					}
				}
				AntarasPoint = int(RaidPointStr) + AntarasPoint;
				data4.szData = string(AntarasPoint);
				Record.LVDataList[3] = data4;
				
				Record.szReserved = RaidDescription;
				//Record.nReserved1 = RaidMonsterZone;
				// insertion to the list control.
				//m_hRaidListCtrl.InsertRecord( Record );
			}
			
			else if (RaidMonsterID == ANTARASMONID2)
			{

								
				if(RaidMonsterLevel > 0)
				{
					RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
				}else
				{
					RaidMonsterPrefferedLevel = GetSystemString(1415);				
				}	
				data1.nReserved1 = i;
				data1.szData = RaidMonsterName;
				Record.LVDataList[0] = data1;
				data2.szData = RaidMonsterPrefferedLevel;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(RaidMonsterZone);
				Record.LVDataList[2] = data3;
				//레이드 획득점수 
				RaidPointStr = "0";
				for(j=0;j<RaidNum;j++)
				{
					if(RaidRecordList[j].a == RaidMonsterID)
					{
						RaidPointStr = RaidRecordList[j].b$"";
						//log("RaidID : " $ RaidMonsterID $ "RaidPoint : " $ RaidPointStr );
					}
				}
				AntarasPoint = int(RaidPointStr) + AntarasPoint;
				data4.szData =string(AntarasPoint);
				Record.LVDataList[3] = data4;
				
				Record.szReserved = RaidDescription;
				//Record.nReserved1 = RaidMonsterZone;
				// insertion to the list control.
				//m_hRaidListCtrl.InsertRecord( Record );

				
			}
			
			else if (RaidMonsterID == ANTARASMONID3)
			{

				
				if(RaidMonsterLevel > 0)
				{
					RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
				}else
				{
					RaidMonsterPrefferedLevel = GetSystemString(1415);				
				}	
				data1.nReserved1 = i;
				data1.szData = RaidMonsterName;
				Record.LVDataList[0] = data1;
				data2.szData = RaidMonsterPrefferedLevel;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(RaidMonsterZone);
				Record.LVDataList[2] = data3;
				//레이드 획득점수 
				RaidPointStr = "0";
				for(j=0;j<RaidNum;j++)
				{
					if(RaidRecordList[j].a == RaidMonsterID)
					{
						RaidPointStr = RaidRecordList[j].b$"";
						//log("RaidID : " $ RaidMonsterID $ "RaidPoint : " $ RaidPointStr );
					}
				}
				AntarasPoint = int(RaidPointStr) + AntarasPoint;
				data4.szData = String(AntarasPoint);
				Record.LVDataList[3] = data4;
				
				Record.szReserved = RaidDescription;
				//Record.nReserved1 = RaidMonsterZone;
				// insertion to the list control.
				m_hRaidListCtrl.InsertRecord( Record );

				
			}
			
			else
			{
				
				if(RaidMonsterLevel > 0)
				{
					RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
				}else
				{
					RaidMonsterPrefferedLevel = GetSystemString(1415);				
				}	
				data1.nReserved1 = i;
				data1.szData = RaidMonsterName;
				Record.LVDataList[0] = data1;
				data2.szData = RaidMonsterPrefferedLevel;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(RaidMonsterZone);
				Record.LVDataList[2] = data3;
				//레이드 획득점수 
				RaidPointStr = "0";
				for(j=0;j<RaidNum;j++)
				{
					if(RaidRecordList[j].a == RaidMonsterID)
					{
						RaidPointStr = RaidRecordList[j].b$"";
						//log("RaidID : " $ RaidMonsterID $ "RaidPoint : " $ RaidPointStr );
					}
				}
				data4.szData = RaidPointStr;
				Record.LVDataList[3] = data4;
				
				Record.szReserved = RaidDescription;
				//Record.nReserved1 = RaidMonsterZone;
				// insertion to the list control.
				m_hRaidListCtrl.InsertRecord( Record );
			}
			loc = class'UIDATA_RAID'.static.GetRaidLoc(i);
			DataforMap = "";
			ParamAdd(DataforMap, "Index", string(i));
			ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
			ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "Description", "");
			ParamAdd(DataforMap, "DescOffsetX", "0");
			ParamAdd(DataforMap, "DescOffsetY", "0");
			ParamAdd(DataforMap, "Tooltip", RaidMonsterName);
			currentmaprecord[i] = DataforMap ;
		}	
	}

}
function LoadRaidList3()
{
	local int i;
	local int RaidMonsterID;
	//~ local int RaidMonsterLevel;
	//~ local int RaidMonsterZone;
	//~ local string RaidPointStr;
	//~ local string RaidMonsterPrefferedLevel;
	local string RaidMonsterName;
	//~ local string RaidDescription;
	//~ local LVDataRecord Record;
	//~ local LVData data1;
	//~ local LVData data2;
	//~ local LVData data3;	
	//~ local LVData data4;
	local string DataforMap;
	local Vector loc;
	
	//local int RaidRanking;
	//local int RaidSeasonPoint;
	//~ local int RaidNum;
	//~ local int RaidCount;
	//local int ClearRaidMonsterID;
	//local int ClearSeasonPoint;
	//local int ClearTotalPoint;
	
	//~ m_hRaidListCtrl.DeleteAllItem();
	
	//comboxFiller("RaidInfoComboBox");
	//class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.RaidInfoComboBox",0);

	//~ ResetArray();
	
	for(i = 0; i < MAX_RAID_NUM ; i++)
	{
		if(class'UIDATA_RAID'.static.IsValidData(i))
		{
			//Retrieving Raid data record.
			RaidMonsterID = class'UIDATA_RAID'.static.GetRaidMonsterID(i);
			//~ RaidMonsterLevel = class'UIDATA_RAID'.static.GetRaidMonsterLevel(i);
			//~ RaidMonsterZone = class'UIDATA_RAID'.static.GetRaidMonsterZone(i);
			//~ RaidDescription = class'UIDATA_RAID'.static.GetRaidDescription(i);
			RaidMonsterName = class'UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
			//~ //Process 
			//~ if(RaidMonsterLevel > 0)
			//~ {
				//~ RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
			//~ }else
			//~ {
				//~ RaidMonsterPrefferedLevel = GetSystemString(1415);				
			//~ }	
			//~ data1.nReserved1 = i;
			//~ data1.szData = RaidMonsterName;
			//~ Record.LVDataList[0] = data1;
			//~ data2.szData = RaidMonsterPrefferedLevel;
			//~ Record.LVDataList[1] = data2;
			//~ data3.szData = conv_zoneName(RaidMonsterZone);
			//~ Record.LVDataList[2] = data3;
			//~ //레이드 획득점수 
			//~ RaidPointStr = "0";
			//~ if(RaidCount < RaidNum)
			//~ {
				//~ if(RaidRecordList[RaidCount].a == RaidMonsterID)
				//~ {
					//~ RaidPointStr = RaidRecordList[RaidCount++].b$"";
				//~ }
			//~ }
			//~ data4.szData = RaidPointStr;
			//~ Record.LVDataList[3] = data4;
			
			//~ Record.szReserved = RaidDescription;
			//~ //Record.nReserved1 = RaidMonsterZone;
			//~ // insertion to the list control.
			//~ m_hRaidListCtrl.InsertRecord( Record );
			
			loc = class'UIDATA_RAID'.static.GetRaidLoc(i);
			DataforMap = "";

			ParamAdd(DataforMap, "Index", string(i));
			ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
			ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "Description", "");
			ParamAdd(DataforMap, "DescOffsetX", "0");
			ParamAdd(DataforMap, "DescOffsetY", "0");
			ParamAdd(DataforMap, "Tooltip", RaidMonsterName);
			currentmaprecord[i] = DataforMap ;
			
		}	
	}
	
}

function LoadRaidList2()
{
	local int i;
	local int RaidMonsterID;
	local int RaidMonsterLevel;
	local int RaidMonsterZone;
	local string RaidPointStr;
	local string RaidMonsterPrefferedLevel;
	local string RaidMonsterName;
	local string RaidDescription;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;	
	local LVData data4;
	local string DataforMap;
	local Vector loc;
	
	//local int RaidRanking;
	//local int RaidSeasonPoint;
	local int RaidNum;
	local int RaidCount;
	//local int ClearRaidMonsterID;
	//local int ClearSeasonPoint;
	//local int ClearTotalPoint;
	
	m_hRaidListCtrl.DeleteAllItem();
	
	//comboxFiller("RaidInfoComboBox");
	//class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.RaidInfoComboBox",0);

	ResetArray();
	
	for(i = 0; i < MAX_RAID_NUM ; i++)
	{
		if(class'UIDATA_RAID'.static.IsValidData(i))
		{
			//~ //Retrieving Raid data record.
			RaidMonsterID = class'UIDATA_RAID'.static.GetRaidMonsterID(i);
			RaidMonsterLevel = class'UIDATA_RAID'.static.GetRaidMonsterLevel(i);
			RaidMonsterZone = class'UIDATA_RAID'.static.GetRaidMonsterZone(i);
			RaidDescription = class'UIDATA_RAID'.static.GetRaidDescription(i);
			RaidMonsterName = class'UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
			//Process 
			if(RaidMonsterLevel > 0)
			{
				RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
			}else
			{
				RaidMonsterPrefferedLevel = GetSystemString(1415);				
			}	
			data1.nReserved1 = i;
			data1.szData = RaidMonsterName;
			Record.LVDataList[0] = data1;
			data2.szData = RaidMonsterPrefferedLevel;
			Record.LVDataList[1] = data2;
			data3.szData = conv_zoneName(RaidMonsterZone);
			Record.LVDataList[2] = data3;
			//레이드 획득점수 
			RaidPointStr = "0";
			if(RaidCount < RaidNum)
			{
				if(RaidRecordList[RaidCount].a == RaidMonsterID)
				{
					RaidPointStr = RaidRecordList[RaidCount++].b$"";
				}
			}
			data4.szData = RaidPointStr;
			Record.LVDataList[3] = data4;
			
			Record.szReserved = RaidDescription;
			//Record.nReserved1 = RaidMonsterZone;
			// insertion to the list control.
			m_hRaidListCtrl.InsertRecord( Record );
			
			loc = class'UIDATA_RAID'.static.GetRaidLoc(i);
			DataforMap = "";

			ParamAdd(DataforMap, "Index", string(i));
			ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
			ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
			ParamAdd(DataforMap, "Description", "");
			ParamAdd(DataforMap, "DescOffsetX", "0");
			ParamAdd(DataforMap, "DescOffsetY", "0");
			ParamAdd(DataforMap, "Tooltip", RaidMonsterName);
			currentmaprecord[i] = DataforMap ;
			
		}	
	}
	
}
// Load Raid Search Result
function LoadRaidSearchResult(int SearchZone)
{
	local int i;
	local int RaidMonsterID;
	local int RaidMonsterLevel;
	local int RaidMonsterZone;
	local string RaidPointStr;
	local string RaidMonsterPrefferedLevel;
	local string RaidMonsterName;
	local string RaidDescription;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;	
	local LVData data4;
	local int RaidNum;
	local int RaidCount;
	
if (SearchZone == 19989)
{
	LoadRaidList2();
}
else
{

	m_hRaidListCtrl.DeleteAllItem();
	
	RaidNum = RaidRecordList.Length;
	RaidCount = 0;
	for(i = 0; i < MAX_RAID_NUM ; i++)
	{
		if(class'UIDATA_RAID'.static.IsValidData(i))
		{
			RaidMonsterZone = class'UIDATA_RAID'.static.GetRaidMonsterZone(i);

			if( SearchZone == RaidMonsterZone)
			{
				//Retrieving Raid data record.
				RaidMonsterID = class'UIDATA_RAID'.static.GetRaidMonsterID(i);
				RaidMonsterLevel = class'UIDATA_RAID'.static.GetRaidMonsterLevel(i);
				RaidDescription = class'UIDATA_RAID'.static.GetRaidDescription(i);
				RaidMonsterName = class'UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
				//Process 
				if(RaidMonsterLevel > 0)
				{
					RaidMonsterPrefferedLevel = GetSystemString(537) $ " " $ RaidMonsterLevel;
				}else
				{
					RaidMonsterPrefferedLevel = "-";				
				}

				data1.nReserved1 = i;
				data1.szData = RaidMonsterName;
				Record.LVDataList[0] = data1;
				data2.szData = RaidMonsterPrefferedLevel;
				Record.LVDataList[1] = data2;
				data3.szData = conv_zoneName(RaidMonsterZone);
				Record.LVDataList[2] = data3;
				//레이드 획득점수 
				RaidPointStr = "0";
				if(RaidCount < RaidNum)
				{
					if(RaidRecordList[RaidCount].a == RaidMonsterID)
					{
						RaidPointStr = RaidRecordList[RaidCount++].b$"";
					}
				}
				data4.szData = RaidPointStr;
				Record.LVDataList[3] = data4;
				
				Record.szReserved = RaidDescription;
				Record.nReserved1 = IntToInt64(RaidMonsterZone);
				// insertion to the list control.
				m_hRaidListCtrl.InsertRecord( Record );
			}
		}	
	}
}
}

// Quest Data
function LoadQuestList()
{
	//퀘스트 리스트 컨트롤에 퀘스트 이름, 수행조건, 추천레벨, 반복성, 소속영지, 의뢰인, 설명이 필요하다
	local string QuestName;
	//local string Condition;
	local int MinLevel;
	local int MaxLevel;
	local int Type;
	//local int Zone;
	local int NPC;
	//local int CountDigit;
	//local string Description;
	local string LevelLimit;
	local string NPCname;
	local int ID;
	local int i;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local String TypeText[5];
	//~ local string DataforMap;
	local Vector loc;
	
	ResetArray();
	

	m_hQuestListCtrl.DeleteAllItem();
	
	comboxFiller("QuestComboBox");
	m_hQuestComboBox.SetSelectedNum( 0 );

	TypeText[0] = GetSystemString(861);
	TypeText[1] = GetSystemString(862);
	TypeText[2] = GetSystemString(861);
	TypeText[3] = GetSystemString(862);
	TypeText[4] = GetSystemString(861);
	
	i = 1;
	
	for( ID = class'UIDATA_QUEST'.static.GetFirstID(); -1 != ID; iD = class'UIDATA_QUEST'.static.GetNextID() )
	{
		//Retrieving quest data record.
		QuestName = class'UIDATA_QUEST'.static.GetQuestName(ID);
		MinLevel = class'UIDATA_QUEST'.static.GetMinLevel(ID,1);
		MaxLevel = class'UIDATA_QUEST'.static.GetMaxLevel(ID,1);
		Type = class'UIDATA_QUEST'.static.GetQuestType(ID,1);
		
		// 2006/12/07 Commended out by NeverDie
		//Condition = class'UIDATA_QUEST'.static.GetRequirement(ID,1);
		//Zone = class'UIDATA_QUEST'.static.GetQuestZone(ID,1);
		//Description = class'UIDATA_QUEST'.static.GetIntro(ID,1);
		//CountDigit = Len(Condition);

		NPC = class'UIDATA_QUEST'.static.GetStartNPCID(ID,1);
		NPCname = class'UIDATA_NPC'.static.GetNPCName(NPC);
		if(MinLevel > 0 && MaxLevel > 0)
		{
		 	LevelLimit = MinLevel $ "~" $ MaxLevel;	
		}else if(minlevel > 0)
		{
			LevelLimit = MinLevel $ " " $ GetSystemString(859);
		}else
		{
			LevelLimit = GetSystemString(866);
		}		
		if (NPCname == "" || NPCname == "None")
			NPCname = GetSystemString(27);
		//Process 
		//debug("value: " $ CountDigit);
		data1.nReserved1 = ID;
		data1.szData = QuestName;
		Record.LVDataList[0] = data1;
		//data2.szData = Condition;

		if( 0 <= Type && Type <= 4 )
			data2.szData = TypeText[Type];
		Record.LVDataList[1] = data2;
		data3.szData = NPCname;
		Record.LVDataList[2] = data3;
		data4.szData = LevelLimit;
		Record.LVDataList[3] = data4;
		//Record.szReserved = Description;
		//Record.nReserved1 = Type;
		//Record.nReserved2 = Zone;
		//Record.nReserved3 = NPC;
		//insertion to the list control.
		m_hQuestListCtrl.InsertRecord( Record );
		
		loc = class'UIDATA_QUEST'.static.GetStartNPCLoc(ID,1);
			
		//~ DataforMap = "";
		
		//~ ParamAdd(DataforMap, "Index", string(i));
		
		//~ ParamAdd(DataforMap, "WorldX", string(loc.x -  1998));
		//~ ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	
		//~ ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		//~ ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		//~ ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		//~ ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
		//~ ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
		
		//~ ParamAdd(DataforMap, "Description", "");
		//~ ParamAdd(DataforMap, "DescOffsetX", "0");
		//~ ParamAdd(DataforMap, "DescOffsetY", "0");
	
		//~ ParamAdd(DataforMap, "Tooltip", QuestName $" \\n" $ NPCname);
		
		//~ currentmaprecord[i] = DataforMap ;
		//~ debug(DataforMap);
		
		i = i + 1;
		
	}
	
}
 
function displayCurrentDataOnTheMap(Vector currentloc, int txtureint)
{
	local int i;
	local int comparedVecX;
	local int comparedVecY;
	local string temp;
	local string temp1;
	local string temp2;
	local string temp3;
	local string temp4;
	local string temp5;
	local string temp6;
	local string temp7;
	switch (txtureint)
	{
		case 0:
		//~ m_MiniMap.EraseAllRegionInfo();
		//~ m_MiniMap_Expand.EraseAllRegionInfo();
		
		ParseString(currentmaprecord[g_modedID], "Index", temp1 );
		ParseString(currentmaprecord[g_modedID], "WorldX", temp2 );
		ParseString(currentmaprecord[g_modedID], "WorldY", temp3);
		ParseString(currentmaprecord[g_modedID], "Description", temp4);
		ParseString(currentmaprecord[g_modedID], "DescOffsetX", temp5 );
		ParseString(currentmaprecord[g_modedID], "DescOffsetY", temp6);
		ParseString(currentmaprecord[g_modedID], "Tooltip", temp7);
		
		currentmaprecord[g_modedID] = "";
		
		ParamAdd(currentmaprecord[g_modedID], "Index", temp1);
		ParamAdd(currentmaprecord[g_modedID], "WorldX", temp2 );
		ParamAdd(currentmaprecord[g_modedID], "WorldY", temp3 );
		ParamAdd(currentmaprecord[g_modedID], "Description", temp4);
		ParamAdd(currentmaprecord[g_modedID], "DescOffsetX", temp5);
		ParamAdd(currentmaprecord[g_modedID], "DescOffsetY", temp6);
		ParamAdd(currentmaprecord[g_modedID], "Tooltip", temp7);
	
		ParamAdd(currentmaprecord[g_modedID], "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		ParamAdd(currentmaprecord[g_modedID], "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		ParamAdd(currentmaprecord[g_modedID], "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	
		ParamAdd(currentmaprecord[g_modedID], "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		ParamAdd(currentmaprecord[g_modedID], "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
		ParamAdd(currentmaprecord[g_modedID], "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");

		ParamAdd(currentmaprecord[g_modedID], "BtnWidth", string(GUIDEICON_SIZE));
		ParamAdd(currentmaprecord[g_modedID], "BtnHeight", string(GUIDEICON_SIZE));
		ParseString(currentmaprecord[g_modedID], "BtnTexNormal", temp);
		break;
	}
	for (i=0;i<currentmaprecord.length;i++)
	{

		ParseInt( currentmaprecord[i], "WorldX", comparedVecX );
		ParseInt( currentmaprecord[i], "WorldY", comparedVecY ); 
			
		comparedVecX = comparedVecX + REGIONINFO_OFFSETX;
		comparedVecY = comparedVecY + REGIONINFO_OFFSETY; 

		switch (txtureint)
		{
			case 0:
				if (currentloc.x == comparedVecX && currentloc.y == comparedVecY)
				{
					//~ debug("매칭되는가?");
					ParseString(currentmaprecord[i], "Index", temp1 );
					ParseString(currentmaprecord[i], "WorldX", temp2 );
					ParseString(currentmaprecord[i], "WorldY", temp3);
					ParseString(currentmaprecord[i], "Description", temp4);
					ParseString(currentmaprecord[i], "DescOffsetX", temp5 );
					ParseString(currentmaprecord[i], "DescOffsetY", temp6);
					ParseString(currentmaprecord[i], "Tooltip", temp7);
					
					currentmaprecord[i] = "";
					
					ParamAdd(currentmaprecord[i], "Index", temp1);
					ParamAdd(currentmaprecord[i], "WorldX", temp2 );
					ParamAdd(currentmaprecord[i], "WorldY", temp3 );
					ParamAdd(currentmaprecord[i], "Description", temp4);
					ParamAdd(currentmaprecord[i], "DescOffsetX", temp5);
					ParamAdd(currentmaprecord[i], "DescOffsetY", temp6);
					ParamAdd(currentmaprecord[i], "Tooltip", temp7);
					ParamAdd(currentmaprecord[i], "BtnTexNormal", "L2UI.TargetPos");
					ParamAdd(currentmaprecord[i], "BtnTexPushed", "L2UI.TargetPos");
					ParamAdd(currentmaprecord[i], "BtnTexOver", "L2UI.TargetPos");
					ParamAdd(currentmaprecord[i], "BtnWidth", string(GUIDEICON_SIZE));
					ParamAdd(currentmaprecord[i], "BtnHeight", string(GUIDEICON_SIZE));
					ParseString(currentmaprecord[i], "BtnTexNormal", temp);
					//~ debug (currentmaprecord[i]);
					//~ debug (temp);
					g_modedID = i;
					
				}
			break;
		}
		m_MiniMap.AddRegionInfo(currentmaprecord[i]);
		//~ m_MiniMap_Expand.AddRegionInfo(currentmaprecord[i]);
	}
}


function JustdisplayCurrentDataOnTheMap()
{
	local int i;
	
	m_MiniMap.EraseAllRegionInfo();
	//~ m_MiniMap_Expand.EraseAllRegionInfo();
	
	for (i=0;i<currentmaprecord.length;i++)
	{
		m_MiniMap.AddRegionInfo(currentmaprecord[i]);
		//~ m_MiniMap_Expand.AddRegionInfo(currentmaprecord[i]);
	}
}


// Search Quest Data 
function LoadQuestSearchResult(int SearchZone)
{
	//퀘스트 리스트 컨트롤에 퀘스트 이름, 수행조건, 추천레벨, 반복성, 소속영지, 의뢰인, 설명이 필요하다
	local string QuestName;
	local string Condition;
	local int MinLevel;
	local int MaxLevel;
	local int Type;
	local int Zone;
	local int NPC;
	//local int CountDigit;
	local string Description;
	local string LevelLimit;
	local string NPCname;
	local int i;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	
	local string TypeText;
if (SearchZone == 19989)
{
LoadQuestList();
}
else
{
	m_hQuestListCtrl.DeleteAllItem();
	for(i = 0; i < MAX_QUEST_NUM ; i++)
	{
		if(class'UIDATA_QUEST'.static.IsValidData(i))
		{
			if (class'UIDATA_QUEST'.static.GetQuestZone(i,1) == SearchZone)
			{
				QuestName = class'UIDATA_QUEST'.static.GetQuestName(i);
				Condition = class'UIDATA_QUEST'.static.GetRequirement(i,1);
				MinLevel = class'UIDATA_QUEST'.static.GetMinLevel(i,1);
				MaxLevel = class'UIDATA_QUEST'.static.GetMaxLevel(i,1);
				Type = class'UIDATA_QUEST'.static.GetQuestType(i,1);
				Zone = class'UIDATA_QUEST'.static.GetQuestZone(i,1);
				Description = class'UIDATA_QUEST'.static.GetIntro(i,1);
				NPC = class'UIDATA_QUEST'.static.GetStartNPCID(i,1);
				NPCname = class'UIDATA_NPC'.static.GetNPCName(NPC);
				if(MinLevel > 0 && MaxLevel > 0)
				{
					LevelLimit = MinLevel $ "~" $ MaxLevel;	
				}else if(minlevel > 0)
				{
					LevelLimit = MinLevel $ " " $ GetSystemString(859);
				}else
				{
					LevelLimit = GetSystemString(866);
				}		
				switch(Type)
				{
					case 0:
						TypeText = GetSystemString(861);
					break;
					case 1:
						TypeText = GetSystemString(862);
					break;
					case 2:
						TypeText = GetSystemString(861);
					break;
					case 3:
						TypeText = GetSystemString(862);
					break;
					case 4:
						TypeText = GetSystemString(861);
					break;
				}
				data1.nReserved1 = i;
				data1.szData = QuestName;
				Record.LVDataList[0] = data1;
				//data2.szData = Condition;
				data2.szData = TypeText;
				Record.LVDataList[1] = data2;
				data3.szData = NPCname;
				Record.LVDataList[2] = data3;
				data4.szData = LevelLimit;
				Record.LVDataList[3] = data4;
				//Record.szReserved = Description;
				//Record.nReserved1 = Type;
				//Record.nReserved2 = Zone;
				//Record.nReserved3 = NPC;
				//insertion to the list control.
				m_hQuestListCtrl.InsertRecord( Record );
			}
		}	
	}
}
}

// Area Information data
function LoadAreaInfoList()
{
	//지역정보 리스트 컨트롤에 필요한 변수 정의
	// 지역 이름
	local string AreaName;
	//분류
	local int Type;
	//소속영지
	local int Zone;
	//설명
	local string ZoneName;
	local string ZoneType;
	local string Description;
	//위치좌표
	local int i;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local Vector loc;
	local string DataforMap;

	m_hAreaInfoListCtrl.DeleteAllItem();
	
	ResetArray();
	comboxFiller("AreaInfoComboBox");
	class'UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.AreaInfoComboBox",0);

	
	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			Type = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
			if(Type > 2)
			{
				
				//지역정보 데이터 가지고 오?
				// 지역 이름
				AreaName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				//소속영지
				Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
				//설명
				Description = class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i); 
				//가공
				ZoneName = conv_dom(Zone);
				ZoneType = conv_zoneType(Type);
				//얻어온 데이터를 레코드로 만들기
				data1.nReserved1 = i;
				data1.szData = AreaName;
				Record.LVDataList[0] = data1;
				data2.szData = ZoneType;
				Record.LVDataList[1] = data2;
				data3.szData = ZoneName;
				Record.LVDataList[2] = data3;
				//툴팁 정보 레코드에 넣기
				Record.nReserved1 = IntToInt64(Zone);
				Record.szReserved = Description;
				//레코드를 리스트 컨트롤에 인서트 하기
				m_hAreaInfoListCtrl.InsertRecord( Record );
				
				
				loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(i);
				
				DataforMap = "";
				ParamAdd(DataforMap, "Index", string(i));
				ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
				ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
				ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
				ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
				ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
				ParamAdd(DataforMap, "Description", "");
				ParamAdd(DataforMap, "DescOffsetX", "0");
				ParamAdd(DataforMap, "DescOffsetY", "0");
				ParamAdd(DataforMap, "Tooltip", AreaName);
				
				currentmaprecord[i] = DataforMap ;
			}
		}	
	}
	
}

function ResetArray()
{
	local int i;
	//~ local array<string> currentmaprecord_empty;
	//~ currentmaprecord = currentmaprecord_empty;
	
	for (i=0; i < currentmaprecord.length; i++)
	{
		currentmaprecord.Remove(1,i);
		//~ currentmaprecord.Remove(0,i);
		
	}
	
	
}


// Search Area Information Data
function LoadAreaInfoListSearchResult(int SearchZone)
{
//지역정보 리스트 컨트롤에 필요한 변수 정의
	// 지역 이름
	local string AreaName;
	//분류
	local int Type;
	//소속영지
	local int Zone;
	//설명
	local string ZoneName;
	local string ZoneType;
	local string Description;
	//위치좌표
	local int i;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	
	if (SearchZone == 19989)
	{
		LoadAreaInfoList();
	}
	else
	{
		m_hAreaInfoListCtrl.DeleteAllItem();

		for(i = 0; i < MAX_QUEST_NUM ; i++)
		{
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
			{
				//log(SearchZone);
				if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == SearchZone)
				{
					//분류
					Type = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
					if(Type > 2)
					{
						//지역정보 데이터 가지고 오?
						// 지역 이름
						AreaName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
						//소속영지
						Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
						//설명
						Description = class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i); 
						//가공
						ZoneName = conv_dom(Zone);
						ZoneType = conv_zoneType(Type);
						//얻어온 데이터를 레코드로 만들기
						data1.nReserved1 = i;
						data1.szData = AreaName;
						Record.LVDataList[0] = data1;
						data2.szData = ZoneType;
						Record.LVDataList[1] = data2;
						data3.szData = ZoneName;
						Record.LVDataList[2] = data3;
						//툴팁 정보 레코드에 넣기
						//Record.m_szReserved = Description;
						//레코드를 리스트 컨트롤에 인서트 하기
						m_hAreaInfoListCtrl.InsertRecord( Record );
					}
				}	
			}
		}
	}
}

// Validate the comboboxes already have any data.
function comboxFiller(string ComboboxName)
{
	switch (comboboxName) 
	{
		case "QuestComboBox":
				proc_combox("QuestComboBox");
		break;
		case "HuntingZoneComboBox":
				proc_combox("HuntingZoneComboBox");
		break;
		//case "RaidInfoComboBox":
		//		proc_combox("RaidInfoComboBox");
		//break;
		case "AreaInfoComboBox":
				proc_combox("AreaInfoComboBox");
		break;
	}
}

// Process combox data filling.
function proc_combox(string ComboboxName)
{
	//local int currentsetnum;
	local string ComboboxNameFull;
	local string ZoneName;
	local int Zone;
	local int i;
	
	//currentsetnum = 0;
	ComboboxNameFull = "GuideWnd." $ ComboboxName;
	class'UIAPI_COMBOBOX'.static.Clear(ComboboxNameFull);
	class'UIAPI_COMBOBOX'.static.AddStringWithReserved(ComboboxNameFull,GetSystemString(144),19989);
	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == HUNTING_ZONE_TYPE)
			{
				ZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
				class'UIAPI_COMBOBOX'.static.AddStringWithReserved(ComboboxNameFull,ZoneName,Zone);
			}
		}	
	}

	//class'UIAPI_COMBOBOX'.static.SetSelectedNum(ComboboxNameFull, 0);
	//class'UIAPI_COMBOBOX'.static.("GuideWnd.QuestComboBox",0);
}


// Convert Domain Name ID to String Domain Name
function string conv_dom(int ZoneNameNum)
{
	local string ZoneNameStr;
	local int i;
	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == HUNTING_ZONE_TYPE)
			{
				if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == ZoneNameNum)
				{
					ZoneNameStr = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				}
			}
		}	
	}
	return ZoneNameStr;
}

// Convert ZoneType ID to Zone Type String
function string conv_zoneType(int ZoneTypeNum)
{
	local string ZoneTypeStr;
	switch(ZoneTypeNum)
	{
		case HUNTING_ZONE_FIELDHUTINGZONE:
		ZoneTypeStr = GetSystemString(1313);
		break;
		case HUNTING_ZONE_DUNGEON:
		ZoneTypeStr = GetSystemString(1314);	
		break;
		case HUNTING_ZONE_CASTLEVILLE:
		ZoneTypeStr = GetSystemString(1315);	
		break;
		case HUNTING_ZONE_HARBOR:
		ZoneTypeStr = GetSystemString(1316);	
		break;
		case HUNTING_ZONE_Agit:
		ZoneTypeStr = GetSystemString(1317);	
		break;
		case HUNTING_ZONE_COLOSSEUM:
		ZoneTypeStr = GetSystemString(1318);	
		break;
		case HUNTING_ZONE_ETCERA:
		ZoneTypeStr = GetSystemString(1319);	
		break;		
	}
	return ZoneTypeStr;
}

function string conv_zoneName(int search_zoneid)
{
	local string HuntingZoneName; 
	local int i;
	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{
		//debug( "conv_zoneName i=" $ i );
		
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if(class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
			{
				if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == search_zoneid)
				{
				HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				}
			}
		}	
	}
	return HuntingZoneName;
}


function CastleInfo()
{
	RequestAllCastleInfo();
}

function FortressInfo()
{
	RequestAllFortressInfo();
	
}

function AgitInfo()
{
	RequestAllAgitInfo();
}

function FortressSeigeInfoReq()
{
	RequestFortressSiegeInfo();
}



function int GetMapCastleID(string CastleName)
{
	local int i;
	local int resultval;
	
	for (i=0; i < MAX_HUNTINGZONE_NUM; i++)
	{
		if ( class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i) == CastleName )
		{
			resultval = i;
			//~ debug("지역정보는?" @ resultval);
		}
	}
	
	return resultval;
	
}

function LoadCastleInfo( string Param)
{
	//공성 데이터
	local int castleID;
	local string OwnerClanName;
	local string OwnerClanNameToolTip;
	local string TaxRate;
	local string NextSiegeTime;
	local string NextSiegeYear;
	local string NextSiegeMonth;
	local string NextSiegeDay;
	local string NextSiegeHour;
	local string NextSiegeMin;
	local string NextSiegeSec;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local Vector loc;
	local string DataforMap;
	local string CastleName;
	local int ZoneID;
	

	//성 아이디
	ParseInt( Param, "CastleID", castleID);
	//성 이름
	CastleName = GetCastleName(castleID);
	//소유혈맹
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//세금정보
	ParseString( Param, "TaxRate", TaxRate);
	//다음공성일
	//~ ParseString( Param, "NextSiegeTime", NextSiegeTime);
	
	//연도에다가는 무조건 1900을 더해야 한다. 
	ParseString( Param, "NextSiegeYear", NextSiegeYear);
	ParseString( Param, "NextSiegeMonth", NextSiegeMonth);
	ParseString( Param, "NextSiegeDay", NextSiegeDay);
	ParseString( Param, "NextSiegeHour", NextSiegeHour);
	ParseString( Param, "NextSiegeMin", NextSiegeMin);
	ParseString( Param, "NextSiegeSec", NextSiegeSec);
	
	//지형데이터아이디
	ZoneID = g_CastleID[castleID];	
	
	
	
	if (OwnerClanName == "")
	{
		OwnerClanName =  GetSystemString(27);
		OwnerClanNameToolTip =  GetSystemMessage(2196);
	}
	else
	{
		OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197),OwnerClanName);
		OwnerClanName = OwnerClanName @ GetSystemString(439);
		
	}
	
	if (NextSiegeMonth == "0" && NextSiegeYear == "70" && NextSiegeDay == "1")
	{
		NextSiegeTime = GetSystemString(584);
	}
	else 
	{
		NextSiegeMonth = String(Int(NextSiegeMonth)+1);
		NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay);
	}
	
	data1.nReserved1 = ZoneID;
	data1.szData = CastleName;
	Record.LVDataList[0] = data1;
	data2.szData = OwnerClanName;
	Record.LVDataList[1] = data2;
	data3.szData = TaxRate$"%";
	Record.LVDataList[2] = data3;
	data4.szData = NextSiegeTime;
	Record.LVDataList[3] = data4;
	
	m_CastleListCtrl.InsertRecord( Record );

	loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
	DataforMap = "";	
	
	ParamAdd(DataforMap, "Index", string(castleID));
	ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
	ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", CastleName $ "\\n" $ OwnerClanNameToolTip);
	currentmaprecord[castleID] = DataforMap ;
	m_MiniMap.AddRegionInfo(DataforMap);
	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	DataforMap = "";
	
}		

function LoadFortressInfo( string Param)
{
	//요새전 데이터
	local int FortressID;
	local string OwnerClanName;
	local string OwnerClanNameToolTip;
	local int SiegeState;
	local int LastOwndedTime;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	//~ local LVData data5;
	local Vector loc;
	local string DataforMap;
	local string CastleName;
	local string Statcur;
	local int ZoneID;
	local string iconname;
	
	local int Hour;
	local int Date;
	local int Min;
	local int Sec;
	
	local string DateTotal;
	
	Hour = 0;
	Date = 0;
	Min = 0;
	Sec = 0;
	
	
	//요새 아이디
	ParseInt( Param, "FortressID", FortressID);
	//요새  이름
	CastleName = GetCastleName(FortressID);
	//소유혈맹
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//요새전 진행
	ParseInt( Param, "SiegeStatae", SiegeState);
	//해당혈맹의 마지막 소유현황
	ParseInt( Param, "LastOwnedTime", LastOwndedTime);
	//~ debug("LastOwndedTime"@ LastOwndedTime);
	//지형데이터아이디
	ZoneID = g_CastleID[FortressID];	
	if (OwnerClanName == "")
	{
		OwnerClanName = GetSystemString(27);
		OwnerClanNameToolTip = GetSystemMessage(2196);
	}
	else
	{
		OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
		OwnerClanName = OwnerClanName @ GetSystemString(439);
		
	}
	//~ debug("전쟁현황?" @ SiegeState);
	if (SiegeState == 0)
	{
		Statcur = GetSystemString(894);
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SHIELD";
	} 
	else if(SiegeState == 1)
	{
		Statcur = GetSystemString(340);
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
	}

	Min = (LastOwndedTime/60);
	Hour = (Min/60);
	Date = (Hour/24);
	
	//~ debug ("계산값" @ Min @ Hour @ Date );

	if (Min <60 && Min != 0)
	{
		DateTotal = String(Min) @ GetSystemString(1111);
	}
	else if (Hour <60 && Hour != 0)
	{
		DateTotal = String(Hour) @ GetSystemString(1110);
	}
	else if (Date != 0)
	{
		DateTotal = String(Date) @ GetSystemString(1109);
	}
	
	//~ debug ("데이트 토탈"@ DateTotal);
	
	data1.nReserved1 = ZoneID;
	data1.szData = CastleName;
	Record.LVDataList[0] = data1;
	data2.szData = OwnerClanName;
	Record.LVDataList[1] = data2;
	data3.szData = Statcur;
	Record.LVDataList[2] = data3;
	if (LastOwndedTime == 0)
		data4.szData = GetSystemString(27);
	else 
		data4.szData = DateTotal;
	//~ data4.szData = String((((LastOwndedTime/1000)/60)/60));
	Record.LVDataList[3] = data4;
	m_FortressListCtrl.InsertRecord( Record );
	loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
	DataforMap = "";
	ParamAdd(DataforMap, "Index", string(FortressID));
	ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
	ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	ParamAdd(DataforMap, "BtnTexNormal", iconname);
	ParamAdd(DataforMap, "BtnTexPushed", iconname);
	ParamAdd(DataforMap, "BtnTexOver", iconname);
	ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", CastleName $ "\\n" $ Statcur $ "\\n" $OwnerClanName);
	//~ Log ("요새전데이터" @ DataforMap);
	currentmaprecord[FortressID-100] = DataforMap ;
	m_MiniMap.AddRegionInfo(DataforMap);
	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	DataforMap = "";
	//~ displayCurrentDataOnTheMap();
}	
	

function LoadAgitInfo( string Param)
{
	//지트데이트
	local int AgitID;
	local string OwnerClanName;
	local string OwnerClanMasterName;
	local int Type;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local Vector loc;
	local string DataforMap;
	local string CastleName;
	local int ZoneID;
	local string History;
	//~ debug ("실행은돼?");
	//요새 아이디
	ParseInt( Param, "AgitID", AgitID);
	//요새  이름
	CastleName = GetCastleName(AgitID);
	//소유혈맹
	ParseString( Param, "OwnerClanName", OwnerClanName);
	if (OwnerClanName == "")
	{
		OwnerClanName = GetSystemString(27);
	}
	//요새ㅕㄹ맹 주
	ParseString( Param, "OwnerClanMasterName", OwnerClanMasterName);
	if (OwnerClanMasterName == "")
	{
		OwnerClanMasterName = GetSystemString(27);
	}
	
	//해당혈맹의 마지막 소유현황
	ParseInt( Param, "Type", Type);
	//지형데이터아이디
	ZoneID = g_CastleID[AgitID];	
	if (Type == 0)
	{
		History =  GetSystemString(1706);
	}
	else if (Type == 1)
	{
		History =GetSystemString(1210);
	} 
	else if (Type == 2)
	{
		History =GetSystemString(49);
	}
	data1.nReserved1 = AgitID;
	data1.szData = CastleName;
	Record.LVDataList[0] = data1;
	data2.szData = OwnerClanName;
	Record.LVDataList[1] = data2;
	data3.szData = OwnerClanMasterName;
	Record.LVDataList[2] = data3;
	data4.szData = History;
	Record.LVDataList[3] = data4;
	m_AgitListCtrl.InsertRecord( Record );
	
	
	loc.x = agitid1[AgitID];
	loc.y = agitid2[AgitID];
		
	DataforMap = "";	
	ParamAdd(DataforMap, "Index", string(AgitID));
	ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
	ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", CastleName $ "\\n" $OwnerClanName);
	
	currentmaprecord[global_i] = DataforMap ;
	
	//~ m_MiniMap.AddRegionInfo(DataforMap);
	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	DataforMap = "";
}	

function LoadFortressSeigeInfo(string Param)
{
	//요새전 데이터
	local int FortressID;
	local Vector loc;
	local string DataforMap;
	local string CastleName;
	//~ local string Statcur;
	local int ZoneID;
	local string iconname;
	local int TotalBarrackCnt;
	local int CapturedBarrackCnt;
	local string CurrentStat;
	local string CurrentText;
	
	//요새 아이디
	ParseInt( Param, "FortressID", FortressID);
	//요새  이름
	CastleName = GetCastleName(FortressID);
	//요새 현황
	ParseInt( Param, "TotalBarrackCnt", TotalBarrackCnt);
	ParseInt( Param, "CapturedBarrackCnt", CapturedBarrackCnt);
	
	//~ debug ("현황1:" @ TotalBarrackCnt);
	//~ debug ("현황2:" @ CapturedBarrackCnt);
	CurrentText = GetSystemString(340);
	CurrentStat =  string(CapturedBarrackCnt)$"/"$string(TotalBarrackCnt);
	iconname = "L2UI_CT1.ICON_DF_SIEGE_SWORD";

	//지형데이터아이디
	ZoneID = g_CastleID[FortressID];	
	
	DataforMap = "";	
	loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
	ParamAdd(DataforMap, "Index", string(FortressID-100));
	ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
	ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	ParamAdd(DataforMap, "BtnTexNormal", iconname);
	ParamAdd(DataforMap, "BtnTexPushed", iconname);
	ParamAdd(DataforMap, "BtnTexOver", iconname);
	ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "Description", GetSystemString(1656) @ CurrentStat);
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", CastleName $ "\\n" $ CurrentText $ "\\n" $ GetSystemString(1656) @ CurrentStat);
	
	//~ Log ("요새현황" @ DataforMap);
	if ( ReduceButton.IsShowWindow() == false || ReduceButton_Expand.IsShowWindow() == false )
	{
		m_MiniMap.AddRegionInfo(DataforMap);
	}
	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	DataforMap = "";
	
	
}

function SetCastleLocData()
{
g_CastleID[1] = 43;
g_CastleID[2] = 9;
g_CastleID[3] = 27;
g_CastleID[4] = 83;
g_CastleID[5] = 112;
g_CastleID[6] = 127;
g_CastleID[7] = 182;
g_CastleID[8] = 202;
g_CastleID[9] = 156;
g_CastleID[101] = 254;
g_CastleID[102] = 255;
g_CastleID[103] = 250;
g_CastleID[104] = 253;
g_CastleID[105] = 256;
g_CastleID[106] = 261;
g_CastleID[107] = 262;
g_CastleID[108] = 264;
g_CastleID[109] = 267;
g_CastleID[110] = 269;
g_CastleID[111] = 266;
g_CastleID[112] = 251;
g_CastleID[113] = 257;
g_CastleID[114] = 252;
g_CastleID[115] = 258;
g_CastleID[116] = 259;
g_CastleID[117] = 260;
g_CastleID[118] = 263;
g_CastleID[119] = 265;
g_CastleID[120] = 268;
g_CastleID[121] = 270;

agitid1[21]=43370;
agitid1[22]=-16029;
agitid1[23]=-14848;
agitid1[24]=-13879;
agitid1[25]=-12710;
agitid1[26]=-84416;
agitid1[27]=-84171;
agitid1[28]=-84236;
agitid1[29]=-79544;
agitid1[30]=-79513;
agitid1[31]=17760;
agitid1[32]=18800;
agitid1[33]=20096;
agitid1[34]=177930;
agitid1[35]=80339;
agitid1[36]=149134;
agitid1[37]=150644;
agitid1[38]=145667;
agitid1[39]=150748;
agitid1[40]=143992;
agitid1[41]=144014;
agitid1[42]=78592;
agitid1[43]=82032;
agitid1[44]=83392;
agitid1[45]=80960;
agitid1[46]=82064;
agitid1[47]=146022;
agitid1[48]=146960;
agitid1[49]=148480;
agitid1[50]=149376;
agitid1[51]=37736;
agitid1[52]=38737;
agitid1[53]=39403;
agitid1[54]=39599;
agitid1[55]=39440;
agitid1[56]=38712;
agitid1[57]=37711;
agitid1[58]=85812;
agitid1[59]=86609;
agitid1[60]=88093;
agitid1[61]=88901;
agitid1[62]=140949;
agitid1[63]=60608;
agitid1[64]=57932;
agitid2[21]=108839;
agitid2[22]=123642;
agitid2[23]=125552;
agitid2[24]=125413;
agitid2[25]=124029;
agitid2[26]=152192;
agitid2[27]=153385;
agitid2[28]=155520;
agitid2[29]=150181;
agitid2[30]=151506;
agitid2[31]=145200;
agitid2[32]=143248;
agitid2[33]=146064;
agitid2[34]=-18629;
agitid2[35]=-15442;
agitid2[36]=23140;
agitid2[37]=23653;
agitid2[38]=25356;
agitid2[39]=26540;
agitid2[40]=27092;
agitid2[41]=28202;
agitid2[42]=148080;
agitid2[43]=145328;
agitid2[44]=145328;
agitid2[45]=151600;
agitid2[46]=151904;
agitid2[47]=-55560;
agitid2[48]=-56768;
agitid2[49]=-56848;
agitid2[50]=-55568;
agitid2[51]=-50777;
agitid2[52]=-50491;
agitid2[53]=-49668;
agitid2[54]=-48264;
agitid2[55]=-46806;
agitid2[56]=-46042;
agitid2[57]=-45723;
agitid2[58]=-143183;
agitid2[59]=-141949;
agitid2[60]=-141931;
agitid2[61]=-143200;
agitid2[62]=-124658;
agitid2[63]=-94016;
agitid2[64]=-26064;
agitid3[21]=-1980;
agitid3[22]=-3101;
agitid3[23]=-3128;
agitid3[24]=-3128;
agitid3[25]=-3096;
agitid3[26]=-3123;
agitid3[27]=-3159;
agitid3[28]=-3160;
agitid3[29]=-3038;
agitid3[30]=-3041;
agitid3[31]=-3036;
agitid3[32]=-3010;
agitid3[33]=-3111;
agitid3[34]=-2240;
agitid3[35]=-1804;
agitid3[36]=-2160;
agitid3[37]=-2150;
agitid3[38]=-2150;
agitid3[39]=-2280;
agitid3[40]=-2290;
agitid3[41]=-2280;
agitid3[42]=-3581;
agitid3[43]=-3520;
agitid3[44]=-3389;
agitid3[45]=-3517;
agitid3[46]=-3520;
agitid3[47]=-2765;
agitid3[48]=-2765;
agitid3[49]=-2765;
agitid3[50]=-2765;
agitid3[51]=950;
agitid3[52]=950;
agitid3[53]=950;
agitid3[54]=950;
agitid3[55]=950;
agitid3[56]=950;
agitid3[57]=950;
agitid3[58]=-1230;
agitid3[59]=-1230;
agitid3[60]=-1230;
agitid3[61]=-1230;
agitid3[62]=-1800;
agitid3[63]=-1349;
agitid3[64]=595;


}

function HandleDominionInfoCnt(string Param)
/* 
“DominionInfoCnt”             영지 정보 개수 : int
 */
{
	//~ local int DominionInfoCnt;
	
	//~ debug ("HandleDominionInfoCnt" @ Param);
	m_TerritoryListCtrl.DeleteAllItem();
	ParseInt	(Param, "DominionInfoCnt", m_DominionInfoCnt );
	//~ DominionInfoCnt = m_DominionInfoCnt;
}

function HandleDominionInfo(string Param)

/* 
“DominionID”       				영지ID : INT
“DominionName” 				영지이름 : string -> 영지 ID에 80을 빼면 성이름이 된답니다.   성이름은 castlename.txt에 있으니까 그거로 만들어서 사용하시면될 듯(이부분 규칙은 바뀌거나 새로 정해질수도있습니다.)
“ClanName”         				혈맹이름 : string
“DominionsOwnCnt”  			고유물 개수 : INT
“DominionsOwnName숫자”  		고유물 이름 (숫자는 개수만큼 반복)  -> 고유물은 나중에 classID가 넘어오게 됩니다. ClassID가지고 이름을 찾아내세요.
“NextDate”           				다음 영지전 시각 : INT
 */
{
	local int DominionID;
	local int DominionName;
	local string ClanName;
	local int DominionsOwnCnt;
	local int DominionsOwnName[8];  		
	local int NextDate;
	local int i;
	
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	//~ local LVTe
	//~ local LVData dataTex[9];
	//~ local int FortressID;
	local Vector loc;
	local string DataforMap;
	local string CastleName;
	//~ local string Statcur;
	local int ZoneID;
	//~ local string iconname;
	//~ local int TotalBarrackCnt;
	//~ local int CapturedBarrackCnt;
	//~ local string CurrentStat;
	//~ local string CurrentText;
	local texture DominionFlagTex;
	local texture DominionFlagTexreset;
	//~ local itemInfo FlagItem;
	//~ local itemID ID;
	
	//debug ("HandleDominionInfoCnt" @ Param);
	
	// 영지 ID
	ParseInt	(Param, "DominionID", DominionID );
	ParseInt	(Param, "DominionsOwnCnt", DominionsOwnCnt );
	//~ ParseInt	(Param, "DominionsOwnName", DominionsOwnName );
	
	
	ParseInt	(Param, "NextDate", NextDate );
	ParseInt	(Param, "DominionName", DominionName );
	ParseString	(Param, "ClanName", ClanName );
	
	ZoneID = g_CastleID[DominionID - 80];
	
	data3.arrTexture.Length = 9;
	//debug ("DominionsOwnCnt" @ DominionsOwnCnt);
	/* if (DominionsOwnCnt > 0)
	{
		//~ data3.arrTexture.Length = 9;
		for (i=0;i<= DominionsOwnCnt; i++)
		{
			//~ ParseInt	(Param, "DominionsOwnName"$ string(i),  DominionsOwnName[i]);
			//debug ("DominionsOwnName" @  DominionsOwnName[i]);
			DominionFlagTex = DominionFlagTexreset;
			DominionFlagTex = GetDominionFlagIconTex(DominionsOwnName[i]);
			//~ DominionFlagTex = GetDominionFlagIconTex(DominionID);
			data3.arrTexture[i].objTex = DominionFlagTex;
			data3.arrTexture[i].Width = 12;
			data3.arrTexture[i].Height =12;
			data3.arrTexture[i].X = (i*12);
			data3.arrTexture[i].Y = 0;
			data3.arrTexture[i].U = 32;
			data3.arrTexture[i].V = 32;
		}
	} */
	
	for (i=1; i<10; i++)
	{
		ParseInt (Param, "HaveOwnthingDominionID" $ i , DominionsOwnName[i]);
		
		//~ debug ("DominionsOwnName" @  DominionsOwnName[i]);
		DominionFlagTex = DominionFlagTexreset;
		DominionFlagTex = GetDominionFlagIconTex(DominionsOwnName[i]);
		data3.arrTexture[i-1].objTex = DominionFlagTex;
		data3.arrTexture[i-1].Width = 12;
		data3.arrTexture[i-1].Height =12;
		data3.arrTexture[i-1].X = (i*12);
		data3.arrTexture[i-1].Y = 0;
		data3.arrTexture[i-1].U = 32;
		data3.arrTexture[i-1].V = 32;
	}
	
	
	
	
	Record.LVDataList[2] = data3;
	CastleName = GetCastleName(DominionID);
	data1.nReserved1 = ZoneID;
	data1.szData = CastleName;
	Record.LVDataList[0] = data1;
	data2.szData = ClanName;
	Record.LVDataList[1] = data2;
	data4.szData = ConvertTimetoStr(NextDate);
	Record.LVDataList[3] = data4;
	m_TerritoryListCtrl.InsertRecord( Record );
	
	
	//~ ZoneID = g_CastleID[DominionID-80];
	
	loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
	//~ loc.x = g_CastleID[AgitID];
	//~ loc.y = g_CastleID[AgitID];
		
	DataforMap = "";	
	ParamAdd(DataforMap, "Index", string(ZoneID));
	ParamAdd(DataforMap, "WorldX", string(loc.x -REGIONINFO_OFFSETX));
	ParamAdd(DataforMap, "WorldY", string(loc.y - REGIONINFO_OFFSETY));
	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
	ParamAdd(DataforMap, "BtnWidth", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "BtnHeight", string(GUIDEICON_SIZE));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", "" $ "\\n" $"");
	
	currentmaprecord[global_i] = DataforMap ;
	
	m_MiniMap.AddRegionInfo(DataforMap);
	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	//~ DataforMap = "";

	
}


defaultproperties
{
    m_WindowName="GuideWnd"
}
