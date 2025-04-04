class BR_BuyingWnd extends UICommonAPI;

const FEE_OFFSET_Y_EQUIP = -18;

const DIALOG_RESULT_SUCCESS		= 301;
const DIALOG_RESULT_FAILURE		= 302;

var bool m_bDrawBg;
var int m_iRootNameLength;
var bool m_bInConfirm;

// current product
var int 	m_iProductID;
var int		m_iPrice;
var int		m_iAmount;
var string	m_strName;
var string 	m_strIconName;
var INT64 m_iGamePoint;

var WindowHandle Me;
var TextBoxHandle TextCurCash;
var TextBoxHandle TextBalance;
var TextBoxHandle TextPrice;
var TreeHandle TreeItemList;
var ButtonHandle BtnCancel;
var ButtonHandle BtnBuy;
var ButtonHandle BtnCharge;
var TextureHandle TexPriceInfoBG;
var TextureHandle TexItemInfoBG;

function OnLoad()
{
	if (CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_bInConfirm = false;
		
	InitHandle();
}

function InitHandle()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_BuyingWnd" );
		TextCurCash = TextBoxHandle ( GetHandle( "BR_BuyingWnd.TextCurCash" ) );
		TextBalance = TextBoxHandle ( GetHandle( "BR_BuyingWnd.TextBalance" ) );
		TextPrice = TextBoxHandle ( GetHandle( "BR_BuyingWnd.TextPrice" ) );
		TreeItemList = TreeHandle ( GetHandle( "BR_BuyingWnd.TreeItemList" ) );
		BtnCancel = ButtonHandle ( GetHandle( "BR_BuyingWnd.BtnCancel" ) );
		BtnBuy = ButtonHandle ( GetHandle( "BR_BuyingWnd.BtnBuy" ) );
		BtnCharge = ButtonHandle ( GetHandle( "BR_BuyingWnd.BtnCharge" ) );
		TexPriceInfoBG = TextureHandle ( GetHandle( "BR_BuyingWnd.TexPriceInfoBG" ) );
		TexItemInfoBG = TextureHandle ( GetHandle( "BR_BuyingWnd.TexItemInfoBG" ) );
	}
	else {
		Me = GetWindowHandle( "BR_BuyingWnd" );
		TextCurCash = GetTextBoxHandle ( "BR_BuyingWnd.TextCurCash" );
		TextBalance = GetTextBoxHandle ( "BR_BuyingWnd.TextBalance" );
		TextPrice = GetTextBoxHandle ( "BR_BuyingWnd.TextPrice" );
		TreeItemList = GetTreeHandle ( "BR_BuyingWnd.TreeItemList" );
		BtnCancel = GetButtonHandle ( "BR_BuyingWnd.BtnCancel" );
		BtnBuy = GetButtonHandle ( "BR_BuyingWnd.BtnBuy" );
		BtnCharge = GetButtonHandle ( "BR_BuyingWnd.BtnCharge" );
		TexPriceInfoBG = GetTextureHandle ( "BR_BuyingWnd.TexPriceInfoBG" );
		TexItemInfoBG = GetTextureHandle ( "BR_BuyingWnd.TexItemInfoBG" );
	}
}

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_SHOW_CONFIRM );
	RegisterEvent( EV_BR_HIDE_CONFIRM );
	RegisterEvent( EV_BR_SETGAMEPOINT );
	RegisterEvent( EV_BR_RESULT_BUY_PRODUCT );
	RegisterEvent( EV_DialogOK );
}

function OnClickButton( string Name )
{
	if (m_bInConfirm)
		return;
		
	switch( Name )
	{
	case "BtnCancel":
		OnBtnCancelClick();
		break;
	case "BtnBuy":
		OnBtnBuyClick();
		break;
	case "BtnCharge":
		OnBtnChargeClick();
		break;
	}
}

function OnEvent(int Event_ID, string param)
{
	local int iResult;

	switch( Event_ID )
	{
	case EV_BR_SETGAMEPOINT :
		ParseInt64(param, "GamePoint", m_iGamePoint);
		if (m_bInConfirm==false)
			CalculateBalance();
		break;
	case EV_BR_RESULT_BUY_PRODUCT :
		ParseInt(param, "Result", iResult );
		//ParseInt64(param, "GamePoint", m_iGamePoint);
		ResultBuy(iResult, m_iGamePoint);
		//RequestBR_GamePoint();
		break;
	case EV_BR_SHOW_CONFIRM :
		debug("EV_BR_SHOW_CONFIRM : " $ param);
		ParseInt(param, "ID", m_iProductID);
		ParseInt(param, "Price", m_iPrice);
		ParseString(param, "ItemName", m_strName);
		ParseString(param, "IconName", m_strIconName);
		ParseInt(param, "Amount", m_iAmount);

		ShowBuyWindow(true);
		m_bInConfirm = false;
		InitProductList();
		AddProductList(m_iProductID, m_iAmount, m_iPrice, m_strName, m_strIconName);
		break;
	case EV_DialogOK:
		if( DialogIsMine() == false)
			return;
		ShowBuyWindow(false);
		m_bInConfirm = false;
		break;
	case EV_DialogCancel:
		m_bInConfirm = false;
		break;
	}
}

function OnHide()
{
	DialogHide();

	ExecuteEvent(EV_BR_HIDE_CONFIRM);
	PlaySound("InterfaceSound.inventory_close_01");
	
	m_bInConfirm = false;
}

function OnShow()
{
	CalculateBalance();
}

function OnBtnCancelClick()
{
	ShowBuyWindow(false);
	m_bInConfirm = false;
	InitProductList();
}

function OnBtnBuyClick()
{
	if (m_iProductID > 0 && m_iAmount > 0) {
		m_bInConfirm = true;
		RequestBR_BuyProduct(m_iProductID, m_iAmount);
	}
}

function OnBtnChargeClick()
{
	ShowCashChargeWebSite();
	RequestBR_GamePoint();
}

function CalculateBalance()
{
	local INT64 iTotalPrice;
	local INT64 iBalance;
	
	iTotalPrice = IntToInt64(m_iPrice) * IntToInt64(m_iAmount);
	TextPrice.SetText("" $ Int64ToString(iTotalPrice) $ " " $ GetSystemString(5012));
	
	TextCurCash.SetText("" $ Int64ToString(m_iGamePoint) $ " " $ GetSystemString(5012));

	iBalance = m_iGamePoint - iTotalPrice;
	TextBalance.SetText("" $ Int64ToString(iBalance) $ " " $ GetSystemString(5012));
}

function ResultBuy(int iResult, INT64 iGamePoint)
{
	//debug( "Buying Result [" $ iResult $ "] - " $ string(iGamePoint) );
	
	switch (iResult)
	{
	case 1 :			// BR_BUY_SUCCESS
		m_iGamePoint = iGamePoint;
		CalculateBalance();
		DialogSetID( DIALOG_RESULT_SUCCESS );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6001) );
		break;
	case -7 :			// BR_BUY_BEFORE_SALE_DATE
	case -8 :			// BR_BUY_AFTER_SALE_DATE
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6003) );
		break;
	case -1 :			// BR_BUY_LACK_OF_POINT
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6005) );
		break;
	case -2 :			// BR_BUY_INVALID_PRODUCT
	case -5 :			// BR_BUY_CLOSED_PRODUCT
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6008) );
		break;
	case -4 :			// BR_BUY_INVENTROY_OVERFLOW
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6006) );
		break;
	case -9 :			// BR_BUY_INVALID_USER
	case -11 :			// BR_BUY_INVALID_USER_STATE
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6007) );
		break;
	case -10 :			// BR_BUY_INVALID_ITEM
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6009) );
		break;
	case -12 :		//BR_BUY_NOT_DAY_OF_WEEK
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6019) );
	case -13 :		//BR_BUY_NOT_TIME_OF_DAY
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6020) );
	case -14 :		//BR_BUY_SOLD_OUT
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(350) );
		break;
	case -3 :			// BR_BUY_USER_CANCEL
	case -6 :			// BR_BUY_SERVER_ERROR
	default:
		DialogSetID( DIALOG_RESULT_FAILURE );
		DialogSetDefaultOK();
		DialogShow( DIALOG_Modal, DIALOG_OK, GetSystemMessage(6002) $ " errorcode:" $ iResult );
		break;
	}

	// 인자를 넣을땐,
	//DialogShow( DIALOG_Modal, DIALOG_WARNING, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) )) );
}

function ShowBuyWindow(bool bShow)
{
	m_bDrawBg = true;
	
	debug("Show Confirm " $ bShow);
	if ( bShow == true )
	{
		Me.ShowWindow();
		Me.SetFocus();
		RequestBR_GamePoint();
		PlaySound("InterfaceSound.inventory_open_01");
	}
	else 
	{
		Me.HideWindow();
	}
}

function InitProductList()
{
	local XMLTreeNodeInfo	infNode;
	local string strTmp;

	class'UIAPI_TREECTRL'.static.Clear("BR_BuyingWnd.TreeItemList");

	m_iRootNameLength = 0;
	
	//트리에 Root추가
	infNode.strName = "ProductListRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = -3;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("BR_BuyingWnd.TreeItemList", "", infNode);
	if (Len(strTmp) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	m_iRootNameLength=Len(infNOde.strName);
}

function AddProductList(int iId, int iAmount, int price, string itemname, string iconname)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;
	local string strAdenaComma;

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with No Button
	infNode = infNodeClear;
	infNode.strName = "" $ iId;
	infNode.bShowButton = 0;
	
	//Expand되었을때의 BackTexture설정
	//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
	infNode.nTexExpandedOffSetX = 0;		//OffSet
	infNode.nTexExpandedOffSetY = 0;		//OffSet
	infNode.nTexExpandedHeight = 40;		//Height
	infNode.nTexExpandedRightWidth = 0;		//오른쪽 그라데이션부분의 길이
	infNode.nTexExpandedLeftUWidth = 32; 		//스트레치로 그릴 왼쪽 텍스쳐의 UV크기
	infNode.nTexExpandedLeftUHeight = 40;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	infNode.tooltip = MakeTooltipSimpleText(itemname $ " X " $ iAmount);
	
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("BR_BuyingWnd.TreeItemList", "ProductListRoot", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	debug("Node Add : " $ infNode.strName);
	
	
	if (m_bDrawBg == true)
	{
		//Insert Node Item - 아이템 배경?

		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureUHeight = 14;
		infNodeItem.u_nTextureWidth = 275;
		infNodeItem.u_nTextureHeight = 40;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		//Insert Node Item - 아이템 배경?

		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 275;
		infNodeItem.u_nTextureHeight = 40;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);
		m_bDrawBg = true;	
	}
		
	
	//Insert Node Item - 아이템슬롯 배경
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -270;
	infNodeItem.nOffSetY = 2;
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;

	infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);

	//Insert Node Item - 아이템 아이콘
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -34;
	infNodeItem.nOffSetY = 4;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = iconname;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);

	//Insert Node Item - 아이템 이름
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = itemname;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 10;
	infNodeItem.nOffSetY = 6;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);


	//Insert Node Item - "가격"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(190) $ " : ";
	infNodeItem.bLineBreak = true;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 50;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;

	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);

	//아데나(,)
	strAdenaComma = MakeCostString("" $ price);
	
	//Insert Node Item - "제작비(아데나)"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strAdenaComma;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	infNodeItem.t_color = GetNumericColor(strAdenaComma);
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);

	//Insert Node Item - "포인트"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(5012);
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	infNodeItem.t_color.R = 255;
	infNodeItem.t_color.G = 255;
	infNodeItem.t_color.B = 0;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);

	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = " X " $ iAmount;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("BR_BuyingWnd.TreeItemList", strRetName, infNodeItem);
}
defaultproperties
{
}
