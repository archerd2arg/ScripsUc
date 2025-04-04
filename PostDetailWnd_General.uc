class PostDetailWnd_General extends UICommonAPI;


var WindowHandle Me;
var WindowHandle SafetyTrade;

var TextboxHandle Title_SenderID;
var TextboxHandle SenderID;
var TextboxHandle PostType;
var TextboxHandle PostTitle;
var TextListBoxHandle PostContents;  
var TextboxHandle WeightText;

var ButtonHandle SendCancelBtn;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle ReplyBtn;
//선준 수정(10.03.19)
var ButtonHandle AddBtn;

var ItemWindowHandle AccompanyItem;

var int trade;		//안전거래, 일반우편
var int returnd;	//반송여부
var int mailID;
var int totalWeight;//총  무게
var int returnable, sentbysystem;

//var int IsPeaceZone;

const DIALOG_RETURN_POST = 1111;
function OnRegisterEvent()
{
	registerEvent( EV_ReplyReceivedPostStart ); 
	registerEvent( EV_ReplyReceivedPostAddItem );
	registerEvent( EV_ReplyReceivedPostEnd );

	registerEvent( EV_ReplySentPostStart ); 
	registerEvent( EV_ReplySentPostAddItem );
	registerEvent( EV_ReplySentPostEnd );
	registerEvent( EV_DialogOK );

	registerEvent( EV_SetRadarZoneCode );
}

function OnLoad()
{
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

	Me.HideWindow();

//	ResetUI();
	totalWeight = 0;
}

function OnShow()
{
	if (SafetyTrade.IsShowWindow())
		SafetyTrade.HideWindow();
}

function Initialize()
{
	Me = GetHandle("PostDetailWnd_General");
	SafetyTrade = GetHandle("PostDetailWnd_SafetyTrade");
	
	Title_SenderID=TextboxHandle(GetHandle("PostDetailWnd_General.Title_SenderID"));
	SenderID=TextboxHandle(GetHandle("PostDetailWnd_General.SenderID"));
	PostType=TextboxHandle(GetHandle("PostDetailWnd_General.PostType"));
	PostTitle=TextboxHandle(GetHandle("PostDetailWnd_General.PostTitle"));
	PostContents=TextListBoxHandle(GetHandle("PostDetailWnd_General.PostContents"));
	WeightText=TextboxHandle(GetHandle("PostDetailWnd_General.WeightText"));
	
	SendCancelBtn=ButtonHandle (GetHandle("PostDetailWnd_General.SendCancelBtn"));
	ReceiveBtn=ButtonHandle (GetHandle("PostDetailWnd_General.ReceiveBtn"));
	ReturnBtn=ButtonHandle (GetHandle("PostDetailWnd_General.ReternBtn"));
	ReplyBtn=ButtonHandle (GetHandle("PostDetailWnd_General.ReplyBtn"));
	//선준 수정(10.03.19)
	AddBtn=ButtonHandle (GetHandle("PostDetailWnd_General.AddBtn"));

	AccompanyItem = ItemWindowHandle(GetHandle("PostDetailWnd_General.AccompanyItem"));
	

}

function InitializeCOD()
{
	
	Me = GetWindowHandle("PostDetailWnd_General.PostDetailWnd_General");
	SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");

	Title_SenderID=GetTextBoxHandle("PostDetailWnd_General.Title_SenderID");
	SenderID=GetTextBoxHandle("PostDetailWnd_General.SenderID");
	PostType=GetTextBoxHandle("PostDetailWnd_General.PostType");
	PostTitle=GetTextBoxHandle("PostDetailWnd_General.PostTitle");
	PostContents = GetTextListBoxHandle("PostDetailWnd_General.PostContents");
	WeightText=GetTextBoxHandle("PostDetailWnd_General.WeightText");

	SendCancelBtn=GetButtonHandle("PostDetailWnd_General.SendCancelBtn");
	ReceiveBtn=GetButtonHandle("PostDetailWnd_General.ReceiveBtn");
	ReturnBtn=GetButtonHandle("PostDetailWnd_General.ReternBtn");
	ReplyBtn=GetButtonHandle("PostDetailWnd_General.ReplyBtn");
	//선준 수정(10.03.19)
	AddBtn=GetButtonHandle("PostDetailWnd_General.AddBtn");

	AccompanyItem = GetItemWindowHandle("PostDetailWnd_General.AccompanyItem");
}


function OnEvent( int Event_ID, String Param )
{
	local int zonetype;
	switch(Event_ID)
	{
	case EV_ReplyReceivedPostStart:		
		OnEVReplyReceivedPostStart(Param);
		break;
	case EV_ReplyReceivedPostAddItem:
		OnEVReplyReceivedPostAddItem(Param);
		break;
	case EV_ReplyReceivedPostEnd:
		OnEVReplyReceivedPostEnd(Param);
		break;

	case EV_ReplySentPostStart:
		OnEVReplySentPostStart(Param);
		break;
	case EV_ReplySentPostAddItem:
		OnEVReplySentPostAddItem(Param);
		break;
	case EV_ReplySentPostEnd:
		OnEVReplySentPostEnd(Param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;	
	case EV_SetRadarZoneCode:
		ParseInt( Param, "ZoneCode", zonetype );
		if (zonetype == 12)
		{
			SendCancelBtn.EnableWindow();
			ReceiveBtn.EnableWindow();
			ReturnBtn.EnableWindow();
//			ReplyBtn.EnableWindow();
		}
		else
		{
			if (Me.IsShowWindow())
				AddSystemMessage(3066);

			SendCancelBtn.DisableWindow();
			ReceiveBtn.DisableWindow();
			ReturnBtn.DisableWindow();
//			if ( AccompanyItem.GetItemNum() > 0 )
//				ReplyBtn.DisableWindow();
		}

		break;
	}
}


function OnEVReplyReceivedPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	ParseInt(param, "Returnd", returnd);  // 반송된 메일인가(1), 아닌가(0)

	if (returnd == 1 || trade == 0 ) //반송된경우이거나, 일반우편일경우
	{
		Me.SetWindowTitle(GetSystemString(2075));
		ReceiveBtn.Hidewindow();
		ReturnBtn.ShowWindow();
		SendCancelBtn.HideWindow();
//		ReturnBtn.ShowWindow();			//위랑 똑같아서 제거.

		Me.ShowWindow();
		Me.Setfocus();
		
	}
	totalWeight =0;
	
}

function OnEVReplyReceivedPostAddItem(String Param)
{
	local ItemInfo info;
	if (returnd == 1 || trade == 0 ) //일반우편이면
	{
		ParamToItemInfo( param, info );
		AccompanyItem.AddItem(info);

		totalWeight += info.Weight * Int64ToInt(info.ItemNum);

		
	}
}

function OnEVReplyReceivedPostEnd(String Param)
{
	local string SenderName, title, contents;
	local INT64 tradeMoney;
	local string fixedtitle;
	
	if (returnd == 1 || trade == 0)
	{
		ParseInt(param, "MailID", mailID);  
		ParseString(param, "SenderName", SenderName);	// 보낸 사람
		ParseString(param, "Title", title);				// 제목
		ParseString(param, "Content", contents);		// 내용
		ParseINT64(param, "TradeMoney", tradeMoney);	// 청구비용
		ParseInt(param, "ReturnAble", returnable);  // 취소할수있나(1), 없나(0)
		ParseInt(param, "Sentbysystem", sentbysystem);// 시스템이 보낸메일인가(1), 아닌가(0)
		
		PostType.SetText(GetSystemString(2071));
		fixedtitle = DivideStringWithWidth(title, 380);
		if (fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);

		PostContents.AddString(contents,GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		if (AccompanyItem.GetItemNum() != 0 )
		{
			if (!ReceiveBtn.IsShowwindow())
				ReceiveBtn.Showwindow();
		}

		if (returnable == 1)
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomRight", -1, -4);
			}
			ReturnBtn.ShowWindow();
//			ReturnBtn.EnableWindow();
		}
		else
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}

//#ifndef CT26P2_0825 
//		if (sentbysystem == 1) //시스템이 보낸메일이면
//		{
//			if (returnd == 1)
//				SenderID.SetText(GetSystemString(2073));
//			else
//				SenderID.SetText(GetSystemString(2211));
//
//			if (ReceiveBtn.IsShowwindow())
//			{
//				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
//			}
//			ReturnBtn.HideWindow();
//		}
//		else
//		{
//			SenderID.SetText(SenderName);
//		}
//
//		if (sentbysystem == 1)
//		{
//			ReplyBtn.HideWindow();
//		}
//		else
//		{
//			ReplyBtn.EnableWindow();
//			ReplyBtn.ShowWindow();
//		}
//#endif 

//#ifdef CT26P2_0825
		if (sentbysystem == 1) // 1: 시스템이 보낸 메일
		{
			if (returnd == 1)
				SenderID.SetText(GetSystemString(2073));
			else
				SenderID.SetText(GetSystemString(2211));			
		}
		else if (sentbysystem == 3)
		{
			SenderID.SetText(GetSystemString(2316)); // 알레그리아
		}
		else
		{
			SenderID.SetText(SenderName);
		}

		if (sentbysystem == 1 || sentbysystem == 3 ) // 3: BirthDay Mail
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
			ReplyBtn.HideWindow();
		}
		else
		{
			ReplyBtn.EnableWindow();
			ReplyBtn.ShowWindow();
		}
//#endif 

		if (AccompanyItem.GetItemNum() == 0 )
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}
		
		WeightText.SetText(string(totalWeight));
	}
}

function OnEVReplySentPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	if (trade == 0 ) //일반우편이면
	{
		Me.SetWindowTitle(GetSystemString(2076));
		ReceiveBtn.Hidewindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.ShowWindow();
		ReplyBtn.HideWindow();
		//ReturnBtn.Showwindow();
		Me.ShowWindow();
		Me.Setfocus();
	}
}

function OnEVReplySentPostAddItem(String Param)
{
	local ItemInfo info;
	if (trade == 0 ) //일반우편이면
	{
		ParamToItemInfo( param, info );
		AccompanyItem.AddItem(info);	
	}
}

function OnEVReplySentPostEnd(String Param)
{
	local string ReceiverName, title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;
	if (trade == 0)
	{
		ParseInt(param, "MailID", mailID);				// 메일 아이디
		ParseString(param, "ReceiverName", ReceiverName);	// 받을 사람
		ParseString(param, "Title", title);				// 제목
		ParseString(param, "Content", contents);		// 내용
		ParseINT64(param, "TradeMoney", tradeMoney);	// 청구비용
		ParseInt(param, "NotOpend", notOpend);  // 취소할수있나(1), 없나(0)
	
		

		PostType.SetText(GetSystemString(2071));
		fixedtitle = DivideStringWithWidth(title, 380);
		if (fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);


		Title_SenderID.SetText(GetSystemString(2087));
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		SenderID.SetText(ReceiverName);
	
		if (AccompanyItem.GetItemNum() != 0)
		{
			SendCancelBtn.ShowWindow();
//			SendCancelBtn.EnableWindow();
		}
		else
		{
		//	AddSystemMessage(3030);
			SendCancelBtn.HideWindow();
		}
	}
}

function ClearAll()
{

	SenderID.SetText("");
	PostType.SetText(GetSystemString(2071));
	PostTitle.SetText("");

	PostContents.Clear();
	WeightText.SetText("0");


	ReceiveBtn.HideWindow();
	ReturnBtn.HideWindow();
	SendCancelBtn.HideWindow();
	AccompanyItem.Clear();

}

function OnClickButton( String a_ButtonID )
{

	switch( a_ButtonID )
	{
	case "ReceiveBtn":
		RequestReceivePost(mailID);
		Me.HideWindow();
		break;
	case "ReternBtn":
		if (returnd == 1 || trade == 0 && returnable == 1)
		{
			DialogHide();
			DialogShow(DIALOG_Modalless,DIALOG_OKCancel, GetSystemMessage(3063));
			DialogSetID(DIALOG_RETURN_POST);			
		}
		
		break;
	case "SendCancelBtn":
		RequestCancelSentPost(mailID);
		Me.HideWindow();
		break;
	case "ReplyBtn":
		HandleReplyBtn();
		break;
	//선준 수정(10.03.19)
	case "AddBtn":
		HandleAddBtn();
		break;
	}
}
function HandleDialogOK()
{
	local int id;
	if (DialogIsMine() )
	{
		id = DialogGetID();

	
		if (id == DIALOG_RETURN_POST )
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
	}
}
function HandleReplyBtn()
{
	local PostWriteWnd script;
	local string title;
	
	if (returnd != 1)
	{
		RequestPostItemList();
		script = PostWriteWnd(GetScript("PostWriteWnd"));

		Me.HideWindow();
		title = "[Re]"$ PostTitle.GetText();
		script.SetPostWriteWnd(SenderID.GetText(), title, "");
	}
}
//선준 수정(10.03.19)
function HandleAddBtn()
{
	class'PostWndAPI'.static.RequestAddingPostFriend( SenderID.GetText() );
}
defaultproperties
{
}
