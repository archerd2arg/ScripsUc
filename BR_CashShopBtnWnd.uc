class BR_CashShopBtnWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnShowCashShop;
var WindowHandle Drawer; // by sr

function OnLoad()
{
	InitHandle();
	Load();
}

function InitHandle()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_CashShopBtnWnd" );
		BtnShowCashShop = ButtonHandle ( GetHandle( "BR_CashShopBtnWnd.BtnShowCashShop" ) );
	}
	else {
		Me = GetWindowHandle( "BR_CashShopBtnWnd" );
		BtnShowCashShop = GetButtonHandle ( "BR_CashShopBtnWnd.BtnShowCashShop" );
	}
}

function Load()
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "BtnShowCashShop":
		OnBtnShowCashShopClick();
		break;
	}
}

function OnBtnShowCashShopClick()
{
	// 클릭할 때마다 토글된다.
	if(IsShowWindow("BR_CashShopWnd"))
	{
		HideWindow("BR_CashShopWnd");
		PlaySound("InterfaceSound.inventory_close_01");
	}
	else
	{
		//ShowWindowWithFocus("BR_CashShopWnd");	// 테스트용
		ExecuteEvent(EV_BR_CashShopToggleWindow);
		PlaySound("InterfaceSound.inventory_open_01");
	}
}

function OnShow()
{
	local int bShow;
	bShow = 0;
	GetINIBool("PrimeShop", "UsePrimeShop", bShow, "L2.ini");
	
	//debug("bShow=" $ bShow);
	if ( bShow != 0 ) {
		Me.ShowWindow();
	} else {
		Me.HideWindow();
	}
}
defaultproperties
{
}
