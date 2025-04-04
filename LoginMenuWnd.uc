class LoginMenuWnd extends UICommonAPI;


var WindowHandle	m_hOptionWnd;
var CharacterPasswordHelpHtmlWnd   CharacterPasswordHelpHtmlWndScript;
var CharacterPasswordWnd           CharacterPasswordWndScript;

function onShow()
{
	// 비밀번호 입력이 혹시 열려 있다면 닫는다.
	// (자동 접속 종료, 암호 틀림 등 상태에서 발행)
	hidePasswordWndAll();
}
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		m_hOptionWnd=GetHandle("OptionWnd");
	else
		m_hOptionWnd=GetWindowHandle("OptionWnd");

	CharacterPasswordHelpHtmlWndScript = CharacterPasswordHelpHtmlWnd( GetScript("CharacterPasswordHelpHtmlWnd") );
	CharacterPasswordWndScript = CharacterPasswordWnd( GetScript("CharacterPasswordWnd") );
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "btnNewAccount" :
		ShowMessageInLogin(GetSystemMessage(1186));
		break;
	case "btnLossAccount" :
		ShowMessageInLogin(GetSystemMessage(1187));
		break;
	case "btnOption" :
		ShowOptionWnd();
		break;
	case "btnCredit" :
		SetUIState("CreditState");
		InitCreditState();
		break;
	case "btnReplay" :
		SetUIState("ReplaySelectState");
		break;
	case "btnHomepage" :
		OpenL2Home();
		break;
	}
}

function ShowOptionWnd()
{
	if (m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
}

// 패스워드 윈도우가 나와 있다면 사라지게 한다.
function hidePasswordWndAll()
{
	 CharacterPasswordHelpHtmlWndScript.Me.HideWindow();
	 CharacterPasswordWndScript.Me.HideWindow();
}
defaultproperties
{
}
