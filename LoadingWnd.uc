class LoadingWnd extends UIScriptEx;

var string LoadingTexture15;
var string LoadingTexture18;
var string LoadingTextureFree;
var texturehandle blackbillboard;
var texturehandle loadingtexture;

function OnRegisterEvent()
{
	RegisterEvent( EV_ServerAgeLimitChange );
	RegisterEvent( EV_ResolutionChanged );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		blackbillboard = TextureHandle(GetHandle("BlackBackTex"));
		loadingtexture = TextureHandle(GetHandle("BackTex"));
	}
	else
	{
		blackbillboard = GetTextureHandle("LoadingWnd.BlackBackTex");
		loadingtexture = GetTextureHandle("LoadingWnd.BackTex");
	}
	
	loadingtexture.SetTexture(LoadingTextureFree );	
	CheckResolution();
	
}

function OnEvent( int a_EventID, String a_Param )
{
	local int ServerAgeLimitInt;
	local EServerAgeLimit ServerAgeLimit;

	if( a_EventID == EV_ServerAgeLimitChange )
	{
		if( ParseInt( a_Param, "ServerAgeLimit", ServerAgeLimitInt ) )
		{
			ServerAgeLimit = EServerAgeLimit( ServerAgeLimitInt );
			switch( ServerAgeLimit )
			{
			case SERVER_AGE_LIMIT_15:
				//debug( "LoadingTexture15=" $ LoadingTexture15 );
				loadingtexture.SetTexture(LoadingTexture15 );
				break;
			case SERVER_AGE_LIMIT_18:
				//debug( "LoadingTexture18=" $ LoadingTexture18 );
				loadingtexture.SetTexture( LoadingTexture18 );
				break;
			case SERVER_AGE_LIMIT_Free:
				//debug( "LoadingTextureFree=" $ LoadingTextureFree );
			default:
				loadingtexture.SetTexture(LoadingTextureFree );
				break;
			}
		}
	}
	
	if( a_EventID == EV_ResolutionChanged)
	{
		CheckResolution();
	}
	
}



function CheckResolution()
{
	local int CurrentMaxWidth; 
	local int CurrentMaxHeight;
	
	GetCurrentResolution (CurrentMaxWidth, CurrentMaxHeight);
	blackbillboard.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	loadingtexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	loadingtexture.SetAnchor("LoadingWnd", "CenterCenter", "CenterCenter", 0, 0 );
	loadingtexture.SetWindowSizeRel43(1.f,1.f,0,0);
	
	
}
defaultproperties
{
    LoadingTexture15="L2Font.loading03-k"
    LoadingTexture18="L2Font.loading04-k"
    LoadingTextureFree="L2Font.loading02-k"
}
