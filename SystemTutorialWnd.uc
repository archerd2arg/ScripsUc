class SystemTutorialWnd extends UICommonAPI;

const TimerValue = 4218763921321939;

var WindowHandle Me;
var Array<ButtonHandle> TutorialBtnWnd;
//~ var ButtonHandle TutorialBtnWnd2;
//~ var ButtonHandle TutorialBtnWnd3;
//~ var ButtonHandle TutorialBtnWnd4;
//~ var ButtonHandle TutorialBtnWnd5;
//~ var ButtonHandle TutorialBtnWnd6;
//~ var ButtonHandle TutorialBtnWnd7;
//~ var ButtonHandle TutorialBtnWnd8;
//~ var ButtonHandle TutorialBtnWnd9;
//~ var ButtonHandle TutorialBtnWnd10;
var WindowHandle SystemTutorialBtnWnd;
var TextBoxHandle TutorialTitle;
var TextBoxHandle TutorialContent;
var ButtonHandle BtnClear;
var int g_nCurrentViewedID;
var Array<int> G_TutorialStr;
var Array<int> G_TutorialText;

var Array<int> iconID;
var Array<int> iconTitle;
var Array<int> iconText;



/////////////////////////////////////////////////////////////////////////////////

function OnEnterState( name a_PrevStateName )
{
	if( a_PrevStateName == 'LoadingState' )			
	{
		SystemTutorialBtnWnd.ShowWindow();
		//~ OnStart();
		//~ debug ("뤌드 로딩");
	}
}

function OnStart()
{
		
	//~ debug("케크시작했음");

//~		OnTutorialCondition(1);
//~		OnTutorialCondition(2);
//~		OnTutorialCondition(3);
//~		OnTutorialCondition(4);
//~		OnTutorialCondition(5);
//~		OnTutorialCondition(6);
//~		OnTutorialCondition(7);
//~		OnTutorialCondition(8);
//~		OnTutorialCondition(9);
//~		OnTutorialCondition(10);
//~		OnTutorialCondition(11);
//~		OnTutorialCondition(22);
//~		OnTutorialCondition(13);
//~		OnTutorialCondition(14);
//~		OnTutorialCondition(15);
//~		OnTutorialCondition(16);
}

///////////////////////////////////////////////////////////////////////////////////






function OnLoad()
{
	Initialize();
	//~ Me.SetAlpha(0);
	//~ Me.Rotate(False,100000);
	g_nCurrentViewedID = 0;

	OnStart();
}






function Initialize()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "SystemTutorialWndViewer" );
		SystemTutorialBtnWnd = GetHandle( "SystemTutorialBtnWnd" );
	}
	else
	{
		Me = GetWindowHandle( "SystemTutorialWndViewer" );
		SystemTutorialBtnWnd = GetWindowHandle( "SystemTutorialBtnWnd" );
	}
	//~ TutorialBtnWnd[1] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial1" ));
	//~ TutorialBtnWnd[2] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial2" ));
	//~ TutorialBtnWnd[3] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial3" ));
	//~ TutorialBtnWnd[4] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial4" ));
	//~ TutorialBtnWnd[5] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial5" ));
	//~ TutorialBtnWnd[6] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial6" ));
	//~ TutorialBtnWnd[7] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial7" ));
	//~ TutorialBtnWnd[8] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial8" ));
	//~ TutorialBtnWnd[9] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial9" ));
	//~ TutorialBtnWnd[10] = ButtonHandle(GetHandle( "SystemTutorialBtnWnd.btnTutorial10" ));
	
	
	//~ TutorialTitle = TextBoxHandle(GetHandle( "TextTitle" ));
	//~ TutorialContent = TextBoxHandle(GetHandle( "TextCurrent" ));
	//~ BtnClear = ButtonHandle(GetHandle( "BtnClear" ));
	
	
	//~ TutorialTitle.SetText("");
	//~ TutorialContent.SetText("");
	
	//~ for (i = 0; i <=10; i++)
	//~ {
		//~ TutorialBtnWnd[i].HideWindow();
		//~ iconID[i] = 0;
		//~ iconTitle[i] = 0;
		//~ iconText[i] = 0;
		
	//~ }
	
	
	FillTutorialList();
}

function OnShow()
{
	//~ Me.SetAlpha(0);
	//~ class'UIAPI_WINDOW'.static.SetUITimer("SystemTutorialWnd", TimerValue,330);
	//~ Me.Rotate(False, 2100);
}

//~ function OnTimer(int TimerID)
//~ {
	//~ if (TimerID==TimerValue)	
	//~ {	
		//~ class'UIAPI_WINDOW'.static.KillUITimer("SystemTutorialWnd", TimerValue);
		//~ Me.SetAlpha(255, 0.2f);
	//~ }
//~ }

function OnHide()
{
	//~ Me.Rotate(False,10000);
	//~ Me.SetAlpha(0);
	ClearCurrentID();
}

function LaunchTutorial(int ID, int Title, int Msg)
{
	if (Me.IsShowWindow()) 
	{
		
		g_nCurrentViewedID = ID;
		ClearCurrentID();
		TutorialTitle.SetText("");
		TutorialContent.SetText("");
		TutorialContent.SetText(GetSystemMessage(Msg));
		//~ debug(GetSystemMessage(Msg));
		
	}
	else
	{
		g_nCurrentViewedID = ID;
		TutorialTitle.SetText("");
		TutorialContent.SetText("");
		TutorialContent.SetText(GetSystemMessage(Msg));
		//~ debug(GetSystemMessage(Msg));
		Me.ShowWindow();
	}
}

function OnClickButton(string BtnName)
{
	//~ debug ("현재 누르는 버튼?"@ BtnName);
	switch(btnName)
	{
		case "BtnClear":
			ClearCurrentID();
			Me.HideWindow();
		break;
	}
}

function ClearCurrentID()
{
	class'TutorialAPI'.static.RequestExSetTutorial( g_nCurrentViewedID );
}

// 튜토리얼 조건 발생 이벤트 처리 함수 
function OnTutorialCondition(int CurrentEvent)
{
	local int i;
	local bool b;
	//~ debug ("데이터 들어옴");
	b = class'UIDATA_TUTORIALLIST'.static.CheckTutorial( CurrentEvent );
	//~ debug ("들어온 데이터:" @ b);
	if ( !b)
	{
		//~ debug("길이:" @ G_TutorialStr.length);
		for (i=1;i<=G_TutorialStr.length;++i)
		{
			
			if (i==CurrentEvent)
			{
				ShowTutorialIcon(i, G_TutorialStr[i], G_TutorialText[i]);
				//~ debug ("데이터 들어옴"@ G_TutorialStr[i] @ G_TutorialText[i]);
			}
		}
	}
}

function ShowTutorialIcon(int a, int b, int c)
{
	local int i;
	//~ local int lastNum;
	local int lastNumber;
	local bool bEnabled;
	//~ lastNum= 0;
	lastNumber = 1;
	
	bEnabled = GetOptionBool( "Game", "SystemTutorialBox" );

	for (i=0;i<=10;i++)
	{
		if ( iconID[i] == 0 )
		{
			
		} 
		else
		{
			lastNumber = i + 1;
		}
	}
	
	iconID[lastNumber] = a;
	iconTitle[lastNumber] = b;
	iconText[lastNumber] = c;
	//~ debug ("입력된 데이터"$ lastNumber @ a @ b @ c );
	TutorialBtnWnd[lastNumber].ShowWindow();
}

function BubbleData(int a)
{
	local int i;
	local int tempint1;
	local int tempint2;
	local int tempint3;
	local int lastnum;
	//~ for (i=1;i<=10;i++)
	//~ {
		//~ debug ("보여지는 데이터 1" @ iconID[i]);
		//~ debug ("보여지는 데이터 2" @ iconTitle[i]);
		//~ debug ("보여지는 데이터 3" @ iconText[i]);
        //~ }
	if (iconID[a] !=0)
	{
		//~ debug ("보여지는 데이터 " @ a);
		LaunchTutorial(iconID[a],iconTitle[a], iconText[a]);
		TutorialBtnWnd[a].HideWindow();
	}
	for (i=a;i<=10;i++)
	{
		tempint1 = iconID[i + 1] ;
		tempint2 = iconTitle[i + 1]; 
		tempint3 = iconText[i + 1];
		iconID[i + 1] = 0;
		iconTitle[i + 1] = 0; 
		iconText[i + 1] = 0;
		iconID[i] = tempint1;
		iconTitle[i] = tempint2;
		iconText[i] = tempint3; 
        }
	
	for (i=0;i<=10;i++)
	{
		if ( iconID[i] == 0 )
		{
			
		} 
		else
		{
			lastnum = i + 1;
		}
	}
	for (i=a;i<=10;i++)
	{
		if (iconID[i] != 0)
		{
			TutorialBtnWnd[i].ShowWindow();
		}
		else 
		{
			TutorialBtnWnd[i].HideWindow();
		}
        }
}
       


function FillTutorialList()	
{	
	G_TutorialStr[1] = 901;
	G_TutorialText[1] =1;
	G_TutorialStr[2] = 902;
	G_TutorialText[2] = 2;
	G_TutorialStr[3] = 903;
	G_TutorialText[3] = 6;
	G_TutorialStr[4] = 904;
	G_TutorialText[4] = 7;
	G_TutorialStr[5] = 905;
	G_TutorialText[5] = 8;
	G_TutorialStr[6] = 906;
	G_TutorialText[6] = 9;
	G_TutorialStr[7] = 907;
	G_TutorialText[7] = 10;
	G_TutorialStr[8] = 908;
	G_TutorialText[8] = 11;
	G_TutorialStr[9] = 909;
	G_TutorialText[9] = 12;
	G_TutorialStr[10] = 910;
	G_TutorialText[10] = 13;
	G_TutorialStr[11] = 911;
	G_TutorialText[11] = 14;
	G_TutorialStr[12] = 912;
	G_TutorialText[12] = 27;
	G_TutorialStr[13] = 913;
	G_TutorialText[13] = 26;
	G_TutorialStr[14] = 914;
	G_TutorialText[14] = 28;
	G_TutorialStr[15] = 915;
	G_TutorialText[15] = 62;
	G_TutorialStr[16] = 916;
	G_TutorialText[16] = 67;
}	
defaultproperties
{
}
