class SummonedWnd extends UICommonAPI;

const NPET_SMALLBARSIZE = 125;
const NPET_BARHEIGHT = 12;

var int m_PetID;

var WindowHandle Me;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;
var TextBoxHandle txtLvName;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtSpiritShotConsume;
var ItemWindowHandle SummonedActionWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_SummonedWndShow );
	RegisterEvent( EV_PetSummonedStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionSummonedListStart );
	RegisterEvent( EV_ActionSummonedList );
	
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
}

function InitHandle()
{
	Me = GetHandle( "SummonedWnd" );
	HPBar = StatusBarHandle( GetHandle( "SummonedWnd.HPBar" ) );
	MPBar = StatusBarHandle( GetHandle( "SummonedWnd.MPBar" ) );
	txtLvName = TextBoxHandle( GetHandle( "SummonedWnd.txtLvName" ) );
	txtPhysicalAttack = TextBoxHandle( GetHandle( "SummonedWnd.txtPhysicalAttack" ) );
	txtPhysicalDefense = TextBoxHandle( GetHandle( "SummonedWnd.txtPhysicalDefense" ) );
	txtHitRate = TextBoxHandle( GetHandle( "SummonedWnd.txtHitRate" ) );
	txtCriticalRate = TextBoxHandle( GetHandle( "SummonedWnd.txtCriticalRate" ) );
	txtPhysicalAttackSpeed = TextBoxHandle( GetHandle( "SummonedWnd.txtPhysicalAttackSpeed" ) );
	txtMagicalAttack = TextBoxHandle( GetHandle( "SummonedWnd.txtMagicalAttack" ) );
	txtMagicDefense = TextBoxHandle( GetHandle( "SummonedWnd.txtMagicDefense" ) );
	txtPhysicalAvoid = TextBoxHandle( GetHandle( "SummonedWnd.txtPhysicalAvoid" ) );
	txtMovingSpeed = TextBoxHandle( GetHandle( "SummonedWnd.txtMovingSpeed" ) );
	txtMagicCastingSpeed = TextBoxHandle( GetHandle( "SummonedWnd.txtMagicCastingSpeed" ) );
	txtSoulShotCosume = TextBoxHandle( GetHandle( "SummonedWnd.txtSoulShotCosume" ) );
	txtSpiritShotConsume = TextBoxHandle( GetHandle( "SummonedWnd.txtSpiritShotConsume" ) );
	SummonedActionWnd = ItemWindowHandle( GetHandle( "SummonedWnd.SummonedWnd_Action.SummonedActionWnd" ) );
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "SummonedWnd" );
	HPBar = GetStatusBarHandle( "SummonedWnd.HPBar" );
	MPBar = GetStatusBarHandle( "SummonedWnd.MPBar" );
	txtLvName = GetTextBoxHandle( "SummonedWnd.txtLvName" );
	txtPhysicalAttack = GetTextBoxHandle( "SummonedWnd.txtPhysicalAttack" );
	txtPhysicalDefense = GetTextBoxHandle( "SummonedWnd.txtPhysicalDefense" );
	txtHitRate = GetTextBoxHandle( "SummonedWnd.txtHitRate" );
	txtCriticalRate = GetTextBoxHandle( "SummonedWnd.txtCriticalRate" );
	txtPhysicalAttackSpeed = GetTextBoxHandle( "SummonedWnd.txtPhysicalAttackSpeed" );
	txtMagicalAttack = GetTextBoxHandle( "SummonedWnd.txtMagicalAttack" );
	txtMagicDefense = GetTextBoxHandle( "SummonedWnd.txtMagicDefense" );
	txtPhysicalAvoid = GetTextBoxHandle( "SummonedWnd.txtPhysicalAvoid" );
	txtMovingSpeed = GetTextBoxHandle( "SummonedWnd.txtMovingSpeed" );
	txtMagicCastingSpeed = GetTextBoxHandle( "SummonedWnd.txtMagicCastingSpeed" );
	txtSoulShotCosume = GetTextBoxHandle( "SummonedWnd.txtSoulShotCosume" );
	txtSpiritShotConsume = GetTextBoxHandle( "SummonedWnd.txtSpiritShotConsume" );
	SummonedActionWnd = GetItemWindowHandle( "SummonedWnd.SummonedWnd_Action.SummonedActionWnd" );
}

function OnShow()
{
	class'ActionAPI'.static.RequestSummonedActionList();
}

function HandleLanguageChanged()
{
	class'ActionAPI'.static.RequestSummonedActionList();
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetSummonedStatusClose();
	}
	else if (Event_ID == EV_SummonedWndShow)
	{
		HandlePetShow();
	}
	else if (Event_ID == EV_ActionSummonedListStart)
	{
		HandleActionSummonedListStart();
	}
	else if (Event_ID == EV_ActionSummonedList)
	{
		HandleActionSummonedList(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		class'ActionAPI'.static.RequestSummonedActionList();
	}
}

//액션의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "SummonedActionWnd" && index>-1)
	{
		if (SummonedActionWnd.GetItem(index, infItem))
			DoAction(infItem.ID);
	}
}

function HandleActionSummonedListStart()
{
	ClearActionWnd();
}

//초기화
function Clear()
{
	txtLvName.SetText("");
	HPBar.SetPoint(0,0);
	MPBar.SetPoint(0,0);	
}
function ClearActionWnd()
{
	SummonedActionWnd.Clear();
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
	local int		Level;
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
	
	local PetInfo	info;
	
	if( !Me.IsShowWindow() )
		return;
	
	if (GetPetInfo(info))
	{
		//Check Is Pet?
		if( !info.bIsPetOrSummoned )
			return;

		m_PetID = info.nID;
		Name = info.Name;
		Level = info.nLevel;
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		
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

	HPBar.SetPoint(HP , MaxHP);
	MPBar.SetPoint(MP , MaxMP);	
}

//펫창을 표시
function HandlePetShow()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	
	HandlePetInfoUpdate();
}

function HandleActionSummonedList(string param)
{
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);

	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//ItemWnd에 추가
	Type = EActionCategory(Tmp);
	if (Type==ACTION_SUMMON)
		SummonedActionWnd.AddItem(infItem);
}
defaultproperties
{
}
