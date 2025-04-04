//-----------------------------------------------------------//
//		 Premium Item alarm btn window
//					by innowind (NC Soft)
//-----------------------------------------------------------//

class PremiumItemBtnWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle AlarmWnd;
var ButtonHandle btnItemPop;

function OnRegisterEvent()
{
	RegisterEvent( EV_PremiumItemAlarm );
	RegisterEvent( EV_GoodsInventoryNoti );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	Initialize();
	Clear();
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "PremiumItemBtnWnd" );
		AlarmWnd = GetHandle( "PremiumItemAlarmWnd" );
		btnItemPop = ButtonHandle ( GetHandle( "PremiumItemBtnWnd.btnItemPop" ) );
	}
	else
	{
		Me = GetWindowHandle( "PremiumItemBtnWnd" );
		AlarmWnd = GetWindowHandle( "PremiumItemAlarmWnd" );
		btnItemPop = GetButtonHandle ("PremiumItemBtnWnd.btnItemPop" );
	}

	if( IsUseGoodsInvnentory() == false )
	{
		btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2313)));	// 툴팁. 프리미엄 아이템이 도착하였습니다.
	}
	else
	{
		btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(3462)));	// 툴팁. 새로운 상품이 도착하였습니다. 아이콘을 클릭하시면 상품을 확인하실 수 있습니다.
	}
}

function Clear()
{

}

// 버튼을 클릭하면 알림창 팝업
function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnItemPop":
		if( IsUseGoodsInvnentory() == false )
		{
			if(!AlarmWnd.isShowWindow()) AlarmWnd.showWindow();
		}
		else
		{
			HandleShowProductInventory();
		}
		Me.hideWindow();
		Me.SetWindowSize( 0 , 32 );	//윈도우의 크기를 재조정해준다. 
		break;
	}
}

//상품 인벤토리 열기
function HandleShowProductInventory()
{
	local WindowHandle win;	
	win = GetWindowHandle( "ProductInventoryWnd" );

	if( ! win.IsShowWindow() )
	{
		win.ShowWindow();
		win.SetFocus();
	}
}

// 이벤트를 받아 데이터를 파싱한다. 
function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PremiumItemAlarm:
			Me.SetWindowSize( 32 , 32);	//윈도우의 크기를 재조정해준다. 
			ShowWindowWithFocus("PremiumItemBtnWnd");
			btnItemPop.ShowWindow();
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("PremiumItemBtnWnd.btnItemPop", 0);
			AddSystemMessage(2313);	
		break;

		case EV_GoodsInventoryNoti:
			Me.SetWindowSize( 32 , 32);	//윈도우의 크기를 재조정해준다. 
			ShowWindowWithFocus("PremiumItemBtnWnd");
			btnItemPop.ShowWindow();
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("PremiumItemBtnWnd.btnItemPop", 0);
			break;
	}
}

//상태가 변할 경우 무조건 닫아준다.
function OnExitState( name a_NextStateName )
{
	Clear();
	Me.SetWindowSize( 0 , 32);	//윈도우의 크기를 재조정해준다. 
	Me.HideWindow();	
}
defaultproperties
{
}
