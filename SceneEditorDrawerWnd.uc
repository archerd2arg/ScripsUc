class SceneEditorDrawerWnd extends UICommonAPI;

const SCENE_DATA_CAMERA = 0;
const SCENE_DATA_NPC  = 1;
const SCENE_DATA_PC = 2;
const SCENE_DATA_MUSIC = 3;
const SCENE_DATA_SCREEN = 4;

var WindowHandle				Me;
var TabHandle					SceneDataTab;

var WindowHandle				CAMERA;
var WindowHandle				NPC;
var WindowHandle				PC;
var WindowHandle				MUSIC;
var WindowHandle				SCREEN;
var WindowHandle				CurrentData;

var EditBoxHandle				SceneTime;
var EditBoxHandle				SceneDesc;

var PropertyControllerHandle	ctlPropertyCAMERA;
var PropertyControllerHandle	ctlPropertyNPC;
var PropertyControllerHandle	ctlPropertyPC;
var PropertyControllerHandle	ctlPropertyMUSIC;
var PropertyControllerHandle	ctlPropertySCREEN;

var WindowHandle			SceneCameraWnd;
var WindowHandle			SceneNpcWnd;
var WindowHandle			ScenePcWnd;
var WindowHandle			SceneScreenWnd;
var WindowHandle			SceneMusicWnd;

var SceneCameraCtrlHandle	SceneCameraCtrl;
var SceneNpcCtrlHandle		SceneNpcCtrl;
var ScenePcCtrlHandle		ScenePcCtrl;
var SceneScreenCtrlHandle	SceneScreenCtrl;
var SceneMusicCtrlHandle	SceneMusicCtrl;

var int						m_CurIndex;
var int						m_NumOfScene;

function OnRegisterEvent()
{
	RegisterEvent( EV_SceneDataUpdate );
	RegisterEvent( EV_SceneDataSave );
	RegisterEvent( EV_CurSceneIndexInit );
}

function OnLoad()
{
	if( CREATE_ON_DEMAND == 0 )
		OnRegisterEvent();

	if( CREATE_ON_DEMAND == 0 )
		Initialize();
	else
		InitializeCOD();

	CurrentData = CAMERA;
	m_CurIndex = -1;
	m_NumOfScene = 0;

	InitControlItem();
}

function OnEvent(int Event_ID, String param)
{
	local int Index;
	local int NumOfScene;	

	if( Event_ID == EV_SceneDataUpdate )
	{
		ParseInt(param, "NumOfScene", NumOfScene);
		ParseInt(param, "Index", Index);
		if( Index < 0 )
			return;

		if( m_CurIndex >= 0 && Index != m_CurIndex )
			SceneDataSave();

		m_NumOfScene = NumOfScene;
		m_CurIndex = Index;
		SceneDataUpdate();
	}
	else if( Event_ID == EV_SceneDataSave )
	{
		SceneDataSave();
	}
	else if( Event_ID == EV_CurSceneIndexInit )
	{
		m_CurIndex = -1;
	}
}


function OnCompleteEditBox( String strID )
{
	local string	strParam;
	
	debug("OnCompleteEditBox:" $ strID );
	
	switch( strID )
	{	
	case "txtSceneTime":
	case "txtSceneDesc":	
		if( m_CurIndex >= 0 )
		{
			// update scene data
			SceneDataSave();
			
			ParamAdd(strParam, "NumOfScene", string(m_NumOfScene));
			ParamAdd(strParam, "Index", string(m_CurIndex));
			ExecuteEvent(EV_SceneDataUpdate, strParam);
		}		
		break;
	}
}


function Initialize()
{
	Me		= GetHandle( "SceneEditorDrawerWnd" );
	SceneDataTab = TabHandle( GetHandle("SceneEditorDrawerWnd.SceneDataTab" ));
	
	CAMERA	= GetHandle( "SceneEditorDrawerWnd.CAMERA" );
	NPC		= GetHandle( "SceneEditorDrawerWnd.NPC" );
	PC		= GetHandle( "SceneEditorDrawerWnd.PC" );
	MUSIC	= GetHandle( "SceneEditorDrawerWnd.MUSIC" );
	SCREEN	= GetHandle( "SceneEditorDrawerWnd.SCREEN" );	

	SceneTime = EditBoxHandle(GetHandle("SceneEditorDrawerWnd.txtSceneTime"));
	SceneDesc = EditBoxHandle(GetHandle("SceneEditorDrawerWnd.txtSceneDesc"));

	ctlPropertyCAMERA	= PropertyControllerHandle( GetHandle( "SceneEditorDrawerWnd.ctlPropertyCAMERA" ) );
	ctlPropertyNPC		= PropertyControllerHandle( GetHandle( "SceneEditorDrawerWnd.ctlPropertyNPC" ) );
	ctlPropertyPC		= PropertyControllerHandle( GetHandle( "SceneEditorDrawerWnd.ctlPropertyPC" ) );
	ctlPropertyMUSIC	= PropertyControllerHandle( GetHandle( "SceneEditorDrawerWnd.ctlPropertyMUSIC" ) );
	ctlPropertySCREEN	= PropertyControllerHandle( GetHandle( "SceneEditorDrawerWnd.ctlPropertySCREEN" ) );
}

function InitializeCOD()
{	
	Me		= GetWindowHandle( "SceneEditorDrawerWnd" );
	SceneDataTab = GetTabHandle("SceneEditorDrawerWnd.SceneDataTab" );

	CAMERA	= GetWindowHandle( "SceneEditorDrawerWnd.CAMERA" );
	NPC		= GetWindowHandle( "SceneEditorDrawerWnd.NPC" );
	PC		= GetWindowHandle( "SceneEditorDrawerWnd.PC" );
	MUSIC	= GetWindowHandle( "SceneEditorDrawerWnd.MUSIC" );
	SCREEN	= GetWindowHandle( "SceneEditorDrawerWnd.SCREEN" );

	SceneTime = GetEditBoxHandle( "SceneEditorDrawerWnd.txtSceneTime" );
	SceneDesc = GetEditBoxHandle( "SceneEditorDrawerWnd.txtSceneDesc" );

	ctlPropertyCAMERA	= GetPropertyControllerHandle( "SceneEditorDrawerWnd.ctlPropertyCAMERA" );
	ctlPropertyNPC		= GetPropertyControllerHandle( "SceneEditorDrawerWnd.ctlPropertyNPC" );
	ctlPropertyPC		= GetPropertyControllerHandle( "SceneEditorDrawerWnd.ctlPropertyPC" );
	ctlPropertyMUSIC	= GetPropertyControllerHandle( "SceneEditorDrawerWnd.ctlPropertyMUSIC" );
	ctlPropertySCREEN	= GetPropertyControllerHandle( "SceneEditorDrawerWnd.ctlPropertySCREEN" );
}

function InitControlItem()
{	
	//Set Title
	Me.SetWindowTitle("Scene Data");	
	
	// Camera Ctrl
	SceneCameraWnd = Me.AddChildWnd( XCT_FrameWnd );
	SceneCameraWnd.SetWindowSize( 0, 0 );
	SceneCameraWnd.SetBackTexture("");
	
	SceneCameraCtrl = SceneCameraCtrlHandle(SceneCameraWnd.AddChildWnd( XCT_SceneCameraCtrl ));
	if( SceneCameraCtrl!=None )
	{
		SceneCameraCtrl.SetWindowSize( 0, 0 );

		ctlPropertyCAMERA.SetProperty( SceneCameraCtrl.GetControlType(), SceneCameraCtrl );
		ctlPropertyCAMERA.SetGroupVisible( "DefaultProperty", false );
		CAMERA.SetScrollHeight( ctlPropertyCAMERA.GetPropertyHeight() );
		CAMERA.SetScrollPosition( 0 );
	}

	// Npc Ctrl
	SceneNpcWnd = Me.AddChildWnd( XCT_FrameWnd );
	SceneNpcWnd.SetWindowSize( 0, 0 );
	SceneNpcWnd.SetBackTexture("");
	
	SceneNpcCtrl = SceneNpcCtrlHandle(SceneNpcWnd.AddChildWnd( XCT_SceneNpcCtrl ));
	if( SceneNpcCtrl!=None )
	{
		SceneNpcCtrl.SetWindowSize( 0, 0 );

		ctlPropertyNPC.SetProperty( SceneNpcCtrl.GetControlType(), SceneNpcCtrl );
		ctlPropertyNPC.SetGroupVisible( "DefaultProperty", false );
		NPC.SetScrollHeight( ctlPropertyNPC.GetPropertyHeight() );
		NPC.SetScrollPosition( 0 );
	}
	
	// Pc Ctrl
	ScenePcWnd = Me.AddChildWnd( XCT_FrameWnd );
	ScenePcWnd.SetWindowSize( 0, 0 );
	ScenePcWnd.SetBackTexture("");
	
	ScenePcCtrl = ScenePcCtrlHandle(ScenePcWnd.AddChildWnd( XCT_ScenePcCtrl ));
	if( ScenePcCtrl!=None )
	{
		ScenePcCtrl.SetWindowSize( 0, 0 );

		ctlPropertyPC.SetProperty( ScenePcCtrl.GetControlType(), ScenePcCtrl );
		ctlPropertyPC.SetGroupVisible( "DefaultProperty", false );
		PC.SetScrollHeight( ctlPropertyPC.GetPropertyHeight() );
		PC.SetScrollPosition( 0 );
	}

	// Music Ctrl
	SceneMusicWnd = Me.AddChildWnd( XCT_FrameWnd );
	SceneMusicWnd.SetWindowSize( 0, 0 );
	SceneMusicWnd.SetBackTexture("");
	
	SceneMusicCtrl = SceneMusicCtrlHandle(SceneMusicWnd.AddChildWnd( XCT_SceneMusicCtrl ));
	if( SceneMusicCtrl!=None )
	{
		SceneMusicCtrl.SetWindowSize( 0, 0 );

		ctlPropertyMUSIC.SetProperty( SceneMusicCtrl.GetControlType(), SceneMusicCtrl );
		ctlPropertyMUSIC.SetGroupVisible( "DefaultProperty", false );
		MUSIC.SetScrollHeight( ctlPropertyMUSIC.GetPropertyHeight() );
		MUSIC.SetScrollPosition( 0 );
	}

	// Screen Ctrl
	SceneScreenWnd = Me.AddChildWnd( XCT_FrameWnd );
	SceneScreenWnd.SetWindowSize( 0, 0 );
	SceneScreenWnd.SetBackTexture("");
	
	SceneScreenCtrl = SceneScreenCtrlHandle(SceneScreenWnd.AddChildWnd( XCT_SceneScreenCtrl ));
	if( SceneScreenCtrl!=None )
	{
		SceneScreenCtrl.SetWindowSize( 0, 0 );

		ctlPropertySCREEN.SetProperty( SceneScreenCtrl.GetControlType(), SceneScreenCtrl );
		ctlPropertySCREEN.SetGroupVisible( "DefaultProperty", false );
		SCREEN.SetScrollHeight( ctlPropertySCREEN.GetPropertyHeight() );
		SCREEN.SetScrollPosition( 0 );
	}
}

function OnDefaultPosition()
{
	SceneDataTab.MergeTab(SCENE_DATA_CAMERA);
	SceneDataTab.MergeTab(SCENE_DATA_NPC);
	SceneDataTab.MergeTab(SCENE_DATA_PC);
	SceneDataTab.MergeTab(SCENE_DATA_MUSIC);
	SceneDataTab.MergeTab(SCENE_DATA_SCREEN);
	SceneDataTab.SetTopOrder(0, true);
}

function OnShow()
{
	SceneDataTab.InitTabCtrl();

	CAMERA.HideWindow();
	NPC.HideWindow();
	PC.HideWindow();
	MUSIC.HideWindow();
	SCREEN.HideWindow();
	
	if (CurrentData == CAMERA)
	{
		SceneDataTab.SetTopOrder(0,false);
	}
	else if (CurrentData == NPC)
	{
		SceneDataTab.SetTopOrder(1,false);
	}
	else if (CurrentData == PC)
	{
		SceneDataTab.SetTopOrder(2,false);
	}
	else if (CurrentData == MUSIC)
	{
		SceneDataTab.SetTopOrder(3,false);
	}
	else if (CurrentData == SCREEN)
	{
		SceneDataTab.SetTopOrder(4,false);
	}	

	CurrentData.Setfocus();
}

function OnClickButton( string strID )
{
	switch( strID )
	{	
		case "SceneDataTab0":			
			CurrentData.HideWindow();
			CurrentData = CAMERA;
			CurrentData.ShowWindow();			
			break;
		case "SceneDataTab1":			
			CurrentData.HideWindow();
			CurrentData = NPC;
			CurrentData.ShowWindow();
			break;
		case "SceneDataTab2":			
			CurrentData.HideWindow();
			CurrentData = PC;
			CurrentData.ShowWindow();
			break;
		case "SceneDataTab3":
			CurrentData.HideWindow();
			CurrentData = MUSIC;
			CurrentData.ShowWindow();
			break;
		case "SceneDataTab4":
			CurrentData.HideWindow();
			CurrentData = SCREEN;
			CurrentData.ShowWindow();
			break;		
	}
}


function OnPropertyControllerResize( int Height )
{	
	local int propertyHeight;	

	if (CurrentData == CAMERA)
	{		
		propertyHeight = ctlPropertyCAMERA.GetPropertyHeight();
		if( propertyHeight > Height )
			Height = propertyHeight;

		if( CAMERA != None )
			CAMERA.SetScrollHeight( Height );
	}
	else if (CurrentData == NPC)
	{
		propertyHeight = ctlPropertyNPC.GetPropertyHeight();
		if( propertyHeight > Height )
			Height = propertyHeight;

		if( NPC != None )
			NPC.SetScrollHeight( Height );
	}
	else if (CurrentData == PC)
	{
		propertyHeight = ctlPropertyPC.GetPropertyHeight();
		if( propertyHeight > Height )
			Height = propertyHeight;

		if( PC != None )
			PC.SetScrollHeight( Height );
	}
	else if (CurrentData == MUSIC)
	{
		propertyHeight = ctlPropertyMUSIC.GetPropertyHeight();
		if( propertyHeight > Height )
			Height = propertyHeight;

		if( MUSIC != None )
			MUSIC.SetScrollHeight( Height );
	}
	else if (CurrentData == SCREEN)
	{
		propertyHeight = ctlPropertySCREEN.GetPropertyHeight();
		if( propertyHeight > Height )
			Height = propertyHeight;

		if( SCREEN != None )
			SCREEN.SetScrollHeight( Height );
	}
}


function SceneDataUpdate()
{
	local int Time;
	local string Desc;

	class'SceneEditorAPI'.static.GetCurSceneTimeAndDesc(m_CurIndex, Time, Desc);
	SceneTime.SetString( string(Time) );
	SceneDesc.SetString( Desc );
	
	//Set Title
	Me.SetWindowTitle("Scene " $ m_CurIndex $ " Data Info");
	
	// Camera Ctrl
	if( SceneCameraCtrl != None )
	{
		SceneCameraCtrl.UpdateCameraData(m_CurIndex);

		ctlPropertyCAMERA.SetProperty( SceneCameraCtrl.GetControlType(), SceneCameraCtrl );
		ctlPropertyCAMERA.SetGroupVisible( "DefaultProperty", false );
		CAMERA.SetScrollHeight( ctlPropertyCAMERA.GetPropertyHeight() );
		CAMERA.SetScrollPosition( 0 );
	}

	// Npc Ctrl
	if( SceneNpcCtrl != None )
	{
		SceneNpcCtrl.UpdateNpcData(m_CurIndex);

		ctlPropertyNPC.SetProperty( SceneNpcCtrl.GetControlType(), SceneNpcCtrl );
		ctlPropertyNPC.SetGroupVisible( "DefaultProperty", false );
		NPC.SetScrollHeight( ctlPropertyNPC.GetPropertyHeight() );
		NPC.SetScrollPosition( 0 );
	}
	
	// Pc Ctrl
	if( ScenePcCtrl != None )
	{
		ScenePcCtrl.UpdatePcData(m_CurIndex);

		ctlPropertyPC.SetProperty( ScenePcCtrl.GetControlType(), ScenePcCtrl );
		ctlPropertyPC.SetGroupVisible( "DefaultProperty", false );
		PC.SetScrollHeight( ctlPropertyPC.GetPropertyHeight() );
		PC.SetScrollPosition( 0 );
	}

	// Music Ctrl
	if( SceneMusicCtrl != None )
	{
		SceneMusicCtrl.UpdateMusicData(m_CurIndex);

		ctlPropertyMUSIC.SetProperty( SceneMusicCtrl.GetControlType(), SceneMusicCtrl );
		ctlPropertyMUSIC.SetGroupVisible( "DefaultProperty", false );
		MUSIC.SetScrollHeight( ctlPropertyMUSIC.GetPropertyHeight() );
		MUSIC.SetScrollPosition( 0 );
	}

	// Screen Ctrl		
	if( SceneScreenCtrl!=None )
	{
		SceneScreenCtrl.UpdateScreenData(m_CurIndex);

		ctlPropertySCREEN.SetProperty( SceneScreenCtrl.GetControlType(), SceneScreenCtrl );
		ctlPropertySCREEN.SetGroupVisible( "DefaultProperty", false );
		SCREEN.SetScrollHeight( ctlPropertySCREEN.GetPropertyHeight() );
		SCREEN.SetScrollPosition( 0 );
	}
}

function SceneDataSave()
{
	local int Time, OldTime,DeltaTime;
	local string Desc;

	if( m_CurIndex < 0 )
		return;
		
	// get delta time
	class'SceneEditorAPI'.static.GetCurSceneTimeAndDesc(m_CurIndex, OldTime, Desc);

	//
	Desc = SceneTime.GetString();
	Time = int(Desc);
	Desc = SceneDesc.GetString();
	class'SceneEditorAPI'.static.SaveCurSceneTimeAndDesc(m_CurIndex, Time, Desc);
		
	// all scene time update
	DeltaTime = (Time -  OldTime);
	AllSceneTimeUpdate(DeltaTime);

	// Camera Ctrl
	if( SceneCameraCtrl != None )
		SceneCameraCtrl.SaveCameraData(m_CurIndex);

	// Npc Ctrl
	if( SceneNpcCtrl != None )
		SceneNpcCtrl.SaveNpcData(m_CurIndex);
		
	// Pc Ctrl
	if( ScenePcCtrl != None )
		ScenePcCtrl.SavePcData(m_CurIndex);

	// Music Ctrl
	if( SceneMusicCtrl != None )
		SceneMusicCtrl.SaveMusicData(m_CurIndex);

	// Screen Ctrl		
	if( SceneScreenCtrl!=None )
		SceneScreenCtrl.SaveScreenData(m_CurIndex);
}

// 
// 
function AllSceneTimeUpdate( int DeltaTime )
{
	local int Time;
	local string Desc;
	local int index;
	
	//	
	for(index = m_CurIndex+1; index<m_NumOfScene; ++index)
	{
		class'SceneEditorAPI'.static.GetCurSceneTimeAndDesc(index, Time, Desc);		
		Time += DeltaTime;		
		class'SceneEditorAPI'.static.SaveCurSceneTimeAndDesc(index, Time, Desc);		
	}
}
defaultproperties
{
}
