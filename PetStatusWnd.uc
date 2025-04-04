class PetStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var bool m_bBuff;
var bool m_bShow;
var int m_PetID;
var int  m_CurBf;
var bool  m_bPetload;
var WindowHandle Me;
var BarHandle barFATIGUE;
var BarHandle barMP;
var BarHandle barHP;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle BackTex;
//~ var StatusIconHandle StatusIcon;
var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle	BufIcon;
var StatusIconHandle	DebufIcon;
var StatusIconHandle	SongDanceIcon;


function OnRegisterEvent()
{
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_ShowBuffIcon );
	 
	RegisterEvent( EV_PetStatusShow );
	RegisterEvent( EV_PetStatusSpelledList );
	 
	RegisterEvent( EV_PetSummonedStatusClose );
}

function OnLoad()
{
	m_bPetload = false;
	 
	if(CREATE_ON_DEMAND==0)
	  Initialize();
	 else
	  InitializeCOD();
	 
	Load();
}

function Initialize()
{
	BufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	DebufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	SongDanceIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );

	Me = GetHandle( "PetStatusWnd" );
	barFATIGUE = BarHandle ( GetHandle( "PetStatusWnd.barFATIGUE" ) );
	barMP = BarHandle ( GetHandle( "PetStatusWnd.barMP" ) );
	barHP = BarHandle ( GetHandle( "PetStatusWnd.barHP" ) );
	PetName = NameCtrlHandle ( GetHandle( "PetStatusWnd.PetName" ) );
	btnBuff = ButtonHandle ( GetHandle( "PetStatusWnd.btnBuff" ) );
	BackTex = GetHandle( "PetStatusWnd.BackTex" );
	m_StatusIconBuff = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconBuff" ) );
	m_StatusIconDeBuff = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconDeBuff" ) );
	m_StatusIconSongDance = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconSongDance" ) );
	m_CurBf = 1;
	SetBuffButtonTooltip();
}

function InitializeCOD()
{
	BufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	DebufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	SongDanceIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );

	Me = GetWindowHandle( "PetStatusWnd" );
	barFATIGUE = GetBarHandle( "PetStatusWnd.barFATIGUE" );
	barMP = GetBarHandle( "PetStatusWnd.barMP" );
	barHP = GetBarHandle( "PetStatusWnd.barHP" );
	PetName = GetNameCtrlHandle( "PetStatusWnd.PetName" );
	btnBuff = GetButtonHandle( "PetStatusWnd.btnBuff" );
	BackTex = GetWindowHandle( "PetStatusWnd.BackTex" );
	m_StatusIconBuff = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	m_StatusIconDeBuff = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	m_StatusIconSongDance = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );
	m_CurBf = 1;
	SetBuffButtonTooltip();
}

function Load()
{
	m_CurBf = 1;
	SetBuffButtonTooltip();

	m_bShow = false;
	m_bBuff = false;
}

function OnShow()
{
	local int PetID;
	local int IsPetOrSummoned;

	PetID = class'UIDATA_PET'.static.GetPetID();
	IsPetOrSummoned = class'UIDATA_PET'.static.GetIsPetOrSummoned();

	if (PetID<0 || IsPetOrSummoned!=2)
	{
		Me.HideWindow();
	}
	else
	{
		m_bShow = true;
	}
}

function OnHide()
{
	m_bShow = false;
}

function OnEnterState( name a_PreStateName )
{
	if (m_bPetload)
		Me.ShowWindow();

	m_bBuff = false;
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetStatusClose();
		m_bPetload = false;
	}
	else if (Event_ID == EV_PetStatusShow)
	{
	//  debug ("Show Pet Wnd"$ GetGameStateName());
		if(GetGameStateName()!="GAMINGSTATE")
			return;
	
		HandlePetStatusShow();
		m_bPetload=true;
	}
	else if (Event_ID == EV_ShowBuffIcon)
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PetStatusSpelledList)
	{
		HandlePetStatusSpelledList(param);
	}
}

//초기화
function Clear()
{
 //~ StatusIcon.Clear();
 
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();

	PetName.SetName("", NCT_Normal,TA_Center);
	barHP.SetValue(0, 0);
	barMP.SetValue(0, 0);
	barFatigue.SetValue(0, 0);
}

//종료처리
function HandlePetStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//펫Info패킷 처리
function HandlePetInfoUpdate()
{
	local string Name;
	local int  HP;
	local int  MaxHP;
	local int  MP;
	local int  MaxMP;
	local int  Fatigue;
	local int  MaxFatigue;
	local PetInfo info;

	m_PetID = 0;
	if (GetPetInfo(info))
	{
		m_PetID = info.nID;
		Name = info.Name;
		HP = info.nCurHP;
		MP = info.nCurMP;
		Fatigue = info.nFatigue;
		MaxHP = info.nMaxHP;
		MaxMP = info.nMaxMP;
		MaxFatigue = info.nMaxFatigue;
	}

	PetName.SetName(Name, NCT_Normal,TA_Center);
	barHP.SetValue(MaxHP, HP);
	barMP.SetValue(MaxMP, MP);
	barFatigue.SetValue(MaxFatigue, Fatigue); 
}

//펫창을 표시
function HandlePetStatusShow()
{
	Clear();
	Me.ShowWindow();
	Me.SetFocus();
}

//펫의 버프리스트정보
function HandlePetStatusSpelledList(string param)
{
	//~ local int i;
	//~ local int Max, ID;

	local int i;
	local int ID;
	local int Max;

	local int BuffCnt;
	local int BuffCurRow;

	local int DeBuffCnt;
	local int DeBuffCurRow;

	local int SongDanceCnt;
	local int SongDanceCurRow;

	//~ local int BuffCnt;
	//~ local int CurRow;
	local StatusIconInfo info;

	//~ CurRow = -1;

	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;

	ParseInt(param, "ID", ID);
	info.ServerID = ID;
	if (ID<1 || m_PetID != ID) // 내 펫의 버프정보인지 확인하고, 아니면 반사 
	{
		return;
	}

	//버프 초기화
	//~ StatusIcon.Clear();

	//~ .Clear();
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();


	//info 초기화
	info.Size = 16;
	info.bShow = true; 

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "Sec_" $ i, info.RemainTime);

		//~ if (IsValidItemID(info.ID))
		//~ {
		//~ info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, 1);

		//~ //한줄에 NSTATUSICON_MAXCOL만큼 표시한다.
		//~ if (BuffCnt%NSTATUSICON_MAXCOL == 0)
		//~ {
		//~ CurRow++;
		//~ StatusIcon.AddRow();
		//~ }

		//~ StatusIcon.AddCol(CurRow, info); 

		//~ BuffCnt++;
		//~ }

		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level);

			if (IsDeBuff( info.ID, 1) == true )
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
				 DeBuffCurRow++;
				 //~ if(isPC) 
				 //~ {
				  info.Size = 16;
				  m_StatusIconDeBuff.AddRow();
				 //~ }
				 //~ else  
				 //~ {
				  //~ info.Size = 10;
				  //~ m_PetStatusIconDeBuff[idx].AddRow();
				 //~ }
				}
				//~ if(isPC) 
				//~ {
				 //~ info.Size = 16;
				 //~ m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info); 
				//~ }
				//~ else   
				//~ {
				 //~ info.Size = 10;
				 //~ m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info); 
				//~ }

				m_StatusIconDeBuff.AddCol(DeBuffCurRow, info);
				DeBuffCnt++;
			}
			else if (IsSongDance( info.ID, 1) == true )
			{
				if (SongDanceCnt%NSTATUSICON_MAXCOL == 0)
				{
					//~ debug("송댄스입니까?");
					SongDanceCurRow++;
					//~ if(isPC) 
					//~ {
					info.Size = 16;
					m_StatusIconSongDance.AddRow();
					//~ }
					//~ else  
					//~ {
					 //~ info.Size = 10;
					 //~ m_PetStatusIconSongDance[idx].AddRow();
					//~ }
				}
				//~ if(isPC) 
				//~ {
				 //~ info.Size = 16;
				 //~ m_StatusIconSongDance[idx].AddCol(0, info); 
				//~ }
				//~ else   
				//~ {
				 //~ info.Size = 10;
				 //~ m_PetStatusIconSongDance[idx].AddCol(0, info); 
				//~ }

					m_StatusIconSongDance.AddCol(SongDanceCurRow, info);
					SongDanceCnt++;
			}
			else
			{
				//~ debug("일반 버프입니까?");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
				 //~ if(isPC) 
				 //~ {
					info.Size = 16;
					m_StatusIconBuff.AddRow();
				 //~ }
				 //~ else
				 //~ {
				  //~ info.Size = 10;
				  //~ m_PetStatusIconBuff[idx].AddRow();
				 //~ }
				}
			//~ if(isPC) 
			//~ {
			 //~ info.Size = 16;
			 //~ m_StatusIconBuff[idx].AddCol(BuffCurRow, info); 
			//~ }
			//~ else  
			//~ {
			 //~ info.Size = 10;
			 //~ m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info); 
			//~ }
				m_StatusIconBuff.AddCol(BuffCurRow, info);
				BuffCnt++;
			}
		}
	}

	//~ UpdateBuff(m_bBuff);
	UpdateBuff();
}

//버프아이콘 표시
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	if (nShow==1)
	{
		//~ UpdateBuff(true);
		UpdateBuff();
	}
	else
	{
		//~ UpdateBuff(false);
		UpdateBuff();
	}
}


// 버프디버프 표시,  송댄스 , 끄기 3가지모드를 전환한다.
function UpdateBuff()
{
	//~ local int idx;
	if (m_CurBf == 1)
	{
		// 버프 , 디버프 보여 준다.
		m_StatusIconBuff.ShowWindow(); 
		m_StatusIconDeBuff.ShowWindow(); 
		m_StatusIconSongDance.HideWindow(); 
	}
	 /*  
	 // 버프/디버프 통합 
	 else if (m_CurBf == 2)
	 {
	  //~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	  //~ {
	   m_StatusIconBuff.HideWindow(); 
	   m_StatusIconDeBuff.ShowWindow(); 
	   m_StatusIconSongDance.HideWindow(); 
	  //~ }
	 }
	 */
	else if (m_CurBf == 2)
	{
		//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		//~ {
		m_StatusIconBuff.HideWindow(); 
		m_StatusIconDeBuff.HideWindow(); 
		m_StatusIconSongDance.ShowWindow(); 
  //~ }
	}
	else
	{
	//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	//~ {
	m_StatusIconBuff.HideWindow();
	m_StatusIconDeBuff.HideWindow(); 
	m_StatusIconSongDance.HideWindow(); 
  //~ }
	}
 //m_bBuff = bShow;
}


function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;

	rectWnd = Me.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			RequestAction(m_PetID, userinfo.Loc);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
		case "btnBuff":
			OnBuffButton();
			break;
	}
}


function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;

	// 2009.10.01 이전: 기존에 버프, 디버프, 이상상태 끄기, 송/댄스 4가지 였다. 
	// (버프/디버프) 이상상태 보기, 송/댄스 보기, 이상상태 끄기
	// 3가지 모드가 전환된다.
	if (m_CurBf > 2)
	{
		m_CurBf = 0;
	}

	SetBuffButtonTooltip();
	UpdateBuff();
}

// 버프 툴팁을 설정한다.
function SetBuffButtonTooltip()
{
	local int idx;

	 //stringID=1496 string=[버프보기] 
	 //stringID=1497 string=[디버프보기] 
	 //stringID=1498 string=[이상상태 끄기] 
	 //stringID=1741 string=[송/댄스 보기] 
	 switch (m_CurBf)
	 {
		case 0: idx = 2221; // 1496;  // 버프보기로 변경 -> 이상상태 보기 2221 
			break;
		//case 1: idx = 1497; break; // 삭제 된다. 
		case 1: idx = 1741;
			break;
		case 2: idx = 1498;
			break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}



//~ function OnBuffButton()
//~ {
 //~ UpdateBuff(!m_bBuff);
//~ }

//~ function UpdateBuff(bool bShow)
//~ {
 //~ if (bShow)
 //~ {
  //~ //StatusIcon.ShowWindow();
  //~ m_StatusIconBuff.ShowWindow();
  //~ m_StatusIconDeBuff.ShowWindow();
  //~ m_StatusIconSongDance.ShowWindow();
 //~ }
 //~ else
 //~ {
  //~ //StatusIcon.HideWindow();
  //~ m_StatusIconBuff.ShowWindow();
  //~ m_StatusIconDeBuff.ShowWindow();
  //~ m_StatusIconSongDance.ShowWindow();
 //~ }
 //~ m_bBuff = bShow;
//~ }


function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// 스킬 정보. 버프스킬인지 확인해야 하니까
	local StatusIconHandle  StatusIcon;

	col = index / 10;
	row = index - (col * 10);

	if(InStr( strID ,"StatusIconBuff" ) > -1)
	{
		StatusIcon = BufIcon;
	}
	if(InStr( strID ,"StatusIconDeBuff" ) > -1)
	{
		StatusIcon = DebufIcon;
	}
	if(InStr( strID ,"StatusIconSongDance" ) > -1)
	{
		StatusIcon = SongDanceIcon;
	}

	StatusIcon.GetItem(row, col, info);
	
	// ID를 가지고 스킬의 정보를 얻어온다. 없으면 패배
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"StatusIconBuff" ) > -1 ||  InStr( strID ,"StatusIconDeBuff" ) > -1 ||  InStr( strID ,"StatusIconSongDance" ) > -1)
	{
		if (skillInfo.IsDebuff == false && skillInfo.OperateType == 1) 		{	RequestDispel(info.ServerID, info.ID, info.Level);	}					//버프 취소 요청
		else												{	AddSystemMessage(2318);	}	//강화 스킬인 경우에만 버프 취소가 가능합니다. 
	}
}
defaultproperties
{
}
