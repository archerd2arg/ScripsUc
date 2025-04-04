class ActionWnd extends UICommonAPI;

var bool m_bShow;

function OnRegisterEvent()
{
	RegisterEvent(EV_ActionListNew);
	RegisterEvent(EV_ActionListStart);
	RegisterEvent(EV_ActionList);
	RegisterEvent(EV_LanguageChanged);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_bShow = false;
	
	//ItemWnd의 스크롤바 Hide
	HideScrollBar();
}

function OnShow()
{
	class'ActionAPI'.static.RequestActionList();
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnEvent(int Event_ID, String param)
{
	//debug("debug@" @ Event_ID);
	if (Event_ID == EV_ActionListStart)
	{
		//debug("ActionListStart:" );
		HandleActionListStart();
	}
	else if (Event_ID == EV_ActionList)
	{
		//debug("EV_ActionList:" @ param);
		HandleActionList(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		//debug("EV_LanguageChanged:");
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		//debug("EV_ActionListNew");
		HandleActionListNew();
	}
}

//액션의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "ActionBasicItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionBasicItem", index, infItem))
			return;
			
	}
	else if (strID == "ActionPartyItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionPartyItem", index, infItem))
			return;
	}
	else if (strID == "ActionSocialItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionSocialItem", index, infItem))
			return;
	}
	DoAction(infItem.ID);
}

function HideScrollBar()
{
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionBasicItem", false);
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionPartyItem", false);
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionSocialItem", false);
}

function HandleLanguageChanged()
{
	class'ActionAPI'.static.RequestActionList();
}

function HandleActionListStart()
{
	Clear();
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionBasicItem");
	class'UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionPartyItem");
	class'UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionSocialItem");
	//~ class'ActionAPI'.static.RequestActionList();
}

function HandleActionList(string param)
{
	local string WndName;
	
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);

	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//ItemWnd에 추가
	Type = EActionCategory(Tmp);
	if (Type==ACTION_BASIC)
	{
		WndName = "ActionBasicItem";
	}
	else if (Type==ACTION_PARTY)
	{
		WndName = "ActionPartyItem";
	}
	else if (Type==ACTION_SOCIAL)
	{
		WndName = "ActionSocialItem";
	}
	else
	{
		return;
	}
	class'UIAPI_ITEMWINDOW'.static.AddItem("ActionWnd." $ WndName, infItem);
}

function HandleActionListNew()		// Request new data
{
	class'ActionAPI'.static.RequestActionList();
}
defaultproperties
{
}
