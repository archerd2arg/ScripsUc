class AuctionBtnWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle btnAuction[3];

var int ButtonOn[3];		//경매가 3군데이므로
					//1이면 최고입찰 진행
// 어째서인지 bool은 배열을 만들수 없다는.. 


function OnRegisterEvent()
{
	RegisterEvent(EV_SystemMessage);		// 시스템 메세지를 후킹하기 위한 이벤트
	RegisterEvent( EV_ITEM_AUCTION_INFO );	// 상위 입찰자가 생겼을 경우 버튼을 지워주기 위한 이벤트
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AuctionBtnWnd" );
		btnAuction[0] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction1" ) );
		btnAuction[1] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction2" ) );
		btnAuction[2] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction3" ) );	
	}
	else
	{
		Me = GetWindowHandle( "AuctionBtnWnd" );
		btnAuction[0] = GetButtonHandle( "AuctionBtnWnd.btnAuction1" );
		btnAuction[1] = GetButtonHandle( "AuctionBtnWnd.btnAuction2" );
		btnAuction[2] = GetButtonHandle( "AuctionBtnWnd.btnAuction3" );	
	}
}

function Load()
{
	clear();
}

function clear()
{
	local int i;
	for(i=0; i<3; i++)
	{
		ButtonOn[i] = -1;	// 버튼 3개를 초기화해준다. 
		btnAuction[i].HideWindow();
	}	
}

// 이벤트를 받아 데이터를 파싱한다. 
function OnEvent(int Event_ID, string param)
{
	//이벤트로 받는 정보
	local int 		SystemMsgIndex;
	
	switch(Event_ID)
	{
	// 시스템 메세지가 왔을 겨우
	case EV_SystemMessage:
		ParseInt ( param, "Index", SystemMsgIndex );
		HandleAuctionSystemMessage(SystemMsgIndex);
		break;
	}
}

//상태가 변할 경우 무조건 닫아준다.
function OnExitState( name a_NextStateName )
{
	clear();
}


function HandleAuctionSystemMessage(int SystemMsgIndex)
{
	if(SystemMsgIndex == 2192)		//경매에 입찰하였습니다.
	{
		SetAuctionTooltip();
	}
	else if(SystemMsgIndex == 2080 || SystemMsgIndex == 2131)		//상위 입찰자에 의해 경매가 취소되었습니다. or  낙찰되었습니다.
	{
		DeleteAuctionTooltip();
	}
}

//최고 입찰중이라는 툴팁을 셋팅해준다. 보여주는 것은 시스템 메세지가 왔을 경우
function SetAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2198)));
	ButtonOn[0]  = 1;
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 5, 0 );		//시스템 튜토리얼 버튼을 경매 버튼 옆에 붙여준다.  경매 버튼이 있으면 margin 5
	btnAuction[0].ShowWindow();
	ComputeWidth();
	
	/*	//여기는 12월에 개발 
	// 해당 경매 ID에 해당하는 장소의 최고 입찰가를 표시해준다. 
	if (auctionID == 1)
	{
		btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText("아덴성 경매에 최고 입찰중입니다."));
		//btnAuction[0].ShowWindow();
		ButtonOn[0] = auctionID;
		//btnAuction1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
	}
	else if( auctionID == 2)
	{
		btnAuction[1].SetTooltipCustomType(MakeTooltipSimpleText("오렌성 경매에 최고 입찰중입니다."));
		//btnAuction[1].ShowWindow();
		ButtonOn[1] = auctionID;
	}
	else if(auctionID == 3)
	{
		btnAuction[2].SetTooltipCustomType(MakeTooltipSimpleText("오렌성 경매에 최고 입찰중입니다."));
		//btnAuction[2].ShowWindow();
		ButtonOn[2] = auctionID;
	}
	else
	{
		debug("ERROR - auctionID is invalid!!");
	}
	*/
}

//다른 사람이 최고입찰하면 아이콘을 숨긴다.  
function DeleteAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(""));
	btnAuction[0].HideWindow();
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 0, 0 );		//시스템 튜토리얼 버튼을 경매 버튼 옆에 붙여준다.  경매 버튼이 없으면 margin 0
	ComputeWidth();
	/*
	// 해당 경매 ID에 해당하는 장소의 최고 입찰가를 표시해준다. 
	if (auctionID == 1)
	{
		btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(""));
		btnAuction[0].HideWindow();
		ButtonOn[0] = -1;
		//btnAuction1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
	}
	else if( auctionID == 2)
	{
		btnAuction[1].SetTooltipCustomType(MakeTooltipSimpleText(""));
		btnAuction[1].HideWindow();
		ButtonOn[1] = -1;
	}
	else if(auctionID == 3)
	{
		btnAuction[2].SetTooltipCustomType(MakeTooltipSimpleText(""));
		btnAuction[2].HideWindow();
		ButtonOn[2] = -1;
	}
	else
	{
		debug("ERROR - auctionID is invalid!!");
	}
	*/
}

// 활성화된 버튼 수에 따라 윈도우 넓이를 계산하고, 위치를 재조정한다. 
function ComputeWidth()
{
	local int i;	//for문을 위한 변수
	local int nOpenButton;
	local int nNowX;
	
	nOpenButton = 0;
	nNowX = 0;
	for(i=0 ; i< 3 ; i++)
	{
		//해당 버튼이 열려있을 경우
		if( ButtonOn[i] > -1)
		{
			nOpenButton ++;
			if( nOpenButton > 1)	//처음 추가하면 0부터 시작한다.
				nNowX = nNowX + 37;
			btnAuction[0].Move(nNowX, 0);
		}		
	}

	Me.SetWindowSize( nOpenButton * 37 , 32);	//윈도우의 크기를 재조정해준다.  // 클릭영역때문에
}
defaultproperties
{
}
