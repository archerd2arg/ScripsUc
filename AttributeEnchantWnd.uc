class AttributeEnchantWnd extends UICommonAPI;

//Handle List
var WindowHandle		Me;
var ItemWindowHandle	ItemWnd;
var TextBoxHandle	TextBox;
var ButtonHandle		OkButton;

// ���� ���
var ItemInfo 		SelectItemInfo;		// ������ ������
var int 			ScrollCID;			// ��ũ���� ������ �����Ѵ�. 

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
		// �Ӽ� ���� â�� ���������� �Ӽ� ��þƮ�� ���ϰ� ���´�.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd") )	
		{	
			// �� �Ӽ� ��þƮ�� â�� �������� �ȳ�
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

//�׼��� Ŭ��
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
	
	// ������ �������� ������ �޾ƿ´�. 
	ItemWnd.GetSelectedItem(SelectItemInfo);	
	
	if(SelectItemInfo.ID.ClassID != 0)	// ���õ� �������� ���� ��츸 ����
	{
		if(IsShowWindow("ItemEnchantWnd"))	//������ ��þƮ�� ���� ���ִٸ� ��æƮ�� �����Ű�� �ʴ´�. 
		{
			AddSystemMessage(2188);
		}
		// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
// };
		else if(SelectItemInfo.Reserved != 0) //��æ�Ҽ� ���� �������̶��
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
			// ���α׷��� �ٸ� ����ش�. 
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

	m_WarehouseWnd = GetWindowHandle( "WarehouseWnd" );	//â���� ������ �ڵ��� ���´�.
	m_DeliverWnd = GetWindowHandle( "DeliverWnd" );

	if ( m_WarehouseWnd.IsShowWindow() || m_DeliverWnd.IsShowWindow() )			//â�� ���½� Ȱ��ȭ ���Ѵ�.
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
	
		// ���ſ��� �ֹ��� ������ ������ Ÿ��Ʋ�� ǥ���� �־�����, �����δ� ������ ���ο� ǥ�����ֵ��� �Ѵ�. 
		//Me.SetWindowTitle(GetSystemString(1220) $ "(" $ class'UIDATA_ITEM'.static.GetItemName(cID) $ ")");
		ScrollCID = cID.ClassID;				// ��ũ�� ���̵� ����
		TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(cID));
		OkButton.DisableWindow();				// ó�� �ѷ��� ���� �������� �������� �ʾұ� ������ ������ Ȯ�� ��ư�� disable �����ش�. 
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

// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
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
	
	// item ������ �Ǵ��Ͽ� ��� ������ �����۸� insert �Ѵ�.  - ģ���� UI��å ^^ - innowind 
	// S�� �̻��� ����/ ���� �Ӽ� ��æƮ ����
	
	//ItemWnd.AddItem(infItem);	// �������� �˾Ƽ� �ɷ��ִ°� ������ �Ʒ� �ڵ�� �ʿ� ����.
	
	//S�� �̻��� �����۸� �߰�. S80�� ���� �ε�ȣ�� ����Ͽ���. 
	//���д� �����Ѵ�. ���е� itemType�� 1�� ������ ������ shieldDefense ������ ���.
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
	//����� ������� ������ Hide
	Me.HideWindow();
	Clear();
}
defaultproperties
{
}
