class UIEditor_FileManager extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";

var WindowHandle	Me;

var ListBoxHandle	lstDirs;
var ListBoxHandle	lstFiles;
var ButtonHandle	btnLoad;
var ButtonHandle	btnSave;
var ButtonHandle	btnMakeUC;
var ButtonHandle    exitButton;

var EditBoxHandle	txtPath;

var WindowHandle WorkSheet;

var string m_CurPath;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	//Init Handle
	InitHandle();
	
	//Init Control Item
	InitControlItem();
	
	Update();
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
	
	GetFileList( FileList, m_CurPath, XML_EXT );
	
	for( idx=0; idx<FileList.Length; idx++ )
		lstFiles.AddString( FileList[idx] );
}

function InitHandle()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "UIEditor_FileManager" );
		
		lstDirs = ListBoxHandle( GetHandle( "UIEditor_FileManager.lstDirs" ) );
		lstFiles = ListBoxHandle( GetHandle( "UIEditor_FileManager.lstFiles" ) );
		btnLoad = ButtonHandle( GetHandle( "UIEditor_FileManager.btnLoad" ) );
		btnSave = ButtonHandle( GetHandle( "UIEditor_FileManager.btnSave" ) );
		btnMakeUC = ButtonHandle( GetHandle( "UIEditor_FileManager.btnMakeUC" ) );
		txtPath = EditBoxHandle ( GetHandle( "UIEditor_FileManager.txtPath" ) );

		exitButton = ButtonHandle( GetHandle( "UIEditor_FileManager.exitButton" ) );

		WorkSheet = GetHandle( "Worksheet" );
	}
	else
	{
		Me = GetWindowHandle( "UIEditor_FileManager" );
		
		lstDirs = GetListBoxHandle(  "UIEditor_FileManager.lstDirs" );
		lstFiles = GetListBoxHandle(  "UIEditor_FileManager.lstFiles" );
		btnLoad = GetButtonHandle(  "UIEditor_FileManager.btnLoad" );
		btnSave = GetButtonHandle(  "UIEditor_FileManager.btnSave" );
		btnMakeUC = GetButtonHandle(  "UIEditor_FileManager.btnMakeUC" );
		txtPath = GetEditBoxHandle (  "UIEditor_FileManager.txtPath" );
		WorkSheet = GetWindowHandle( "Worksheet" );
	}

}

function InitControlItem()
{
	//Set Title
	Me.SetWindowTitle("UIEditor - FileManager");
	
	//Interface Path
	m_CurPath = GetOptionString( "UIEditor", "SysPath" );
	if( Len(m_CurPath) < 1 )
		m_CurPath = GetInterfaceDir() $ "\\Default\\";
	txtPath.SetString( m_CurPath );
}

function OnEvent(int Event_ID, string param)
{
	local string FileName;
	
	if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			if( DialogGetID() == 98 )
			{
				FileName = DialogGetString();
				if( Len(FileName) < 1 )
					return;
					
				MakeUC( FileName );
			}	
			else if( DialogGetID() == 99 )
			{
				FileName = DialogGetString();
				if( Len(FileName) < 1 )
					return;
					
				SaveXMLFile( FileName );
			}			
		}
	}
}

function OnDBClickListBoxItem( String strID, int SelectedIndex)
{
	local string DirName;
	
	if( strID != "lstDirs" )
		return;
		
	DirName = lstDirs.GetSelectedString();
		
	if( DirName == PREV_DIR )
		m_CurPath = GetParentDirectory( m_CurPath );
	else
		m_CurPath = m_CurPath $ DirName;
		
	Update();
}

function Update()
{
	if( Right( m_CurPath, 1 ) != "\\" )
		m_CurPath = m_CurPath $ "\\";
	
	SetOptionString( "UIEditor", "SysPath", m_CurPath );
	txtPath.SetString( m_CurPath );
	UpdateDirectory();
	UpdateFileList();
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

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnLoad":
		OnLoadClick();
		break;
	case "btnSave":
		OnSaveClick();
		break;
	case "btnMakeUC":
		OnMakeClick();
		break;

	case "exitButton" :
		ExecuteCommand( "///setstate gamingstate" );
	}
}

function OnCompleteEditBox( string strID )
{
	switch( strID )
	{
	case "txtPath":
		m_CurPath = txtPath.GetString();
		Update();
		break;
	}
}

function OnLoadClick()
{
	local WindowHandle NewControl;
	local string FileName;
	local string FullName;
	
	if( WorkSheet == None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Can't Find Worksheet.");
		return;
	}
	
	FileName = lstFiles.GetSelectedString();
	if( Len(FileName) < 1 )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Please Select XML File.");
		return;
	}
	FullName = m_CurPath $ FileName;
	
	NewControl = WorkSheet.LoadXMLWindow( FullName );
	if( NewControl == None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Load XML Window Failed!");
		return;
	}
	
	NewControl.SetScript( "UIEditor_Worksheet" );
	NewControl.ConvertToEditable();
	NewControl.SetFocus();
}

function OnSaveClick()
{
	local string FileName;
	
	FileName = lstFiles.GetSelectedString();
	
	DialogSetEditBoxMaxLength(100);
	DialogSetID(99);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, "Input File Name.");
	DialogSetString( FileName );
}

function OnMakeClick()
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local string ScriptName;
	local string FileName;
	
	//Find SciptName
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Select Target Window to save.");
		return;
	}
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Target Window Have No XML Infomation.");
		return;
	}
	ScriptName = TopWnd.GetScriptName();
	if( Len(ScriptName) < 1 )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Target Window Have No Script Name.");
		return;
	}
	
	FileName = ScriptName $ UC_EXT;
	DialogSetEditBoxMaxLength(100);
	DialogSetID(98);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, "Input Script File Name.");
	DialogSetString( FileName );
}

function SaveXMLFile( string FileName )
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local string FullName;
	
	if( Len(FileName) < 1 )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Please Input Save File Name!");
		return;
	}
	
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Select Target Window to save.");
		return;
	}
	
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Target Window Have No XML Infomation.");
		return;
	}
	
	FullName = m_CurPath $ FileName;
	
	if( TopWnd.SaveXMLWindow( FullName ) )
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Save Complete. (" $ FullName $ ")" );
	else
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Save Failed. OTL" );
		
	Update();
}

function MakeUC( string FileName )
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local array<String> NameList;
	local int Idx;
	local int Count;
	
	local string UCName;
	local string FullName;
	
	if( Len(FileName) < 1 )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Please Input Save File Name!");
		return;
	}
	
	Count = Split( FileName, ".", NameList );
	if( ( "." $ NameList[Count-1] ) != UC_EXT )
		FileName = FileName $ UC_EXT;
	
	Count = Split( FileName, ".", NameList );
	for( idx=0; idx<Count-1; idx++ )
	{
		if( Idx > 0 )
			UCName = UCName $ ".";
		UCName = UCName $ NameList[Idx];
	}
	
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Select Target Window to save.");
		return;
	}
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Target Window Have No XML Infomation.");
		return;
	}
	
	FullName = m_CurPath $ FileName;
	
	if( TopWnd.MakeBaseUC( UCName, FullName ) )
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Save Complete. (" $ FullName $ ")" );
	else
		DialogShow(DIALOG_Modalless, DIALOG_OK, "Save Failed. OTL" );
}
defaultproperties
{
}
