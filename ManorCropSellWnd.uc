class ManorCropSellWnd extends UICommonAPI;


const CROP_NAME=0;
const MANOR_NAME=1;
const CROP_REMAIN_CNT=2;
const CROP_PRICE=3;
const PROCURE_TYPE=4;
const MY_CROP_CNT=5;
const SELL_CNT=6;
const CROP_LEVEL=7;
const REWARD_TYPE_1=8;
const REWARD_TYPE_2=9;

const COLUMN_CNT=10;

var string m_WindowName;
var ListCtrlHandle m_hManorCropSellWndManorCropSellListCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ManorCropSellWndShow );
	RegisterEvent( EV_ManorCropSellWndAddItem );
	RegisterEvent( EV_ManorCropSellWndSetCropSell );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_hManorCropSellWndManorCropSellListCtrl=GetListCtrlHandle(m_WindowName$".ManorCropSellListCtrl");
}

function OnEvent( int Event_ID, string a_Param)
{
	switch( Event_ID )
	{
	case EV_ManorCropSellWndShow :
		if(IsShowWindow("ManorCropSellWnd"))
		{
			HideWindow("ManorCropSellWnd");
		}
		else
		{
			DeleteAll();		
			ShowWindowWithFocus("ManorCropSellWnd");
		}
		break;

	case  EV_ManorCropSellWndAddItem :
		HandleAddItem(a_Param);
		break;
	case EV_ManorCropSellWndSetCropSell :
		HandleSetCropSell(a_Param);
		break;
	}
}

function DeleteAll()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropSellWnd.ManorCropSellListCtrl");
}

function OnDBClickListCtrlRecord( String strID )
{
	switch(strID)
	{
	case "ManorCropSellListCtrl" :
		OnChangeBtn();
		break;
	}
}

function OnClickButton(string strID)
{
	//debug(" "$strID);

	switch(strID)
	{
	case "btnChangeSell" :
		OnChangeBtn();
		break;
	case "btnSell" :
		OnSellBtn();
		break;
	case "btnCancel" :
		HideWindow("ManorCropSellWnd");
		break;
	}
}

function OnSellBtn()
{
	local int RecordCount;
	local LVDataRecord record;
	local INT64 SellCnt;	// 개별 작물의 갯수
	local int CropCnt;	// 판매되는 작물의 갯수
	
	local int CropNum;
	

	local int i;

	local string param;

	RecordCount=m_hManorCropSellWndManorCropSellListCtrl.GetRecordCount();

	// 레코드만큼 돌면서 일단 판매 작물의 갯수를 센다
	CropCnt=0;
	for(i=0; i<RecordCount; ++i)
	{
		m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, record);

		// 판매수량이 있는것만 넣는다
		SellCnt=StringToInt64(record.LVDataList[SELL_CNT].szData);
		if(SellCnt>IntToInt64(0))
			CropCnt++;
	}

	ParamAdd(param, "CropCnt", string(CropCnt));

	CropNum=0;
	// 레코드 수만큼 돌면서 검색해서 넣는다
	for(i=0; i<RecordCount; ++i)
	{
		m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, record );

		// 판매수량이 있는것만 넣는다
		SellCnt=StringToInt64(record.LVDataList[SELL_CNT].szData);
		if(SellCnt<=IntToInt64(0))
			continue;

		ParamAddINT64(param, "CropServerID"$CropNum, record.nReserved3);
		ParamAddINT64(param, "CropID"$CropNum, record.nReserved2);
		ParamAddINT64(param, "ManorID"$CropNum, record.nReserved1);
		ParamAddINT64(param, "SellCount"$CropNum, SellCnt);
		CropNum++;
	}

	//debug("RequestProcureCropList" $ param);
	RequestProcureCropList(param);

	HideWindow("ManorCropSellWnd");
}

function OnChangeBtn()
{
	local LVDataRecord record;
	local int SelectedIndex;
	local int CropID;
	local string ManorCropSellChangeWndString;

	local string param;
	
	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");

	if(SelectedIndex==-1)
		return;

	m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(record);
	CropID=Int64ToInt(record.nReserved2);

	// 서버에 윈도우 열기 요청
	// 원래 문자열 "manor_menu_select?ask=9&state=%d&time=0" <- %d 자리에CropID 가 들어감
	ManorCropSellChangeWndString="manor_menu_select?ask=9&state="$string(CropID)$"&time=0";
	RequestBypassToServer(ManorCropSellChangeWndString);

	// 작물판매량 변경 윈도우에 정보를 보내준다
	ParamAdd(param, "CropName", record.LVDataList[CROP_NAME].szData);
	ParamAdd(param, "RewardType1", record.LVDataList[REWARD_TYPE_1].szData);
	ParamAdd(param, "RewardType2", record.LVDataList[REWARD_TYPE_2].szData);

	ExecuteEvent(EV_ManorCropSellChangeWndSetCropNameAndRewardType, param);
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord record;

	local string CropName;
	local string ManorName;
	local INT64 CropRemainCnt;
	local INT64 CropPrice;
	local int ProcureType;
	local INT64 MyCropCnt;
	local int CropLevel;
	local string RewardType1;
	local string RewardType2;

	local int ManorID;
	local int CropID;
	local int CropServerID;

	record.LVDataList.Length=COLUMN_CNT;

	ParseString(a_Param, "CropName", CropName);
	ParseString(a_Param, "ManorName", ManorName);
	ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
	ParseINT64(a_Param, "CropPrice", CropPrice);
	ParseInt(a_Param, "ProcureType", ProcureType);
	ParseINT64(a_Param, "MyCropCnt", MyCropCnt);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);

	ParseInt(a_Param, "ManorID", ManorID);
	ParseInt(a_Param, "CropID", CropID);
	ParseInt(a_Param, "CropServerID", CropServerID);


//	debug("CropName"$CropName$"ManorName"$ManorName$"CropRemainCnt"$CropRemainCnt$"CropPrice"$CropPrice$"ProcureType"$ProcureType$"MyCropCnt"$MyCropCnt);

	record.LVDataList[CROP_NAME].szData=CropName;
	record.LVDataList[MANOR_NAME].szData=ManorName;
	record.LVDataList[CROP_REMAIN_CNT].szData=Int64ToString(CropRemainCnt);
	record.LVDataList[CROP_PRICE].szData=Int64ToString(CropPrice);
	record.LVDataList[PROCURE_TYPE].szData=string(ProcureType);
	record.LVDataList[MY_CROP_CNT].szData=Int64ToString(MyCropCnt);
	record.LVDataList[SELL_CNT].szData="0";
	record.LVDataList[CROP_LEVEL].szData=string(CropLevel);
	record.LVDataList[REWARD_TYPE_1].szData=RewardType1;
	record.LVDataList[REWARD_TYPE_2].szData=RewardType2;
	record.nReserved1=IntToInt64(ManorID);
	record.nReserved2=IntToInt64(CropID);
	record.nReserved3=IntToInt64(CropServerID);

	class'UIAPI_LISTCTRL'.static.InsertRecord( "ManorCropSellWnd.ManorCropSellListCtrl", record );
}

function HandleSetCropSell(string a_Param)
{
	local string SellCntString;
	local int ManorID;
	local string ManorName; 
	local string CropRemainCntString;
	local string CropPriceString;
	local string ProcureTypeString;
	local int SelectedIndex;

	local LVDataRecord record;

	ParseString(a_Param, "SellCntString", SellCntString);
	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);
	ParseString(a_Param, "CropRemainCntString", CropRemainCntString);
	ParseString(a_Param, "CropPriceString", CropPriceString);
	ParseString(a_Param, "ProcureTypeString", ProcureTypeString);

	m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(record);

	record.LVDataList[MANOR_NAME].szData=ManorName;
	record.LVDataList[CROP_REMAIN_CNT].szData=CropRemainCntString;
	record.LVDataList[CROP_PRICE].szData=CropPriceString;
	record.LVDataList[PROCURE_TYPE].szData=ProcureTypeString;
	record.LVDataList[SELL_CNT].szData=SellCntString;
	record.nReserved1=IntToInt64(ManorID);

	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");

	class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropSellWnd.ManorCropSellListCtrl", SelectedIndex, record);
}

defaultproperties
{
    m_WindowName="ManorCropSellWnd"
}
