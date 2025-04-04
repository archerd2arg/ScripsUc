class AttributeEnchantWnd extends UICommonAPI;

//Handle List
var WindowHandle		Me;
var ItemWindowHandle	ItemWnd;
var TextBoxHandle	TextBox;
var ButtonHandle		OkButton;

// 변수 목록
var ItemInfo 		SelectItemInfo;		// 선택한 아이템
var int 			ScrollCID;			// 스크롤의 종류를 저장한다. 

function OnRegisterEvent()
{
	RegisterEvent( EV_AttributeEnchantItemShow );
	RegisterEvent( EV_EnchantHide );
	RegisterEvent( EV_AttributeEnchantItemList );
	RegisterEvent( EV_AttributeEnchantResult );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	// IsShowWindow


	//Init Handle
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AttributeEnchantWnd" );
		ItemWnd = ItemWindowHandle( GetHandle( "AttributeEnchantWnd.ItemWnd" ) );
		TextBox = TextBoxHandle( GetHandle( "AttributeEnchantWnd.txtScrollName" ) );
		OkButton = ButtonHandle( GetHandle( "AttributeEnchantWnd.btnOK" ) );	
	}
	else
	{
		Me = GetWindowHandle( "AttributeEnchantWnd" );
		ItemWnd = GetItemWindowHandle( "AttributeEnchantWnd.ItemWnd" );
		TextBox = GetTextBoxHandle( "AttributeEnchantWnd.txtScrollName" );
		OkButton = GetButtonHandle( "AttributeEnchantWnd.btnOK" );	
	}
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_AttributeEnchantItemShow)
	{
		// 속성 해제 창이 열렸을때는 속성 인첸트를 못하게 막는다.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd") )	
		{	
			// 왜 속성 인첸트를 창을 못여는지 안내
			AddSystemMessage(3161);	
			OnCancelClick();
		}
		else
		{
			HandleAttributeEnchantShow(param);	
		}
	}
	else if (Event_ID == EV_EnchantHide)
	{
		HandleAttributeEnchantHide();
	}
	else if (Event_ID == EV_AttributeEnchantItemList)
	{
		HandleAttributeEnchantItemList(param);
	}
	else if (Event_ID == EV_AttributeEnchantResult)
	{
		HandleAttributeEnchantResult(param);
	}
}

//액션의 클릭
function OnClickItem( string strID, int index )
{	
	if (strID == "ItemWnd")
	{		
		OkButton.EnableWindow();
	}
}

function OnClickButton( string strID )
{
	//debug("strID : " $ strID);
	switch( strID )
	{
	case "btnOK":
		OnOkClickProgress();
		break;
	case "btnCancel":
		OnCancelClick();
		break;
	}
}


function OnOkClickProgress()
{	
	local ProgressBox script;
	
	// 선택한 아이템의 정보를 받아온다. 
	ItemWnd.GetSelectedItem(SelectItemInfo);	
	
	if(SelectItemInfo.ID.ClassID != 0)	// 선택된 아이템이 있을 경우만 진행
	{
		if(IsShowWindow("ItemEnchantWnd"))	//아이템 인첸트가 먼저 떠있다면 인챈트를 진행시키지 않는다. 
		{
			AddSystemMessage(2188);
		}
		// 밑의 이유 c++ 코드부분
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3속성이 다찼다
// };
		else if(SelectItemInfo.Reserved != 0) //인챈할수 없는 아이템이라면
		{
			if(SelectItemInfo.Reserved == 1)
				AddSystemMessage(3117);			
			if(SelectItemInfo.Reserved == 2)
				AddSystemMessage(3154);			
			if(SelectItemInfo.Reserved == 4)
				AddSystemMessage(3153);			
			if(SelectItemInfo.Reserved == 6)
				AddSystemMessage(3155);			
		}
		else
		{
			// 프로그레스 바를 띄워준다. 
			Me.HideWindow();
			script = ProgressBox( GetScript("ProgressBox") );	
			script.Initialize();
			script.ShowDialog(GetSystemString(1530), "AttributeEnchantWnd", 2000);	
		}
	}
}

function OnOKClick()
{
	class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);
}

function OnCancelClick()
{
	local ItemID ID;
	
	ID = GetItemID(-1);
	//debug("request attribute cancle");
	class'EnchantAPI'.static.RequestEnchantItemAttribute(ID);
	Me.HideWindow();
	Clear();
}

function Clear()
{
	ItemWnd.Clear();
}

function HandleAttributeEnchantShow(string param)
{
	local ItemID cID;
	//branch
	local WindowHandle m_WarehouseWnd;
	local WindowHandle m_DeliverWnd;

	m_WarehouseWnd = GetWindowHandle( "WarehouseWnd" );	//창고의 윈도우 핸들을 얻어온다.
	m_DeliverWnd = GetWindowHandle( "DeliverWnd" );

	if ( m_WarehouseWnd.IsShowWindow() || m_DeliverWnd.IsShowWindow() )			//창고 오픈시 활성화 안한다.
	{
		cID = GetItemID(-1);
		class'EnchantAPI'.static.RequestEnchantItemAttribute(cID);
		Clear();
	} 
	else
	{
	//end of branch
	
		Clear();
		ParseItemID(param, cID);
	 
		//debug("show doing ");
	
		// 과거에는 주문서 종류를 윈도우 타이틀에 표현해 주었으나, 앞으로는 윈도우 내부에 표시해주도록 한다. 
		//Me.SetWindowTitle(GetSystemString(1220) $ "(" $ class'UIDATA_ITEM'.static.GetItemName(cID) $ ")");
		ScrollCID = cID.ClassID;				// 스크롤 아이디 저장
		TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(cID));
		OkButton.DisableWindow();				// 처음 뿌려줄 때는 아이템을 선택하지 않았기 때문에 무조건 확인 버튼을 disable 시켜준다. 
		Me.ShowWindow();
		Me.SetFocus();

	//branch
	}
	//end of branch	
}

function HandleAttributeEnchantHide()
{
	Me.HideWindow();
	Clear();
}

// 밑의 이유 c++ 코드부분
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3속성이 다찼다
// };

function HandleAttributeEnchantItemList(string param)
{
	local ItemInfo infItem;
	local int Ispossible;
	ParseInt(param, "Ispossible", Ispossible);
	ParamToItemInfo(param, infItem);
	infItem.Reserved = Ispossible;
	debug(string(Ispossible));
	//debug("Name :" $ infItem.Name $ " SlotBitType: "  $ infItem.SlotBitType $ " ShieldDefense : " $ infItem.ShieldDefense $ " CrystalType :"  $infItem.CrystalType);
	
	// item 정보로 판단하여 사용 가능한 아이템만 insert 한다.  - 친절한 UI정책 ^^ - innowind 
	// S급 이상의 무기/ 방어구만 속성 인챈트 가능
	
	//ItemWnd.AddItem(infItem);	// 서버에서 알아서 걸러주는것 같으니 아래 코드는 필요 없다.
	
	//S급 이상의 아이템만 추가. S80을 위해 부등호를 사용하였다. 
	//방패는 제외한다. 방패도 itemType이 1로 들어오기 때문에 shieldDefense 변수를 사용.
	if((infItem.CrystalType > 4) && (infItem.ShieldDefense == 0) && (infItem.SlotBitType != 268435456) && (infItem.ArmorType != 4) && (infItem.SlotBitType != 1))
	{
		if(Ispossible == 0) //ATTR_ENCHAN_POSSIBLE
			ItemWnd.AddItem(infItem);
		else
			ItemWnd.AddItemWithFaded(infItem);
	}
}



function HandleAttributeEnchantResult(string param)
{
	//debug("Result param : " $ param);
	//결과에 상관없이 무조건 Hide
	Me.HideWindow();
	Clear();
}
defaultproperties
{
}
