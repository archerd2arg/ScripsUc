class RecipeManufactureWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

var int		m_RecipeID;		//RecipeID
var int		m_SuccessRate;		//성공률
var int		m_RecipeBookClass;	//드워프? 일반? 공방
var bool		m_MultipleProduct;
var int		m_MaxMP;
var int		m_PlayerID;

var BarHandle MPBar;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeItemMakeInfo );
	RegisterEvent( EV_UpdateMP );
	
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MPBar = BarHandle( GetHandle( "barMp" ) );
	}
	else
	{
		MPBar = GetBarHandle( "barMp" );
	}
}

function OnEvent(int Event_ID, string param)
{
	local Rect 	rectWnd;
	local int		ServerID;
	local int		MPValue;

	// 2006/07/10 NeverDie
	local int		RecipeID;
	local int		CurrentMP;
	local int		MaxMP;
	local int		MakingResult;
	local int		Type;
	
	if (Event_ID == EV_RecipeItemMakeInfo)
	{
		Debug("EV_RecipeItemMakeInfo.... Do we have it?");
		class'UIAPI_WINDOW'.static.HideWindow("RecipeBookWnd");
		
		Clear();
		
		//윈도우의 위치를 RecipeBookWnd에 맞춤
		rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBookWnd");
		class'UIAPI_WINDOW'.static.MoveTo("RecipeManufactureWnd", rectWnd.nX, rectWnd.nY);
		
		//Show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeManufactureWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd");
		
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CurrentMP", CurrentMP );
		ParseInt( param, "MaxMP", MaxMP );
		ParseInt( param, "MakingResult", MakingResult );
		ParseInt( param, "Type", Type );
		
		ReceiveRecipeItemMakeInfo(RecipeID, CurrentMP, MaxMP, MakingResult, Type);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue);
		if (m_PlayerID==ServerID && m_PlayerID>0)
		{
			SetMPBar(MPValue);
		}
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		HandleInventoryItem(param);
	}
}

function OnClickButton( string strID )
{
	local string param;
	
	switch( strID )
	{
	case "btnClose":
		CloseWindow();
		break;
	case "btnPrev":
		//RecipeBookWnd로 돌아감
		class'RecipeAPI'.static.RequestRecipeBookOpen(m_RecipeBookClass);
		
		CloseWindow();
		break;
	case "btnRecipeTree":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");	
		}
		else
		{
			ParamAdd(param, "RecipeID", string(m_RecipeID));
			ParamAdd(param, "SuccessRate", string(m_SuccessRate));
			ExecuteEvent( EV_RecipeShowRecipeTreeWnd, param);
		}
		break;
	case "btnManufacture":
		class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
		break;
	}
}

//윈도우 닫기
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//초기화
function Clear()
{
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_RecipeBookClass = 0;
	m_MultipleProduct = false;
	m_MaxMP = 0;
	m_PlayerID = 0;
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.ItemWnd");
}

//기본정보 셋팅
function ReceiveRecipeItemMakeInfo(int RecipeID,int CurrentMP,int MaxMP,int MakingResult,int Type)
{
	local int			i;
	
	local string		strTmp;
	local int			nTmp;
	local int			nTmp2;
	
	local int			ProductID;
	local int			ProductNum;
	local string		ItemName;
	
	local string		param;
	local ItemInfo		infItem;
	
	//전역변수 설정
	m_RecipeID = RecipeID;
	m_SuccessRate = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_MultipleProduct = bool(class'UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID));
	m_RecipeBookClass = Type;
	m_MaxMP = MaxMP;
	debug ("MaxMP" @ MaxMP);
	m_PlayerID = class'UIDATA_PLAYER'.static.GetPlayerID();

	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//(아이템)텍스쳐
	strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texItem", strTmp);
	
	//아이템 이름
	ItemName = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon출력)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texGrade", strTmp);
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtName", ItemName);
	
	//MP소비량
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMPConsume", "" $ nTmp);
	
	//성공확률
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtSuccessRate", m_SuccessRate $ "%");
	
	//옵션부여가능여부
	if (m_MultipleProduct)
		class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", GetSystemMessage(2320));
	else
		class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", "");
		
	
	//결과물수
	ProductNum = class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtResultValue", "" $ ProductNum);
	
	//MP바 표시
	SetMPBar(CurrentMP);
	
	//보유갯수
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCountValue", "" $ Int64ToString(GetInventoryItemCount(GetItemID(ProductID))));
	
	//제작결과
	strTmp = "";
	if (MakingResult == 0)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");
	}
	else if (MakingResult == 1)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ ProductNum);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMsg", strTmp);
	
	//ItemWnd에 추가
	param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nTmp);
	for (i=0; i<nTmp; i++)
	{
		//Set ItemID
		ParseInt(param, "ID_" $ i, nTmp2);
		infItem.ID = GetItemID(nTmp2);
		
		//NeedNum
		ParseINT64(param, "NeededNum_" $ i, infItem.Reserved64);	
		infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
		infItem.AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(infItem.ID);
		infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(infItem.ID);
		infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
		infItem.ItemNum = GetInventoryItemCount(infItem.ID);
		if (infItem.Reserved64>infItem.ItemNum)
		{
			infItem.bDisabled = true;
		}
		else 
		{
			infItem.bDisabled = false;
		}
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeManufactureWnd.ItemWnd", infItem);
	}
}

//MP Bar
function SetMPBar(int CurrentMP)
{
	/*
	local int	nTmp;
	local int	nMPWidth;
	
	nTmp = RECIPEWND_MAX_MP_WIDTH * CurrentMP;
	nMPWidth = nTmp / m_MaxMP;
	if (nMPWidth>RECIPEWND_MAX_MP_WIDTH)
	{
		nMPWidth = RECIPEWND_MAX_MP_WIDTH;
	}
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texMPBar", nMPWidth, 12);
	*/
	
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//인벤아이템이 업데이트되면 아이템의 현재보유수를 바꿔준다
function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;
	
	if (ParseItemID( param, cID ))
	{
		idx = class'UIAPI_ITEMWINDOW'.static.FindItem( "RecipeManufactureWnd.ItemWnd", cID);	// ClassID
		if (idx>-1)
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeManufactureWnd.ItemWnd", idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);
			if (infItem.Reserved64>infItem.ItemNum)
				infItem.bDisabled = true;
			else
				infItem.bDisabled = false;
			class'UIAPI_ITEMWINDOW'.static.SetItem( "RecipeManufactureWnd.ItemWnd", idx, infItem);
		}
	}
}
defaultproperties
{
}
