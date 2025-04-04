class AuctionBtnWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle btnAuction[3];

var int ButtonOn[3];		//��Ű� 3�����̹Ƿ�
					//1�̸� �ְ����� ����
// ��°������ bool�� �迭�� ����� ���ٴ�.. 


function OnRegisterEvent()
{
	RegisterEvent(EV_SystemMessage);		// �ý��� �޼����� ��ŷ�ϱ� ���� �̺�Ʈ
	RegisterEvent( EV_ITEM_AUCTION_INFO );	// ���� �����ڰ� ������ ��� ��ư�� �����ֱ� ���� �̺�Ʈ
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
		ButtonOn[i] = -1;	// ��ư 3���� �ʱ�ȭ���ش�. 
		btnAuction[i].HideWindow();
	}	
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string param)
{
	//�̺�Ʈ�� �޴� ����
	local int 		SystemMsgIndex;
	
	switch(Event_ID)
	{
	// �ý��� �޼����� ���� �ܿ�
	case EV_SystemMessage:
		ParseInt ( param, "Index", SystemMsgIndex );
		HandleAuctionSystemMessage(SystemMsgIndex);
		break;
	}
}

//���°� ���� ��� ������ �ݾ��ش�.
function OnExitState( name a_NextStateName )
{
	clear();
}


function HandleAuctionSystemMessage(int SystemMsgIndex)
{
	if(SystemMsgIndex == 2192)		//��ſ� �����Ͽ����ϴ�.
	{
		SetAuctionTooltip();
	}
	else if(SystemMsgIndex == 2080 || SystemMsgIndex == 2131)		//���� �����ڿ� ���� ��Ű� ��ҵǾ����ϴ�. or  �����Ǿ����ϴ�.
	{
		DeleteAuctionTooltip();
	}
}

//�ְ� �������̶�� ������ �������ش�. �����ִ� ���� �ý��� �޼����� ���� ���
function SetAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2198)));
	ButtonOn[0]  = 1;
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 5, 0 );		//�ý��� Ʃ�丮�� ��ư�� ��� ��ư ���� �ٿ��ش�.  ��� ��ư�� ������ margin 5
	btnAuction[0].ShowWindow();
	ComputeWidth();
	
	/*	//����� 12���� ���� 
	// �ش� ��� ID�� �ش��ϴ� ����� �ְ� �������� ǥ�����ش�. 
	if (auctionID == 1)
	{
		btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText("�Ƶ��� ��ſ� �ְ� �������Դϴ�."));
		//btnAuction[0].ShowWindow();
		ButtonOn[0] = auctionID;
		//btnAuction1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
	}
	else if( auctionID == 2)
	{
		btnAuction[1].SetTooltipCustomType(MakeTooltipSimpleText("������ ��ſ� �ְ� �������Դϴ�."));
		//btnAuction[1].ShowWindow();
		ButtonOn[1] = auctionID;
	}
	else if(auctionID == 3)
	{
		btnAuction[2].SetTooltipCustomType(MakeTooltipSimpleText("������ ��ſ� �ְ� �������Դϴ�."));
		//btnAuction[2].ShowWindow();
		ButtonOn[2] = auctionID;
	}
	else
	{
		debug("ERROR - auctionID is invalid!!");
	}
	*/
}

//�ٸ� ����� �ְ������ϸ� �������� �����.  
function DeleteAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(""));
	btnAuction[0].HideWindow();
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 0, 0 );		//�ý��� Ʃ�丮�� ��ư�� ��� ��ư ���� �ٿ��ش�.  ��� ��ư�� ������ margin 0
	ComputeWidth();
	/*
	// �ش� ��� ID�� �ش��ϴ� ����� �ְ� �������� ǥ�����ش�. 
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

// Ȱ��ȭ�� ��ư ���� ���� ������ ���̸� ����ϰ�, ��ġ�� �������Ѵ�. 
function ComputeWidth()
{
	local int i;	//for���� ���� ����
	local int nOpenButton;
	local int nNowX;
	
	nOpenButton = 0;
	nNowX = 0;
	for(i=0 ; i< 3 ; i++)
	{
		//�ش� ��ư�� �������� ���
		if( ButtonOn[i] > -1)
		{
			nOpenButton ++;
			if( nOpenButton > 1)	//ó�� �߰��ϸ� 0���� �����Ѵ�.
				nNowX = nNowX + 37;
			btnAuction[0].Move(nNowX, 0);
		}		
	}

	Me.SetWindowSize( nOpenButton * 37 , 32);	//�������� ũ�⸦ ���������ش�.  // Ŭ������������
}
defaultproperties
{
}
