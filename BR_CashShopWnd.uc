class BR_CashShopWnd extends UICommonAPI;

const DIALOG_PRODUCT_QUANTITY		= 351;
const DIALOG_CLOSED_SHOP			= 352;

const MAX_BUY_COUNT		= 99;
const FEE_OFFSET_Y_EQUIP = -18;
const ITEM_INFO_WIDTH = 256;
const ITEM_INFO_LEFT_MARGIN = 10;
const ITEM_INFO_BLANK_HEIGHT = 10;

const TAB_MASK = 0;
const TAB_CATEGORY = 1;
const TAB_RECENT = 2;

var array<int> m_arrTabType;
var array<int> m_arrTabIndex;

var int m_iCurrentHeight;
var DrawItemInfo m_kDrawInfoClear;

struct ProductInfo
{
	var int 	iProductID;
	var int 	iCategory;
	var int		iShowTab;
	var int		iPrice;
	var string	strName;
	var string 	strIconName;
	var int		iDayWeek;
	var int		iStartSale;
	var int		iEndSale;
	var int		iStartHour;
	var int		iStartMin;
	var int		iEndHour;
	var int		iEndMin;
	var int		iStock;
	var int		iMaxStock;
	var bool	bLimited;
	var bool	bEnable;
};
var array< ProductInfo >	m_ProductList;
var array< ProductInfo >	m_RecentList;

var int		m_nSelectedProduct;
var int 	m_iRootNameLength;
var bool 	m_bDrawBg;
var int		m_iCurrentTab;
var bool	m_bInConfirm;
var bool	m_bSortDesc;

enum EPrItemSortType
{
	PR_ITEM_INDEX,
	PR_ITEM_PRICE,
	PR_ITEM_NAME,	
};

var DrawPanelHandle m_hDrawPanel;

var WindowHandle Me;
var EditBoxHandle EditBuyCount;
var EditBoxHandle EditItemSearch;
var ButtonHandle BtnItemSearch;
var ButtonHandle BtnItemIndexSort;
var ButtonHandle BtnItemPointSort;
var ButtonHandle BtnItemNameSort;
var ButtonHandle BtnBuy;
var ButtonHandle BtnCancel;
var ButtonHandle BtnInputQuantity;
var TreeHandle TreeItemList;
var TabHandle TabCategory;
var TextBoxHandle TextTotalPrice;
var ButtonHandle BtnCashCharge;
var TextBoxHandle TextCurrentCash;
var TextureHandle TexCategoryUpper;
var TextureHandle TexBackItemList;
var TextureHandle ItemInfoBg;
var TextureHandle TexBgCategory;
var WindowHandle ScrollItemInfo;
var WindowHandle WndItemInfo;
var WindowHandle Drawer; // by sr

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_CashShopToggleWindow );
	RegisterEvent( EV_BR_CashShopAddItem );
	RegisterEvent( EV_BR_SetNewProductInfo );
	RegisterEvent( EV_BR_AddEachProductInfo );
	RegisterEvent( EV_BR_SETGAMEPOINT );
	RegisterEvent( EV_BR_SHOW_CONFIRM );
	RegisterEvent( EV_BR_HIDE_CONFIRM );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_BR_SetNewList );
	RegisterEvent( EV_BR_SetRecentProduct );
}

function OnLoad()
{
	if (CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	Initialize();
	InitHandle();
}

function InitHandle()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_CashShopWnd" );
		EditBuyCount = EditBoxHandle ( GetHandle( "BR_CashShopWnd.EditBuyCount" ) );
		//
		EditItemSearch = EditBoxHandle ( GetHandle( "BR_CashShopWnd.EditItemSearch" ) );
		BtnItemSearch = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnItemSearch" ) );
		BtnItemIndexSort = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnItemIndexSort" ) );
		BtnItemPointSort = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnItemPointSort" ) );
		BtnItemNameSort = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnItemNameSort" ) );
		//
		BtnBuy = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnBuy" ) );
		BtnCancel = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnCancel" ) );
		BtnInputQuantity = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnInputQuantity" ) );
		TreeItemList = TreeHandle ( GetHandle( "BR_CashShopWnd.TreeItemList" ) );
		TabCategory = TabHandle ( GetHandle( "BR_CashShopWnd.TabCategory" ) );
		TextTotalPrice = TextBoxHandle ( GetHandle( "BR_CashShopWnd.TextTotalPrice" ) );
		BtnCashCharge = ButtonHandle ( GetHandle( "BR_CashShopWnd.BtnCashCharge" ) );
		TextCurrentCash = TextBoxHandle ( GetHandle( "BR_CashShopWnd.TextCurrentCash" ) );
		TexCategoryUpper = TextureHandle ( GetHandle( "BR_CashShopWnd.TexCategoryUpper" ) );
		TexBackItemList = TextureHandle ( GetHandle( "BR_CashShopWnd.TexBackItemList" ) );
		ItemInfoBg = TextureHandle ( GetHandle( "BR_CashShopWnd.ItemInfoBg" ) );
		TexBgCategory = TextureHandle ( GetHandle( "BR_CashShopWnd.TexBgCategory" ) );

		ScrollItemInfo = GetHandle("BR_CashShopWnd.ScrollItemInfo");
		WndItemInfo = GetHandle("BR_CashShopWnd.ScrollItemInfo.WndItemInfo");

		Drawer = GetHandle( "PopupWnd"); // br sr
	}
	else {
		Me = GetWindowHandle( "BR_CashShopWnd" );
		EditBuyCount = GetEditBoxHandle ( "BR_CashShopWnd.EditBuyCount" );
		//
		EditItemSearch = GetEditBoxHandle( "BR_CashShopWnd.EditItemSearch" );
		BtnItemSearch = GetButtonHandle( "BR_CashShopWnd.BtnItemSearch" );
		BtnItemIndexSort = GetButtonHandle( "BR_CashShopWnd.BtnItemIndexSort" );
		BtnItemPointSort = GetButtonHandle( "BR_CashShopWnd.BtnItemPointSort" );
		BtnItemNameSort = GetButtonHandle( "BR_CashShopWnd.BtnItemNameSort" );
		//
		BtnBuy = GetButtonHandle ( "BR_CashShopWnd.BtnBuy" );
		BtnCancel = GetButtonHandle ( "BR_CashShopWnd.BtnCancel" );
		BtnInputQuantity = GetButtonHandle ( "BR_CashShopWnd.BtnInputQuantity" );
		TreeItemList = GetTreeHandle ( "BR_CashShopWnd.TreeItemList" );
		TabCategory = GetTabHandle ( "BR_CashShopWnd.TabCategory" );
		TextTotalPrice = GetTextBoxHandle ( "BR_CashShopWnd.TextTotalPrice" );
		BtnCashCharge = GetButtonHandle ( "BR_CashShopWnd.BtnCashCharge" );
		TextCurrentCash = GetTextBoxHandle ( "BR_CashShopWnd.TextCurrentCash" );
		TexCategoryUpper = GetTextureHandle ( "BR_CashShopWnd.TexCategoryUpper" );
		TexBackItemList = GetTextureHandle ( "BR_CashShopWnd.TexBackItemList" );
		ItemInfoBg = GetTextureHandle ( "BR_CashShopWnd.ItemInfoBg" );
		TexBgCategory = GetTextureHandle ( "BR_CashShopWnd.TexBgCategory" );

		ScrollItemInfo = GetWindowHandle("BR_CashShopWnd.ScrollItemInfo");
		WndItemInfo = GetWindowHandle("BR_CashShopWnd.ScrollItemInfo.WndItemInfo");

		Drawer = GetWindowHandle( "PopupWnd"); // by sr	
	}
}

// by sr
function ClickPopupItemList( int ProductID )
{
	RequestBR_ProductInfo( ProductID ); // 클릭된 상품을 상품 설명란에 표시	
	OnTabCategory( 2 ); // 이벤트 상품 리스트 
	TabCategory.SetTopOrder( 2, false ); // 이벤트 탭으로
}
// by sr
	
function Initialize()
{
	m_iCurrentTab = 0;
	m_bInConfirm = false;
	m_bSortDesc = false;
	
	// 탭 정보
	m_arrTabType[1] = TAB_MASK;
	m_arrTabType[2] = TAB_MASK;
	m_arrTabType[3] = TAB_CATEGORY;
	m_arrTabType[4] = TAB_CATEGORY;
	m_arrTabType[5] = TAB_CATEGORY;
	m_arrTabType[6] = TAB_CATEGORY;
	m_arrTabType[7] = TAB_CATEGORY;
	m_arrTabType[8] = TAB_RECENT;
	m_arrTabIndex[1] = 2;		// 0x02 - 이벤트용
	m_arrTabIndex[2] = 1;		// 0x01 - 베스트
	m_arrTabIndex[3] = 1;		// 강화
	m_arrTabIndex[4] = 2;		// 소모품
	m_arrTabIndex[5] = 3;		// 꾸미기
	m_arrTabIndex[6] = 4;		// 패키지
	m_arrTabIndex[7] = 5;		// 기타
	m_arrTabIndex[8] = 0;
	
	ClearItemInfo();
}

function OnEvent(int Event_ID, string param)
{
	local int iId;

	local int price;
	local int weight;
	local int iAmount;
	local string itemname;
	local string iconname;
	local int trade;
	local string desc;
	local INT64 iGamePoint;
	local int iResult;

	switch( Event_ID )
	{
		
	case EV_BR_CashShopToggleWindow :
		HandleToggleWindow();
		break;
	case EV_BR_CashShopAddItem :
		AddProductItem(param);
		break;
	case EV_BR_SetNewProductInfo :
		ParseInt(param, "ID", iId);
		ParseInt(param, "Price", price);
		ParseString(param, "ItemName", itemname);
		ParseString(param, "Desc", desc);
		SetNewProductInfo(iID, price, itemname, desc);
		
		break;
	case EV_BR_AddEachProductInfo :
		ParseInt(param, "ID", iId );
		ParseInt(param, "Amount", iAmount );
		ParseString(param, "ItemName", itemname );
		ParseString(param, "IconName", iconname );
		ParseString(param, "Desc", desc );
		ParseInt(param, "Weight", weight );
		ParseInt(param, "Trade", trade );
	
		AddEachProductInfo(iId, iAmount, itemname, iconname, desc, weight, trade);
		break;
	case EV_BR_SetRecentProduct:
		HandleSetRecentProduct(param);
		break;
	case EV_BR_SETGAMEPOINT :
		ParseInt64(param, "GamePoint", iGamePoint);
		SetGamePoint(iGamePoint);
		break;
	case EV_BR_SHOW_CONFIRM :
		HandleToggleWindow();
		m_bInConfirm = true;
		break;
	case EV_BR_HIDE_CONFIRM :
		m_bInConfirm = false;
		ClearItemInfo();
		HandleToggleWindow();
		break;
	case EV_BR_SetNewList :
		ParseInt(param, "Option", iResult );
		if (iResult == 1) {		// new recent list
			PrepareRecentList();
		}
		else {
			PrepareProductList(iResult);
		}
		break;
	case EV_DialogOK:
		//debug("handle dialog ok");
		HandleDialogOK();
		break;
	}
}

function OnClickButton( string Name )
{
	local string strRootName;
	local string strProductID;
	
	switch( Name )
	{
	//
	case "BtnItemSearch":
		OnBtnItemSearchClick();
		break;
	case "BtnItemIndexSort":
		OnBtnItemSortClick(PR_ITEM_INDEX);
		break;
	case "BtnItemPointSort":
		OnBtnItemSortClick(PR_ITEM_PRICE);
		break;
	case "BtnItemNameSort":
		OnBtnItemSortClick(PR_ITEM_NAME);
		break;
		//
	case "BtnBuy":
		OnBtnBuyClick();
		break;		
	case "BtnCancel":
		OnBtnCancelClick();
		break;
	case "BtnCashCharge":
		OnBtnCashChargeClick();
		break;
	case "BtnInputQuantity":
		OnBtnInputQuantity();
		break;
	case "TabCategory0":	//탭이 클릭된 경우
	case "TabCategory1":
	case "TabCategory2":
	case "TabCategory3":
	case "TabCategory4":
	case "TabCategory5":
	case "TabCategory6":
	case "TabCategory7":
		OnTabCategory(TabCategory.GetTopIndex());
		break;
	case "TabCategory8":	// 최근 구매 탭
		OnTabRecentList(TabCategory.GetTopIndex());
		break;
	default :
		// item list 눌렸을 때를 처리
		strRootName = Mid(Name, 0, m_iRootNameLength);
		strProductID = Mid(Name, m_iRootNameLength+1);
		if (strRootName == "ProductListRoot" && Len(strProductID) > 0)
		{
			//debug("Selected Product ID : " $ strProductID);
			RequestBR_ProductInfo(int(strProductID));
		}
		break;
	}
}

function OnHide()
{
	Drawer.KillTimer( 2009 ); // by sr
	if(IsShowWindow("PopupWnd")) Drawer.HideWindow(); // by sr
}

function OnDBClickItem( string Name, int index )
{
	//local int i;
	local string strParam;
	local ProductInfo ProductItem;
	
	local string strRootName;
	local string strProductID;
	
	strRootName = Mid(Name, 0, m_iRootNameLength);
	strProductID = Mid(Name, m_iRootNameLength+1);
	if (strRootName == "ProductListRoot" && Len(strProductID) > 0)
	{
		ProductItem = GetProductItem(int(strProductID));
		
		if (ProductItem.iProductID > 0) {
			ParamAdd(strParam, "ID", strProductID);
			ParamAdd(strParam, "Price", string(ProductItem.iPrice));
			ParamAdd(strParam, "ItemName", ProductItem.strName);
			ParamAdd(strParam, "IconName", ProductItem.strIconName);
			ParamAdd(strParam, "Amount", "1");
			ExecuteEvent(EV_BR_SHOW_CONFIRM, strParam);
		}	
	}
}

function OnChangeEditBox( String strID )
{
	local int iQuantity;
	local int iTotal;
	local ProductInfo ProductItem;
	local Color kColor;
	local string strCount;
	
	//debug("OnchangeEditBox : " $ strID);
	if ( strID == "EditBuyCount" )
	{
		strCount = EditBuyCount.GetString();
		if ( int(strCount) > MAX_BUY_COUNT ) {
			EditBuyCount.SetString( string(MAX_BUY_COUNT) );
		}
		
		if (m_nSelectedProduct < 0) {
			TextTotalPrice.SetText("0");
		}
		else {
			ProductItem = GetProductItem(m_nSelectedProduct);
			
			if (ProductItem.iProductID > 0) {
				iQuantity = int( EditBuyCount.GetString() );
				iTotal = iQuantity * ProductItem.iPrice;
			
				TextTotalPrice.SetText("" $ iTotal $ " " $ GetSystemString(5012));
				
				kColor.r = 255;
				kColor.g = 255;
				kColor.b = 0;
				TextTotalPrice.SetTextColor(kColor);
			}
		}
	}
}

function SetGamePoint(INT64 iGamePoint)
{
	local string strGamePoint;
	
	strGamePoint = "" $ Int64ToString(iGamePoint);
	strGamePoint = MakeCostString(strGamePoint) $ " " $ GetSystemString(5012);
	TextCurrentCash.SetText(strGamePoint);
}

function ClearItemList(int allclear)
{
	class'UIAPI_TREECTRL'.static.Clear("BR_CashShopWnd.TreeItemList");	
	
	if (allclear > 0)
		m_ProductList.Length = 0;
}

function ClearItemInfo()
{
	//local string ChildName;
	//local DrawItemInfo kDrawInfo;

	if (m_hDrawPanel == None) {
		m_hDrawPanel = DrawPanelHandle( ScrollItemInfo.AddChildWnd(XCT_DrawPanel) );
		m_hDrawPanel.SetWindowSize( ITEM_INFO_WIDTH, 100 );
		m_hDrawPanel.Move(ITEM_INFO_LEFT_MARGIN, ITEM_INFO_LEFT_MARGIN);
		m_hDrawPanel.SetBackTexture("");
	}
	m_hDrawPanel.Clear();

	m_iCurrentHeight = 0;
	ResetScrollHeight();
	
	m_nSelectedProduct = -1;
	EditBuyCount.SetString("");
	EditItemSearch.SetString("");
	BtnBuy.DisableWindow();	
}

function PrepareRecentList()
{
	m_RecentList.Length = 0;
}

function HandleSetRecentProduct(string param)
{
	local int iId, category, showtab, price;
	local string itemname, iconname;
	local int start_sale, end_sale;
	local int day_week, start_hour, start_min, end_hour, end_min, stock, max_stock;
	
	local int iCurrentIndex;
	
	ParseInt(param, "ID", iId);
	ParseInt(param, "Category", category);
	ParseInt(param, "ShowTab", showtab);
	ParseInt(param, "Price", price);
	ParseString(param, "ItemName", itemname);
	ParseString(param, "IconName", iconname);
	
	ParseInt(param, "StartSale", start_sale);
	ParseInt(param, "EndSale", end_sale);

	ParseInt(param, "DayWeek", day_week);
	ParseInt(param, "StartHour", start_hour);
	ParseInt(param, "StartMin", start_min);
	ParseInt(param, "EndHour", end_hour);
	ParseInt(param, "EndMin", end_min);
	ParseInt(param, "Stock", stock);
	ParseInt(param, "MaxStock", max_stock);
	
	iCurrentIndex = m_RecentList.Length;
	m_RecentList.Length = iCurrentIndex + 1;

	m_RecentList[iCurrentIndex].iProductID = iId;
	m_RecentList[iCurrentIndex].iCategory = category;
	m_RecentList[iCurrentIndex].iShowTab = showtab;
	m_RecentList[iCurrentIndex].iPrice = price;
	m_RecentList[iCurrentIndex].strName = itemname;
	m_RecentList[iCurrentIndex].strIconName = iconname;
	
	m_RecentList[iCurrentIndex].iStartSale = start_sale;
	m_RecentList[iCurrentIndex].iEndSale = end_sale;
	
	m_RecentList[iCurrentIndex].iDayWeek = day_week;
	m_RecentList[iCurrentIndex].iStartHour = start_hour;
	m_RecentList[iCurrentIndex].iStartMin = start_min;
	m_RecentList[iCurrentIndex].iEndHour = end_hour;
	m_RecentList[iCurrentIndex].iEndMin = end_min;
	m_RecentList[iCurrentIndex].iStock = stock;
	m_RecentList[iCurrentIndex].iMaxStock = max_stock;
	
	debug("===============add recent : " $ iCurrentIndex $ "," $ m_RecentList.Length);
	m_RecentList[iCurrentIndex].bLimited = false;
	if ( !(start_hour==0 && start_min==0 && end_hour==23 && end_min==59) || day_week != 127 
		|| BR_GetDayType(end_sale, 0) != 2037 )
		m_RecentList[iCurrentIndex].bLimited = true;
		
	m_RecentList[iCurrentIndex].bEnable = false;
		
	if (m_iCurrentTab == 8) {
		AddFilteredProductList(iId, category, showtab, price, itemname, iconname, stock, max_stock, m_ProductList[iCurrentIndex].bLimited);
	}
}

function HandleToggleWindow()
{
	ClearItemList(1);
	if( m_hOwnerWnd.IsShowWindow() )
	{		
		m_hOwnerWnd.HideWindow();		
		PlaySound("InterfaceSound.inventory_close_01");
	}
	else if (m_bInConfirm == false)
	{
		ShowCashShopWnd();	
		InitProductList();
		RequestBR_GamePoint();
		RequestBR_ProductList();
		RequestBR_RecentProductList();		// 최근구매목록		
	}
}

function HandleDialogOK()
{
	local int id, num;
	local WindowHandle m_BuyWnd;	// 인벤토리 핸들 선언.
	
	if( DialogIsMine() ) {
		id = DialogGetID();
		num = int( DialogGetString() );
		if( id == DIALOG_PRODUCT_QUANTITY && num > 0 )
		{
			if (num > MAX_BUY_COUNT)
				num = MAX_BUY_COUNT;
			EditBuyCount.SetString("" $ num);			
		}
		else if ( id == DIALOG_CLOSED_SHOP ) {
			m_BuyWnd = GetWindowHandle( "BR_BuyingWnd" );
			if ( m_BuyWnd.IsShowWindow() )
			{
				m_BuyWnd.HideWindow();
			}
			if( m_hOwnerWnd.IsShowWindow() )
			{
				m_hOwnerWnd.HideWindow();
			}
		}
	}
}

function PrepareProductList(int iOption)	// 올바를 리스트를 받으면 초기화하고, -1 인 경우 상점 불가
{
	local WindowHandle m_BuyWnd;

	ClearItemList(1);
	InitProductList();
	
	if (iOption==-1) {
		m_BuyWnd = GetWindowHandle( "BR_BuyingWnd" );
		if( m_hOwnerWnd.IsShowWindow() || m_BuyWnd.IsShowWindow() ) {
			DialogSetID( DIALOG_CLOSED_SHOP );
			DialogSetDefaultOK();
			//DialogShow( DIALOG_Modalless, DIALOG_Notice, MakeFullSystemMsg( GetSystemMessage(280), "" ) );
			DialogShow( DIALOG_Modalless, DIALOG_Notice, MakeFullSystemMsg( GetSystemMessage(1474), GetSystemString(5021) ) );
		}
	}
}

function OnTabCategory(int tabindex)
{
	if (m_iCurrentTab == tabindex) {
		return;
	}
	m_iCurrentTab = tabindex;
	
	AddFilteredProductListAll();
}

function OnTabRecentList(int tabindex)
{
	local int i;
	
	if (m_iCurrentTab == tabindex) {
		return;
	}
	m_iCurrentTab = tabindex;

	ClearItemList(0);
	InitProductList();
	
	//debug("---------------tab : count=" $ m_RecentList.Length);
 
	for (i=0; i < m_RecentList.Length; i++)
	{
		//debug("--------------- " $ i $ "=" $ m_RecentList[i].iProductID $ ", " $ m_RecentList[i].strName);
		if (m_RecentList[i].iProductID != -1) {
			AddFilteredProductList(m_RecentList[i].iProductID, m_RecentList[i].iCategory, m_RecentList[i].iShowTab, m_RecentList[i].iPrice, m_RecentList[i].strName, m_RecentList[i].strIconName,
					m_RecentList[i].iStock, m_RecentList[i].iMaxStock, m_RecentList[i].bLimited);
		}
	}
}

function OnBtnItemSearchClick()
{
	local int i;
	local string strAmount;	

 	strAmount = EditItemSearch.GetString() ;
 	if( strAmount == "" ) return;
		
	ClearItemList(0);
	InitProductList();
	
	strAmount = Substitute(strAmount, " ", "", FALSE);
	
	for (i=0; i < m_ProductList.Length; i++)
	{
 		if(InStr(m_ProductList[i].strName,strAmount) > -1 )
 		{ 
			AddFilteredProductList(m_ProductList[i].iProductID, m_ProductList[i].iCategory, m_ProductList[i].iShowTab, m_ProductList[i].iPrice, m_ProductList[i].strName, m_ProductList[i].strIconName,
					m_ProductList[i].iStock, m_ProductList[i].iMaxStock, m_ProductList[i].bLimited);
		}
	}
}

function OnBtnItemSortClick(EPrItemSortType eType)
{	
	m_bSortDesc = !m_bSortDesc;
	
	if(eType == PR_ITEM_INDEX)
	{
		quicksortIndex(0, m_ProductList.Length - 1 , m_bSortDesc);
	}
	else if(eType == PR_ITEM_PRICE)
	{
		quicksortPrice(0, m_ProductList.Length - 1 , m_bSortDesc);
	}
	else if(eType == PR_ITEM_NAME)
	{
		quicksortchar(0, m_ProductList.Length - 1 , m_bSortDesc);	
	}

	AddFilteredProductListAll();
}

function swap(int i, int j)
{
	local ProductInfo ProductItem;
	ProductItem = m_ProductList[i];
	m_ProductList[i] = m_ProductList[j];
	m_ProductList[j] = ProductItem;
}


function int partitionIndex( int low, int high, bool desc )
{
	local int pivot;
	local int i;
	local int j;
	
	pivot = m_ProductList[low].iProductID;
	j = low;

	for(i = low + 1 ; i <= high ; i++)
	{
		if( desc )
		{
			if( m_ProductList[i].iProductID > pivot )
			{
				j++;
				swap(i,j);
			}
		}
		else
		{
			if( m_ProductList[i].iProductID < pivot )
			{
				j++;
				swap(i,j);
			}
		}		
	}
	
	swap(low,j);
	return j;
}


function quicksortIndex(int left, int right, bool desc )
{
	local int q;

	if( right - left == 0 )
	{
		return;
	}
	else if( left < right )
	{
		q = partitionIndex(left,right, desc);
		quicksortIndex(left, q - 1, desc);
		quicksortIndex( q + 1, right, desc);
	}
}

function int partitionPrice( int low, int high, bool desc )
{
	local int pivot;
	local int i;
	local int j;
	
	pivot = m_ProductList[low].iPrice;
	j = low;

	for(i = low + 1 ; i <= high ; i++)
	{
		if( desc )
		{
			if( m_ProductList[i].iPrice > pivot )
			{
				j++;
				swap(i,j);
			}
		}
		else
		{
			if( m_ProductList[i].iPrice < pivot )
			{
				j++;
				swap(i,j);
			}
		}		
	}
	
	swap(low,j);
	return j;
}


function quicksortPrice(int left, int right, bool desc )
{
	local int q;

	if( right - left == 0 )
	{
		return;
	}
	else if( left < right )
	{
		q = partitionPrice(left,right, desc);
		quicksortPrice(left, q - 1, desc);
		quicksortPrice( q + 1, right, desc);
	}
}


function int partitionchar( int low, int high, bool desc )
{
	local string pivot;
	local string temp;
	local int i;
	local int j;
	
	pivot = Caps(m_ProductList[low].strName);
	j = low;

	for(i = low + 1 ; i <= high ; i++)
	{
		temp = Caps(m_ProductList[i].strName);
		if( desc )
		{
			if( temp > pivot )
			{
				j++;
				swap(i,j);
			}
		}
		else
		{
			if( temp < pivot )
			{
				j++;
				swap(i,j);
			}
		}		
	}
	
	swap(low,j);
	return j;
}

function quicksortchar(int left, int right, bool desc )
{
	local int q;

	if( right - left == 0 )
	{
		return;
	}
	else if( left < right )
	{
		q = partitionchar(left,right, desc);
		quicksortchar(left, q - 1, desc);
		quicksortchar( q + 1, right, desc);
	}
}

function OnBtnBuyClick()
{
	//local int i;
	local string strParam;
	local string strAmount;
	local ProductInfo ProductItem;

	strAmount = EditBuyCount.GetString();
	ProductItem = GetProductItem(m_nSelectedProduct);
	
	if (ProductItem.iProductID > 0) {
		ParamAdd(strParam, "ID", string(m_nSelectedProduct));
		ParamAdd(strParam, "Price", string(ProductItem.iPrice));
		ParamAdd(strParam, "ItemName", ProductItem.strName);
		ParamAdd(strParam, "IconName", ProductItem.strIconName);
		ParamAdd(strParam, "Amount", strAmount);
		ExecuteEvent(EV_BR_SHOW_CONFIRM, strParam);
	}
}

function ProductInfo GetProductItem(int id)
{
	local int i;
	local ProductInfo ProductItem;
	ProductItem.iProductID = -1;

	for (i=0; i < m_ProductList.Length; i++)
	{
		if (m_ProductList[i].iProductID == id) {
			return m_ProductList[i];
		}
	}

	for (i=0; i < m_RecentList.Length; i++)
	{
		if (m_RecentList[i].iProductID == id) {
			return m_RecentList[i];
		}
	}
		
	return ProductItem;
}

function OnBtnCancelClick()
{
	Me.HideWindow();
}

function OnBtnCashChargeClick()
{
	ShowCashChargeWebSite();
	RequestBR_GamePoint();
}

function OnBtnInputQuantity()
{
	local ProductInfo ProductItem;
	ProductItem = GetProductItem(m_nSelectedProduct);
	
	if (ProductItem.iProductID > 0) {
		DialogSetID( DIALOG_PRODUCT_QUANTITY );
		//DialogSetReservedItemID( info.ID );
		DialogSetDefaultOK();
		DialogSetParamInt64( IntToInt64(MAX_BUY_COUNT) );
		DialogShow( DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(570), ProductItem.strName, "" ) );
	}
}

function InitProductList()
{
	local XMLTreeNodeInfo	infNode;
	local string strTmp;

	m_iRootNameLength = 0;
	
	//트리에 Root추가
	infNode.strName = "ProductListRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = -3;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("BR_CashShopWnd.TreeItemList", "", infNode);
	if (Len(strTmp) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}	
	m_iRootNameLength=Len(infNOde.strName);
	TreeItemList.SetScrollPosition( 0 );
}

function ShowCashShopWnd()
{
	local WindowHandle m_inventoryWnd;	// 인벤토리 핸들 선언.
	m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//인벤토리의 윈도우 핸들을 얻어온다.

	ShowWindow("BR_CashShopWnd");
	class'UIAPI_WINDOW'.static.SetFocus("BR_CashShopWnd");

	PlaySound("InterfaceSound.inventory_open_01");
	
	if( m_inventoryWnd.IsShowWindow() )			//인벤토리 창이 열려있으면 닫아준다. 
	{
		m_inventoryWnd.HideWindow();
	}
}

function bool CheckTabIndex(int category, int showtab)
{
	//local int i;
	local int iCurIndex;
	//local int num;
	
	if (m_iCurrentTab == 0 || m_iCurrentTab == 8) {		// 전체 탭인경우 무조건 true, 최근 탭도.
		return true;
	}
	else {
		if (m_arrTabType[m_iCurrentTab] == TAB_MASK) {
			iCurIndex = (showtab / m_arrTabIndex[m_iCurrentTab]) % 2;
			//debug("Check : showtab=" $ showtab $ ", index=" $ iCurIndex);
			
			if (iCurIndex == 0) {
				return false;
			}
			else {	
				return true;
			}
		}
		else if (m_arrTabType[m_iCurrentTab] == TAB_CATEGORY) {
			if (m_arrTabIndex[m_iCurrentTab] == category) {
				return true;
			}
			else {
				return false;
			}
		}
	}
	
	return false;
}

function AddFilteredProductListAll()
{
	local int i;
	
	ClearItemList(0);
	InitProductList();
	
	for (i=0; i < m_ProductList.Length; i++)
	{
		//debug("Add : " $ m_ProductList[i].iProductID $ "=" $ m_ProductList[i].strName $ ", show=" $ m_ProductList[i].iShowTab);
		AddFilteredProductList(m_ProductList[i].iProductID, m_ProductList[i].iCategory, m_ProductList[i].iShowTab, m_ProductList[i].iPrice, m_ProductList[i].strName, m_ProductList[i].strIconName,
				m_ProductList[i].iStock, m_ProductList[i].iMaxStock, m_ProductList[i].bLimited);
	}
}

function AddFilteredProductList(int iId, int category, int showtab, int price, string itemname, string iconname, int stock, int max_stock, bool bLimited)
{
	if (CheckTabIndex(category, showtab) == false) {
		return;
	}
	
	AddOneProductList("BR_CashShopWnd.TreeItemList", "ProductListRoot", iId);
}

function AddOneProductList(string HandleName, string RootName, int iId)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;
	local string strAdenaComma;

	local int price, stock, max_stock;
	local string itemname, iconname;
	local bool bLimited, bEnable;
	
	local ProductInfo kProductInfo;
	kProductInfo = GetProductItem(iId);
	
	price = kProductInfo.iPrice;
	itemname = kProductInfo.strName;
	iconname = kProductInfo.strIconName;
	stock = kProductInfo.iStock;
	max_stock = kProductInfo.iMaxStock;
	bLimited = kProductInfo.bLimited;	
	bEnable = kProductInfo.bEnable;

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
	
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode(HandleName, RootName, infNode);	
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	//debug("Node Add : " $ infNode.strName);
	
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
		class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);
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
		class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);
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
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);

	// 한정판매 강조
	if (bLimited==true || max_stock>0 || (kProductInfo.iShowTab&1)!=0 ) {
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -36-5;
		infNodeItem.nOffSetY = 4-5;
		infNodeItem.u_nTextureWidth = 42 ;
		infNodeItem.u_nTextureHeight = 42;

		//infNodeItem.u_strTexture ="L2UI_ct1.ShortcutWnd.ShortcutWnd_DF_Select";
		infNodeItem.u_strTexture ="BranchSys.ui.br_icon_limited";
		class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);
	}

	//Insert Node Item - 아이템 아이콘
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -42+5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = iconname;
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);

	//Insert Node Item - 아이템 이름
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = itemname;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 10;
	infNodeItem.nOffSetY = 6;
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);


	//Insert Node Item - "가격"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(322) $ " : ";
	infNodeItem.bLineBreak = true;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 50;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;

	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);

	//아데나(,)
	strAdenaComma = MakeCostString("" $ price);
	
	//Insert Node Item - "(아데나)"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strAdenaComma;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	infNodeItem.t_color = GetNumericColor(strAdenaComma);
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);

	//Insert Node Item - "포인트"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(5012);
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);
	
	//Insert Node Item - "남은 갯수"
	if (bEnable == false) {
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemString(1157) $ " " $ GetSystemString(908);
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 10;
		infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
		infNodeItem.t_color.R = 255;
		infNodeItem.t_color.G = 200;
		infNodeItem.t_color.B = 150;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);	
	}
	else if (max_stock > 0) {
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		if (stock>0)
			infNodeItem.t_strText = "(" $ stock $ "/" $ max_stock $ ")";
			//infNodeItem.t_strText = stock $ "/" $ max_stock $ "(" $ GetSystemString(932) $ ")";
		else if (stock<=0)
			infNodeItem.t_strText = "Sold Out";
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 10;
		infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
		infNodeItem.t_color.R = 255;
		infNodeItem.t_color.G = 200;
		infNodeItem.t_color.B = 150;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem(HandleName, strRetName, infNodeItem);	
	}
}

function AddProductItem(string param)
{
	local int iId, category, showtab, price;
	local string itemname, iconname;
	local int start_sale, end_sale;
	local int day_week, start_hour, start_min, end_hour, end_min, stock, max_stock;
	
	local int iCurrentIndex;
	
	ParseInt(param, "ID", iId);
	ParseInt(param, "Category", category);
	ParseInt(param, "ShowTab", showtab);
	ParseInt(param, "Price", price);
	ParseString(param, "ItemName", itemname);
	ParseString(param, "IconName", iconname);

	ParseInt(param, "StartSale", start_sale);
	ParseInt(param, "EndSale", end_sale);
	
	ParseInt(param, "DayWeek", day_week);
	ParseInt(param, "StartHour", start_hour);
	ParseInt(param, "StartMin", start_min);
	ParseInt(param, "EndHour", end_hour);
	ParseInt(param, "EndMin", end_min);
	ParseInt(param, "Stock", stock);
	ParseInt(param, "MaxStock", max_stock);
	
	iCurrentIndex = m_ProductList.Length;
	m_ProductList.Length = iCurrentIndex + 1;

	m_ProductList[iCurrentIndex].iProductID = iId;
	m_ProductList[iCurrentIndex].iCategory = category;
	m_ProductList[iCurrentIndex].iShowTab = showtab;
	m_ProductList[iCurrentIndex].iPrice = price;
	m_ProductList[iCurrentIndex].strName = itemname;
	m_ProductList[iCurrentIndex].strIconName = iconname;
	
	m_ProductList[iCurrentIndex].iStartSale = start_sale;
	m_ProductList[iCurrentIndex].iEndSale = end_sale;
	
	m_ProductList[iCurrentIndex].iDayWeek = day_week;
	m_ProductList[iCurrentIndex].iStartHour = start_hour;
	m_ProductList[iCurrentIndex].iStartMin = start_min;
	m_ProductList[iCurrentIndex].iEndHour = end_hour;
	m_ProductList[iCurrentIndex].iEndMin = end_min;
	m_ProductList[iCurrentIndex].iStock = stock;
	m_ProductList[iCurrentIndex].iMaxStock = max_stock;
	
	//debug("======================== end_sale : " $ end_sale);
	m_ProductList[iCurrentIndex].bLimited = false;
	if ( !(start_hour==0 && start_min==0 && end_hour==23 && end_min==59) || day_week != 127 
		|| BR_GetDayType(end_sale, 0) != 2037)
		m_ProductList[iCurrentIndex].bLimited = true;
	
	m_ProductList[iCurrentIndex].bEnable = true;
	
	if (m_iCurrentTab != 8) {	// 최근구매 제외
		AddFilteredProductList(iId, category, showtab, price, itemname, iconname, stock, max_stock, m_ProductList[iCurrentIndex].bLimited);
	}
	
//	debug("AddProductListItem:"$strName$", "$strIconName$", "$iFee);
}

// 상세 정보 창에 출력 - 상단 상품 정보
function SetNewProductInfo(int iId, int price, string itemname, string desc)
{
	local ProductInfo kProductInfo;
	local string strTemp;
	local DrawItemInfo kDrawInfo;
	local int LimitedMarginY;
	local int bTimeLimit;
	
	//debug("SetNewProductInfo : " $ iId $ "-" $ itemname );
	ClearItemInfo();

	// 상품 이름
	//MakeDrawInfo_Text(kDrawInfo, itemname, 255, 255, 0);
	MakeDrawInfo_Desc(kDrawInfo, itemname, 255, 255, 0);
	m_hDrawPanel.InsertDrawItem(kDrawInfo);

	// 가격
	strTemp = GetSystemString(190) $ " : " $ price $ " " $ GetSystemString(5012);
	MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 255);
	kDrawInfo.bLineBreak = true;
	kDrawInfo.nOffSetY = 6;
	m_hDrawPanel.InsertDrawItem(kDrawInfo);
	
	// 한정판매 정보
	kProductInfo = GetProductItem(iId);
	if (kProductInfo.iProductID >= 0) {
		LimitedMarginY = 6;
		bTimeLimit = 0;
		if (!(kProductInfo.iStartHour==0 && kProductInfo.iStartMin==0 && kProductInfo.iEndHour==23 && kProductInfo.iEndMin==59)) {
			bTimeLimit = 1;
		}

		if (BR_GetDayType(kProductInfo.iEndSale, 0) != 2037) {
			strTemp = "[" $ GetSystemString(5035) $ "] " $ BR_ConvertTimetoStr(kProductInfo.iStartSale, bTimeLimit);
			MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
			strTemp = "             ~ " $ BR_ConvertTimetoStr(kProductInfo.iEndSale, bTimeLimit) ;
			MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);		}
		if (kProductInfo.iDayWeek != 127) {
			strTemp = "[" $ GetSystemString(5028) $ "]";
			MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if (bTimeLimit!=0) {
			strTemp = "[" $ GetSystemString(5029) $ "] " $ ZERO_STR(kProductInfo.iStartHour) $ kProductInfo.iStartHour $ ":" 
						$ ZERO_STR(kProductInfo.iStartMin) $ kProductInfo.iStartMin $ "~" 
						$ ZERO_STR(kProductInfo.iEndHour) $ kProductInfo.iEndHour $ ":" 
						$ ZERO_STR(kProductInfo.iEndMin) $ kProductInfo.iEndMin;
			MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if (kProductInfo.iMaxStock > 0) {		// 잔여량
			strTemp = "[" $ GetSystemString(5027) $ "] " $ kProductInfo.iStock $ "/" $ kProductInfo.iMaxStock; // $ "(" $ GetSystemString(932) $ ")"; // 932 스트링이 영어가 이상
			MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
	}	
	
	// 상품 설명 (존재시)
	if ( Len(desc) > 0 ) 
	{
		MakeDrawInfo_Desc(kDrawInfo, desc, 200, 200, 200);
		kDrawInfo.nOffSetY = 12;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
	}
		
	m_nSelectedProduct = iID;
	EditBuyCount.SetString("1");
	BtnBuy.EnableWindow();
	
	ResetScrollHeight();
}

// 상세 정보 창에 출력 - 하단 아이템 정보
function AddEachProductInfo(int iId, int iAmount, string itemname, string iconname, string desc, int weight, int trade)
{
	local string strWeight;
	local string strTrade;
	local string strTemp;
	local string strNum;
	local ItemInfo kItemInfo;
	local DrawItemInfo kDrawInfo;
	local bool IsPremium;
	local int nHeight;
	local int nWidth;

	//local int iHeight, iWidth;
	local Color NameColor;
	local int i;
	
	NameColor.R = 200;
	NameColor.G = 200;
	NameColor.B = 200;
	NameColor.A = 255;
	
	//debug("AddEachProductInfo : " $ iId $ "-" $ itemname $ "," $ iconname);
	class'UIDATA_ITEM'.static.GetItemInfo( GetItemID(iId), kItemInfo );

	MakeDrawInfo_Blank(kDrawInfo, 12);
	m_hDrawPanel.InsertDrawItem(kDrawInfo);
	
	// 아이템 아이콘	
	MakeDrawInfo_Image(kDrawInfo, iconname, 32, 32);
	kDrawInfo.nOffSetY = 12;
	kDrawInfo.bLineBreak = true;
	m_hDrawPanel.InsertDrawItem(kDrawInfo);

	// 아이템 이름. 아이콘 옆에 위치
	// prime icon
	if (kItemInfo.IsBRPremium == 2) 
	{
		IsPremium = MakeCashItemIcon(kDrawInfo);
		if ( IsPremium == true ) {
			kDrawInfo.nOffSetX = 6;
			kDrawInfo.nOffSetY = 16;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
		}
	}

	// 이름
	strTemp = itemname;
	MakeDrawInfo_Text(kDrawInfo, strTemp, 255, 255, 255);
	kDrawInfo.nOffSetY = 16;
	if ( IsPremium == false ) {
		kDrawInfo.nOffSetX = 6;
	}
	m_hDrawPanel.InsertDrawItem(kDrawInfo);

	// additional name
	if (Len(kItemInfo.AdditionalName)>0) {
		GetTextSizeDefault(strTemp, nWidth, nHeight);
		MakeDrawInfo_Text(kDrawInfo, kItemInfo.AdditionalName, 255, 217, 105);
		kDrawInfo.nOffSetX = -nWidth;
		kDrawInfo.nOffSetY = 32;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
	}
	
	// 갯수
	if (iAmount > 1) {
		strNum = GetSystemString(192) $ " : " $ iAmount;
		MakeDrawInfo_Text(kDrawInfo, strNum, 200, 200, 200);
		kDrawInfo.nOffSetY = 6;
		kDrawInfo.bLineBreak = true;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
	}

	// 무게
	strWeight = GetSystemString(52) $ " : " $ weight $ " (" $ GetSystemString(468) $ ")";
	MakeDrawInfo_Text(kDrawInfo, strWeight, 200, 200, 200);
	if (iAmount <= 1) kDrawInfo.nOffSetY = 6;
	kDrawInfo.bLineBreak = true;
	m_hDrawPanel.InsertDrawItem(kDrawInfo);

	// 교환여부
	if (trade == 0) {
		strTrade = GetSystemString(1491);
		MakeDrawInfo_Text(kDrawInfo, strTrade, 200, 200, 200);
		kDrawInfo.bLineBreak = true;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
	}

	// 상세 설명
	if ( Len(desc) > 0 ) 
	{
		MakeDrawInfo_Desc(kDrawInfo, desc, 255, 255, 255);
		kDrawInfo.nOffSetY = 12;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
	}
	
	// 팩 아이템 추가정보
	if ( kItemInfo.IncludeItem[0] > 0 ) {
		MakeDrawInfo_Text(kDrawInfo, GetSystemString(5064), 255, 255, 128);
		kDrawInfo.bLineBreak = true;
		kDrawInfo.nOffSetY = 12;
		m_hDrawPanel.InsertDrawItem(kDrawInfo);
		
		i = 0;
		while(kItemInfo.IncludeItem[i] > 0 && i < 10) {
			MakeDrawInfo_TextLink(kDrawInfo, kItemInfo.IncludeItem[i], 200, 200, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetX = 16;
			kDrawInfo.nOffSetY = 2;
			m_hDrawPanel.InsertDrawItem(kDrawInfo);
			debug("========id : " $ kItemInfo.IncludeItem[i]);
			i = i+1;
		}
	}

	ResetScrollHeight();
}

function int CalcTextHeight(string tempStr)
{
	local int nHeight;
	local int nWidth;
	GetTextSizeDefault(tempStr, nWidth, nHeight);		// 사이즈를 받아서
	if (nWidth == 0) {
		return 0;
	}
	
	nHeight = (nHeight + 5) * (nWidth / ITEM_INFO_WIDTH + 1);
	
	return nHeight;
}

function ResetScrollHeight()
{
	local int iWidth, iHeight;
	
	m_hDrawPanel.PreCheckPanelSize(iWidth, iHeight);
	m_hDrawPanel.SetWindowSize(ITEM_INFO_WIDTH, iHeight+16);

	m_iCurrentHeight = iHeight;
	
	ScrollItemInfo.SetScrollHeight(m_iCurrentHeight+17);
	ScrollItemInfo.SetScrollPosition( 0 );
}

function bool MakeCashItemIcon(out DrawItemInfo Info)
{
	local string TextureName;
	
	Info = m_kDrawInfoClear;
	//TextureName = GetItemGradeTextureName(5);
	TextureName = GetPrimeItemSymbolName();
	if (Len(TextureName)>0)
	{
		Info.eType = DIT_TEXTURE;
		Info.nOffSetX = 0;
		Info.nOffSetY = 0;
		Info.u_nTextureWidth = 16;
		Info.u_nTextureHeight = 16;
		Info.u_nTextureUWidth = 16;
		Info.u_nTextureUHeight = 16;
		Info.u_strTexture = TextureName;
		
		return true;
	}
	
	return false;
}

function MakeText(out DrawItemInfo Info, string str)
{
	Info = m_kDrawInfoClear;

	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 255;
	Info.t_color.G = 255;
	Info.t_color.B = 255;
	Info.t_color.A = 255;
	Info.t_strText = str;
}

function MakeDrawInfo_Text(out DrawItemInfo Info, string str, int r, int g, int b)
{
	Info = m_kDrawInfoClear;

	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = r;
	Info.t_color.G = g;
	Info.t_color.B = b;
	Info.t_color.A = 255;
	Info.t_strText = str;
}

function MakeDrawInfo_Desc(out DrawItemInfo Info, string str, int r, int g, int b)
{
	Info = m_kDrawInfoClear;

	Info.eType = DIT_TEXT;
	Info.bLineBreak = true;
	Info.t_bDrawOneLine = false;
	Info.t_MaxWidth = ITEM_INFO_WIDTH;
	Info.t_color.R = r;
	Info.t_color.G = g;
	Info.t_color.B = b;
	Info.t_color.A = 255;
	Info.t_strText = str;
}

function bool MakeDrawInfo_Image(out DrawItemInfo Info, string TextureName, int width, int height)
{
	Info = m_kDrawInfoClear;
	if (Len(TextureName)>0)
	{
		Info.eType = DIT_TEXTURE;
		Info.nOffSetX = 0;
		Info.nOffSetY = 0;
		Info.u_nTextureWidth = width;
		Info.u_nTextureHeight = height;
		Info.u_nTextureUWidth = width;
		Info.u_nTextureUHeight = height;
		Info.u_strTexture = TextureName;
		
		return true;
	}
	
	return false;
}

function MakeDrawInfo_Blank(out DrawItemInfo Info, int Height)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_BLANK;
	Info.b_nHeight = Height;
}

function MakeDrawInfo_TextLink(out DrawItemInfo Info, int id, int r, int g, int b)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_TEXTLINK;
	Info.t_ID = id;
	Info.t_color.R = r;
	Info.t_color.G = g;
	Info.t_color.B = b;
	Info.t_color.A = 255;
	Info.t_strText = "";
}

function string ZERO_STR(int num)
{
	if (num < 10)
		return "0";
	else
		return "";
}
defaultproperties
{
}
