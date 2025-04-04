/******************************************************************************
//                                             확장된 파티창 UI 관련 스크립트                                                                    //
******************************************************************************/
class PartyWnd extends UICommonAPI;	

//상수설정.  
const NSTATUSICON_MAXCOL = 12;	//status icon의 최대 가로.
const NPARTYSTATUS_HEIGHT = 46;	//status 상태창의 세로길이.
const NPARTYPETSTATUS_HEIGHT = 18;	//status 상태창의 세로길이.
const NPARTYSTATUS_MAXCOUNT = 9;	//한 파티창에 들어갈수 있는 최대 파티원의 수.	//파티원의 수는 8이지만 버퍼를 위해 (위치변경) +1을 합니다.

const SMALL_BUF_ICON_SIZE = 6;	// 펫 버프 아이콘이 겹치므로 항상 작게 해준다. 

struct VnameData
{
	var int ID;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};

var bool	m_bCompact;	//컴팩트창 오픈여부.
var bool	m_bBuff;		//버프 표시상태 플래그.

var int		m_arrID[NPARTYSTATUS_MAXCOUNT];	// 인덱스에 해당하는 파티원의 서버 ID.
var int		m_arrPetID[NPARTYSTATUS_MAXCOUNT];	// 인덱스에 해당하는 파티원의 펫의서버 ID.
var int		m_arrPetIDOpen[NPARTYSTATUS_MAXCOUNT];	// 인덱스에 해당하는 파티원의 펫의 창이 열려있는지 확인. 1이면 오픈, 2이면 닫힘. -1이면 없음
var int		m_CurCount;	
var int 		m_CurBf;
var int		m_TargetID;
var int		m_LastChangeColor;

var VnameData m_Vname[8];
var bool m_AmIRoomMaster; //자신이 파티방의 방장인지를 가지고 있다. PartyMatchRoomWnd에 의해서 파티방이 열리고 닫힐때 갱신된다
//Handle 을 등록.
var WindowHandle		m_wndTop;
var WindowHandle		m_PartyStatus[NPARTYSTATUS_MAXCOUNT];
var WindowHandle		m_PartyOption;
var NameCtrlHandle		m_PlayerName[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_ClassIcon[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_LeaderIcon[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconSongDance[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconTriggerSkill[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarCP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarMP[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle			btnBuff;

var ButtonHandle			m_petButton[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle			m_petButtonTrash[NPARTYSTATUS_MAXCOUNT];

var WindowHandle		m_PetPartyStatus[NPARTYSTATUS_MAXCOUNT];
//var NameCtrlHandle		m_PetName[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconSongDance[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconTriggerSkill[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_PetClassIcon[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarMP[NPARTYSTATUS_MAXCOUNT];

var int partymasteridx;
function OnRegisterEvent()
{
	// 이벤트 (서버 혹은 클라이언트에서 오는) 핸들 등록.
	RegisterEvent( EV_ShowBuffIcon );
	
	RegisterEvent( EV_PartyAddParty);
	RegisterEvent( EV_PartyUpdateParty );
	RegisterEvent( EV_PartyDeleteParty );
	RegisterEvent( EV_PartyDeleteAllParty );
	RegisterEvent( EV_PartySpelledList );
	RegisterEvent( EV_PartyRenameMember );
	
	RegisterEvent( EV_PartySummonAdd );
	RegisterEvent( EV_PartySummonUpdate );
	RegisterEvent( EV_PartySummonDelete );
	
	RegisterEvent( EV_PetStatusSpelledList );		// 펫 버프가 날라오는 이벤트
	RegisterEvent( EV_SummonedStatusSpelledList );	// 소환수  버프가 날라오는 이벤트
	
	RegisterEvent( EV_Restart );
	
	RegisterEvent( EV_TargetUpdate );	// 타겟 업데이트 이벤트
}

// 윈도우 생성시 불리는 함수.
function OnLoad()
{
	local int idx;	// 루프를 돌게될 int.
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	// 전역변수 초기화.
	partymasteridx = -1;
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_TargetID = -1;
	m_LastChangeColor = -1;
	m_AmIRoomMaster = false;
	
	//Reset Anchor	// 버프와 디버프는 PartyWndCompact의 anchor point를 참조한다.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);

		m_PetStatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
	}
	m_PartyOption.HideWindow();
	
	//Init VirtualDrag
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		//m_PartyStatus[idx].SetVirtualDrag( true );
		m_PartyStatus[idx].SetDragOverTexture( "L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight" );
	}
	
	ResetVName();
}

function InitHandle()
{
	local int idx;	// 루프를 돌게될 int.

	//Init Handle
	m_wndTop = GetHandle( "PartyWnd" );
	m_PartyOption = GetHandle("PartyWndOption");	// 옵션창의 핸들 초기화.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)	// 최대파티원 수 만큼 각 데이터를 초기화해줌.
	{
		m_PartyStatus[idx] = GetHandle( "PartyWnd.PartyStatusWnd" $ idx );
		m_PlayerName[idx] = NameCtrlHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".PlayerName" ) ); 
		m_ClassIcon[idx] = TextureHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".ClassIcon" ) );
		m_LeaderIcon[idx] = TextureHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".LeaderIcon" ) );
		
		m_StatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconBuff" ) );
		m_StatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconDeBuff" ) );
		m_StatusIconSongDance[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconSongDance" ) );
		m_StatusIconTriggerSkill[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconTriggerSkill" ) );

		m_BarCP[idx] = BarHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barCP" ) );
		m_BarHP[idx] = BarHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barHP" ) );
		m_BarMP[idx] = BarHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barMP" ) );
		//if(idx != 0) // 첫번째 창의 버튼을 상속받은 모든 창에 버튼이 생겼지만 어쩔수 없다. 
		//{
		//	m_petButtonTrash[idx] = ButtonHandle( GetHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".btnSummon0") );	
		//	m_petButtonTrash[idx].HideWindow();
		//}
		m_petButton[idx] = ButtonHandle( GetHandle( "PartyWnd.btnSummon" $ idx) );	// 실제로 사용될 버튼		
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx );
		//m_PetName[idx] = NameCtrlHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".SummonName" ) ); 
		m_PetClassIcon[idx] = TextureHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".ClassIcon" ) );
		
		m_PetStatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" ) );
		m_PetStatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" ) );
		m_PetStatusIconSongDance[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconSongDance" ) );
		m_PetStatusIconTriggerSkill[idx] = StatusIconHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconTriggerSkill" ) );

		m_PetBarHP[idx] = BarHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".barHP" ) );
		m_PetBarMP[idx] = BarHandle( GetHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".barMP" ) );		
				
		m_arrPetIDOpen[idx] = -1;
		m_arrID[idx] = 0;
		
		if(idx == 0) //첫번째 창은 레이아웃이 다르다. 
		{
			m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 32);
		}
		else
			m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
		
	}
	btnBuff = ButtonHandle( GetHandle( "PartyWnd.btnBuff" ) );
}

function InitHandleCOD()
{
	local int idx;	// 루프를 돌게될 int.

	//Init Handle
	m_wndTop = GetWindowHandle( "PartyWnd" );
	m_PartyOption = GetWindowHandle("PartyWndOption");	// 옵션창의 핸들 초기화.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)	// 최대파티원 수 만큼 각 데이터를 초기화해줌.
	{
		m_PartyStatus[idx] = GetWindowHandle( "PartyWnd.PartyStatusWnd" $ idx );
		m_PlayerName[idx] = GetNameCtrlHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".PlayerName" ); 
		m_ClassIcon[idx] = GetTextureHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".ClassIcon" );
		m_LeaderIcon[idx] = GetTextureHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".LeaderIcon" );
		
		m_StatusIconBuff[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconBuff" );
		m_StatusIconDeBuff[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconDeBuff" );
		m_StatusIconSongDance[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconSongDance" );
		m_StatusIconTriggerSkill[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".StatusIconTriggerSkill" );

		m_BarCP[idx] = GetBarHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barCP" );
		m_BarHP[idx] = GetBarHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barHP" );
		m_BarMP[idx] = GetBarHandle( "PartyWnd.PartyStatusWnd" $ idx $ ".barMP" );

		m_petButton[idx] = GetButtonHandle( "PartyWnd.btnSummon" $ idx);	// 실제로 사용될 버튼		
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetWindowHandle( "PartyWnd.PartyStatusSummonWnd" $ idx );

		m_PetClassIcon[idx] = GetTextureHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".ClassIcon" );
		m_PetStatusIconBuff[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" );
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" );
		m_PetStatusIconSongDance[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconSongDance" );
		m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".StatusIconTriggerSkill" );
		m_PetBarHP[idx] = GetBarHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".barHP" );
		m_PetBarMP[idx] = GetBarHandle( "PartyWnd.PartyStatusSummonWnd" $ idx $ ".barMP" );		
				
		m_arrPetIDOpen[idx] = -1;
		m_arrID[idx] = 0;
		
		if(idx == 0) //첫번째 창은 레이아웃이 다르다. 
		{
			m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 32);
		}
		else
			m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
		
	}
	btnBuff = GetButtonHandle( "PartyWnd.btnBuff" );
}

function OnShow()
{
	SetBuffButtonTooltip();
}

function OnHide()
{
	ResetVName();

}

function OnEnterState( name a_PreStateName )
{
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	ResizeWnd();
}

// 이벤트 핸들 처리.
function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_PartyAddParty)	//파티원을 추가하는 이벤트.
	{
		HandlePartyAddParty(param);
	}
	else if (Event_ID == EV_PartyUpdateParty)	//파티 업데이트. 각종 HP 및 상태를 처리하기 위함.
	{
		HandlePartyUpdateParty(param);
	}
	else if (Event_ID == EV_PartyDeleteParty)	//파티원 삭제.
	{
		HandlePartyDeleteParty(param);
	}
	else if (Event_ID == EV_PartyDeleteAllParty)	//모든 파티원 삭제. 파티를 떠나거나 뽀갤때.
	{
		HandlePartyDeleteAllParty();
	}
	else if (Event_ID == EV_PartySpelledList || Event_ID == EV_PetStatusSpelledList || Event_ID == EV_SummonedStatusSpelledList)	// 버프 혹은 디버프 처리.
	{
		HandlePartySpelledList(param);
	}
	else if (Event_ID == EV_ShowBuffIcon)		// 버프, 디버프, 버프/디버프 보이기 모드를 전환.
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PartySummonAdd)	//파티원이 소환했을 경우
	{
		HandlePartySummonAdd(param);
	}
	else if (Event_ID == EV_PartySummonUpdate)	//소환수 업데이트 HP나 뭐 그런거..
	{
		HandlePartySummonUpdate(param);
	}
	else if (Event_ID == EV_PartySummonDelete)	//소환 해제
	{
		HandlePartySummonDelete(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HandleRestart();
	}
	else if (Event_ID == EV_TargetUpdate)
	{
		HandleCheckTarget();
	}
	else if (Event_ID == EV_PartyRenameMember)
	{
		HandlePartyRenameMember(param);
	}
}

function HandlePartyRenameMember(string Param)
{
	local int idx;
	local int ID;
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	ParseInt(Param, "ID", ID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);
	
	idx = GetVNameIndexByID( ID );
	if( idx > -1 )
	{
		m_Vname[idx].ID = ID;
		m_Vname[idx].UseVName = UseVName;
		m_Vname[idx].DominionIDForVName = DominionIDForVName;
		m_Vname[idx].VName = VName;
		m_Vname[idx].SummonVName = SummonVName;
		ExecuteEvent( EV_TargetUpdate);
	}	
}




// 타겟한 것이 파티원이면 색깔에 조금 변화를 준다.
function HandleCheckTarget()
{
	//~ local int idx;
	
	//~ idx = -1;
	
	//~ m_TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	//~ if(m_TargetID > 0)	{	idx = FindPartyID(m_TargetID);	}
	
	//~ if(idx == -1) 
	//~ {
		//~ if( m_LastChangeColor != -1) // 이전에 색을 바꿔준게 이으면 다시 원상 복귀
		//~ {	
			//~ debug("qkRudigka");
			//~ m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
			//~ m_TargetID	 = -1;
			//~ m_LastChangeColor = -1;			
		//~ }
	//~ }
	//~ else
	//~ {
		//~ m_LastChangeColor = idx;
		//~ m_PartyStatus[idx].SetBackTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
	//~ }
}

//리스타트를 하면 올클리어
function HandleRestart()
{
	Clear();
}

//초기화
function Clear()
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		ClearStatus(idx);		// 모든 상태를 초기화해준다. 
		ClearPetStatus(idx);
	}
	m_CurCount = 0;
	m_TargetID	 = -1;
	m_LastChangeColor = -1;
	ResizeWnd();
}

//상태창의 초기화
function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	m_StatusIconSongDance[idx].Clear();
	m_StatusIconTriggerSkill[idx].Clear();
	m_PlayerName[idx].SetName("", NCT_Normal,TA_Center);
	m_LeaderIcon[idx].SetTexture("");
	m_ClassIcon[idx].SetTexture("");
	UpdateCPBar(idx, 0, 0);
	UpdateHPBar(idx, 0, 0);
	UpdateMPBar(idx, 0, 0);
	m_arrID[idx] = 0;
}

// 펫 상태창의 초기화
function ClearPetStatus(int idx)
{
	m_PetStatusIconBuff[idx].Clear();
	m_PetStatusIconDeBuff[idx].Clear();
	//m_PetStatusIconSongDance[idx].Clear();
	//m_PetStatusIconTriggerSkill[idx].Clear();
	//m_PetName[idx].SetName("", NCT_Normal,TA_Center);
	m_PetClassIcon[idx].SetTexture("");
	UpdateHPBar(idx + 100, 0, 0);
	UpdateMPBar(idx + 100, 0, 0);
	
	if(m_PetPartyStatus[idx].IsShowWindow()) m_PetPartyStatus[idx].HideWindow();	// 펫창 없애기
	if(m_petButton[idx].IsShowWindow()) m_petButton[idx].HideWindow();
	m_arrPetID[idx] = 0;
	m_arrPetIDOpen[idx] = -1;
}

//파티창의 복사 (목적이 되는 파티창의 인덱스, 복사할 파티창의 인덱스)
function CopyStatus(int DesIndex, int SrcIndex)
{
	local string	strTmp;	
	local int		MaxValue;	// CP, HP, MP의 최대값.
	local int		CurValue;	// CP, HP, MP의 현재값.
	
	local int		Width;
	local int		Height;
	
	local int		Row;
	local int		Col;
	local int		MaxRow;
	local int		MaxCol;
	local StatusIconInfo info;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;
	
	//ServerID
	m_arrID[DesIndex] = m_arrID[SrcIndex];
	
	//Name
	m_PlayerName[DesIndex].SetName(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Center);
	
	//Class Texture
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//파티장 Texture
	strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
	m_LeaderIcon[DesIndex].SetTexture(strTmp);
	if (Len(strTmp)>0)
	{
		//아이콘을 이름의 옆에 위치시켜준다.
		strTmp = m_PlayerName[DesIndex].GetName();
		GetTextSizeDefault(strTmp, Width, Height);
		m_LeaderIcon[DesIndex].SetAnchor("PartyWnd.PartyStatusWnd" $ DesIndex, "TopCenter", "TopLeft", -(Width/2)-18, 8);
		m_LeaderIcon[DesIndex].ShowWindow();
	}
	//루팅 방식 툴팁
	m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
	m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	
	//CP,HP,MP
	m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_StatusIconBuff[DesIndex].Clear();
	MaxRow = m_StatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_StatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//SongDanceStatus
	m_StatusIconSongDance[DesIndex].Clear();
	MaxRow = m_StatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_StatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}
	
	
	// -------------------------------------------펫도 옮겨준다. 
	//ServerID
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
	
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];	
	m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];;	
	
	//Name
	//m_PetName[DesIndex].SetName(m_PetName[SrcIndex].GetName(), NCT_Normal,TA_Center);

	
	//Class Texture
	//m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	//m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	//m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//CP,HP,MP
	m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_PetStatusIconBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_PetStatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}

	//SongDanceStatus
	m_PetStatusIconSongDance[DesIndex].Clear();
	MaxRow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_PetStatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}	
}

//윈도우의 사이즈 조정
function ResizeWnd()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i;
	local int OpenPetCount;
	
	// SetOptionBool과 페어. 이 변수는 PartyWndOption 에서 변경됨
	bOption = GetOptionBool( "Game", "SmallPartyWnd" );
	
	if (m_CurCount>0)
	{
		OpenPetCount=0;
		for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
		{
			if(m_arrPetIDOpen[i] == 1) OpenPetCount++;
			else 	// 열려있는 상태가 아닌데..
			{
				 if(m_PetPartyStatus[i].IsShowWindow()) m_PetPartyStatus[i].HideWindow();
			}
		}
		
		//윈도우 사이즈 변경
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, NPARTYSTATUS_HEIGHT*m_CurCount + OpenPetCount * NPARTYPETSTATUS_HEIGHT);	
		// 펫창이 열려진 만큼 윈도우 사이즈에서 더해준다. 
		m_wndTop.SetResizeFrameSize(10, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT);
		if (!bOption)	// 옵션창에 체크가 되어있지 않으면 현재 (확장된) 윈도우를 활성화
			m_wndTop.ShowWindow();
		else
			m_wndTop.HideWindow();
				
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			if (idx<=m_CurCount-1)
			{
				if(idx >0 )	 //1 이상일때의 anchor를 처리해준다.
				{
					if(m_arrPetIDOpen[idx-1] == 1) // 앞 파티원의 소환수가 열려있다면
					{
						m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// 펫 윈도우 밑으로 앵커
					}
					else// 앞 파티원의 소환수가 닫혀있거나 소환수가 없으면
					{
						m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// 파티원 밑으로 앵커
					}
				}
				if(m_arrID[idx]!= 0 )
				{
					if (m_arrPetIDOpen[idx] > -1)  m_petButton[idx].showWindow();
					else	m_petButton[idx].HideWindow();
					m_PartyStatus[idx].SetVirtualDrag( true );
					m_PartyStatus[idx].ShowWindow();
				}
				if(m_arrPetIDOpen[idx] == 1) m_PetPartyStatus[idx].ShowWindow();
			}
			else
			{
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag( false );
				m_PartyStatus[idx].HideWindow();
				m_PetPartyStatus[idx].HideWindow();
			}
		}
	}
	else	// 파티원이 존재하지 않으면 이 윈도우는 보이지 않는다.
	{
		m_wndTop.HideWindow();
		m_PetPartyStatus[idx].HideWindow();
	}
}

//ID로 몇번째 표시되는 파티원인지 구한다
function int FindPartyID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID로 몇번째 표시되는 펫인지 구한다
function int FindPetID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrPetID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ADD	파티원 추가.
function HandlePartyAddParty(string param)
{
	local int ID;
	local int SummonID;
	
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	ParseInt(param, "ID", ID);	// ID를 파싱한다.
	ParseInt(param, "SummonID", SummonID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);	
	
	if (ID>0)
	{
		m_Vname[m_CurCount].ID = ID;
		m_Vname[m_CurCount].UseVName = UseVName;
		m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
		m_Vname[m_CurCount].VName = VName;
		m_Vname[m_CurCount].SummonVName = SummonVName;
		ExecuteEvent( EV_TargetUpdate);
	
		m_CurCount++;	
		
		m_arrID[m_CurCount-1] = ID;
		UpdateStatus(m_CurCount-1, param);
		if(SummonID > 0)	// 소환수가 있으면 소환수도 보여줌
		{
			m_arrPetID[m_CurCount-1] = SummonID;
			m_arrPetIDOpen[m_CurCount-1] = 1;
			UpdatePetStatus(m_CurCount-1, param $"SummonMasterID = "$ID );
			m_petButton[m_CurCount-1].showWindow();
			if( !m_PetPartyStatus[m_CurCount-1].isShowwindow())
			{
				m_PetPartyStatus[m_CurCount-1].ShowWindow();
			}
		}
		ResizeWnd();
	}
}

function bool AmILeader() //자신이 리더(파티장이거나 파티방의 생성자인지)인지를 리턴한다. 파티창의 리더아이콘을 기준으로 하므로 리더아이콘이 변경될경우 수정해야 한다.
{
	local int	i;
	local bool res;
	res = true; //내가 파티장이다
	if(m_CurCount == 0) res = false; //파티원이 없으면 아닌뎁 ㅋㅋㅋ
	for(i = 0; i < m_CurCount; i++)
	{
		if(m_LeaderIcon[i].GetTextureName() != "")
		{
			res = false; //방장텍스쳐를 가진놈이 존재한다. 그럼 너는 방장 아ㅋ님ㅋ
			break;
		}
	}
	
	return (res || m_AmIRoomMaster); //내가 방장이거나 파티방의 생성자면 나는 리더다
}
//UPDATE	특정 파티원 업데이트.
function HandlePartyUpdateParty(string param)
{
	local int	ID;
	local int	idx;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		UpdateStatus(idx, param);	// 해당 인덱스의 파티원 정보를 갱신
	}
}

//DELETE	특정 파티원을 삭제.
function HandlePartyDeleteParty(string param)
{
	local int	ID;
	local int	idx;
	local int	i;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		if (idx>-1)
		{	
			for (i=idx; i<m_CurCount-1; i++)	// 삭제하려는 파티원 아래의 파티원들을 땡겨준다. 
			{
				CopyStatus(i, i+1);
			}
			ClearStatus(m_CurCount-1);
			ClearPetStatus(m_CurCount-1);
			m_CurCount--;
			ResizeWnd();	// 만약 파티원이 자신밖에 없다면 알아서 파티윈도우는 사라짐.
		}
	}
}

//DELETE ALL	그저 모두 지울뿐..
function HandlePartyDeleteAllParty()
{
	Clear();
}

//Set Info	특정 인덱스의 파티원의 정보 갱신. 서버 아이디 정보는 확인을 위해 필요하다.

function SetMasterTooltip(int lootingtype)
{
	if(partymasteridx < NPARTYSTATUS_MAXCOUNT && partymasteridx > -1)
		m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(lootingtype)));	
}

function UpdateStatus(int idx, string param)
{
	local string	Name;
	local int		MasterID;
	local int		RoutingType;
	local int		ID;
	local int		CP;
	local int		MaxCP;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		ClassID;
	local int		Level;
	local userinfo 	TargetUser;
	//~ local int		SummonID;
	
	local int		Width;
	local int		Height;
	
	
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", ID);
	GetUserInfo(ID, TargetUser);
	
	ParseInt(param, "CurCP", CP);
	ParseInt(param, "MaxCP", MaxCP);
	ParseInt(param, "CurHP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "CurMP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	
	UseVName = m_Vname[idx].UseVName;
	DominionIDForVName = m_Vname[idx].DominionIDForVName;
	VName = m_Vname[idx].VName;
	SummonVName = m_Vname[idx].SummonVName;
	
	if (UseVName == 1)
	{
		m_PlayerName[idx].SetName(VName, NCT_Normal,TA_Center);
	}
	else
	{
		m_PlayerName[idx].SetName(Name, NCT_Normal,TA_Center);
	}
	
	//팟장 아이콘
	if (ParseInt(param, "MasterID", MasterID))
	{
		if (MasterID>0 && MasterID==ID)
		{	
			partymasteridx = idx;
			ParseInt(param, "RoutingType", RoutingType);
			m_LeaderIcon[idx].SetTexture("L2UI_CH3.PartyWnd.party_leadericon");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(RoutingType)));
			
			//아이콘을 이름의 옆에 위치시켜준다.
			GetTextSizeDefault(Name, Width, Height);
			m_LeaderIcon[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopCenter", "TopLeft", -(Width/2)-18, 8);
		}
		else
		{
			m_LeaderIcon[idx].SetTexture("");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
		}
	}
	
	//직업 아이콘
	m_ClassIcon[idx].SetTexture(GetClassIconName(ClassID));
	m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	
	//각종 게이지
	UpdateCPBar(idx, CP, MaxCP);
	UpdateHPBar(idx, HP, MaxHP);
	UpdateMPBar(idx, MP, MaxMP);
}

function HandlePartySummonAdd( string param )
{
	local int	SummonMasterID;
	local int	SummonID;
	local int	 i;
	local int	 MasterIndex;
	
	
	
	
	ParseInt(param, "SummonMasterID", SummonMasterID);	// 마스터 ID를 파싱한다.
	ParseInt(param, "SummonID", SummonID);	// 마스터 ID를 파싱한다.
	if (SummonMasterID>0)
	{
		MasterIndex = -1;
		for(i=0; i< NPARTYSTATUS_MAXCOUNT ; i++)
		{
			if(m_arrID[i] == SummonMasterID)
				MasterIndex = i;
		}
		
		if(MasterIndex == -1)
		{
			//debug("ERROR - Can't find master ID");
			return;
		}
		//ResizeWnd();
					
		m_arrPetID[MasterIndex] = SummonID;
		m_arrPetIDOpen[MasterIndex] = 1;
		UpdatePetStatus(MasterIndex, param);
		m_petButton[MasterIndex].showWindow();
		if( !m_PetPartyStatus[MasterIndex].isShowwindow())
		{
			m_PetPartyStatus[MasterIndex].ShowWindow();
			ResizeWnd();
		}
	}
}

function HandlePartySummonUpdate( string param )
{
	local int	SummonID;
	local int	idx;
	
	//debug(" PartySummonUpdate !! ");
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		UpdatePetStatus(idx, param);	// 해당 인덱스의 펫 정보를 갱신
	}
}

function HandlePartySummonDelete( string param )
{
	local int	SummonID;
	local int	idx;
	//~ local int	i;
	
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		if (idx>-1)
		{	
			ClearPetStatus(idx);
			ResizeWnd();	// 만약 파티원이 자신밖에 없다면 알아서 파티윈도우는 사라짐.
		}
	}
}

function UpdatePetStatus(int idx, string param)
{
	local int		SummonID;			// 펫 ID
	local int		SummonClassID;		// 펫 종류
	local int		SummonType;		// 펫 타입 1-소환수 2-펫
	local int		SummonMasterID;	// 주인의 ID
	local string		SummonNickName;	// 펫 이름
		
	local int		SummonHP;
	local int		SummonMaxHP;
	local int		SummonMP;
	local int		SummonMaxMP;
	local int		SummonLevel;
	
	//~ local int 		UseVName;
	//~ local int		DominionIDForVName;
	//~ local string	VName;
	//~ local string SummonVName;
	
	//~ ParseInt(Param, "UseVName",UseVName);
	//~ ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	//~ ParseString(Param, "VName", VName);
	//~ ParseString(Param, "SummonVName", SummonVName);
	
		
	//~ local int		Width;
	//~ local int		Height;
	
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "SummonNickName", SummonNickName);
	ParseInt(param, "SummonID", SummonID);
	ParseInt(param, "SummonClassID", SummonClassID);
	ParseInt(param, "SummonType", SummonType);
	ParseInt(param, "SummonMasterID", SummonMasterID);
	ParseInt(param, "SummonHP", SummonHP);
	ParseInt(param, "SummonMaxHP", SummonMaxHP);
	ParseInt(param, "SummonMP", SummonMP);
	ParseInt(param, "SummonMaxMP", SummonMaxMP);
	ParseInt(param, "SummonLevel", SummonLevel);
	
	//debug(" SummonNickName : " $ SummonNickName);
	//debug(" SummonID : " $ SummonID);
	//debug(" SummonClassID : " $ SummonClassID);
	//debug(" SummonType : " $ SummonType);
	//debug(" SummonMasterID : " $ SummonMasterID);
	//debug(" SummonHP : " $ SummonHP);
	//debug(" SummonMP : " $ SummonMP);
	//debug(" SummonMaxMP : " $ SummonMaxMP);
	//debug(" SummonLevel : " $ SummonLevel);
	//이름
	//
	//~ if( Len(SummonNickName) <1)	// 이름이 없으면
	//~ {
		//~ if(SummonType == 1)	// 소환수
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2140), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1597)), NCT_Normal,TA_Center);
		//~ else // 펫
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2139), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1596)), NCT_Normal,TA_Center);
	//~ }
	//~ else
	//~ {
		//~ m_PetName[idx].SetName(SummonNickName, NCT_Normal,TA_Center);
	//~ }
	
	//툴팁
	m_PetClassIcon[idx].SetTexture("L2UI_CT1.Icon.ICON_DF_PETICON");
	//m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(m_PetName[idx].GetName()));
			
	//펫 아이콘
	//m_ClassIcon[idx].SetTexture(GetClassIconName(SummonClassID));
	//m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	
	//각종 게이지
	UpdateHPBar(idx + 100, SummonHP, SummonMaxHP);
	UpdateMPBar(idx + 100, SummonMP, SummonMaxMP);
}

//버프리스트정보
function HandlePartySpelledList(string param)
{
	local int i;
	local int idx;
	local int ID;
	local int Max;
	
	local int BuffCnt;
	local int BuffCurRow;
	
	local int DeBuffCnt;
	local int DeBuffCurRow;
	
	//~ local int SongDanceCnt;
	local int SongDanceCurRow;
	
	local int TriggerSkillCnt;
	local int TriggerSkillCurRow;
	
	local bool isPC;	//pc인지 펫인지 체크하는 함수
	
	local StatusIconInfo info;
	
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	TriggerSkillCurRow = -1;
	isPC = false;
	
	ParseInt(param, "ID", ID);
	if (ID<1)
	{
		return;
	}
	
	idx = FindPartyID(ID);
	if(idx >=0)
	{
		//버프 초기화
		m_StatusIconBuff[idx].Clear();
		m_StatusIconDeBuff[idx].Clear();
		m_StatusIconSongDance[idx].Clear();
		m_StatusIconTriggerSkill[idx].Clear();
		isPC = true;
	}
	else	// 파티원이면 여긴 그냥 패스
	{
		idx = FindPetID(ID);	// 파티원이 아니라면, 펫인지 살펴본다. 
		if(idx >= 0)
		{
			//버프 초기화
			m_PetStatusIconBuff[idx].Clear();
			m_PetStatusIconDeBuff[idx].Clear();
			m_PetStatusIconSongDance[idx].Clear();
			m_PetStatusIconTriggerSkill[idx].Clear();
			isPC = false;
		}
		else
		{
			return;	// 펫 아이디마저 없다면 걍 무시무시
		}
	}
		
	//info 초기화
	info.Size = 16;
	info.bShow = true;
	
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "Sec_" $ i, info.RemainTime);
		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level);
			
			if (IsDeBuff( info.ID, info.Level) == true )
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconDeBuff[idx].AddRow();
					}
					else		
					{
						info.Size = 10;
						m_PetStatusIconDeBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				DeBuffCnt++;
			}
			else if (IsSongDance( info.ID, info.Level) == true )
			{
				//~ debug("송댄스입니까?");
				//~ SongDanceCurRow++;
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconSongDance[idx].AddRow();
				}
				else		
				{
					info.Size = 10;
					m_PetStatusIconSongDance[idx].AddRow();
				}
				
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconSongDance[idx].AddCol(0, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconSongDance[idx].AddCol(0, info);	
				}
				//~ SongDanceCurRow++;
			}
			else if (IsTriggerSkill( info.ID, info.Level) == true )
			{
				//~ debug("발동버프입니까?");
				if (TriggerSkillCnt % NSTATUSICON_MAXCOL == 0)
				{
					TriggerSkillCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconTriggerSkill[idx].AddRow();
					}
					else		
					{
						info.Size = 10;
						m_PetStatusIconTriggerSkill[idx].AddRow();
					}
				}
					
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				TriggerSkillCnt++;
			}
			else
			{
				//~ debug("일반 버프입니까?");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconBuff[idx].AddRow();
					}
					else
					{
						info.Size = 10;
						m_PetStatusIconBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconBuff[idx].AddCol(BuffCurRow, info);	
				}
				else		
				{
					info.Size = 10;
					m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info);	
				}
				BuffCnt++;
			}
		}
	}
	UpdateBuff();
}

//버프아이콘 표시
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	
	m_CurBf = m_CurBf + 1;
	
	
	if (m_CurBf > 3)
	{
		m_CurBf = 0;
	}
	
	SetBuffButtonTooltip();
	UpdateBuff();
	//~ switch (m_CurBf)
	//~ {
		//~ case 1:
		//~ UpdateBuff();
		//~ break;
		//~ case 2:
		//~ UpdateBuff();
		//~ break;
		//~ case 0:
		//~ m_CurBf = 0;
		//~ UpdateBuff();
	//~ }
}





// 버튼클릭 이벤트
function OnClickButton( string strID )
{
	local int idx;
	local PartyWndCompact script;
	script = PartyWndCompact( GetScript("PartyWndCompact") );
	switch( strID )
	{
	case "btnBuff":		//버프버튼 클릭시 
		OnBuffButton();
		script.OnBuffButton();
		break;
	case "btnCompact":	// 옵션 버튼 클릭시
		OnOpenPartyWndOption();
		//OnCompactButton();
		break;	
	case "btnSummon":	// 소환수 버튼 클릭시
		//debug("ERROR - you can't enter here");	// 여기로 들어오면 에러 -_-;
		break;
	}
	
	if(  inStr( strID , "btnSummon") > -1)
	{
		idx = int( Right(strID , 1));
		if(m_PetPartyStatus[idx].isShowwindow())
		{
			m_PetPartyStatus[idx].HideWindow();
			m_arrPetIDOpen[idx] = 2;
		}
		else
		{
			m_PetPartyStatus[idx].ShowWindow();
			m_arrPetIDOpen[idx] = 1;
		}
		ResizeWnd();
	}
}

// 옵션버튼 클릭시 불리는 함수
function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption script;
	script = PartyWndOption( GetScript("PartyWndOption") );
	
	// 열려있는 소환수 창 정보를 옵션 윈도우 , 작은 윈도우로 전달한다. 
	for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
	{
		script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
	}
	
	script.ShowPartyWndOption();
	m_PartyOption.SetAnchor("PartyWnd.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
	
	
}

// 사용되지 않는 함수인듯.  PartyWnd, PartyWndCompact, PartyWndOption 에서 사용하지 않음

//		function OnCompactButton()
//		{
//			local int idx;
//			local int Size;
//			
//			if (m_bCompact)
//			{
//				Size = 16;
//			}
//			else
//			{
//				Size = 10;
//			}
//			m_bCompact = !m_bCompact;
//			
//			for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
//			{
//				m_StatusIconBuff[idx].SetIconSize(Size);	
//				m_StatusIconDeBuff[idx].SetIconSize(Size);	
//			}
//		}

// 버프버튼을 눌렀을 경우 실행되는 함수
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;
	
	//3가지 모드가 전환된다.
	if (m_CurBf > 4)
	{
		m_CurBf = 0;
	}
	
	SetBuffButtonTooltip();
	UpdateBuff();
}

// 버프표시, 디버프 표시,  끄기 3가지모드를 전환한다.
function UpdateBuff()
{
	local int idx;
	if (m_CurBf == 1)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].ShowWindow();	
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if (m_CurBf == 2)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();	
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	else if (m_CurBf == 3)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();	
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	else if (m_CurBf == 4)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].ShowWindow();	
			m_PetStatusIconTriggerSkill[idx].ShowWindow();			
		}
	}
	else
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	//m_bBuff = bShow;
}

//CP바 갱신
function UpdateCPBar(int idx, int Value, int MaxValue)
{
	m_BarCP[idx].SetValue(MaxValue, Value);
}

//HP바 갱신
function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarHP[idx].SetValue(MaxValue, Value);
	else
		m_PetBarHP[idx - 100].SetValue(MaxValue, Value);
}

//MP바 갱신
function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarMP[idx].SetValue(MaxValue, Value);
	else 	// 100보다 크면 펫이 보낸거라는..
		m_PetBarMP[idx - 100].SetValue(MaxValue, Value);
}

//파티원 클릭 했을시..
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int idx;
	
	rectWnd = m_wndTop.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;	//펫보여주기 개편 전의 코드
			idx = GetIdx( Y-rectWnd.nY );
			//debug("OnLButtonDown : " $ idx);
			if (IsPKMode())
			{
				if(idx <100)
					RequestAttack(m_arrID[idx], userinfo.Loc);
				else
					RequestAttack(m_arrPetID[idx-100], userinfo.Loc);
			}
			else
			{
				if(idx < 100)
					RequestAction(m_arrID[idx], userinfo.Loc);
				else
					RequestAction(m_arrPetID[idx-100], userinfo.Loc);
			}
		}
	}
}

//파티원의 어시스트
function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int idx;
		
	rectWnd = m_wndTop.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;	//펫보여주기 개편 전의 코드
			idx = GetIdx( Y-rectWnd.nY );
			//debug("OnRButtonUp : " $ idx);
			if(idx <100)
				RequestAssist(m_arrID[idx], userinfo.Loc);
			else
				RequestAssist(m_arrPetID[idx-100], userinfo.Loc);
		}
	}
}

// Y 좌표를 이용해 배열의 인덱스 값을 구한다. 펫의 경우에는 + 100을 하여 리턴해준다. 
function int GetIdx(int y)
{
	local int tempY;	// 이변수는 배열을 위에서부터 훑고 내려가면서 누적 감소시킨다. 
	local int i;
	local int idx;
	
	idx = -1;
	tempY = y;
	
	for(i=0 ; i<NPARTYSTATUS_MAXCOUNT ; i++)
	{
		tempY = tempY - NPARTYSTATUS_HEIGHT;
		
		if(tempY <0)	// 0보다 작으면 해당 i가 IDX가 된다. 
		{
			idx = i;	//필요할까 싶지만, 안전장치 차원에서..
			return idx;
		}
		else if( m_arrPetIDOpen[i] == 1) // 해당 인덱스의 펫이 열려있다면
		{
			tempY = tempY - NPARTYPETSTATUS_HEIGHT;			
			if(tempY <0)	// 0보다 작으면 해당 i가 IDX가 된다. 
			{
				idx = i + 100;	//펫일 경우 100을 더하여 보내준다. 
				return idx;
			}
		}		
	}
	
	return idx;
}

// 버프 툴팁을 설정한다.
function SetBuffButtonTooltip()
{
	local int idx;
	switch (m_CurBf)
	{
		case 0:	idx = 1496;
		break;
		case 1:	idx = 1497;
		break;
		case 2:	idx = 1741;
		break;
		case 3:	idx = 2307;
		break;
		case 4: idx = 1498;
		break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}

function OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y )
{
	local string sTargetName, sDropName ,sTargetParent;
	local int dropIdx, targetIdx, i;
	
	//local  PartyWnd script1;			// 확장된 파티창의 클래스
	local PartyWndCompact script2;	// 축소된 파티창의 클래스
	
	//script1 = PartyWnd( GetScript("PartyWnd") );
	script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	dropIdx = -1;
	targetIdx = -1;
	
	if( hTarget == None || hDropWnd == None )
		return;
	
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	
	// PartyStatusWnd에만 드래그 엔 드롭을 할 수 있다. 
	//if(( InStr( "PartyStatusWnd", sTargetName ) == -1 ) || ( InStr( "PartyStatusWnd" ,sDropName) == -1 ))
	if( (( InStr( sTargetName , "PartyStatusWnd" ) == -1 ) && ( InStr( sTargetParent , "PartyStatusWnd" ) == -1 )   ) || ( InStr( sDropName, "PartyStatusWnd") == -1 ))
	{
		//Debug( "sTargetName: " $ sTargetName );
		//Debug( "sTargetName: " $ sDropName );
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName , 1));
		
		if( InStr( sTargetName , "PartyStatusWnd" ) > -1 ) 	//타겟 네임이 있을 겨우
			targetIdx = int(Right(sTargetName , 1));
		else									//타겟 네임은 없지만 부모의 이름이 PartyStatusWnd 일때
			targetIdx = int(Right(sTargetParent , 1));
		
		if( dropIdx <0 || targetIdx <0 )
		{
			//Debug( "ERROR IDX: " $ dropIdx $ " / " $  targetIdx);
		}
		
		// 아래 혹은 위로 밀어주는 코드
		if( dropIdx > targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//타겟을 옮겨놓고
			script2.CopyStatus ( 8 , dropIdx );		//타겟을 옮겨놓고
			
			for (i=dropIdx-1; i>targetIdx-1; i--)	// 아래로 밀어준다. 
			{
				CopyStatus(i+1, i);
				script2.CopyStatus(i+1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script2.CopyStatus ( targetIdx , 8  );
		}
		else if(dropIdx < targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//타겟을 옮겨놓고
			script2.CopyStatus ( 8 , dropIdx );		//타겟을 옮겨놓고
			
			for (i=dropIdx+1; i<targetIdx+1; i++)	// 위로 땡겨준다.
			{
				CopyStatus(i-1, i);
				script2.CopyStatus(i-1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script2.CopyStatus ( targetIdx , 8  );
		}

		ClearStatus(8);
		ClearPetStatus(8);
		
		//Update Client Data
		class'UIDATA_PARTY'.static.MovePartyMember( dropIdx, targetIdx );
		
		ResizeWnd();
	}
}

function int GetVNameIndexByID( int ID )
{
	local int i;
	for (i=0; i<8; i++)
	{
		if( m_Vname[i].ID == ID )
			return i;
	}
	return -1;
}

function ResetVName()
{
	local int i;
	
	for (i=0; i<8; i++)
	{
		m_Vname[i].ID = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
	}
}
defaultproperties
{
}
