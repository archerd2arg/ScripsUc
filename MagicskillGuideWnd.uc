class MagicskillGuideWnd extends UICommonAPI;

var WindowHandle Me;
var String g_WindowName;
var ButtonHandle btn_01;
var ButtonHandle btn_02;
var ButtonHandle btn_03;
var ButtonHandle btn_04;
var ButtonHandle btn_05;

var TextBoxHandle BtnText_01;
var TextBoxHandle BtnText_02;
var TextBoxHandle BtnText_03;
var TextBoxHandle BtnText_04;
var TextBoxHandle BtnText_05;


var HtmlHandle HtmlViewer_02;

function Initialize()
{
	Me = GetWindowHandle( g_WindowName );
	
	HtmlViewer_02 = GetHtmlHandle(g_WindowName$".HtmlViewer_02");
	btn_01 = GetButtonHandle (g_WindowName$".btn_01");
	btn_02 = GetButtonHandle (g_WindowName$".btn_02");
	btn_03 = GetButtonHandle (g_WindowName$".btn_03");
	btn_04 = GetButtonHandle (g_WindowName$".btn_04");
	btn_05 = GetButtonHandle (g_WindowName$".btn_05");
	
	BtnText_01 = GetTextBoxHandle (g_WindowName$".BtnText_01");
	BtnText_02 = GetTextBoxHandle (g_WindowName$".BtnText_02");
	BtnText_03 = GetTextBoxHandle (g_WindowName$".BtnText_03");
	BtnText_04 = GetTextBoxHandle (g_WindowName$".BtnText_04");
	BtnText_05 = GetTextBoxHandle (g_WindowName$".BtnText_05");
	
	
	
}



function OnLoad()
{
	Initialize();
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide.htm");
	
	BtnText_01.SetText( GetSystemString(2070));
	BtnText_02.SetText(GetSystemString(2069));
	BtnText_03.SetText(GetSystemString(2038)@GetSystemString(2068));
	BtnText_04.SetText(GetSystemString(2097)@GetSystemString(2067));
	BtnText_05.SetText(GetSystemString(2098));
	
}

function OnClickButton( string Name )
{
	switch( Name)
	{
	case "btn_01":
		Onbtn_01Click();
		break;
	case "btn_02":
		Onbtn_02Click();
		break;
	case "btn_03":
		Onbtn_03Click();
		break;
	case "btn_04":
		Onbtn_04Click();
		break;
	case "btn_05":
		Onbtn_05Click();
		break;
	}
}

function Onbtn_01Click()
{
	HtmlViewer_02.Clear();
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide_1.htm");
}

function Onbtn_02Click()
{
	HtmlViewer_02.Clear();
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide_2.htm");
}

function Onbtn_03Click()
{
	HtmlViewer_02.Clear();
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide_3.htm");
}

function Onbtn_04Click()
{
	HtmlViewer_02.Clear();
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide_4.htm");
}

function Onbtn_05Click()
{
	HtmlViewer_02.Clear();
	HtmlViewer_02.LoadHtml("..\\L2text\\skill_enchant_guide_5.htm");
}

function OnHide()
{

}

defaultproperties
{
    g_WindowName="MagicskillGuideWnd"
}
