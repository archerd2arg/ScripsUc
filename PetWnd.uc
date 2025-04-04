class PetWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";

const DIALOG_PETNAME		= 1111;				// 펫이름적기
const DIALOG_GIVEITEMTOPET	= 2222;				// 인벤에서 펫인벤으로 아이템 옮기기

const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
//~ const PET_EVOLUTIONIZED_ID = 16025;
const PET_EVOLUTIONIZED_ID = 1210114602;

var int			m_PetID;
var bool		m_bShowNameBtn;
var string		m_LastInputPetName;
var int 		EvolutionizedAction;

var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
//var TextBoxHandle txtPetHP;
//var TextBoxHandle txtPetMP;
var TextBoxHandle txtPetSP;
//var TextBoxHandle txtPetExp;
//var TextBoxHandle txtFatigue;
var TextBoxHandle txtLvName;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSpiritShotConsume;
var ItemWindowHandle PetActionWnd;
var ItemWindowHandle PetInvenWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_PetWndShow );
	RegisterEvent( EV_PetWndShowNameBtn );
	RegisterEvent( EV_PetWndRegPetNameFailed );
	RegisterEvent( EV_PetSummonedStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionPetListStart );
	RegisterEvent( EV_ActionPetList );
	
	RegisterEvent( EV_PetInventoryItemStart );
	RegisterEvent( EV_PetInventoryItemList );
	RegisterEvent( EV_PetInventoryItemUpdate );
	
	RegisterEvent( EV_LanguageChanged );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
}

function InitHandle()
{
	Me = GetHandle( "PetWnd" );
	btnName = ButtonHandle ( GetHandle( "PetWnd.btnName" ) );
	texPetHP = StatusBarHandle ( GetHandle( "PetWnd.texPetHP" ) );
	texPetMP = StatusBarHandle ( GetHandle( "PetWnd.texPetMP" ) );
	texPetExp = StatusBarHandle ( GetHandle( "PetWnd.texPetExp" ) );
	texPetFatigue = StatusBarHandle ( GetHandle( "PetWnd.texPetFatigue" ) );
	//txtPetHP = TextBoxHandle ( GetHandle( "PetWnd.txtPetHP" ) );
	//txtPetMP = TextBoxHandle ( GetHandle( "PetWnd.txtPetMP" ) );
	txtPetSP = TextBoxHandle ( GetHandle( "PetWnd.txtPetSP" ) );
	//txtPetExp = TextBoxHandle ( GetHandle( "PetWnd.txtPetExp" ) );
	//txtFatigue = TextBoxHandle ( GetHandle( "PetWnd.txtFatigue" ) );
	txtLvName = TextBoxHandle ( GetHandle( "PetWnd.txtLvName" ) );
	txtPhysicalAttack = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAttack" ) );
	txtPhysicalDefense = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalDefense" ) );
	txtHitRate = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtHitRate" ) );
	txtCriticalRate = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtCriticalRate" ) );
	txtPhysicalAttackSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAttackSpeed" ) );
	txtSoulShotCosume = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtSoulShotCosume" ) );
	txtMagicalAttack = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicalAttack" ) );
	txtMagicDefense = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicDefense" ) );
	txtPhysicalAvoid = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAvoid" ) );
	txtMovingSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMovingSpeed" ) );
	txtMagicCastingSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicCastingSpeed" ) );
	txtSpiritShotConsume = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtSpiritShotConsume" ) );
	PetActionWnd = ItemWindowHandle ( GetHandle( "PetWnd.PetWnd_Action.PetActionWnd" ) );
	PetInvenWnd = ItemWindowHandle ( GetHandle( "PetWnd.PetWnd_Inventory.PetInvenWnd" ) );
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "PetWnd" );
	btnName = GetButtonHandle ( "PetWnd.btnName" );
	texPetHP = GetStatusBarHandle( "PetWnd.texPetHP" );
	texPetMP = GetStatusBarHandle( "PetWnd.texPetMP" );
	texPetExp = GetStatusBarHandle( "PetWnd.texPetExp" );
	texPetFatigue = GetStatusBarHandle( "PetWnd.texPetFatigue" );
	txtPetSP = GetTextBoxHandle( "PetWnd.txtPetSP" );
	txtLvName = GetTextBoxHandle( "PetWnd.txtLvName" );
	txtPhysicalAttack = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAttack" );
	txtPhysicalDefense = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalDefense" );
	txtHitRate = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtHitRate" );
	txtCriticalRate = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtCriticalRate" );
	txtPhysicalAttackSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAttackSpeed" );
	txtSoulShotCosume = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtSoulShotCosume" );
	txtMagicalAttack = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicalAttack" );
	txtMagicDefense = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicDefense" );
	txtPhysicalAvoid = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAvoid" );
	txtMovingSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMovingSpeed" );
	txtMagicCastingSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicCastingSpeed" );
	txtSpiritShotConsume = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtSpiritShotConsume" );
	PetActionWnd = GetItemWindowHandle ( "PetWnd.PetWnd_Action.PetActionWnd" );
	PetInvenWnd = GetItemWindowHandle ( "PetWnd.PetWnd_Inventory.PetInvenWnd" );
}

function OnShow()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();
}

function OnDropItem( String strTarget, ItemInfo info, int x, int y )
{
	if( strTarget == "PetInvenWnd" && info.DragSrcName == "InventoryItem" )
	{
		if( IsStackableItem(info.ConsumeType) && info.ItemNum > IntToInt64(1) )			// Multiple item?
		{
			if( info.AllItemCount > IntToInt64(0) )				// 전부 이동?
			{
				class'PetAPI'.static.RequestGiveItemToPet(info.ID, info.AllItemCount);
			}
			else
			{
				DialogSetID(DIALOG_GIVEITEMTOPET);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetParamInt64(info.ItemNum);
				DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name ) );
			}
		}
		else																// Single item?
		{
			class'PetAPI'.static.RequestGiveItemToPet(info.ID, IntToInt64(1));
		}
	}
}

function HandleLanguageChanged()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		//~ debug("펫정보 업데이트 이벤트로 받음");
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetSummonedStatusClose();
	}
	else if (Event_ID == EV_PetWndShow)
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	}
	else if (Event_ID == EV_PetWndShowNameBtn)
	{
		HandlePetShowNameBtn(param);
	}
	else if (Event_ID == EV_PetWndRegPetNameFailed)
	{
		HandleRegPetName(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if (Event_ID == EV_ActionPetListStart)
	{
		//~ debug("액션항목을 지운다.:");
		HandleActionPetListStart();
	}
	else if (Event_ID == EV_ActionPetList)
	{
		HandleActionPetList(param);
	}
	else if (Event_ID == EV_PetInventoryItemStart)
	{
		HandlePetInventoryItemStart();
	}
	else if (Event_ID == EV_PetInventoryItemList)
	{
		HandlePetInventoryItemList(param);
	}
	else if (Event_ID == EV_PetInventoryItemUpdate)
	{
		HandlePetInventoryItemUpdate(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		class'ActionAPI'.static.RequestPetActionList();
	}

}

function HandleDialogOK()
{
	local int ID;
	local ItemID sID;
	local INT64 Number;
	
	if( DialogIsMine() )
	{
		ID = DialogGetID();
		sID = DialogGetReservedItemID();
		Number = StringToInt64(DialogGetString());
		
		if( id == DIALOG_PETNAME )
		{
			m_LastInputPetName = DialogGetString();
			RequestChangePetName(m_LastInputPetName);	//등록 결과가 EV_PetWndRegNameXXX로 날라온다.
		}
		else if( id == DIALOG_GIVEITEMTOPET )
		{
			class'PetAPI'.static.RequestGiveItemToPet(sID, Number);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnName":
		OnNameClick();
		break;
	}
}

function OnNameClick()
{
	DialogSetID(DIALOG_PETNAME);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
}

//액션의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetActionWnd" && index>-1)
	{
		if (PetActionWnd.GetItem(index, infItem))
			DoAction(infItem.ID);
	}
}

//인벤 아이템의 사용
function OnDBClickItem( String strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetInvenWnd" && index>-1)
	{
		if (PetInvenWnd.GetItem(index, infItem))
			class'PetAPI'.static.RequestPetUseItem(infItem.ID);
	}
}
function OnRClickItem( String strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetInvenWnd" && index>-1)
	{
		if (PetInvenWnd.GetItem(index, infItem))
			class'PetAPI'.static.RequestPetUseItem(infItem.ID);
	}
}

//초기화
function Clear()
{
	txtLvName.SetText("");
	//txtPetHP.SetText("0/0");
	//txtPetMP.SetText("0/0");
	txtPetSP.SetText("0");
	//txtPetExp.SetText("0%");
	//txtFatigue.SetText("0%");
		
	texPetHP.SetPoint(0, 0);
	texPetMP.SetPoint(0, 0);
	texPetExp.SetPointExpPercentRate(0.0f);
	texPetFatigue.SetPointExpPercentRate(0.0f);
}
function ClearActionWnd()
{
	PetActionWnd.Clear();
}
function ClearInvenWnd()
{
	PetInvenWnd.Clear();
}

//펫이름 등록 결과 처리
function HandleRegPetName(string param)
{
	local int MsgNo;
	
	ParseInt(param, "ErrMsgNo", MsgNo);
		
	AddSystemMessage(MsgNo);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
	
	//펫이름이 제한글자수를 초과하였을 때는, 전에 입력한 이름을 다시 출력한다.
	if (MsgNo==80)
	{
		DialogSetString(m_LastInputPetName);
	}
}

//펫이름 버튼 처리
function HandlePetShowNameBtn(string param)
{
	local int ShowFlag;
	ParseInt(param, "Show", ShowFlag);
	
	if (ShowFlag==1)
	{
		SetVisibleNameBtn(true);
	}
	else
	{
		SetVisibleNameBtn(false);
	}
}

function SetVisibleNameBtn(bool bShow)
{
	if (bShow)
	{
		btnName.ShowWindow();
	}
	else
	{
		btnName.HideWindow();
	}
	m_bShowNameBtn = bShow;
}

//종료처리
function HandlePetSummonedStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//펫Info패킷 처리
function HandlePetInfoUpdate()
{
	local string	Name;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Fatigue;
	local int		MaxFatigue;
	local int		SP;
	local int		Level;
	local float		fExpRate;
	local float		fTmp;
	local int		PhysicalAttack;
	local int		PhysicalDefense;
	local int		HitRate;
	local int		CriticalRate;
	local int		PhysicalAttackSpeed;
	local int		MagicalAttack;
	local int		MagicDefense;
	local int		PhysicalAvoid;
	local int		MovingSpeed;
	local int		MagicCastingSpeed;
	local int		SoulShotCosume;
	local int		SpiritShotConsume;
	local int 		nEvolutionID;
	
	local PetInfo	info;
	
	if( !Me.IsShowWindow() )
		return;
	
	if (GetPetInfo(info))
	{
		//Check Is Pet?
		if( info.bIsPetOrSummoned )
			return;
			
		m_PetID = info.nID;
		Name = info.Name;
		SP = info.nSP;
		Level = info.nLevel;
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		Fatigue = info.nFatigue;
		MaxFatigue = info.nMaxFatigue;
		fExpRate = class'UIDATA_PET'.static.GetPetEXPRate();
		nEvolutionID = info.nEvolutionID;
			
		
		//펫 상세 정보
		PhysicalAttack			= info.nPhysicalAttack;
		PhysicalDefense		= info.nPhysicalDefense;
		HitRate				= info.nHitRate;
		CriticalRate			= info.nCriticalRate;
		PhysicalAttackSpeed	= info.nPhysicalAttackSpeed;
		MagicalAttack			= info.nMagicalAttack;
		MagicDefense			= info.nMagicDefense;
		PhysicalAvoid			= info.nPhysicalAvoid;
		MovingSpeed			= info.nMovingSpeed;
		MagicCastingSpeed		= info.nMagicCastingSpeed;
		SoulShotCosume		= info.nSoulShotCosume;
		SpiritShotConsume		= info.nSpiritShotConsume;
	}
	
	txtLvName.SetText(Level $ " " $ Name);
	//txtPetHP.SetText(HP $ "/" $ MaxHP);
	//txtPetMP.SetText(MP $ "/" $ MaxMP);
	txtPetSP.SetText(string(SP));
	//txtPetExp.SetText(fExpRate $ "%");
	
	//펫 상세 정보 탭
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(string(MovingSpeed));
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	txtSoulShotCosume.SetText(string(SoulShotCosume));
	txtSpiritShotConsume.SetText(string(SpiritShotConsume));
	
	fTmp = 100.0f * float(Fatigue) / float(MaxFatigue);
	//txtFatigue.SetText(fTmp $ "%");
	
	//debug ("현쟁의  PEt HP1"@ HP);
	//debug ("현쟁의  PEt HP2"@ MaxHP);
	texPetHP.SetPoint(HP , MaxHP);
	
	texPetMP.SetPoint(MP , MaxMP);
	fTmp = 100.0f * fExpRate;
	
	
	texPetExp.SetPointExpPercentRate(GetPercent(int(fTmp), 10000));
	texPetFatigue.SetPointExpPercentRate(GetPercent(Fatigue, MaxFatigue));
	
	//진화형 펫에 따른 특별 액션 처리
	EvolutionizedAction = nEvolutionID;
	//~ debug("진화아이디:"@ EvolutionizedAction @ nEvolutionID);
	
}

//펫창을 표시
function HandlePetShow()
{
	//branch
	local UserInfo	a_UserInfo;
	local PetInfo	info;
	if (GetPetInfo(info)) {
		GetUserInfo( info.nID, a_UserInfo );
		if (a_UserInfo.nClassID == 1538) {
			return;
		}
	}
	//end of branch
	
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	//~ debug("펫정보 이벤트를 임의로 실행함");
	HandlePetInfoUpdate();
	
	//이름버튼
	SetVisibleNameBtn(m_bShowNameBtn);
}

///////////////////////////////////////////////////////////////////////////////////////
// 액션 아이템 처리
///////////////////////////////////////////////////////////////////////////////////////
function HandleActionPetListStart()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
}

function HandleActionPetList(string param)
{
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	local int intClassID;
	
	local ItemInfo	infItem;

	//branch	
	local UserInfo	a_UserInfo;
	local PetInfo	info;
	//end of branch
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "ClassID", intClassID);
	
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//~ ClearActionWnd();
	
	//ItemWnd에 추가
	Type = EActionCategory(Tmp);

	//branch
	if (GetPetInfo(info)) {
		if (GetUserInfo( info.nID, a_UserInfo )) {
			if (a_UserInfo.nClassID == 1561 && Type==ACTION_PET && intClassID == 16 ) {		// 유료 루돌프 펫은 걸러짐 -_-;;
				return;
			}
		}
	}
	//end of branch
	
	//펫의 레벨별 액션 추가 기능 
	if (Type==ACTION_PET)
	{
		switch (EvolutionizedAction)
		{
			case 2:
				if (intClassID == 1044)
				{
					//~ debug("걸러짐3");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 1:
				if (intClassID == 1042 || intClassID == 1044)
				{
					//~ debug("걸러짐2");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 0:
				if (intClassID == 1042 || intClassID == 1043 || intClassID == 1044 || intClassID == 1045 || intClassID == 1046)
				{
					//~ debug("걸러짐1");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 3:
				PetActionWnd.AddItem(infItem);
				break;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// 인벤 아이템 처리
///////////////////////////////////////////////////////////////////////////////////////
function HandlePetInventoryItemStart()
{
	ClearInvenWnd();
}

function HandlePetInventoryItemList(string param)
{
	local ItemInfo	infItem;
	
	ParamToItemInfo(param, infItem);
	
	if (infItem.bEquipped)
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
	
	PetInvenWnd.AddItem(infItem);
}

function HandlePetInventoryItemUpdate(string param)
{
	local ItemInfo	infItem;
	local int		Tmp;
	local int		Index;
	local EInventoryUpdateType WorkType;
	
	ParamToItemInfo(param, infItem);
	ParseInt(param, "WorkType", Tmp);
	WorkType = EInventoryUpdateType(Tmp);
	
	//Check ClassID
	if (!IsValidItemID(infItem.ID))
		return;
		
	if (infItem.bEquipped)
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
		
	switch( WorkType )
	{
	case IVUT_ADD:
		PetInvenWnd.AddItem(infItem);
		break;
	case IVUT_UPDATE:
		//Find Item
		Index = PetInvenWnd.FindItem(infItem.ID);
		if (Index<0)
			return;
		PetInvenWnd.SetItem(Index, infItem);
		break;
	case IVUT_DELETE:
		//Find Item
		Index = PetInvenWnd.FindItem(infItem.ID);
		if (Index<0)
			return;
		PetInvenWnd.DeleteItem(Index);
		break;
	}
}
defaultproperties
{
}
