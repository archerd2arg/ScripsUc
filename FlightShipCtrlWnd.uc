class FlightShipCtrlWnd extends UIScriptEx;

// µðÆÄÀÎ
const MAX_ShortcutPerPage = 12;	// 12Ä­ÀÇ ¼ôÄÆÀ» Áö¿øÇÑ´Ù. 
const FSShortcutPage = 11;		// ºñÇàÁ¤Àº 11¹ø ÆäÀÌÁö¸¦ »ç¿ëÇÑ´Ù. 
const Relative_Altitude = 4000;	// ½Ç ÁÂÇ¥°è¿¡ +a ÇÏ´Â °ª

const SelectTex_X = -5;
const SelectTex_Y = -5;

// Àü¿ª º¯¼ö
var WindowHandle Me;
var WindowHandle ShortcutWnd;

var	CheckBoxHandle 	Chk_EnterChatting;	//shortcut assign wndÀÇ ¿£ÅÍÃ¤ÆÃ ¸ðµå Ã¼Å©¹Ú½º.
var	TextBoxHandle	AltitudeTxt;		//°íµµ ÅØ½ºÆ®¹Ú½º
var	TextureHandle	SelectTex;			// ¼±ÅÃµÈ ¾ÆÀÌÅÛÀ» ¾Ë·ÁÁÖ´Â ÅØ½ºÃÄ

var	ButtonHandle	UpButton;			// °íµµ »ó½Â
var	ButtonHandle	DownButton;		// °íµµ ÇÏ°­®


var	ButtonHandle	LockBtn;			// Àá±Ý ¹öÆ°
var	ButtonHandle	UnlockBtn;			// Àá±Ý ÇØÁ¦ ¹öÆ°
var	ButtonHandle	JoypadBtn;			// Á¶ÀÌÆÐµå

var 	EditBoxHandle ChatEditBox;			// Ã¤ÆÃ ¿¡µðÆ® ¹Ú½º

var  	ShortcutWnd 	scriptShortcutWnd;		

var	int i;							//·çÇÁ µ¹¸±¶§ »ç¿ëÇÏ´Â º¯¼ö

var	bool 		preEnterChattingOption;

var 	bool m_IsLocked;	// ¼ôÄÆ Àá±Ý º¯¼ö

var	bool	m_preDriver;	// ÀÌÀü »óÅÂ¿¡¼­ µå¶óÀÌ¹ö¿´´ÂÁö¸¦ ÀúÀåÇÑ´Ù.

var	bool isNowActiveFlightShipShortcut;	// ÇöÀç Á¶Á¾¸ðµåÀÎÁö¸¦ ÀúÀåÇÑ´Ù. Çâ»óµÈ ¼¼ÀÌ´õ°°ÀÌ °ÔÀÓÁß ·ÎµùÀÌ ³ª¿Ã ¼ö ÀÖÀ¸¹Ç·Î.

var	int preSlot;			// ÀÌÀü¿¡ È°¼ºÈ­µÈ ½½·ÔÀ» ÀúÀåÇØµÐ´Ù.

// ÀÌº¥Æ® µî·Ï
function OnRegisterEvent()
{
	RegisterEvent( EV_AirShipState );
	RegisterEvent( EV_AirShipAltitude);
	
	RegisterEvent( EV_ShortcutCommandSlot );	//¼ôÄÆ ÀÌº¥Æ®
	RegisterEvent( EV_ReserveShortCut);		// ¿¹¾àµÈ ¼ôÄÆ ÀÌº¥Æ®	
	
	RegisterEvent( EV_ShortcutPageUpdate );
	RegisterEvent( EV_ShortcutUpdate );
	RegisterEvent( EV_ShortcutClear );	
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)		// °ú°ÅÀÇ ÇÚµé ¹Þ±â
	{
		Me = GetHandle( "FlightShipCtrlWnd" );
		ShortcutWnd = GetHandle( "ShortcutWnd" );
		Chk_EnterChatting = CheckBoxHandle ( GetHandle( "OptionWnd.ShortcutTab.OptionCheckboxGroup.Chk_EnterChatting"));
		AltitudeTxt = TextBoxHandle ( GetHandle ( "FlightShipCtrlWnd.AltitudeTxt"));
		SelectTex = TextureHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.SelectTex"));
		
		UpButton = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightSteerWnd.UpButton"));
		DownButton = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightSteerWnd.DownButton"));
		LockBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.LockBtn"));
		UnlockBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.UnlockBtn"));
		JoypadBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.JoypadBtn"));
		
		ChatEditBox = EditBoxHandle( GetHandle("ChatWnd.ChatEditBox" ));
		
	}
	else	// »õ·Î¿î ÇÚµé ¹Þ±â!!
	{
		Me = GetWindowHandle( "FlightShipCtrlWnd" );
		ShortcutWnd = GetWindowHandle( "ShortcutWnd" );
		Chk_EnterChatting = GetCheckBoxHandle( "OptionWnd.ShortcutTab.OptionCheckboxGroup.Chk_EnterChatting");
		AltitudeTxt = GetTextBoxHandle( "FlightShipCtrlWnd.AltitudeTxt");
		SelectTex = GetTextureHandle( "FlightShipCtrlWnd.FlightShortCut.SelectTex");
		
		UpButton = GetButtonHandle( "FlightShipCtrlWnd.FlightSteerWnd.UpButton");
		DownButton = GetButtonHandle ( "FlightShipCtrlWnd.FlightSteerWnd.DownButton");
		LockBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.LockBtn");
		UnlockBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.UnlockBtn");
		JoypadBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.JoypadBtn");	
		
		ChatEditBox = GetEditBoxHandle( "ChatWnd.ChatEditBox" );
	}
	
	scriptShortcutWnd = ShortcutWnd( GetScript("ShortcutWnd") );	
	isNowActiveFlightShipShortcut = false;
	m_preDriver = false;
	preSlot = -1;
	JoypadBtn.HideWindow();	
	updateLockButton();	// Àá±Ý »óÅÂ¸¦ ¾÷µ¥ÀÌÆ® ÇÑ´Ù. 
	ShortCutUpdateAll();
}

function OnEnterState( name a_PreStateName )
{
	if(isNowActiveFlightShipShortcut)	// Á¶Á¾¸ðµå¿´¾ú´Ù¸é
	{
		if( a_PreStateName == 'ShaderBuildState')
		{
			if(!Me.isShowwindow()) Me.ShowWindow();					//Àü¿ë ¼ôÄÆÀ¸·Î º¯°æ
			if(ShortcutWnd.isShowwindow()) ShortcutWnd.HideWindow();
		}
	}
}

function OnExitState( name a_NextStateName )
{
	if( a_NextStateName != 'ShaderBuildState')	// ½¦ÀÌ´õ »óÅ×·Î ³ª°¥ °æ¿ì°¡ ¾Æ´Ï¶ó¸é,  Ã¼Å©¹Ú½ºÀÇ µð½º¿¡ÀÌºíÀ» Ç®¾îÁØ´Ù. 
	{
		Chk_EnterChatting.EnableWindow();	// µð½º¿¡ÀÌºí ÇØÁ¦		
	}
}

function updateLockButton()
{
	m_IsLocked = GetOptionBool( "Game", "IsLockShortcutWnd" );
	if(m_IsLocked)
	{
		if(!LockBtn.isShowwindow()) LockBtn.ShowWindow();
		if(UnlockBtn.isShowwindow()) UnlockBtn.HideWindow();
	}
	else
	{
		if(LockBtn.isShowwindow()) LockBtn.HideWindow();
		if(!UnlockBtn.isShowwindow()) UnlockBtn.ShowWindow();
	}
	scriptShortcutWnd.ArrangeWnd();
}


// ÀÌº¥Æ® Ã³¸®
function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_AirShipState:
		OnAirShipState( a_Param );
		break;
	case EV_AirShipAltitude:
		OnAirShipAltitude( a_Param);
		break;
	case EV_ShortcutCommandSlot:
		ExecuteShortcutCommandBySlot(a_Param);	// ´ÜÃàÅ° ½ÇÇà ÀÌº¥Æ®
		break;
	case EV_ReserveShortCut:
		OnReserveShortCut( a_Param );
		break;
	case EV_ShortcutUpdate:
		HandleShortcutUpdate( a_Param );
		break;
	case EV_ShortcutPageUpdate:	// ÆäÀÌÁö°¡ ¾ø±â ¶§¹®¿¡ ÀüÃ¼¸¦ ¾÷µ¥ÀÌÆ® ÇÑ´Ù.
		ShortCutUpdateAll();
		break;
	case EV_ShortcutClear:
		HandleShortcutClear();
		updateLockButton();	// Àá±Ý »óÅÂ¸¦ ¾÷µ¥ÀÌÆ® ÇÑ´Ù. 			
		break;
	default:
		break;
	}
}

function OnAirShipState( string a_Param )
{
	local int VehicleID;
	local int IsDriver;
	
	ParseInt( a_Param, "VehicleID", VehicleID );	// ºñÇàÁ¤ À§ÀÇ ºñÇàÁ¤ °íµµ ¹× HP ¿¬·á µî UI´Â RadarMapWnd.uc¿¡¼­ Ã³¸®ÇÏµµ·Ï ÇÑ´Ù. 
	ParseInt( a_Param, "IsDriver", IsDriver );
	
	debug("VehicleID = " $ VehicleID $" IsDriver = " $ IsDriver);
	
	if( IsDriver > 0 )	//Á¶Á¾»ç ´ÜÃàÅ° ¸ðµå
	{
		if(VehicleID > 0)	// Á¶Á¾ ¸ðµå º¸ÀÌ±â, ÇØÁ¦¿¡¼­´Â Ç×»ó ºñÇàÁ¤ ¾ÆÀÌµð°¡ Á¸ÀçÇÏ¿©¾ß ÇÑ´Ù. 
		{		
			preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//±âÁ¸ ¿£ÅÍÃ¤ÆÃ ¿É¼ÇÀ» ÀúÀåÇØµÐ´Ù. 		
			SetOptionBool( "Game", "EnterChatting", true );	//°­Á¦ ¿£ÅÍ Ã¤ÆÃ
			Chk_EnterChatting.SetCheck(true);
			Chk_EnterChatting.DisableWindow();			// µð½º¿¡ÀÌºí
			
			class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");		//¼ôÄÆ ±×·ì ÁöÁ¤	
			updateLockButton();	// Àá±Ý »óÅÂ¸¦ ¾÷µ¥ÀÌÆ® ÇÑ´Ù. 			
			if(!Me.isShowwindow()) 
			{
				Me.ShowWindow();					//Àü¿ë ¼ôÄÆÀ¸·Î º¯°æ
				ShortcutWnd.HideWindow();
			}
			
			ChatEditBox.ReleaseFocus();
			
			isNowActiveFlightShipShortcut = true;
			m_preDriver = true;
		}
	}
	else	// Á¶Á¾»ç ÇØÁ¦ isDriver == 0
	{
		if(VehicleID > 0 && m_preDriver == true)		// ÀÌÀü »óÅÂ°¡ Á¶Á¾¸ðµå¿´À»¶§¸¸ Á¶Á¾À» ÇØÁ¦ÇÑ´Ù.
		{		
			Chk_EnterChatting.EnableWindow();	// µð½º¿¡ÀÌºí ÇØÁ¦
			class'ShortcutAPI'.static.DeactivateGroup("FlightStateShortcut"); 	// ¼ôÄÆ ±×·ì ÇØÁ¦		
			
			SetOptionBool( "Game", "EnterChatting", preEnterChattingOption );	//¹é¾÷ÇØµÐ ¿£ÅÍÃ¤ÆÃ ¿É¼ÇÀ» ´Ù½Ã ³Ö¾îÁØ´Ù.
			if(preEnterChattingOption)	// º¯½ÅÀü ¹é¾÷ »óÅÂ¿¡ µû¶ó ¿£ÅÍ Ã¤ÆÃÀ» È°¼ºÈ­ ÇØÁØ´Ù.			
			{			
				class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
			}		
			Chk_EnterChatting.SetCheck(preEnterChattingOption);		
			
			if(Me.isShowwindow())	
			{
				Me.HideWindow();					// ¿ø·¡ ¼ôÄÆÀ¸·Î µ¹·Á³õÀ½
				ShortcutWnd.ShowWindow();
			}
			
			isNowActiveFlightShipShortcut = false;			
			ChatEditBox.ReleaseFocus();
		}
	}
}

function OnAirShipAltitude( string a_Param )
{
	local int m_nZ;
	
	ParseInt( a_Param, "Z" , m_nZ);
	
	AltitudeTxt.SetText(string(m_nZ + 4000));	// °íµµ¸¦ ¾÷µ¥ÀÌÆ® ÇØÁØ´Ù. 
	
}

function ShortCutUpdateAll()
{
	local int nShortcutID;
	
	nShortcutID = MAX_ShortcutPerPage * FSShortcutPage;
	
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ), nShortcutID );
		nShortcutID++;
	}
}

// ¼ôÄÆ ¾÷µ¥ÀÌÆ®
function HandleShortcutUpdate(string param)
{
	local int nShortcutID;
	local int nShortcutNum;
	
	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ( nShortcutID - MAX_ShortcutPerPage * FSShortcutPage) + 1;
	
	debug(" ----------fs------------- id : " $ nShortcutID $ " nShortcutNum " $ nShortcutNum );
	
	if((nShortcutNum > 0 ) && ( nShortcutNum  < MAX_ShortcutPerPage + 1 ))	// ºñÇà¼ôÄÆÀÏ °æ¿ì¿¡¸¸  ¾÷µ¥ÀÌÆ®
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ nShortcutNum, nShortcutID );
	}
}

 //¼ôÄÆ Å¬¸®¾î
function HandleShortcutClear()
{		
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.clear( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ) );
	}
}

function ExecuteShortcutCommandBySlot( string a_Param )
{
	local int slot;
	//local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 132¹øºÎÅÍ 143¹ø±îÁöÀÇ ½½·ÔÀÌ µé¾î¿À¸é ½ÇÇàÇØÁØ´Ù. 
	if( (slot >= MAX_ShortcutPerPage * FSShortcutPage) && ( slot < MAX_ShortcutPerPage * (FSShortcutPage + 1)))
	{	
		//slotFromOne = slot - MAX_ShortcutPerPage * FSShortcutPage + 1;
		class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);
		//SelectTex.SetAnchor( "FlightShipCtrlWnd.FlightShortCut.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
	}
}

function OnReserveShortCut( string a_Param )
{
	local int slot;
	local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 132¹øºÎÅÍ 143¹ø±îÁöÀÇ ½½·ÔÀÌ µé¾î¿À¸é ±¤À» ³»ÁØ´Ù.
	if( (slot >= MAX_ShortcutPerPage * FSShortcutPage) && ( slot < MAX_ShortcutPerPage * (FSShortcutPage + 1)))
	{	
		slotFromOne = slot - MAX_ShortcutPerPage * FSShortcutPage + 1;
		SelectTex.SetAnchor( "FlightShipCtrlWnd.FlightShortCut.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
		
		if( preSlot == slotFromOne )	// ÀÌ¹Ì ¼±ÅÃµÈ »óÅÂ¿¡¼­ ÇÑ¹ø ´õ ´©¸£¸é ½ÇÇàµÈ´Ù.
		{
			class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);
		}
		else
		{
			preSlot = slotFromOne;
		}
	}
}

// °íµµ »ó½Â, ÇÏ°­ ¹öÆ°
function OnClickButton( String strID )
{
	switch( strID )
	{
	case "UpButton":
		Class'VehicleAPI'.static.AirShipMoveUp();	//°íµµ »ó½Â
		break;
	case "DownButton":
		Class'VehicleAPI'.static.AirShipMoveDown(); // °íµµ ÇÏ°­
		break;
	case "LockBtn":
		m_IsLocked = false;
		SetOptionBool( "Game", "IsLockShortcutWnd", false );
		updateLockButton();
		break;
	case "UnlockBtn":
		m_IsLocked = true;
		SetOptionBool( "Game", "IsLockShortcutWnd", true );
		updateLockButton();
		break;
	}
}
defaultproperties
{
}
