class AITimerWnd extends UIScriptEx;
//~ const MAX_GAME_TIME_MIN = 20;
const TIMER_ID_COUNTDOWN=2025;
const TIMER_ID_COUNTUP=2026;// 타이머아디 수정 해줘야 하지 않나 ???
const TIMER_DELAY=1000;

var WindowHandle Me,MEBtn;
var TextBoxHandle txtAITimerObject,MinTxt,SecTxt, DividerTxt;
var int UserID,EventID,ASK,Reply,Min, Sec, CurMin, CurSec, TargetMin, TargetSec;
var int TempMin,TempSec;
var string param1,param2,param3,param4,param5,param6;
var string MinStr, SecStr;
var bool m_InGameBool;

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me 	= 		GetHandle("AITimerWnd");
		MinTxt	= 	TextBoxHandle(GetHandle("AITimerWnd.MinTxt"));
		SecTxt	=	TextBoxHandle(GetHandle("AITimerWnd.SecTxt"));
		DividerTxt 	= 	TextBoxHandle(GetHandle("AITimerWnd.DividerTxt"));
		txtAITimerObject = TextBoxHandle(GetHandle("AITimerWnd.txtAITimerObject"));
	}
	else
	{
		Me 	= 		GetWindowHandle("AITimerWnd");
		MinTxt	= 	GetTextBoxHandle("AITimerWnd.MinTxt");
		SecTxt	=	GetTextBoxHandle("AITimerWnd.SecTxt");
		DividerTxt 	= 	GetTextBoxHandle("AITimerWnd.DividerTxt");
		txtAITimerObject = GetTextBoxHandle("AITimerWnd.txtAITimerObject");
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_AITimer);
}


function OnEvent(int Event_ID, string param)
{
	//~ local int StatusInt;
	switch(Event_ID)
	{
		case EV_AITimer:
		//debug ("AITimerEvent" @ Param);
		HandleAIController(Param);
		break;
		

		
	}
}

//카운트가 또 불렸을때 기존의 것을 죽여야 한다.

function HandleAIController(string Param)
{
	local string Param1, Param2, Param3, Param4;
	local int EventID;
	local int intTimerDelay;
	
	//Debug("How Param composed of :" @ Param);
	ParseString(Param, "Param1", Param1);	//카운트다운인지 업인지	
	ParseString(Param, "Param2", Param2); //카운트 시작하는 분?
	ParseString(Param, "Param3", Param3); //카운트 시작하는 초
	ParseString(Param, "Param4", Param4); //보여주는 스트링
	ParseString(Param, "Param5", Param5); //카운트 종료되는 분?
	ParseString(Param, "Param6", Param6); //카운트 종료되는 초
	Parseint(Param, "EventID", EventID) ;   //이벤트 아이디 - 이 이벤트아이디로 시작/정지/일시중지/일시정지 후 다시 시작인지 판단

	Min = 0;
	Sec = 0;
	CurMin = 0;
	CurSec = 0;
	TargetMin = 0;
	TargetSec = 0;
	
	if (EventID== 0)
	{
		switch (Param1)
		{
			case "0":
				//Debug("Startcountdown" @ Param);
				Me.KillTimer( TIMER_ID_COUNTDown );
				StartCountDown(int(Param2), int(Param3), Param4, int(Param5), int(Param6));
			break;
			case "1":
				Me.KillTimer( TIMER_ID_COUNTUP );
				StartCountUp(int(Param2), int(Param3), Param4 , int(Param5), int(Param6));
			break;
		}
	}
	else if (EventID == 1) // 정지
	{
		switch (Param1)
		{
			case "0":
				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTDown );
			break;
			case "1":

				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTUP );
			break;
		}
		
		//LaunchTimer(Param1, Param4);
		
	
	}
	else if (EventID == 2) // 일시 중지
	{

		TempMin = Min ;
		TempSec = Sec ;
		Me.KillTimer( TIMER_ID_COUNTDOWN );
				
				
	}
	
	else if (EventID == 3) // 일시 중지 후 다시 시작
	{
		switch (Param1)
		{
			case "0":
				
				Min = TempMin ;
				Sec = TempSec + 1 ;
				//Me.KillTimer( TIMER_ID_COUNTDOWN );
				TimerReset( Min,  Sec);
				//txtAITimerObject.SetText(strDisplayTxt);
				intTimerDelay = ((Min*60)+sec)*100;
				//Debug("Converted Milisecond" @ intTimerDelay);
				Me.ShowWindow();
				Me.SetTimer(TIMER_ID_COUNTDOWN,TIMER_DELAY);
								
				
			break;
			case "1":
				
				CurMin = TempMin ;
				CurSec = TempSec - 1;
				//Me.KillTimer( TIMER_ID_COUNTUP );
				TimerReset(CurMin, CurSec);
				//txtAITimerObject.SetText(strDisplayTxt);
				intTimerDelay = ((Min*60)+sec)*100;
				//Debug("Converted Milisecond" @ intTimerDelay);
				Me.ShowWindow();
				Me.SetTimer(TIMER_ID_COUNTUP,TIMER_DELAY);


				
			break;
		}
		//ResumeTimer();
	}
}

/*function LaunchTimer(string TimerID,string strDisplayTxt)      //시간 초기화 하고 셋해주는 것
{
	if (TimerID == "0")
	{
	    	TimerReset( MIn,  Sec);
		txtAITimerObject.SetText(strDisplayTxt);
	}
	
	else if (TimerID == "1")
	{
		TimerReset(0, 0);
		txtAITimerObject.SetText(strDisplayTxt);
		
	}
	
	
}*/

/*function PauseTimer(int Min, int Sec) 
{
	if (EventID == 2)
	{
		Min = Min;
		Sec = Sec;
		Me.KillTimer( TIMER_ID_COUNTUP );
		Me.KillTimer( TIMER_ID_COUNTDOWN );
	}
}*/

function OnTimer(int TimerID) 
{
	//Debug("Min" @min @ "Sec" @ Sec);
	if(TimerID == TIMER_ID_COUNTDOWN)
	{
		//Debug("TimerCOUNTDOWN");
		if (Min == TargetMin && Sec < 10)
		{
			MinTxt.HideWindow();
			SecTxt.HideWindow();
			DividerTxt.HideWindow();
			txtAITimerObject.HideWindow();
			Me.KillTimer( TIMER_ID_COUNTDOWN );
		}
		else
		{
			txtAITimerObject.ShowWindow();
			MinTxt.ShowWindow();
			SecTxt.ShowWindow();
			DividerTxt.ShowWindow();
			UpdateTimerCountDown();
		}
	}
	
	else if (TimerID == TIMER_ID_COUNTUP)
	{
		//Debug("TimerCOUNTUP");
		if(TargetSec < 11)
			{	
			 Debug("TargetMin"@TargetMin@"Min"@ Min @ "Sec"@ Sec);
			if (Min == TargetMin -1 && ((TargetSec+60)-Sec) < 10)
			
				{
					MinTxt.HideWindow();
					SecTxt.HideWindow();
					DividerTxt.HideWindow();
					txtAITimerObject.HideWindow();
					Me.KillTimer( TIMER_ID_COUNTUP );
				}
			else
				{
					txtAITimerObject.ShowWindow();
					MinTxt.ShowWindow();
					SecTxt.ShowWindow();
					DividerTxt.ShowWindow();
					UpdateTimerCountUp();
				}
		}
		
		
		else
		{
			if (Min == TargetMin && (TargetSec-Sec) < 10)
			{
				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTUP );
			}
			else
			{
				txtAITimerObject.ShowWindow();
				MinTxt.ShowWindow();
				SecTxt.ShowWindow();
				DividerTxt.ShowWindow();
				UpdateTimerCountUp();
			}
		}
		

	}
}

function UpdateTimerCountDown()   //시간을 카운트 다운 업데이트 시켜준다
{
	MinStr = String(Min);
	SecStr = String(Sec);
		
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	
	if (Sec == 0)
	{
		Sec = 59;
		Min = Min -1;
	} 
	else 
	{
		Sec = Sec -1;
	}
}

function UpdateTimerCountUp()   //시간을 카운터 업 업데이트 시켜준다
{
	MinStr = String(Min);
	SecStr = String(Sec);
		
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	
	if (Sec == 59)
	{
		Sec = 0;
		Min = Min +1;
	} 
	else 
	{
		Sec = Sec +1;
	}
}

function TimerReset(int CurMin, int CurSec)
{
	//~ Min = MAX_GAME_TIME_MIN;
	//Sec = 0;
	Min = CurMin;
	Sec = CurSec;
	
	MinStr = String(Min);
	SecStr = String(Sec);
	
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	m_InGameBool = true;
}


function StartCountDown(int CurMin, int CurSec, string strDisplayTxt , int TMin , int TSec)
{
	local int intTimerDelay;
	
      CurMin = CurMin ;
	CurSec = CurSec ;
	TargetMin = TMin;
	TargetSec = TSec;
	
	TimerReset( CurMin,  CurSec);

	txtAITimerObject.SetText(strDisplayTxt);
	intTimerDelay = ((Min*60)+sec)*100;
	//Debug("Converted Milisecond" @ intTimerDelay);
	Me.ShowWindow();
	//debug("Startcountdown"@ TIMER_ID_COUNTDOWN);
	Me.SetTimer(TIMER_ID_COUNTDOWN,TIMER_DELAY);
}


function StartCountUp(int CurMin, int CurSec, string strDisplayTxt , int TMin , int TSec)
{
	local int intTimerDelay;

        CurMin = CurMin ;
	CurSec = CurSec ;
	TargetMin = TMin;
	TargetSec = TSec;
	
	Debug("TargetMin"@TargetMin);
	TimerReset(CurMin, CurSec);
	txtAITimerObject.SetText(strDisplayTxt);
	intTimerDelay = ((Min*60)+sec)*100;
	//Debug("Converted Milisecond" @ intTimerDelay);
	Me.ShowWindow();
	Me.SetTimer(TIMER_ID_COUNTUP,TIMER_DELAY);
}

function OnHide()
{
	Me.KillTimer( TIMER_ID_COUNTUP );
	Me.KillTimer( TIMER_ID_COUNTDOWN );
}
defaultproperties
{
}
