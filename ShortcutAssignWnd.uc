//////////////////////////////////////////////////////////////////////////////////////////////
//  L 2    S H O R T C U T    U S E R    C U S T O M    A S S I G N    W I N D O W
//////////////////////////////////////////////////////////////////////////////////////////////
/* Note

ShortcutAssignWnd is dependent on OptionWnd. The UI module works as a part of OptionWnd tab feature. For the complexity of the system and for the easy maintenance of the source code, it has own separated UC file as listed below.

The UI has two distinctive states. One is normal "shortcut key browse mode" while the other is special "key assign mode".  Two states are exclusive to each other and must be switched by calling LockShortcut(); and  UnlockShortcut();  UI API functions.

Default shortcut Key is assigned by Shortcut.xml datasheet. The datasheet assigns and controls the entire game key settings while this shortcut user custom assign window only allowding users to assign custom keys in "gaming state" at the moment. 

The most challenging part of this system is to control two totally differently behaving gaming state keys as they are divided into "Normal Key Settings" and "Enter Chatting Key Settings". 

UI Designed and UC Programmed by Oxyzen.
UI API Designed and Programmed by Lipsily.

한글 주석, 비행 관련 숏컷 by innowind -_-+
*/

class ShortcutAssignWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////////////////////
//Initialization Header
//////////////////////////////////////////////////////////////////////////////////////////////
/* ---------
 * Constants
 */
const DIALOGID_proc1= 0;
const DIALOGID_proc2= 1;
const DIALOGID_proc3= 2;

/* ----------------
 * Global Variables
 */

/* XML Handles  */
var	WindowHandle 	Me;
var	WindowHandle 	DisableBox;
var	WindowHandle 	GeneralKeyWnd;
var	WindowHandle 	GeneralKeySetting;
var	WindowHandle 	EnterKeySetting;
var	WindowHandle 	CFrameWnd386;
var	WindowHandle 	CFrameWnd385;
var	WindowHandle	EnterkeyWnd;
var 	WindowHandle	OptionWnd;

var	ListCtrlHandle 	GeneralKeyList;
var	ListCtrlHandle 	EnterKeyList;

var	EditBoxHandle 	InputKey;
var	EditBoxHandle 	KeySettingInput;
var	CheckBoxHandle 	Chk_EnterChatting;
var	CheckBoxHandle 	Chk_NewKeySystem;
var	CheckBoxHandle 	AltCheck;
var	CheckBoxHandle 	CtrlCheck;
var	CheckBoxHandle 	ShiftCheck;
var	ButtonHandle 	ResetAllBtn;
var	ButtonHandle 	Btn_AssignCurrent;
//~ var	ButtonHandle 	Btn_ResetCurrent;
var	ButtonHandle 	Btn_OK;
var	ButtonHandle 	Btn_Cancel;
var	ButtonHandle 	Btn_Apply;
var	ButtonHandle 	Btn_SaveCurrentKey;
var	ButtonHandle 	Btn_CancelCurrentKey;
var 	TextBoxHandle	assignShortKeyText;
var 	TextBoxHandle	selectedkeygrouptext;
var 	TextBoxHandle	TextCurrent;
var	TabHandle	Tab_KeyGroup;

var	WindowHandle 	AirKeySetting;		// 비행정 키셋팅 윈도우 추가되었음 - CT2_Final
var	WindowHandle	AirkeyWnd;

var	ListCtrlHandle	AirKeyList;

var	WindowHandle 	AirTransKeySetting;		// 비행변신 키셋팅 윈도우 추가되었음 - CT2_Final
var	WindowHandle	AirTranskeyWnd;

var	ListCtrlHandle	AirTransKeyList;

var	FlightShipCtrlWnd			scriptShip;
var	FlightTransformCtrlWnd		scriptTrans;


/* Key Setting Data  */	// 디폴트 설정 그룹
var array<ShortcutCommandItem> m_DefaultGeneralKeyShortcutList;
var array<ShortcutCommandItem> m_DefaultEnterKeyShortcutList;
var array<ShortcutCommandItem> m_DefaultFlightShortcutList;			// 비행정
var array<ShortcutCommandItem> m_DefaultFlightTransShortcutList;		// 비행 변신체

/* Data Sheets Array  */
var array<string> m_datasheetKeyReplace;
var array<string> m_datasheetKeyReplaced;

/* User Input Key Data  */
var string m_mainkey;
var string m_subkey1;
var string m_subkey2;

/* UIFEature Data  */
var int m_currentListCtrlIndex;

var string m_WindowName;

//////////////////////////////////////////////////////////////////////////////////////////
//Array Data Sheets
//////////////////////////////////////////////////////////////////////////////////////////

function DataSheetAssignKeyReplacement()
/* Referenced by: OnLoad()
 * Description: 
 * 	Datasheet contains key name data to replace system key name to user readable names.
 */
{
	m_datasheetKeyReplace[1]="LEFTMOUSE";
	m_datasheetKeyReplace[2]="RIGHTMOUSE";
	m_datasheetKeyReplace[3]="BACKSPACE";
	m_datasheetKeyReplace[4]="ENTER";
	m_datasheetKeyReplace[5]="SHIFT";
	m_datasheetKeyReplace[6]="CTRL";
	m_datasheetKeyReplace[7]="ALT";
	m_datasheetKeyReplace[8]="PAUSE";
	m_datasheetKeyReplace[9]="CAPSLOCK";
	m_datasheetKeyReplace[10]="ESCAPE";
	m_datasheetKeyReplace[11]="SPACE";
	m_datasheetKeyReplace[12]="PAGEUP";
	m_datasheetKeyReplace[13]="PAGEDOWN";
	m_datasheetKeyReplace[14]="END";
	m_datasheetKeyReplace[15]="HOME";
	m_datasheetKeyReplace[16]="LEFT";
	m_datasheetKeyReplace[17]="UP";
	m_datasheetKeyReplace[18]="RIGHT";
	m_datasheetKeyReplace[19]="DOWN";
	m_datasheetKeyReplace[20]="SELECT";
	m_datasheetKeyReplace[21]="PRINT";
	m_datasheetKeyReplace[22]="PRINTSCRN";
	m_datasheetKeyReplace[23]="INSERT";
	m_datasheetKeyReplace[24]="DELETE";
	m_datasheetKeyReplace[25]="HELP";
	m_datasheetKeyReplace[26]="NUMPAD0";
	m_datasheetKeyReplace[27]="NUMPAD1";
	m_datasheetKeyReplace[28]="NUMPAD2";
	m_datasheetKeyReplace[29]="NUMPAD3";
	m_datasheetKeyReplace[30]="NUMPAD4";
	m_datasheetKeyReplace[31]="NUMPAD5";
	m_datasheetKeyReplace[32]="NUMPAD6";
	m_datasheetKeyReplace[33]="NUMPAD7";
	m_datasheetKeyReplace[34]="NUMPAD8";
	m_datasheetKeyReplace[35]="NUMPAD9";
	m_datasheetKeyReplace[36]="GREYSTAR";
	m_datasheetKeyReplace[37]="GREYPLUS";
	m_datasheetKeyReplace[38]="SEPARATOR";
	m_datasheetKeyReplace[39]="GREYMINUS";
	m_datasheetKeyReplace[40]="NUMPADPERIOD";
	m_datasheetKeyReplace[41]="GREYSLASH";
	m_datasheetKeyReplace[42]="NUMLOCK";
	m_datasheetKeyReplace[43]="SCROLLLOCK";
	m_datasheetKeyReplace[44]="UNICODE";
	m_datasheetKeyReplace[45]="SEMICOLON";
	m_datasheetKeyReplace[46]="EQUALS";
	m_datasheetKeyReplace[47]="COMMA";
	m_datasheetKeyReplace[48]="MINUS";
	m_datasheetKeyReplace[49]="SLASH";
	m_datasheetKeyReplace[50]="TILDE";
	m_datasheetKeyReplace[51]="LEFTBRACKET";
	m_datasheetKeyReplace[52]="BACKSLASH";
	m_datasheetKeyReplace[53]="RIGHTBRACKET";
	m_datasheetKeyReplace[54]="SINGLEQUOTE";
	m_datasheetKeyReplace[55]="PERIOD";
	m_datasheetKeyReplace[56]="MIDDLEMOUSE";
	m_datasheetKeyReplace[57]="MOUSEWHEELDOWN";
	m_datasheetKeyReplace[58]="MOUSEWHEELUP";
	m_datasheetKeyReplace[59]="UNKNOWN16";
	m_datasheetKeyReplace[60]="UNKNOWN17";
	m_datasheetKeyReplace[61]="BACKSLASH";
	m_datasheetKeyReplace[62]="UNKNOWN19";
	m_datasheetKeyReplace[63]="UNKNOWN5C";
	m_datasheetKeyReplace[64]="UNKNOWN5D";
	m_datasheetKeyReplace[65]="UNKNOWN0C";
	m_datasheetKeyReplaced[1]=GetSystemString(1670);
	m_datasheetKeyReplaced[2]=GetSystemString(1671);
	m_datasheetKeyReplaced[3]=GetSystemString(1517);
	m_datasheetKeyReplaced[4]="Enter";
	m_datasheetKeyReplaced[5]="Shift";
	m_datasheetKeyReplaced[6]="Ctrl";
	m_datasheetKeyReplaced[7]="Alt";
	m_datasheetKeyReplaced[8]="Pause";
	m_datasheetKeyReplaced[9]="CapsLock";
	m_datasheetKeyReplaced[10]="ESC";
	m_datasheetKeyReplaced[11]=GetSystemString(1672);
	m_datasheetKeyReplaced[12]="PageUp";
	m_datasheetKeyReplaced[13]="PageDown";
	m_datasheetKeyReplaced[14]="End";
	m_datasheetKeyReplaced[15]="Home";
	m_datasheetKeyReplaced[16]="Left";
	m_datasheetKeyReplaced[17]="Up";
	m_datasheetKeyReplaced[18]="Right";
	m_datasheetKeyReplaced[19]="Down";
	m_datasheetKeyReplaced[20]="Select";
	m_datasheetKeyReplaced[21]="Print";
	m_datasheetKeyReplaced[22]="PrintScrn";
	m_datasheetKeyReplaced[23]="Insert";
	m_datasheetKeyReplaced[24]="Delete";
	m_datasheetKeyReplaced[25]="Help";
	m_datasheetKeyReplaced[26]=GetSystemString(1657);
	m_datasheetKeyReplaced[27]=GetSystemString(1658);
	m_datasheetKeyReplaced[28]=GetSystemString(1659);
	m_datasheetKeyReplaced[29]=GetSystemString(1660);
	m_datasheetKeyReplaced[30]=GetSystemString(1661);
	m_datasheetKeyReplaced[31]=GetSystemString(1662);
	m_datasheetKeyReplaced[32]=GetSystemString(1663);
	m_datasheetKeyReplaced[33]=GetSystemString(1664);
	m_datasheetKeyReplaced[34]=GetSystemString(1665);
	m_datasheetKeyReplaced[35]=GetSystemString(1666);
	m_datasheetKeyReplaced[36]="*";
	m_datasheetKeyReplaced[37]="+";
	m_datasheetKeyReplaced[38]="Separator";
	m_datasheetKeyReplaced[39]="-";
	m_datasheetKeyReplaced[40]=".";
	m_datasheetKeyReplaced[41]="/";
	m_datasheetKeyReplaced[42]="NumLock";
	m_datasheetKeyReplaced[43]="ScrollLock";
	m_datasheetKeyReplaced[44]="Unicode";
	m_datasheetKeyReplaced[45]=";";
	m_datasheetKeyReplaced[46]="=";
	m_datasheetKeyReplaced[47]=",";
	m_datasheetKeyReplaced[48]="-";
	m_datasheetKeyReplaced[49]="/";
	m_datasheetKeyReplaced[50]="`";
	m_datasheetKeyReplaced[51]="[";
	m_datasheetKeyReplaced[52]="";
	m_datasheetKeyReplaced[53]="]";
	m_datasheetKeyReplaced[54]="'";
	m_datasheetKeyReplaced[55]=".";
	m_datasheetKeyReplaced[56]=GetSystemString(1669);
	m_datasheetKeyReplaced[57]=GetSystemString(1667);
	m_datasheetKeyReplaced[58]=GetSystemString(1668);
	m_datasheetKeyReplaced[59]="-";
	m_datasheetKeyReplaced[60]="=";
	m_datasheetKeyReplaced[61]=GetSystemString(1676);
	m_datasheetKeyReplaced[62]=GetSystemString(1673);
	m_datasheetKeyReplaced[63]=GetSystemString(1674);
	m_datasheetKeyReplaced[64]=GetSystemString(1675);
	m_datasheetKeyReplaced[65]=GetSystemString(1677);

}

function bool IsStandAloneKey(String KeyName)
/* Referenced by: OnKeyDown()
* Description: The following keys are alloweded for standalone use.	// 아래 기술된 키 들은 단독으로 사용이 가능하다. 
*	1. true means standalone usable. 
*	2. false means vice-versa to the above.
*/
{
	switch(KeyName)
	{
		case "ESCAPE":
		case "F1":
		case "F2":
		case "F3":
		case "F4":
		case "F5":
		case "F6":
		case "F7":
		case "F8":
		case "F9":
		case "F10":
		case "F11":
		case "F12":
		case "HOME":
		case "END":
		case "PAGEUP":
		case "PAGEDOWN":
		case "DELETE":
		case "TAB":
		case "ALT":
		case "CTRL":
		case "SHIFT":
		return true;
		break;
		default:
		return false;
	}
}


function bool IsValidKey(string KeyName)
/* Referenced by: OnKeyDown()			// 아래 키들은 UI에서 사용할 수 없는 키들이다.
* Description: The following keys are not alloweded to use with the UI so this function validate them and returns bool value with the validity information
*	1. true means valid keys to use. 
*	2. false means invalid keys.
*/
{
	switch(KeyName)
	{
	case "NUMLOCK":
	case "UNKNOWN15":
	case "UNKNOWN19":
	case "UNKNOWN5B":
	case "UNKNOWN5C":
	case "UNKNOWN5D":
	case "UNKNOWN0C":
	case "INSERT":
	case "LEFT":
	case "RIGHT":
	case "UP":
	case "DOWN":
		return false;
		break;
	Default:
		return true;
	}
}


function bool IsReleaseActionItems(string ActionName)
/* Referenced by:
 * Description: 
 * 	Checks the current action item has release functions if so returns true bool value.	// 현재 동작 대기중인 액션이 이동이라면 True를 리턴한다. 
 */
{
	switch (ActionName)
	{
		case "LeftTurn":
		case "RightTurn":
		case "MoveForward":
		case "MoveBackward":
			return true;
			break;
		Default:
			return false;	
	}
}


/////////////////////////////////////////////////////////////////////////////////////////
// Custom Converting Functions
/////////////////////////////////////////////////////////////////////////////////////////

function string MakeUserInputKeyCombinationName(string MainKey, Bool subkeybool1, Bool subkeybool2, Bool subkeybool3)
/* Referenced by: OnKeyDown()			// 조합키의 이름을 만들어내는 함수인듯, (동시에 누르는 것)
 * Description: Converts user viewable arrange ment of the key item's key combination upon user key input and returns string with user readable key combination format.
 */
{
	local string SubKey1;
	local string SubKey2;
	local string SubKey3;
	local string outputtext;
	SubKey1 = "";
	SubKey2 = "";
	SubKey3 = "";
	if (MainKey != "CTRL" ^^ MainKey != "ALT" ^^ MainKey != "SHIFT")
	{
		if (subkeybool3 == true)
			subkey3 = "SHIFT";
		if (subkeybool2 == true)
			subkey2 = "CTRL";
		if (subkeybool1 == true)
			subkey1 ="ALT";
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey2);
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, "");
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey2);
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey3);
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey2, SubKey3);
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey2, "");
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, "", "");
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, "", "");
		return outputtext;
	}
}

function  MakeSystemUserInputKeyCombination(string MainKey, Bool subkeybool1, Bool subkeybool2, Bool subkeybool3)
/* Referenced by: OnKeyDown()
 * Description: Converts System set of key combination to global current key value.	// 입력을 받았을 경우, 위에서 이름을 조합하여 전역변수에 넣어준다.
 */
{
	local string SubKey1;
	local string SubKey2;
	local string SubKey3;
	SubKey1 = "";
	SubKey2 = "";
	SubKey3 = "";
	if (MainKey != "CTRL" ^^ MainKey != "ALT" ^^ MainKey != "SHIFT")
	{
		if (subkeybool3 == true)
			subkey3 = "SHIFT";
		if (subkeybool2 == true)
			subkey2 = "CTRL";
		if (subkeybool1 == true)
			subkey1 ="ALT";
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey2;
		}
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = "";
		}
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey2;
		}
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey3;
		}
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey2;
			m_subkey2 = SubKey3;
		}
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey2;
			m_subkey2 = "";
		}
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = "";
			m_subkey2 = "";
		}
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = "";
			m_subkey2 = "";
		}
	}
}


function String GetShortcutItemNameWithID(int ID)
/* Referenced by: HandleUpdateGeneralKeyListControl()
 * Description: Converts KeySetting ID to Key Name.
 */
{
	local ShortcutScriptData AliasList;
	local string OutName;
	class'ShortcutAPI'.static.RequestShortcutScriptData(ID, AliasList);
	OutName = GetSystemString(AliasList.sysString);
	return OutName;
}

function string MakeFullShortcutKeyCombinationName(string MainKey, string SubKey1, string SubKey2)
/* Referenced by: HandleUpdateGeneralKeyListControl()
 * Description: Returns user readable key setting combination name string with key names.
 */
{
	local string MainKeyOut;
	local string SubKeyOut1;
	local string SubKeyOut2;
	local string OutKey;
	
	MainKeyOut = MainKey;
	SubKeyOut1 = "";
	SubKeyOut2 = "";
	
	Switch(SubKey1)
	{
		case "NONE":
			SubKeyOut1 = "";
			break;
		case "CTRL":
			SubKeyOut1 = "Ctrl + ";
			break;
		case "SHIFT":
			SubKeyOut1 = "Shift + ";
			break;
		case "ALT":
			SubKeyOut1 = "Alt + ";
			break;
		case "":
			SubKeyOut1 = "";
			break;
	}
	
	Switch(SubKey2)
	{
		case "NONE":
			SubKeyOut2 = "";
			break;
		case "CTRL":
			SubKeyOut2 = "Ctrl + ";
			break;
		case "SHIFT":
			SubKeyOut2 = "Shift + ";
			break;
		case "ALT":
			SubKeyOut2 = "Alt + ";
			break;
		case "":
			SubKeyOut2 = "";
			break;
	}
	if (SubKeyOut1 == SubKeyOut2)
	{
		SubKeyOut2 = "";
	}
	OutKey = SubKeyOut1 $ SubKeyOut2 $ GetUserReadableKeyName(MainKeyOut);
	return OutKey;
}

function String GetKeySettingDescriptionWithID(int ID)
/* Referenced by:
 * Description: Returns selected key setting description
 */
{
	local ShortcutScriptData AliasList;
	local string OutName;
	class'ShortcutAPI'.static.RequestShortcutScriptData(ID, AliasList);
	OutName = GetSystemMessage(AliasList.sysMsg);
	return OutName;
}

function String GetUserReadableKeyName(String input)
/* Referenced by: HandleUpdateGeneralKeyListControl()
 * Description: Returns user readable key name with system key names.
 */
{
	local int i;
	local String output;
	for (i= 0 ; i < m_datasheetKeyReplace.Length ; ++i)
	{
		if (m_datasheetKeyReplace[i] == input)
			output = m_datasheetKeyReplaced[i];
	}
	if (output == "")
		output = input;
	return output;
}

//////////////////////////////////////////////////////////////////////////////////////////
//Reserved Function Sets
//////////////////////////////////////////////////////////////////////////////////////////

function OnLoad()
/* Referenced by: Reserved Function
  * Description:
  *  * Initialize default settings upon loading of the script.	// 로드될 때 해야할 일들
  */
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitializeWindowHandles();
	else
		InitializeWindowHandlesCOD();
//	InitializeUIEvents();
	DataSheetAssignKeyReplacement();
	class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", m_DefaultEnterKeyShortcutList);
	class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", m_DefaultGeneralKeyShortcutList);
	class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", m_DefaultFlightShortcutList);	// 비행정 관련 추가
	class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", m_DefaultFlightTransShortcutList);	
	
	scriptShip = FlightShipCtrlWnd ( GetScript("FlightShipCtrlWnd") );
	scriptTrans = FlightTransformCtrlWnd ( GetScript("FlightTransformCtrlWnd") ); 
	
}

function OnClickListCtrlRecord(string ID)
/* Referenced by: Reserved Function
 * Description: 
 * 	On click record on the list control refreshes current selected keys in normal key browsing mode and key setting modes.	
 */
{
	local LVDataRecord Record;
	local int CurrentID;
	local string CurrentCommand;
	local string CurrentMainKey;
	local string CurrentSubkey1;
	local string CurrentSubkey2;

	AssignCurrentSelectedKeyfromtheListCtrl();
	if (Tab_KeyGroup.GetTopIndex() == 0)
		GeneralKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		EnterKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
		AirKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가
		AirTransKeyList.GetSelectedRec(Record);

	CurrentID = Record.LVDataList[0].nReserved1;
	CurrentCommand = Record.LVDataList[5].szData;
	CurrentMainKey = Record.LVDataList[2].szData;
	CurrentSubkey1 = Record.LVDataList[3].szData;
	CurrentSubkey2 = Record.LVDataList[4].szData;
	selectedkeygrouptext.SetText(GetShortcutItemNameWithID(CurrentID));
	TextCurrent.SetText(GetKeySettingDescriptionWithID(CurrentID));
	KeySettingInput.SetString(MakeFullShortcutKeyCombinationName(CurrentMainKey,CurrentSubKey1,CurrentSubKey2));
}



function OnClickButton(string Name)
/* Referenced by: Reserved Function
 * 
 * Description: 
 *  * To assign tasks upon user button click events switching.
 * 
 *  * Every OnClickButton events reset the state into normal shortcut key browse mode.
 * 
 *  * Button Click Behaviours are as follow:
 * 
 * 	1. Default Key Setting Tab Button - "TabCtrl0"
 * 		a. Switches the current showing assign key list ctrl to "GeneralKeyList".
 * 		b. Selects the first record (0) on the assign key list ctrl above. 
 * 
 * 	2. Enter Key Setting Tab Button - "TabCtrl1"
 * 		a. Switches the current showing assign key list ctrl to "EnterKeyList".
 * 		b. Selects the first record (0) on the assign key list ctrl above. 
 * 
 * 	3. Reset All Key Setting to Default - "ResetAllBtn"
 * 
 * 	4. Assign Currently Selected Item on the ListCtrl - "Btn_AssignCurrent".
 * 
 * 	5. Reset Currently Selected Item on the ListCtrl - "Btn_ResetCurrent".
 * 
 * 	6. OK Button on the OptionWnd. - "Btn_OK".
 * 
 * 	7. Cancel Button on the OptionWnd. - "Btn_Cancel".
 * 
 * 	8. Apply Button on the OptionWnd.  - "Btn_Apply".
 * 
 * 	9. Confirm and save the user assigned key  - "Btn_SaveCurrentKey".
 * 		a. Apply the user assigned key to the system.
 * 		b. Switch the UI back into normal shortcut key browse mode.
 * 
 * 	10. Cancel the user key assignment and return to the normal shortcut key browse mode. - "Btn_CancelCurrentKey".
 * 		a. Forget the user assign key if there was any modification.
 * 		b. Switch the UI back into normal shortcut key browse mode.
 */
{
	local string str_reduntedstr;
		
	class'ShortcutAPI'.static.UnlockShortcut();
	switch( Name )
	{
		case "TabCtrl0":
			GeneralKeySetting.ShowWindow();
			HandleUpdateGeneralKeyListControl();
			Switch2KeyBrowsingMode();
			GeneralKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태

		break;
		case "TabCtrl1":
			EnterKeySetting.ShowWindow();
			HandleUpdateEnterKeyListControl();
			Switch2KeyBrowsingMode();
			EnterKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태

		break;
		case "TabCtrl2":	// 비행정 탭을 눌렀을 경우
			AirKeySetting.ShowWindow();	// 비행정 키 셋팅을 보여준다. 
			HandleUpdateAirKeyListControl();	// 비행정 키 컨트롤 리스트 처리
			Switch2KeyBrowsingMode();
			AirKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태
		break;
		case "TabCtrl3":	// 비행정 탭을 눌렀을 경우
			AirTransKeySetting.ShowWindow();	// 비행정 키 셋팅을 보여준다. 
			HandleUpdateAirTransKeyListControl();	// 비행정 키 컨트롤 리스트 처리
			Switch2KeyBrowsingMode();
			AirTransKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태
		break;
		case "ResetAllBtn":
			Switch2KeyBrowsingMode();
			OnResetAllBtnClickPopUpMessage();
		break;
		case "Btn_AssignCurrent":
			Switch2KeyInputMode();
			AssignCurrentSelectedKeyfromtheListCtrl();
		break;
		//~ case "Btn_ResetCurrent":
		//~ break;
		case "Btn_OK":
			HandleResetUI2Default();
			OptionWnd.HideWindow();
			Switch2KeyBrowsingMode();
			class'ShortcutAPI'.static.Save();
		break;
		case "Btn_Cancel":
			HandleResetUI2Default();
			OptionWnd.HideWindow();
			Switch2KeyBrowsingMode();
		break;
		case "Btn_Apply":
			Switch2KeyBrowsingMode();
			class'ShortcutAPI'.static.Save();
		break;
		case "Btn_SaveCurrentKey":
			str_reduntedstr = CheckShortcutItemRedundency();
			if (str_reduntedstr == "")
			{
				DeleteCurrentShortcutItem();
				SetCurrentKeyAsShortKey();
				Switch2KeyBrowsingMode();
				HandleUpdateGeneralKeyListControl();
				HandleUpdateEnterKeyListControl();
				HandleUpdateAirKeyListControl();
				HandleUpdateAirTransKeyListControl();
				if (Tab_KeyGroup.GetTopIndex() == 0)
					GeneralKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
				if (Tab_KeyGroup.GetTopIndex() == 1)
					EnterKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
				if (Tab_KeyGroup.GetTopIndex() == 2)
					AirKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
				if (Tab_KeyGroup.GetTopIndex() == 3)
					AirTransKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
			}
			else	
			{
				DisableBox.ShowWindow();
				DisableBox.SetFocus();
				DialogSetID( DIALOGID_proc3 );
				DialogSetDefaultOK();	
				DialogShow(DIALOG_Modalless, DIALOG_WARNING, MakeFullSystemMsg( GetSystemMessage( 2048 ),  str_reduntedstr) );
			}
			
		break;
		case "Btn_CancelCurrentKey":
			Switch2KeyBrowsingMode();
		break;
	}
}

function OnDBClickListCtrlRecord(string ID)
/* Referenced by: Reserved Function
 * Description: 
 * 	Handles Double Click On the ListCtrl	//리스트 컨트롤을 더블클릭 했을 경우 처리되는 함수
 */
{
	if (ID == "GeneralKeyList" || ID == "EnterKeyList" ||  ID == "AirKeyList"  ||  ID == "AirTransKeyList" )
	{
		Switch2KeyInputMode();
		AssignCurrentSelectedKeyfromtheListCtrl();
	}
}

function OnClickCheckBox( String strID )
// 체크박스를 클릭할때 발생.엔터채팅 체크박스를 위해 처리하지만, 비행정의 경우비활성화 되기 때문에 필요없다.
/* Referenced by: Reserved Function
 * Description: 
 * 	Handles user input checkbox and switch gaming key mode upon GetOptionBool("Game", "EnterChatting"); Data
 */
{
	switch( strID )
	{
		case "Chk_EnterChatting":
			if (Chk_EnterChatting.IsChecked() == true)
			{
				SetOptionBool( "Game", "EnterChatting", true );
				HandleSwitchEnterchatting();
			}
			else
			{
				SetOptionBool( "Game", "EnterChatting", false );
				HandleSwitchEnterchatting();
			}
		break;
	}
}

function OnShow()
/*  Referenced by: Reserved Function
 *  Description: 
 * 	* Initialize Window Handle Objects 
 * 	* Every OnShow() events reset the state into normal shortcut key browse mode.
 *	* Fill EnterKey list control. 
 * 	* Set focus on DisableBox when it is showing.
 */
{
	// Reset Window Handle Objects
	KeySettingInput.HideWindow();
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	// Switch back to Shortcut Key Browsing Mode
	class'ShortcutAPI'.static.UnlockShortcut();
	
	HandleUpdateGeneralKeyListControl();
	HandleUpdateEnterKeyListControl();
	HandleUpdateAirKeyListControl();
	HandleUpdateAirTransKeyListControl();
	
	if (DisableBox.IsShowWindow())
		DisableBox.SetFocus();

	// onShow 이벤트가 발생 했을때, 탭의 현재 위치를 파악해서
	// 각 키보드 정보 리스트를 첫번째가 선택 되도록 세팅 한다.
	switch( Tab_KeyGroup.GetTopIndex() )
	{
		case 0: GeneralKeyList.SetSelectedIndex(0,true);
				break;
		case 1: EnterKeyList.SetSelectedIndex(0,true);
				break;
		case 2: AirKeyList.SetSelectedIndex(0,true);
				break;
		case 3: AirTransKeyList.SetSelectedIndex(0,true);
				break;
	}
}


function OnHide()
/* Referenced by: Reserved Function
 * Description: 
 *  * To initialize and dismiss all the features of the UI upon closing or hiding window.
 *  * Initialize the UI to its normal status in case of it has turned into key assign state. // 1
 */
{
	// 1 
	class'ShortcutAPI'.static.UnlockShortcut();
}

function OnEvent( int a_EventID, String a_Param )
/* Referenced by: Reserved Function
 * Description:
 * 	* Events Handled by this function 
 * 
 * 	1. EV_DialogOK
 * 		a. Handles user reaction from the dialogue input.
 * 	2. EV_DialogCancel
 * 		a. Handles user reaction from the dialogue input.
 * 	3. EV_ShortcutInit
 * 		a. Triggers after event process everytime shortcut key setting is successfully loaded to the system.
 * 	4. EV_StateChanged
 * 		a. Newly added event - triggers some process everytime game state changes. Parameters provided to select proper key settings to be activated.
 * 		b. Everytime the game enters the gaming state, the script loads server stored user key settings and applies it to the current game session.
 * 		c. When switching into gaming state, the script activates shortcut assign UI.
 * 		d. When switching into log-in state, the script deactivates shortcut assign UI to block it.
 */
{
	switch( a_EventID )
	{

		case EV_DialogOK:
			HandleDialogOK();
		break;
		
		case EV_DialogCancel:
			HandleDialogCancel();
		break;
		
		case EV_ShortcutInit:
			//~ debug("OXYZEN: ShortcutInit Received");
			//ResetActivateKeyGroup();
			//~ HandleSwitchEnterchatting();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			//~ class'ShortcutAPI'.static.Save();
			//HandleSwitchEnterchatting();
		break;
		
		case EV_StateChanged:
			switch( a_Param )
			{
				case "GAMINGSTATE":
					//Activate UI.
					//~ KeySettingInput.Clear();
					UIActivationUponStateChanges(true);	// 로그인시 숏컷 할당이 가능하도록 활성화해준다. 
					//ResetActivateKeyGroup();
					HandleSwitchEnterchatting();
					class'ShortcutAPI'.static.RequestList();
					
				break;
				case "LOGINSTATE":
					//Deactivate UI.
					//~ KeySettingInput.Clear();
					UIActivationUponStateChanges(false);
					
				break;
			}
		break;
			
		case EV_ShortcutDataReceived:
			//~ if (Me.IsShowWindow())
			//~ {
				//ResetActivateKeyGroup();
				//~ HandleSwitchEnterchatting();
				HandleUpdateGeneralKeyListControl();
				HandleUpdateEnterKeyListControl();
				HandleUpdateAirKeyListControl();
				HandleUpdateAirTransKeyListControl();
				//HandleSwitchEnterchatting();
			//~ }
		break;
	}
}


function OnKeyDown(WindowHandle a_WindowHandle, EInputKey Key)
/* Referenced by: Reserved Functions
 * Description:  This function is only activated on user key setting mode.  Upon user key input refreshes current keys to modify current selected key item.
 */
{
	local string MainKey;
	local bool subkeybool1;
	local bool subkeybool2;
	local bool subkeybool3;
	subkeybool1 = false;
	subkeybool2 = false;
	subkeybool3 = false;
	if (KeySettingInput.IsShowWindow())
	{
		Me.SetFocus();
		MainKey = class'InputAPI'.static.GetKeyString(Key);
		if (MainKey == "MOUSEY")
		{
			MainKey = "";
			subkeybool3 = false;
			subkeybool2 = false;
			subkeybool1 = false;
			KeySettingInput.Clear();
		}
		else if (IsValidKey(Mainkey))
		{
			
			subkeybool3 = class'InputAPI'.static.IsShiftPressed();
			subkeybool2 = class'InputAPI'.static.IsCtrlPressed();
			subkeybool1 = class'InputAPI'.static.IsAltPressed();

			if (Tab_KeyGroup.GetTopIndex() == 1)
			{
				subkeybool3 = false;
				subkeybool2 = false;
				subkeybool1 = false;
			}
			if (subkeybool3 ^^ !subkeybool2 ^^ !subkeybool1)
				subkeybool3 = false;
			if (Tab_KeyGroup.GetTopIndex() == 0)
			{
				if (!subkeybool1 && !subkeybool2 && !subkeybool3)
				{
					if (IsStandAloneKey(MainKey))
					{
						//debug("OXYZEN: Key Input Value" @ IsStandAloneKey(MainKey) @ subkeybool1@ subkeybool2 @ subkeybool3);
						KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
						MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
					}
					else 
					{
						DisableBox.ShowWindow();
						DisableBox.SetFocus();
						MainKey = "";
						DialogSetID( DIALOGID_proc2 );
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_OK,  GetSystemMessage(2272));
					}
				}
				else
				{
					//debug("OXYZEN: Key Input Value2" @ IsStandAloneKey(MainKey) @ subkeybool1@ subkeybool2 @ subkeybool3);
					KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
					MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
				}
			}
			else
			{
				KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
				MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
			}
		}
	}
}

function HandleDialogOK()
/*  Reserved Function
 *  Description:  
 * 	* Processes with Dialog OK events
*/
{
	if( DialogIsMine() )
	{
		if ( DialogGetID() == DIALOGID_proc1  )
		{
			class'ShortcutAPI'.static.RestoreDefault();
			class'ShortcutAPI'.static.Save();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			ActiveFlightShort();	//비행상태의 숏컷그룹을 액티브해줌
		}
		else if ( DialogGetID() == DIALOGID_proc2  )
		{
			DisableBox.HideWindow();
		}
		else if ( DialogGetID() == DIALOGID_proc3 )
		{
			DeleteCurrentShortcutItem();
			SwapReduntedShortcutItemwithCurrentShortcutItem();
			SetCurrentKeyAsShortKey();
			DisableBox.HideWindow();
			Switch2KeyBrowsingMode();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			if (Tab_KeyGroup.GetTopIndex() == 0)
				GeneralKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
			if (Tab_KeyGroup.GetTopIndex() == 1)
				EnterKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
			if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
				AirKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
			if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가
				AirTransKeyList.SetSelectedIndex(m_currentListCtrlIndex,true);
		}
	}
}

function HandleDialogCancel()
/*  Reserved Function
 *  Description:  
 * 	* Processes Dialog Cancel events
 */
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
		case DIALOGID_proc1:
		case DIALOGID_proc2:
			break;
		case DIALOGID_proc3:
			DisableBox.HideWindow();
			break;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
//Custom Function Sets
/////////////////////////////////////////////////////////////////////////////////////////

function InitializeWindowHandles()
/* Refrence: OnLoad()
 * Description: 
 * 	* Initialize UI Window Handle
 *	윈도우 핸들을 초기화해준다.
 */
{
	CFrameWnd385		=	GetHandle( "CFrameWnd385" );
	CFrameWnd386		=	GetHandle( "CFrameWnd386" );
	DisableBox		=	GetHandle( "DisableBox" );
	GeneralKeyWnd 	= 	GetHandle( "GeneralKeyWnd" );
	Me 				=	GetHandle( "ShortcutTab" );
	EnterKeySetting		=	GetHandle("EnterKeySetting");
	EnterkeyWnd		=	GetHandle("EnterkeyWnd" );
	GeneralKeySetting	=	GetHandle("GeneralKeySetting");
	OptionWnd	=	GetHandle(	"OptionWnd"	);
	Btn_Apply			=	ButtonHandle ( GetHandle( "Btn_Apply" ) );
	Btn_AssignCurrent	=	ButtonHandle ( GetHandle( "Btn_AssignCurrent" ) );
	Btn_Cancel		=	ButtonHandle ( GetHandle( "Btn_Cancel" ) );
	Btn_CancelCurrentKey	=	ButtonHandle ( GetHandle( "Btn_CancelCurrentKey" ) );
	Btn_OK			=	ButtonHandle ( GetHandle( "Btn_OK" ) );
	//~ Btn_ResetCurrent	=	ButtonHandle ( GetHandle( "ShortcutTab.Btn_ResetCurrent" ) );
	Btn_SaveCurrentKey	=	ButtonHandle ( GetHandle( "Btn_SaveCurrentKey" ) );
	ResetAllBtn		=	ButtonHandle ( GetHandle( "ResetAllBtn" ) );
	Chk_EnterChatting	=	CheckBoxHandle ( GetHandle( "Chk_EnterChatting" ) );
	KeySettingInput	=	EditBoxHandle ( GetHandle( "KeySettingInput" ) );
	EnterKeyList		=	ListCtrlHandle ( GetHandle( "EnterKeyList" ) );
	GeneralKeyList		= 	ListCtrlHandle ( GetHandle( "GeneralKeyList" ) );
	assignShortKeyText	=	TextBoxHandle ( GetHandle( "assignShortKeyText" ) );
	selectedkeygrouptext	=	TextBoxHandle ( GetHandle( "selectedkeygrouptext" ) );
	TextCurrent		=	TextBoxHandle ( GetHandle( "TextCurrent" ) );
	Tab_KeyGroup	=	TabHandle( GetHandle(	"TabCtrl"	) );
	
	AirKeySetting		=	GetHandle(m_WindowName$"."$"AirKeySetting");				// 공중용 추가
	AirkeyWnd			=	GetHandle(m_WindowName$"."$"AirKeySetting.AirKeyWnd" );
	AirKeyList			=	ListCtrlHandle( GetHandle (m_WindowName$"."$ "AirKeySetting.AirKeyList" ) );
	
	AirTransKeySetting		=	GetHandle(m_WindowName$"."$"AirTransKeySetting");				// 공중용 추가
	AirTranskeyWnd			=	GetHandle(m_WindowName$"."$"AirTransKeySetting.AirTransKeyWnd" );
	AirTransKeyList			=	ListCtrlHandle( GetHandle (m_WindowName$"."$ "AirTransKeySetting.AirTransKeyList" ) );

}

function InitializeWindowHandlesCOD()
/* Refrence: OnLoad()
 * Description: 
 * 	* Initialize UI Window Handle
 *	핸들 초기화 신버젼!
 */
{
	CFrameWnd385		=	GetWindowHandle( m_WindowName$"."$"CFrameWnd385" );
	CFrameWnd386		=	GetWindowHandle( m_WindowName$"."$"CFrameWnd386" );
	Me 				=	GetWindowHandle( m_WindowName );
	DisableBox			=	GetWindowHandle( m_WindowName$"."$"DisableBox" );
	GeneralKeySetting	=	GetWindowHandle(m_WindowName$"."$"GeneralKeySetting");
	GeneralKeyWnd 		= 	GetWindowHandle( m_WindowName$"."$"GeneralKeySetting.GeneralKeyWnd" );		
	EnterKeySetting		=	GetWindowHandle(m_WindowName$"."$"EnterKeySetting");
	EnterkeyWnd		=	GetWindowHandle(m_WindowName$"."$"EnterKeySetting.EnterkeyWnd" );
	EnterKeyList		=	GetListCtrlHandle (m_WindowName$"."$ "EnterKeySetting.EnterKeyList" );
	
	AirKeySetting		=	GetWindowHandle(m_WindowName$"."$"AirKeySetting");				// 공중용 추가
	AirkeyWnd			=	GetWindowHandle(m_WindowName$"."$"AirKeySetting.AirKeyWnd" );		// 공중용 추가
	AirKeyList			=	GetListCtrlHandle (m_WindowName$"."$ "AirKeySetting.AirKeyList" );		// 공중용 추가
	
	AirTransKeySetting	=	GetWindowHandle(m_WindowName$"."$"AirTransKeySetting");				// 공중용 추가
	AirTranskeyWnd		=	GetWindowHandle(m_WindowName$"."$"AirTransKeySetting.AirTransKeyWnd" );		// 공중용 추가
	AirTransKeyList		=	GetListCtrlHandle (m_WindowName$"."$ "AirTransKeySetting.AirTransKeyList" );		// 공중용 추가
	
	OptionWnd	=	GetWindowHandle(	"OptionWnd"	);
	Btn_Apply			=	GetButtonHandle ( m_WindowName$"."$"Btn_Apply" );
	Btn_AssignCurrent	=	GetButtonHandle (m_WindowName$"."$ "CFrameWnd386.Btn_AssignCurrent" );
	Btn_Cancel		=	GetButtonHandle ( m_WindowName$"."$"Btn_Cancel" );
	Btn_CancelCurrentKey	=	GetButtonHandle ( m_WindowName$"."$"CFrameWnd386.Btn_CancelCurrentKey" );
	Btn_OK			=	GetButtonHandle ( m_WindowName$"."$"Btn_OK" );
	//~ Btn_ResetCurrent	=	ButtonHandle ( "ShortcutTab.Btn_ResetCurrent" );
	Btn_SaveCurrentKey	=	GetButtonHandle ( m_WindowName$"."$"CFrameWnd386.Btn_SaveCurrentKey" );
	ResetAllBtn		=	GetButtonHandle ( m_WindowName$"."$"OptionCheckboxGroup.ResetAllBtn" );
	Chk_EnterChatting	=	GetCheckBoxHandle (m_WindowName$"."$ "OptionCheckboxGroup.Chk_EnterChatting" );
	KeySettingInput	=	GetEditBoxHandle ( m_WindowName$"."$"CFrameWnd386.KeySettingInput" );
	
	
	GeneralKeyList		= 	GetListCtrlHandle ( m_WindowName$"."$"GeneralKeySetting.GeneralKeyWnd.GeneralKeyList" );
	assignShortKeyText	=	GetTextBoxHandle (m_WindowName$"."$ "CFrameWnd386.assignShortKeyText" );
	selectedkeygrouptext	=	GetTextBoxHandle ( m_WindowName$"."$"CFrameWnd386.selectedkeygrouptext" );
	TextCurrent		=	GetTextBoxHandle (m_WindowName$"."$ "CFrameWnd385.TextCurrent" );
	Tab_KeyGroup	=	GetTabHandle(m_WindowName$"."$"TabCtrl"	);
}

function OnRegisterEvent()
/* Referenced by: OnLoad()
 * Description: 
 * 	* Initialize UIEvents to be called during the operation.
 *	처리될 이벤트들을 등록한다. 
 */
{
	registerEvent( 	EV_DialogOK	);
	registerEvent( 	EV_DialogCancel	);
	registerEvent(	EV_ShortcutInit	);
	registerEvent(	EV_StateChanged	);
	registerEvent(	EV_ShortcutDataReceived	);
}

function UIActivationUponStateChanges(bool bTurnOff)
/*  Referenced by: OnEvent() > EV_StateChanged
 *  Description:
 * 	*  Simply switch UI to turn on or to turn off.
 * 	*  When Bool bTurnOff is false, it disables UI and vice versa.
 *	스테이트 별로 숏컷 어사인 자체를 활성화할지 비활성화 할지 결정한다.
 */
{
	if (bTurnOff == false)
	{
		DisableBox.ShowWindow();
		DisableBox.SetFocus();
	}
	else if (bTurnOff == true)
	{
		DisableBox.HideWindow();
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
//	WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//	Don't meddle with activating/deactivating!!!! - lpislhy
/////////////////////////////////////////////////////////////////////////////////////////////////////
//Function ResetActivateKeyGroup()
/* Referenced by: OnClickCheckBox()
 * Description:
 * 	* Reads OptionBool "EnterChatting" and gets the chatting mode setting data.
 * 	* Clear current state key settings first.
 *	* Activate apparant key setting groups.
 *	* Check or CheckBox "Chk_EnterChatting".
 */
//{
		//class'ShortcutAPI'.static.ActivateGroup("CameraControl");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateDefaultShortcut");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateShortcut");	
		//class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		//~ class'ShortcutAPI'.static.ActivateGroup("GamingStateShortcut");	
//}

// 빌더 캐릭터일경우, 빌더 숏컷 그룹을 불러온다.
Function ResetGMKeyActivate()
{
	if( IsBuilderPC() )
		class'ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
	else
		class'ShortcutAPI'.static.DeactivateGroup("GamingStateGMShortcut");
}


// 엔터채팅으로 변경해준다. 
Function HandleSwitchEnterchatting()
/* Referenced by: OnClickCheckBox()
 * Description:
 * 	* Reads OptionBool "EnterChatting" and gets the chatting mode setting data.
 * 	* Clear current state key settings first.
 *	* Activate apparant key setting groups.
 *	* Check or CheckBox "Chk_EnterChatting".
 */
{
	local bool bEnterChat;
	bEnterChat = GetOptionBool("Game", "EnterChatting");
	//~ ResetActivateKeyGroup();
	if (bEnterChat)
	{
		
		class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		Chk_EnterChatting.SetCheck(true);
	}
	else
	{
		class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
		Chk_EnterChatting.SetCheck(false);
	}
}

Function HandleResetUI2Default()
/* Referenced by: OnClickButton()
 * Description: 
 * 	Reset Shortcut UI to the default.
 */
{
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	Btn_AssignCurrent.ShowWindow();
	//~ Btn_ResetCurrent.ShowWindow();
	KeySettingInput.HideWindow();
}

Function HandleUpdateGeneralKeyListControl()
/* Referenced by: OnEvent(), OnClickButton()
 * Description:
 * 	1.Retrieves assigned group key setting data to the global ShortcutCommandItem array m_CurrentGeneralKeyShortcutList.
 *	2.Perform Bubble Sorting with IDs.
 * 	3.Updates key setting data with the above array data.
 *	4.Updates List Control.
 */
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	GeneralKeyList.DeleteAllItem();
	class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;

		if (l_Action == "PRESS")
		{
			GeneralKeyList.InsertRecord( Record );
		}
	
		
		
	}
}

Function HandleUpdateEnterKeyListControl()
/* Referenced by: OnEvent(), OnClickButton()
 * Description:
 * 	1.Retrieves assigned group key setting data to the global ShortcutCommandItem array m_CurrentEnterKeyShortcutList.
 *	2.Perform Bubble Sorting with IDs.
 * 	3.Updates key setting data with the above array data.
 *	4.Updates List Control.
 */
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	EnterKeyList.DeleteAllItem();
	
	class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;
		if (l_Action == "PRESS")
		{
			EnterKeyList.InsertRecord( Record );
		}
	}
}

// 공중 키 컨트롤을 업데이트한다.
Function HandleUpdateAirKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	AirKeyList.DeleteAllItem();
	
	class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
		
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;
		if (l_Action == "PRESS")
		{
			AirKeyList.InsertRecord( Record );
		}
	}
}

// 공중 키 컨트롤을 업데이트한다. // 비행 변신체
Function HandleUpdateAirTransKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	AirTransKeyList.DeleteAllItem();
	
	class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;
		if (l_Action == "PRESS")
		{
			AirTransKeyList.InsertRecord( Record );
		}
	}
}

function OnResetAllBtnClickPopUpMessage()
/* Referenced by: OnClickButton() > ResetAllButton
 * Description: Triggers the dialogue box with system message. 
 */
{
	DialogSetID( DIALOGID_proc1 );
	DialogSetDefaultOK();	
	DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 2152 ) );
}


function AssignCurrentSelectedKeyfromtheListCtrl()
/* Referenced by: OnClickButton() OnClickListCtrlRecord()
 * Description: Put current user selected record from the list control to the user key setting menu form.
 */
{
	local LVDataRecord Record;
	local string CurrentCommand;
	local string CurrentMainKey;
	local string CurrentSubkey1;
	local string CurrentSubkey2;
	local int CurrentID;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		GeneralKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		EnterKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가 
		AirKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가 	// 비행 변신체
		AirTransKeyList.GetSelectedRec(Record);
	CurrentID = Record.LVDataList[0].nReserved1;
	CurrentCommand = Record.LVDataList[5].szData;
	CurrentMainKey = Record.LVDataList[2].szData;
	CurrentSubkey1 = Record.LVDataList[3].szData;
	CurrentSubkey2 = Record.LVDataList[4].szData;
	selectedkeygrouptext.SetText(GetShortcutItemNameWithID(CurrentID));
	TextCurrent.SetText(GetKeySettingDescriptionWithID(CurrentID));
	KeySettingInput.SetString(MakeFullShortcutKeyCombinationName(CurrentMainKey,CurrentSubKey1,CurrentSubKey2));
}

function Switch2KeyInputMode()
/* Referenced by: OnDBClickListCtrlRecord(), OnClickButton() 
* Description: Switch to Key Input Mode   // 키 입력 모드로 변경된다. 입력 모드 상태에서 눌리는 키를 저장
*/
{
	class'ShortcutAPI'.static.LockShortcut();
	KeySettingInput.ShowWindow();
	KeySettingInput.DisableWindow();
	Me.SetFocus();
	Btn_SaveCurrentKey.ShowWindow();
	Btn_CancelCurrentKey.ShowWindow();
	Btn_AssignCurrent.HideWindow();
	//~ Btn_ResetCurrent.HideWindow();
}

function Switch2KeyBrowsingMode()
/* Referenced by: OnClickButton(), OnDBClickListCTrlRecord()
* Description: Reset Key Input mode to normal key browsing mode.		//키 입력모드를 종료하고, 키 브라우징 모드로 변경한다. 
*
*/
{
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	Btn_AssignCurrent.ShowWindow();
	//~ Btn_ResetCurrent.ShowWindow();
	KeySettingInput.HideWindow();
	class'ShortcutAPI'.static.UnlockShortcut();
}

function SetCurrentKeyAsShortKey()
/* Referenced by: OnClickButton(), HandleDialogOK()
 * Description:
 *	1.Performs actual system assignment precedures of shortcut items with user input key combination.
*	2. When the assignment item has a sister with special "release" action and Stop* command, it automatically processes it.
 */
{
	local ShortcutCommandItem item;
	local LVDataRecord Record;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = m_subkey1;
		item.subkey2 =  m_subkey2;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = m_subkey1;
			item.subkey2 =  m_subkey2;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);		// 비행정과 비행변신체를 동시에 바꿔주어야 한다.	
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련	// 비행 변신체
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);		// 비행정과 비행변신체를 동시에 바꿔주어야 한다.
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		}
	}
}

function DeleteCurrentShortcutItem()
/* Referenced by: OnClickButton(), HandleDialogOK()
 * Description:
 * 	1. Delete Current Selected Key Item to Prepare new key setting.
 *	2. When the delete item has a sister with special "release" action and Stop* command, it automatically processes it.
 */
{
	local ShortcutCommandItem item;
	local LVDataRecord Record;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 =  Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = m_mainkey;
			item.subkey1 = m_subkey1;
			item.subkey2 =  m_subkey2;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련	//비행 변신체 관련
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);
		}
	}
}


function string CheckShortcutItemRedundency()
/* Referenced by: OnClickButton()
 * Description: 
 * 	Performs verification to see if any of the current shortcut items have any redundented key combination to the current user input key combination.
 * 		* returns redundented key combination shortcut key item string when it finds any redunted items.
 * 		* returns nothing when there is no redunted items.
 */
{
	local int i;
	local array<ShortcutCommandItem> CurrentShortcutList;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local int l_id;
	local string str_redunteditem;
	
	str_redunteditem = "";
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 수정
		class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 수정
		class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		
		if (m_mainkey == l_key && m_subkey1 == l_subkey1 && m_subkey2 == l_subkey2)
			str_redunteditem = GetShortcutItemNameWithID(l_id) @ "-" @ MakeFullShortcutKeyCombinationName(m_mainkey, m_subkey1, m_subkey2);
	}
	
	return str_redunteditem;
	
}

function SwapReduntedShortcutItemwithCurrentShortcutItem()
/* Referenced by: HandleDialogOK()
 * Description: 
 * 	1. Performs verification to see if any of the current shortcut items have any redundented key combination to the current user input key combination. 
 *	2. If so,  performs swapping procedure with the redundented key with current selected items key combinations.
 *	3. When the swapping item has a sister with special "release" action and Stop* command, it automatically processes it.
 */
{
	local int i;
	local ShortcutCommandItem item;
	local string l_command;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local int l_id;
	local LVDataRecord Record;
	local array<ShortcutCommandItem> CurrentShortcutList;
	
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
		class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가	// 비행 변신체
		class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		
		if (m_mainkey == CurrentShortcutList[i].key && m_subkey1 == CurrentShortcutList[i].subkey1 && m_subkey2 == CurrentShortcutList[i].subkey2 )
		{
			l_command = CurrentShortcutList[i].sCommand;
			l_key = CurrentShortcutList[i].key;
			l_subkey1 = CurrentShortcutList[i].subkey1;
			l_subkey2 = CurrentShortcutList[i].subkey2;
			l_id = CurrentShortcutList[i].id;
			l_Action = CurrentShortcutList[i].sAction;
			break;
		}
	}
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 =  Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 =  Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);
		}
	}
}

// 비행선 or 비행변신 상태일때 해당 숏컷 그룹을 액티브 시켜준다. 
function ActiveFlightShort()
{
	//scriptShip
	//scriptTrans
	if( scriptShip.Me.IsShowWindow())	// 비행정 조종 상태일때	// 비행정 숏컷 그룹을 액티브 해준다. 
	{
		//scriptShip.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//기존 엔터채팅 옵션을 저장해둔다. 		
		SetOptionBool( "Game", "EnterChatting", true );	//강제 엔터 채팅
		Chk_EnterChatting.SetCheck(true);
		Chk_EnterChatting.DisableWindow();			// 디스에이블
			
		class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");		//숏컷 그룹 지정	
		scriptShip.updateLockButton();	// 잠금 상태를 업데이트 한다. 			
			
		scriptShip.ChatEditBox.ReleaseFocus();
	}
	else if( scriptTrans.Me.IsShowWindow())
	{
		//scriptTrans.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//기존 엔터채팅 옵션을 저장해둔다. 		
		
		SetOptionBool( "Game", "EnterChatting", true );	//강제 엔터 채팅
		Chk_EnterChatting.SetCheck(true);
		Chk_EnterChatting.DisableWindow();			// 디스에이블
		
		scriptTrans.updateLockButton();	// 잠금 상태를 업데이트 한다. 
		class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");	//숏컷 그룹 지정
	}
}

defaultproperties
{
    m_WindowName="OptionWnd.ShortcutTab"
}
