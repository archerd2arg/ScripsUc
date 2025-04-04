class TeleportBookMarkWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_0";

var WindowHandle Me;
var WindowHandle BookMarkEditWnd;
var TextBoxHandle txtTeleportLoc;
var ItemWindowHandle ItemBookMarkItem;
var TextBoxHandle txtSlotAvailability;
var TextBoxHandle txtSavedTeleportList;
var TextBoxHandle txtRequiredItemCount;
var MinimapCtrlHandle Minimap;
var ButtonHandle ItemDelete;
var ButtonHandle ItemEdit;
var ButtonHandle btnSaveMyLoc;
var TeleportBookMarkDrawerWnd m_Script;
var ButtonHandle btnReduce;
var TextBoxHandle txtNoticeMessage;
var TextBoxHandle txtNoticeMessage2;
var TextureHandle TexDeactivated;


var ItemID	m_CurBookMarkItemID;
var ItemID  m_DeleteBookMarkItemID;
var int m_totalableSlotNum;

function OnEnterState( name a_PreStateName )
{
//	class'BookMarkAPI'.static.RequestBookMarkSlotInfo();
}
function OnShow()
{
	class'BookMarkAPI'.static.RequestBookMarkSlotInfo();
	class'BookMarkAPI'.static.RequestShowBookMark();
	OnMyLocBtnClick();
	GetTeleportItemCnt();
	btnReduce.HideWindow();
	txtSavedTeleportList.SetText(GetSystemString(1749));
}

function GetTeleportItemCnt()
{
	debug ("GetTeleportBookMarkCount" @ GetTeleportBookMarkCount());
	txtSavedTeleportList.SetText(MakeFullSystemMsg(GetSystemMessage(2360), String(GetTeleportBookMarkCount()), ""));
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
	txtNoticeMessage.ShowWindow();
	txtNoticeMessage2.ShowWindow();
	ClearItemID(m_CurBookMarkItemID);
	//~ SetUnActiveSlots();
	
	//~ txtNoticeMessage.HideWindow();
	//~ txtNoticeMessage2.HideWindow();
}

function Initialize()
{
	Me = GetHandle( "TeleportBookMarkWnd" );
	BookMarkEditWnd = GetHandle( "TeleportBookMarkDrawerWnd" );
	txtTeleportLoc = TextBoxHandle ( GetHandle( "TeleportBookMarkWnd.txtTeleportLoc" ) );
	ItemBookMarkItem = ItemWindowHandle ( GetHandle( "TeleportBookMarkWnd.ItemBookMarkItem" ) );
	txtSlotAvailability = TextBoxHandle ( GetHandle( "TeleportBookMarkWnd.txtSlotAvailability" ) );
	txtSavedTeleportList = TextBoxHandle ( GetHandle( "TeleportBookMarkWnd.txtSavedTeleportList" ) );
	txtRequiredItemCount = TextBoxHandle ( GetHandle( "TeleportBookMarkWnd.txtRequiredItemCount" ) );
	Minimap = MinimapCtrlHandle ( GetHandle( "TeleportBookMarkWnd.Minimap" ) );
	ItemDelete = ButtonHandle ( GetHandle( "TeleportBookMarkWnd.ItemDelete" ) );
	ItemEdit = ButtonHandle ( GetHandle( "TeleportBookMarkWnd.ItemEdit" ) );
	btnSaveMyLoc = ButtonHandle ( GetHandle( "TeleportBookMarkWnd.btnSaveMyLoc" ) );
	btnReduce = ButtonHandle (GetHandle("TeleportBookMarkWnd.btnReduce") );
	TexDeactivated = TextureHandle (GetHandle("TeleportBookMarkWnd.TexDeactivated"));
	txtNoticeMessage = TextBoxHandle (GetHandle("TeleportBookMarkWnd.txtNoticeMessage"));
	txtNoticeMessage2 = TextBoxHandle (GetHandle("TeleportBookMarkWnd.txtNoticeMessage2"));
	m_totalableSlotNum = 0;
	m_Script = TeleportBookMarkDrawerWnd(GetScript("TeleportBookMarkDrawerWnd"));
	btnReduce.HideWindow();

}
function InitializeCOD()
{
	Me = GetWindowHandle( "TeleportBookMarkWnd" );
	BookMarkEditWnd = GetWindowHandle( "TeleportBookMarkDrawerWnd" );
	txtTeleportLoc = GetTextBoxHandle( "TeleportBookMarkWnd.txtTeleportLoc" );
	ItemBookMarkItem = GetItemWindowHandle ( "TeleportBookMarkWnd.ItemBookMarkItem" );
	txtSlotAvailability = GetTextBoxHandle( "TeleportBookMarkWnd.txtSlotAvailability" );
	txtSavedTeleportList = GetTextBoxHandle( "TeleportBookMarkWnd.txtSavedTeleportList" );
	txtRequiredItemCount = GetTextBoxHandle( "TeleportBookMarkWnd.txtRequiredItemCount" );
	Minimap = GetMinimapCtrlHandle ( "TeleportBookMarkWnd.Minimap" );
	ItemDelete = GetButtonHandle ( "TeleportBookMarkWnd.ItemDelete" );
	ItemEdit = GetButtonHandle ( "TeleportBookMarkWnd.ItemEdit" );
	btnSaveMyLoc = GetButtonHandle ( "TeleportBookMarkWnd.btnSaveMyLoc" );
	btnReduce = GetButtonHandle ("TeleportBookMarkWnd.btnReduce");
	TexDeactivated = GetTextureHandle ("TeleportBookMarkWnd.TexDeactivated");
	txtNoticeMessage = GetTextBoxHandle ("TeleportBookMarkWnd.txtNoticeMessage");
	txtNoticeMessage2 = GetTextBoxHandle ("TeleportBookMarkWnd.txtNoticeMessage2");
	btnReduce.HideWindow();
}

function Load()
{
	ClearItemID(m_CurBookMarkItemID);
}

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_MinimapShowReduceBtn );
	RegisterEvent( EV_BookMarkList);
	RegisterEvent( EV_BookMarkShow );
	RegisterEvent( EV_BeginShowZoneTitleWnd );
	RegisterEvent( EV_SystemMessage );
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnSaveMyLoc":
		OnbtnSaveMyLocClick();
		break;
	case "BtnMyLoc":
		OnMyLocBtnClick();
		break;
	case "btnReduce":
		Minimap.RequestReduceBtn();
		btnReduce.HideWindow();
		SetLocatorOnMiniMap2();
		break;
	}
}


function OnEvent(int Event_ID, String param)
{
	local int 		SystemMsgIndex;
	if (Event_ID == EV_BookMarkList)
	{
		HandleBookMarkList(param);
	}	
	else if (Event_ID == EV_DialogOK )
	{
		if (DialogIsMine())
		{
			if (IsValidItemID(m_DeleteBookMarkItemID))
			{
				class'BookMarkAPI'.static.RequestDeleteBookMarkSlot(m_DeleteBookMarkItemID);			
				ClearItemID(m_DeleteBookMarkItemID);						
			}
		}
	}	
	else if (Event_ID == EV_BeginShowZoneTitleWnd)
	{
		GetTeleportItemCnt();
	}
	else if (Event_ID == EV_BookMarkShow)
	{
		OpenWindow();
	}
	else if (Event_ID == EV_MinimapShowReduceBtn)
	{
		//~ btnReduce.ShowWindow();
		//~ minimap.EraseAllRegionInfo();
		//~ SetLocatorOnMiniMap2();
	}
	else if (Event_ID == EV_SystemMessage)
	{
		ParseInt ( param, "Index", SystemMsgIndex );
		HandleUpdateItemCountSystemMessage(SystemMsgIndex);
	}
		
}


function HandleUpdateItemCountSystemMessage( int Index)
{
	switch(Index)
	{
		case 301:
		case 302:
		case 301:
		case 377:
			GetTeleportItemCnt();
			break;
	}
}

function OpenWindow()
{
	Me.ShowWindow();
	Me.SetFocus();
}

//Trash아이콘으로의 DropITem
function OnDropItem( string strID, ItemInfo infItem, int x, int y)
{
	switch( strID )
	{
	case "ItemDelete":
		OnDeleteBookMarkSlot(infItem);
		break;
	case "ItemEdit":
		OnModifyBookMarkSlot(infItem);
		break;
	}
}

function SetUnActiveSlots()
{
	//~ local int idx;
	//~ local ItemInfo ClearItem;
	//~ ClearItemID( ClearItem.ID );
	//~ ClearItem.IconName = "L2ui_ct1.ItemWindow_DF_SlotBox_Disable";
	
	//~ for(idx=0; idx<30; ++idx)
	//~ {
		//~ ItemBookMarkItem.AddItem(ClearItem);
	//~ }
	TexDeactivated.ShowWindow();
}

function HandleBookMarkList(string param)
{
	local int idx;	
	local int ableSlotNum;
	local int curSlotNum;
	//~ local int slotID, 
	local int iconID;
	local string strSlotTitle;
	local string strIconTitle;
	local string strTexture;
	local ItemInfo infItem;
	local ItemInfo ClearItem;
	local int	 emptySlot;
	local vector loc;
	
	ClearItemID( ClearItem.ID );
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	Clear();
	ParseInt(param, "Count", ableSlotNum);
	curSlotNum = 0;
	m_totalableSlotNum = ableSlotNum;
	
	if (ableSlotNum == 0)
	{
		txtNoticeMessage.ShowWindow();
		txtNoticeMessage2.ShowWindow();
		TexDeactivated.ShowWindow();
		SetUnActiveSlots();
		
	}
	else
	{
		txtNoticeMessage.HideWindow();
		txtNoticeMessage2.HideWindow();
		TexDeactivated.HideWindow();
	}
	
	
	
	for(idx=0; idx<ableSlotNum; ++idx)
	{
		
		strSlotTitle = "";
		strIconTitle = "";
		strTexture = "";

		ParseInt(param, "EmptySlot_" $ idx, emptySlot);
		if (emptySlot == 1)
		{
			ItemBookMarkItem.AddItem(ClearItem);
		}
		else
		{
			ParseItemIDWithIndex(param, infItem.ID, idx);
			ParseString(param, "SlotName_" $ idx, strSlotTitle);
			ParseInt(param, "IconID_" $ idx, iconID);
			ParseString(param, "IconName_" $ idx, strIconTitle);
			ParseFloat(param,"XPos_" $ idx, loc.X);
			ParseFloat(param,"YPos_" $ idx, loc.Y);
			ParseFloat(param,"ZPos_" $ idx, loc.Z);
			 
	
			infItem.Name = strSlotTitle;
			infItem.AdditionalName = strIconTitle;
			infItem.IconName = TEMPLATEICONNAME $ string(iconID);
			infItem.Description = strIconTitle;
			infItem.ItemSubType = int(EShortCutItemType.SCIT_BOOKMARK);
			
			ItemBookMarkItem.AddItem(infItem);
			curSlotNum++;
		}			
	}
	SetBookMarkCount(ableSlotNum, curSlotNum);
}

function OnDeleteBookMarkSlot(ItemInfo infItem)
{
	local string strMsg;
	
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_BOOKMARK))
		return;
		
	strMsg = MakeFullSystemMsg(GetSystemMessage(2362), infItem.Name, "");
	m_DeleteBookMarkItemID = infItem.ID;
	DialogShow(DIALOG_Modalless,DIALOG_Warning, strMsg);
	
	
}

function OnModifyBookMarkSlot(ItemInfo infItem)
{

	local vector loc;
	local TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
	
	txtTeleportBookMarkDrawerWndNameHead = TextBoxHandle(GetHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead"));
	
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_BOOKMARK))
		return;
	
	m_CurBookMarkItemID = infItem.ID;	
	//이름
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
	//단축이름
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
	
	class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);				
	txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
	SetLocatorOnMiniMap(loc);
	
	m_Script.m_CurIconNum = Int(Right(infItem.IconName,1));
	m_Script.UpdateIcon();

	if(!BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.ShowWindow();
		BookMarkEditWnd.SetFocus();
	}	
}


/* function OnModifyBookMarkSlotWithClick(ItemInfo infItem)
{

	local vector loc;
	local TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
	txtTeleportBookMarkDrawerWndNameHead = TextBoxHandle(GetHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead"));
	m_CurBookMarkItemID = infItem.ID;	
	
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
	
	class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);				
	
	m_Script.m_CurIconNum = Int(Right(infItem.IconName,1));
	m_Script.UpdateIcon();
	
	txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
	SetLocatorOnMiniMap(loc);
} */

function OnbtnSaveMyLocClick()
{
	ClearItemID(m_CurBookMarkItemID);
	if ( BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.HideWindow();
	}
	else
	{
		m_Script.InitializeUI();
		m_Script.UpdateCurrentLocation();
		BookMarkEditWnd.ShowWindow();
		SetCurrentLocOnMinimap();
	}
	GetTeleportItemCnt();
}

function SetCurrentLocOnMinimap()
{
	local vector loc;
	loc = GetPlayerPosition();
	SetLocatorOnMiniMap(loc);
}

function SetLocatorOnMiniMap(vector Loc)
{
	local string DataforMap;

	minimap.EraseAllRegionInfo();
	
	ParamAdd(DataforMap, "Index", "BookMarkID");
	ParamAdd(DataforMap, "WorldX", string(loc.x));
	ParamAdd(DataforMap, "WorldY", string(loc.y-1500));
	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnTexOver",  "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnWidth", string(24));
	ParamAdd(DataforMap, "BtnHeight", string(24));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "-20");
	ParamAdd(DataforMap, "Tooltip", "");
	minimap.AddRegionInfo(DataforMap);	
	
	Minimap.AdjustMapView(loc);
}

function SetLocatorOnMiniMap2()
{
	local vector loc;
	local string DataforMap;

	loc = GetPlayerPosition();
	
	ParamAdd(DataforMap, "Index", "BookMarkID");
	ParamAdd(DataforMap, "WorldX", string(loc.x));
	ParamAdd(DataforMap, "WorldY", string(loc.y-1500));
	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnTexOver",  "l2ui_ch3.mapicon_mark");
	ParamAdd(DataforMap, "BtnWidth", string(24));
	ParamAdd(DataforMap, "BtnHeight", string(24));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "-20");
	ParamAdd(DataforMap, "Tooltip", "");
	minimap.AddRegionInfo(DataforMap);	
}

function Clear()
{
	Minimap.DeleteAllTarget();
	ItemBookMarkItem.Clear();
}

//매크로의 클릭
function OnDBClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "ItemBookMarkItem" && index>-1)
	{
		if (ItemBookMarkItem.GetItem(index, infItem))
		{
			if (infItem.ID.ClassID > 0 )
				class'BookMarkAPI'.static.RequestTeleportBookMark(infItem.ID);
		}
	}
	GetTeleportItemCnt();
}

function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	local vector 	loc;
	if (strID == "ItemBookMarkItem" && index>-1)
	{
		if (ItemBookMarkItem.GetItem(index, infItem))
		{
			if (infItem.ID.ClassID > 0 )
			{								
				class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);				
				SetLocatorOnMiniMap(loc);
			}
		}		
	}
	GetTeleportItemCnt();
}

function SetBookMarkCount(int ableSlotNum, int curSlotNum)
{
	txtSlotAvailability.SetText("(" $ string(curSlotNum) $ "/" $ string(ableslotNum) $ ")");
	//~ txtSavedTeleportList.SetText("");
}

function OnMyLocBtnClick()
{
	local Vector PlayerPosition;
	PlayerPosition = GetPlayerPosition();
	Minimap.DeleteAllTarget();
	SetLocatorOnMiniMap(PlayerPosition);
}
defaultproperties
{
}
