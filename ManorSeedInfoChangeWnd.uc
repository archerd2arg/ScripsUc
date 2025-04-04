class ManorSeedInfoChangeWnd extends UICommonAPI;


var INT64 m_MinCropPrice;
var INT64 m_MaxCropPrice;
var INT64 m_TomorrowLimit;

function OnRegisterEvent()
{
	RegisterEvent( EV_ManorSeedInfoChangeWndShow );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnEvent( int Event_ID, string a_Param)
{
	switch( Event_ID )
	{
	case EV_ManorSeedInfoChangeWndShow :
		HandleShow(a_Param);
		break;
	}
}

function HandleShow(string a_Param)
{
	local string SeedName;
	local INT64 TomorrowVolumeOfSales;
	local INT64 TomorrowLimit;
	local INT64 TomorrowPrice;
	local INT64 MinCropPrice;
	local INT64 MaxCropPrice;

	local string TomorrowLimitString;


	ParseString(a_Param, "SeedName", SeedName);							// 씨앗이름
	ParseINT64(a_Param, "TomorrowVolumeOfSales", TomorrowVolumeOfSales);	// 내일 판매량
	ParseINT64(a_Param, "TomorrowLimit", TomorrowLimit);					// 내일 발매한도
	ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);					// 내일 가격

	ParseINT64(a_Param, "MinCropPrice", MinCropPrice);						// 최소작물가격
	ParseINT64(a_Param, "MaxCropPrice", MaxCropPrice);						// 최대작물가격

	class'UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtSeedName", SeedName);
	class'UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume", Int64ToString(TomorrowVolumeOfSales));

	m_TomorrowLimit=TomorrowLimit;
	TomorrowLimitString=MakeCostString(Int64ToString(TomorrowLimit));
	class'UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtVarTomorrowLimit", TomorrowLimitString);
	class'UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowPrice", Int64ToString(TomorrowPrice));

	m_MinCropPrice=MinCropPrice;
	m_MaxCropPrice=MaxCropPrice;

	ShowWindowWithFocus("ManorSeedInfoChangeWnd");
	class'UIAPI_WINDOW'.static.SetFocus("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume");
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "btnOk" :
		OnClickBtnOk();
		break;
	case "btnCancel" :
		HideWindow("ManorSeedInfoChangeWnd");
		break;
	}
}

function OnClickBtnOk()
{
	local INT64 InputTomorrowSalesVolume;
	local INT64 InputTomorrowPrice;

	local string ParamString;
	
	InputTomorrowSalesVolume=StringToInt64(class'UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume"));
	InputTomorrowPrice=StringToInt64(class'UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowPrice"));

	if(InputTomorrowSalesVolume < IntToInt64(0) || InputTomorrowSalesVolume > m_TomorrowLimit)
	{	
		ShowErrorDialog(IntToInt64(0), m_TomorrowLimit, 1558);	
		return;
	}

	if(InputTomorrowSalesVolume !=IntToInt64(0)&& (InputTomorrowPrice < m_MinCropPrice || InputTomorrowPrice > m_MaxCropPrice))
	{
		ShowErrorDialog(m_MinCropPrice, m_MaxCropPrice, 1557);
		return;
	}

	ParamAddINT64(ParamString, "TomorrowSalesVolume", InputTomorrowSalesVolume);
	ParamAddINT64(ParamString, "TomorrowPrice", InputTomorrowPrice);
	ExecuteEvent(EV_ManorSeedInfoSettingWndChangeValue, ParamString);

	HideWindow("ManorSeedInfoChangeWnd");
}


function ShowErrorDialog(INT64 MinValue, INT64 MaxValue, int SystemStringIdx)
{
	local string ParamString;
	local string Message;

	ParamAdd(ParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
	ParamAddINT64(ParamString, "param1", MinValue);
	AddSystemMessageParam(ParamString);
	ParamString="";
	ParamAdd(ParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
	ParamAddINT64(ParamString, "param1", MaxValue);
	AddSystemMessageParam(ParamString);
	Message = EndSystemMessageParam(SystemStringIdx, true);

	DialogShow(DIALOG_Modalless, DIALOG_Notice, Message );
}
defaultproperties
{
}
