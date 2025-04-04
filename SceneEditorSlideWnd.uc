class SceneEditorSlideWnd extends UICommonAPI;

var string m_WindowName;

var WindowHandle	Me;
var WindowHandle	ScreenWnd;
var WindowHandle	Slide;
var WindowHandle	BackSlide;

var WindowHandle	CurSlide;
var WindowHandle	NextSlide;

var TextureHandle	SlideTexture;
var TextureHandle	BackSlideTexture;

var TextureHandle	CurSlideTexture;
var TextureHandle	NextSlideTexture;

function OnRegisterEvent()
{
	RegisterEvent( EV_SlideShow );
	RegisterEvent( EV_ResolutionChanged );
}

function OnLoad()
{
	Me = GetWindowHandle( "SceneEditorSlideWnd" );
	ScreenWnd = GetWindowHandle( "SceneEditorSlideWnd.ScreenWnd" );
	Slide = GetWindowHandle( "SceneEditorSlideWnd.ScreenWnd.Slide" );
	BackSlide = GetWindowHandle( "SceneEditorSlideWnd.ScreenWnd.BackSlide" );
	
	SlideTexture = GetTextureHandle( "SceneEditorSlideWnd.ScreenWnd.Slide.SlideTexture" );
	BackSlideTexture = GetTextureHandle( "SceneEditorSlideWnd.ScreenWnd.BackSlide.BackSlideTexture" );
	
	CurSlide = Slide;
	NextSlide = BackSlide;
	
	CurSlideTexture = SlideTexture;
	NextSlideTexture = BackSlideTexture;
	
	CheckResolution();
}

function OnEvent( int Event_ID, string param )
{
	local int Type;
	local int Time;
	local int Dir;
	local string TexName;
	local int USize;
	local int VSize;
	local int MoveRatio;
	local int WndRatio;

	local int ScreenWndWidth;
	local int ScreenWndHeight;
	local int MoveVal;
	
	local WindowHandle TempSlide;
	local TextureHandle TempSlideTexture;

	if( Event_ID == EV_SlideShow )
	{
		ParseInt(param, "Type", Type);
		ParseInt(param, "Time", Time);
		ParseInt(param, "Dir", Dir);
		ParseString(param, "TexName", TexName);		
		ParseInt(param, "USize", USize);
		ParseInt(param, "VSize", VSize);
		ParseInt(param, "MoveRatio", MoveRatio);
		ParseInt(param, "WndRatio", WndRatio);

		switch( Type )
		{
			case 3 :	// Start

				SlideTexture.SetTexture("Default.BlackTexture");
				BackSlideTexture.SetTexture("Default.BlackTexture");

				Me.ShowWindow();
				
				break;	

			case 4 :	// Change

				if( Dir != 0 )
					break;
					
				CurSlide.SetShowAndHideAnimType(false, Dir, 1.f);
				CurSlide.HideWindow();					
				
				ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);
				
				NextSlide.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
				NextSlideTexture.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
				NextSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);

				NextSlideTexture.SetTextureSize(USize, VSize);
				NextSlideTexture.SetTexture(TexName);
				
				NextSlide.SetShowAndHideAnimType(true, Dir, float(Time) /1000.f);
				NextSlide.ShowWindow();
				
				TempSlide = CurSlide;
				CurSlide = NextSlide;
				NextSlide = TempSlide;
				
				TempSlideTexture = CurSlideTexture;
				CurSlideTexture = NextSlideTexture;
				NextSlideTexture = TempSlideTexture;

				break;

			case 5 : // Move

				ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);

				switch( Dir )
				{
					case 0:
						return;

					case 1: // Left
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);

						CurSlide.SetWindowSize(ScreenWndWidth * WndRatio / 100, ScreenWndHeight);
						CurSlideTexture.SetWindowSize(ScreenWndWidth * WndRatio / 100, ScreenWndHeight);

						break;

					case 2: // Right
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopRight", "TopRight", 0, 0);

						CurSlide.SetWindowSize(ScreenWndWidth * WndRatio / 100, ScreenWndHeight);
						CurSlideTexture.SetWindowSize(ScreenWndWidth * WndRatio / 100, ScreenWndHeight);

						break;

					case 3: // Up
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);

						CurSlide.SetWindowSize(ScreenWndWidth, ScreenWndHeight * WndRatio / 100);
						CurSlideTexture.SetWindowSize(ScreenWndWidth, ScreenWndHeight * WndRatio / 100);

						break;

					case 4: // Down
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "BottomLeft", "BottomLeft", 0, 0);

						CurSlide.SetWindowSize(ScreenWndWidth, ScreenWndHeight * WndRatio / 100);
						CurSlideTexture.SetWindowSize(ScreenWndWidth, ScreenWndHeight * WndRatio / 100);

						break;

					default:
						return;
				}

				CurSlideTexture.SetTextureSize(USize, VSize);
				CurSlideTexture.SetTexture(TexName);

				CurSlide.ClearAnchor();
				
				switch( Dir )
				{
					case 0:
						return;

					case 1: // Left
						MoveVal = ScreenWndWidth * MoveRatio / 100 * -1;
						CurSlide.MoveExWithTime(MoveVal, 0, float(Time) /1000.f);

						break;

					case 2: // Right
						MoveVal = ScreenWndWidth * MoveRatio / 100;
						CurSlide.MoveExWithTime(MoveVal, 0, float(Time) /1000.f);

						break;

					case 3: // Up
						MoveVal = ScreenWndHeight * MoveRatio / 100 * -1;
						CurSlide.MoveExWithTime(0, MoveVal, float(Time) /1000.f);

						break;

					case 4: // Down
						MoveVal = ScreenWndHeight * MoveRatio / 100;
						CurSlide.MoveExWithTime(0, MoveVal, float(Time) /1000.f);

						break;

					default:
						return;
				}

				break;

			case 7 :	// End

				Me.HideWindow();

				break;

			default :
				break;
		}
	}
	else if( Event_ID == EV_ResolutionChanged )
	{
		CheckResolution();
	}
}


function CheckResolution()
{
	local int CurrentMaxWidth; 
	local int CurrentMaxHeight;
	
	GetCurrentResolution (CurrentMaxWidth, CurrentMaxHeight);
	
	ScreenWnd.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	ScreenWnd.SetAnchor("SceneEditorSlideWnd", "CenterCenter", "CenterCenter", 0, 0 );
	ScreenWnd.SetWindowSizeRel43(1.f,1.f,0,0);

	ScreenWnd.GetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	Slide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	SlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	
	BackSlide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	BackSlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
}
defaultproperties
{
}
