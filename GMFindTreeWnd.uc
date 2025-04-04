class GMFindTreeWnd extends UICommonAPI;

var WindowHandle  Me;
var array<String> m_ComboList;
var String m_WindowName;
var bool bSummon;
var bool bShow;	// GM창에서 버튼을 한번 더 누르면 사라지게 하기 위한 변수
var Color Gold;

var ListCtrlHandle	m_hFindTreeList;

var EditBoxHandle	m_hEdSummonCnt;

function OnLoad()
{
	Me = GetWindowHandle("GMFindTreeWnd");
	m_hFindTreeList=GetListCtrlHandle(m_WindowName $ ".ListFindWnd");
	m_hEdSummonCnt=GetEditBoxHandle(m_WindowName$".edSummonCnt");

	bSummon = false;
	bShow = false;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	/*	case EV_ShowItem:
		break;
		case EV_ShowSkill:
		break;
	*/
	}
}

function ShowSkillList( String a_Param )
{
	if( a_Param == "" )
		return;
	
	Me.HideWindow();
	FindAllSkill( a_Param );
	Me.ShowWindow();
	Me.SetFocus();

	bSummon = false;
}

function ShowNPCList( String a_Param )
{
	if( a_Param == "" )
		return;
	
	Me.HideWindow();
	FindAllNPC( a_Param );
	Me.ShowWindow();
	Me.SetFocus();	

	bSummon = true;
}

function ShowItemList( String a_Param )
{
	if( a_Param == "" )
		return;

	Me.HideWindow();
	FindAllItem( a_Param );
	Me.ShowWindow();
	Me.SetFocus();

	bSummon = true;
}


function FindAllSkill( String a_Param )
{
	local ItemID cID;
	local int itemID;
	local String fullNameString;
	local LVDataRecord record;

	local string modifiedString;
	local string modifiedParam;

	if ( a_Param == "" )
		return;
	m_ComboList.Remove(0, m_ComboList.Length);
	
	itemID = 0;
	record.LVDataList.Length = 2;
	ClearList();

	modifiedParam=Substitute(a_Param, " ", "", FALSE);

	for ( cID = class'UIDATA_SKILL'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_SKILL'.static.GetNextID() )
	{
		fullNameString = class'UIDATA_SKILL'.static.GetName( cID, 1 );

		modifiedString=Substitute(fullNameString, " ", "", FALSE);

		if ( InStr( modifiedString , modifiedParam ) != -1 )
		{
			record.LVDataList[0].buseTextColor = True;
			record.LVDataList[0].szData = fullNameString;
			record.LVDataList[0].TextColor = Gold;
			record.LVDataList[1].szData= string(cID.ClassID);
			record.LVDataList[1].TextColor = Gold;
		
			m_hFindTreeList.InsertRecord(record);
		}
	}
}

function FindAllNPC( String a_Param )
{
	local int ID;
	local int itemID;
	local String fullNameString;
	local LVDataRecord record;

	local string modifiedString;
	local string modifiedParam;

	if ( a_Param == "" )
		return;
	m_ComboList.Remove(0, m_ComboList.Length);
	
	itemID = 0;
	record.LVDataList.Length = 2;
	ClearList();

	modifiedParam=Substitute(a_Param, " ", "", FALSE);
	for( ID = class'UIDATA_NPC'.static.GetFirstID(); -1 != ID ; ID = class'UIDATA_NPC'.static.GetNextID() )
	{
		fullNameString  = class'UIDATA_NPC'.static.GetNPCName( ID );

		modifiedString=Substitute(fullNameString, " ", "", FALSE);

		if ( InStr( modifiedString , modifiedParam ) != -1 )
		{
			record.LVDataList[0].buseTextColor = True;
			record.LVDataList[0].szData = fullNameString;
			record.LVDataList[0].TextColor = Gold;
			record.LVDataList[1].szData= string(ID + 1000000);
			record.LVDataList[1].TextColor = Gold;
				
			m_hFindTreeList.InsertRecord(record);
		}
	}
}
function FindAllItem( String a_Param )
{
	local ItemID cID;
	local int itemID;
	local String fullNameString;
	local String additionalName;
	local LVDataRecord record;
	local int itemNameClass;
	local string modifiedString;
	local string modifiedParam;

	if ( a_Param == "" )
		return;

	m_ComboList.Remove(0, m_ComboList.Length);
	
	itemID = 0;

	record.LVDataList.Length = 2;
	ClearList();
	
	modifiedParam=Substitute(a_Param, " ", "", FALSE);
	for ( cID = class'UIDATA_ITEM'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_ITEM'.static.GetNextID() )
	{
		fullNameString  = class'UIDATA_ITEM'.static.GetItemName( cID );

		modifiedString=Substitute(fullNameString, " ", "", FALSE);

		if ( InStr( modifiedString  , modifiedParam ) != -1 )
		{
			itemNameClass = class'UIDATA_ITEM'.static.GetItemNameClass( cID);			
			additionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName( cID );
			if (itemNameClass == 0)		 //보급형 아이템 
			{
				fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
			}
			else if (itemNameClass == 2) //희귀한 아이템
			{
				fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
			}
			if (Len(additionalName) > 0 )
			{
				fullNameString = fullNameString $ "(" $ additionalName $ ")";
			}
			m_ComboList[itemID] = fullNameString;
			
			record.LVDataList[0].buseTextColor = True;
			record.LVDataList[0].szData = m_ComboList[itemID];
			record.LVDataList[0].TextColor = Gold;
			record.LVDataList[1].szData = string(cID.ClassID);
			record.LVDataList[1].TextColor = Gold;
			
			m_hFindTreeList.InsertRecord(record);
			itemID++;

		}
	}

}

function OnDBClickListCtrlRecord( string ListCtrlID)
{
	summon(1);
}

function Summon(int cnt)
{
	local LVDataRecord record;
	record.LVDataList.Length = 2;

	if( GetSelectedListCtrlItem( record ) )
	{
		if ( record.LVDataList[1].szData != "")
		{
			if( bSummon )
				ProcessChatMessage("//summon"@record.LVDataList[1].szData$" "$string(cnt), 0);
			else
				ProcessChatMessage("//setskill"@record.LVDataList[1].szData$" "$string(cnt), 0);
		}
	}
}

function OnClickListCtrlRecord( String strID )
{
	m_hEdSummonCnt.SetString("1");
}

function OnClickButton( string strID )
{
	local string summonCnt;

	switch( strID )
	{
	case "btnSummon":
		summonCnt=m_hEdSummonCnt.GetString();
		Summon(int(summonCnt));
		break;
	}
}



function bool GetSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;
	index = m_hFindTreeList.GetSelectedIndex();
	if( index >= 0 )
	{
		m_hFindTreeList.GetRec(index, record);
		return true;
	}
	return false;
}

// List related operations
function ClearList()
{
	m_hFindTreeList.DeleteAllItem();
}
defaultproperties
{
    m_WindowName="GMFindTreeWnd"
}
