class MacroListWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;

var bool	m_bShow;
var ItemID	m_DeleteItemID;
var int	m_Max;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	
	RegisterEvent(EV_MacroShowListWnd);
	RegisterEvent(EV_MacroUpdate);
	RegisterEvent(EV_MacroList);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_bShow = false;
	ClearItemID(m_DeleteItemID);
}

function OnEnterState( name a_PreStateName )
{
	class'MacroAPI'.static.RequestMacroList();
}

function OnShow()
{
	m_bShow = true;
}
	
function OnHide()
{
	m_bShow = false;
}

function OnClickButton( string strID )
{	
	switch( strID )
	{
	case "btnHelp":
		OnClickHelp();
		break;
	case "btnAdd":
		OnClickAdd();
		break;
	}
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_MacroShowListWnd)
	{
		HandleMacroShowListWnd();
	}
	else if (Event_ID == EV_MacroUpdate)
	{
		HandleMacroUpdate();
	}
	else if (Event_ID == EV_MacroList)
	{
		HandleMacroList(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			if (IsValidItemID(m_DeleteItemID))
			{
				class'MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
				//debug("what?");
				ClearItemID(m_DeleteItemID);
				if(m_Max == 1)	//�ϳ����� ���� ���� ��� 0�� �ǹǷ� �ѹ� �������ش�. 
				{
					HandleMacroList("");// â�� �ѹ� �������ش�. //0�ϰ�쿡�� �������ָ� ��.
				}
			}
			
		}
	}
}

//��ũ���� Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "MacroItem" && index>-1)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", index, infItem))
			class'MacroAPI'.static.RequestUseMacro(infItem.ID);
	}
}

//����
function OnClickHelp()
{
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help_macro.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

//�߰�
function OnClickAdd()
{
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", "");
	ExecuteEvent(EV_MacroShowEditWnd, "");
}

function HandleMacroUpdate()
{
	class'MacroAPI'.static.RequestMacroList();
}

function HandleMacroShowListWnd()
{
	if (m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroListWnd");
	}
	else
	{
		
		PlayConsoleSound(IFST_WINDOW_OPEN);	
		class'UIAPI_WINDOW'.static.ShowWindow("MacroListWnd");
		class'UIAPI_WINDOW'.static.SetFocus("MacroListWnd");
	}
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
}

function HandleMacroList(string param)
{
	local int Idx;
	local int Max;
	

	
	
	local string strIconName;
	local string strMacroName;
	local string strDescription;
	local string strTexture;
	local string strTmp;
	
	local ItemInfo	infItem;
		//debug ("�Ķ�:"@ param);
	//�ʱ�ȭ
	Clear();
	
	ParseInt(param, "Max", Max);
	m_Max = Max;	//�۷ι� �ƽ��� ���� -_-;;
	for (Idx=0; Idx<Max; Idx++)
	{
		strIconName = "";
		strMacroName = "";
		strDescription = "";
		strTexture = "";
		
		ParseItemIDWithIndex(param, infItem.ID, idx);
		ParseString(param, "IconName_" $ Idx, strIconName);
		ParseString(param, "MacroName_" $ Idx, strMacroName);
		ParseString(param, "Description_" $ Idx, strDescription);
		ParseString(param, "TextureName_" $ Idx, strTexture);
	
		infItem.Name = strMacroName;
		infItem.AdditionalName = strIconName;
		infItem.IconName = strTexture;
		infItem.Description = strDescription;
		infItem.ItemSubType = int(EShortCutItemType.SCIT_MACRO);
		
		//MacroItem�� �߰�
		class'UIAPI_ITEMWINDOW'.static.AddItem("MacroListWnd.MacroItem", infItem);
	}
	
	//��ũ�� ����ǥ��
	if (Max<10)
	{
		strTmp = strTmp $ "0";
	}
	strTmp = strTmp $ Max;
	strTmp = "(" $ strTmp $ "/" $ MACRO_MAX_COUNT $ ")";
	class'UIAPI_TEXTBOX'.static.SetText("MacroListWnd.txtCount", strTmp);
}

//Trash������������ DropITem
function OnDropItem( string strID, ItemInfo infItem, int x, int y)
{
	switch( strID )
	{
	case "btnTrash":
		DeleteMacro(infItem);
		break;
	case "btnEdit":
		EditMacro(infItem);
		break;
	}
}

//��ũ�� ����
function DeleteMacro(ItemInfo infItem)
{
	local string strMsg;
	
	//��ũ�ΰ� �ƴϸ� �н�
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))		
		return;			
	
	strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
	m_DeleteItemID = infItem.ID;
	DialogShow(DIALOG_Modalless,DIALOG_Warning, strMsg);
}

//��ũ�� ����
function EditMacro(ItemInfo infItem)
{
	local string param;
	
	//��ũ�ΰ� �ƴϸ� �н�
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))
		return;
	
	ParamAddItemID(param, infItem.ID);
	ExecuteEvent(EV_MacroShowEditWnd, param);
}
defaultproperties
{
}
