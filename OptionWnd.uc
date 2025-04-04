// edKith 07.01.2016
// added language switch support for Russian Localization
class OptionWnd extends UICommonAPI;


const PARTY_MODIFY_REQUEST = 0;
const OPTION_CHANGE = 1;

/* 옵션 컨트롤 이름

[비디오옵션]

해상도		ResBox
주사율		RefreshRateBox
감마값		GammaBox
텍스쳐디테일	TextureBox
모델링디테일	ModelBox
모션디테일	AnimBox
시야-지형	TerrainBox
시야-캐릭터	CharBox
캐릭터표시제한	PawnBox
최소프레임유지	FrameBox - checkbox
반사효과		ReflectBox
안티알리아싱	AABox
그림자		ShadowBox - checkbox
배경효과		DecoBox - checkbox
텍스쳐필터링	TriBox -checkbox
스크린샷 품질	CaptureBox
화질개선셰이더	HDRBox

///////////////////////////////////////////
// Added on 2006/03/21 by NeverDie

기상효과 - WeatherEffectComboBox
GPU애니메이션 -	GPUAnimationCheckBox

[오디오옵션]

효과음볼륨	EffectBox
음악볼륨		MusicBox
시스템음성	SystemBox
튜토리얼음성	TutorialBox

[게임옵션]

인터페이스초기화버튼	WindowInitBtn
투명화			OpacityBox
언어선택			LanguageBox - combobox
자신이름			NameBox0
몬스터이름		NameBox1
다른PC이름		NameBox2
혈맹이름			NameBox3
파티이름			NameBox4
일반이름			NameBox5
엔터체팅			EnterChatBox
채팅기호			OldChatBox
키보드보안		KeyboardBox
게임패드			JoypadBox
마우스 오른쪽버튼 사용않기	 RightClickBox
카메라추적		CameraBox
그래픽커서		CursorBox
3D화살표		ArrowBox
지역명표시		ZoneNameBox
시스템메시지전용창	SystemMsgBox
데미지			DamageBox
소모성아이템사용		ItemBox
파티루팅			LootingBox - combobox
파티신청 거부		PartyRejectBox
커플액션 거부		CoupleActionBox
PC방 포인트 끄기	PCPointBox

*/
//캐릭터 표시제한 슬라이더 액션
const RENDERCHARACTERLIMIT_MIN = 10;
const RENDERCHARACTERLIMIT_MAX = 400;

var bool bPartyMember;
var bool bPartyMaster;
//var bool bPartyRoomMaster;
//var int Lootingtype;
var bool NowLooting; //파티루팅도중에는 루팅콤보박스를 막으려고 한다

var int g_CurrentMaxWidth;
var int g_CurrentMaxHeight;
var int nPixelShaderVersion;
var int nVertexShaderVersion;
var float gSoundVolume;
var float gMusicVolume;
var float gWavVoiceVolume;
var float gOggVoiceVolume;
var Array<ResolutionInfo> ResolutionList;
var Array<int> RefreshRateList;
var bool bShow;

var bool m_bL2Shader;
var bool m_bDepthBufferShadow;
var bool m_bDOF;
var bool m_bShaderWater;
//var bool m_bPartyRejected;

// 취소 하면 되돌리기 위해서 예전 것을 기억하고 있을 변수 - lancelot 2006. 6. 13.
var int m_iPrevSoundTick;
var int m_iPrevMusicTick;
var int m_iPrevSystemTick;
var int m_iPrevTutorialTick;
var bool bg_Temp;

// 파티매칭방에 입장한 상태인가?	2006.10.19 ttmayrin
var bool m_bPartyMatchRoomState;

//solasys-포그테스트변수
var bool m_bAirState;

var WindowHandle TargetStatusWnd;
var WindowHandle StatusWnd;
var WindowHandle SystemMenuWnd;

var EditBoxHandle KeySettingInput;
var ButtonHandle Btn_SaveCurrentKey;
var ButtonHandle Btn_CancelCurrentKey;

var DialogBox	dScript;

function ResetRefreshRate( optional int a_nWidth, optional int a_nHeight )
{
	local int i;

	GetRefreshRateList( RefreshRateList, a_nWidth, a_nHeight );
	//debug( "RefreshRateList.Length " $ RefreshRateList.Length );
	class'UIAPI_COMBOBOX'.static.Clear( "OptionWnd.RefreshRateBox" );
	for( i = 0; i < RefreshRateList.Length; ++i )
	{
		//~ debug( "RefreshRateList[ i ] " $ RefreshRateList[ i ] );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.RefreshRateBox", RefreshRateList[ i ] $ "Hz" );
	}
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.RefreshRateBox", 0 );
}
function OnRegisterEvent()
{

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );//파티루팅옵션 변경을위해 다이얼로그에 반응할 필요가 있다.

	RegisterEvent( EV_AskPartyLootingModify ); //파티루팅의 변경 동의 여부를 물어옴 
	RegisterEvent( EV_PartyLootingHasModified); //파티루팅의 결과를 알려줌
		// S: actor char name
		// d: nItemRoutingType

	//solasys-포그테스트
	RegisterEvent( EV_AirStateOn );
	RegisterEvent( EV_AirStateOff );
	
	RegisterEvent( EV_MinFrameRateChanged );
	RegisterEvent( EV_PartyMemberChanged );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );

	RegisterEvent( EV_PartyHasDismissed );//파티가 해체되었음
	RegisterEvent( EV_OustPartyMember ); //파티에서 추방당했음
	RegisterEvent( EV_BecamePartyMember ); //파티의 멤버가 됨
	RegisterEvent( EV_BecamePartyMaster ); //파티장이됨
	RegisterEvent( EV_HandOverPartyMaster ); //파티장을 양도함
	RegisterEvent( EV_RecvPartyMaster ); //파티장을 양도받음
// 	RegisterEvent( EV_PartyMatchRoomStart ); //파티방장이됨
 	RegisterEvent( EV_PartyMatchRoomClose ); //파티방닫음
	RegisterEvent( EV_WithdrawParty ); //파티에서 탈퇴함


	

}


function InitHandle()
{
	TargetStatusWnd = GetHandle( "TargetStatusWnd" );
	StatusWnd = GetHandle( "StatusWnd" );
	SystemMenuWnd = GetHandle( "SystemMenuWnd" );

	KeySettingInput = EditBoxHandle ( GetHandle( "OptionWnd.KeySettingInput" ) );
	Btn_SaveCurrentKey = ButtonHandle ( GetHandle( "OptionWnd.Btn_SaveCurrentKey" ) );
	Btn_CancelCurrentKey = ButtonHandle ( GetHandle( "OptionWnd.Btn_CancelCurrentKey" ) );
}

function InitHandleCOD()
{
	TargetStatusWnd = GetWindowHandle( "TargetStatusWnd" );
	StatusWnd = GetWindowHandle( "StatusWnd" );
	SystemMenuWnd = GetWindowHandle( "SystemMenuWnd" );

	KeySettingInput = GetEditBoxHandle( "OptionWnd.KeySettingInput" );
	Btn_SaveCurrentKey = GetButtonHandle ( "OptionWnd.Btn_SaveCurrentKey" );
	Btn_CancelCurrentKey = GetButtonHandle ( "OptionWnd.Btn_CancelCurrentKey" );
}

function OnLoad()
{
	local int i;
	local int nMultiSample;
	local bool bEnableEngSelection;
	local ELanguageType Language;
	local string strResolution;
	
	dScript = DialogBox(GetScript("DialogBox"));

	bPartyMember = false;
	bPartyMaster = false;
//	bPartyRoomMaster = false;
//	Lootingtype = 0;
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	
	m_bAirState = false;

	// 2006/03/26 - added register state by NeverDie. multi-registering states can only be placed in uc...
	RegisterState( "OptionWnd", "GamingState" );
	RegisterState( "OptionWnd", "LoginState" );

	// Shader version
	GetShaderVersion( nPixelShaderVersion, nVertexShaderVersion );

	GetResolutionList( ResolutionList );
	
	SetOptionBool( "Game", "HideDropItem", false );
	
	for( i = 0; i < ResolutionList.Length; ++i )
	{
		strResolution = "" $ ResolutionList[ i ].nWidth $ "*" $ ResolutionList[ i ].nHeight $ " " $ ResolutionList[ i ].nColorBit $ "bit";
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.ResBox", strResolution );
	}

	ResetRefreshRate();
	/*
	GetRefreshRateList( RefreshRateList );
	class'UIAPI_COMBOBOX'.static.Clear( "OptionWnd.RefreshRateBox" );
	for( i = 0; i < RefreshRateList.Length; ++i )
	{
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.RefreshRateBox", RefreshRateList[ i ] $ "Hz" );
	}
	*/

	nMultiSample = GetMultiSample();
	if( 0 == nMultiSample )
	{
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 869 );
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.AABox" );
	}
	else if( 1 == nMultiSample )
	{
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 869 );
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 870 );
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.AABox" );
	}
	else if( 2 == nMultiSample )
	{
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 869 );
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 870 );
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.AABox", 871 );
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.AABox" );
	}

	bEnableEngSelection = IsEnableEngSelection();
	Language = GetLanguage();
	switch( Language )
	{
	case LANG_None:
		break;
	case LANG_Korean:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "Korean" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	case LANG_English:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		break;
	case LANG_Japanese:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "Japanese" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	case LANG_Taiwan:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "Chinese(Taiwan)" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	case LANG_Chinese:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "China" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	case LANG_Thai:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "Thai" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	case LANG_Philippine:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		break;
	//edKith
	//07.01.2016
	//Added Russian Language Support
	case LANG_Russia:
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "Russian" );
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.LanguageBox", "English" );
		if( bEnableEngSelection )
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.LanguageBox" );
		else
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.LanguageBox" );
		break;
	default:
		break;
	}

	if( CanUseHDR() )
	{
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.HDRBox", 1230 );
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.HDRBox", 1231 );
		class'UIAPI_COMBOBOX'.static.SYS_AddString( "OptionWnd.HDRBox", 1232 );
	}

	// 2007/11/16 Now new functions(LoadVideoOption,LoadAudioOption,LoadGameOption) load the ini configuration. - NeverDie
	//InitVideoOption();
	//InitAudioOption();
	//InitGameOption();
	LoadVideoOption();
	LoadAudioOption();
	LoadGameOption();

	bShow = false;
}

function RefreshLootingBox()
{
	local PartyWnd script;
	// debug("Refresh looting box");
	if(NowLooting)
	{
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
		return;
	}
	if( GetPartyMemberCount() > 0 || m_bPartyMatchRoomState )
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
	else
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );

	script = PartyWnd(GetScript("PartyWnd"));
	if(script.AmILeader())
	{		
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );
	}
}


function int GetPawnValue( out int iCurrTick, int iNumTick, int MIN, int MAX )
{
	local int iValue;

	if(iCurrTick<0 || iCurrTick>=(iNumTick-1))
	{
		iValue = 10000;
		iCurrTick = (iNumTick-1);
	}
	else
	{
		iValue = 10+iCurrTick*(MAX-MIN)/(iNumTick-2)-(Sin( Pi*iCurrTick/(iNumTick-2) ) * MAX/3.66);
	}
	
	return iValue;
}

function InitVideoOption()
{
	local int i;
	local int nResolutionIndex;
	local float fGamma;
	//local float fPawnClippingRange;
	//local float fTerrainClippingRange;
	local bool bRenderDeco;
	local int nPostProcessType;
	local bool bShadow;
	local int nTextureDetail;
	local int nModelDetail;
	local int nSkipAnim;
	local bool bWaterEffect;
	local int nWaterEffectType;
	local int nMultiSample;
	local int nOption;
	local bool bOption;
	local bool bL2Shader;
	local bool bDOF;
	local bool bShaderWater;
	local int iPawnValue;
	local int iNumTick;
	local int RenderActorLimitOpt;

	// 해상도 - ResBox
	nResolutionIndex = GetResolutionIndex();
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ResBox", nResolutionIndex );

	// 주사율 - RefreshRateBox
	GetRefreshRateList( RefreshRateList );
	class'UIAPI_COMBOBOX'.static.Clear( "OptionWnd.RefreshRateBox" );
	for( i = 0; i < RefreshRateList.Length; ++i )
	{
		class'UIAPI_COMBOBOX'.static.AddString( "OptionWnd.RefreshRateBox", RefreshRateList[ i ] $ "Hz" );
	}
	nOption = GetOptionInt( "Video", "RefreshRate" );
	for( i = 0; i < RefreshRateList.Length; ++i )
	{
		//~ debug( "RefreshRateList[ " $ i $ " ] = " $ RefreshRateList[ i ] );
		if( RefreshRateList[ i ] == nOption )
			class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.RefreshRateBox", i );
	}

	// 감마값 - GammaBox
	fGamma = GetOptionFloat( "Video", "Gamma" );
	if( 1.2f <= fGamma )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.GammaBox", 0 );
	else if( 1.0f <= fGamma && fGamma < 1.2f )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.GammaBox", 1 );
	else if( 0.8f <= fGamma && fGamma < 1.0f )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.GammaBox", 2 );
	else if( 0.6f <= fGamma && fGamma < 0.8f )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.GammaBox", 3 );
	else if( fGamma < 0.6f )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.GammaBox", 4 );

	// 시야-캐릭터 - CharBox
	nOption = GetOptionInt( "Video", "PawnClippingRange" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.CharBox", nOption );

	// 시야-지형 - TerrainBox
	nOption = GetOptionInt( "Video", "TerrainClippingRange" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.TerrainBox", nOption );

	// 배경효과 - DecoBox
	bRenderDeco = GetOptionBool( "Video", "RenderDeco" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.DecoBox", bRenderDeco );

	// 화질개선셰이더 - HDRBox
	nPostProcessType = GetOptionInt( "Video", "PostProc" );
	
	//~ debug ("포스트 프로세스타입" @ nPostProcessType);
	if( 0 <= nPostProcessType && nPostProcessType <= 5 )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.HDRBox", nPostProcessType );
	else
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.HDRBox", 0 );

	// 그림자 - ShadowBox
	bShadow = GetOptionBool( "Video", "PawnShadow" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ShadowBox", bShadow );

	// 텍스쳐디테일 - TextureBox
	nTextureDetail = GetOptionInt( "Video", "TextureDetail" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.TextureBox", Max( 0, Min( 2, nTextureDetail ) ) );

	// 모델링디테일 - ModelBox
	nModelDetail = GetOptionInt( "Video", "ModelDetail" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ModelBox", nModelDetail );

	// 모션디테일 - AnimBox
	nSkipAnim = GetOptionInt( "Video", "SkipAnim" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.AnimBox", nSkipAnim );

	// 반사효과 - ReflectBox
	if( nPixelShaderVersion < 12 )
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 0 );
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );

		bWaterEffect = GetOptionBool( "L2WaterEffect", "IsUseEffect" );
		nWaterEffectType = GetOptionInt( "L2WaterEffect", "EffectType" );
		if( !bWaterEffect )
			class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 0 );
		else if( nWaterEffectType == 1 )
			class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 1 );
		else if ( nWaterEffectType == 2 )
			class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 2 );
		else
			class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 0 );
	}

	// 텍스쳐필터링 - TriBox
	bOption = GetOptionBool( "Video", "UseTrilinear" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.TriBox", bOption );

	// 캐릭터표시제한 - RenderCharacterCount
	RenderActorLimitOpt = GetOptionInt( "Video", "RenderActorLimitOpt" );
	iNumTick = class'UIAPI_SLIDERCTRL'.static.GetTotalTickCount("OptionWnd.CharacterLimitSliderCtrl");

	iPawnValue = GetPawnValue( RenderActorLimitOpt, iNumTick, RENDERCHARACTERLIMIT_MIN, RENDERCHARACTERLIMIT_MAX );

	class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.CharacterLimitSliderCtrl", RenderActorLimitOpt);
	SetOptionInt( "Video", "RENDERCHARACTERCOUNT", iPawnValue );

	// 안티알리아싱	- AABox
	nMultiSample = GetMultiSample();
	if( nMultiSample > 0 && !( 3 <= nPostProcessType && nPostProcessType <= 5 ) ) 
	{
		nOption = GetOptionInt( "Video", "AntiAliasing" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.AABox", nOption );
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.AABox" );
	}
	else 
	{
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.AABox", 0 );
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.AABox" );
	}
	
	//셰이더 3.0
	bL2Shader = GetOptionBool( "Video", "L2Shader" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30Box", bL2Shader );
	if ( nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30)
	{
		if(bL2Shader)
		{
			//class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.GPUAnimationCheckBox" );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30DOFBOX" );
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30WaterEffectBox" );
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30ShadowBox" );
		}
		else
		{
			//class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.GPUAnimationCheckBox" );
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
		}
		//셰이더 3.0 - DOF?
		bDOF = GetOptionBool( "Video", "S30DOFBOX" );
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", bDOF );
			
		//셰이더 3.0 - 물효과
		bShaderWater = GetOptionBool( "Video", "S30WaterEffectBox" );
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", bShaderWater );
		
		//셰이더 3.0 - 그림자.
		m_bDepthBufferShadow = GetOptionBool( "Video", "S30ShadowBox" );
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", m_bDepthBufferShadow );
	}
	else
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30Box" );
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
	}
	
	// 최소프레임유지 - FrameBox
	bOption = GetOptionBool( "Video", "IsKeepMinFrameRate" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.FrameBox", bOption );
	if( bOption ) 
		MinFrameRateOn();
	else
		MinFrameRateOff();

	// 스크린샷 품질 - CaptureBox
	nOption = GetOptionInt( "Game", "ScreenShotQuality" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.CaptureBox", nOption );
		
	nOption = GetOptionInt("Game", "LayoutDF");
	//~ Debug ("기본 레이아웃 번호:" @ nOption);
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.DefaultPositionBox", nOption );
	
	if (nOption ==1)
	{
		SetStuck(true);
	}
	else
	{
		SetStuck(false);
	}
	
	
	///////////////////////////////////////////
	// Added on 2006/03/21 by NeverDie

	// 기상효과 - WeatherEffectComboBox
	nOption = GetOptionInt( "Video", "WeatherEffect" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.WeatherEffectComboBox", nOption );

	// GPU애니메이션 - GPUAnimationCheckBox
	bOption = GetOptionBool( "Video", "GPUAnimation" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GPUAnimationCheckBox", bOption );
	if( nVertexShaderVersion < 20 )
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.GPUAnimationCheckBox" );
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GPUAnimationCheckBox", false );
	}
}

function InitAudioOption()
{
	local float fSoundVolume;
	local float fMusicVolume;
	local float fWavVoiceVolume;
	local float fOggVoiceVolume;

	// lancelot 2006. 6. 13.
	local int iSoundVolume;
	local int iMusicVolume;
	local int iSystemVolume;
	local int iTutorialVolume;

	if (GetOptionBool( "Audio", "AudioMuteOn" ) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.mutecheckbox", true);

	}
	else
	{
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.mutecheckbox", false);
	}
		

	if( CanUseAudio() )
	{
		// 효과음볼륨 - EffectVolumeSliderCtrl
		fSoundVolume = GetOptionFloat( "Audio", "SoundVolume" );
		gSoundVolume = fSoundVolume;

		if( 0.0f <= fSoundVolume && fSoundVolume < 0.2f )
			iSoundVolume=0;
		else if( 0.2f <= fSoundVolume && fSoundVolume < 0.4f )
			iSoundVolume=1;
		else if( 0.4f <= fSoundVolume && fSoundVolume < 0.6f )
			iSoundVolume=2;
		else if( 0.6f <= fSoundVolume && fSoundVolume < 0.8f )
			iSoundVolume=3;
		else if( 0.8f <= fSoundVolume && fSoundVolume < 1.0f )
			iSoundVolume=4;
		else if( 1.0f <= fSoundVolume )
			iSoundVolume=5;

		class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.EffectVolumeSliderCtrl", iSoundVolume);


		// 음악볼륨	- MusicVolumeSliderCtrl
		fMusicVolume = GetOptionFloat( "Audio", "MusicVolume" );
		gMusicVolume=fMusicVolume;

		if( 0.0f <= fMusicVolume && fMusicVolume < 0.2f )
			iMusicVolume=0;
		else if( 0.2f <= fMusicVolume && fMusicVolume < 0.4f )
			iMusicVolume=1;
		else if( 0.4f <= fMusicVolume && fMusicVolume < 0.6f )
			iMusicVolume=2;
		else if( 0.6f <= fMusicVolume && fMusicVolume < 0.8f )
			iMusicVolume=3;
		else if( 0.8f <= fMusicVolume && fMusicVolume < 1.0f )
			iMusicVolume=4;
		else if( 1.0f <= fMusicVolume )
			iMusicVolume=5;

		class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.MusicVolumeSliderCtrl", iMusicVolume);

		// 시스템음성 - SystemVolumeSliderCtrl
		fWavVoiceVolume = GetOptionFloat( "Audio", "WavVoiceVolume" );
		gWavVoiceVolume = fWavVoiceVolume;

		if( 0.0f <= fWavVoiceVolume && fWavVoiceVolume < 0.2f )
			iSystemVolume=0;
		else if( 0.2f <= fWavVoiceVolume && fWavVoiceVolume < 0.4f )
			iSystemVolume=1;
		else if( 0.4f <= fWavVoiceVolume && fWavVoiceVolume < 0.6f )
			iSystemVolume=2;
		else if( 0.6f <= fWavVoiceVolume && fWavVoiceVolume < 0.8f )
			iSystemVolume=3;
		else if( 0.8f <= fWavVoiceVolume && fWavVoiceVolume < 1.0f )
			iSystemVolume=4;
		else if( 1.0f <= fWavVoiceVolume )
			iSystemVolume=5;

		class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.SystemVolumeSliderCtrl", iSystemVolume);


		// 튜토리얼음성	- TutorialBox
		fOggVoiceVolume = GetOptionFloat( "Audio", "OggVoiceVolume" );
		gOggVoiceVolume = fOggVoiceVolume;
			
		if( 0.0f <= fOggVoiceVolume && fOggVoiceVolume < 0.2f )
			iTutorialVolume=0;
		else if( 0.2f <= fOggVoiceVolume && fOggVoiceVolume < 0.4f )
			iTutorialVolume=1;
		else if( 0.4f <= fOggVoiceVolume && fOggVoiceVolume < 0.6f )
			iTutorialVolume=2;
		else if( 0.6f <= fOggVoiceVolume && fOggVoiceVolume < 0.8f )
			iTutorialVolume=3;
		else if( 0.8f <= fOggVoiceVolume && fOggVoiceVolume < 1.0f )
			iTutorialVolume=4;
		else if( 1.0f <= fOggVoiceVolume )
			iTutorialVolume=5;

		class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.TutorialVolumeSliderCtrl", iTutorialVolume);
	
		m_iPrevSoundTick=iSoundVolume;
		m_iPrevMusicTick=iMusicVolume;
		m_iPrevSystemTick=iSystemVolume;
		m_iPrevTutorialTick=iTutorialVolume;
	}
	else
	{
		class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.EffectVolumeSliderCtrl");
		class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.MusicVolumeSliderCtrl");
		class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.SystemVolumeSliderCtrl");
		class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.TutorialVolumeSliderCtrl");
	}
	

	
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.mutecheckbox" ) )
		{
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.EffectVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.MusicVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.SystemVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.TutorialVolumeSliderCtrl");
				

//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.EffectBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.MusicBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.SystemBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.TutorialBox" );
			

			SetSoundVolume( 0.f );
			SetMusicVolume( 0.f );
			SetWavVoiceVolume( 0.f );
			SetOggVoiceVolume( 0.f );
			SetOptionBool("Audio", "AudioMuteOn", true);
			
		}
		else
		{
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.EffectBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.MusicBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.SystemBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.TutorialBox" );
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.EffectVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.MusicVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.SystemVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.TutorialVolumeSliderCtrl");
		}
	
}

function InitGameOption()
{
	local bool bShowOtherPCName;
	local int nOption;
	local bool bOption;

	// 투명화 - OpacityBox
	bOption = GetOptionBool( "Game", "TransparencyMode" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.OpacityBox", bOption );

	// 언어선택 - LanguageBox
	bOption = GetOptionBool( "Game", "IsNative" );
	if( bOption )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.LanguageBox", 0 );
	else
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.LanguageBox", 1 );
	
	// 자신이름 - NameBox0
	bOption = GetOptionBool( "Game", "MyName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox0", bOption );

	// 몬스터이름 - NameBox1
	bOption = GetOptionBool( "Game", "NPCName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox1", bOption );

	// 다른PC이름 - NameBox2
	bShowOtherPCName = GetOptionBool( "Game", "GroupName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox2", bShowOtherPCName );

	// 혈맹이름 - NameBox3
	bOption = GetOptionBool( "Game", "PledgeMemberName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox3", bOption );

	// 파티이름	- NameBox4
	bOption = GetOptionBool( "Game", "PartyMemberName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox4", bOption );

	// 일반이름	- NameBox5
	bOption = GetOptionBool( "Game", "OtherPCName" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.NameBox5", bOption );

	if( bShowOtherPCName ) 
	{
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox3" );
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox4" );
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox5" );
	}
	else
	{
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox3" );
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox4" );
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox5" );
	}

	// 엔터체팅	- EnterChatBox
	//~ bOption = GetOptionBool( "Game", "EnterChatting" );
	//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.EnterChatBox", bOption );

	// 채팅기호	- OldChatBox
	bOption = GetOptionBool( "Game", "OldChatting" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.OldChatBox", bOption );
		
	// 시스템 튜토리얼
	bOption = GetOptionBool( "Game", "SystemTutorialBox" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.SystemTutorialBox", bOption );
	SetTutorialData(bOption);

	//PC방 포인트 끄기 - PCPointBox
	// bOption = GetOptionBool( "Game", "IsPCPointBox" );
	// class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.PCPointBox", bOption );
	// SetPCPointBoxData();

	// 유니버설 툴팁
	bOption = GetOptionBool( "Game", "UniversalToolTipBox" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.UniversalToolTipBox", bOption );
	
	// 툴팁위치
	nOption = GetOptionInt( "Game", "ToolTipPositionBox" );
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ToolTipPositionBox", nOption );
		
	//~ SetToolTipData(GetOptionBool( "Game", "UniversalToolTipBox" ), GetOptionInt( "Game", "ToolTipPositionBox" ));

	// 키보드보안 - KeyboardBox
	if( IsUseKeyCrypt() )
	{
		if( IsCheckKeyCrypt() )
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.KeyboardBox", true );
		else
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.KeyboardBox", false );

		if( IsEnableKeyCrypt() )
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.KeyboardBox" );
		else
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.KeyboardBox" );
	}
	else
	{
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.KeyboardBox", false );
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.KeyboardBox" );
	}

	// 게임패드	- Box
	bOption = GetOptionBool( "Game", "UseJoystick" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.JoypadBox", bOption );
	if( CanUseJoystick() )
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.JoypadBox" );
	else
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.JoypadBox" );
		
	//마우스우클릭 - RightClickBox
	
	bOption = GetOptionBool( "Game", "RightClickBox" );
	//~ debug ("마우ㅠ스 우클릭" @ bOption);
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.RightClickBox", bOption );
	/*bOption = GetOptionBool( "Game", "RightClickBox");
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.RightClickBox",bOption );
	if( !CanUseRightClick())
		 class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.RightClickBox" );
	else
		 class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.RightClickBox" );*/
	// 카메라추적 - CameraBox
	bOption = GetOptionBool( "Game", "AutoTrackingPawn" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.CameraBox", bOption );

	// 그래픽커서 - CursorBox
	bOption = GetOptionBool( "Video", "UseColorCursor" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.CursorBox", bOption );

	// 3D화살표	- ArrowBox
	bOption = GetOptionBool( "Game", "ArrowMode" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ArrowBox", bOption );

	// 지역명표시 - ZoneNameBox
	bOption = GetOptionBool( "Game", "ShowZoneTitle" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ZoneNameBox", bOption );

	// 게임팁 표시 - ShowGameTipMsg
	bOption = GetOptionBool( "Game", "ShowGameTipMsg" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GametipBox", bOption );
		
	// 결투 거부 - DuelBox
	bOption = GetOptionBool( "Game", "IsRejectingDuel" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.DuelBox", bOption );
	
	//파티 신청 거부 - PartyRejectBox
	bOption = GetOptionBool( "Game", "IsRejectingParty" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.PartyRejectBox", bOption );

	//커플 신청 거부 - CoupleActionBox
	bOption = GetOptionBool( "Game", "IsCoupleAction" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.CoupleActionBox", bOption );

	// 드롭된 아이템 표시
	bOption = GetOptionBool( "Game", "HideDropItem");
	class'UIAPI_CHECKBOX'.static.SetCheck("OptionWnd.DropItemBox", bOption);
		
	//백그라운드 실행성능 낮추기
	bOption = GetOptionBool( "Game", "UseLazyMode");
	//~ debug("레이지모드가져온 데이터"@ bOption);
	class'UIAPI_CHECKBOX'.static.SetCheck("OptionWnd.LazyModeBox", bOption);
	
	// 시스템메시지전용창 - SystemMsgBox
	/*
	bSystemMsgWnd = GetOptionBool( "Game", "SystemMsgWnd" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.SystemMsgBox", bSystemMsgWnd );
	
	// 데미지 - DamageBox
	bOption = GetOptionBool( "Game", "SystemMsgWndDamage" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.DamageBox", bOption );

	// 소모성아이템사용 - ItemBox
	bOption = GetOptionBool( "Game", "SystemMsgWndExpendableItem" );
	class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ItemBox", bOption );

	if( bSystemMsgWnd )
	{
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.DamageBox" );
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.ItemBox" );
	}
	else
	{
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.DamageBox" );
		class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.ItemBox" );
	}
	*/

	// 파티루팅 - LootingBox
	nOption = GetOptionInt( "Game", "PartyLooting" );
	if( class'UIAPI_WINDOW'.static.IsEnableWindow( "OptionWnd.LootingBox" ) )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.LootingBox", nOption );
	
	//RefreshLootingBox();
}

function OnClickCheckBox( String strID )
{
	//~ debug( strID );

	switch( strID )
	{
	case "NameBox2":
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox2" ) )
		{
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox3" );
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox4" );
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.NameBox5" );
		}
		else
		{
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox3" );
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox4" );
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.NameBox5" );
		}
		break;
	case "SystemMsgBox":
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.SystemMsgBox" ) )
		{
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.DamageBox" );
			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.ItemBox" );
		}
		else
		{
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.DamageBox" );
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.ItemBox" );
		}
		break;
	case "FrameBox":
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.FrameBox" ) )
			MinFrameRateOn();
		else
			MinFrameRateOff();
		break;
	case "mutecheckbox":
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.mutecheckbox" ) )
		{
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.EffectVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.MusicVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.SystemVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.DisableWindow("OptionWnd.TutorialVolumeSliderCtrl");
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.EffectBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.MusicBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.SystemBox" );
//			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.TutorialBox" );
		}
		else
		{
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.EffectBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.MusicBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.SystemBox" );
//			class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.TutorialBox" );
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.EffectVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.MusicVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.SystemVolumeSliderCtrl");
			class'UIAPI_SLIDERCTRL'.static.EnableWindow("OptionWnd.TutorialVolumeSliderCtrl");
		}
		break;
	case "S30Box":
		//셰이더 3.0
	
		
		if ( nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30)
		{
			if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30Box" ) )
			{
				//~ debug("s30지원가 - 활성");
				//class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.GPUAnimationCheckBox" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
				// 2007/11/16 Options should only be disabled not unchecked - NeverDie
				//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GPUAnimationCheckBox", false );
				//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ReflectBox", false );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30DOFBOX" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30WaterEffectBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30ShadowBox" );
			}
			else
			{
				//~ debug("s30지원가 - 비활성");
				//class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.GPUAnimationCheckBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
				// 2007/11/16 Options should only be disabled not unchecked - NeverDie
				//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
				//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
				//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
			}
		}
		else
			
		{
			//~ debug("s30지원불가");
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30Box" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30Box", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
		}
	break;
	}
}

function OnShow()
{
	//~ local ShortcutAssignWnd script;
	local ComboBoxHandle c_handle;
	bShow = true;

	
	InitVideoOption();
	InitAudioOption();
	InitGameOption();

	//~ script.OnShow();
	class'ShortcutAPI'.static.UnlockShortcut();
	KeySettingInput.HideWindow();
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();

	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	// debug("show type is");
	
//	Lootingtype = c_handle.GetSelectedNum();

}

function OnHide()
{
	bShow = false;
	class'ShortcutAPI'.static.UnlockShortcut();
}

function ApplyVideoOption()
{
	local bool bKeepMinFrameRate;
	local bool bTrilinear;
	local int nTextureDetail;
	local int nModelDetail;
	local int nMotionDetail;
	local int nTerrainClippingRange;
	local int nPawnClippingRange;
	local int nReflectionEffect;
	local int nHDR;
	local int nWeatherEffect;
	//~ local int nSelectedNum;
	//local float fPawnClippingRange;
	//local float fStaticMeshClippingRange;
	//local float fActorClippingRange;
	//local float fTerrainClippingRange;
	//local float fStaticMeshLodClippingRange;
	local int nSelectedNum;
	local float fGamma;
	local bool bRenderDeco;
	local bool bShadow;
	local int nResolutionIndex;
	local int nRefreshRateIndex;
	//~ local bool bIsChecked;
	local bool bGPUAnimation;
	local bool bL2Shader;
	local bool bDOF;
	local bool bShaderWater;
	local bool bDepthBufferShadow;
	local bool UnappliedOptionChange;	// In order to apply option change, loading is required.
	local int iNumTick;
	local int iPawnValue;
	local int RenderActorLimitOpt;

	UnappliedOptionChange = false;

	// 텍스쳐필터링 - TriBox
	bTrilinear = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.TriBox" );
	SetOptionBool( "Video", "UseTrilinear", bTrilinear );

	// 텍스쳐디테일 - TextureBox
	nTextureDetail = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.TextureBox" );
	SetOptionInt( "Video", "TextureDetail", nTextureDetail );

	// 모델링디테일 - ModelBox
	nModelDetail = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.ModelBox" );
	SetOptionInt( "Video", "ModelDetail", nModelDetail );

	// 모션디테일 - AnimBox
	nMotionDetail = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.AnimBox" );
	SetOptionInt( "Video", "SkipAnim", nMotionDetail );

	// 시야-캐릭터 - CharBox
	nPawnClippingRange = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.CharBox" );
	SetOptionInt( "Video", "PawnClippingRange", nPawnClippingRange );

	// 시야-지형 - TerrainBox
	nTerrainClippingRange = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.TerrainBox" );
	SetOptionInt( "Video", "TerrainClippingRange", nTerrainClippingRange );

	// 감마값 - GammaBox
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.GammaBox" );
	switch( nSelectedNum )
	{
	case 0:
		fGamma = 1.2f;
		break;
	case 1:
		fGamma = 1.0f;
		break;
	case 2:
		fGamma = 0.8f;
		break;
	case 3:
		fGamma = 0.6f;
		break;
	case 4:
		fGamma = 0.4f;
		break;
	}
	SetOptionFloat( "Video", "Gamma", fGamma );

	// 화질개선셰이더 - HDRBox
	nHDR = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.HDRBox" );
	SetOptionInt( "Video", "PostProc", nHDR );

	// 배경효과 - DecoBox
	bRenderDeco = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.DecoBox" );
	SetOptionBool( "Video", "RenderDeco", bRenderDeco );

	// 그림자 - ShadowBox
	bShadow = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.ShadowBox" );
	SetOptionBool( "Video", "PawnShadow", bShadow );

	// 반사효과 - ReflectBox
	nReflectionEffect = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.ReflectBox" );
	SetOptionInt( "L2WaterEffect", "EffectType", nReflectionEffect );
	if( 0 == nReflectionEffect )
		SetOptionBool( "L2WaterEffect", "IsUseEffect", false );
	else
		SetOptionBool( "L2WaterEffect", "IsUseEffect", true );

	// 캐릭터표시제한 - RenderCharacterCount
	RenderActorLimitOpt = class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("OptionWnd.CharacterLimitSliderCtrl");
	iNumTick = class'UIAPI_SLIDERCTRL'.static.GetTotalTickCount("OptionWnd.CharacterLimitSliderCtrl");

	iPawnValue = GetPawnValue( RenderActorLimitOpt, iNumTick, RENDERCHARACTERLIMIT_MIN, RENDERCHARACTERLIMIT_MAX );

	class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.CharacterLimitSliderCtrl", RenderActorLimitOpt);
	SetOptionInt( "Video", "RENDERCHARACTERCOUNT", iPawnValue );
	SetOptionInt( "Video", "RenderActorLimitOpt", RenderActorLimitOpt );

	// 안티알리아싱	- AABox
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.AABox" );
	SetOptionInt( "Video", "AntiAliasing", nSelectedNum );

	// 스크린샷 품질 - CaptureBox
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.CaptureBox" );
	SetOptionInt( "Game", "ScreenShotQuality", nSelectedNum );

	// 해상도 - ResBox
	// 주사율 - RefreshRateBox
	nResolutionIndex = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.ResBox" );
	nRefreshRateIndex = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.RefreshRateBox" );
	SetResolution( nResolutionIndex, nRefreshRateIndex );

	///////////////////////////////////////////
	// Added on 2006/03/21 by NeverDie

	// 기상효과 - WeatherEffectComboBox
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.WeatherEffectComboBox" );
	switch( nSelectedNum )
	{
	case 0:
		nWeatherEffect = 0;
		break;
	case 1:
		nWeatherEffect = 1;
		break;
	case 2:
		nWeatherEffect = 2;
		break;
	case 3:
		nWeatherEffect = 3;
		break;
	}
	SetOptionInt( "Video", "WeatherEffect", nWeatherEffect );

	// GPU애니메이션 - GPUAnimationCheckBox
	bGPUAnimation = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.GPUAnimationCheckBox" );
	SetOptionBool( "Video", "GPUAnimation", bGPUAnimation );
	
	// 최소프레임유지 - FrameBox
	bKeepMinFrameRate = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.FrameBox" );
	SetOptionBool( "Video", "IsKeepMinFrameRate", bKeepMinFrameRate );

	//셰이더 3.0
	bL2Shader = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30Box" );
	SetOptionBool( "Video", "L2Shader", bL2Shader );
	
	//셰이더 3.0 - DOF?
	bDOF = class'UIAPI_CHECKBOX'.static.IsEnableWindow( "OptionWnd.S30DOFBOX" ) && class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30DOFBOX" );
	SetOptionBool( "Video", "S30DOFBOX", bDOF );
	
	//셰이더 3.0 - 물효과
	bShaderWater = class'UIAPI_CHECKBOX'.static.IsEnableWindow( "OptionWnd.S30WaterEffectBox" ) && class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30WaterEffectBox" );
	SetOptionBool( "Video", "S30WaterEffectBox", bShaderWater );
	
	//셰이더 3.0 - 그림자.
	bDepthBufferShadow = class'UIAPI_CHECKBOX'.static.IsEnableWindow( "OptionWnd.S30ShadowBox" ) && class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30ShadowBox" );
	SetOptionBool( "Video", "S30ShadowBox", bDepthBufferShadow );
	
	if( bKeepMinFrameRate )
	{
		//~ debug( "KeepMinFrameRate" );
		SetTextureDetail( 2 );
		SetModelingDetail( 1 );
		SetMotionDetail( 1 );
		SetShadow( false );
		SetBackgroundEffect( false );
		SetTerrainClippingRange( 4 );
		SetPawnClippingRange( 4 );
		//~ SetRenderCharacterCount(RENDERCHARACTERLIMIT_MIN);
		SetReflectionEffect( 0 );
		//~ Debug("HDRSettingOff");
		SetHDR( 0 );
		SetWeatherEffect( 0 );
		SetL2Shader(false);
		SetDOF(false);
		SetShaderWaterEffect(false);
		SetDepthBufferShadow(false);
		m_bL2Shader = false;			
		m_bDOF = false;
		m_bShaderWater = false;
		m_bDepthBufferShadow = false;

		// 2007/11/16 Set UnappliedOptionChange to false because options are all applied right above - NeverDie
		UnappliedOptionChange = false;
	}
	else 
	{
		//~ debug( "Not KeepMinFrameRate nTextureDetail=" $ nTextureDetail );
		SetTextureDetail( nTextureDetail );
		SetModelingDetail( nModelDetail );
		SetMotionDetail( nMotionDetail );
		SetShadow( bShadow );
		SetBackgroundEffect( bRenderDeco );
		
		//solasys-포그테스트
		if (m_bAirState)
		{
			SetTerrainClippingRange( 2 );
			SetPawnClippingRange( 2 );
		}
		else
		{
			SetTerrainClippingRange( nTerrainClippingRange );
			SetPawnClippingRange( nPawnClippingRange );
		}
		//SetRenderCharacterCount(nRenderCharacterLimit);
		SetReflectionEffect( nReflectionEffect );
		SetHDR( nHDR );
		//~ debug ("HDR" @ nHDR);
		SetWeatherEffect( nWeatherEffect );

		// See if there is an unapplied option

		if( m_bL2Shader != bL2Shader )
		{
			if( bL2Shader )
				UnappliedOptionChange = true;
			m_bL2Shader = bL2Shader;			
		}

		// If L2Shader is off, all other options can be applied right away.
		if( bL2Shader )
		{
			if( m_bDOF != bDOF )
			{
				UnappliedOptionChange = true;
				m_bDOF = bDOF;
			}

			if( m_bShaderWater != bShaderWater )
			{
				UnappliedOptionChange = true;
				m_bShaderWater = bShaderWater;
			}

			if( m_bDepthBufferShadow != bDepthBufferShadow )
			{
				UnappliedOptionChange = true;
				m_bDepthBufferShadow = bDepthBufferShadow;
			}
		}

		if( !UnappliedOptionChange )
		{
			SetL2Shader(bL2Shader);
			SetDOF(bDOF);
			SetShaderWaterEffect(bShaderWater);
			SetDepthBufferShadow(bDepthBufferShadow);
		}
	}

	//UI 기본 세팅
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.DefaultPositionBox" );
	//~ Debug ("기본 레이아웃 번호 설정:" @ nSelectedNum);
	SetOptionInt( "Game", "LayoutDF", nSelectedNum );

	// In case of option change which requires loading, show warning dialog box - NeverDie
	//~ debug( "UnappliedOptionChange " $ UnappliedOptionChange );
	if( UnappliedOptionChange )
	{
		DialogSetID( OPTION_CHANGE );
		DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 2191 ) );
	}
	//~ InitVideoOption();
}

function ApplyAudioOption()
{
	//local int nSelectedNum;
	local float fSoundVolume;
	local float fMusicVolume;
	local float fWavVoiceVolume;
	local float fOggVoiceVolume;


	local int iSoundTick;
	local int iMusicTick;
	local int iSystemTick;
	local int iTutorialTick;

	if( !CanUseAudio() )
		return;
	// code 변경 - lancelot 2006. 6. 13.
	// 효과음볼륨 - EffectVolumeSliderCtrl
	iSoundTick=class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("OptionWnd.EffectVolumeSliderCtrl");
	fSoundVolume=GetVolumeFromSliderTick(iSoundTick);
	SetOptionFloat("Audio", "SoundVolume", fSoundVolume);
	gSoundVolume=fSoundVolume;

	// 음악볼륨 - MusicVolumeSliderCtrl
	iMusicTick=class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("OptionWnd.MusicVolumeSliderCtrl");
	fMusicVolume=GetVolumeFromSliderTick(iMusicTick);
	SetOptionFloat("Audio", "MusicVolume", fMusicVolume);
	gMusicVolume=fMusicVolume;

	// 시스템볼륨 - SystemVolumeSliderCtrl
	iSystemTick=class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("OptionWnd.SystemVolumeSliderCtrl");
	fWavVoiceVolume=GetVolumeFromSliderTick(iSystemTick);
	SetOptionFloat("Audio", "WavVoiceVolume", fWavVoiceVolume);
	gWavVoiceVolume=fWavVoiceVolume;

	// 음악볼륨 - MusicVolumeSliderCtrl
	iTutorialTick=class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("OptionWnd.TutorialVolumeSliderCtrl");
	fOggVoiceVolume=GetVolumeFromSliderTick(iTutorialTick);
	SetOptionFloat("Audio", "OggVoiceVolume", fOggVoiceVolume);
	gOggVoiceVolume=fOggVoiceVolume;


	// 기억시켜준다
	m_iPrevSoundTick=iSoundTick;
	m_iPrevMusicTick=iMusicTIck;
	m_iPrevSystemTick=iSystemTick;
	m_iPrevTutorialTick=iTutorialtick;

	if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.mutecheckbox" ) )
	{
		SetSoundVolume( 0.f );
		SetMusicVolume( 0.f );
		SetWavVoiceVolume( 0.f );
		SetOggVoiceVolume( 0.f );
		SetOptionBool("Audio", "AudioMuteOn", true);
	}
	else
	{
		SetOptionBool( "Audio", "AudioMuteOn", false);
	}

/*	없어도 될거같아서 삭제 - lancelot 2006. 6. 13.
	else
	{
		SetSoundVolume( gSoundVolume );
		SetMusicVolume( gMusicVolume);
		SetWavVoiceVolume( gWavVoiceVolume);
		SetOggVoiceVolume( gOggVoiceVolume );
	}
*/

}

function ApplyGameOption()
{
	local int nSelectedNum;
	local bool bChecked;

	// 언어선택 - LanguageBox
	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.LanguageBox" );
	if( 0 == nSelectedNum )
		SetOptionBool( "Game", "IsNative", true );
	else if( 1 == nSelectedNum )
		SetOptionBool( "Game", "IsNative", false );

	// 자신이름 - NameBox0
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox0" );
	SetOptionBool( "Game", "MyName", bChecked );

	// 몬스터이름 - NameBox1
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox1" );
	SetOptionBool( "Game", "NPCName", bChecked );

	// 혈맹이름 - NameBox3
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox3" );
	SetOptionBool( "Game", "PledgeMemberName", bChecked );

	// 파티이름	- NameBox4
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox4" );
	SetOptionBool( "Game", "PartyMemberName", bChecked );

	// 일반이름	- NameBox5
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox5" );
	SetOptionBool( "Game", "OtherPCName", bChecked );

	// 다른PC이름 - NameBox2
	// 다른 이름 관련 옵션이 모두 적용되고 나서 덮어써야 하므로, 제일 나중에 해야한다. - NeverDie
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.NameBox2" );
	SetOptionBool( "Game", "GroupName", bChecked );

	// 투명화 - OpacityBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.OpacityBox" );
	SetOptionBool( "Game", "TransparencyMode", bChecked );

	// 3D화살표 - ArrowBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.ArrowBox" );
	SetOptionBool( "Game", "ArrowMode", bChecked );

	// 카메라추적 - CameraBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.CameraBox" );
	SetOptionBool( "Game", "AutoTrackingPawn", bChecked );

	// 엔터채팅 - EnterChatBox
	//~ bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.EnterChatBox" );
	//~ SetOptionBool( "Game", "EnterChatting", bChecked );

	// 채팅기호 - OldChatBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.OldChatBox" );
	SetOptionBool( "Game", "OldChatting", bChecked );

	// 지역명표시 - ZoneNameBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.ZoneNameBox" );
	SetOptionBool( "Game", "ShowZoneTitle", bChecked );
	
	// 게임팁표시 - GametipBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.GametipBox" );
	SetOptionBool( "Game", "ShowGameTipMsg", bChecked );
	
	// 결투 거부 - DuelBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.DuelBox" );
	SetOptionBool( "Game", "IsRejectingDuel", bChecked );
	
	// 파티 신청 거부 - PartyRejectBox
  	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.PartyRejectBox" );
	SetOptionBool( "Game", "IsRejectingParty", bChecked );
	SetIgnorePartyInviting(bChecked );
	//m_bPartyRejected = bChecked;

	//커플 신청 거부 - CoupleActionBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.CoupleActionBox" );
	SetOptionBool( "Game", "IsCoupleAction", bChecked );
	//SetIgnorePartyInviting(bChecked );

	// 드랍 아이템 - DropItemBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.DropItemBox" );
	SetOptionBool( "Game", "HideDropItem", bChecked );

	// 시스템 튜토리얼
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.SystemTutorialBox" );
	SetOptionBool( "Game", "SystemTutorialBox", bChecked );
	SetTutorialData(bChecked);
		
	//PC방 포인트 끄기 - PCPointBox
	// bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.PCPointBox" );
	// SetOptionBool( "Game", "IsPCPointBox", bChecked );
	// SetPCPointBoxData();

	// 유니버설 툴팁
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.UniversalToolTipBox" );
	SetOptionBool( "Game", "UniversalToolTipBox", bChecked );
	
	// 유니버설 툴팁 박스  데이터 세팅

	nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.ToolTipPositionBox" );
	SetOptionInt( "Game", "ToolTipPositionBox", nSelectedNum );

	//~ SetToolTipData(GetOptionBool( "Game", "UniversalToolTipBox" ), GetOptionInt( "Game", "ToolTipPositionBox" ));
		
	// 파티루팅 - LootingBox
	if( class'UIAPI_WINDOW'.static.IsEnableWindow( "OptionWnd.LootingBox" ) )
	{
		nSelectedNum = class'UIAPI_COMBOBOX'.static.GetSelectedNum( "OptionWnd.LootingBox" );
		SetOptionInt( "Game", "PartyLooting", nSelectedNum );
		
	//	Lootingtype = nSelectedNum;
	}

	// 그래픽커서 - CursorBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.CursorBox" );
	SetOptionBool( "Video", "UseColorCursor", bChecked );
	
	//Background 실행성능 낮추기
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked("OptionWnd.LazyModeBox");
	SetOptionBool( "Game", "UseLazyMode", bChecked);
	//~ debug("레이지모드"@ bChecked);
	

	// 시스템메시지전용창 - SystemMsgBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.SystemMsgBox" );
	SetOptionBool( "Game", "SystemMsgWnd", bChecked );

	// 데미지 - DamageBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.DamageBox" );
	SetOptionBool( "Game", "SystemMsgWndDamage", bChecked );

	// 소모성아이템사용 - ItemBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.ItemBox" );
	SetOptionBool( "Game", "SystemMsgWndExpendableItem", bChecked );

	// 게임패드	- JoypadBox
	if( CanUseJoystick() )
	{
		bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.JoypadBox" );
		SetOptionBool( "Game", "UseJoystick", bChecked );
	}
	
	//마우스 우클릭 - RightClickBox
	

	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.RightClickBox" );
	SetOptionBool( "Game", "RightClickBox", bChecked );
	SetFixedDefaultCamera(bChecked);

	
	// 키보드보안 - KeyboardBox
	if( IsUseKeyCrypt() )
	{
		bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.KeyboardBox" );
		SetOptionBool("Game", "L2UseKeyCrypt", bChecked);
		SetKeyCrypt( bChecked );
	}	
}

function OnClickButton( string strID )
{
	//~ Debug( strID );

	switch( strID )
	{
	case "VideoCancelBtn":
	case "AudioCancelBtn":
	case "GameCancelBtn":
		SetOptionInt( "FirstRun", "FirstRun", 2 );

		// 되돌려준다 - lancelot 2006. 6. 13. 수정 문선준. 2011.3.8.
		if( GetOptionBool( "Audio", "AudioMuteOn" ) == false )
		{
			OnModifyCurrentTickSliderCtrl("EffectVolumeSliderCtrl", m_iPrevSoundTick);
			OnModifyCurrentTickSliderCtrl("MusicVolumeSliderCtrl", m_iPrevMusicTick);
			OnModifyCurrentTickSliderCtrl("SystemVolumeSliderCtrl", m_iPrevSystemTick);
			OnModifyCurrentTickSliderCtrl("TutorialVolumeSliderCtrl", m_iPrevTutorialTick);
		}

		class'UIAPI_Window'.static.HideWindow( "OptionWnd" );
		break;
	case "VideoOKBtn":
	case "AudioOKBtn":
	case "GameOKBtn":
		ApplyVideoOption();
		ApplyAudioOption();
		ApplyGameOption();
		SetOptionInt( "FirstRun", "FirstRun", 2 );
		class'UIAPI_Window'.static.HideWindow( "OptionWnd" );
		break;
	case "VideoApplyBtn":
	case "AudioApplyBtn":
	case "GameApplyBtn":
		ApplyVideoOption();
		ApplyAudioOption();
		ApplyGameOption();
		break;
	case "WindowInitBtn":
		
		GetCurrentResolution(g_CurrentMaxWidth, g_CurrentMaxHeight);
		SetDefaultPosition();

		break;
	}
}



// Slider control의 tick 으로부터 volume의 float값을 구하는 함수
function float GetVolumeFromSliderTick(int iTick)
{
	local float fReturnVolume;
	switch(iTick)
	{
	case 0 :
		fReturnVolume=0.0f;
		break;
	case 1 :
		fReturnVolume=0.2f;
		break;
	case 2 :
		fReturnVolume=0.4f;
		break;
	case 3 :
		fReturnVolume=0.6f;
		break;
	case 4 :
		fReturnVolume=0.8f;
		break;
	case 5 :
		fReturnVolume=1.0f;
		break;
	}

	return fReturnVolume;
}

//solasys-포그테스트
function AirStateOn()
{
	m_bAirState=true;
	
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.TerrainBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.CharBox" );
}

function AirStateOff()
{
	m_bAirState=false;
	
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.TerrainBox" );
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.CharBox" );
	
	if( nPixelShaderVersion < 12 )
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 0 );
	}
	else
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );

	if( nPixelShaderVersion >= 20 && nVertexShaderVersion >= 20 )
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.HDRBox" );
	else
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.HDRBox" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.HDRBox", 0 );
	}
	/////////////////////////////////////////////
	//  Added on 2007/05/25 by Oxyzen
	if ( nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30)
	{
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30Box" );
			if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30Box" ) )
			{
				//~ debug("s30지원가 - 활성");
				
				//class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.GPUAnimationCheckBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GPUAnimationCheckBox", false );
				//~ class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ShadowBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ShadowBox", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ReflectBox", false );
				//~ class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30Box" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30DOFBOX" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30WaterEffectBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30ShadowBox" );
			}
			else
			{
				//~ debug("s30지원가 - 비활성");
				//class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.GPUAnimationCheckBox" );
				//~ class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ShadowBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
			}
		}
		else
			
		{
			//~ debug("s30지원불가");
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30Box" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30Box", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
		}
}	
//solasys-end

function MinFrameRateOn()
{
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.TextureBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ModelBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.AnimBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ShadowBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.DecoBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.TerrainBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.CharBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.HDRBox" );
	/////////////////////////////////////////////
	//  Added on 2007/05/25 by Oxyzen
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30Box" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
	// 2007/11/16 Options should only be disabled not unchecked - NeverDie
	//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30Box", false );
	//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
	//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
	//class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
	///////////////////////////////////////////
	// Added on 2006/03/21 by NeverDie
	class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.WeatherEffectComboBox" );
}



function MinFrameRateOff()
{
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.TextureBox" );
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ModelBox" );
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.AnimBox" );
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ShadowBox" );
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.DecoBox" );
	
	//solasys-포그테스트
	if(!m_bAirState)
	{
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.TerrainBox" );
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.CharBox" );
	}

	///////////////////////////////////////////
	// Added on 2006/03/21 by NeverDie
	class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.WeatherEffectComboBox" );

	if( nPixelShaderVersion < 12 )
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.ReflectBox", 0 );
	}
	else
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );

	if( nPixelShaderVersion >= 20 && nVertexShaderVersion >= 20 )
		class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.HDRBox" );
	else
	{
		class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.HDRBox" );
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( "OptionWnd.HDRBox", 0 );
	}
	/////////////////////////////////////////////
	//  Added on 2007/05/25 by Oxyzen
	if ( nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30)
	{
			class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30Box" );
			if( class'UIAPI_CHECKBOX'.static.IsChecked( "OptionWnd.S30Box" ) )
			{
				//~ debug("s30지원가 - 활성");
				
				//class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.GPUAnimationCheckBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.GPUAnimationCheckBox", false );
				//~ class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ShadowBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ShadowBox", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.ReflectBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.ReflectBox", false );
				//~ class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30Box" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30DOFBOX" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30WaterEffectBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.S30ShadowBox" );
			}
			else
			{
				//~ debug("s30지원가 - 비활성");
				//class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.GPUAnimationCheckBox" );
				//~ class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ShadowBox" );
				class'UIAPI_WINDOW'.static.EnableWindow( "OptionWnd.ReflectBox" );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
				class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
				//~ class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
			}
		}
		else
			
		{
			//~ debug("s30지원불가");
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30Box" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30Box", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30DOFBOX" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30DOFBOX", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30WaterEffectBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30WaterEffectBox", false );
			class'UIAPI_WINDOW'.static.DisableWindow( "OptionWnd.S30ShadowBox" );
			class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.S30ShadowBox", false );
		}
	
	
}

function OnEvent( int a_EventID, String a_Param )
{
	local bool bMinFrameRate;

	

	switch( a_EventID )
	{
	
	case EV_DialogOK:
		
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		HandleDialogCancel();
		break;

	case EV_MinFrameRateChanged:
		InitVideoOption();
		bMinFrameRate = GetOptionBool( "Video", "IsKeepMinFrameRate" );
		class'UIAPI_CHECKBOX'.static.SetCheck( "OptionWnd.FrameBox", bMinFrameRate );
		if( bMinFrameRate ) 
			MinFrameRateOn();
		else
			MinFrameRateOff();
		ApplyVideoOption();
		break;
	case EV_PartyMemberChanged:
//		RefreshLootingBox();
		break;
	case EV_DialogCancel:
		break;
	//solasys-포그테스트
	case EV_AirStateOn:
		AirStateOn();
		ApplyVideoOption();
		break;
	case EV_AirStateOff:
		AirStateOff();
		ApplyVideoOption();
		break;
	//solasys-end


	/////파티루팅관련 이벤트//////////////////jdh84
	case EV_AskPartyLootingModify: //파티루팅변경 신청 들어옴
		OnAskPartyLootingModify(a_Param);
		break;
	
	case EV_PartyLootingHasModified: //파티루팅변경 결과 알려옴
		OnPartyLootingHasModified(a_Param);
		break;

	case EV_WithdrawParty: //탈퇴하거나
	case EV_OustPartyMember: //추방당하거나
	case EV_PartyHasDismissed: //파티가 해산될때
		bPartyMember = false;
		bPartyMaster = false;
		OnPartyHasDismissed();
		break;
	case EV_BecamePartyMember://파티의 멤버가됨
		bPartyMember = true;
		bPartyMaster = false;
		OnBecamePartyMember(a_Param);
		break;
	case EV_BecamePartymaster://파티장이됨		
		bPartyMember = false;
		bPartyMaster = true;
		OnBecamePartyMaster(a_Param);
		break;
	case EV_HandOverPartyMaster: //파티장을 양도함
		bPartyMember = true;
		bPartyMaster = false;
		OnHandOverPartyMaster();
		break;;
	case EV_RecvPartyMaster: //파티장을 양도받음
		bPartyMember = false;
		bPartyMaster = true;
		OnRecvPartyMaster();
		break;;
	case EV_Restart: //리스타트
		bPartyMember = false;
		bPartyMaster = false;
		OnRestart();
		break;
// 	case EV_PartyMatchRoomStart:
// 		bPartyRoomMaster = true;
// 		break;
 	case EV_PartyMatchRoomClose:
		OnPartyMatchRoomClose();
// 		bPartyRoomMaster = false;
 		break;
	}
}

///////////////지금부터 파티루팅변경 관련 코드가 들어갑니다//////////////////////////////////////////////////////////////////////////////////////////
//
//		파티루팅을 옵션창에서 변경하는 관계로 여기에다 넣었음
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function OnPartyMatchRoomClose()
{
	local ComboBoxHandle c_handle;
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	if (!bPartyMember && !bPartyMaster)
		c_handle.SetSelectedNum(GetOptionInt( "Game", "PartyLooting"));
}

function OnPartyHasDismissed()
{
	local ComboBoxHandle c_handle;
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	c_handle.SetSelectedNum(GetOptionInt( "Game", "PartyLooting"));
	class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );
	//파티가 해제,탈퇴,추방되면 자신이 설정한 루팅방식으로 돌아간다. 
	//파티장도 마찬가지(루팅변경시 파티장은 저장된다)
}


function OnBecamePartyMember(string a_Param) //파티원이 됨
{
	local int Lootingtype;
	local ComboBoxHandle c_handle;
	ParseInt(a_Param, "Lootingtype", Lootingtype);
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	c_handle.SetSelectedNum(Lootingtype); //루팅타입을 파티장따라간다. 저장은 하지 않는다
	class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
}

function OnBecamePartyMaster(string a_Param) //파티장이됨
{
	local int Lootingtype;
	local ComboBoxHandle c_handle;
	ParseInt(a_Param, "Lootingtype", Lootingtype);
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	c_handle.SetSelectedNum(Lootingtype); 
	class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );
}

function OnHandOverPartyMaster() //파티장을 양도함
{
	class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
}

function OnRecvPartyMaster()  //파티장을 양도받음
{
	local ComboBoxHandle c_handle;
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	SetOptionInt( "Game", "PartyLooting", c_handle.GetSelectedNum()); //방장이 되면 현재방식을 저장한다. 운명적으로
	class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );
}

function OnRestart()
{
	local ComboBoxHandle c_handle;
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
	c_handle.SetSelectedNum(GetOptionInt( "Game", "PartyLooting"));
	class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" );
}

function string getLootingString(int type)
{
	local string retstr;
	switch(type)
	{
	case 0: //					  0(gatherer first)
		retstr = GetSystemString(487);
		break;
	case 1://					  1(party random distribution) 
		retstr = GetSystemString(488);
		break;
	case 2://					  2(party random distribution including spoil) 
		retstr = GetSystemString(798);
		break;
	case 3://					  3(party member's ordering) 
		retstr = GetSystemString(799);
		break;
	case 4://					  4(party member's ordering including spoil)
		retstr = GetSystemString(800);
		break;
	}

	return retstr;
}

function bool IsRoomMaster()
{
	local PartyWnd Script;
	Script = PartyWnd(GetScript("PartyWnd"));
	return Script.m_AmIRoomMaster;
}
function OnPartyLootingHasModified(String a_Param) //파티루팅이 변경되었을때
{
	local int IsSuccess;
	local int LootingScheme;
	local string Schemestr;
	local string	strParam;
	local PartyWnd script;
	//////////for ScreenMsg///////////
	local SystemMsgData SystemMsgCurrent;
	///////////////////////////////////////

	//루팅 콤보박스 변경을 위해
	local ComboBoxHandle c_handle;
	/////////////////////////

	local TextBoxHandle t_handle;

	script = PartyWnd(GetScript("PartyWnd"));
	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");

	ParseInt(a_Param, "IsSuccess", IsSuccess);
	ParseInt(a_Param, "LootingScheme", LootingScheme);
	//이곳에 스크린메시지 코드 추가. 옵션창 파티루팅방식 콤보박스도 다루어야함

	if(IsSuccess != 0) //성공이기만 하면 partyMatchRoom 의 루팅방식은 무조건 바꿔야한다. //파티창의 방장툴팁도변경
	{
		
		script.SetMasterTooltip(LootingScheme);
		Schemestr = getLootingString(LootingScheme);
		t_handle = GetTextBoxHandle("PartyMatchRoomWnd.LootingMethod");
		t_handle.SetText(Schemestr);
	}
	
		
	if(bPartyMaster || IsRoomMaster()) //자신이 파티장 혹은 파티방장이라면
	{
		AddSystemMessage(3136);
		if(IsSuccess != 0) //변경 성공 
		{
			SetOptionInt( "Game", "PartyLooting", LootingScheme ); //방장만 이 방법으로 루팅설정을 저장한다.(자기가 권유한 거니까)
			//do not change. Preserve combobox's current Item.
		}
		else //변경실패 콤보박스 원래로 복귀
		{
			c_handle.SetSelectedNum(GetOptionInt( "Game", "PartyLooting"));			
		}
		class'UIAPI_CHECKBOX'.static.EnableWindow( "OptionWnd.LootingBox" ); //루팅박스 활성화
	}
		

	if(IsSuccess == 0) //fail
	{
		//debug("실패했음");
	}
	else if(IsSuccess == 1)//success 파티원일 경우, 콤보박스만 바꿔주고 저장은 하지않는다
	{
		Schemestr = getLootingString(LootingScheme);
		GetSystemMsgInfo( 3138, SystemMsgCurrent);
		
		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000) );
		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
		
		PlaySound(SystemMsgCurrent.Sound);
		c_handle.SetSelectedNum(LootingScheme);	 //저장은 하지 않는다.
		
	}
	else if(IsSuccess == 2)//success 그냥 방안에 있는 사람일 경우. 콤보박스만 바꿔주고 저장은 하지않는다
	{
		Schemestr = getLootingString(LootingScheme);
		GetSystemMsgInfo( 3138, SystemMsgCurrent);

		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000) );
		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
		
		PlaySound(SystemMsgCurrent.Sound);
		c_handle.SetSelectedNum(LootingScheme);	 //저장은 하지 않는다.
	}
	
}

// function OnPartyLootingHasModified(String a_Param) //파티루팅이 변경되었을때
// {
// 	local int IsSuccess;
// 	local int LootingScheme;
// 	local string Schemestr;
// 	local string	strParam;
// 	
// 	//////////for ScreenMsg///////////
// 	local SystemMsgData SystemMsgCurrent;
// 	///////////////////////////////////////
// 
// 	//루팅 콤보박스 변경을 위해
// 	local PartyWnd script;
// 	local ComboBoxHandle c_handle;
// 	/////////////////////////
// 
// 	local TextBoxHandle t_handle;
// 
// 	
// 	NowLooting = false; //루팅변경이종료
// 	RefreshLootingBox(); //권한에 따라 콤보박스를 enable/disable 한다
// 
// 	script = PartyWnd(GetScript("PartyWnd"));
// 	c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
// 
// 	ParseInt(a_Param, "IsSuccess", IsSuccess);
// 	ParseInt(a_Param, "LootingScheme", LootingScheme);
// 	//이곳에 스크린메시지 코드 추가. 옵션창 파티루팅방식 콤보박스도 다루어야함
// 
// 	if(IsSuccess != 0) //성공이기만 하면 partyMatchRoom 의 루팅방식은 무조건 바꿔야한다.
// 	{
// 		Schemestr = getLootingString(LootingScheme);
// 		t_handle = GetTextBoxHandle("PartyMatchRoomWnd.LootingMethod");
// 		t_handle.SetText(Schemestr);
// 	}
// 	
// 		
// 	if(script.AmILeader()) //자신이 파티장 혹은 파티방장이라면
// 	{
// 		AddSystemMessage(3136);
// 		if(IsSuccess != 0) //변경 성공 
// 		{
// 			debug("success now type is");
// 			debug(string(LootingScheme));
// 			SetOptionInt( "Game", "PartyLooting", LootingScheme ); //방장만 이 방법으로 루팅설정을 저장한다.(자기가 권유한 거니까)
// //			Lootingtype = LootingScheme;
// 			//do not change. Preserve combobox's current Item.
// 		}
// 		else //변경실패 콤보박스 원래로 복귀
// 		{
// 			c_handle.SetSelectedNum(GetOptionInt( "Game", "PartyLooting"));			
// 		}
// 	}
// 	
// 
// 	if(IsSuccess == 0) //fail
// 	{
// 		//debug("실패했음");
// 	}
// 	else if(IsSuccess == 1)//success 파티원일 경우, 콤보박스만 바꿔주고 저장은 하지않는다
// 	{
// 		Schemestr = getLootingString(LootingScheme);
// 		GetSystemMsgInfo( 3138, SystemMsgCurrent);
// 		
// 		ParamAdd(strParam, "MsgType", String(1));
// 		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
// 		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
// 		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
// 		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000) );
// 		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
// 		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
// 		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
// 		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
// 		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
// 		ExecuteEvent(EV_ShowScreenMessage, strParam);
// 		
// 		PlaySound(SystemMsgCurrent.Sound);
// 		c_handle.SetSelectedNum(LootingScheme);	 //저장은 하지 않는다.
// 		
// 	}
// 	else if(IsSuccess == 2)//success 그냥 방안에 있는 사람일 경우. 콤보박스만 바꿔주고 저장은 하지않는다
// 	{
// 		Schemestr = getLootingString(LootingScheme);
// 		GetSystemMsgInfo( 3138, SystemMsgCurrent);
// 
// 		ParamAdd(strParam, "MsgType", String(1));
// 		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
// 		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
// 		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
// 		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000) );
// 		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
// 		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
// 		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
// 		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
// 		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
// 		ExecuteEvent(EV_ShowScreenMessage, strParam);
// 		
// 		PlaySound(SystemMsgCurrent.Sound);
// 		c_handle.SetSelectedNum(LootingScheme);	 //저장은 하지 않는다.
// 	}
// 	
// }

function OnAskPartyLootingModify(String a_Param)
{
	//Using for Party Looting Scheme Modification//
	local string LeaderName;
	local int LootingScheme;
	/////////////////////////////////////////////////
	local string Schemestr;

	// 다이얼 로그 박스에서 예, 아니오 가 나오도록 한다.
	dScript.SetButtonName( 184, 185 );
	
	DialogSetID( PARTY_MODIFY_REQUEST );
	DialogSetParamInt64( IntToInt64(10*1000) );			// 5 seconds
	DialogSetDefaultCancle(); // 엔터를 치거나 타임아웃발생시 cancle로 판단
	ParseString(a_Param, "LeaderName", LeaderName);
	ParseInt(a_Param, "LootingScheme", LootingScheme);
	Schemestr = getLootingString(LootingScheme);
	DialogShow(DIALOG_Modalless, DIALOG_Progress, MakeFullSystemMsg(GetSystemMessage(3134),Schemestr));
}
function HandleDialogOK() //파티루팅변경 동의창 
{
	if( DialogIsMine() )
	{
		if( DialogGetID() == PARTY_MODIFY_REQUEST )
		{
			RequestPartyLootingModifyAgreement(1); //동의 함
		}
		else if( DialogGetID() == OPTION_CHANGE )
		{			
			SetUIState( "ShaderBuildState" );		
		}
	}
	
}

function HandleDialogCancel() //파티루팅변경 동의창 
{
	// 확인, 취소 로 복구 
	dScript.SetButtonName( 1337, 1342 );

	if( DialogIsMine() )
	{
		if( DialogGetID() == PARTY_MODIFY_REQUEST )
		{
			RequestPartyLootingModifyAgreement(0); //거절함 혹은 타임아웃
		}
	}
}

function OnComboBoxItemSelected( string sName, int index ) 
{
	local PartyWnd script;
	local ComboBoxHandle c_handle;
	
	// debug(string(bPartyMaster));
	// debug(string(IsRoomMaster()));
	// debug(string(bPartyMember));
	switch( sName )
	{
	case "LootingBox": 
		
		script = PartyWnd(GetScript("PartyWnd"));
		c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
		if(bPartyMaster || (IsRoomMaster() && !bPartyMember)) //파티방장인데 파티장을 양도하는 경우가 있어서
		{
			//현재 루팅과 같은걸 또선택하면 무시. 
			//저장된 설정이 현재 설정이랑 일치하는 이유는 파티를 초대할때 저장된 설정을 사용하고, 
			//루팅이 변경되도 설정을 저장하기 때문이다.
			if(GetOptionInt( "Game", "PartyLooting") == c_handle.GetSelectedNum()) 
				break;
			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
			RequestPartyLootingModify(c_handle.GetSelectedNum()); // 루팅변경을 신청한다.
		}
		break;
	case "ResBox":
		ResetRefreshRate( ResolutionList[ index ].nWidth, ResolutionList[ index ].nHeight );
		break;
	
	case "DefaultPositionBox" :
		SetOptionInt( "Game", "LayoutDF", index );
		break;
	}
}

// 
// function OnComboBoxItemSelected( string sName, int index ) 
// {
// 	local PartyWnd script;
// 	local ComboBoxHandle c_handle;
// 	
// 	switch( sName )
// 	{
// 	case "LootingBox": 
// 		
// 		script = PartyWnd(GetScript("PartyWnd"));
// 		c_handle = GetComboBoxHandle("OptionWnd.LootingBox");
// 		if(script.AmILeader()) //자신이 파티장 혹은 파티방장이라면
// 		{
// 			//파티루팅 변경중 이라는 플래그를 설정한다.
// 			NowLooting = true;
// 			
// 			//현재 루팅과 같은걸 또선택하면 무시. 
// 			//저장된 설정이 현재 설정이랑 일치하는 이유는 파티를 초대할때 저장된 설정을 사용하고, 
// 			//루팅이 변경되도 설정을 저장하기 때문이다.
// 			if(GetOptionInt( "Game", "PartyLooting") == c_handle.GetSelectedNum()) 
// 				break;
// 			
// 			RefreshLootingBox(); //NowLooting을 true로 했으므로 disable된다. 루팅이 종료되면 NowLooting을 풀어주자
// 			RequestPartyLootingModify(c_handle.GetSelectedNum()); // 루팅변경을 신청한다.
// 
// 			class'UIAPI_CHECKBOX'.static.DisableWindow( "OptionWnd.LootingBox" );
// 		}
// 		else
// 		{
// 			//Lootingtype = c_handle.GetSelectedNum();
// 		}
// 		break;
// 	case "ResBox":
// 		ResetRefreshRate( ResolutionList[ index ].nWidth, ResolutionList[ index ].nHeight );
// 		break;
// 	
// 	case "DefaultPositionBox" :
// 		SetOptionInt( "Game", "LayoutDF", index );
// 		break;
// 	}
// }

////////////////////파티루팅 코드 종료/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 슬라이더 컨트롤 핸들러 - lancelot 2006. 6. 13.
function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fVolume;
	fVolume=GetVolumeFromSliderTick(iCurrentTick);
	switch(strID)
	{
	case "EffectVolumeSliderCtrl" :
		SetOptionFloat("Audio", "SoundVolume", fVolume);
		break;
	case "MusicVolumeSliderCtrl" :
		if(fVolume==0.0f)	// 슬라이더 바를 움직이는 도중에는 음악이 꺼지지 않게 하기 위해서
			fVolume=0.005f;
		SetOptionFloat("Audio", "MusicVolume", fVolume);
		break;
	case "SystemVolumeSliderCtrl" :
		SetOptionFloat("Audio", "WavVoiceVolume", fVolume);
		break;
	case "TutorialVolumeSliderCtrl" :
		SetOptionFloat("Audio", "OggVoiceVolume", fVolume);
		break;
	}
}

function OnDefaultPosition()
{
	GetCurrentResolution(g_CurrentMaxWidth, g_CurrentMaxHeight);
	//~ TargetStatusWnd.SetStuckable(false);
	//~ StatusWnd.SetStuckable(false);
	//~ SystemMenuWnd.SetStuckable(false);
	if (GetOptionInt( "Game", "LayoutDF" ) == 1)
	{
		//branch
		//StatusWnd.HideWindow();
		//end of branch
		if (TargetStatusWnd.IsShowWindow())
		{	
			bg_Temp = true;
			TargetStatusWnd.HideWindow();
		}
		else
		{
			bg_Temp = false;
		}
		class'UIAPI_WINDOW'.static.SetUITimer("OptionWnd", 1, 200);
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetUITimer("OptionWnd", 2, 200);
	}
	
}

function SetStuck(bool a)
{
	//~ local WindowHandle TargetStatusWnd;
	//~ local WindowHandle StatusWnd;
	//~ local WindowHandle SystemMenuWnd;
	//~ TargetStatusWnd = GetHandle( "TargetStatusWnd" );
	//~ StatusWnd = GetHandle( "StatusWnd" );
	//~ SystemMenuWnd = GetHandle( "SystemMenuWnd" );
	
	//~ if (a)
	//~ {
		//~ TargetStatusWnd.SetStuckable(false);
		//~ StatusWnd.SetStuckable(false);
		//~ SystemMenuWnd.SetStuckable(false);
	//~ }
	//~ else if (!a)
	//~ {
		//~ TargetStatusWnd.SetStuckable(true);
		//~ StatusWnd.SetStuckable(true);
		//~ SystemMenuWnd.SetStuckable(true);
	//~ }
}


function OnTimer(int TimerID)
{
	if (TimerID==1)	
	{
		class'UIAPI_WINDOW'.static.KillUITimer("OptionWnd", 1 );
		//branch : 왜 아래랑 다를까... TTP 33257
		//StatusWnd.ShowWindow();
		//end of branch
		StatusWnd.MoveTo(g_CurrentMaxWidth-170, g_CurrentMaxHeight-170);
		TargetStatusWnd.MoveTo(347,g_CurrentMaxHeight-184);
		if (bg_Temp)
			TargetStatusWnd.ShowWindow();

		SystemMenuWnd.SetAnchor("StatusWnd","TopRight", "BottomRight", -12, 0);
		SystemMenuWnd.ClearAnchor();
	}
	if (TimerID==2)	
	{
		class'UIAPI_WINDOW'.static.KillUITimer("OptionWnd", 2 );
		StatusWnd.MoveTo(0, 0);
		TargetStatusWnd.MoveTo((g_CurrentMaxWidth/2)-85, 0);
		if (bg_Temp)
			TargetStatusWnd.ShowWindow();
		
		SystemMenuWnd.SetAnchor("MenuWnd","TopRight", "BottomRight", -2, 0);
		SystemMenuWnd.ClearAnchor();
	}
	//~ TargetStatusWnd.SetStuckable(true);
	//~ StatusWnd.SetStuckable(true);
	//~ SystemMenuWnd.SetStuckable(true);
}


Function SetTutorialData(bool bOption)
{
}

/*
// PC방 포인트를 적용 시킨다. 
function SetPCPointBoxData()
{
	local PCCafeEventWnd script;
	script = PCCafeEventWnd( GetScript("PCCafeEventWnd") );

	// 갱신
	script.Refresh(1);
}
*/


//=================================================================================
// Function : LoadVideoOption()
//
// Description :
//	* Reads option.ini file, and apply video options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code. (e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here. (e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadVideoOption()
{
	local bool bKeepMinFrameRate;		// Min frame rate
	local bool bL2Shader;				// Shader 3.0
	local bool bShaderDOF;				// Shader 3.0 Depth of field
	local bool bShaderWater;			// Shader 3.0 Water
	local bool bShaderShadow;			// Shader 3.0 Self shadow

	// Shader option should be set only when "KeepMinFrameRate" option is off
	bKeepMinFrameRate = GetOptionBool( "Video", "IsKeepMinFrameRate" );
	if( !bKeepMinFrameRate )
	{
		// If current driver doesn't support Shader 3.0, there is no need to set Shader 3.0 options
		if( nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30 )
		{
			// Apply Shader 3.0 config
			bL2Shader = GetOptionBool( "Video", "L2Shader" );			
			SetL2Shader(bL2Shader);

			// DOF, WaterEffect, Shadow depend on L2Shader option. Set them only when bL2Shader is on.
			if( bL2Shader )
			{
				// Apply Shader 3.0 Depth of Field
				bShaderDOF = GetOptionBool( "Video", "S30DOFBOX" );
				SetDOF(bShaderDOF);
					
				// Apply Shader 3.0 Water
				bShaderWater = GetOptionBool( "Video", "S30WaterEffectBox" );
				SetShaderWaterEffect(bShaderWater);
				
				// Apply Shader 3.0 Self shadow
				bShaderShadow = GetOptionBool( "Video", "S30ShadowBox" );
				SetDepthBufferShadow(bShaderShadow);
			}
		}
	}
}

//=================================================================================
// Function : LoadAudioOption()
//
// Description :
//	* Reads option.ini file, and apply audio options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code. (e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here. (e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadAudioOption()
{
	local bool bMute;		// Audio mute

	// If device does not support audio, it's ok to simply ignore audio options
	if( CanUseAudio() )
	{
		// We only need to apply "Mute" option, because keys for volumes are shared between script and native code.
		bMute = GetOptionBool( "Audio", "AudioMuteOn" );
		if(bMute)
		{
			// Turn off all sounds
			SetSoundVolume( 0.f );
			SetMusicVolume( 0.f );
			SetWavVoiceVolume( 0.f );
			SetOggVoiceVolume( 0.f );
		}
	}
}

//=================================================================================
// Function : LoadGameOption()
//
// Description :
//	* Reads option.ini file, and apply game options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code. (e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here. (e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadGameOption()
{
	// Currently there is no options to load for the game tab.

	local bool bChecked;
	bChecked=false;
	bChecked=GetOptionBool( "Game", "RightClickBox");
	SetFixedDefaultCamera(bChecked);
}
defaultproperties
{
}
