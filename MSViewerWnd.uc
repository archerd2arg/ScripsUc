class MSViewerWnd extends UICommonAPI;


const SK_NORMAL=0;
const SK_BUFF=1;
const SK_DEBUFF=2;
const SK_TOGGLE=3;
const SK_SONGDANCE=4;
const SK_PASSIVE=5;
const SK_SEARCH=6;
const SK_MAX=7;

var string m_WindowName;


var ItemWindowHandle	m_hItemWnd[ SK_MAX ];

var WindowHandle m_hWnd;

var TabHandle		m_hTabItemWnd;

var EditBoxHandle	m_hEbSkillName;
var EditBoxHandle	m_hEbSkillID;

var TextBoxHandle	m_hTxtFrontHairTexture;
var TextBoxHandle	m_hTxtRearHairTexture;

function OnRegisterEvent()
{
	registerEvent(EV_MSViewerWndAddSkill);
	registerEvent(EV_MSViewerWndShow);
}

function OnLoad()
{
	InitializeHandle();
	m_hWnd.SetWindowTitle("SKILL VIEWER");
}


function InitializeHandle()
{
	m_hWnd=GetWindowHandle(m_WindowName);

	m_hTabItemWnd=GetTabHandle(m_WindowName$".SkillTab");

	m_hItemWnd[ SK_NORMAL ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillNormal");
	m_hItemWnd[ SK_BUFF ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillBuff");
	m_hItemWnd[ SK_DEBUFF ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillDebuff");
	m_hItemWnd[ SK_TOGGLE ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillToggle");
	m_hItemWnd[ SK_SONGDANCE ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillSongdance");
	m_hItemWnd[ SK_PASSIVE ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillPassive");
	m_hItemWnd[ SK_SEARCH ]=GetItemWindowHandle(m_WindowName$".ItemWndSkillSearch");

	m_hEbSkillName=GetEditBoxHandle(m_WindowName$".ebSkillName");
	m_hEbSkillID=GetEditBoxHandle(m_WindowName$".ebSkillID");
}

function OnEvent( int a_EventID, String Param )
{
//	debug(""$a_EventID @ Param);
	switch( a_EventID )
	{
	case EV_MSViewerWndAddSkill :
		HandleAddSkill(Param);
		break;
	case EV_MSViewerWndShow :
		m_hWnd.ShowWindow();	
		break;
	}
}

function HandleAddSkill(string Param)
{
	local int Type;
	local int SkillLevel;
	local int Lock;
	local string strIconName;
	local string strSkillName;
	local string strDescription;
	local string strEnchantName;
	local string strCommand;
	local string strIconPanel;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Type);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "Lock", Lock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "AdditionalName", strEnchantName);
	ParseString(param, "Command", strCommand);
	
	//debug(" Type : " $ Tmp $ "SkillLevel : " $ SkillLevel $ " strSkillName : " $ strSkillName $ " Command : " $ strCommand);

	infItem.Level = SkillLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_SKILL);
	infItem.MacroCommand = strCommand;
	if (Lock>0)
	{
		infItem.bIsLock = true;
	}
	else
	{
		infItem.bIsLock = false;
	}

	if(type>=0 && type<SK_MAX)
		m_hItemWnd[type].AddItem(infItem);
}

// ItemWindow Event
function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	OnRClickItemWithHandle(a_hItemWindow, index );
}

function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local itemInfo info;
	a_hItemWindow.GetItem(index, info);
//	debug("SkillName:"$info.Name);
	class'UIDATA_PAWNVIEWER'.static.ExecuteSkill(info.ID);
}


function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnSearchByName" :
		processBtnSearchByName();
		break;
	case "btnSearchByID" :
		processBtnSearchByID();
		break;
	}
}

function processBtnSearchByName()
{
	local string inputString;

	m_hItemWnd[SK_SEARCH].Clear();
	inputString=m_hEbSkillName.GetString();
	if(Len(inputString)>0)
	{
		class'UIDATA_PAWNVIEWER'.static.AddSkillByName(inputString);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
}

function processBtnSearchByID()
{
	local int ID;
	m_hItemWnd[SK_SEARCH].Clear();
	ID=int(m_hEbSkillID.GetString());
	if(ID>0)
	{
		class'UIDATA_PAWNVIEWER'.static.AddSkillByID(ID);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
}

function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	if (nKey == IK_Enter )
	{
		if(m_hEbSkillName==a_WindowHandle)
			processBtnSearchByName();
		else if (m_hEbSkillID==a_WindowHandle)
			processBtnSearchByID();
	}
}


defaultproperties
{
    m_WindowName="MSViewerWnd"
}
