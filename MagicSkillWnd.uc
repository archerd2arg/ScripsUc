class MagicSkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;
const Skill_GROUP_COUNT = 8;

const Skill_GROUP_COUNT_P = 6;	//패시브용

//const SKILL_MAX_HERO = 6;
//const SKILL_MAX_ITEM = 1000;
//const SKILL_MAX_CHANGE = 20;

const SKILL_ITEMWND_WIDTH = 223;
const SKILL_SLOTBG_WIDTH = 216;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT = 20;
const BETWEEN_NAME_ITEM = 3;

// 스킬 그룹 번호
const SKILL_NORMAL = 0;		// 보통 스킬. 데미지 및 힐, 마법 포함.
const SKILL_BUF = 1;			// 버프
const SKILL_DEBUF = 2;		// 디버프
const SKILL_TOGGLE = 3;		// 토글
const SKILL_SONG_DANCE = 4;	// 송댄스
const SKILL_ITEM = 5;			// 아이템 스킬
const SKILL_HERO = 6;		// 영웅 스킬
const SKILL_CHANGE = 7;		// 변신 스킬

var WindowHandle	m_wndTop;
var WindowHandle	m_wndSkillDrawWnd;
// 액티브용
var WindowHandle	m_wndName[Skill_GROUP_COUNT];
var TextBoxHandle	m_NameStr[Skill_GROUP_COUNT];
var TextureHandle	m_NameBtn[Skill_GROUP_COUNT];
var TextureHandle	m_ItemBg[Skill_GROUP_COUNT];
var WindowHandle	m_wnd[Skill_GROUP_COUNT];
var ItemWindowHandle	m_Item[Skill_GROUP_COUNT];
var ButtonHandle		m_HiddenBtn[Skill_GROUP_COUNT];
var WindowHandle	areaScroll;
//패시브용
var WindowHandle	m_wndName_p[Skill_GROUP_COUNT_P];
var TextBoxHandle	m_NameStr_p[Skill_GROUP_COUNT_P];
var TextureHandle	m_NameBtn_p[Skill_GROUP_COUNT_P];
var TextureHandle	m_ItemBg_p[Skill_GROUP_COUNT_P];
var WindowHandle	m_wnd_p[Skill_GROUP_COUNT_P];
var ItemWindowHandle	m_Item_p[Skill_GROUP_COUNT_P];
var ButtonHandle		m_HiddenBtn_p[Skill_GROUP_COUNT_P];
var WindowHandle	areaScroll_p;

//var array<int> m_HeroSkillID;
//var array<int> m_ItemSkillID;
//var array<int> m_ChangeSkillID;

var bool m_bShow;
var String m_WindowName;
// 액티브용
var int m_bExistSkill[Skill_GROUP_COUNT];	// 1이면 해당 그룹 스킬이 없는것, 2이면 해당 그룹 스킬이 있고 열려있는 것. 3 이면 해당 그룹 스킬이 있고 닫혀 있는 것
var int nScrollHeight;					// 전체 윈도우의 스크롤 크기 결정

// 패시브용
var int m_bExistSkill_p[Skill_GROUP_COUNT_P];
var int nScrollHeight_p;					// 전체 윈도우의 스크롤 크기 결정

var WindowHandle	Drawer;
var ButtonHandle	ResearchButton;

function OnRegisterEvent()
{
	RegisterEvent(EV_SkillListStart);
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_LanguageChanged);
	RegisterEvent(Ev_SkillEnchantInfoWndShow);
	
}

function OnLoad()
{
	InitHandle();
		
	m_bShow = false;
}

function InitHandle()
{
	local int i;

	m_wndTop = GetWindowHandle( m_WindowName );
	Drawer = GetWindowHandle( "MagicSkillDrawerWnd");
	areaScroll = GetWindowHandle( m_WindowName $ ".ASkillScroll" );
	areaScroll_p = GetWindowHandle( m_WindowName $ ".PSkillScroll" );
	
	for(i=0; i<Skill_GROUP_COUNT ; i++)
	{
		m_wndName[i] = GetWindowHandle( m_WindowName $".ASkill.ASkillName" $ i ); 
		m_wnd[i] = GetWindowHandle( m_WindowName $ ".ASkill.ASkill" $ i ); 
		m_NameStr[i] = GetTextBoxHandle ( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillNameStr" $ i ); 
		m_NameBtn[i] = GetTextureHandle( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillBtn" $ i ); 
		m_Item[i] = GetItemWindowHandle ( m_WindowName $ ".ASkill.ASkill" $  i $ ".ASkillItem" $ i ); 
		m_ItemBg[i] = GetTextureHandle( m_WindowName $ ".ASkill.ASkill" $  i $ ".ASkillSlotBg" $ i ); 
		m_HiddenBtn[i] = GetButtonHandle ( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillHiddenBtn" $ i ); 
		m_HiddenBtn[i].SetAlpha(255);
	}
	
	for(i=0; i<Skill_GROUP_COUNT_P ; i++)
	{
		m_wndName_p[i] = GetWindowHandle( m_WindowName $".PSkill.PSkillName" $ i ); 
		m_wnd_p[i] = GetWindowHandle( m_WindowName $ ".PSkill.PSkill" $ i ); 
		m_NameStr_p[i] = GetTextBoxHandle ( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillNameStr" $ i ); 
		m_NameBtn_p[i] = GetTextureHandle( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillBtn" $ i ); 
		m_Item_p[i] = GetItemWindowHandle ( m_WindowName $ ".PSkill.PSkill" $  i $ ".PSkillItem" $ i ); 
		m_ItemBg_p[i] = GetTextureHandle( m_WindowName $ ".PSkill.PSkill" $  i $ ".PSkillSlotBg" $ i ); 
		m_HiddenBtn_p[i] = GetButtonHandle ( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillHiddenBtn" $ i ); 
		m_HiddenBtn_p[i].SetAlpha(255);
	}
}

function OnShow()
{
	RequestSkillList();
	m_bShow = true;
}

function OnHide()
{
	local MagicSkillDrawerWnd script_a;	

	m_bShow = false;

	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

	script_a.HideAgathion();
	Drawer.HideWindow();
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_SkillListStart)
	{
		//debug("!!!Skill!!! List 패킷 날아옴");
		HandleSkillListStart();
	}
	else if (Event_ID == EV_SkillList)
	{
		HandleSkillList(param);
		ComputeItemWndHeight();
		ComputeItemWndAnchor();
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if (Event_ID == Ev_SkillEnchantInfoWndShow)
	{
		Drawer.ShowWindow();
	}
}

//스킬의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	local int		GroupID;
	
	if ( InStr( strID ,"ASkillItem" ) > -1 && index>-1)
	{
		GroupID = int(Right(strID, 1));
		if(m_Item[GroupID].GetItem(index, infItem))
		{
			// 10.04.5 동현씨 수정 요청 
			UseSkill(infItem.ID, infItem.ItemSubType);
		}
	}
}

// 버튼클릭 이벤트
function OnClickButton( string strID )
{
	local int i;				// for를 돌리기 위한 변수
	local int index;
	local int nWndWidth, nWndHeight; // 윈도우 사이즈 받기 변수
	local MagicSkillDrawerWnd script_a;	
	
	index = int(Right(strID, 1));	//버튼의 제일 끝 숫자를 따낸다. 
	
	if( InStr( strID ,"ASkillHiddenBtn" ) > -1)
	{
		if (m_bExistSkill[index] == 1)		// 안접혀 있으면 접어준다. 
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;; Height만 사용
			nScrollHeight = nScrollHeight - nWndHeight - BETWEEN_NAME_ITEM;	// 사이즈가 변했기 때문에 스크롤 높이를 조절해준다. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill[index] = 2;
			m_wnd[index].HideWindow();	
			
			// 다음 윈도우의 앵커를 수정해준다.  (네임 바로 밑에 붙여줌)
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1 ; i<Skill_GROUP_COUNT ; i++)	
				{
					if(m_bExistSkill[i]  >0)	// 다음 윈도우가 접혔는지 펼쳐져 있는지는 신경쓰지 않는다. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill[index] == 2)		// 접혀있으면 펴준다.
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;; Height만 사용
			nScrollHeight = nScrollHeight + nWndHeight + BETWEEN_NAME_ITEM;	// 사이즈가 변했기 때문에 스크롤 높이를 조절해준다. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill[index] = 1;
			m_wnd[index].ShowWindow();
			
			// 다음 윈도우의 앵커를 수정해준다. 
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1; i<Skill_GROUP_COUNT ; i++)	
				{
					if(m_bExistSkill[i]  >0)	// 다음 윈도우가 접혔는지 펼쳐져 있는지는 신경쓰지 않는다. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll.SetScrollHeight(nScrollHeight);
		//areaScroll.SetScrollPosition( 0 );
	}
	else if( InStr( strID ,"PSkillHiddenBtn" ) > -1)
	{
		if (m_bExistSkill_p[index] == 1)		// 안접혀 있으면 접어준다. 
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;; Height만 사용
			nScrollHeight_p = nScrollHeight_p - nWndHeight - BETWEEN_NAME_ITEM;	// 사이즈가 변했기 때문에 스크롤 높이를 조절해준다. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill_p[index] = 2;
			m_wnd_p[index].HideWindow();	
			
			// 다음 윈도우의 앵커를 수정해준다.  (네임 바로 밑에 붙여줌)
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1 ; i<Skill_GROUP_COUNT_P ; i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// 다음 윈도우가 접혔는지 펼쳐져 있는지는 신경쓰지 않는다. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill_p[index] == 2)		// 접혀있으면 펴준다.
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;; Height만 사용
			nScrollHeight_p = nScrollHeight_p + nWndHeight + BETWEEN_NAME_ITEM;	// 사이즈가 변했기 때문에 스크롤 높이를 조절해준다. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill_p[index] = 1;
			m_wnd_p[index].ShowWindow();
			
			// 다음 윈도우의 앵커를 수정해준다. 
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1; i<Skill_GROUP_COUNT_P ; i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// 다음 윈도우가 접혔는지 펼쳐져 있는지는 신경쓰지 않는다. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll_p.SetScrollHeight(nScrollHeight_p);
	}
	
	else if ( strID == "ResearchButton" ) //스킬 인챈트 버튼 클릭
	{
		

		script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

		if (Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
			script_a.HideAgathion();
			script_a.SkillInfoClear();
			RequestSkillList();
			//debug("CanEnchant"$iCnaEnchant);

			//script_a.txtMySp.SetText(MakeCostString( string(0) ));
			
		}
		else 
		{
			Drawer.ShowWindow();
			script_a.SkillInfoClear();
			script_a.txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
			RequestSkillList();
			//debug("CanEnchant"$iCnaEnchant);

		}
	}
}



function HandleLanguageChanged()
{
	RequestSkillList();
}

function HandleSkillListStart()
{
	Clear();
}

function Clear()
{
	local int i;
	
	// 스킬 플레그 초기화
	for(i =0; i<Skill_GROUP_COUNT ; i++)
	{
		m_bExistSkill[ i ] = 0;
		m_NameBtn[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd[i].HideWindow();
		m_wndName[i].HideWindow();
		m_Item[i].Clear();
	}
	
	for(i =0; i<Skill_GROUP_COUNT_P ; i++)
	{
		m_bExistSkill_p[ i ] = 0;
		m_NameBtn_p[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd_p[i].HideWindow();
		m_wndName_p[i].HideWindow();
		m_Item_p[i].Clear();
	}
}

function HandleSkillList(string param)
{
	local int Tmp;
	local ESkillCategory Type;
	local int SkillLevel;
	local int Lock;
	local string strIconName;
	local string strSkillName;
	local string strDescription;
	local string strEnchantName;
	local string strCommand;
	local string strIconPanel;
	local int iCanEnchant;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "Lock", Lock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "EnchantName", strEnchantName);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "CanEnchant", iCanEnchant);
	
	//debug(" Type : " $ Tmp $ "SkillLevel : " $ SkillLevel $ " strSkillName : " $ strSkillName $ " Command : " $ strCommand);
	
	//debug("CanEnchant"$iCanEnchant);

	infItem.Level = SkillLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_SKILL);
	infItem.MacroCommand = strCommand;
	
	
	if (Lock>0)
	{
		infItem.bIsLock = true;
	}
	else
	{
		infItem.bIsLock = false;
	}

	infItem.Reserved = iCanEnchant;
	if(Drawer.IsShowWindow())
	{
			if (iCanEnchant>0)
			{
				infItem.bDisabled = false;

			}else
			{
				infItem.bDisabled = true;
			}
	}else
	{
				infItem.bDisabled = false;
	}
	


	//ItemWnd에 추가
	Type = ESkillCategory(Tmp);
	
	GroupingSkill(infItem.ID.ClassID , SkillLevel, infItem);

	
}

function ComputeItemWndHeight()
{	
	local int i;			// for문을 돌리기 위한 변수
	local int nItemNum;	// 해당 아이템 윈도우에 들어있는 스킬의 갯수
	local int nItemWndHeight;	// 아이템윈도우의 높이
	local int nWndWidth;	
	
	//---------------- 액티브 스킬의 높이 계산
	nScrollHeight = 0;
	for (i=0 ; i<Skill_GROUP_COUNT ; i++)
	{
		nItemNum = m_Item[i].GetItemNum();
		
		if(nItemNum <1)	// 스킬이 없으면
		{
			m_bExistSkill[i] = 0; //창을 보여주지 않는다. 초기화때 해주지만 그래도 혹시 모르니깐!
			m_wnd[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{
			m_bExistSkill[i] = 1; // 펼쳐짐. 접기는 클릭이벤트에서
			
			nItemWndHeight = ((nItemNum - 1) / 6 + 1) * 32 + ((nItemNum - 1) / 6) * 4 + 12;	// 위아래 갭 + 그룹박스 여백을 합치면 12!!
			m_wnd[i].SetWindowSize( SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg[i].SetWindowSize( SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item[i].SetRow((nItemNum - 1) / 6 + 2);	//??
			
			// 창이 안떠있으면 띄워준다. 
			if( !m_wnd[i].IsShowWindow()) m_wnd[i].ShowWindow();
			if( !m_wndName[i] .IsShowWindow()) m_wndName[i].ShowWindow();
			
			nScrollHeight = nScrollHeight + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// 누적시킨다
			//debug("!!!!SKill !! Height " $"   " $i $"    " $nScrollHeight $"  " $nItemWndHeight);
		}
	}
	//debug("!!!Skill!!! Height 재조정" $ nScrollHeight);
	if (areaScroll.IsShowWindow())
	areaScroll.SetScrollHeight(nScrollHeight);
	//debug("!!!Skill!!! Height Refresh");
	if (!areaScroll.IsShowWindow())
		areaScroll.SetScrollPosition( 0 );
	
	// ---------------패시브 스킬의 높이 계산
	
	nScrollHeight_p = 0;
	for (i=0 ; i<Skill_GROUP_COUNT_P ; i++)
	{
		nItemNum = m_Item_p[i].GetItemNum();
		
		if(nItemNum <1)	// 스킬이 없으면
		{
			m_bExistSkill_p[i] = 0; //창을 보여주지 않는다. 초기화때 해주지만 그래도 혹시 모르니깐!
			m_wnd_p[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd_p[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{
			m_bExistSkill_p[i] = 1; // 펼쳐짐. 접기는 클릭이벤트에서
			
			nItemWndHeight = ((nItemNum - 1) / 6 + 1) * 32 + ((nItemNum - 1) / 6) * 4 + 12;	// 위아래 갭 + 그룹박스 여백을 합치면 12!!
			m_wnd_p[i].SetWindowSize( SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg_p[i].SetWindowSize( SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item_p[i].SetRow((nItemNum - 1) / 6 + 2);	//??
			
			// 창이 안떠있으면 띄워준다. 
			if( !m_wnd_p[i].IsShowWindow()) m_wnd_p[i].ShowWindow();
			if( !m_wndName_p[i] .IsShowWindow()) m_wndName_p[i].ShowWindow();
			
			nScrollHeight_p = nScrollHeight_p + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// 누적시킨다
			//debug("!!!!SKill2 !! Height " $"   " $i $"    " $nScrollHeight_p $"  " $nItemWndHeight);
		}
	}
	
	//debug("!!!Skill2!!! Height 재조정" $ nScrollHeight_p);
	if (areaScroll_p.IsShowWindow())
	areaScroll_p.SetScrollHeight(nScrollHeight_p);
	//debug("!!!Skill2!!! Height Refresh" );
	if (!areaScroll_p.IsShowWindow())
		areaScroll_p.SetScrollPosition( 0 );
}

function ComputeItemWndAnchor()
{	
	local int i, j;			// for문을 돌리기 위한 변수
	local int nWndWidth, nWndHeight;	// 윈도우 사이즈 받기 변수
	
	//------------- 액티브의 앵커 잡아주기
	//첫번째 창이 닫혀있을 경우
	if(m_bExistSkill[0] == 0) 
	{
		for (i = 1 ; i < Skill_GROUP_COUNT ; i++)
		{
			// 활성화 중인 첫번째 창을 붙여준다. 
			if(m_bExistSkill[i] > 0)
			{
				m_wndName[i].SetAnchor(m_WindowName $ ".ASkillScroll", "TopLeft", "TopLeft", 5, 4);	// 스크롤이 먹통되는 현상의 원인
				m_wndName[i].ClearAnchor();
				break;
			}		
		}
	}
	
	// 0번째는 잡아주지 않아도 된다. 
	for (i = 0 ; i < Skill_GROUP_COUNT ; i++)
	{
		// 활성화 중일때만 앵커
		if(m_bExistSkill[i] > 0)
		{
			for(j=i+1 ; j<Skill_GROUP_COUNT; j++)
			{
				if(m_bExistSkill[j] > 0)	// 다음 활성화된 창을 검색 후 붙여준다.
				{
					if( m_bExistSkill[i] == 1)	// 아이템 윈도우가 열려있을 경우
					{
						m_wnd[i].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;;
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if( m_bExistSkill[i] == 2)	// 아이템 윈도우가 접혀있을 경우
					{	
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
	
	//------------- 패시브의 앵커 잡아주기
	//첫번째 창이 닫혀있을 경우
	if(m_bExistSkill_p[0] == 0) 
	{
		for (i = 1 ; i < Skill_GROUP_COUNT_P ; i++)
		{
			// 활성화 중인 첫번째 창을 붙여준다. 
			if(m_bExistSkill_p[i] > 0)
			{
				m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkillScroll", "TopLeft", "TopLeft", 5, 4);	// 스크롤이 먹통되는 현상의 원인
				m_wndName_p[i].ClearAnchor();
				break;
			}		
		}
	}
	
	// 0번째는 잡아주지 않아도 된다. 
	for (i = 0 ; i < Skill_GROUP_COUNT_P ; i++)
	{
		// 활성화 중일때만 앵커
		if(m_bExistSkill_p[i] > 0)
		{
			for(j=i+1 ; j<Skill_GROUP_COUNT_P; j++)
			{
				if(m_bExistSkill_p[j] > 0)	// 다음 활성화된 창을 검색 후 붙여준다.
				{
					if( m_bExistSkill_p[i] == 1)	// 아이템 윈도우가 열려있을 경우
					{
						m_wnd_p[i].GetWindowSize(nWndWidth, nWndHeight);	// width는 버린다 -_-;;
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if( m_bExistSkill_p[i] == 2)	// 아이템 윈도우가 접혀있을 경우
					{	
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
}

// ID를 가지고 정보를 구해 해당 스킬의 구분을 확정짓는다.
function GroupingSkill( int  SkillID , int SkillLevel, ItemInfo infItem )
{	
	local SkillInfo info;
	
	// ID를 가지고 스킬의 정보를 얻어온다. 없으면 패배
	if( !GetSkillInfo( SkillID, SkillLevel , info ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}
	
	switch ( info.IconType )
	{
		//------------------ 액티브
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			m_Item[info.IconType].AddItem(infItem);
			break;
		
		//------------------ 패시브
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		case 16:
			m_Item_p[info.IconType-11].AddItem(infItem);
			break;
		default:
			break;
	}
}


//영웅 스킬 검사
function bool IsHeroSkillID(int SkillID)
{
	switch(SkillID)
	{
		case 395:
		case 396:
		case 1374:
		case 1375:
		case 1376:
			return true;
		
		default:
			return false;
	}
}

// 아이템 스킬 검사
function bool IsItemSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}

//변신 스킬 검사
function bool IsChangeSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}


function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local MagicSkillDrawerWnd script_a;
	local string dragsrcName;
	
	
	
	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

	dragsrcName = Left(a_ItemInfo.DragSrcName,10);
	//RequestSkillList();

	
	//debug("CanEnchant");
	switch (a_WindowID)
	{		
		case "ResearchButton":

		if (dragsrcName== "PSkillItem" || dragsrcName == "ASkillItem")
		{

				RequestSkillList();
					if ( a_ItemInfo.Reserved == 0)
					{
						script_a.SkillInfoClear();
						script_a.SetAdenaSpInfo();
						script_a.ResearchGuideDesc.SetText(GetSystemString(2041));
						script_a.AddSystemMessage(3070);//바꿔야 함
						
					} else
					{
						RequestExEnchantSkillInfo(a_ItemInfo.ID.ClassID, a_ItemInfo.Level); 
						script_a.SetCurSkillInfo(a_ItemInfo);
						script_a.txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
					}


		}
	
		break;

	}
}

//SP 수치를 표현한다.
function int GetuserSP()
{

	local UserInfo infoPlayer;
	local int iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP=infoPlayer.nSP;

	return iPlayerSP;
}
defaultproperties
{
    m_WindowName="MagicSkillWnd"
}
