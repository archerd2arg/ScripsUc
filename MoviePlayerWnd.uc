class MoviePlayerWnd extends UICommonAPI;

var WindowHandle m_hMoviePlayerWnd;
var VideoPlayerCtrlHandle MoviePlayerCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowMoviePlayer);
	RegisterEvent( EV_EndMoviePlayer);
	RegisterEvent( EV_ResizeMoviePlayer);
	RegisterEvent( EV_FullScreenMoviePlayer);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)
	{
		m_hMoviePlayerWnd = GetHandle( "MoviePlayerWnd" );
		MoviePlayerCtrl = VideoPlayerCtrlHandle(GetHandle("MoviePlayerWnd.MoviePlayer"));	
	}
	else
	{
		m_hMoviePlayerWnd = GetWindowHandle( "MoviePlayerWnd" );
		MoviePlayerCtrl = GetVideoPlayerCtrlHandle("MoviePlayerWnd.MoviePlayer");	
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_ShowMoviePlayer:
	 	ShowMoviePlayer();
		break;
	case EV_EndMoviePlayer:
		HideMoviePlayer();
		break;
	case EV_ResizeMoviePlayer:
		ResizeMoviePlayer();
		break;
	case EV_FullScreenMoviePlayer:
		FullScreenMoviePlayer();
		break;
	}
}

function ShowMoviePlayer()
{
	//debug("MoviePlayerWnd - OnShow");
	
	m_hMoviePlayerWnd.ShowWindow();
	MoviePlayerCtrl.SetFocus();
	
	MoviePlayerCtrl.PlayMovie();
	MoviePlayerCtrl.SetFocus();
}

function HideMoviePlayer()
{
	//debug("MoviePlayerWnd - OnHide");
	
	MoviePlayerCtrl.EndMovie();
		
	m_hMoviePlayerWnd.HideWindow();
}

function ResizeMoviePlayer()
{
	//debug("MoviePlayerWnd - Resize");
	
	MoviePlayerCtrl.Resize();
	MoviePlayerCtrl.SetFocus();	
}

function FullScreenMoviePlayer()
{
	//debug("MoviePlayerWnd() - FullScreen");
	
	MoviePlayerCtrl.FullScreen();
	MoviePlayerCtrl.SetFocus();
}
defaultproperties
{
}
