class ChatWnd extends UICommonAPI;

struct ChatFilterInfo
{
	var int bSystem;
	var int bChat;
	var int bDamage;
	var int bNormal;
	var int bShout;
	var int bClan;
	var int bParty;
	var int bTrade;
	var int bWhisper;
	var int bAlly;
	var int bUseitem;
	var int bHero;
	var int bUnion;
	var int bBattle;
};

//Global Setting
var int	m_NoUnionCommanderMessage;
var int m_NoNpcMessage;				// NPC 대사 필터링 - 2010.9.8 winkey


var int	m_KeywordFilterSound;
var int 	m_KeywordFilterActivate;
var string  	m_Keyword0;
var string		m_Keyword1;
var string 		m_Keyword2;

var array<ChatFilterInfo>		m_filterInfo;
var array<string>			m_sectionName;
//~ var int					m_chatType;

struct native ChatUIType
{
	var 	int			ID;
	var	int			UI;		
};

var ChatUIType					m_ChatUI[8];
var ChatUIType					m_chatType;

const CHAT_WINDOW_NORMAL = 0;
const CHAT_WINDOW_TRADE = 1;
const CHAT_WINDOW_PARTY = 2;
const CHAT_WINDOW_CLAN = 3;
const CHAT_WINDOW_ALLY = 4;
const CHAT_WINDOW_COUNT = 9;
const CHAT_WINDOW_SYSTEM = 9;		// 시스템 메시지 창
//~ const CHAT_WINDOW_


//(10.1.28 문선준 추가)
//Link 이벤트 const 값.
const DIALOGID_GoWeb = 10;
//Url 값 저장.
var string Url;
var string Text;

//branch
//const CHAT_UNION_MAX = 20;			// 지휘채널 OnScreenMessage 한줄에 최대로 들어갈 수 있는 글자 수
const CHAT_UNION_MAX = 35;			// 지휘채널 OnScreenMessage 한줄에 최대로 들어갈 수 있는 글자 수(글로벌용)
//end of branch

//Handle List
var ChatWindowHandle NormalChat;
var ChatWindowHandle TradeChat;
var ChatWindowHandle PartyChat;
var ChatWindowHandle ClanChat;
var ChatWindowHandle AllyChat;
var ChatWindowHandle SystemMsg;




//~ var ChekboxHandle OutEditBox


var TabHandle ChatTabCtrl;
var EditBoxHandle ChatEditBox;

var WindowHandle	m_hChatWnd;
var WindowHandle	m_hSystemMsgWnd;
var WindowHandle	m_hChatFilterWnd;
var TextureHandle	m_hChatWndLanguageTexture;

var CheckBoxHandle	m_hChatFilterWndSystemMsgBox;
var CheckBoxHandle	m_hChatFilterWndDamageBox;
var CheckBoxHandle	m_hChatFilterWndItemBox;
var TextboxHandle	m_hChatFilterWndCurrentText;

var CheckBoxHandle	m_hChkChatFilterWndCheckBoxCommand;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxNpc;		// NPC 대사 필터링 - 2010.9.8 winkey
var CheckBoxHandle	m_hChkChatFilterWndKeywordSoundBox;
var CheckBoxHandle	m_hChkChatFilterWndKeywordFilterBox;

var CheckBoxHandle	m_hChkChatFilterWndCheckBoxSystem;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxNormal;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxShout;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxPledge;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxParty;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxTrade;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxWhisper;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxDamage;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxAlly;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxItem;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxHero;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxUnion;
var CheckBoxHandle	m_hChkChatFilterWndCheckBoxBattleField;


function OnRegisterEvent()
{
	registerEvent( EV_ChatMessage );
	registerEvent( EV_IMEStatusChange );

	registerEvent( EV_ChatWndStatusChange );
	registerEvent( EV_ChatWndSetString );
	registerEvent( EV_ChatWndSetFocus );
	registerEvent( EV_ChatWndMsnStatus );
	registerEvent( EV_ChatWndMacroCommand );
	
	//TextLink
	registerEvent( EV_TextLinkLButtonClick );
	registerEvent(EV_GamingStateEnter);
	registerEvent(EV_GamingStateExit);
	

	//진정창, 채팅 url링크 이벤트(10.1.28 문선준 추가)
	registerEvent( EV_UrlLinkClick );
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );
}

function OnLoad()
{
	m_filterInfo.Length = CHAT_WINDOW_COUNT + 1;		// 실제로 쓰이는 것은 CHAT_WINDOW_COUNT 만큼이지만 CheckFilter를 좀 더 간편하게 짜기위해 CHAT_WINDOW_SYSTEM 용 더미를 한개 더 할당한다.

	m_sectionName.Length = CHAT_WINDOW_COUNT;				// chatfilter.ini에서의 항목
	m_sectionName[0] = "entire_tab";
	m_sectionName[1] = "pledge_tab";
	m_sectionName[2] = "party_tab";
	m_sectionName[3] = "market_tab";
	m_sectionName[4] = "ally_tab";
	m_sectionName[5] = "hero_tab";
	m_sectionName[6] = "union_tab";
	m_sectionName[7] = "shout_tab";
	m_sectionName[8] = "battlefield_tab";
	//~ m_sectionName[CHAT_WINDOW_ALLY] = "ally_tab";
	//~ m_sectionName[CHAT_WINDOW_ALLY] = "ally_tab";
	//~ m_sectionName[CHAT_WINDOW_ALLY] = "ally_tab";
	//~ m_sectionName[CHAT_WINDOW_ALLY] = "ally_tab";
	
	// xml 에서 GaimingState에 등록해 주고 여기서 추가로 OlympiadObserverState에도 등록해 준다.
	RegisterState( "ChatWnd", "OlympiadObserverState" );

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
		
	InitFilterInfo();
	InitGlobalSetting();
	InitScrollBarPosition();
	
	//Enable TextLink
	ChatEditBox.SetEnableTextLink( true );
	m_chatType.UI = 0;
	m_chatType.ID = -1;
}

//function OnExitState( name a_NextStateName )
//{
	//if (a_NextStateName == 'GamingState')
	//{
	//	ShowWindow("ChatWnd");
	//}
	//else if ( a_NextStateName == 'OlympiadObserverState')
	//{
	//	ShowWindow("ChatWnd");
	//}
	//else
	//{
	//HideWindow("ChatWnd");
	//}
//}

function OnDefaultPosition()
{
	ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
	ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
	ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
	ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
	ChatTabCtrl.SetTopOrder(0, true);
	
	m_hChatWnd.SetAnchor("", "BottomLeft", "BottomLeft", 0, 2 );
	HandleTabClick("ChatTabCtrl0");
}

function InitGlobalSetting()
{
	local EditBoxHandle EditBox_KeyWord0;
	local EditBoxHandle EditBox_KeyWord1;
	local EditBoxHandle EditBox_KeyWord2;

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		EditBox_KeyWord0 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord0" ));
		EditBox_KeyWord1 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord1" ));
		EditBox_KeyWord2 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord2" ));
	}
	else
	{
		EditBox_KeyWord0 = GetEditBoxHandle ("ChatFilterWnd.Editbox_KeyWord0" );
		EditBox_KeyWord1 = GetEditBoxHandle ("ChatFilterWnd.Editbox_KeyWord1" );
		EditBox_KeyWord2 = GetEditBoxHandle ("ChatFilterWnd.Editbox_KeyWord2" );
	}
	
	m_hChkChatFilterWndCheckBoxCommand.SetCheck( bool(m_NoUnionCommanderMessage) );
	m_hChkChatFilterWndCheckBoxNpc.SetCheck( bool(m_NoNpcMessage) );	// NPC 대사 필터링 - 2010.9.8 winkey				
	m_hChkChatFilterWndKeywordSoundBox.SetCheck( bool(m_KeywordFilterSound) );
	m_hChkChatFilterWndKeywordFilterBox.SetCheck( bool(m_KeywordFilterActivate) );

	EditBox_KeyWord0.SetString(m_Keyword0);
	EditBox_KeyWord1.SetString(m_Keyword1);
	EditBox_KeyWord2.SetString(m_Keyword2);
}

function InitHandle()
{
	NormalChat = ChatWindowHandle( GetHandle( "ChatWnd.NormalChat" ));
	TradeChat = ChatWindowHandle( GetHandle( "ChatWnd.TradeChat" ));
	PartyChat = ChatWindowHandle( GetHandle( "ChatWnd.PartyChat" ));
	ClanChat = ChatWindowHandle( GetHandle( "ChatWnd.ClanChat" ));
	AllyChat = ChatWindowHandle( GetHandle( "ChatWnd.AllyChat" ));
	SystemMsg = ChatWindowHandle( GetHandle( "SystemMsgWnd.SystemMsgList" ));
	ChatTabCtrl = TabHandle( GetHandle("ChatWnd.ChatTabCtrl" ));
	ChatEditBox = EditBoxHandle( GetHandle("ChatWnd.ChatEditBox" ));

	m_hChatWnd=GetHandle("ChatWnd");
	m_hSystemMsgWnd=GetHandle("SystemMsgWnd");
	m_hChatFilterWnd=GetHandle("ChatFilterWnd");
	m_hChatWndLanguageTexture=TextureHandle(GetHandle("ChatWnd.LanguageTexture"));

	m_hChatFilterWndSystemMsgBox			=CheckBoxHandle( GetHandle("ChatFilterWnd.SystemMsgBox"));
	m_hChatFilterWndDamageBox			=CheckBoxHandle( GetHandle("ChatFilterWnd.DamageBox"));
	m_hChatFilterWndItemBox				=CheckBoxHandle( GetHandle("ChatFilterWnd.ItemBox"));
	m_hChatFilterWndCurrentText			=TextboxHandle( GetHandle("ChatFilterWnd.CurrentText"));

	m_hChkChatFilterWndCheckBoxCommand	=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxCommand" ));
	m_hChkChatFilterWndCheckBoxNpc		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxNPC" ));				// NPC 대사 필터링 - 2010.9.8 winkey
	m_hChkChatFilterWndKeywordSoundBox		=CheckBoxHandle( GetHandle( "ChatFilterWnd.KeywordSoundBox" ));
	m_hChkChatFilterWndKeywordFilterBox		=CheckBoxHandle( GetHandle( "ChatFilterWnd.KeywordFilterBox" ));

	m_hChkChatFilterWndCheckBoxSystem		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxSystem"));
	m_hChkChatFilterWndCheckBoxNormal		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxNormal"));
	m_hChkChatFilterWndCheckBoxShout		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxShout"));
	m_hChkChatFilterWndCheckBoxPledge		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxPledge"));
	m_hChkChatFilterWndCheckBoxParty		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxParty"));
	m_hChkChatFilterWndCheckBoxTrade		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxTrade"));
	m_hChkChatFilterWndCheckBoxWhisper		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxWhisper"));
	m_hChkChatFilterWndCheckBoxDamage		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxDamage"));
	m_hChkChatFilterWndCheckBoxAlly		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxAlly"));
	m_hChkChatFilterWndCheckBoxItem		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxItem"));
	m_hChkChatFilterWndCheckBoxHero		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxHero"));
	m_hChkChatFilterWndCheckBoxUnion		=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxUnion"));
	m_hChkChatFilterWndCheckBoxBattleField 	=CheckBoxHandle( GetHandle( "ChatFilterWnd.CheckBoxBattle")); 
}

function InitHandleCOD()
{
	NormalChat = GetChatWindowHandle( "ChatWnd.NormalChat" );
	TradeChat = GetChatWindowHandle( "ChatWnd.TradeChat" );
	PartyChat = GetChatWindowHandle( "ChatWnd.PartyChat" );
	ClanChat = GetChatWindowHandle( "ChatWnd.ClanChat" );
	AllyChat = GetChatWindowHandle( "ChatWnd.AllyChat" );
	SystemMsg = GetChatWindowHandle( "SystemMsgWnd.SystemMsgList" );
	ChatTabCtrl = GetTabHandle( "ChatWnd.ChatTabCtrl" );
	ChatEditBox = GetEditBoxHandle( "ChatWnd.ChatEditBox" );

	m_hChatWnd=GetWindowHandle("ChatWnd");
	m_hSystemMsgWnd=GetWindowHandle("SystemMsgWnd");
	m_hChatFilterWnd=GetWindowHandle("ChatFilterWnd");
	m_hChatWndLanguageTexture=GetTextureHandle("ChatWnd.LanguageTexture");

	m_hChatFilterWndSystemMsgBox		=GetCheckboxHandle("ChatFilterWnd.SystemMsgBox");
	m_hChatFilterWndDamageBox			=GetCheckboxHandle("ChatFilterWnd.DamageBox");
	m_hChatFilterWndItemBox				=GetCheckboxHandle("ChatFilterWnd.ItemBox");
	m_hChatFilterWndCurrentText			=GetTextboxHandle("ChatFilterWnd.CurrentText");

	m_hChkChatFilterWndCheckBoxCommand	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxCommand" );
	m_hChkChatFilterWndCheckBoxNpc	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxNPC" );			// NPC 대사 필터링 - 2010.9.8 winkey
	m_hChkChatFilterWndKeywordSoundBox	=GetCheckBoxHandle( "ChatFilterWnd.KeywordSoundBox" );
	m_hChkChatFilterWndKeywordFilterBox	=GetCheckBoxHandle( "ChatFilterWnd.KeywordFilterBox" );

	m_hChkChatFilterWndCheckBoxSystem	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxSystem");
	m_hChkChatFilterWndCheckBoxNormal	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxNormal");
	m_hChkChatFilterWndCheckBoxShout	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxShout");
	m_hChkChatFilterWndCheckBoxPledge	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxPledge");
	m_hChkChatFilterWndCheckBoxParty	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxParty");
	m_hChkChatFilterWndCheckBoxTrade	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxTrade");
	m_hChkChatFilterWndCheckBoxWhisper	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxWhisper");
	m_hChkChatFilterWndCheckBoxDamage	=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxDamage");
	m_hChkChatFilterWndCheckBoxAlly		=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxAlly");
	m_hChkChatFilterWndCheckBoxItem		=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxItem");
	m_hChkChatFilterWndCheckBoxHero		=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxHero");
	m_hChkChatFilterWndCheckBoxUnion		=GetCheckBoxHandle( "ChatFilterWnd.CheckBoxUnion");
	m_hChkChatFilterWndCheckBoxBattleField =GetCheckBoxHandle( "ChatFilterWnd.CheckBoxBattle");
}

function InitScrollBarPosition()
{
	NormalChat.SetScrollBarPosition( 5, 10, -18 );
	TradeChat.SetScrollBarPosition( 5, 10, -18 );
	PartyChat.SetScrollBarPosition( 5, 10, -18 );
	ClanChat.SetScrollBarPosition( 5, 10, -18 );
	AllyChat.SetScrollBarPosition( 5, 10, -18 );
}

function OnCompleteEditBox( String strID )
{
	local String strInput;
	local EChatType Type;
	
	if( strID == "ChatEditBox" )
	{
		strInput = ChatEditBox.GetString();
		if ( Len( strInput ) < 1 )
			return;
			
		ProcessChatMessage( strInput, m_chatType.ID, true );
		ChatEditBox.SetString( "" );
		
		//채팅기호
		if( GetOptionBool( "Game", "OldChatting" ) == true)
		{
			Type = GetChatTypeByTabIndex( m_chatType.ID );
			
			//일반탭이 아닌 경우, Prefix를 붙여준다.
			if ( m_chatType.ID  != 0 )
			{
				//debug ("m_chatType.UI " @ m_chatType.UI );
				//debug ("m_chatType.ID " @ m_chatType.ID );
				if(GetChatPrefix( Type ) != "~")
				{
					ChatEditBox.AddString( GetChatPrefix( Type ) );
				}
			}
			
		}
		
		//엔터채팅
		if( GetOptionBool( "Game", "EnterChatting" ) == true)
		{
			ChatEditBox.ReleaseFocus();
		}
	}
}

function Clear()
{
	ChatEditBox.Clear();
	NormalChat.Clear();
	PartyChat.Clear();
	ClanChat.Clear();
	TradeChat.Clear();
	AllyChat.Clear();
	SystemMsg.Clear();
}
 
function OnShow()
{
	if( GetOptionBool("Game", "SystemMsgWnd") )
	{
		m_hSystemMsgWnd.ShowWindow();
	}
	else
	{
		m_hSystemMsgWnd.HideWindow();
	}

	HandleIMEStatusChange();
	
	GetAllcurrentAssignedChatTypeID();
	//~ SetChatFilterButton();
	//~ HandleTabClick("ChatTabCtrl0");
	m_chatType.UI = 0;
	m_chatType.ID = -1;
}

function OnClickButton( String strID )
{
	local PartyMatchWnd script;
	local WindowHandle TaskWnd;
	local PartyMatchRoomWnd p2_script;
	p2_script = PartyMatchRoomWnd( GetScript( "PartyMatchRoomWnd" ) );
	script = PartyMatchWnd( GetScript( "PartyMatchWnd" ) );
	switch( strID )
	{
	case "ChatTabCtrl0":
	case "ChatTabCtrl1":
	case "ChatTabCtrl2":
	case "ChatTabCtrl3":
	case "ChatTabCtrl4":
		//~ InitScrollBarPosition();
		HandleTabClick(strID);
		break;
	case "ChatFilterBtn":
		if (m_hChatFilterWnd.IsShowWindow())
		{
			m_hChatFilterWnd.HideWindow();
		}
		else
		{
			SetChatFilterButton();
			m_hChatFilterWnd.ShowWindow();
		}
		break;
	case "MessengerBtn":
		ToggleMsnWindow();
		break;
	case "PartyMatchingBtn":
		if(CREATE_ON_DEMAND==0)
			TaskWnd=GetHandle( "PartyMatchWnd" );
		else
			TaskWnd=GetWindowHandle( "PartyMatchWnd" );

		if (TaskWnd.IsShowWindow())
		{
			ClosePartyMatchingWnd();
		}
		else
		{
			if(CREATE_ON_DEMAND==0)
				TaskWnd=GetHandle("PartyMatchRoomWnd");
			else
				TaskWnd=GetWindowHandle("PartyMatchRoomWnd");

			if (TaskWnd.IsShowWindow())
			{
				TaskWnd.HideWindow();
				
				if(CREATE_ON_DEMAND==0)
					TaskWnd=GetHandle("PartyMatchWnd");
				else
					TaskWnd=GetWindowHandle("PartyMatchWnd");

				p2_script.OnSendPacketWhenHiding();
				
				
				if(CREATE_ON_DEMAND==0)
					TaskWnd=GetHandle("ChatWnd");
				else
					TaskWnd=GetWindowHandle("ChatWnd");

				TaskWnd.SetTimer( 1992, 500 );
			}
			else
			{
				if(CREATE_ON_DEMAND==0)
					TaskWnd=GetHandle("PartyMatchWnd");
				else
					TaskWnd=GetWindowHandle("PartyMatchWnd");
				//~ TaskWnd.ShowWindow();
				class'PartyMatchAPI'.static.RequestOpenPartyMatch();
				//~ ExecuteCommand("/partymatching");
			}
		}
		//~ ExecuteCommand("/partymatch");
		break;
	default:
		break;
	};
}

function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;
	p_script = PartyMatchWnd( GetScript( "PartyMatchWnd" ) );

	if(CREATE_ON_DEMAND==0)
		TaskWnd = GetHandle("PartyMatchWnd");
	else
		TaskWnd = GetWindowHandle("PartyMatchWnd");

	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
}

function OnTimer(int TimerID)
{
	if(TimerID == 1992)
	{
		ClosePartyMatchingWnd();
		m_hChatWnd.KillTimer(1992); 
	}
}

function OnTabSplit( string sTabButton )
{
	//~ local int width;
	//~ local int height;
	
	local ChatWindowHandle handle;
	InitScrollBarPosition();
	
	switch( sTabButton )
	{
	case "ChatTabCtrl0":
		handle = NormalChat;
		HandleTabClick(sTabButton);
		break;
	case "ChatTabCtrl1":
		handle = TradeChat;
		HandleTabClick(sTabButton);
		break;
	case "ChatTabCtrl2":
		handle = PartyChat;
		HandleTabClick(sTabButton);
		break;
	case "ChatTabCtrl3":
		handle = ClanChat;
		HandleTabClick(sTabButton);
		break;
	case "ChatTabCtrl4":
		handle = AllyChat;
		HandleTabClick(sTabButton);
		break;
	default:
		break;
	};
	if (handle!=None)
	{
		//~ handle.Move(0,-4);
		handle.SetWindowSizeRel( -1.0f, -1.0f, 0, 0);	//RelativeSize해제
		//~ handle.GeWindowSize( width, height );
		//~ handle.SetWindowSize( width , height + 4 );
		handle.Move(0,4);
		//handle.SetSettledWnd( true );
		handle.EnableTexture( true );
	}
}

function OnTabMerge( string sTabButton )
{
	local ChatWindowHandle handle;
	local int width, height;
	local Rect rectWnd;
	InitScrollBarPosition();
	
	switch( sTabButton )
	{
	case "ChatTabCtrl0":
		handle = NormalChat;
		break;
	case "ChatTabCtrl1":
		handle = TradeChat;
		break;
	case "ChatTabCtrl2":
		handle = PartyChat;
		break;
	case "ChatTabCtrl3":
		handle = ClanChat;
		break;
	case "ChatTabCtrl4":
		handle = AllyChat;
		break;
	default:
		break;
	};
	if (handle!=None)
	{
		rectWnd = NormalChat.GetRect();
		NormalChat.GetWindowSize( width, height );
		handle.Move(0,-4);
		handle.SetSettledWnd( false );
		handle.MoveTo( rectWnd.nX, rectWnd.nY );
		handle.SetWindowSize( width, height - 46 );
		handle.SetWindowSizeRel( 1.0f, 1.0f, 0, -46 );
		handle.EnableTexture( false );
	}
}

function HandleTabClick( string strID )
{
	local string strInput;
	local string strPrefix;
	local int strLen;
	
	m_chatType.UI = ChatTabCtrl.GetTopIndex();
	//~ debug("CurrentTopIndex" @ m_chatType.UI);
	m_chatType.ID = GetCurrentChatTypeID(m_chatType.UI);
	
	SetChatFilterButton();
	InitScrollBarPosition();
	
	//채팅기호
	if( GetOptionBool( "Game", "OldChatting" ) == true)
	{
		//~ debug("Arrange me");
		strInput = ChatEditBox.GetString();
		strLen = Len(strInput);
		//Prefix가 있으면, 제거(일단 길이는 1로 가정한다)
		strPrefix = Left( strInput, 1 );
		if ( IsSameChatPrefix(CHAT_MARKET, strPrefix)
			|| IsSameChatPrefix(CHAT_PARTY, strPrefix)
			|| IsSameChatPrefix(CHAT_CLAN, strPrefix)
			|| IsSameChatPrefix(CHAT_ALLIANCE, strPrefix) 
			|| IsSameChatPrefix(CHAT_HERO, strPrefix) 
			|| IsSameChatPrefix(CHAT_INTER_PARTYMASTER_CHAT, strPrefix) 
			|| IsSameChatPrefix(CHAT_SHOUT, strPrefix) 
			//~ || IsSameChatPrefix(CHAT_BATTLE, strPrefix) 
			|| IsSameChatPrefix(CHAT_DOMINIONWAR, strPrefix) 	)
		{
			strInput = Right( strInput, strLen-1 );
		}
		//일반탭이 아닌 경우, 변경된 Prefix를 붙여준다.
		//~ if ( m_chatType.ID != CHAT_WINDOW_NORMAL )
		if ( m_chatType.UI != 0 )
		{
				//~ if(GetChatPrefix( Type ) != "~")
			strPrefix = GetChatPrefix(GetChatTypeByTabIndex(m_chatType.ID));
			if (strPrefix != "~")
				strInput = strPrefix $ strInput;
		}
		else
		{
			strPrefix = "";
			strInput = strPrefix $ strInput;
		}
		ChatEditBox.SetString(strInput);
	}
}

function OnEnterState( name a_PrevStateName )
{
	if( a_PrevStateName == 'LoadingState' )			// 게임 중에 다른 스테이트(스페셜카메라 등)으로 갔다가 다시 들어오는 경우는 Clear()를 불러주면 안되기때문에
	{
		Clear();
	}
}

function OnEvent(int Event_ID, String param)
{
	switch( Event_ID )
	{
	case EV_ChatMessage:
		//~ debug (param);
		HandleChatMessage( param );
	case EV_IMEStatusChange:
		HandleIMEStatusChange();
		break;
	case EV_ChatWndStatusChange:
		HandleChatWndStatusChange();
		break;
	case EV_ChatWndSetFocus:
		HandleSetFocus();
		break;
	case EV_ChatWndSetString:
		HandleSetString( param );
		break;
	case EV_ChatWndMsnStatus:
		HandleMsnStatus(param);
		break;
	case EV_ChatWndMacroCommand:
		HandleChatWndMacroCommand( param );
		break;
	case EV_TextLinkLButtonClick:
		HandleTextLinkLButtonClick( param );
		break;
	case EV_DominionWarChannelSet:
		HandleDominionWarChannelSet( param );
		break;
	case EV_GamingStateEnter:
		SetChatFilterButton();
		HandleTabClick("ChatTabCtrl0");
		break;
	case EV_GamingStateExit:
		ChatEditBox.ClearHistory();
		break;
	//진정창, 채팅 url링크 이벤트 리스너(10.1.28 문선준 추가)
	case EV_UrlLinkClick:
		linkWebPage( param );
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		break;
	default:
		break;
	}
}

//홈페이지 링크(10.1.28 문선준 추가)
function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
	case DIALOGID_GoWeb:
		OpenGivenURL( Url );
		break;
	}
}

function linkWebPage( string param )
{	
	if ( !ParseString(param, "Url", Url) )
	return;

	if ( !ParseString(param, "Text", Text) )
	{
		Text = "";
	}

	//debug( "Url---->" $ Url @ GetSystemString( 2265 ));
	//debug( "Text---->" $ Text );
	
	DialogSetID( DIALOGID_GoWeb );
	if( Text != "" )
	{
		DialogShow( DIALOG_Modalless, DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage( 3211 ) , Text, "" ) );
	}
	else
	{
		if( Url == GetSystemString( 2265 ) )
		{
			DialogShow( DIALOG_Modalless, DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage( 3211 ) , GetSystemString( 2259 ), "" ) );
		}
		else if( Url == GetSystemString( 2266 ) )
		{
			DialogShow( DIALOG_Modalless, DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage( 3211 ) , GetSystemString( 2261 ), "" ) );
		}
		else if( Url == GetSystemString( 2267 ) )
		{
			DialogShow( DIALOG_Modalless, DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage( 3211 ) , GetSystemString( 2263 ), "" ) );
		}

	}
}



//매크로커맨드의 실행, UC의 ChatType에 맞게 실행되어야한다.
function HandleChatWndMacroCommand( string param )
{
	local string Command;
	
	if (!ParseString(param, "Command", Command))
		return;
		
	ProcessChatMessage( Command, m_chatType.ID );
}

function HandleChatmessage( String param )
{
	local int				nTmp;
	local EChatType		type;
	local ESystemMsgType	systemType;
	local string			text;
	local Color			color;
	local  int 			foundID;
	local SystemMsgData	SysMsgData;
	local int SysMsgIndex;

	local int SayType;
	//~ debug(param);
	ParseInt(param, "Type", nTmp);
	type = EChatType(nTmp);
	SayType=nTmp;

	ParseString(param, "Msg", text);
	
	// 시스템 메시지일때는 스크립트의 색상을 사용 - lancelot 2008. 8. 18.	
	if(type==CHAT_SYSTEM)
	{
		ParseInt(param, "SysMsgIndex", SysMsgIndex);
		if(SysMsgIndex==-1)
		{
			Color=GetChatColorByType(SayType);		// 시스템 메시지는 5
		}
		else
		{
			GetSystemMsgInfo(SysMsgIndex, SysMsgData);
			color=SysMsgData.FontColor;
		}
	
		ParseInt(param, "SysType", nTmp);	
		systemType = ESystemMsgType(nTmp);
	}
	else
	{
		Color=GetChatColorByType(SayType);
		
		systemType = SYSTEM_NONE;
	}
	
	if (m_KeywordFilterActivate == 1)
		foundID = 	ChatNotificationFilter(text, m_Keyword0, m_Keyword1, m_Keyword2);	
	//~ debug ("현재 채팅 타입" @ m_chatType.ID @ m_chatType.UI @ type);
	if( CheckFilter( type, 0, systemType ) )
	{
		//~ switch (m_chatType.UI) 
		NormalChat.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		if (foundID > 0 && m_KeywordFilterSound == 1 && ChatTabCtrl.GetTopIndex()== 0)
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}
	if( CheckFilter( type, 2, systemType ) )
	{
		PartyChat.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		//~ debug(text @ color.r @ color.g @color.b);
		if (foundID > 0 && m_KeywordFilterSound == 1 && ChatTabCtrl.GetTopIndex()== 2)
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}
	if( CheckFilter( type, 3, systemType ) )
	{
		ClanChat.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		if (foundID > 0 && m_KeywordFilterSound == 1 && ChatTabCtrl.GetTopIndex()== 3)
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}
	if( CheckFilter( type, 1, systemType ) )
	{	
		TradeChat.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		if (foundID > 0 && m_KeywordFilterSound == 1 && ChatTabCtrl.GetTopIndex()== 1)
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}
	if( CheckFilter( type, 4, systemType) )
	{	
		AllyChat.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		if (foundID > 0 && m_KeywordFilterSound == 1 && ChatTabCtrl.GetTopIndex()== 4)
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}

	if( CheckFilter( type, 9, systemType ) )
	{
		SystemMsg.AddStringToChatWindow( text, color );
		//~ debug("Add String Goes Here" @ Type @ systemType);
		if (foundID > 0 && m_KeywordFilterSound == 1 )
			PlaySound("ItemSound3.Sys_Chat_Keyword");
	}
	//Union Commander Message
	if ( type == CHAT_COMMANDER_CHAT && m_NoUnionCommanderMessage == 0 )
	{
		ShowUnionCommanderMessgage( text );
	}
	if ( type == CHAT_SCREEN_ANNOUNCE )
	{
		NormalChat.AddStringToChatWindow( text, color );
		ShowAnnounceMessgage( text );
	}
}


function ShowUnionCommanderMessgage(string Msg)
{
	local string	strParam;
	local string MsgTemp;
	local string MsgTemp2;
	local int maxlength;
	
	maxlength = Len(Msg);
	
	
	if (maxlength > CHAT_UNION_MAX)
	{
		
		MsgTemp = Left(Msg, CHAT_UNION_MAX);
		MsgTemp2 = Right(Msg, maxlength - CHAT_UNION_MAX);
		Msg = MsgTemp $"#"$ MsgTemp2 ;
		
		
	}


	//~ debug (Msg);

	if (Len(Msg)>0)
	{
		
		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(8));
		ParamAdd(strParam, "FontType", String(0));
		ParamAdd(strParam, "BackgroundType",String(0));
		ParamAdd(strParam, "LifeTime", String(5000));
		ParamAdd(strParam, "AnimationType", String(1));
		ParamAdd(strParam, "Msg", Msg);
		ParamAdd(strParam, "MsgColorR", String(255));
		ParamAdd(strParam, "MsgColorG", String(150));
		ParamAdd(strParam, "MsgColorB", String(149));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
	}
}

function ShowAnnounceMessgage(string Msg)
{
	local string	strParam;
	local string MsgTemp;
	local string MsgTemp2;
	local int maxlength;
	
	maxlength = Len(Msg);
	
	
	if (maxlength > CHAT_UNION_MAX)
	{
		
		MsgTemp = Left(Msg, CHAT_UNION_MAX);
		MsgTemp2 = Right(Msg, maxlength - CHAT_UNION_MAX);
		Msg = MsgTemp $"#"$ MsgTemp2 ;
		
		
	}


	//~ debug (Msg);

	if (Len(Msg)>0)
	{
		
		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(8));
		ParamAdd(strParam, "FontType", String(1));
		ParamAdd(strParam, "BackgroundType",String(0));
		ParamAdd(strParam, "LifeTime", String(5000));
		ParamAdd(strParam, "AnimationType", String(1));
		ParamAdd(strParam, "Msg", Msg);
		ParamAdd(strParam, "MsgColorR", String(255));
		ParamAdd(strParam, "MsgColorG", String(150));
		ParamAdd(strParam, "MsgColorB", String(149));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
	}
}


function HandleIMEStatusChange()
{
	local string texture;
	local EIMEType imeType;
	imeType = GetCurrentIMELang();
	switch( imeType )
	{
	case IME_KOR:
		texture = "L2UI.ChatWnd.IME_kr";
		break;
	case IME_ENG:
		texture = "L2UI.ChatWnd.IME_en";
		break;
	case IME_JPN:
		texture = "L2UI.ChatWnd.IME_jp";
		break;
	case IME_CHN:
		texture = "L2UI.ChatWnd.IME_jp";
		break;
	case IME_TAIWAN_CHANGJIE:
		texture = "L2UI.ChatWnd.IME_tw2";
		break;
	case IME_TAIWAN_DAYI:
		texture = "L2UI.ChatWnd.IME_tw3";
		break;
	case IME_TAIWAN_NEWPHONETIC:
		texture = "L2UI.ChatWnd.IME_tw1";
		break;
	case IME_CHN_MS:
		texture = "L2UI.ChatWnd.IME_cn1";
		break;
	case IME_CHN_JB:
		texture = "L2UI.ChatWnd.IME_cn2";
		break;
	case IME_CHN_ABC:
		texture = "L2UI.ChatWnd.IME_cn3";
		break;
	case IME_CHN_WUBI:
		texture = "L2UI.ChatWnd.IME_cn4";
		break;
	case IME_CHN_WUBI2:
		texture = "L2UI.ChatWnd.IME_cn4";
		break;
	case IME_THAI:
		texture = "L2UI.ChatWnd.IME_th";
		break;
	//branch
	case IME_RUSSIA:
		texture = "BranchSys.symbol.IME_ru";
		break;
	//end of branch
	default:
		texture = "L2UI.ChatWnd.IME_en";
		break;
	};

	m_hChatWndLanguageTexture.SetTexture(texture);
}

function bool CheckFilter( EChatType type, int windowType, ESystemMsgType systemType )		// systemType은 CHAT_SYSTEM일 경우만 넘겨주면된다
{
	if( !( windowType >= 0 && windowType < CHAT_WINDOW_COUNT ) && windowType != CHAT_WINDOW_SYSTEM )
	{
		return false;
	}

	if( type == CHAT_MARKET && m_filterInfo[windowtype].bTrade != 0)
	{
		return true;
	}
	else if( type == CHAT_NORMAL && m_filterInfo[windowType].bNormal != 0 )
	{
		return true;
	}
	else if( type == CHAT_CLAN && m_filterInfo[windowType].bClan != 0 )
	{
		return true;
	}
	else if( type == CHAT_PARTY && m_filterInfo[windowType].bParty != 0 )
	{
		return true;
	}
	else if( type == CHAT_SHOUT && m_filterInfo[windowType].bShout != 0 )
	{
		return true;
	}
	else if( type == CHAT_TELL && m_filterInfo[windowType].bWhisper != 0 )
	{
		return true;
	}
	else if( type == CHAT_ALLIANCE && m_filterInfo[windowType].bAlly != 0 )
	{
		return true;
	}
	else if( type == CHAT_HERO && m_filterInfo[windowType].bHero != 0 )
	{
		return true;
	
	}
	else if( type == CHAT_DOMINIONWAR  && m_filterInfo[windowType].bBattle != 0 )
	{
		return true;
	}
	else if( type == CHAT_ANNOUNCE || type == CHAT_CRITICAL_ANNOUNCE || type == CHAT_GM_PET )
	{
		return true;
	}
	else if( ( type == CHAT_INTER_PARTYMASTER_CHAT || type == CHAT_COMMANDER_CHAT ) && m_filterInfo[windowType].bUnion != 0 )
	{
		return true;
	}

	else if( type == CHAT_SYSTEM )
	{
		if( systemType == SYSTEM_SERVER || systemType == SYSTEM_PETITION )
			return true;
		else if( windowType == CHAT_WINDOW_SYSTEM )			// 시스템 메시지 창이면 옵션을 보고
		{
			if( systemType == SYSTEM_DAMAGE )
			{
				if( GetOptionBool("Game", "SystemMsgWndDamage") )
					return true;
				else 
					return false;
			}
			else if( systemType == SYSTEM_USEITEMS )
			{
				if( GetOptionBool("Game", "SystemMsgWndExpendableItem" ) )
					return true;
				else 
					return false;
			}
			else if( systemType == SYSTEM_BATTLE || systemType == SYSTEM_NONE  )
				return true;

			return false;
		}
		else if( m_filterInfo[windowType].bSystem != 0 )
		{
			if( systemType == SYSTEM_DAMAGE )
			{
				if( m_filterInfo[windowType].bDamage != 0 )
					return true;
				else 
					return false;
			}
			else if( systemType == SYSTEM_USEITEMS )
			{
				if( m_filterInfo[windowType].bUseItem != 0 )
					return true;
				else 
					return false;
			}
			return true;
		}
		return false;
	}
	else if( ( type == CHAT_NPC_NORMAL || type == CHAT_NPC_SHOUT ) && m_NoNpcMessage == 0 )	// NPC 대사 필터링 - 2010.9.8 winkey
	{
		return true;
	}

	return false;
}

// init with chatfilter.ini
function InitFilterInfo()
{
	local int i;
	local int tempVal;
	local string tempstring;
	
	SetDefaultFilterValue();
	for( i=0; i < CHAT_WINDOW_COUNT ; ++i )
	{
		if( GetINIBool( m_sectionName[i], "system", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bSystem = tempVal;

		if( GetINIBool( m_sectionName[i], "chat", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bChat = tempVal;
		
		if( GetINIBool( m_sectionName[i], "normal", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bNormal = tempVal;
		
		if( GetINIBool( m_sectionName[i], "shout", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bShout = tempVal;
		
		if( GetINIBool( m_sectionName[i], "pledge", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bClan = tempVal;
		
		if( GetINIBool( m_sectionName[i], "party", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bParty = tempVal;
		
		if( GetINIBool( m_sectionName[i], "market", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bTrade = tempVal;
		
		if( GetINIBool( m_sectionName[i], "tell", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bWhisper = tempVal;
		
		if( GetINIBool( m_sectionName[i], "damage", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bDamage = tempVal;
		
		if( GetINIBool( m_sectionName[i], "ally", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bAlly = tempVal;
		
		if( GetINIBool( m_sectionName[i], "useitems", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bUseItem = tempVal;
		
		if( GetINIBool( m_sectionName[i], "hero", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bHero = tempVal;
			
		if( GetINIBool( m_sectionName[i], "union", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bUnion = tempVal;
		
		if( GetINIBool( m_sectionName[i], "battle", tempVal, "chatfilter.ini" ) )
			m_filterInfo[i].bBattle = tempVal;
	}
	
	// 기존의 잘못된 INI를 가진 유저들을 위해 기본 값을 항상 리셋한다. 
	SetDefaultFilterOn();
	
	//Global Setting
	if( GetINIBool( "global", "command", tempVal, "chatfilter.ini" ) )
		m_NoUnionCommanderMessage = tempVal;

	if( GetINIBool( "global", "npc", tempVal, "chatfilter.ini" ) )	// NPC 대사 필터링 - 2010.9.8 winkey
		m_NoNpcMessage = tempVal;
	
	if( GetINIBool( "global", "keywordsound", tempVal, "chatfilter.ini" ) )
		m_KeywordFilterSound = tempVal;
	
	if( GetINIBool( "global", "keywordactivate", tempVal, "chatfilter.ini" ) )
		m_KeywordFilterActivate = tempVal;
	
	if ( GetINIString("global", "Keyword0", tempstring, "chatfilter.ini") )
		m_Keyword0 = tempstring;
	
	if ( GetINIString("global", "Keyword1", tempstring, "chatfilter.ini") )
		m_Keyword1 = tempstring;
	
	if ( GetINIString("global", "Keyword2", tempstring, "chatfilter.ini") )
		m_Keyword2 = tempstring;
	
	
	//~ debug ("키워드값"@ m_keyword0 @ m_keyword1 @ m_keyword2);
}


function SetDefaultFilterOn()
{
	m_filterInfo[ CHAT_WINDOW_TRADE ].bTrade = 1;
	m_filterInfo[ CHAT_WINDOW_PARTY ].bParty = 1;
	m_filterInfo[ CHAT_WINDOW_CLAN ].bClan = 1;
	m_filterInfo[ CHAT_WINDOW_ALLY ].bAlly = 1;
}

function SetDefaultFilterValue()
{
	m_filterInfo[ 0 ].bSystem = 1;
	m_filterInfo[ 0 ].bChat = 1;
	m_filterInfo[ 0 ].bNormal = 1;
	m_filterInfo[ 0 ].bShout = 1;
	m_filterInfo[ 0 ].bClan = 1;
	m_filterInfo[ 0 ].bParty = 1;
	m_filterInfo[ 0 ].bTrade = 0;
	m_filterInfo[ 0 ].bWhisper = 1;
	m_filterInfo[ 0 ].bDamage = 1;
	m_filterInfo[ 0 ].bAlly = 0;
	m_filterInfo[ 0 ].bUseItem = 0;
	m_filterInfo[ 0 ].bHero = 0;
	m_filterInfo[ 0 ].bUnion = 1;
	m_filterInfo[ 0 ].bBattle = 1;
	
	m_filterInfo[ 1 ].bSystem = 1;
	m_filterInfo[ 1 ].bChat = 1;
	m_filterInfo[ 1 ].bNormal = 0;
	m_filterInfo[ 1 ].bShout = 1;
	m_filterInfo[ 1 ].bClan = 0;
	m_filterInfo[ 1 ].bParty = 0;
	m_filterInfo[ 1 ].bTrade = 1;
	m_filterInfo[ 1 ].bWhisper = 1;
	m_filterInfo[ 1 ].bDamage = 1;
	m_filterInfo[ 1 ].bAlly = 0;
	m_filterInfo[ 1 ].bUseItem = 0;
	m_filterInfo[ 1 ].bHero = 0;
	m_filterInfo[ 1 ].bUnion = 0;
	m_filterInfo[ 1 ].bBattle = 0;
	
	m_filterInfo[ 2 ].bSystem = 1;
	m_filterInfo[ 2 ].bChat = 1;
	m_filterInfo[ 2 ].bNormal = 0;
	m_filterInfo[ 2 ].bShout = 1;
	m_filterInfo[ 2 ].bClan = 0;
	m_filterInfo[ 2 ].bParty = 1;
	m_filterInfo[ 2 ].bTrade = 0;
	m_filterInfo[ 2 ].bWhisper = 1;
	m_filterInfo[ 2 ].bDamage = 1;
	m_filterInfo[ 2 ].bAlly = 0;
	m_filterInfo[ 2 ].bUseItem = 0;
	m_filterInfo[ 2 ].bHero = 0;
	m_filterInfo[ 2 ].bUnion = 0;
	m_filterInfo[ 2 ].bBattle = 0;
	
	m_filterInfo[ 3 ].bSystem = 1;
	m_filterInfo[ 3 ].bChat = 1;
	m_filterInfo[ 3 ].bNormal = 0;
	m_filterInfo[ 3 ].bShout = 1;
	m_filterInfo[ 3 ].bClan = 1;
	m_filterInfo[ 3 ].bParty = 0;
	m_filterInfo[ 3 ].bTrade = 0;
	m_filterInfo[ 3 ].bWhisper = 1;
	m_filterInfo[ 3 ].bDamage = 1;
	m_filterInfo[ 3 ].bAlly = 0;
	m_filterInfo[ 3 ].bUseItem = 0;
	m_filterInfo[ 3 ].bHero = 0;
	m_filterInfo[ 3 ].bUnion = 0;
	m_filterInfo[ 3 ].bBattle = 0;
	
	m_filterInfo[ 4 ].bSystem = 1;
	m_filterInfo[ 4 ].bChat = 1;
	m_filterInfo[ 4 ].bNormal = 0;
	m_filterInfo[ 4 ].bShout = 1;
	m_filterInfo[ 4 ].bClan = 0;
	m_filterInfo[ 4 ].bParty = 0;
	m_filterInfo[ 4 ].bTrade = 0;
	m_filterInfo[ 4 ].bWhisper = 1;
	m_filterInfo[ 4 ].bDamage = 1;
	m_filterInfo[ 4 ].bAlly = 1;
	m_filterInfo[ 4 ].bUseItem = 0;
	m_filterInfo[ 4 ].bHero = 0;
	m_filterInfo[ 4 ].bUnion = 0;
	m_filterInfo[ 4 ].bBattle = 0;
	
	m_filterInfo[ 5 ].bSystem = 0;
	m_filterInfo[ 5 ].bChat = 0;
	m_filterInfo[ 5 ].bNormal = 0;
	m_filterInfo[ 5 ].bShout = 0;
	m_filterInfo[ 5 ].bClan = 0;
	m_filterInfo[ 5 ].bParty = 0;
	m_filterInfo[ 5 ].bTrade = 0;
	m_filterInfo[ 5 ].bWhisper = 1;
	m_filterInfo[ 5 ].bDamage = 0;
	m_filterInfo[ 5 ].bAlly = 0;
	m_filterInfo[ 5 ].bUseItem = 0;
	m_filterInfo[ 5 ].bHero = 1;
	m_filterInfo[ 5 ].bUnion = 0;
	m_filterInfo[ 5 ].bBattle = 0;
	
	m_filterInfo[ 6 ].bSystem = 0;
	m_filterInfo[ 6 ].bChat = 0;
	m_filterInfo[ 6 ].bNormal = 0;
	m_filterInfo[ 6 ].bShout = 0;
	m_filterInfo[ 6 ].bClan = 0;
	m_filterInfo[ 6 ].bParty = 0;
	m_filterInfo[ 6 ].bTrade = 0;
	m_filterInfo[ 6 ].bWhisper = 1;
	m_filterInfo[ 6 ].bDamage = 0;
	m_filterInfo[ 6 ].bAlly = 0;
	m_filterInfo[ 6 ].bUseItem = 0;
	m_filterInfo[ 6 ].bHero = 0;
	m_filterInfo[ 6 ].bUnion = 1;
	m_filterInfo[ 6 ].bBattle = 0;
	
	m_filterInfo[ 7 ].bSystem = 0;
	m_filterInfo[ 7 ].bChat = 0;
	m_filterInfo[ 7 ].bNormal = 0;
	m_filterInfo[ 7 ].bShout = 1;
	m_filterInfo[ 7 ].bClan = 0;
	m_filterInfo[ 7 ].bParty = 0;
	m_filterInfo[ 7 ].bTrade = 0;
	m_filterInfo[ 7 ].bWhisper = 1;
	m_filterInfo[ 7 ].bDamage = 0;
	m_filterInfo[ 7 ].bAlly = 0;
	m_filterInfo[ 7 ].bUseItem = 0;
	m_filterInfo[ 7 ].bHero = 0;
	m_filterInfo[ 7 ].bUnion = 0;
	m_filterInfo[ 7 ].bBattle = 0;
	
	m_filterInfo[ 8 ].bSystem = 0;
	m_filterInfo[ 8 ].bChat = 0;
	m_filterInfo[ 8 ].bNormal = 0;
	m_filterInfo[ 8 ].bShout = 1;
	m_filterInfo[ 8 ].bClan = 0;
	m_filterInfo[ 8 ].bParty = 0;
	m_filterInfo[ 8 ].bTrade = 0;
	m_filterInfo[ 8 ].bWhisper = 1;
	m_filterInfo[ 8 ].bDamage = 0;
	m_filterInfo[ 8 ].bAlly = 0;
	m_filterInfo[ 8 ].bUseItem = 0;
	m_filterInfo[ 8 ].bHero = 0;
	m_filterInfo[ 8 ].bUnion = 0;
	m_filterInfo[ 8 ].bBattle = 1;
	
	
	//실제 사용되지는 않는 더미 값들
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bSystem = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bChat = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bNormal = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bShout = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bClan = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bParty = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bTrade = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bWhisper = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bDamage = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bAlly = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bUseItem = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bHero = 0;
	m_filterInfo[ CHAT_WINDOW_SYSTEM ].bUnion = 0;
	
	//Global Setting
	m_NoUnionCommanderMessage = 0;
	m_NoNpcMessage = 0;				// NPC 대사 필터링 - 2010.9.8 winkey
	m_KeywordFilterSound = 0;
	m_KeywordFilterActivate = 0;
	m_Keyword0 = "";
	m_Keyword1 = "";
	m_Keyword2 = "";
	
}

// 채팅 필터 창의 체크박스 들을 m_filterInfo에따라 세팅해 주고 옵션불에서 시스템 메시지 전용창의 위치를 파악한다.
function SetChatFilterButton()
{
	local bool bSystemMsgWnd;
	local bool bOption;
	local ChatFilterWnd script;

	script = ChatFilterWnd( GetScript("ChatFilterWnd") );
	
	// 시스템 메시지 윈도우 
	bSystemMsgWnd = GetOptionBool( "Game", "SystemMsgWnd" );
	m_hChatFilterWndSystemMsgBox.SetCheck( bSystemMsgWnd );
		
	// 데미지 - DamageBox
	bOption = GetOptionBool( "Game", "SystemMsgWndDamage" );
	m_hChatFilterWndDamageBox.SetCheck( bOption );

	// 소모성아이템사용 - ItemBox
	bOption = GetOptionBool( "Game", "SystemMsgWndExpendableItem" );
	m_hChatFilterWndItemBox.SetCheck( bOption );
	
	//~ debug ("m_chatType.UI" @ m_chatType.UI);
	//~ debug ("m_chatType.ID" @ m_chatType.ID);
	
	//debug("SetChatFilterButton : chattype " $ m_chatType );
	if( m_chatType.UI >= 0 && m_chatType.UI <= CHAT_WINDOW_COUNT )
	{
		if (m_chatType.UI  == 0)
			m_chatType.ID = 0;
		//Print( m_chatType );
		script.SetComboxIDSelect( m_chatType.UI -1, m_chatType.ID );
		switch (m_chatType.ID)
		{
			//전체 
			case 0:
				//~ debug("1");
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(144) , "" ));
				break;
			//매매
			case 1:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(355) , "" ));
				break;
			//파티
			case 2:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(188) , "" ));
				break;
			//혈맹
			case 3:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(128) , "" ));
				break;
			//동맹
			case 4:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(559) , "" ));
				break;
			case 5:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(1961) , "" ));
				break;
			case 6:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(1962) , "" ));
				break;
			case 7:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(1963) , "" ));
				break;
			case 8:
				m_hChatFilterWndCurrentText.SetText(MakeFullSystemMsg( GetSystemMessage(1995), GetSystemString(1964) , "" ));
				break;
			
				//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1961), 5);
	//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1962), 6);
	//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1963), 7);
	//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1964), 8);
			
			
			
		}
		
		m_hChkChatFilterWndCheckBoxSystem.SetCheck( bool(m_filterInfo[m_chatType.UI].bSystem ) );
		//class'UIAPI_CHECKBOX'.static.SetCheck( "ChatFilterWnd.CheckBoxChat", bool(m_filterInfo[m_chatType].bChat ) );
		m_hChkChatFilterWndCheckBoxNormal.SetCheck( bool(m_filterInfo[m_chatType.UI].bNormal ) );
		m_hChkChatFilterWndCheckBoxShout.SetCheck(  bool(m_filterInfo[m_chatType.UI].bShout ) );
		m_hChkChatFilterWndCheckBoxPledge.SetCheck( bool(m_filterInfo[m_chatType.UI].bClan ) );
		m_hChkChatFilterWndCheckBoxParty.SetCheck( bool(m_filterInfo[m_chatType.UI].bParty ) );
		m_hChkChatFilterWndCheckBoxTrade.SetCheck( bool(m_filterInfo[m_chatType.UI].bTrade ) );
		m_hChkChatFilterWndCheckBoxWhisper.SetCheck( bool(m_filterInfo[m_chatType.UI].bWhisper ) );
		m_hChkChatFilterWndCheckBoxDamage.SetCheck( bool(m_filterInfo[m_chatType.UI].bDamage ) );
		m_hChkChatFilterWndCheckBoxAlly.SetCheck( bool(m_filterInfo[m_chatType.UI].bAlly ) );
		m_hChkChatFilterWndCheckBoxItem.SetCheck( bool(m_filterInfo[m_chatType.UI].bUseItem ) );
		m_hChkChatFilterWndCheckBoxHero.SetCheck( bool(m_filterInfo[m_chatType.UI].bHero ) );
		m_hChkChatFilterWndCheckBoxUnion.SetCheck( bool(m_filterInfo[m_chatType.UI].bUnion ) );
		m_hChkChatFilterWndCheckBoxBattleField.SetCheck( bool(m_filterInfo[m_chatType.UI].bBattle ) );


		//Print( m_chatType );
		// 큰 카테고리가 체크 되었는지 여부에 따라 작은 카테고리의 checkbox를 활성/비활성 한다.
		if( !m_hChkChatFilterWndCheckBoxSystem.IsChecked() )
		{
			m_hChkChatFilterWndCheckBoxDamage.SetDisable(true );
			m_hChkChatFilterWndCheckBoxItem.SetDisable( true );
		}
		else
		{
			m_hChkChatFilterWndCheckBoxDamage.SetDisable( false );
			m_hChkChatFilterWndCheckBoxItem.SetDisable( false );
		}

		// 큰 카테고리가 체크 되었는지 여부에 따라 작은 카테고리의 checkbox를 활성/비활성 한다.
//		if( !class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxChat" ) )
//		{
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxNormal", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxShout", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxPledge", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxParty", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxTrade", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxWhisper", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxAlly", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxHero", false );
//			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxUnion", false );
//		}
//		else
		
			m_hChkChatFilterWndCheckBoxNormal.SetDisable( false );
			m_hChkChatFilterWndCheckBoxShout.SetDisable( false );
			m_hChkChatFilterWndCheckBoxPledge.SetDisable( false );
			m_hChkChatFilterWndCheckBoxParty.SetDisable( false );
			m_hChkChatFilterWndCheckBoxTrade.SetDisable( false );
			m_hChkChatFilterWndCheckBoxWhisper.SetDisable( false );
			m_hChkChatFilterWndCheckBoxAlly.SetDisable( false );
			m_hChkChatFilterWndCheckBoxHero.SetDisable( false );
			m_hChkChatFilterWndCheckBoxUnion.SetDisable( false );
			m_hChkChatFilterWndCheckBoxBattleField.SetDisable( false );


		// 활성화 될수 없는 체크박스(기본적으로 체크여부를 유저가 결정할 수 없는 것 들)
		switch( m_chatType.ID )
		{
			case 1:
				m_hChkChatFilterWndCheckBoxTrade.SetDisable( true );
				m_hChkChatFilterWndCheckBoxTrade.SetCheck( true );
				break;
			case 2:
				m_hChkChatFilterWndCheckBoxParty.SetDisable( true );
				m_hChkChatFilterWndCheckBoxParty.SetCheck( true );
				break;
			case 3:
				m_hChkChatFilterWndCheckBoxPledge.SetDisable( true );
				m_hChkChatFilterWndCheckBoxPledge.SetCheck( true );
				break;
			case 4:
				m_hChkChatFilterWndCheckBoxAlly.SetDisable( true );
				m_hChkChatFilterWndCheckBoxAlly.SetCheck( true );
				break;
			case 5:
				m_hChkChatFilterWndCheckBoxHero.SetDisable( true );
				m_hChkChatFilterWndCheckBoxHero.SetCheck( true );
				break;
			case 6:
				m_hChkChatFilterWndCheckBoxUnion.SetDisable( true );
				m_hChkChatFilterWndCheckBoxUnion.SetCheck( true );
				break;
			case 7:
				m_hChkChatFilterWndCheckBoxShout.SetDisable( true );
				m_hChkChatFilterWndCheckBoxShout.SetCheck( true );
				break;
			case 8:
				m_hChkChatFilterWndCheckBoxBattleField.SetDisable( true );
				m_hChkChatFilterWndCheckBoxBattleField.SetCheck( true );
				break;
			

			
			
			
			
			
			default:
				break;
		}
	}
}

function HandleChatWndStatusChange()
{
	//~ local UserInfo userInfo;

	//~ GetPlayerInfo( userInfo );

	//~ if( userInfo.nClanID > 0 )
		//~ ChatTabCtrl.SetDisable(CHAT_WINDOW_CLAN, false);
	//~ else
		//~ ChatTabCtrl.SetDisable(CHAT_WINDOW_CLAN, true);

	//~ if( userInfo.nAllianceID > 0 )
		//~ ChatTabCtrl.SetDisable(CHAT_WINDOW_ALLY, false);
	//~ else
		//~ ChatTabCtrl.SetDisable(CHAT_WINDOW_ALLY, true);
}

function HandleSetString( String a_Param )
{
	local int IsAppend;
	local string tmpString;

	IsAppend = 0;
	ParseInt( a_Param, "IsAppend", IsAppend );
	
	if( ParseString( a_Param, "String", tmpString ) )
	{
		if( IsAppend > 0 )
			ChatEditBox.AddString(tmpString);
		else
			ChatEditBox.SetString(tmpString);
	}
}

function HandleSetFocus()
{
	if( !ChatEditBox.IsFocused() )
		ChatEditBox.SetFocus();
}

function Print( int index )
{
	//debug( "Self=" $ Self $ " m_chatType=" $ m_chatType );
/* 	debug( "Print type(" $ index $ "), system :"	$ m_filterInfo[ index ].bSystem $ ", chat:" $ m_filterInfo[ index ].bChat $ ",Normal:" $ m_filterInfo[ index ].bNormal $
 * 		", shout:" $ m_filterInfo[ index ].bShout $ ",pledge:" $ m_filterInfo[ index ].bClan $ ", party:" $ m_filterInfo[ index ].bParty $ 
 * 		", trade:" $ m_filterInfo[ index ].bTrade $ ", whisper:" $ m_filterInfo[ index ].bWhisper $ ", damage:" $ m_filterInfo[ index ].bDamage $
 * 		", ally:" $ m_filterInfo[ index ].bAlly $ ",useitem:" $ m_filterInfo[ index ].bUseItem $ ", hero:" $ m_filterInfo[ index ].bHero );
 */
}

function HandleMsnStatus( string param )
{
	local string status;
	local ButtonHandle handle;

	if(CREATE_ON_DEMAND==0)
		handle = ButtonHandle(GetHandle("Chatwnd.MessengerBtn"));
	else
		handle = GetButtonHandle("Chatwnd.MessengerBtn");

	ParseString( param, "status", status );
	if( status == "online" )
		handle.SetTexture("L2UI_CH3.Msn.chatting_msn1", "L2UI_CH3.Msn.chatting_msn1_down", "L2UI_CH3.Msn.chatting_msn1_over");
	else if( status == "berightback" || status == "idle" || status == "away" || status == "lunch" )
		handle.SetTexture("L2UI_CH3.Msn.chatting_msn2", "L2UI_CH3.Msn.chatting_msn2_down", "L2UI_CH3.Msn.chatting_msn2_over");
	else if( status == "busy" || status == "onthephone" )
		handle.SetTexture("L2UI_CH3.Msn.chatting_msn3", "L2UI_CH3.Msn.chatting_msn3_down", "L2UI_CH3.Msn.chatting_msn3_over");
	else if( status == "offline" || status == "invisible" )
		handle.SetTexture("L2UI_CH3.Msn.chatting_msn4", "L2UI_CH3.Msn.chatting_msn4_down", "L2UI_CH3.Msn.chatting_msn4_over");
	else if( status == "none" )
		handle.SetTexture("L2UI_CH3.Msn.chatting_msn5", "L2UI_CH3.Msn.chatting_msn5_down", "L2UI_CH3.Msn.chatting_msn5_over");
}

function EChatType GetChatTypeByTabIndex(int Index)
{
	local EChatType Type;
	//~ Type = CHAT_NORMAL;
	
	switch( m_chatType.ID )
	{
	//~ case CHAT_WINDOW_NORMAL:
		//~ Type = CHAT_NORMAL;
		//~ break;
	//~ case CHAT_WINDOW_TRADE:
		//~ Type = CHAT_MARKET;
		//~ break;
	//~ case CHAT_WINDOW_PARTY:
		//~ Type = CHAT_PARTY;
		//~ break;
	//~ case CHAT_WINDOW_CLAN:
		//~ Type = CHAT_CLAN;
		//~ break;
	//~ case CHAT_WINDOW_ALLY:
		//~ Type = CHAT_ALLIANCE;
		//~ break;
	//~ case CHAT_WINDOW_ALLY:
		//~ Type = CHAT_ALLIANCE;
		//~ break;
	//~ case CHAT_WINDOW_ALLY:
		//~ Type = CHAT_ALLIANCE;
		//~ break;
	//~ case CHAT_WINDOW_ALLY:
		//~ Type = CHAT_ALLIANCE;
		//~ break;
	//~ case CHAT_WINDOW_ALLY:
		//~ Type = CHAT_ALLIANCE;
		//~ break;
	case 0:
		Type = CHAT_NORMAL;
		break;
	case 1:
		Type = CHAT_MARKET;
		break;
	case 2:
		Type = CHAT_PARTY;
		break;
	case 3:
		Type = CHAT_CLAN;
		break;
	case 4:
		Type = CHAT_ALLIANCE;
		break;
	case 5:
		Type = CHAT_HERO;
		break;
	case 6:
		Type =CHAT_INTER_PARTYMASTER_CHAT;
		break;
	case 7:
		Type = CHAT_SHOUT;
		break;
	case 8:
		Type = CHAT_DOMINIONWAR;
		break;
	
	default:
		break;
	}
	return Type;
}

//TextLink
function HandleTextLinkLButtonClick( string Param )
{
	local ETextLinkType eType;
	local int Type;
	local int ID;
	local string Title;
	local string LinkName;
	
	ParseInt( Param, "Type", Type );
	ParseInt( Param, "ID", ID );
	ParseString( Param, "Title", Title );
	ParseString( Param, "LinkName", LinkName );
	eType = ETextLinkType( Type );
	
	if( eType == TLT_User )
	{
		if( Left( Title, 2 ) == "->" )
			Title = Mid( Title, 2 );
		SetChatMessage( "\"" $ Title $ " " );
	}
}

function HandleDominionWarChannelSet( string param )
{
	local int DominionWarChannelSet;
	
	ParseInt(param, "DominionWarChannelSet", DominionWarChannelSet);
	
	if (DominionWarChannelSet == 1)
	{
		AddSystemMessage(2445);

	}
	else
	{
		AddSystemMessage(2446);
	}
}

function ChangeTabChannel(int ChannelIndex)
{
	switch (ChannelIndex)
	{
		case 1:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(355));
			//~ SetINIInt("global", "TabIndex1", ChannelIndex, "chatfilter.ini");
			//~ m_ChatUI[8].ID = 1;
			//~ m_ChatUI[].UI = m_chatType.UI;
			//~ AssignCurrentChatTypeID(ChannelIndex, m_chatType.UI);
		break;
		case 2:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(188));
			//~ SetINIInt("global", "TabIndex2", 2, "chatfilter.ini");
		break;
		case 3:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(128));
			//~ SetINIInt("global", "TabIndex3", 3, "chatfilter.ini");
		break;
		case 4:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(559));
			//~ SetINIInt("global", "TabIndex4", 4, "chatfilter.ini");
		break;
		case 5:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(1961));
			//~ SetINIInt("global", "TabIndex5", 5, "chatfilter.ini");
		break;
		case 6:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(1962));
			//~ SetINIInt("global", "TabIndex6", 6, "chatfilter.ini");
		break;
		case 7:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(1963));
			//~ SetINIInt("global", "TabIndex7", 7, "chatfilter.ini");
		break;
		case 8:
			ChatTabCtrl.SetButtonName( m_chatType.UI, GetSystemString(1964));
			//~ SetINIInt("global", "TabIndex8", 8, "chatfilter.ini");
		break;
	}
	//~ SetINIInt("global", "TabIndex1", ChannelIndex, "chatfilter.ini");
	AssignCurrentChatTypeID(ChannelIndex, m_chatType.UI);
	SetCurrentAssignedChatType2Ini(ChannelIndex, m_chatType.UI);
}

function SetCurrentAssignedChatType2Ini(int ChannelIndex, int ChatType)
{
	//~ local int i;
	//~ for (i=0;i<5;i++)
	//~ {
	SetINIInt("global", "TabIndex" $ string(ChatType) , ChannelIndex, "chatfilter.ini");
		
	//~ }
}


function GetAllcurrentAssignedChatTypeID()
{
	local int i;
	local int index;
	SetINIInt("global", "TabIndex0", 0, "chatfilter.ini");
	//Reset Procedure
	for (i=0;i<5;i++)
	{
		m_ChatUI[i].ID = i;
		m_ChatUI[i].UI = i;
	}
	//
	for (i=1;i<5;i++)
	{
		GetINIInt( "global", "TabIndex" $ string(i), index, "chatfilter.ini" );
		if (index > 0 && i > 0)
		{
			m_ChatUI[i].UI = i;
			m_ChatUI[i].ID = index;
			
			m_chatType.UI = i;
			ChangeTabChannel(index);
		}
		else
		{
			//~ INI에 0으로 들어 있으면 기본값으로 세팅;						
			AssignCurrentChatTypeID (i, i);
			switch (i)
			{
				case 1:
					m_ChatUI[1].ID = 1;
					ChatTabCtrl.SetButtonName( 1, GetSystemString(355));
					SetINIInt("global", "TabIndex1", 1, "chatfilter.ini");
					m_chatType.UI = i;
					ChangeTabChannel(1);
				break;
				case 2:
					m_ChatUI[2].ID = 2;
					ChatTabCtrl.SetButtonName( 2, GetSystemString(188));
					SetINIInt("global", "TabIndex2", 2, "chatfilter.ini");
					m_chatType.UI = i;
					ChangeTabChannel(2);
				break;
				case 3:
					m_ChatUI[3].ID = 3;
					ChatTabCtrl.SetButtonName( 3, GetSystemString(128));
					SetINIInt("global", "TabIndex3", 3, "chatfilter.ini");
					m_chatType.UI = i;
					ChangeTabChannel(3);
				break;
				case 4:
					m_ChatUI[4].ID = 4;
					ChatTabCtrl.SetButtonName( 4, GetSystemString(559));
					SetINIInt("global", "TabIndex4", 4, "chatfilter.ini");
					m_chatType.UI = i;
					ChangeTabChannel(4);
				
				break;
			}
		}
	}
}

function AssignCurrentChatTypeID (int ChatTypeID, int ChatTypeUI)
{
	local int i;
	for (i=1;i<5;i++)
	{
		if (m_ChatUI[i].UI == ChatTypeUI)
		{
			m_ChatUI[i].ID = ChatTypeID;
			break;
		}
	}
}


function int GetCurrentChatTypeID (int ChatTypeUI)
{
	local int i;
	for (i=1;i<5;i++)
	{
		if (m_ChatUI[i].UI == ChatTypeUI)
		{
			//~ native final function bool GetINIInt( string section, string key, out int value, string file );
			return m_ChatUI[i].ID;
			break;
		}
	}
}
//~ SetINIString("global", "Keyword0", script.m_Keyword0, "chatfilter.ini");
//~ SetINIString("global", "Keyword1", script.m_Keyword1, "chatfilter.ini");
//~ SetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini");
//~ SystemString(355)
//~ m_ChannelAssignComboBox.AddStringWithReserved(Get, 1);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(188), 2);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(128), 3);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(559), 4);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1961), 5);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1962), 6);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1963), 7);
//~ m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1964), 8);
defaultproperties
{
}
