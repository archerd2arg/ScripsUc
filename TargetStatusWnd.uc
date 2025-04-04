class TargetStatusWnd extends UICommonAPI;
	
const CONTRACT_HEIGHT = 55;
const EXPAND_HEIGHT = 89;

var bool m_bExpand;
var bool myPet;
var bool contextOwner;

var int	m_TargetLevel;
var int	m_TargetID;

var int IconType;

var bool m_bShow;

var string g_NameStr;

var WindowHandle	Me;

var BarHandle		barHP;
var TextureHandle	tex_BarHPFrame;
var TextBoxHandle	txt_TargetHP;

var BarHandle		barMP;
var TextureHandle 	tex_BarMPFrame;

var TextBoxHandle	txtPledgeAllianceName;
var TextureHandle	texPledgeAllianceCrest;
var TextBoxHandle	txtAlliance;
var TextBoxHandle	txtPledgeName;
var TextureHandle	texPledgeCrest;
var TextBoxHandle	txtPledge;

var NameCtrlHandle	RankName;
var NameCtrlHandle	UserName;

var TreeHandle		NpcInfo;

var TextureHandle	tex_TargetControlDrag;
var TextureHandle	tex_ClassIcon;
var TextureHandle	tex_ClassIconFrame;

var ButtonHandle	btnClose;
var ButtonHandle	btnExpand;
var ButtonHandle	btnContract;


var PartyWnd		script_PartyWnd;
//var ContextMenuWnd	script_ContextMenuWnd;

var WindowHandle	wnd_contextMenu;


function OnLoad()
{
	//local int idx;
	
	Me = GetWindowHandle("TargetStatusWnd");
	
	wnd_contextMenu = GetWindowHandle("ContextMenuWnd");

	barHP = GetBarHandle( "TargetStatusWnd.barHP" );
	tex_BarHPFrame =  GetTextureHandle("TargetStatusWnd.texbarHPFrame");
	txt_TargetHP = GetTextBoxHandle("TargetStatusWnd.txtTargetHP");
	barMP = GetBarHandle("TargetStatusWnd.barMP");
	tex_BarMPFrame =  GetTextureHandle("TargetStatusWnd.texbarMPFrame");

	txtPledgeAllianceName = GetTextBoxHandle("TargetStatusWnd.txtPledgeAllianceName");
	texPledgeAllianceCrest = GetTextureHandle("TargetStatusWnd.texPledgeAllianceCrest");
	txtAlliance = GetTextBoxHandle("TargetStatusWnd.txtAlliance");
	txtPledgeName = GetTextBoxHandle("TargetStatusWnd.txtPledgeName");
	texPledgeCrest = GetTextureHandle("TargetStatusWnd.texPledgeCrest");
	txtPledge = GetTextBoxHandle("TargetStatusWnd.txtPledge");
	
	RankName = GetNameCtrlHandle("TargetStatusWnd.RankName");
	UserName = GetNameCtrlHandle("TargetStatusWnd.UserName");

	NpcInfo = GetTreeHandle("TargetStatusWnd.NpcInfo");
	
	btnClose = GetButtonHandle("TargetStatusWnd.btnClose");
	btnExpand = GetButtonHandle("TargetStatusWnd.btnExpand");
	btnContract= GetButtonHandle("TargetStatusWnd.btnContract");
	
	NpcInfo = GetTreeHandle("TargetStatusWnd.NpcInfo");
	
	tex_TargetControlDrag = GetTextureHandle("TargetStatusWnd.texTargetControlDrag");;
	tex_ClassIcon = GetTextureHandle("TargetStatusWnd.texClassIcon");
	tex_ClassIconFrame = GetTextureHandle("TargetStatusWnd.texClassIconFrame");
	
	SetExpandMode(false);

	script_PartyWnd = PartyWnd(GetScript("PartyWnd"));
	//script_ContextMenuWnd = ContextMenuWnd(GetScript("ContextMenuWnd"));
	
	g_NameStr = "";
	
	m_bShow = false;
	m_TargetID = -1;
	contextOwner = false;
	
	//tex_ClassIconFrame.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 19, 7);
	//tex_ClassIconFrame.SetWindowSize(13, 13);
	IconType = 1;
	GetINIInt("WindowsCheks", "DetailIcons", IconType, "PatchSettings");
	
	SetupIconClass(IconType);
	
//	if (idx == 2)
	//{
//		tex_ClassIconFrame.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 17, 5);
//		tex_ClassIconFrame.SetWindowSize(18, 18);
//		IconType = 2;
	//}
	
	tex_ClassIcon.HideWindow();
	tex_ClassIconFrame.HideWindow();
//	btnIcon.HideWindow();
//	Me.HideWindow();

}


function OnRegisterEvent()
{
	RegisterEvent( EV_TargetUpdate );
	RegisterEvent( EV_UpdateHP );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMaxHP );
	RegisterEvent( EV_UpdateMaxMP );
	RegisterEvent( EV_ReceiveTargetLevelDiff );
	RegisterEvent( EV_UpdatePetInfo );
	
}


function OnEvent(int Event_ID, string param)
{
/*	local UserInfo TargetInfo;	//some AutoAssist via PartyChat
	local UserInfo Player;*/
	
	if (Event_ID == EV_TargetUpdate)
	{
		HandleTargetUpdate();		
		/*GetPlayerInfo(Player);	//some AutoAssist via PartyChat
		if (m_targetID > 0  && script_PartyWnd.cb_Crown.isShowWindow())
			if (GetUserInfo(m_targetID, TargetInfo))
			{
				if (TargetInfo.bNpc && !TargetInfo.bPet && Player.Name != TargetInfo.Name)
				{
					script_PartyWnd.WriteTargetToPartyChat(TargetInfo.nID);
					script_PartyWnd.g_MsgAutoAssist = -1;
				}
			}	*/				
	}
	else if (Event_ID == EV_ReceiveTargetLevelDiff)
	{
		HandleReceiveTargetLevelDiff(param);		
	}
	else if (Event_ID == EV_UpdateHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMaxHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		HandleUpdateGauge(param,1);
	}
	else if (Event_ID == EV_UpdateMaxMP)
	{
		HandleUpdateGauge(param,1);
	}
	else if (Event_ID == EV_UpdatePetInfo)
	{
		if (myPet) 
			UpdateHPBar(0, 0);
	}	
}


function OnShow()
{
	m_bShow = true;	
}


function OnHide()
{
	m_bShow = false;
	g_NameStr = "";
}


function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnClose":
		OnCloseButton();
		break;
	case "btnExpand":
		SetExpandMode(false);
		break;
	case "btnContract":
		SetExpandMode(true);
		break;
//	case "btnIcon":
//		ExecuteCommand("/olympiadstat");
//		break;
	}
}


function SetupIconClass(int iconNum)
{
	IconType = iconNum;
	
	switch (iconNum)
	{
		case 1:
			tex_ClassIconFrame.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 19, 7);
			tex_ClassIconFrame.SetWindowSize(13, 13);
			break;
		
		case 2:
			tex_ClassIconFrame.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 17, 5);
			tex_ClassIconFrame.SetWindowSize(18, 18);
			break;
	}
}


function OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
	local int playerID;
	
	if (wnd_contextMenu.isShowWindow() && contextOwner)
	{
		wnd_contextMenu.HideWindow(); 
	}
	
	if (a_WindowHandle == tex_ClassIcon)
	{
		playerID = class'UIDATA_PLAYER'.static.GetplayerID();
		if (playerID == m_targetID )
			ExecuteCommand("/olympiadstat");
	}
}


function OnRButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;	
	local UserInfo info;
	
	local int contectType;
	local int playerID;
	local int PetID;
	local int IsPetOrSummoned;
	
	rectWnd = Me.GetRect();

	if (X >= rectWnd.nX  && (X <= rectWnd.nX  + rectWnd.nWidth - 10))
	{
//		if (m_targetID > 0 && playerID != m_targetID && !info.bNpc && !info.bPet)
		if (m_targetID > 0)
		{
			playerID = class'UIDATA_PLAYER'.static.GetplayerID();
			GetUserInfo(m_targetID, info);
			PetID = class'UIDATA_PET'.static.GetPetID();
			
			if (!info.bNpc && !info.bPet && m_TargetID != playerID)	// OTHER PLAYER
			{
				contectType = 2;
			}
			else if (playerID == m_targetID)		// SELF PLAYER
			{
				contectType = 5;
			}
			else if (info.bNpc && info.bPet && m_TargetID == PetID)		// IsPetOrSummoned
			{
				IsPetOrSummoned = class'UIDATA_PET'.static.GetIsPetOrSummoned();	// sum = 1; pet = 2;
				if (IsPetOrSummoned == 1)	// MY sum
				{
					contectType = 3;
				}
				else if (IsPetOrSummoned == 2)	// MY PET
				{
					contectType = 4;
				}
			}
			else
				return;
	
			if (wnd_contextMenu.isShowWindow()) 
			{
				wnd_contextMenu.HideWindow();
			}
			
			contextOwner = true;
			
			wnd_contextMenu.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", x - rectWnd.nX - 30, y - rectWnd.nY - 40);
			//script_ContextMenuWnd.SummonContextMenu(contectType, m_TargetID, UserName.GetName());
		}
	}
}


function OnLButtonDblClick (WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	
	rectWnd = Me.GetRect();
	
 	if (wnd_contextMenu.isShowWindow() && contextOwner)
	{
		wnd_contextMenu.HideWindow(); 
	}
		
	if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) )
	{
		if ( m_targetID != -1 )
		{
			if ( GetPlayerInfo(UserInfo) )
			{
				if ( IsPKMode() )
				{
					RequestAttack(m_targetID,UserInfo.Loc);
				}
				else
				{
					RequestAction(m_targetID,UserInfo.Loc);
				}    
			}
		}
	}
}


//종료
function OnCloseButton()
{
	RequestTargetCancel();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//HP,MP 업데이트
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	
	if (m_bShow)
	{
		ParseInt( param, "ServerID", ServerID );
		if (m_TargetID == ServerID)
			HandleTargetUpdateGauge( Type );
	}
}


//타겟과의 레벨 차이
function HandleReceiveTargetLevelDiff(string param)
{
	ParseInt(param, "LevelDiff", m_TargetLevel);
	m_TargetID = -1	;	// to trick "same target check"
	HandleTargetUpdate();
}


//타겟 정보 업데이트 처리(HP, MP)
function HandleTargetUpdateGauge( int Type )
{
	local UserInfo	info;
	local int		TargetID;
	
	//타겟ID 얻어오기
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	
	if (TargetID < 1)
	{
		Me.HideWindow();
		return;
	}
	
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
	
	switch( Type )
	{
		case 0:
			UpdateHPBar(info.nCurHP, info.nMaxHP);
			break;
		
		case 1:
			UpdateMPBar(info.nCurMP, info.nMaxMP);
			break;
	}	
}

//타겟 정보 업데이트 처리
function HandleTargetUpdate()
{
	local Rect rectWnd;
	local string strTmp;
	
	local int		TargetID;
	local int		playerID;
	local int		PetID;
	local int		ClanType;
	local int		ClanNameValue;
	
	//타겟 속성 정보
	local bool		bIsServerObject;
	local bool		bIsHPShowableNPC;	//공성진지
	local bool		bIsVehicle;
	
	local string	Name;
	local string	NameRank;
	local color	TargetNameColor;
	
	//ServerObject
	local int ServerObjectNameID;
	local Actor.EL2ObjectType ServerObjectType;
	
	//Vehicle
	local Vehicle	VehicleActor;
	local string	DriverName;
	
	//HP,MP
	local bool		bShowHPBar;
	local bool		bShowMPBar;
	
	//혈맹 정보
	local bool		bShowPledgeInfo;
	local bool		bShowPledgeTex;
	local bool		bShowPledgeAllianceTex;
	local string	PledgeName;
	local string	PledgeAllianceName;
	local texture	PledgeCrestTexture;
	local texture	PledgeAllianceCrestTexture;
	local color	PledgeNameColor;
	local color	PledgeAllianceNameColor;
	
	//NPC특성
	local bool		 bShowNpcInfo;
	local Array<int>	 arrNpcInfo;
	
	//새로운Target인가?
//	local bool		IsTargetChanged;
	
	local bool  WantHideName;
	local int 	nMasterID;
	
	local UserInfo	info;
//	local UserInfo PlayerInfo;
	local int ClassID;
	
	local Color WhiteColor;	//  하얀색을 설정.
	
	WhiteColor.R = 0;
	WhiteColor.G = 0;
	WhiteColor.B = 0;
	
	myPet = false;		// added to more effective display HP pet/sum status

//	GetPlayerInfo(PlayerInfo);
	
//	ClassID = Info.nSubClass; 
	
	//타겟ID 얻어오기
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	
	if (TargetID < 1)
	{
		if (contextOwner && wnd_contextMenu.isShowWindow())
		{
		//	script_ContextMenuWnd.tex_ContextMenuIconHighlight.HideWindow();
			wnd_contextMenu.HideWindow();
		//	contextOwner = false;
		}
		m_TargetID = TargetID;
		Me.HideWindow();
		return;
	}

	if (m_TargetID != TargetID)
	{
	//	IsTargetChanged = true;	
		if (contextOwner && wnd_contextMenu.isShowWindow())
		{
		//	script_ContextMenuWnd.tex_ContextMenuIconHighlight.HideWindow();
			wnd_contextMenu.HideWindow();
		//	contextOwner = false;
		}
	}
	else
	{
	//	IsTargetChanged = false;
		return;
	}
	
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
//	PrintUserInfo(info);
	nMasterID= info.nMasterID;
	WantHideName= info.WantHideName;
	
	rectWnd = Me.GetRect();
	PledgeName = GetSystemString(431);
	PledgeAllianceName = GetSystemString(591);
	PledgeNameColor.R = 128;
	PledgeNameColor.G = 128;
	PledgeNameColor.B = 128;
	PledgeAllianceNameColor.R = 128;
	PledgeAllianceNameColor.G = 128;
	PledgeAllianceNameColor.B = 128;
	
	TargetNameColor = GetTargetNameColor(m_TargetLevel);
	
	bIsServerObject = class'UIDATA_TARGET'.static.IsServerObject();
	bIsVehicle = class'UIDATA_TARGET'.static.IsVehicle();

	tex_ClassIcon.SetTexture("");
	tex_ClassIconFrame.HideWindow();
	tex_ClassIcon.HideWindow();
	
	if (bIsServerObject)
	{
		
		ServerObjectType = class'UIDATA_STATICOBJECT'.static.GetServerObjectType(m_TargetID);
		

		
//		btnIcon.SetTexture("","","");
	//	btnIcon.HideWindow();
		
		
		if (ServerObjectType == EL2_AIRSHIPKEY)
		{
			Name = GetSystemString( 1966 );	//조종 키
			NameRank = "";
		}
		else
		{
			ServerObjectNameID = class'UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_TargetID);
			if (ServerObjectNameID>0)
			{
				Name = class'UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
				NameRank = "";
			}
		}		
		
		UserName.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
		
		//HP표시
		if (ServerObjectType == EL2_DOOR)
		{
			if( class'UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP( m_TargetID ) )
			{
				bShowHPBar = true;
				UpdateHPBar(class'UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_TargetID), class'UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_TargetID));
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//탈것인가?
	else if( bIsVehicle )
	{	

		//btnIcon.SetTexture("","","");
		//btnIcon.HideWindow();
		Me.HideWindow();
		return;
		
		//TO DO : 배이름, 나중에 SYSSTRING또는 서버에서 얻어오는 것으로 하자.
		UserName.SetName("AirShip", NCT_Normal,TA_Center);
		
		VehicleActor = Vehicle(class'UIDATA_TARGET'.static.GetTargetActor());
		if( VehicleActor != None )
		{
			//선장 이름
			if(VehicleActor.DriverID > 0 )
				DriverName = class'UIDATA_USER'.static.GetUserName( VehicleActor.DriverID );
			if( Len(DriverName) < 1 )
				DriverName = GetSystemString( 1967 );	// 조종사 없음
			RankName.SetName( DriverName, NCT_Normal,TA_Center );
		}		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//타겟ID는 있는데 이름을 알수없다면, 멀리있는 파티멤버로 가정
	else if (Len(info.Name)<1)
	{		
	//	btnIcon.SetTexture("","","");
	//	btnIcon.HideWindow();
		Name = class'UIDATA_PARTY'.static.GetMemberVirtualName(m_TargetID);
		if ( Name == "")
		{
			Name = class'UIDATA_PARTY'.static.GetMemberName(m_TargetID);
		}
		NameRank = "";
		UserName.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Npc or Pc 의 경우
	else
	{
		playerID = class'UIDATA_PLAYER'.static.GetplayerID();
		PetID = class'UIDATA_PET'.static.GetPetID();
		
		bIsHPShowableNPC = class'UIDATA_TARGET'.static.IsHPShowableNPC();

		//if ((info.bNpc && !info.bPet && info.bCanBeAttacked ) ||	//몹의경우
		if ((info.bNpc && !info.bPet && bIsHPShowableNPC) ||	//몹의경우
			(playerID>0 && m_TargetID == playerID) ||		//나의경우
			(info.bNpc && info.bPet && m_TargetID == PetID) ||	//펫의경우
			(info.bNpc && bIsHPShowableNPC)	)		//공성진지
		{
			
		//	btnIcon.SetTexture("","","");
		//	btnIcon.HideWindow();

			if(IsAllWhiteID(info.nClassID))
			{
				Name = info.Name;
				NameRank = "";
				UserName.SetName(Name, NCT_Normal,TA_Center);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
					
				//HP표시
				if(! (IsNoBarID(info.nClassID)))
				{
					bShowHPBar = true;
					UpdateHPBar(info.nCurHP, info.nMaxHP);
				}
			}
			else
			{
				Name = info.Name;
				NameRank = "";	
				UserName.SetNameWithColor(Name, NCT_Normal,TA_Center,TargetNameColor);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
				
				//HP표시
				bShowHPBar = true;
				//if (info.bNpc && info.bPet && m_TargetID == PetID) 
				if (m_TargetID == PetID) 	
					myPet = true;
				UpdateHPBar(info.nCurHP, info.nMaxHP);
				
				//MP표시
				if (!(info.bNpc && !info.bPet))
				{
					bShowMPBar = true;
					UpdateMPBar(info.nCurMP, info.nMaxMP);
				}								
			}
		
			if (playerID > 0 && m_TargetID == playerID)
			{
					ClassID = Info.nSubClass;

					//tex_ClassIcon.SetTexture(GetDetailedClassIconName(ClassID, 4));
					tex_ClassIconFrame.ShowWindow();
					tex_ClassIcon.ShowWindow();
			}	
		
		}
		//Npc or Other Pc
		else
		{
			Name = info.Name;
			ClassID = Info.nSubClass;
			
			if (WantHideName)
			{
				RankName.hideWindow();		
			}
			
			if (info.bNpc)
			{
				NameRank = "";	
				g_NameStr = "";
				
			//	btnIcon.SetTexture("","","");
			//	btnIcon.HideWindow();
			}
			else
			{
				NameRank = GetClassType(Info.nSubClass) $ " [" $ GetUserRankString(Info.nUserRank) $ "]";
				g_NameStr = Name;
				
				//tex_ClassIcon.SetTexture(GetDetailedClassIconName(ClassID, 4));
				tex_ClassIconFrame.ShowWindow();
				tex_ClassIcon.ShowWindow();		
			}
			UserName.SetName(Name, NCT_Normal,TA_Center);
			RankName.SetName(NameRank, NCT_Normal,TA_Center);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/// 추가 정보 표시
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (m_bExpand)
		{
			if (info.bNpc && 0 >= info.nMasterID)
			{
				if (class'UIDATA_NPC'.static.GetNpcProperty(info.nClassID, arrNpcInfo))
				{
					bShowNpcInfo = true;
					
					//트리컨트롤에 Npc특성아이콘 추가
					//타겟이 바뀌었을때만 정보를 갱신한다. 안그럼 HP만 갱신될 때 깜박거림
			//		if (IsTargetChanged)
						UpdateNpcInfoTree(arrNpcInfo);
				}				
			}
			else
			{
				bShowPledgeInfo = true;

				if (info.nClanID>0)						
				{
					//혈맹이름
					PledgeName = class'UIDATA_CLAN'.static.GetName(info.nClanID);
					PledgeNameColor.R = 176;
					PledgeNameColor.G = 152;
					PledgeNameColor.B = 121;
					if( PledgeName != "" && class'UIDATA_USER'.static.GetClanType( m_TargetID, ClanType ) && class'UIDATA_CLAN'.static.GetNameValue(info.nClanID, ClanNameValue) )
					{
						if( ClanType == CLAN_ACADEMY )
						{
							PledgeNameColor.R = 209;
							PledgeNameColor.G = 167;
							PledgeNameColor.B = 2;
						}
						else if( ClanNameValue > 0 )
						{
							PledgeNameColor.R = 0;
							PledgeNameColor.G = 130;
							PledgeNameColor.B = 255;
						}
						else if( ClanNameValue < 0 )
						{
							PledgeNameColor.R = 255;
							PledgeNameColor.G = 0;
							PledgeNameColor.B = 0;
						}
					}
					
					//혈맹 텍스쳐 얻어오기
					if (class'UIDATA_CLAN'.static.GetCrestTexture(info.nClanID, PledgeCrestTexture))
					{
						bShowPledgeTex = true;
						texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
					}
					else
					{
						bShowPledgeTex = false;
					}
					
					//동맹이름 및 마크
					strTmp = class'UIDATA_CLAN'.static.GetAllianceName(info.nClanID);
					if (Len(strTmp)>0)
					{
						//동맹 이름 색깔
						PledgeAllianceName = strTmp;
						PledgeAllianceNameColor.R = 176;
						PledgeAllianceNameColor.G = 155;
						PledgeAllianceNameColor.B = 121;
						
						//동맹 텍스쳐 얻어오기
						if (class'UIDATA_CLAN'.static.GetAllianceCrestTexture(info.nClanID, PledgeAllianceCrestTexture))
						{
							bShowPledgeAllianceTex = true;
							texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
						}
						else
						{
							bShowPledgeAllianceTex = false;
						}
					}
				}
			}
		}
	}
	if (!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		Me.ShowWindow();
		SetExpandMode(m_bExpand);
	}
	
	//HP,MP표시
	if (bShowHPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		tex_BarHPFrame.ShowWindow();
		barHP.ShowWindow();
		txt_TargetHP.ShowWindow();
	}
	else
	{
		tex_BarHPFrame.HideWindow();
		barHP.HideWindow();
		txt_TargetHP.HideWindow();
	}
	
	if (bShowMPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		if (info.bPet && m_TargetID != PetID) // ubiraem pustoe mp u chujih summov
		{
			tex_BarMPFrame.HIdeWindow();
			barMP.HIdeWindow();
		}
		else
		{
			tex_BarMPFrame.ShowWindow();
			barMP.ShowWindow();
		}
	}
	else
	{
		tex_BarMPFrame.HIdeWindow();
		barMP.HIdeWindow();
	}
	
	//Hide Cursed PC Name, ttmayrin
	if( info.nClanID < 0 )
		bShowPledgeInfo = false;
		
	//혈맹정보 표시
	if (bShowPledgeInfo)
	{
		 if (!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE" )
		{
			txtPledge.ShowWindow();
			txtAlliance.ShowWindow();
			txtPledgeName.ShowWindow();
			txtPledgeAllianceName.ShowWindow();
			txtPledgeName.SetText(PledgeName);
			txtPledgeAllianceName.SetText(PledgeAllianceName);
			txtPledgeName.SetTextColor(PledgeNameColor);
			txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
		
			if (bShowPledgeTex)
			{
				texPledgeCrest.ShowWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 71, rectWnd.nY + 58);
			}
			else
			{
				texPledgeCrest.HideWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 52, rectWnd.nY + 58);
			}
			
			if (bShowPledgeAllianceTex)
			{
				texPledgeAllianceCrest.ShowWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 71, rectWnd.nY + 73);
			}
			else
			{
				texPledgeAllianceCrest.HideWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 52, rectWnd.nY + 73);
			}
		}
		
		else
		{		
			txtPledge.HideWindow();
			txtAlliance.HideWindow();
			txtPledgeName.HideWindow();
			txtPledgeAllianceName.HideWindow();
			texPledgeCrest.HideWindow();
			texPledgeAllianceCrest.HideWindow();
				
		}
	}
	else
	{
		txtPledge.HideWindow();
		txtAlliance.HideWindow();
		txtPledgeName.HideWindow();
		txtPledgeAllianceName.HideWindow();
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
		
	}
	
	//NPC특성 표시
	if (bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		NpcInfo.ShowWindow();
		NpcInfo.ShowScrollBar(false);
	}
	else
	{
		NpcInfo.HideWindow();
	}
}

//Frame Expand버튼 처리

//Expand상태에 따른 여러가지 처리

// 타겟과의 레벨 차이에 따른 색상 값 얻어오기
function Color GetTargetNameColor(int TargetLevelDiff)
{
	local Color OutColor;
	local UserInfo userinfo;
	local int myLevel;


	GetPlayerInfo( userinfo );
	myLevel = userinfo.nLevel;
	
	OutColor.A = 255;
	
	if (myLevel < 78 )
	{
		if (TargetLevelDiff <= -9)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -9 &&TargetLevelDiff <= -6)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -6 &&TargetLevelDiff <= -3)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -3 &&TargetLevelDiff <= 2)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 5 &&TargetLevelDiff <= 8)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 8)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	} 
	else 
	{
		// 유저레벨 78이상 일 경우 레벨 차이 색상 표시를 줄여 보여준다. 
		if (TargetLevelDiff <= -8)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -8 &&TargetLevelDiff <= -5)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -5 &&TargetLevelDiff <= -2)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -2 &&TargetLevelDiff <= 1)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 1 &&TargetLevelDiff <= 3)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 3 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 5)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	}
	return OutColor;
}



function SetExpandMode(bool bExpand)
{
	local int nWndWidth, nWndHeight;	// 윈도우 사이즈 받기 변수
	Me.GetWindowSize(nWndWidth, nWndHeight);
	
	m_bExpand = bExpand;
	
	m_TargetID = -1;
	HandleTargetUpdate();
	
	if (bExpand)
	{
		btnExpand.ShowWindow();
		btnContract.HideWindow();
		Me.SetWindowSize(nWndWidth, EXPAND_HEIGHT);
	}
	else
	{
		btnExpand.HideWindow();
		btnContract.ShowWindow();
		Me.SetWindowSize(nWndWidth, CONTRACT_HEIGHT);
	}
}

//HP바 갱신
function UpdateHPBar(int HP, int MaxHP)
{
	local float Percent;
	local PetInfo	info;
	
	if (myPet)
		if (GetPetInfo(info))
			{
				HP = info.nCurHP;
				MaxHP = info.nMaxHP;	
			}
	Percent = getPercent(HP,MaxHP)*100;
	barHP.SetValue(MaxHP, HP);
	//barHP.SetPoint(MaxHP, HP);
	txt_TargetHP.SetText(string(Percent) $ "%");
}

//MP바 갱신
function UpdateMPBar(int MP, int MaxMP)
{
	barMP.SetValue(MaxMP, MP);
}

//트리컨트롤에 Npc특성아이콘 추가
function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i;
	local int SkillID;
	local int SkillLevel;
	local int nWndWidth, nWndHeight;
	local int divider;
	local string				strNodeName;
	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	
	//초기화
	NpcInfo.Clear();
	Me.GetWindowSize(nWndWidth, nWndHeight);
	if (nWndWidth >= 245) 
		divider = 10 + (nWndWidth - 245)/18;
	else
		divider = 10;
	//루트 추가
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);
	if (Len(strNodeName) < 1)
	{
		return;
	}
	
	if (divider*2 < arrNpcInfo.Length)
		NpcInfo.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 20, 55);
	else
		NpcInfo.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 20, 57);
	
	for (i = 0; i < arrNpcInfo.Length; i += 2)
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[i+1];
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node
		infNode = infNodeClear;
		infNode.nOffSetX = ((i/2)%divider)*18;

		if ((i/2)%divider==0)
		{
			if (i>0)
			{
				infNode.nOffSetY = 1;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}
		
		infNode.strName = "" $ i/2;
		infNode.bShowButton = 0;
		//Tooltip
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);
		if (Len(strNodeName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		//Node Tooltip Clear
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert NodeItem
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		infNodeItem.u_strTexture = class'UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
	}
}

function CustomTooltip SetNpcInfoTooltip(int ID, int Level)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	local DrawItemInfo infoClear;
	local ItemInfo Item;
	local ItemID cID;
	
	cID = GetItemID(ID);
	
	Item.Name = class'UIDATA_SKILL'.static.GetName(cID, Level);
	Item.Description = class'UIDATA_SKILL'.static.GetDescription(cID, Level);
	
	Tooltip.DrawList.Length = 1;
	
	//이름
	info = infoClear;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Item.Name;
	Tooltip.DrawList[0] = info;

	//설명
	if (Len(Item.Description)>0)
	{
		Tooltip.MinimumWidth = 144;
		Tooltip.DrawList.Length = 2;
		
		info = infoClear;
		info.eType = DIT_TEXT;
		info.nOffSetY = 6;
		info.bLineBreak = true;
		info.t_color.R = 178;
		info.t_color.G = 190;
		info.t_color.B = 207;
		info.t_color.A = 255;
		info.t_strText = Item.Description;
		Tooltip.DrawList[1] = info;	
	}
	return Tooltip;
}

//항상 흰색으로 표시해 줄 몬스터를 체크하는 함수
function bool IsAllWhiteID(int m_TargetID)
{
	local bool	bIsAllWhiteName;
	bIsAllWhiteName = false;
	
	switch( m_TargetID )
	{
		case 12775:	//박
		case 12776:
		case 12778:
		case 12779:
		case 13016:
		case 13017:	// 박
		case 13031:	//거대 돼지
		case 13032:	//거대 돼지 리더
		case 13033:	//거대 돼지 부하
		case 13034:	//초거대 돼지
		case 13035:	//황금 돼지
		case 13036:	//연금술사의 보물상자
		case 13098:	//보물찾기 보물상자
		case 13120:	//거대 쥐
		case 13121:	
		case 13122:	
		case 13123:	
		case 13124:	

		// 수박 이벤트 2009. 8.14 추가 
		case 13271:
		case 13272:
		case 13273:
		case 13274:
		case 13275:
		case 13276:
		case 13277:
		case 13278:

		// 소 이벤트 2009. 8.14 추가 
		case 13187:
		case 13188:
		case 13189:
		case 13190:
		case 13191:
		case 13192:

		// 백호 이벤트 2019. 2.29 추가 
		case 13286: // 아기 백호
		case 13287: // 아기 백호 대장
		case 13288: // 우울한 아기 백호
		case 13289: // 우울한 아기 백호 대장
		case 13290: // 백호
		case 13291: // 백호 대장
		case 13292: // 마법 연구소 직원

			 bIsAllWhiteName = true;
			 break;
	}	
	return bIsAllWhiteName;
}

//HP 바도 표시하면 안되는 몬스터인지 체크하는 함수
function bool IsNoBarID(int m_TargetID)
{
	local bool	bIsNoBarName;
	bIsNoBarName = false;
	
	switch( m_TargetID )
	{
		case 13036:	//연금술사의 보물상자
		case 13098:	//보물찾기 보물상자
			bIsNoBarName = true;
			break;
	}	
	return bIsNoBarName;
}


function OnMouseOver(WindowHandle a_WindowHandle )
{
	if	(a_WindowHandle == tex_TargetControlDrag)	// Resize - none
	{
		Me.SetDraggable(true);
	}
	else
	{
		Me.SetDraggable(false);
		if	(a_WindowHandle == tex_ClassIcon)
			InitDetailInfo();
	}
}

function OnMouseOut(WindowHandle a_WindowHandle )
{
	if	(a_WindowHandle == tex_TargetControlDrag)	// Resize - none
	{
		Me.SetDraggable(false);
	}
}


function InitDetailInfo()
{
	local CustomTooltip DetailTooltip;
	
	local Actor PlayerActor;
	
	local UserInfo tempUser;
	local ItemInfo tempItem;
	local ItemID tempID;
	
	local string str1, str2, str3, str4, str5, str6;
	local string tempString;
	local Pawn P;
	
	local int i;
	
	local int Quality;
	local int ColorR;
	local int ColorG;
	local int ColorB;
	local Color TextColor;
	
	GetTargetInfo(tempUser);
	
	PlayerActor = GetPlayerActor();
	
	if (tempUser.bNpc) return;
	
	foreach PlayerActor.CollidingActors( class 'Pawn', P, 5000, PlayerActor.Location)
	{
		if (m_TargetID == P.CreatureID && m_TargetID > 0)
		{
			i = 0;
			
			DetailTooltip.MinimumWidth = 376;
			DetailTooltip.DrawList.length = 1;

			tempString = GetClassType(tempUser.nSubClass) $ " - " $ GetClassStr(tempUser.nSubClass);
			
			DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
			DetailTooltip.DrawList[i].nOffSetX = (376 - Len(tempString) * 6)/2 - 5;	
			if (IconType == 2)
			{
				DetailTooltip.DrawList[i].u_nTextureWidth = 18;
				DetailTooltip.DrawList[i].u_nTextureHeight = 18;
			}
			else
			{
				DetailTooltip.DrawList[i].nOffSetY = 3;	
				DetailTooltip.DrawList[i].u_nTextureWidth = 13;
				DetailTooltip.DrawList[i].u_nTextureHeight = 13;	
			}
			DetailTooltip.DrawList[i].u_nTextureUWidth = 16;
			DetailTooltip.DrawList[i].u_nTextureUHeight = 16;
			DetailTooltip.DrawList[i].u_strTexture = "MonIcaEssence.TargetStatusWnd.IconFrame";	
			
			i++;
			DetailTooltip.DrawList.length = i + 1;
			DetailTooltip.DrawList[i].eType = DIT_TEXTURE;	
			if (IconType == 2)
			{
				DetailTooltip.DrawList[i].nOffSetX = -17;
				DetailTooltip.DrawList[i].nOffSetY = 1;
			}
			else
			{
			//	DetailTooltip.DrawList[i].nOffSetX = -12;
			//	DetailTooltip.DrawList[i].nOffSetY = 4;	
				DetailTooltip.DrawList[i].nOffSetX = -14;
				DetailTooltip.DrawList[i].nOffSetY = 2;	
			}
			DetailTooltip.DrawList[i].u_nTextureWidth = 16;
			DetailTooltip.DrawList[i].u_nTextureHeight = 16;
		//	DetailTooltip.DrawList[i].u_strTexture = GetDetailedClassIconName(tempUser.nSubClass);	

			i++;
			DetailTooltip.DrawList.length = i + 1;
			DetailTooltip.DrawList[i].eType = DIT_TEXT;
			DetailTooltip.DrawList[i].t_bDrawOneLine = true;
			DetailTooltip.DrawList[i].nOffSetY = 4;
			DetailTooltip.DrawList[i].t_strText = GetClassType(tempUser.nSubClass) $ " - " $ GetClassStr(tempUser.nSubClass);
			DetailTooltip.DrawList[i].nOffSetX = 10;
			
			i++;
			DetailTooltip.DrawList.length = i + 1;
			DetailTooltip.DrawList[i].bLineBreak = true;
			DetailTooltip.DrawList[i].t_bDrawOneLine = true;
			DetailTooltip.DrawList[i].nOffSetY = -7;
			DetailTooltip.DrawList[i].eType = DIT_TEXT;
			DetailTooltip.DrawList[i].t_strText = "";
			
			if (P.DefenseItemClassID > 0)
			{	
				tempID.ClassID = P.DefenseItemClassID;
				class'UIDATA_ITEM'.static.GetItemInfo(tempID, tempItem);
				
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_SPLITLINE;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].u_nTextureWidth = DetailTooltip.MinimumWidth;					
				DetailTooltip.DrawList[i].u_nTextureHeight = 1;
				DetailTooltip.DrawList[i].u_strTexture ="L2ui_ch3.tooltip_line";
			
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = 5;
				DetailTooltip.DrawList[i].nOffSetY = 3;
				DetailTooltip.DrawList[i].u_nTextureWidth = 32;
				DetailTooltip.DrawList[i].u_nTextureHeight = 32;
				DetailTooltip.DrawList[i].u_strTexture = tempItem.IconName;
				DetailTooltip.DrawList[i].b_nHeight  = 36;

				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = -33;
				DetailTooltip.DrawList[i].nOffSetY = 2;
				DetailTooltip.DrawList[i].u_nTextureWidth = 36;
				DetailTooltip.DrawList[i].u_nTextureHeight = 36;
				DetailTooltip.DrawList[i].u_strTexture = "L2UI_CH3.etc.menu_outline";		
				
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXT;
				DetailTooltip.DrawList[i].nOffSetX = 10;
				DetailTooltip.DrawList[i].nOffSetY = 13;
				DetailTooltip.DrawList[i].t_strText = tempItem.Name;
			}
			
			if (P.ShieldItemClassID > 0)
			{	
				tempID.ClassID = P.ShieldItemClassID;
				class'UIDATA_ITEM'.static.GetItemInfo(tempID, tempItem);
							

				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_SPLITLINE;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].u_nTextureWidth = DetailTooltip.MinimumWidth;					
				DetailTooltip.DrawList[i].u_nTextureHeight = 1;
				DetailTooltip.DrawList[i].u_strTexture ="L2ui_ch3.tooltip_line";
			
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = 5;
				DetailTooltip.DrawList[i].nOffSetY = 3;
				DetailTooltip.DrawList[i].u_nTextureWidth = 32;
				DetailTooltip.DrawList[i].u_nTextureHeight = 32;
				DetailTooltip.DrawList[i].u_strTexture = tempItem.IconName;
				DetailTooltip.DrawList[i].b_nHeight  = 36;

				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = -33;
				DetailTooltip.DrawList[i].nOffSetY = 2;
				DetailTooltip.DrawList[i].u_nTextureWidth = 36;
				DetailTooltip.DrawList[i].u_nTextureHeight = 36;
				DetailTooltip.DrawList[i].u_strTexture = "L2UI_CH3.etc.menu_outline";			
				
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXT;
				DetailTooltip.DrawList[i].nOffSetX = 10;
				DetailTooltip.DrawList[i].nOffSetY = 13;
				DetailTooltip.DrawList[i].t_strText = tempItem.Name;
			}			
			
			if (P.AttackItemClassID > 0)
			{	
				tempID.ClassID = P.AttackItemClassID;
				class'UIDATA_ITEM'.static.GetItemInfo(tempID, tempItem);
				
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_SPLITLINE;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].u_nTextureWidth = DetailTooltip.MinimumWidth;					
				DetailTooltip.DrawList[i].u_nTextureHeight = 1;
				DetailTooltip.DrawList[i].u_strTexture ="L2ui_ch3.tooltip_line";	
				
				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].bLineBreak = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = 5;
				DetailTooltip.DrawList[i].nOffSetY = 3;
				DetailTooltip.DrawList[i].u_nTextureWidth = 32;
				DetailTooltip.DrawList[i].u_nTextureHeight = 32;
				DetailTooltip.DrawList[i].u_strTexture = tempItem.IconName;
				DetailTooltip.DrawList[i].b_nHeight  = 36;

				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].eType = DIT_TEXTURE;
				DetailTooltip.DrawList[i].nOffSetX = -33;
				DetailTooltip.DrawList[i].nOffSetY = 2;
				DetailTooltip.DrawList[i].u_nTextureWidth = 36;
				DetailTooltip.DrawList[i].u_nTextureHeight = 36;
				DetailTooltip.DrawList[i].u_strTexture = "L2UI_CH3.etc.menu_outline";	

				if (P.AttackItemEnchantedValue > 0)
				{
					i++;
					DetailTooltip.DrawList.length = i + 1;
					DetailTooltip.DrawList[i].t_bDrawOneLine = true;
					DetailTooltip.DrawList[i].eType = DIT_TEXT;
					DetailTooltip.DrawList[i].nOffSetX = 10;
					DetailTooltip.DrawList[i].nOffSetY = 13;
					DetailTooltip.DrawList[i].t_color.R = 255;
					DetailTooltip.DrawList[i].t_color.G = 215;
					DetailTooltip.DrawList[i].t_color.B = 0;
					DetailTooltip.DrawList[i].t_color.A = 255;
					DetailTooltip.DrawList[i].t_strText = "+" $ P.AttackItemEnchantedValue;
				}

				i++;
				DetailTooltip.DrawList.length = i + 1;
				DetailTooltip.DrawList[i].t_bDrawOneLine = true;
				DetailTooltip.DrawList[i].eType = DIT_TEXT;
				if (P.AttackItemEnchantedValue > 0)
					DetailTooltip.DrawList[i].nOffSetX = 3;
				else
					DetailTooltip.DrawList[i].nOffSetX = 10;
				DetailTooltip.DrawList[i].nOffSetY = 13;
				DetailTooltip.DrawList[i].t_strText = tempItem.Name;
				
				if (Len(tempItem.AdditionalName) >0)
				{
					i++;
					DetailTooltip.DrawList.length = i + 1;
					DetailTooltip.DrawList[i].t_bDrawOneLine = true;
					DetailTooltip.DrawList[i].eType = DIT_TEXT;
					DetailTooltip.DrawList[i].nOffSetY = 13;
					DetailTooltip.DrawList[i].t_color.R = 255;
					DetailTooltip.DrawList[i].t_color.G = 215;
					DetailTooltip.DrawList[i].t_color.B = 0;
					DetailTooltip.DrawList[i].t_color.A = 255;
					DetailTooltip.DrawList[i].t_strText = " (" $ tempItem.AdditionalName $ ")";
				
				}
				
				if (P.AttackItemVariationOption2 > 0)
				{
					Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality(P.AttackItemVariationOption2 );
					GetRefineryColor(Quality, ColorR, ColorG, ColorB);
				}
				
				TextColor.R = ColorR;
				TextColor.G = ColorG;
				TextColor.B = ColorB;
				
				if (P.AttackItemVariationOption1 > 0)
				{
					class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(P.AttackItemVariationOption1, str1, str2, str3);
					if (Len(str1) > 0)
					{
						i++;
						DetailTooltip.DrawList.length = i + 1;
						DetailTooltip.DrawList[i].bLineBreak = true;
						DetailTooltip.DrawList[i].t_bDrawOneLine = true;
						DetailTooltip.DrawList[i].eType = DIT_TEXT;
						DetailTooltip.DrawList[i].nOffSetX = 48;
						DetailTooltip.DrawList[i].nOffSetY = 5;
						DetailTooltip.DrawList[i].t_color.R = TextColor.R;
						DetailTooltip.DrawList[i].t_color.G = TextColor.G;
						DetailTooltip.DrawList[i].t_color.B = TextColor.B;
						DetailTooltip.DrawList[i].t_color.A = 255;
						DetailTooltip.DrawList[i].t_strText = str1;
					}
					if (Len(str2) > 0)
					{
						i++;
						DetailTooltip.DrawList.length = i + 1;
						DetailTooltip.DrawList[i].bLineBreak = true;
						DetailTooltip.DrawList[i].t_bDrawOneLine = true;
						DetailTooltip.DrawList[i].eType = DIT_TEXT;
						DetailTooltip.DrawList[i].nOffSetX = 48;
						DetailTooltip.DrawList[i].nOffSetY = 5;
						DetailTooltip.DrawList[i].t_color.R = TextColor.R;
						DetailTooltip.DrawList[i].t_color.G = TextColor.G;
						DetailTooltip.DrawList[i].t_color.B = TextColor.B;
						DetailTooltip.DrawList[i].t_color.A = 255;
						DetailTooltip.DrawList[i].t_strText = str2;
					}				
				}
				
				if (P.AttackItemVariationOption2 > 0)
				{
					class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( P.AttackItemVariationOption2, str4, str5, str6);
					if (Len(str4) > 0)
					{
						i++;
						DetailTooltip.DrawList.length = i + 1;
						DetailTooltip.DrawList[i].bLineBreak = true;
						DetailTooltip.DrawList[i].t_bDrawOneLine = true;
						DetailTooltip.DrawList[i].eType = DIT_TEXT;
						DetailTooltip.DrawList[i].nOffSetX = 48;
						DetailTooltip.DrawList[i].nOffSetY = 5;
						DetailTooltip.DrawList[i].t_color.R = TextColor.R;
						DetailTooltip.DrawList[i].t_color.G = TextColor.G;
						DetailTooltip.DrawList[i].t_color.B = TextColor.B;
						DetailTooltip.DrawList[i].t_color.A = 255;
						DetailTooltip.DrawList[i].t_strText = str4;
					}
					if (Len(str5) > 0)
					{
						i++;
						DetailTooltip.DrawList.length = i + 1;
						DetailTooltip.DrawList[i].bLineBreak = true;
						DetailTooltip.DrawList[i].t_bDrawOneLine = true;
						DetailTooltip.DrawList[i].eType = DIT_TEXT;
						DetailTooltip.DrawList[i].nOffSetX = 48;
						DetailTooltip.DrawList[i].nOffSetY = 5;
						DetailTooltip.DrawList[i].t_color.R = TextColor.R;
						DetailTooltip.DrawList[i].t_color.G = TextColor.G;
						DetailTooltip.DrawList[i].t_color.B = TextColor.B;
						DetailTooltip.DrawList[i].t_color.A = 255;
						DetailTooltip.DrawList[i].t_strText = str5;
					}				
				}
			}
			tex_ClassIcon.SetTooltipCustomType(DetailTooltip);
		}
	}
}


function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch (Quality)
	{
	case 1:
		R = 187;
		G = 181;
		B = 138;
	break;
	case 2:
		R = 132;
		G = 174;
		B = 216;
	break;
	case 3:
		R = 193;
		G = 112;
		B = 202;
	break;
	case 4:
		R = 225;
		G = 109;
		B = 109;
	break;
	default:
		R = 187;
		G = 181;
		B = 138;
	break;
	}
}

defaultproperties
{
}
