class SceneEditorWnd extends UICommonAPI;

const UC_EXT = ".uc";
const PREV_DIR = "..";

var WindowHandle Me;
var WindowHandle Drawer;
var WindowHandle wndFileManager;

var ListBoxHandle lstDirs;
var ListBoxHandle lstFiles;
var EditBoxHandle txtPath;
var ButtonHandle btnNew;
var ButtonHandle btnLoad;
var ButtonHandle btnSave;
var ButtonHandle btnAdd;
var ButtonHandle btnDelete;
var ButtonHandle btnCopy;

var EditBoxHandle txtPlaySceneNo;
var EditBoxHandle txtAddSceneNo;
var EditBoxHandle txtDeleteSceneNo;
var EditBoxHandle txtSrcSceneNo;
var EditBoxHandle txtDestSceneNo;

var TreeHandle		SceneTree;
var CheckBoxHandle	ForcePlayCheckBox;

var string	m_CurPath;
var int		m_CurIndex;
var int		m_NumOfScene;

var	string	m_CurFileName;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_SceneListUpdate );
	RegisterEvent( EV_UpdateSceneTreeData );
}

function OnLoad()
{
	if( CREATE_ON_DEMAND == 0 )
		OnRegisterEvent();

	if( CREATE_ON_DEMAND == 0 )
		Initialize();
	else
		InitializeCOD();

	Load();
}

function Initialize()
{
	Me = GetHandle( "SceneEditorWnd" );
	Drawer = GetHandle( "SceneEditorDrawerWnd" );

	wndFileManager = GetHandle( "SceneEditorWnd.wndFileManager" );
	lstDirs = ListBoxHandle ( GetHandle( "SceneEditorWnd.wndFileManager.lstDirs" ) );
	lstFiles = ListBoxHandle ( GetHandle( "SceneEditorWnd.wndFileManager.lstFiles" ) );
	txtPath = EditBoxHandle ( GetHandle( "SceneEditorWnd.wndFileManager.txtPath" ) );

	btnNew = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnNew" ) );
	btnLoad = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnLoad" ) );
	btnSave = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnSave" ) );
	btnAdd = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnAdd" ) );
	btnDelete = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnDelete" ) );
	btnCopy = ButtonHandle ( GetHandle( "SceneEditorWnd.wndFileManager.btnCopy" ) );

	txtPlaySceneNo = EditBoxHandle ( GetHandle( "SceneEditorWnd.txtEnd" ) );
	txtAddSceneNo = EditBoxHandle ( GetHandle( "SceneEditorWnd.txtAddNo" ) );
	txtDeleteSceneNo = EditBoxHandle ( GetHandle( "SceneEditorWnd.txtDelNo" ) );
	txtSrcSceneNo = EditBoxHandle ( GetHandle( "SceneEditorWnd.txtSrcNo" ) );
	txtDestSceneNo = EditBoxHandle ( GetHandle( "SceneEditorWnd.txtDestNo" ) );

	SceneTree = TreeHandle ( GetHandle("SceneEditorWnd.SceneTree" ) );
}

function InitializeCOD()
{
	Me = GetWindowHandle( "SceneEditorWnd" );
	Drawer = GetWindowHandle( "SceneEditorDrawerWnd" );

	wndFileManager = GetWindowHandle( "SceneEditorWnd.wndFileManager" );
	lstDirs = GetListBoxHandle( "SceneEditorWnd.wndFileManager.lstDirs" );
	lstFiles = GetListBoxHandle( "SceneEditorWnd.wndFileManager.lstFiles" );
	txtPath = GetEditBoxHandle( "SceneEditorWnd.wndFileManager.txtPath" );

	btnNew = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnNew" );
	btnLoad = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnLoad" );	
	btnSave = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnSave" );
	btnAdd = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnAdd" );	
	btnDelete = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnDelete" );
	btnCopy = GetButtonHandle( "SceneEditorWnd.wndFileManager.btnCopy" );

	txtPlaySceneNo = GetEditBoxHandle( "SceneEditorWnd.txtEnd" );
	txtAddSceneNo = GetEditBoxHandle( "SceneEditorWnd.txtAddNo" );
	txtDeleteSceneNo = GetEditBoxHandle( "SceneEditorWnd.txtDelNo" );
	txtSrcSceneNo = GetEditBoxHandle( "SceneEditorWnd.txtSrcNo" );
	txtDestSceneNo = GetEditBoxHandle( "SceneEditorWnd.txtDestNo" );

	SceneTree = GetTreeHandle ( "SceneEditorWnd.SceneTree" );
	ForcePlayCheckBox = GetCheckBoxHandle("SceneEditorWnd.PlayModeBox");
}

function Load()
{
	m_NumOfScene = 0;
	m_CurIndex = -1;

	InitControlItem();
	Update();	
}

function OnEvent(int Event_ID, String param)
{
	local string FileName;
	local int Index;
	local int Time;
	local string Desc;	
	local bool bForceToPlay;

	if( Event_ID == EV_SceneListUpdate )
		HandleSceneListUpdate(param);
	else if ( Event_ID == EV_DialogOK )
	{
		if (DialogIsMine())
		{
			if( DialogGetID() == 2002 )
			{
				FileName = DialogGetString();
				if( Len(FileName) < 1 )
					return;
				bForceToPlay = class'UIAPI_CHECKBOX'.static.IsChecked( "SceneEditorWnd.PlayModeBox" );
					
				class'SceneEditorAPI'.static.SaveSceneData(FileName, m_CurPath, bForceToPlay);
				
				m_CurFileName = FileName;
			}
			else if( DialogGetID() == 1001 )
			{
				FileName = DialogGetString();
				if( Len(FileName) < 1 )
					return;
					
				class'SceneEditorAPI'.static.InitSceneEditorData();
				SceneTree.Clear();
					
				class'SceneEditorAPI'.static.LoadSceneData(FileName);
				ExecuteEvent(EV_CurSceneIndexInit);
				
				m_CurFileName = FileName;
			}
		}
	}
	else if( Event_ID == EV_UpdateSceneTreeData )
	{
		ParseInt(param, "Index", Index);
		ParseInt(param, "Time", Time);
		ParseString(param, "Desc", Desc);

		FileName = "root.SceneList.Scene" $ Index $ ".Scene info";
		SceneTree.SetNodeItemText(FileName, 1, "Time : " $ string(Time));
		SceneTree.SetNodeItemText(FileName, 2, "Desc : " $ Desc);
	}
}

function OnClickButton( string Name )
{
	local string	strParam;
	local string	NodeName;
	local int		Index;

	switch( Name )
	{
	case "btnNew":
		OnbtnNewClick();
		break;
	case "btnLoad":
		OnbtnLoadClick();
		break;
	case "btnSave":
		OnbtnSaveClick();
		break;
	case "btnPlay":
		OnbtnPlayClick();
		break;
	case "btnAdd":
		OnbtnAddClick();
		break;
	case "btnDelete":
		OnbtnDeleteClick();
		break;
	case "btnCopy":
		OnbtnCopyClick();
		break;
	}
	
	if( Left(Name, 20) == "root.SceneList.Scene" )
	{
		Index = int(Mid(Name,20));
		NodeName = "root.SceneList.Scene" $ Index;
		
		if( SceneTree.IsExpandedNode(NodeName) )
		{	
			m_CurIndex = Index;	
				
			ParamAdd(strParam, "NumOfScene", string(m_NumOfScene));
			ParamAdd(strParam, "Index", string(m_CurIndex));
			ExecuteEvent(EV_SceneDataUpdate, strParam);
			
			NodeName = "Scene " $ m_CurIndex $ " Data";
			Drawer.SetWindowTitle(NodeName);
			
			Drawer.ShowWindow();
		}
		else
		{
			if(m_CurIndex == Index)
			{
				m_CurIndex = -1;
				if( Drawer.IsShowWindow() )
				{
					Drawer.HideWindow();
				}
			}
		}	
		
	}
	else if( Left(Name, 14) == "root.SceneList" )
	{
		Drawer.HideWindow();
	}
}

function InitControlItem()
{
	// Set Title
	Me.SetWindowTitle("Scene Editor");

	// Interface Path
	m_CurPath = GetOptionString( "ScenePlayer", "DefaultPath" );
	if( Len(m_CurPath) < 1 )
		m_CurPath = GetInterfaceDir() $ "\\Default\\";
	txtPath.SetString( m_CurPath );
}

function OnbtnNewClick()
{
	Drawer.HideWindow();

	class'SceneEditorAPI'.static.InitSceneEditorData();
	SceneTree.Clear();

	class'SceneEditorAPI'.static.AddScene(-1);
	ExecuteEvent(EV_CurSceneIndexInit);
	
	// clear file name
	m_CurFileName = "";
}

function OnbtnLoadClick()
{
	local string FileName;	
	FileName = lstFiles.GetSelectedString();
	FileName = Left(FileName, Len(FileName)-3);

	Drawer.HideWindow();	
	DialogSetEditBoxMaxLength(100);
	DialogSetID(1001);
	DialogSetDefaultOK();	
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, "Input Scene Name.");
	DialogSetString( FileName );
}

function OnbtnSaveClick()
{
	local string FileName;
	FileName = m_CurFileName;
	
	ExecuteEvent(EV_SceneDataSave);
	
	DialogSetEditBoxMaxLength(100);
	DialogSetID(2002);
	DialogSetDefaultOK();	
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, "Input Scene Name.");
	DialogSetString( FileName );
}

function OnbtnPlayClick()
{
	local String Tmp;
	local int EndNo;
	local bool bShowInfo;
	
	ExecuteEvent(EV_SceneDataSave);
	
	Tmp = txtPlaySceneNo.GetString();
	if( Len(Tmp) > 0 )
		EndNo = int( Tmp );
	else
		EndNo = -1;

	if( EndNo < 0 )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Set SceneNo Failed!");
		return;
	}

	bShowInfo = class'UIAPI_CHECKBOX'.static.IsChecked( "SceneEditorWnd.InfoBox" );
	class'SceneEditorAPI'.static.PlayScene( EndNo, bShowInfo );
}

function OnbtnAddClick()
{
	local String Tmp;
	local int Index;

	ExecuteEvent(EV_SceneDataSave);
	ExecuteEvent(EV_CurSceneIndexInit);

	Drawer.HideWindow();
	
	Tmp = txtAddSceneNo.GetString();
	if( Len(Tmp) > 0 )
		Index = int( Tmp );
	else
		Index = -1;
	
	class'SceneEditorAPI'.static.AddScene(Index);
}

function OnbtnDeleteClick()
{
	local String Tmp;
	local int Index;

	ExecuteEvent(EV_SceneDataSave);
	ExecuteEvent(EV_CurSceneIndexInit);

	Drawer.HideWindow();
	
	Tmp = txtDeleteSceneNo.GetString();
	if( Len(Tmp) > 0 )
		Index = int( Tmp );
	else
		return;
	
	class'SceneEditorAPI'.static.DeleteScene(Index);
}

function OnBtnCopyClick()
{
	local String Tmp;
	local int SrcIndex;
	local int DestIndex;

	ExecuteEvent(EV_SceneDataSave);
	ExecuteEvent(EV_CurSceneIndexInit);

	Drawer.HideWindow();

	Tmp = txtSrcSceneNo.GetString();
	if( Len(Tmp) > 0 )
		SrcIndex = int( Tmp );
	else
		return;

	Tmp = "";
	Tmp = txtDestSceneNo.GetString();
	if( Len(Tmp) > 0 )
		DestIndex = int( Tmp );
	else
		return;
	
	class'SceneEditorAPI'.static.CopyScene(SrcIndex, DestIndex);
}

function Update()
{
	if( Right( m_CurPath, 1 ) != "\\" )
		m_CurPath = m_CurPath $ "\\";
	
	SetOptionString( "ScenePlayer", "DefaultPath", m_CurPath );
	txtPath.SetString( m_CurPath );
	UpdateDirectory();
	UpdateFileList();
}

function UpdateDirectory()
{
	local Array<string> DirList;
	local int idx;
	
	lstDirs.Clear();
	lstFiles.Clear();
	
	GetDirList( DirList, m_CurPath );
	
	lstDirs.AddString( PREV_DIR );
	for( idx=0; idx<DirList.Length; idx++ )
		lstDirs.AddString( DirList[idx] );
}

function UpdateFileList()
{
	local Array<string> FileList;
	local int idx;
	
	lstFiles.Clear();
	
	GetFileList( FileList, m_CurPath, UC_EXT );
	
	for( idx=0; idx<FileList.Length; idx++ )
	{
		lstFiles.AddString( FileList[idx] );
	}
}

function OnDBClickListBoxItem( String strID, int SelectedIndex )
{
	local string DirName;
	
	switch( strID )
	{
	case "lstDirs":
		// update directory list
		DirName = lstDirs.GetSelectedString();
			
		if( DirName == PREV_DIR )
			m_CurPath = GetParentDirectory( m_CurPath );
		else
			m_CurPath = m_CurPath $ DirName;
		
		Update();
		break;
		
	case "lstFiles":
		// open load dialog
		OnbtnLoadClick();
		break;
	}
}

function string GetParentDirectory( String Path )
{
	local array<String> DirList;
	local int Count;
	local int idx;
	local string NewPath;
	
	if( Len(Path) < 1 )
		return NewPath;
		
	if( Right( Path, 1 ) == "\\" )
		Path = Left( Path, Len(Path) - 1 );
	
	Count = Split( Path, "\\", DirList );
	
	if( Count == 1 )
		return Path;
	
	for( idx=0; idx<Count-1; idx++ )
		NewPath = NewPath $ DirList[idx] $ "\\";
	
	return NewPath;
}

function HandleSceneListUpdate( String param )
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		strRetName;
	local string		strRetNodeName;

	local int TotalCount;	
	local int Time;
	local string Desc;
	local string ParamString;

	local int i;
	local int ForceToPlay;
	ParseInt( param, "IsForceToPlay", ForceToPlay);
	if ( ForceToPlay > 0 )
		ForcePlayCheckBox.SetCheck(true);
	else
		ForcePlayCheckBox.SetCheck(false);

	ParseInt( Param, "TotalCount", TotalCount );
	if( TotalCount < 1 )
		return;
	
	//	
	m_NumOfScene = TotalCount;

	// Clear
	SceneTree.Clear();
		
	// Add Root Item
	infNode.strName = "root";
	infNode.nOffSetX = 3;
	infNode.nOffSetY = 5;
	strRetName = SceneTree.InsertNode("", infNode);
	
	if( Len(strRetName) < 1 )
		return;
	
	// Insert Node - with Button
	infNode = infNodeClear;
	infNode.strName = "SceneList" ;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = 14;
	infNode.nTexBtnHeight = 14;
	infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndDownBtn";
	infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndUpBtn";
	infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndDownBtn_over";
	infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndUpBtn_over";
	
	infNode.nTexExpandedOffSetY = 1;
	infNode.nTexExpandedHeight = 13;
	infNode.nTexExpandedRightWidth = 32;
	infNode.nTexExpandedLeftUWidth = 16;
	infNode.nTexExpandedLeftUHeight = 13;
	infNode.nTexExpandedRightUWidth = 32;
	infNode.nTexExpandedRightUHeight = 13;
	infNode.strTexExpandedLeft = "L2UI_CH3.ListCtrl.TextSelect";
	infNode.strTexExpandedRight = "L2UI_CH3.ListCtrl.TextSelect2";
	
	strRetName = SceneTree.InsertNode("root", infNode);
	if (Len(strRetName) < 1)
		return;	

	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = "SceneListData";	
	infNodeItem.nOffSetX = 4;
	infNodeItem.nOffSetY = 2;
	SceneTree.InsertNodeItem(strRetName, infNodeItem);

	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 8;
	SceneTree.InsertNodeItem(strRetName, infNodeItem);

	// Scene List Node
	for( i=0; i< TotalCount; i++ )
	{
		Time = 0;
		ParamString = "Time" $ String(i);
		ParseInt(Param, ParamString, Time);

		Desc = "";
		ParamString = "Desc" $ String(i);
		ParseString(Param, ParamString, Desc);

		// 1. Insert Scene List Node
		infNode = infNodeClear;
		infNode.strName = "Scene" $ String(i);
		infNode.nOffSetX = 7;
		infNode.nOffSetY = 0;
		infNode.bShowButton = 1;
		infNode.nTexBtnWidth = 14;
		infNode.nTexBtnHeight = 14;
		infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
		infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
		infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
		infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";	
		strRetNodeName = SceneTree.InsertNode(strRetName, infNode);
		if (Len(strRetName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		
		// Scene List Node Item - Scene Number
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "Scene " $ String(i);
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 2;
		infNodeItem.t_color.R = 192;
		infNodeItem.t_color.G = 192;
		infNodeItem.t_color.B = 192;
		infNodeItem.t_color.A = 255;
		SceneTree.InsertNodeItem(strRetNodeName, infNodeItem);
		
		// Scene List Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.b_nHeight = 8;
		SceneTree.InsertNodeItem(strRetNodeName, infNodeItem);

		// 2. Insert Scene Info Node
		infNode = infNodeClear;
		infNode.strName = "Scene info";
		infNode.nOffSetX = 10;
		infNode.nOffSetY = 0;
		infNode.bShowButton = 0;
		infNode.bDrawBackground = 1;
		infNode.bTexBackHighlight = 1;
		infNode.nTexBackHighlightHeight = 16;
		infNode.nTexBackWidth = 285;
		infNode.nTexBackUWidth = 211;
		infNode.nTexBackOffSetX = 0;
		infNode.nTexBackOffSetY = -3;
		infNode.nTexBackOffSetBottom = -2;
		strRetNodeName = SceneTree.InsertNode(strRetNodeName, infNode);
		if( Len(strRetName) < 1 )
			return;
		
		// Scene Info Node Item - Time
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "Time : " $ Time;
		infNodeItem.t_nTextID = 1;
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 0;
		infNodeItem.t_color.R = 192;
		infNodeItem.t_color.G = 192;
		infNodeItem.t_color.B = 192;
		infNodeItem.t_color.A = 255;
		SceneTree.InsertNodeItem(strRetNodeName, infNodeItem);
		
		// Scene Info Node Item - Desc
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "Desc : " $ Desc;
		infNodeItem.t_nTextID = 2;
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 4;
		infNodeItem.t_color.R = 192;
		infNodeItem.t_color.G = 192;
		infNodeItem.t_color.B = 192;
		infNodeItem.t_color.A = 255;
		SceneTree.InsertNodeItem(strRetNodeName, infNodeItem);

		// Scene Info Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.b_nHeight = 8;
		SceneTree.InsertNodeItem(strRetNodeName, infNodeItem);
	}
}

defaultproperties
{
}
