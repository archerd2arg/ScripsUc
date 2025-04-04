class MiniMapDrawerWnd extends UICommonAPI;

var WindowHandle 			Me;
var WindowHandle 			GuideWnd;
var TabHandle 				TrackItemTab;
var ListCtrlHandle 			ListTrackItem1;
var ListCtrlHandle 			ListTrackItem2;
var ListCtrlHandle 			ListTrackItem3;
var ButtonHandle 			btnClose;
var MinimapCtrlHandle 			MiniMap;

var WindowHandle m_hSystemMenuWnd;
var MinimapWnd m_MiniMapWndScript;

function OnRegisterEvent()
{ 
	//~ RegisterEvent( EV_ShowWindow );
	//~ RegisterEvent( EV_DominionsOwnPos);
	
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		GuideWnd = 		GetHandle( "GuideWnd" );
		Me = 			GetHandle( "MiniMapDrawerWnd" );
		TrackItemTab = 		TabHandle(GetHandle("MiniMapDrawerWnd.TrackItemTab"));
		ListTrackItem1 = 	ListCtrlHandle(GetHandle("MiniMapDrawerWnd.ListTrackItem1"));
		ListTrackItem2 = 	ListCtrlHandle(GetHandle("MiniMapDrawerWnd.ListTrackItem2"));
		ListTrackItem3 = 	ListCtrlHandle(GetHandle("MiniMapDrawerWnd.ListTrackItem3"));
		btnClose = 		ButtonHandle(GetHandle("MiniMapDrawerWnd.btnClose"));
		MiniMap = 			MinimapCtrlHandle(GetHandle( "MinimapWnd.Minimap" ));
		m_MiniMapWndScript = MinimapWnd( GetScript("MinimapWnd" ) );
	}       
	else  
	{
		Me = 			GetWindowHandle( "MiniMapDrawerWnd" );
		GuideWnd = 		GetWindowHandle( "GuideWnd" );
		TrackItemTab = 		GetTabHandle("MiniMapDrawerWnd.TrackItemTab");
		ListTrackItem1 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem1");
		ListTrackItem2 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem2");
		ListTrackItem3 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem3");
		btnClose = 		GetButtonHandle("MiniMapDrawerWnd.btnClose");
		MiniMap = 		GetMinimapCtrlHandle( "MinimapWnd.Minimap" );
		m_MiniMapWndScript = MinimapWnd( GetScript("MinimapWnd" ) );
	}
	
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose" :
			Me.HideWindow();
	}
}

function OnShow()
{
	if (GuideWnd.IsShowWindow())
	{
		GuideWnd.HideWindow();
	}
	ListTrackItem3.DeleteAllItem();
	RequestDominionInfo();
}


//~ function OnHide()
//~ {
	//~ InsertQuestTrackList();
//~ }

function InsertQuestTrackList()
{
	local QuestTreeWnd Script;
	Script = QuestTreeWnd(GetScript("QuestTreeWnd"));
	ListTrackItem1.DeleteAllItem();
	script.InsertQuestTrackList();
}

//~ function OnEvent(int Event_ID, string Param)
//~ {
	//~ switch (Event_ID)
	//~ {
		//~ case EV_DominionsOwnPos:
			//~ ListTrackItem3.DeleteAllItem();
			//~ HandleDominionsOwnPos(Param);
			//~ break;
	//~ }
//~ }

	

//~ function HandleDominionsOwnPos(string Param)
/* 
“DominionsOwnName	고유물이름 : string     -> 고유물은 나중에 classID가 넘어오게 됩니다. ClassID가지고 이름을 찾아내세요.
“PosX”  				X :INT
“PosY”   				Y : INT
“PosZ”   				Z : INT
 */
//~ { 
	//~ local int DominionID;
	//~ local vector MapLocation;
	//~ local int x;
	//~ local int y;
	//~ local int z;
	//~ local LVDataRecord Record;
	//~ local LVData data1;
	//~ local LVData data2;
	//~ local LVData data3;
	//~ local Vector loc;
	//~ local string DataforMap;
	//~ local MinimapWnd Script2;
	//~ Script2 = MinimapWnd(GetScript("MinimapWnd"));
	//~ DataforMap = "";
	//~ debug ("HandleDominionsOwnPos" @ Param);
	
	//~ ParseInt	(Param, "DominionID", DominionID );
	//~ ParseInt	(Param, "PosX", x );
	//~ ParseInt	(Param, "PosY", y);
	//~ ParseInt	(Param, "PosZ", z );
	
	//~ data1.nReserved1 = DominionID;
	//~ data2.nReserved2 = x;
	//~ data3.nReserved3 = y;
	//~ data1.szData = GetCastleName(DominionID);
	//~ Record.LVDataList[0] = data1;
	//~ Record.LVDataList[1] = data2;
	//~ Record.LVDataList[2] = data3;
	
	//~ ListTrackItem3.InsertRecord( Record );

//~ }



function OnClickListCtrlRecord(string ID)
{
	local LVDataRecord Record;
	//local int SelectedIndex;
	local QuestTreeWnd Script;
	local MinimapWnd Script2;
	local int temp1; 
	local int temp2;
	local int temp3;
	local string RequestParam;
	local vector loc;
	local MinimapCtrlHandle m_MiniMap;
	m_MiniMap = MinimapCtrlHandle(GetHandle( "MinimapWnd.Minimap" ));

	Script = QuestTreeWnd(GetScript("QuestTreeWnd"));
	Script2 = MinimapWnd(GetScript("MinimapWnd"));
	RequestParam = "";
	if (ID == "ListTrackItem1")
	{
		ListTrackItem1.GetSelectedRec(Record);
		//SelectedIndex = ListTrackItem1.GetSelectedIndex();
		temp1 = Record.LVDataList[0].nReserved1;
		temp2 = Record.LVDataList[1].nReserved2;
		temp3 = Record.LVDataList[0].nReserved3;
		Script.HandleQuestSetCurrentIDfromMiniMap(temp1, temp2, temp3);
		Script2.OnClickTargetButton();
	}
	if (ID == "ListTrackItem2")
	{
		Script2.m_AdjustCursedLoc = true;
		//~ class'MiniMapAPI'.static.RequestCursedWeaponLocation();
		ListTrackItem2.GetSelectedRec(Record);
		temp1 = Record.LVDataList[0].nReserved1;
		class'MiniMapAPI'.static.RequestCursedWeaponLocation();
		if (temp1 == 8190)
		{
			ParamAdd(RequestParam, "NUM", string(0));
			Script2.HandleCursedWeaponLoctaion(RequestParam);
			
		}
		else if (temp1 == 8689)
		{
			ParamAdd(RequestParam, "NUM", string(0));
			Script2.HandleCursedWeaponLoctaion(RequestParam);
		}
	}
	if (ID == "ListTrackItem3")
	{
		ListTrackItem3.GetSelectedRec(Record);
		loc.x = Record.LVDataList[1].nReserved2;
		loc.y = Record.LVDataList[2].nReserved3;
		loc.z = Record.LVDataList[2].nReserved2;

		m_MiniMap.EraseAllRegionInfo();
		m_MiniMap.DeleteAllTarget(); 
		Script2.SetLocContinent(loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,false); 
		//class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
		//class'UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap",loc); 

		//Minimap.AdjustMapView(loc,true); 
		ListTrackItem3.DeleteAllItem();
		RequestDominionInfo();
	}
}
defaultproperties
{
}
