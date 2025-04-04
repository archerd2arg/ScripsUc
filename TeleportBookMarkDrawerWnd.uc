class TeleportBookMarkDrawerWnd extends UICommonAPI;
const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_0";

var WindowHandle Me;
var TextBoxHandle txtHead;
var TextBoxHandle txtSaveSlotHead;
var EditBoxHandle EditCurrentSaveBookMarkName;
var TextBoxHandle txtIconName;
var TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
var EditBoxHandle EditCurrentSaveBookMarkIcn;
var TextureHandle TexItemTemplate;
var ButtonHandle btnIconPrev;
var ButtonHandle btnIconNext;
var ButtonHandle btnSave;
var ButtonHandle btnCancel;
var TextBoxHandle txtSaveLocHead;
var TextBoxHandle txtSaveName;
//~ var TextBoxHandle txtSaveLocName;
var TextBoxHandle txtSaveSlotID;
//~ var TextureHandle texMacro;
//~ var TextureHandle macroInfoBg;
//~ var TextureHandle macroTextBg;
var TextureHandle IconBack;
//branch
var TextBoxHandle txtTeleportFlagCount;
var int bUseTeleportFlag;
//end of branch


const BOOKMARKICON_MAX_COUNT = 7;
const BOOKMARK_ICONANME = "L2UI.MacroWnd.Macro_Icon";

var int		m_CurIconNum;

function OnLoad()
{

	if(CREATE_ON_DEMAND==0)
	{
		OnRegisterEvent();
		Initialize();
	}
	else
	{
		InitializeCOD();
	}

	Load();
	m_CurIconNum = 1;

	GetINIBool("Localize", "UseTeleportFlag", bUseTeleportFlag, "L2.ini");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_BeginShowZoneTitleWnd);
}

function Initialize()
{
	Me = GetHandle( "TeleportBookMarkDrawerWnd" );
	txtHead = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtHead" ) );
	txtSaveSlotHead = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtSaveSlotHead" ) );
	EditCurrentSaveBookMarkName = EditBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName" ) );
	txtIconName = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtIconName" ) );
	EditCurrentSaveBookMarkIcn = EditBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn" ) );
	TexItemTemplate = TextureHandle ( GetHandle( "TeleportBookMarkDrawerWnd.TexItemTemplate" ) );
	btnIconPrev = ButtonHandle ( GetHandle( "TeleportBookMarkDrawerWnd.btnIconPrev" ) );
	btnIconNext = ButtonHandle ( GetHandle( "TeleportBookMarkDrawerWnd.btnIconNext" ) );
	btnSave = ButtonHandle ( GetHandle( "TeleportBookMarkDrawerWnd.btnSave" ) );
	btnCancel = ButtonHandle ( GetHandle( "TeleportBookMarkDrawerWnd.btnCancel" ) );
	txtSaveLocHead = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtSaveLocHead" ) );
	txtSaveName = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtSaveName" ) );
	//~ txtSaveLocName = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtSaveLocName" ) );
	txtSaveSlotID = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtSaveSlotID" ) );
	//~ texMacro = TextureHandle ( GetHandle( "TeleportBookMarkDrawerWnd.texMacro" ) );
	//~ macroInfoBg = TextureHandle ( GetHandle( "TeleportBookMarkDrawerWnd.macroInfoBg" ) );
	//~ macroTextBg = TextureHandle ( GetHandle( "TeleportBookMarkDrawerWnd.macroTextBg" ) );
	txtTeleportBookMarkDrawerWndNameHead = TextBoxHandle( GetHandle( "TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead" ) );
	IconBack = TextureHandle ( GetHandle( "TeleportBookMarkDrawerWnd.IconBack" ) );
	//branch
	txtTeleportFlagCount = TextBoxHandle ( GetHandle( "TeleportBookMarkDrawerWnd.txtTeleportFlagCount" ) );
	//end of branch
}
function InitializeCOD()
{
	Me = GetWindowHandle( "TeleportBookMarkDrawerWnd" );
	txtHead = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtHead" );
	txtSaveSlotHead = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtSaveSlotHead" );
	EditCurrentSaveBookMarkName = GetEditBoxHandle ( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName" );
	txtIconName = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtIconName" );
	EditCurrentSaveBookMarkIcn = GetEditBoxHandle ( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn" );
	TexItemTemplate = GetTextureHandle( "TeleportBookMarkDrawerWnd.TexItemTemplate" );
	btnIconPrev = GetButtonHandle( "TeleportBookMarkDrawerWnd.btnIconPrev" );
	btnIconNext = GetButtonHandle( "TeleportBookMarkDrawerWnd.btnIconNext" );
	btnSave = GetButtonHandle( "TeleportBookMarkDrawerWnd.btnSave" );
	btnCancel = GetButtonHandle( "TeleportBookMarkDrawerWnd.btnCancel" );
	txtSaveLocHead = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtSaveLocHead" );
	txtSaveName = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtSaveName" );
	//~ txtSaveLocName = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtSaveLocName" );
	txtSaveSlotID = GetTextBoxHandle( "TeleportBookMarkDrawerWnd.txtSaveSlotID" );
	IconBack = GetTextureHandle( "TeleportBookMarkDrawerWnd.IconBack" );
	//branch
	txtTeleportFlagCount = GetTextBoxHandle ( "TeleportBookMarkDrawerWnd.txtTeleportFlagCount" );
	//end of branch
}
function Load()
{
}

function OnEvent (int EventID, string Param)
{
	switch( EventID)
	{
		// for the case when a PC moves to another zone area while they are opening this window;
		case EV_BeginShowZoneTitleWnd:
			//~ txtSaveLocName.SetText(GetCurrentZoneName());
			break;
	}
}

function OnChangeEditBox( String strID )
{
	switch( strID )
	{
	case "EditCurrentSaveBookMarkIcn":
		UpdateIconName();
		break;
	}
}

function UpdateIconName()
{
	local string strShortName;
	strShortName = EditCurrentSaveBookMarkIcn.GetString();
	txtIconName.SetText(strShortName);
}


function OnShow()
{
	//branch
	local TeleportBookMarkWnd Script;
	//end of branch
	
	UpdateIcon();

	//branch
	Script = TeleportBookMarkWnd(GetScript("TeleportBookMarkWnd"));
	if ( bUseTeleportFlag==0 || IsValidItemID(Script.m_CurBookMarkItemID) )	//EDIT
	{	
		txtTeleportFlagCount.SetText("");
	}
	else {
		txtTeleportFlagCount.SetText(MakeFullSystemMsg(GetSystemMessage(6502), String(GetTeleportFlagCount()), ""));
	}
	//end of branch
}

function UpdateCurrentLocation()
{
	EditCurrentSaveBookMarkName.SetString(GetCurrentZoneName());
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnIconPrev":
		OnbtnIconPrevClick();
		break;
	case "btnIconNext":
		OnbtnIconNextClick();
		break;
	case "btnSave":
		OnbtnSaveClick();
		break;
	case "btnCancel":
		OnbtnCancelClick();
		break;
	}
}

function OnbtnIconPrevClick()
{
	m_CurIconNum--;
	if (m_CurIconNum<1)
		m_CurIconNum = BOOKMARKICON_MAX_COUNT;
	UpdateIcon();
}

function OnbtnIconNextClick()
{
	m_CurIconNum++;
	if (m_CurIconNum > BOOKMARKICON_MAX_COUNT)
		m_CurIconNum = 1;
	UpdateIcon();
}

function OnbtnSaveClick()
{

	local string		slotTitle;
	local int			iconID;
	local string		iconTitle;
	local TeleportBookMarkWnd Script;
	//~ local MinimapCtrlHandle map;
	
	//~ map = MinimapCtrlHandle ( GetHandle( "TeleportBookMarkWnd.Minimap" ) );
	
	Script = TeleportBookMarkWnd(GetScript("TeleportBookMarkWnd"));
	
	
	slotTitle = EditCurrentSaveBookMarkName.GetString();
	iconID = m_CurIconNum;
	iconTitle = EditCurrentSaveBookMarkIcn.GetString();	
	
	iconTitle = left(iconTitle,4);
	
	if (slotTitle != "")
	{
		if ( IsValidItemID(Script.m_CurBookMarkItemID) )	//EDIT
		{
			if ( class'BookMarkAPI'.static.RequestModifyBookMarkSlot(Script.m_CurBookMarkItemID, slotTitle, iconID, iconTitle) )
			{
				Me.HideWindow();
			} 
		}
		else						//새로 추가
		{
			if ( class'BookMarkAPI'.static.RequestSaveBookMarkSlot(slotTitle, iconID, iconTitle) )
			{
				Me.HideWindow();
			}
		}
	}
}

function OnbtnCancelClick()
{
	//~ local MinimapCtrlHandle map;
	//~ map = MinimapCtrlHandle ( GetHandle( "TeleportBookMarkWnd.Minimap" ) );
	Me.HideWindow();
}

function UpdateIcon()
{
	TexItemTemplate.SetTexture( TEMPLATEICONNAME $ m_CurIconNum);
}

function InitializeUI()
{
	EditCurrentSaveBookMarkName.SetString("");;
	EditCurrentSaveBookMarkIcn.SetString("");
	txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1746));
	//~ txtSaveLocName.SetText("");
	txtSaveSlotID.SetText("");
	txtIconName.SetText("");
	UpdateIcon();
}

//~ function SetLocatorOnMiniMap(vector Loc)
//~ {
	//~ local vector loc;
	//~ local string DataforMap;
	//~ ParamAdd(DataforMap, "Index", string(BookMarkID));
	//~ ParamAdd(DataforMap, "WorldX", string(loc.x));
	//~ ParamAdd(DataforMap, "WorldY", string(loc.y));
	//~ ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ch3.mapicon_mark");
	//~ ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ch3.mapicon_mark_light");
	//~ ParamAdd(DataforMap, "BtnTexOver",  "l2ui_ch3.mapicon_mark_light");
	//~ ParamAdd(DataforMap, "BtnWidth", string(24));
	//~ ParamAdd(DataforMap, "BtnHeight", string(24));
	//~ ParamAdd(DataforMap, "Description", "");
	//~ ParamAdd(DataforMap, "DescOffsetX", "-30");
	//~ ParamAdd(DataforMap, "DescOffsetY", "0");
	//~ ParamAdd(DataforMap, "Tooltip", "");
	//~ minimap.AddRegionInfo(DataforMap);	
	//~ Minimap.AdjustMapView(loc);
//~ }
defaultproperties
{
}
