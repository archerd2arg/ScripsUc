class MinimapWnd extends UICommonAPI;

const REGIONINFO_OFFSETX = 225;
const REGIONINFO_OFFSETY = 400;
const TIMER_ID=225;
const TIMER_DELAY=30000;

var int m_PartyMemberCount;
var int m_PartyLocIndex;
var int b_IsShowGuideWnd;
var bool m_AdjustCursedLoc;

var int m_SSQStatus;				// 세븐사인상태가지고 있는 변수
var bool m_bShowSSQType;			// 세븐사인 상태 보여줄것인가를 기억하는 변수
var bool m_bShowCurrentLocation;		// 현재위치 보여줄것인가를 기억하는 변수
var bool m_bShowGameTime;			// 현재시간 보여줄것인가를 기억하는 변수
var bool bHaveItem;					//아이템 소지여부
var bool bMiniMapDisabled;			//미니맵 사용 불가 세팅
var bool m_bExpandState;
var Vector BlockedLoc1;
var Vector BlockedLoc2;

var int FortressID;
var int SiegeStatus;
var int TotalBarrackCnt;
var int GlobalCurFortressID;
var int G_ZoneID;
var int G_ZoneID2;
var bool GlobalCurFortressStatus;
var string m_combocursedName;
var bool m_Dominion;
var int m_CurContinent;

var WindowHandle 	me;
var WindowHandle 	m_hExpandWnd;
var WindowHandle 	m_hGuideWnd;
var ItemWindowHandle	m_questItem;
var MinimapCtrlHandle 	m_MiniMap;
//~ var MinimapCtrlHandle 	m_MiniMap_Expand;
var ButtonHandle 	Btn_Refresh;
var ButtonHandle 	Btn_Refresh_Expand;
var ButtonHandle 	ReduceButton;
var ButtonHandle 	ReduceButton_Expand;
var TextBoxHandle	m_textSSQ;
var TextBoxHandle	m_textSSQStatus;
var TextBoxHandle	m_textSSQ_Expand;
var TextBoxHandle	m_textSSQStatus_Expand;
var TabHandle 		m_MapSelectTab;
var WindowHandle	CleftCurTriggerWnd;
//~ var TabHandle		m_MapSelectTabExpand;
var ListCtrlHandle ListTrackItem3;

var ListCtrlHandle ListTrackItem2;

var Array<int> loc_fortress;
var Array<int> loc_component;
var Array<int> loc_sysstr;
var Array<int> loc_xloc;
var Array<int> loc_yloc;
//~ var int loc_cleftID[5];
var int loc_cleftx[5];
var int loc_clefty[5];
var string loc_cleftName[5];
var string loc_cleftIcon[5];

var WindowHandle 	MiniMapDrawerWnd;

// Function FortressID2ZoneNameID(int LocalID)
// Description 
// * Converts FortressID comes from the server into their correspond ZoneNameID
//  Proper matching of data is crucial here.

function int FortressID2ZoneNameID(int LocalID)
{
	local Array<int> FortressID;
	local Array<int> ZoneNameID;
	local int i;
	local int ReturnInt; 
	FortressID[0]=  422;
	FortressID[1]=  423;
	FortressID[2]=  424;
	FortressID[3]=  425;
	FortressID[4]=  426;
	FortressID[5]=  427;
	FortressID[6]=  428;
	FortressID[7]=  429;
	FortressID[8]=  430;
	FortressID[9]=  431;
	FortressID[10]= 432;
	FortressID[11]= 433;
	FortressID[12]= 434;
	FortressID[13]= 435;
	FortressID[14]= 436;
	FortressID[15]= 437;
	FortressID[16]= 438;
	FortressID[17]= 439;
	FortressID[18]= 440;
	FortressID[19]= 441;
	FortressID[20]= 442;
	ZoneNameID[0]= 101;
	ZoneNameID[1]= 102;
	ZoneNameID[2]= 103;
	ZoneNameID[3]= 104;
	ZoneNameID[4]= 105;
	ZoneNameID[5]= 106;
	ZoneNameID[6]= 107;
	ZoneNameID[7]= 108;
	ZoneNameID[8]= 109;
	ZoneNameID[9]= 110;
	ZoneNameID[10]= 111;
	ZoneNameID[11]= 112;
	ZoneNameID[12]= 113;
	ZoneNameID[13]= 114;
	ZoneNameID[14]= 115;
	ZoneNameID[15]= 116;
	ZoneNameID[16]= 117;
	ZoneNameID[17]= 118;
	ZoneNameID[18]= 119;
	ZoneNameID[19]= 120;
	ZoneNameID[20]= 121;
	ReturnInt = 0;
	for (i=0;i<FortressID.length;i++)
	{
		if (FortressID[i] == LocalID)
		{
			ReturnInt = ZoneNameID[i];
		}
	}
	return ReturnInt;
}

// Function ExecuteFortressSiegeStatus()
// Description
// * To save the server packet. The script checks the PC's current location prior to the server request for the fortress data.
function ExecuteFortressSiegeStatus(string Param)
{
	local int ZoneID;
	//~ ZoneID = GetCurrentZoneID();
	ParseInt(Param, "ZoneID", ZoneID);
	if (ZoneID == 0)
		ZoneID = GetCurrentZoneID();
	DrawPeaceStatusFortressSiegeStatus( Param );
	Switch (ZoneID)
	{
		case 422:
		case 423:
		case 424:
		case 425:
		case 426:
		case 427:
		case 428:
		case 429:
		case 430:
		case 431:
		case 432:
		case 433:
		case 434:
		case 435:
		case 436:
		case 437:
		case 438:
		case 439:
		case 440:
		case 441:
		case 442:
		case 443:
		case 444:
			if (FortressID2ZoneNameID(ZoneID) !=0)
			{
				//~ debug("Running2");
				RequestFortressMapInfo(FortressID2ZoneNameID(ZoneID));
			}
			break;
		default:
			//~ debug("Running1");
			//~ if (SiegeStatus == 1)
			//~ {
				//~ RequestFortressMapInfo(FortressID2ZoneNameID(ZoneID));
			//~ }
			break; 
	}
	 //~ DrawPeaceStatusFortressSiegeStatus( Param );
}


//Description: 
// * To Hide the minimap at certain location.
function bool IsHideMinimapZone(int nZoneID)
{	
	switch(nZoneID)
	{
		case 363:		//헬바운드
		case 364:		//헬바운드
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
			return true;
		default:
			return false;
	}		
}

//Description: 
// * To Hide the minimap at certain location.
function bool IsHideMinimapZone_new(int nZoneID)
{	
	switch(nZoneID)
	{
		case 363:		//헬바운드
		case 364:		//헬바운드
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
			return true;
		default:
			return false;
	}		
}

// -------------------------------------------------
// Function : GetLocData()
// Description : 
// * Initialize the array data that to be used to convert the fortress siege component NPC IDs to their correspond "Fortress ID" 
//    ,"system string IDs" for their naming and the "XY Location" data for the map location.
// * Must be called on initializing process. 
// 
// Coded by Oxyzen.
function GetLocData()
{
	// fortress ID 
	loc_fortress[1] = 101;
	loc_fortress[2] = 101;
	loc_fortress[3] = 101;
	loc_fortress[4] = 101;
	loc_fortress[5] = 102;
	loc_fortress[6] = 102;
	loc_fortress[7] = 102;
	loc_fortress[8] = 102;
	loc_fortress[9] = 102;
	loc_fortress[10] = 102;
	loc_fortress[11] = 103;
	loc_fortress[12] = 103;
	loc_fortress[13] = 103;
	loc_fortress[14] = 103;
	loc_fortress[15] = 104;
	loc_fortress[16] = 104;
	loc_fortress[17] = 104;
	loc_fortress[18] = 104;
	loc_fortress[19] = 104;
	loc_fortress[20] = 104;
	loc_fortress[21] = 105;
	loc_fortress[22] = 105;
	loc_fortress[23] = 105;
	loc_fortress[24] = 105;
	loc_fortress[25] = 106;
	loc_fortress[26] = 106;
	loc_fortress[27] = 106;
	loc_fortress[28] = 106;
	loc_fortress[29] = 107;
	loc_fortress[30] = 107;
	loc_fortress[31] = 107;
	loc_fortress[32] = 107;
	loc_fortress[33] = 107;
	loc_fortress[34] = 107;
	loc_fortress[35] = 108;
	loc_fortress[36] = 108;
	loc_fortress[37] = 108;
	loc_fortress[38] = 108;
	loc_fortress[39] = 109;
	loc_fortress[40] = 109;
	loc_fortress[41] = 109;
	loc_fortress[42] = 109;
	loc_fortress[43] = 109;
	loc_fortress[44] = 109;
	loc_fortress[45] = 110;
	loc_fortress[46] = 110;
	loc_fortress[47] = 110;
	loc_fortress[48] = 110;
	loc_fortress[49] = 110;
	loc_fortress[50] = 110;
	loc_fortress[51] = 111;
	loc_fortress[52] = 111;
	loc_fortress[53] = 111;
	loc_fortress[54] = 111;
	loc_fortress[55] = 112;
	loc_fortress[56] = 112;
	loc_fortress[57] = 112;
	loc_fortress[58] = 112;
	loc_fortress[59] = 112;
	loc_fortress[60] = 112;
	loc_fortress[61] = 113;
	loc_fortress[62] = 113;
	loc_fortress[63] = 113;
	loc_fortress[64] = 113;
	loc_fortress[65] = 113;
	loc_fortress[66] = 113;
	loc_fortress[67] = 114;
	loc_fortress[68] = 114;
	loc_fortress[69] = 114;
	loc_fortress[70] = 114;
	loc_fortress[71] = 115;
	loc_fortress[72] = 115;
	loc_fortress[73] = 115;
	loc_fortress[74] = 115;
	loc_fortress[75] = 116;
	loc_fortress[76] = 116;
	loc_fortress[77] = 116;
	loc_fortress[78] = 116;
	loc_fortress[79] = 116;
	loc_fortress[80] = 116;
	loc_fortress[81] = 117;
	loc_fortress[82] = 117;
	loc_fortress[83] = 117;
	loc_fortress[84] = 117;
	loc_fortress[85] = 117;
	loc_fortress[86] = 117;
	loc_fortress[87] = 118;
	loc_fortress[88] = 118;
	loc_fortress[89] = 118;
	loc_fortress[90] = 118;
	loc_fortress[91] = 118;
	loc_fortress[92] = 118;
	loc_fortress[93] = 119;
	loc_fortress[94] = 119;
	loc_fortress[95] = 119;
	loc_fortress[96] = 119;
	loc_fortress[97] = 120;
	loc_fortress[98] = 120;
	loc_fortress[99] = 120;
	loc_fortress[100] = 120;
	loc_fortress[101] = 121;
	loc_fortress[102] = 121;
	loc_fortress[103] = 121;
	loc_fortress[104] = 121;
	//fortress NPC component IDs
	loc_component[1] = 4;
	loc_component[2] = 2;
	loc_component[3] = 3;
	loc_component[4] = 1;
	loc_component[5] = 6;
	loc_component[6] = 4;
	loc_component[7] = 2;
	loc_component[8] = 3;
	loc_component[9] = 1;
	loc_component[10] = 5;
	loc_component[11] = 4;
	loc_component[12] = 2;
	loc_component[13] = 3;
	loc_component[14] = 1;
	loc_component[15] = 6;
	loc_component[16] = 4;
	loc_component[17] = 2;
	loc_component[18] = 3;
	loc_component[19] = 1;
	loc_component[20] = 5;
	loc_component[21] = 4;
	loc_component[22] = 2;
	loc_component[23] = 3;
	loc_component[24] = 1;
	loc_component[25] = 4;
	loc_component[26] = 2;
	loc_component[27] = 3;
	loc_component[28] = 1;
	loc_component[29] = 6;
	loc_component[30] = 4;
	loc_component[31] = 2;
	loc_component[32] = 3;
	loc_component[33] = 1;
	loc_component[34] = 5;
	loc_component[35] = 4;
	loc_component[36] = 2;
	loc_component[37] = 3;
	loc_component[38] = 1;
	loc_component[39] = 6;
	loc_component[40] = 4;
	loc_component[41] = 2;
	loc_component[42] = 3;
	loc_component[43] = 1;
	loc_component[44] = 5;
	loc_component[45] = 6;
	loc_component[46] = 4;
	loc_component[47] = 2;
	loc_component[48] = 3;
	loc_component[49] = 1;
	loc_component[50] = 5;
	loc_component[51] = 4;
	loc_component[52] = 2;
	loc_component[53] = 3;
	loc_component[54] = 1;
	loc_component[55] = 6;
	loc_component[56] = 4;
	loc_component[57] = 2;
	loc_component[58] = 3;
	loc_component[59] = 1;
	loc_component[60] = 5;
	loc_component[61] = 6;
	loc_component[62] = 4;
	loc_component[63] = 2;
	loc_component[64] = 3;
	loc_component[65] = 1;
	loc_component[66] = 5;
	loc_component[67] = 4;
	loc_component[68] = 2;
	loc_component[69] = 3;
	loc_component[70] = 1;
	loc_component[71] = 4;
	loc_component[72] = 2;
	loc_component[73] = 3;
	loc_component[74] = 1;
	loc_component[75] = 6;
	loc_component[76] = 4;
	loc_component[77] = 2;
	loc_component[78] = 3;
	loc_component[79] = 1;
	loc_component[80] = 5;
	loc_component[81] = 6;
	loc_component[82] = 4;
	loc_component[83] = 2;
	loc_component[84] = 3;
	loc_component[85] = 1;
	loc_component[86] = 5;
	loc_component[87] = 6;
	loc_component[88] = 4;
	loc_component[89] = 2;
	loc_component[90] = 3;
	loc_component[91] = 1;
	loc_component[92] = 5;
	loc_component[93] = 4;
	loc_component[94] = 2;
	loc_component[95] = 3;
	loc_component[96] = 1;
	loc_component[97] = 4;
	loc_component[98] = 2;
	loc_component[99] = 3;
	loc_component[100] = 1;
	loc_component[101] = 4;
	loc_component[102] = 2;
	loc_component[103] = 3;
	loc_component[104] = 1;
	// Each Component's System String IDs.
	loc_sysstr[1] = 1708;
	loc_sysstr[2] = 1709;
	loc_sysstr[3] = 1710;
	loc_sysstr[4] = 1711;
	loc_sysstr[5] = 1708;
	loc_sysstr[6] = 1713;
	loc_sysstr[7] = 1709;
	loc_sysstr[8] = 1710;
	loc_sysstr[9] = 1711;
	loc_sysstr[10] = 1714;
	loc_sysstr[11] = 1708;
	loc_sysstr[12] = 1709;
	loc_sysstr[13] = 1710;
	loc_sysstr[14] = 1711;
	loc_sysstr[15] = 1708;
	loc_sysstr[16] = 1713;
	loc_sysstr[17] = 1709;
	loc_sysstr[18] = 1710;
	loc_sysstr[19] = 1711;
	loc_sysstr[20] = 1714;
	loc_sysstr[21] = 1708;
	loc_sysstr[22] = 1709;
	loc_sysstr[23] = 1710;
	loc_sysstr[24] = 1711;
	loc_sysstr[25] = 1708;
	loc_sysstr[26] = 1709;
	loc_sysstr[27] = 1710;
	loc_sysstr[28] = 1711;
	loc_sysstr[29] = 1708;
	loc_sysstr[30] = 1713;
	loc_sysstr[31] = 1709;
	loc_sysstr[32] = 1710;
	loc_sysstr[33] = 1711;
	loc_sysstr[34] = 1714;
	loc_sysstr[35] = 1708;
	loc_sysstr[36] = 1709;
	loc_sysstr[37] = 1710;
	loc_sysstr[38] = 1711;
	loc_sysstr[39] = 1708;
	loc_sysstr[40] = 1713;
	loc_sysstr[41] = 1709;
	loc_sysstr[42] = 1710;
	loc_sysstr[43] = 1711;
	loc_sysstr[44] = 1714;
	loc_sysstr[45] = 1708;
	loc_sysstr[46] = 1713;
	loc_sysstr[47] = 1709;
	loc_sysstr[48] = 1710;
	loc_sysstr[49] = 1711;
	loc_sysstr[50] = 1714;
	loc_sysstr[51] = 1708;
	loc_sysstr[52] = 1709;
	loc_sysstr[53] = 1710;
	loc_sysstr[54] = 1711;
	loc_sysstr[55] = 1708;
	loc_sysstr[56] = 1713;
	loc_sysstr[57] = 1709;
	loc_sysstr[58] = 1710;
	loc_sysstr[59] = 1711;
	loc_sysstr[60] = 1714;
	loc_sysstr[61] = 1708;
	loc_sysstr[62] = 1713;
	loc_sysstr[63] = 1709;
	loc_sysstr[64] = 1710;
	loc_sysstr[65] = 1711;
	loc_sysstr[66] = 1714;
	loc_sysstr[67] = 1708;
	loc_sysstr[68] = 1709;
	loc_sysstr[69] = 1710;
	loc_sysstr[70] = 1711;
	loc_sysstr[71] = 1708;
	loc_sysstr[72] = 1709;
	loc_sysstr[73] = 1710;
	loc_sysstr[74] = 1711;
	loc_sysstr[75] = 1708;
	loc_sysstr[76] = 1713;
	loc_sysstr[77] = 1709;
	loc_sysstr[78] = 1710;
	loc_sysstr[79] = 1711;
	loc_sysstr[80] = 1714;
	loc_sysstr[81] = 1708;
	loc_sysstr[82] = 1713;
	loc_sysstr[83] = 1709;
	loc_sysstr[84] = 1710;
	loc_sysstr[85] = 1711;
	loc_sysstr[86] = 1714;
	loc_sysstr[87] = 1708;
	loc_sysstr[88] = 1713;
	loc_sysstr[89] = 1709;
	loc_sysstr[90] = 1710;
	loc_sysstr[91] = 1711;
	loc_sysstr[92] = 1714;
	loc_sysstr[93] = 1708;
	loc_sysstr[94] = 1709;
	loc_sysstr[95] = 1710;
	loc_sysstr[96] = 1711;
	loc_sysstr[97] = 1708;
	loc_sysstr[98] = 1709;
	loc_sysstr[99] = 1710;
	loc_sysstr[100] = 1711;
	loc_sysstr[101] = 1708;
	loc_sysstr[102] = 1709;
	loc_sysstr[103] = 1710;
	loc_sysstr[104] = 1711;
	//Locations of each component NPCs on the L2 world.
	loc_xloc[1] = -52818;
	loc_xloc[2] = -52128;
	loc_xloc[3] = -53944;
	loc_xloc[4] = -52435;
	loc_xloc[5] = -22625;
	loc_xloc[6] = -23992;
	loc_xloc[7] = -22992;
	loc_xloc[8] = -21520;
	loc_xloc[9] = -21328;
	loc_xloc[10] = -22728;
	loc_xloc[11] = 16621;
	loc_xloc[12] = 17984;
	loc_xloc[13] = 16016;
	loc_xloc[14] = 15152;
	loc_xloc[15] = 126079;
	loc_xloc[16] = 127209;
	loc_xloc[17] = 124299;
	loc_xloc[18] = 124768;
	loc_xloc[19] = 124768;
	loc_xloc[20] = 128048;
	loc_xloc[21] = 72814;
	loc_xloc[22] = 73788;
	loc_xloc[23] = 71264;
	loc_xloc[24] = 72400;
	loc_xloc[25] = 154848;
	loc_xloc[26] = 155576;
	loc_xloc[27] = 153328;
	loc_xloc[28] = 154704;
	loc_xloc[29] = 189930;
	loc_xloc[30] = 191056;
	loc_xloc[31] = 188160;
	loc_xloc[32] = 188626;
	loc_xloc[33] = 188624;
	loc_xloc[34] = 191846;
	loc_xloc[35] = 118472;
	loc_xloc[36] = 118880;
	loc_xloc[37] = 118560;
	loc_xloc[38] = 117216;
	loc_xloc[39] = 159088;
	loc_xloc[40] = 161066;
	loc_xloc[41] = 157968;
	loc_xloc[42] = 157312;
	loc_xloc[43] = 159664;
	loc_xloc[44] = 160194;
	loc_xloc[45] = 69860;
	loc_xloc[46] = 68289;
	loc_xloc[47] = 71248;
	loc_xloc[48] = 68688;
	loc_xloc[49] = 71264;
	loc_xloc[50] = 68101;
	loc_xloc[51] = 109423;
	loc_xloc[52] = 109600;
	loc_xloc[53] = 108223;
	loc_xloc[54] = 109856;
	loc_xloc[55] = 5542;
	loc_xloc[56] = 4794;
	loc_xloc[57] = 7006;
	loc_xloc[58] = 4384;
	loc_xloc[59] = 6528;
	loc_xloc[60] = 5246;
	loc_xloc[61] = -53232;
	loc_xloc[62] = -51075;
	loc_xloc[63] = -55791;
	loc_xloc[64] = -54168;
	loc_xloc[65] = -55248;
	loc_xloc[66] = -50913;
	loc_xloc[67] = 60296;
	loc_xloc[68] = 61864;
	loc_xloc[69] = 59436;
	loc_xloc[70] = 58480;
	loc_xloc[71] = 11537;
	loc_xloc[72] = 9472;
	loc_xloc[73] = 12829;
	loc_xloc[74] = 13184;
	loc_xloc[75] = 79297;
	loc_xloc[76] = 78915;
	loc_xloc[77] = 77262;
	loc_xloc[78] = 80929;
	loc_xloc[79] = 79440;
	loc_xloc[80] = 80755;
	loc_xloc[81] = 111366;
	loc_xloc[82] = 109150;
	loc_xloc[83] = 109872;
	loc_xloc[84] = 112601;
	loc_xloc[85] = 113481;
	loc_xloc[86] = 113929;
	loc_xloc[87] = 125246;
	loc_xloc[88] = 127398;
	loc_xloc[89] = 122688;
	loc_xloc[90] = 124305;
	loc_xloc[91] = 123232;
	loc_xloc[92] = 127632;
	loc_xloc[93] = 73070;
	loc_xloc[94] = 71392;
	loc_xloc[95] = 71542;
	loc_xloc[96] = 74288;
	loc_xloc[97] = 100645;
	loc_xloc[98] = 100688;
	loc_xloc[99] = 99484;
	loc_xloc[100] = 100752;
	loc_xloc[101] = 72195;
	loc_xloc[102] = 70189;
	loc_xloc[103] = 73831;
	loc_xloc[104] = 73680;
	loc_yloc[1] = 156512;
	loc_yloc[2] = 157752;
	loc_yloc[3] = 155433;
	loc_yloc[4] = 155188;
	loc_yloc[5] = 219799;
	loc_yloc[6] = 218883;
	loc_yloc[7] = 218160;
	loc_yloc[8] = 221504;
	loc_yloc[9] = 218864;
	loc_yloc[10] = 221746;
	loc_yloc[11] = 188124;
	loc_yloc[12] = 187536;
	loc_yloc[13] = 189520;
	loc_yloc[14] = 188128;
	loc_yloc[15] = 123550;
	loc_yloc[16] = 121785;
	loc_yloc[17] = 123614;
	loc_yloc[18] = 124640;
	loc_yloc[19] = 121856;
	loc_yloc[20] = 123344;
	loc_yloc[21] = 4327;
	loc_yloc[22] = 5479;
	loc_yloc[23] = 4144;
	loc_yloc[24] = 2896;
	loc_yloc[25] = 55344;
	loc_yloc[26] = 56592;
	loc_yloc[27] = 54848;
	loc_yloc[28] = 53856;
	loc_yloc[29] = 39808;
	loc_yloc[30] = 38179;
	loc_yloc[31] = 39920;
	loc_yloc[32] = 41066;
	loc_yloc[33] = 38240;
	loc_yloc[34] = 39764;
	loc_yloc[35] = 204952;
	loc_yloc[36] = 203568;
	loc_yloc[37] = 206560;
	loc_yloc[38] = 205648;
	loc_yloc[39] = -70272;
	loc_yloc[40] = -70241;
	loc_yloc[41] = -71659;
	loc_yloc[42] = -70640;
	loc_yloc[43] = -72224;
	loc_yloc[44] = -68688;
	loc_yloc[45] = -61364;
	loc_yloc[46] = -62354;
	loc_yloc[47] = -62352;
	loc_yloc[48] = -59648;
	loc_yloc[49] = -60512;
	loc_yloc[50] = -60816;
	loc_yloc[51] = -141204;
	loc_yloc[52] = -139735;
	loc_yloc[53] = -142209;
	loc_yloc[54] = -142640;
	loc_yloc[55] = 149751;
	loc_yloc[56] = 147528;
	loc_yloc[57] = 148242;
	loc_yloc[58] = 150992;
	loc_yloc[59] = 151872;
	loc_yloc[60] = 152319;
	loc_yloc[61] = 91297;
	loc_yloc[62] = 90317;
	loc_yloc[63] = 91856;
	loc_yloc[64] = 92604;
	loc_yloc[65] = 90496;
	loc_yloc[66] = 92259;
	loc_yloc[67] = 139508;
	loc_yloc[68] = 139257;
	loc_yloc[69] = 140834;
	loc_yloc[70] = 139648;
	loc_yloc[71] = 95056;
	loc_yloc[72] = 94992;
	loc_yloc[73] = 96214;
	loc_yloc[74] = 94928;
	loc_yloc[75] = 91077;
	loc_yloc[76] = 93374;
	loc_yloc[77] = 91704;
	loc_yloc[78] = 90510;
	loc_yloc[79] = 88752;
	loc_yloc[80] = 89002;
	loc_yloc[81] = -15077;
	loc_yloc[82] = -14331;
	loc_yloc[83] = -16624;
	loc_yloc[84] = -13933;
	loc_yloc[85] = -16058;
	loc_yloc[86] = -14801;
	loc_yloc[87] = 95204;
	loc_yloc[88] = 94229;
	loc_yloc[89] = 95760;
	loc_yloc[90] = 96528;
	loc_yloc[91] = 94400;
	loc_yloc[92] = 96240;
	loc_yloc[93] = 186048;
	loc_yloc[94] = 184720;
	loc_yloc[95] = 186410;
	loc_yloc[96] = 186912;
	loc_yloc[97] = -55318;
	loc_yloc[98] = -57440;
	loc_yloc[99] = -54027;
	loc_yloc[100] = -53664;
	loc_yloc[101] = -94701;
	loc_yloc[102] = -93935;
	loc_yloc[103] = -94119;
	loc_yloc[104] = -95456;
	
	loc_cleftx[0] = -211648;
	loc_cleftx[1] = -219104;
	loc_cleftx[2] = -211773;
	loc_cleftx[3] = -204849;
	loc_cleftx[4] = -223211;
	loc_cleftx[5] = -213463;
     
	loc_clefty[0] = 250400;
	loc_clefty[1] = 242704;
	loc_clefty[2] = 238864;
	loc_clefty[3] = 242148;
	loc_clefty[4] = 247803;
	loc_clefty[5] = 244896;
  
	loc_cleftName[0] = GetSystemString(2017);
	loc_cleftName[1] = GetSystemString(2017);
	loc_cleftName[2] = GetSystemString(2017);
	loc_cleftName[3] = GetSystemString(2018);
	loc_cleftName[4] = GetSystemString(2018);
	loc_cleftName[5] = GetSystemString(2019);
	
	loc_cleftIcon[0] = "l2ui_ct1.minimap_df_icn_machinery";
	loc_cleftIcon[1] = "l2ui_ct1.minimap_df_icn_machinery";
	loc_cleftIcon[2] = "l2ui_ct1.minimap_df_icn_machinery";
	loc_cleftIcon[3] = "l2ui_ct1.minimap_df_icn_shield";
	loc_cleftIcon[4] = "l2ui_ct1.minimap_df_icn_shield";
	loc_cleftIcon[5] = "l2ui_ct1.minimap_df_icn_machinery";
	
}

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowMinimap );
	RegisterEvent( EV_PartyMemberChanged );
	RegisterEvent( EV_MinimapAddTarget );
	RegisterEvent( EV_MinimapDeleteTarget );
	RegisterEvent( EV_MinimapDeleteAllTarget );
	RegisterEvent( EV_MinimapShowQuest );
	RegisterEvent( EV_MinimapHideQuest );
	RegisterEvent( EV_MinimapChangeZone );
	RegisterEvent( EV_MinimapCursedWeaponList );
	RegisterEvent( EV_MinimapCursedWeaponLocation );
	RegisterEvent( EV_BeginShowZoneTitleWnd );		// ZoneName 이 바뀌면 현재위치 업데이트 해야하므로
	RegisterEvent( EV_MinimapShowReduceBtn );
	RegisterEvent( EV_MinimapHideReduceBtn );
	RegisterEvent( EV_MinimapUpdateGameTime );
	RegisterEvent( EV_MinimapTravel );
	RegisterEvent( EV_ShowFortressSiegeInfo);
	RegisterEvent( EV_BeginShowZoneTitleWnd );
	RegisterEvent( EV_MinimapRegionInfoBtnClick );
	RegisterEvent( EV_ShowFortressMapInfo );
	RegisterEvent( EV_FortressMapBarrackInfo);
	RegisterEvent( EV_ShowFortressSiegeInfo );
	RegisterEvent( EV_SystemMessage );
	RegisterEvent( EV_GamingStateEnter );
	RegisterEvent( EV_DominionsOwnPos   );
	RegisterEvent( EV_DominionWarStart );
	RegisterEvent( EV_DominionWarEnd );
	RegisterEvent( EV_ShowSeedMapInfo );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MiniMapDrawerWnd = 			GetHandle( "MiniMapDrawerWnd" );
		me = GetHandle( "MinimapWnd" );
		m_hExpandWnd = GetHandle( "MinimapWnd_Expand" );
		m_hGuideWnd = GetHandle( "GuideWnd" );
		m_questItem = ItemWindowHandle(GetHandle("InventoryWnd.QuestItem"));
		m_MiniMap = MinimapCtrlHandle(GetHandle( "MinimapWnd.Minimap" ));
		//~ m_MiniMap_Expand = MinimapCtrlHandle(GetHandle( "MinimapWnd_Expand.Minimap" )); 
		Btn_Refresh = ButtonHandle(GetHandle("MinimapWnd.Btn_Refresh"));
		Btn_Refresh_Expand = ButtonHandle( GetHandle("MinimapWnd_Expand.Btn_Refresh"));
		ReduceButton = ButtonHandle( GetHandle("MinimapWnd.btnReduce"));
		ReduceButton_Expand = ButtonHandle( GetHandle("MinimapWnd_Expand.btnReduce"));
		m_textSSQ = TextBoxHandle(GetHandle("MinimapWnd.txtSSQ"));	
		m_textSSQStatus = TextBoxHandle(GetHandle("Minimapwnd.txtVarSSQType"));
		m_textSSQ_Expand = TextBoxHandle(GetHandle("MinimapWnd_Expand.txtSSQ"));	
		m_textSSQStatus_Expand = TextBoxHandle(GetHandle("Minimapwnd_Expand.txtVarSSQType"));
		m_MapSelectTab = TabHandle(GetHandle("MiniMapWnd.MapSelectTab"));
		ListTrackItem2 = 	ListCtrlHandle(GetHandle("MiniMapDrawerWnd.ListTrackItem2"));
		ListTrackItem3 = 	ListCtrlHandle(GetHandle("MiniMapDrawerWnd.ListTrackItem3"));
		//~ m_MapSelectTabExpand = TabHandle(GetHandle("MiniMapWnd_Expand.MapSelectTab"));
		CleftCurTriggerWnd = GetHandle("CleftCurTriggerWnd");
	}
	else
	{
		MiniMapDrawerWnd = 			GetWindowHandle( "MiniMapDrawerWnd" );
		me = GetWindowHandle( "MinimapWnd" );
		m_hExpandWnd = GetWindowHandle( "MinimapWnd_Expand" );
		m_hGuideWnd = GetWindowHandle( "GuideWnd" );
		m_questItem = GetItemWindowHandle("InventoryWnd.QuestItem");
		m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );
		//~ m_MiniMap_Expand = GetMinimapCtrlHandle( "MinimapWnd_Expand.Minimap" );
		Btn_Refresh = GetButtonHandle("MinimapWnd.Btn_Refresh");
		Btn_Refresh_Expand = GetButtonHandle( "MinimapWnd_Expand.Btn_Refresh");
		ReduceButton = GetButtonHandle( "MinimapWnd.btnReduce");
		ReduceButton_Expand = GetButtonHandle( "MinimapWnd_Expand.btnReduce");
		m_textSSQ = GetTextBoxHandle("MinimapWnd.txtSSQ");	
		m_textSSQStatus = GetTextBoxHandle("Minimapwnd.txtVarSSQType");
		m_textSSQ_Expand = GetTextBoxHandle("MinimapWnd_Expand.txtSSQ");	
		m_textSSQStatus_Expand = GetTextBoxHandle("Minimapwnd_Expand.txtVarSSQType");
		m_MapSelectTab = GetTabHandle("MiniMapWnd.MapSelectTab");
		ListTrackItem2 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem2"); 
		ListTrackItem3 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem3");
		//~ m_MapSelectTabExpand = GetTabHandle("MiniMapWnd_Expand.MapSelectTab");
		CleftCurTriggerWnd = GetWindowHandle("CleftCurTriggerWnd");
	}


	m_PartyLocIndex = -1;
	m_PartyMemberCount = GetPartyMemberCount();
	
	m_AdjustCursedLoc = false;
	m_bShowSSQType=true;
	m_bShowCurrentLocation=true;
	m_bShowGameTime=true;
	m_bExpandState=false;
	GlobalCurFortressStatus=false;
	
	// 헬바운드 맵 확대 방지. 
	BlockedLoc1.x = -32768f;
	BlockedLoc1.y = 32768f;
	BlockedLoc2.x = 229376f;
	BlockedLoc2.y = 262144f;
	bMiniMapDisabled = true;
	RequestAllFortressInfo();
	DrawCleftStatus();
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
		case EV_BeginShowZoneTitleWnd:
			HandleZoneTitle();
			SetCurrentLocation();
			G_ZoneID2 = GetCurrentZoneID();
			break;
		case EV_MinimapRegionInfoBtnClick:
			HandleDungeonMapRefresh(a_Param);
			break;
		case EV_ShowMinimap:
			G_ZoneID2 = GetCurrentZoneID();
			HandleShowMinimap( a_Param );
			break;
		case EV_PartyMemberChanged:
			HandlePartyMemberChanged( a_Param );
			break;
		case EV_MinimapAddTarget:
			HandleMinimapAddTarget( a_Param );
			break;
		case EV_MinimapDeleteTarget:
			HandleMinimapDeleteTarget( a_Param );
			break;
		case EV_MinimapDeleteAllTarget:
			HandleMinimapDeleteAllTarget();
			break;
		case EV_MinimapShowQuest:
			HandleMinimapShowQuest();
			break;
		case EV_MinimapHideQuest:
			HandleMinimapHideQuest();
			break;
		case EV_MinimapChangeZone :
			AdjustMapToPlayerPosition( true );
			G_ZoneID2 = GetCurrentZoneID();
			ParamAdd(a_Param, "ZoneID", String(G_ZoneID2));
			ExecuteFortressSiegeStatus(a_Param);
			break;
		case EV_MinimapCursedweaponList :
			HandleCursedWeaponList(a_Param);
			break;
		case EV_MinimapCursedweaponLocation :
			HandleCursedWeaponLoctaion(a_Param);
			break;
		case EV_MinimapShowReduceBtn :
			ParseInt(a_Param,"ZoneID",G_ZoneID2);
			ShowWindow("MinimapWnd.btnReduce");
			ExecuteFortressSiegeStatus(a_Param);
			DrawCleftStatus();
			break;
		case EV_MinimapHideReduceBtn :
			HideWindow("MinimapWnd.btnReduce");
			m_MiniMap.EraseAllRegionInfo();
			break;
		case EV_MinimapUpdateGameTime :
			if(m_bShowGameTime)
				HandleUpdateGameTime(a_Param);
			break;
		case EV_MinimapTravel:
			HandleMinimapTravel( a_Param );
			break;
		case EV_ShowFortressMapInfo:
			HandleShowFortressMapInfo(a_Param);
			break;
		case EV_FortressMapBarrackInfo:
			HandleFortressMapBarrackInfo(a_Param);
			break;
		case EV_ShowFortressSiegeInfo:
			GlobalCurFortressStatus=true;
			ParseInt( a_Param, "FortressID", GlobalCurFortressID);
			break;
		case EV_SystemMessage:
			//To update Fortress Information Data on System Message Update
			if (me.IsShowWindow())
				HandleChatmessage(a_Param);
			break;
		case EV_GamingStateEnter:
			SiegeStatus = 0;
			FortressID =0;
			TotalBarrackCnt =0;
			GlobalCurFortressID = 0;
			G_ZoneID = 0;
			G_ZoneID2 = 0;
			GlobalCurFortressStatus = false;
			m_MiniMap.EraseAllRegionInfo();
			//~ m_MiniMap_Expand.EraseAllRegionInfo();
			break;

		case EV_DominionsOwnPos:
			//~ debug ("EV_Received");
			HandleDominionsOwnPos(a_Param);
			break;
		case EV_DominionWarStart:
			HandleDominionWarStart();
			break;
		case EV_DominionWarEnd:
			HandleDominionWarEnd();
			break;
		case EV_ShowSeedMapInfo:
			HandleSeedMapInfo(a_Param);
			break;
	}
}

function HandleDominionWarStart()
{
	m_Dominion = true;
	DrawDominionTarget();
}

function HandleDominionWarEnd()
{
	m_Dominion = false;
}	

//Show DominionTargetInfo
function DrawDominionTarget()
{
	//~ debug
	//~ m_CurContinent
	local int LocX[17];
	local int LocY[17];
	local int SysString[17];
	local int i;
	local string DataforMap;
	
	debug ("Draw Dominion Info");
	LocX[0] = -17799;
	LocX[1] = -51717;
	LocX[2] = 21757;
	LocX[3] = 15996;
	LocX[4] = 114707;
	LocX[5] = 126039;
	LocX[6] = 80783;
	LocX[7] = 73722;
	LocX[8] = 147454;
	LocX[9] = 155898;
	LocX[10] = 115744;
	LocX[11] = 117384;
	LocX[12] = 147463;
	LocX[13] = 160489;
	LocX[14] = 15919;
	LocX[15] = 70409;
	LocX[16] = 77552;
	LocX[17] = 108288;
	
	LocY[0] = 111217;
	LocY[1] = 156192;
	LocY[2] = 158534;
	LocY[3] = 187134;
	LocY[4] = 145387;
	LocY[5] = 121624;
	LocY[6] = 37476;
	LocY[7] = 3376;
	LocY[8] = 7187;
	LocY[9] = 54559;
	LocY[10] = 247311;
	LocY[11] = 204366;
	LocY[12] = -46100;
	LocY[13] = -71139;
	LocY[14] = -49314;
	LocY[15] = -60006;
	LocY[16] = -150184;
	LocY[17] = -140728;
	
	SysString[0] = 1990;
	SysString[1] = 1991;
	SysString[2] = 1990;
	SysString[3] = 1991;
	SysString[4] = 1990;
	SysString[5] = 1991;
	SysString[6] = 1990;
	SysString[7] = 1991;
	SysString[8] = 1990;
	SysString[9] = 1991;
	SysString[10] = 1990;
	SysString[11] = 1991;
	SysString[12] = 1990;
	SysString[13] = 1991;
	SysString[14] = 1990;
	SysString[15] = 1991;
	SysString[16] = 1990;
	SysString[17] = 1991;

	if(m_Dominion == true && m_CurContinent == 0)
	//~ {
		for(i=0;i<17;i++)
		{
			DataforMap = "";
			ParamAdd(DataforMap, "Index", string(8300+i));
			ParamAdd(DataforMap, "WorldX", string(LocX[i] - (REGIONINFO_OFFSETX - REGIONINFO_OFFSETX *5 )));
			ParamAdd(DataforMap, "WorldY", string(LocY[i] - (REGIONINFO_OFFSETY - REGIONINFO_OFFSETY *2 )));
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CH3.MapIcon_Mark_Light");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CH3.MapIcon_Mark_Light");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CH3.MapIcon_Mark_Light");
			ParamAdd(DataforMap, "BtnWidth", "32");
			ParamAdd(DataforMap, "BtnHeight", "32");
			ParamAdd(DataforMap, "Description", "");
			//~ ParamAdd(DataforMap, "Description", string(SysString[i]));
			ParamAdd(DataforMap, "DescOffsetX", "0");
			ParamAdd(DataforMap, "DescOffsetY", "0");
			ParamAdd(DataforMap, "Tooltip", GetSystemString(SysString[i]));
			m_MiniMap.AddRegionInfo(DataforMap);
			//~ debug (DataforMap);
		}
	//~ }
}
//Show SeedStatus
function HandleSeedMapInfo(string Param)
{
	local int i;
	local int nSeedCount;
	local int XPos[5];
	local int YPos[5];
	local int ZPos[5];
	local int SysMsgNo[5];
	local string DataforMap;
	debug ("Seed Info" @ Param);
	
	ParseInt(param, "SeedCount", nSeedCount);

	//~ for(i=0; i<SeedCount;i++)
	for(i=0;i<nSeedCount;i++)
	{
		DataforMap = "";
		ParseInt(param,"XPos_"$ i, XPos[i]);
		ParseInt(param,"YPos_" $ i, YPos[i]);
		ParseInt(param,"ZPos_" $ i, ZPos[i]);
		ParseInt(param,"SysMsgNo_" $ i, SysMsgNo[i]);
		
		ParamAdd(DataforMap, "Index", string(8889+i));
		ParamAdd(DataforMap, "WorldX", string(XPos[i] - (REGIONINFO_OFFSETX * 80)));
		ParamAdd(DataforMap, "WorldY", string(YPos[i] - (REGIONINFO_OFFSETY* 5)));
		ParamAdd(DataforMap, "BtnTexNormal", "");
		ParamAdd(DataforMap, "BtnTexPushed", "");
		ParamAdd(DataforMap, "BtnTexOver", "");
		ParamAdd(DataforMap, "BtnWidth", "");
		ParamAdd(DataforMap, "BtnHeight","");
		ParamAdd(DataforMap, "Description", GetSystemMessage(SysMsgNo[i]));
		ParamAdd(DataforMap, "DescOffsetX", "0");
		ParamAdd(DataforMap, "DescOffsetY", "0");
		ParamAdd(DataforMap, "Tooltip", "");
		m_MiniMap.AddRegionInfo(DataforMap);
	}
}

function HandleChatmessage( String param )
{
	local int SystemMsgIndex;
	ParseInt ( param, "Index", SystemMsgIndex );
	switch (SystemMsgIndex)
	{
		//요새전 시작 메시지가 왔을때 요새전 현황을 갱신받는다. 
		case 2090:
			GlobalCurFortressStatus = true;
			if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
			{
				ExecuteFortressSiegeStatus("");
				//~ RequestFortressSiegeInfo();
			}
			else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
				RequestFortressSiegeInfo();
				
		break;
		//요새전 주요 진행 상황중 리셋을 요청한다. 
		case 2164:
		case 2165:
		case 2166:
			GlobalCurFortressStatus = true;
			if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
			{
				ExecuteFortressSiegeStatus("");
				//~ RequestFortressSiegeInfo();
			}
			else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
			{
				RequestFortressSiegeInfo();
			}
		break;
		//요새전이 종료되면 요새전 상황을 리셋한다.
		case 2183:
			GlobalCurFortressStatus = false;
			if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
			{
				ExecuteFortressSiegeStatus("");
				//~ RequestFortressSiegeInfo();	
			}
			else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
				RequestFortressSiegeInfo();
		break;
	}

}


function HandleZoneTitle()
{
	local int nZoneID;
	local string DataforMap;
	nZoneID = GetCurrentZoneID();
	// When a PC has entered specified Zone 
	if( IsHideMinimapZone(nZoneID) )
	{
		//Close MiniMapWnd if it is shown and the PC has no item in inventory
		if(me.IsShowWindow() && bHaveItem==false && !IsBuilderPC())
		{
			me.HideWindow();
			
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			else 
				AddSystemMessage(2207);
		}
		else	if(m_hExpandWnd.IsShowWindow() && bHaveItem==false && !IsBuilderPC()  )
		{
			m_hExpandWnd.HideWindow();
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			else
				AddSystemMessage(2207);
		}
		else if(me.IsShowWindow() && bHaveItem && ReduceButton.IsShowWindow()== false)
		{
			//~ m_MiniMap.EraseAllRegionInfo();
			ParamAdd(DataforMap, "Index", "8888");
			ParamAdd(DataforMap, "WorldX", "13187");
			ParamAdd(DataforMap, "WorldY", "246159");
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue_Down");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue_Over");
			ParamAdd(DataforMap, "BtnWidth", "33");
			ParamAdd(DataforMap, "BtnHeight", "33");
			ParamAdd(DataforMap, "Description", "");
			ParamAdd(DataforMap, "DescOffsetX", "0");
			ParamAdd(DataforMap, "DescOffsetY", "0");
			ParamAdd(DataforMap, "Tooltip", "");
			m_MiniMap.AddRegionInfo(DataforMap);
			//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
		}
	
		bMiniMapDisabled = false;
	}
	else 
	{
		if (bMiniMapDisabled == false)
		{
			AddSystemMessage(2206);
		}
		bMiniMapDisabled = true;
	}
	
	if (IsHideMinimapZone_new(nZoneID) )
	{
		//Close MiniMapWnd if it is shown and the PC has no item in inventory
		if(me.IsShowWindow() && bHaveItem==false && !IsBuilderPC()  )
		{
			me.HideWindow();
			
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			else 
				AddSystemMessage(2207);
		}
		else	if(m_hExpandWnd.IsShowWindow() && bHaveItem==false && !IsBuilderPC() )
		{
			m_hExpandWnd.HideWindow();
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			else
				AddSystemMessage(2207);
		}
		bMiniMapDisabled = false;
	}
	else 
	{
		if (bMiniMapDisabled == false)
		{
			AddSystemMessage(2206);
		}
		
		bMiniMapDisabled = true;
	}
}

function HandleDungeonMapRefresh(string Param)
{
	local int Index;
	
	ParseInt(Param, "Index", Index);
	
	if (Index == 8888)
	{
		if (me.IsShowWindow())
		{
			me.HideWindow();
			me.ShowWindow();
		}
		else if (m_hExpandWnd.IsShowWindow())
		{
			m_hExpandWnd.HideWindow();
			m_hExpandWnd.ShowWindow();
		}
	}
}



function FilterDungeonMap()
{
	local Vector MyPosition;
	MyPosition = GetPlayerPosition();

	if (MyPosition.x > BlockedLoc1.x && MyPosition.x < BlockedLoc2.x && MyPosition.y > BlockedLoc1.y && MyPosition.y < BlockedLoc2.y)
	{
		if (bHaveItem==false && !IsBuilderPC() )
		{
			class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap");
			HideWindow("MinimapWnd.btnReduce");
			class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd_Expand.Minimap");
			HideWindow("MinimapWnd_Expand.btnReduce");
			
		}
	}
	
}	

function OnShow()
{
	local int i;
	local ItemInfo info;
	AdjustMapToPlayerPosition( true );
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_open_01" );
	if(b_IsShowGuideWnd == 1)
	m_hGuideWnd.ShowWindow();
	Btn_Refresh.HideWindow();
	Btn_Refresh_Expand.HideWindow();
	b_IsShowGuideWnd = 0;
	
	SetSSQTypeText();	// 세븐사인종류에따라 텍스트셋팅
	SetCurrentLocation();
	
	GetLocData();
	
	// 아이템 소지 여부 세팅

	bHaveItem = false;

	for (i=0;i<100;i++)
	{
		if (m_questItem.GetItem(i, info) == true)
		{
			if (info.Name == GetSystemString(1647))
				bHaveItem = true;
		}
	}
	
	RequestFortressSiegeInfo();
	class'MiniMapAPI'.static.RequestCursedWeaponList();
	class'MiniMapAPI'.static.RequestCursedWeaponLocation();
	HandleZoneTitle();
	ListTrackItem3.DeleteAllItem();
	RequestDominionInfo();
	ContinentLoc();
	//~ RequestDominionInfo();
	//~ Class'MiniMapAPI'.static.RequestSeedPhase();
	DrawDominionTarget();
}

function ContinentLoc()
{
	local Vector MyPosition;
	MyPosition = GetPlayerPosition();
	
	
	if (GetContinent(MyPosition) == 1)
	{	
		SetContinent(1);
		m_MapSelectTab.SetTopOrder(0, true);
		Class'MiniMapAPI'.static.RequestSeedPhase();
		//~ m_MapSelectTabExpand.SetTopOrder(0, true);
	}
	else if (GetContinent(MyPosition) == 0)
	{
		SetContinent(0);
		m_MapSelectTab.SetTopOrder(1, true);
		//~ m_MapSelectTabExpand.SetTopOrder(1, true);
	}
	debug("Continent@@@" $m_CurContinent);
}

function SetSSQTypeText()
{
	local string SSQText;

	switch(m_SSQStatus)
	{
	case 0 :
		SSQText=GetSystemString(973);
		break;
	case 1 :
		SSQText=GetSystemString(974);
		break;
	case 2 :
		SSQText=GetSystemString(975);
		break;
	case 3 :
		SSQText=GetSystemString(976);
		break;
	}
	m_textSSQ.SetText(GetSystemString(833));
	m_textSSQ_Expand.SetText(GetSystemString(833));
	m_textSSQStatus.SetText(SSQText);
	m_textSSQStatus_Expand.SetText(SSQText);
}

function SetCurrentLocation()
{
	local string ZoneName;

	ZoneName=GetCurrentZoneName();
	class'UIAPI_TEXTBOX'.static.SetText("Minimapwnd.txtVarCurLoc", ZoneName);
}

function OnHide()
{
	if( m_hGuideWnd.IsShowWindow() )
	{
		b_IsShowGuideWnd = 1;
	}
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_close_01" );
}

function HandlePartyMemberChanged( String a_Param )
{
	ParseInt( a_Param, "PartyMemberCount", m_PartyMemberCount );
}

function SetExpandState(bool bExpandState)
{
	m_bExpandState=bExpandstate;
}

function bool IsExpandState()
{
	return m_bExpandState;
}



function HandleShowMinimap( String a_Param )
{
	local int SSQStatus;

	// SSQState의 등록
	if( ParseInt( a_Param, "SSQStatus", SSQStatus ) )
	{
		class'UIAPI_MINIMAPCTRL'.static.SetSSQStatus( "MinimapWnd.Minimap", SSQStatus );
	
		m_SSQStatus=SSQStatus;
	}

	if(IsExpandState())
	{
		// 큰윈도우 상태
		if(IsShowWindow("MinimapWnd_Expand"))
		{
			HideWindow("MinimapWnd_Expand");
		}
		else
		{
			// 작은 윈도우 닫고
			// 큰윈도우 오픈
			HideWindow("MinimapWnd");
			ShowWindowWithFocus("MinimapWnd_Expand");
		}
	}
	else
	{
		// 작은 윈도우 상태
		if(IsShowWindow("MinimapWnd"))
		{
			HideWindow("MinimapWnd");
		}
		else
		{
			HideWindow("MinimapWnd_Expand");
			ShowWindowWithFocus("MinimapWnd");
		}
	}

	if(IsShowWindow("MinimapWnd") || IsShowWindow("MinimapWnd_Expand"))
	{
		class'MiniMapAPI'.static.RequestCursedWeaponList();
		class'MiniMapAPI'.static.RequestCursedWeaponLocation();
	}
	RequestFortressSiegeInfo();
}

function HandleMinimapAddTarget( String a_Param )
{
	local Vector Loc;
	
	if( ParseFloat( a_Param, "X", Loc.x )
		&& ParseFloat( a_Param, "Y", Loc.y )
		&& ParseFloat( a_Param, "Z", Loc.z ) )
	{
		
		class'UIAPI_MINIMAPCTRL'.static.AddTarget( "MinimapWnd.Minimap", Loc );
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", Loc, false, false);
	}
}

function HandleMinimapDeleteTarget( String a_Param )
{
	local Vector Loc;
	local int LocX;
	local int LocY;
	local int LocZ;

	if( ParseInt( a_Param, "X", LocX )
		&& ParseInt( a_Param, "Y", LocY )
		&& ParseInt( a_Param, "Z", LocZ ) )
	{
		Loc.x = float(LocX);
		Loc.y = float(LocY);
		Loc.z = float(LocZ);
		class'UIAPI_MINIMAPCTRL'.static.DeleteTarget( "MinimapWnd.Minimap", Loc );
	}
}

function HandleMinimapDeleteAllTarget()
{
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget( "MinimapWnd.Minimap" );
}

function HandleMinimapShowQuest()
{

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd.Minimap", true );
}

function HandleMinimapHideQuest()
{

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd.Minimap", false );
}

//~ function OnComboBoxItemSelected( string sName, int index )
//~ {
	//~ local int CursedweaponComboBoxCurrentReservedData;

	//~ if( sName == "CursedComboBox")
	//~ {
		//~ CursedweaponComboBoxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("MinimapWnd.CursedComboBox",index);
	//~ }
	
//~ }

function OnClickButton( String a_ButtonID )
{


	switch( a_ButtonID )
	{
		//~ case "TargetButton":
			//~ OnClickTargetButton();
			//~ break;
		case "MyLocButton":
			OnClickMyLocButton();
			break;
		case "PartyLocButton":
			OnClickPartyLocButton();
			break;
		case "OpenGuideWnd":
			if( m_hGuideWnd.IsShowWindow() )
			{
				m_MiniMap.EraseAllRegionInfo();
				//~ m_MiniMap_Expand.EraseAllRegionInfo();
				m_hGuideWnd.HideWindow();
			}
			else
			{
				m_hGuideWnd.ShowWindow();
			}
			break;
			//~ RequestFortressSiegeInfo();
		//~ case "Pursuit":
			//~ m_AdjustCursedLoc = true;
			//~ class'MiniMapAPI'.static.RequestCursedWeaponLocation();
			//~ break;
		case "ExpandButton":
			SetExpandState(true);
			ShowWindowWithFocus( "MinimapWnd_Expand" );
			me.HideWindow();
			break;
		case "btnReduce" :
			OnClickReduceButton();
			m_MiniMap.EraseAllRegionInfo();
			//~ DrawDominionTarget();
			//~ if (m_CurContinent == 0)
			//~ {
				//~ Class'MiniMapAPI'.static.RequestSeedPhase();
			//~ }
			break;
		case "Btn_Refresh" :
			ExecuteFortressSiegeStatus("");
			break;
		case "MapSelectTab1":
			// Assign World Continent 
			SetContinent(0);
			
			// Reset Map Location
			m_Minimap.EraseAllRegionInfo();
			// Fortress Siege Information Location 
			RequestFortressSiegeInfo();
			InitializeLocation();
			//Cursed Weapon Location
			class'MiniMapAPI'.static.RequestCursedWeaponList();
			class'MiniMapAPI'.static.RequestCursedWeaponLocation();
			//~ HandleZoneTitle();
			//My Current Location;
			//~ ContinentLoc();
			// Dominion War General Info
			ListTrackItem3.DeleteAllItem();
			RequestDominionInfo();
			// Dominion War  Status;
			DrawDominionTarget();
			//~ DrawDominionTarget();
			break;
		case "MapSelectTab0":
			SetContinent(1);
			//~ Class'MiniMapAPI'.static.RequestSeedPhase();
			m_Minimap.EraseAllRegionInfo();
			InitializeLocation();
			//~ m_MiniMap_Expand.SetContinent(1);
			//~ m_MiniMap_Expand.SetContinent(1);
			//~ debug (a_ButtonID @ "Task2");
			break;
		case "btnLocatingTool": 
			if (MiniMapDrawerWnd.IsShowWindow())
				MiniMapDrawerWnd.HideWindow();
			else
				MiniMapDrawerWnd.ShowWindow();
			break;
		
	}
}

//~ function OnLButtonUp (WindowHandle  a_WindowHandle, int X, int Y)
//~ {
	//~ local Rect Rect1;
	//~ debug ("Loc"  @ X @ Y);
	//~ me.GetRect();
	//~ debug ("Rect1" @ Rect1.nX @ Rect1.nY);
	//~ switch (a_WindowHandle)
	//~ {
		//~ case m_MapSelectTab:
			
			//~ break;
	//~ }
//~ }

function OnClickReduceButton()
{
	class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap");
	HideWindow("MinimapWnd.btnReduce");
	Btn_Refresh.HideWindow();
	Btn_Refresh_Expand.HideWindow();
	RequestFortressSiegeInfo();
	HandleZoneTitle();
	SetSSQTypeText();
	DrawDominionTarget();
	if (m_CurContinent == 0)
	{
		Class'MiniMapAPI'.static.RequestSeedPhase();
	}
}


function OnClickTargetButton()
{
	local Vector QuestLocation;
	
	//~ debug ("UpdateTarget");
	
	if( GetQuestLocation(QuestLocation ) )
	{
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", QuestLocation );
		SetLocContinent(QuestLocation);
		if(  QuestLocation.x ==19714 && QuestLocation.y == 243420  && QuestLocation.z == -205)
		{
			OnClickReduceButton();
		}
		else if (QuestLocation.x ==8800 && QuestLocation.y == 251652  && QuestLocation.z == -2032 )
		{
			OnClickReduceButton();
		}
		else if (QuestLocation.x ==8800  && QuestLocation.y == 251652  && QuestLocation.z == -2032 )
		{
			OnClickReduceButton();
		}
		else if (QuestLocation.x ==27491  && QuestLocation.y == 247340  && QuestLocation.z == -3256 )
		{
			OnClickReduceButton();
		}
	}
}

function OnClickMyLocButton()
{
//	AdjustMapToPlayerPosition( false );
	AdjustMapToPlayerPosition( true );
}

function AdjustMapToPlayerPosition( bool a_ZoomToTownMap )
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();
	SetLocContinent(PlayerPosition);
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", PlayerPosition, a_ZoomToTownMap );
}

function OnClickPartyLocButton()
{
	local Vector PartyMemberLocation;

	m_PartyMemberCount = GetPartyMemberCount();

	
	
	if( 0 == m_PartyMemberCount )
		return;

	m_PartyLocIndex = ( m_PartyLocIndex + 1 ) % m_PartyMemberCount;
	if( GetPartyMemberLocation( m_PartyLocIndex, PartyMemberLocation ) )
	{
		SetLocContinent(PartyMemberLocation);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", PartyMemberLocation, false );
	}
}

function HandleCursedWeaponList( string param )
{

	local int num;  
	local int itemID;
	local int i;
	local LVData data1;
	local LVDataRecord	record;
	local string cursedName;
	
	ParseInt( param, "NUM", num );
	//~ class'UIAPI_COMBOBOX'.static.Clear("MinimapWnd.CursedComboBox");
	ListTrackItem2.DeleteAllItem();	

	for(i=0;i<num+1;++i)
	{
		if (i==0)
		{
			//~ class'UIAPI_COMBOBOX'.static.AddStringWithReserved("MinimapWnd.CursedComboBox", GetSystemString(1463) , 0);
			ListTrackItem2.DeleteAllItem();
		}
		else
		{
			ParseInt( param, "ID" $ i-1, itemID );
			ParseString( param, "NAME" $ i-1, cursedName );
			data1.szData = cursedName;
			data1.nReserved1 = itemID;
			//~ debug ("data1.nReserved1" @ data1.nReserved1);
			data1.szReserved = cursedName;
			//~ debug ("data1.szReserved" @ data1.szReserved);
			//~ debug("CursedWeapon"@ CursedName);
			//~ record.LVDataList[0].szData = cursedName;	
			record.LVDataList[0] = data1;	
			//~ class'UIAPI_COMBOBOX'.static.AddStringWithReserved("MinimapWnd.CursedComboBox", cursedName , itemID);
			//~ class'UIAPI_COMBOBOX'.static.SetSelectedNum("MinimapWnd.CursedComboBox",0);
			ListTrackItem2.InsertRecord(record);
		}
	}
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap"); 
}

function HandleCursedWeaponLoctaion( string param )
{
	local int num;  
	local int itemID;
	local int itemID1;
	local int itemID2;
	local int isowndedo;
	local int isownded1;
	local int isownded2;
	
	local LVDataRecord record;
	
	local int x;
	local int y;
	local int z;
	local int i;
	local Vector CursedWeaponLoc1;
	local Vector CursedWeaponLoc2;
	local int CursedWeaponComboCurrentData;
	local string cursedName;
	local string cursedName1;
	local string cursedName2;
	local Vector cursedWeaponLocation;
	local bool combined;
	
	ParseInt( param, "NUM", num );

	if(num==0)
	{	
		if(m_AdjustCursedLoc)
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", GetPlayerPosition());  
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");	
		return;
	}
	else
	{
		for(i=0; i<num; ++i)
		{
			ParseInt( param, "ID" $ i, itemID );
			ParseString( param, "NAME" $ i, cursedName );

			ParseInt( param, "ISOWNED" $ i, isowndedo );
			ParseInt( param, "X" $ i, x );
			ParseInt( param, "Y" $ i, y );
			ParseInt( param, "Z" $ i, z );
				
			cursedWeaponLocation.x = x;
			cursedWeaponLocation.y = y;
			cursedWeaponLocation.z = z;
			SetLocContinent(cursedWeaponLocation);
			Normal(cursedWeaponLocation);
			
			if( itemID == 8190 )
			{
				itemID1=itemID;
				cursedName1=cursedName;
				isownded1=isowndedo;
				CursedWeaponLoc1.x = cursedWeaponLocation.x;
				CursedWeaponLoc1.y = cursedWeaponLocation.y;
				CursedWeaponLoc1.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc1);
			}
			else
			{
				itemID2=itemID;
				cursedName2=cursedName;
				isownded2=isowndedo;
				CursedWeaponLoc2.x = cursedWeaponLocation.x;
				CursedWeaponLoc2.y = cursedWeaponLocation.y;
				CursedWeaponLoc2.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc2);
			}
			
			/*
			switch (i)
			{
			case 0:
				debug ("i" @ i);
				debug ("itemID1" @ itemID);
				debug ("cursedName1" @ cursedName);
				itemID1=itemID;
				cursedName1=cursedName;
				isownded1=isowndedo;
				CursedWeaponLoc1.x = cursedWeaponLocation.x;
				CursedWeaponLoc1.y = cursedWeaponLocation.y;
				CursedWeaponLoc1.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc1);
				break;
			case 1:
				debug ("i" @ i);
				debug ("itemID2" @ itemID);
				debug ("cursedName2" @ cursedName);
				itemID2=itemID;
				cursedName2=cursedName;
				isownded2=isowndedo;
				CursedWeaponLoc2.x = cursedWeaponLocation.x;
				CursedWeaponLoc2.y = cursedWeaponLocation.y;
				CursedWeaponLoc2.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc2);
				break;
			}
			*/
		}
	}
	if(m_AdjustCursedLoc) 
	{
		m_AdjustCursedLoc=false;
		ListTrackItem2.GetSelectedRec(Record);
		CursedWeaponComboCurrentData = Record.LVDataList[0].nReserved1;

		if(num==1)
		{
			if( itemID == 8190 )
			{
				DrawCursedWeapon("MinimapWnd.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
			}
			else
			{
				DrawCursedWeapon("MinimapWnd.Minimap", itemID2, cursedName2, CursedWeaponLoc2, isownded2==0 , true);
			}
		}
		else if(num==2)
		{
			combined = class'UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd.Minimap", CursedWeaponLoc1.x, CursedWeaponLoc1.y, CursedWeaponLoc2.x, CursedWeaponLoc2.y);
			if(combined)
			{
				class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd.Minimap","L2UI_CH3.MiniMap.cursedmapicon00","L2UI_CH3.MiniMap.cursedmapicon00", cursedWeaponLoc1,true, 0, -12, cursedName1$"\\n"$cursedName2);			
			}	
			else
			{
				
				DrawCursedWeapon("MinimapWnd.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
				DrawCursedWeapon("MinimapWnd.Minimap", itemID2, cursedName2, CursedWeaponLoc2, isownded2==0 , false);
			}
		}
	
		
		
		if(CursedWeaponComboCurrentData==8190)
		{
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", cursedWeaponLoc1, false);			
		}
		else if(CursedWeaponComboCurrentData==8689)
		{
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", cursedWeaponLoc2, false);			
		}
		else
			AdjustMapToPlayerPosition(true);
	}
	else
	{
		if(num==1)
		{
			//DrawCursedWeapon("MinimapWnd.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
			if( itemID == 8190 )
			{
				DrawCursedWeapon("MinimapWnd.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
			}
			else
			{
				DrawCursedWeapon("MinimapWnd.Minimap", itemID2, cursedName2, CursedWeaponLoc2, isownded2==0 , true);
			}
		}
		else if(num==2)
		{
			combined = class'UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd.Minimap", CursedWeaponLoc1.x, CursedWeaponLoc1.y, CursedWeaponLoc2.x, CursedWeaponLoc2.y);
			if(combined)
			{
				class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd.Minimap","L2UI_CH3.MiniMap.cursedmapicon00","L2UI_CH3.MiniMap.cursedmapicon00", cursedWeaponLoc1,true, 0, -12, cursedName1$"\\n"$cursedName2);			
			}	
			else
			{
				
				DrawCursedWeapon("MinimapWnd.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
				DrawCursedWeapon("MinimapWnd.Minimap", itemID2, cursedName2, CursedWeaponLoc2, isownded2==0 , false);
			}
		}
	}
}

function DrawCursedWeapon(string WindowName, int itemID, string cursedName, Vector vecLoc, bool bDropped, bool bRefresh)
{
	local string itemIconName;

	if(itemID==8190)
	{
		ItemIconName="L2UI_CH3.MiniMap.cursedmapicon01";
	}
	else if(itemID==8689)
	{
		ItemIconName="L2UI_CH3.MiniMap.cursedmapicon02";
	}

	if(bDropped)
		ItemIconName=ItemIconName$"_drop";

	class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName,ItemIconName,"L2UI_CH3.MiniMap.cursedmapicon00", vecLoc, bRefresh, 0, -12, cursedName);
}

function HandleUpdateGameTime(string a_Param)
{
	local int GameHour;
	local int GameMinute;

	local string GameTimeString;

	ParseInt(a_Param, "GameHour", GameHour);
	ParseInt(a_Param, "GameMinute", GameMinute);

	GameTimeString = "";

	SelectSunOrMoon(GameHour);
	
	if ( GameHour == 0 )
		GameHour = 12;

		GameTimeString=GameTimeString$string(GameHour)$" : ";

	if(GameMinute<10)
		GameTimeString=GameTimeString$"0"$string(GameMinute);
	else
		GameTimeString=GameTimeString$string(GameMinute);

	class'UIAPI_TEXTBOX'.static.SetText("MinimapWnd.txtGameTime", GameTimeString);
}

function HandleMinimapTravel( String a_Param )
{
	local int TravelX;
	local int TravelY;

	if( !ParseInt( a_Param, "TravelX", TravelX ) )
		return;

	if( !ParseInt( a_Param, "TravelY", TravelY ) )
		return;

	ExecuteCommand( "//teleport" @ TravelX @ TravelY );
}

function SelectSunOrMoon(int GameHour)
{
	if ( GameHour >= 6 && GameHour <= 24 )
	{
		ShowWindow("MinimapWnd.texSun");
		HideWindow("MinimapWnd.texMoon");
	}
	else
	{
		ShowWindow("MinimapWnd.texMoon");
		HideWindow("MinimapWnd.texSun");
	}
}


function DrawPeaceStatusFortressSiegeStatus( string Param )
{
	local int ZoneID;
	
	ParseInt(Param,  "ZoneID",  ZoneID);
	G_ZoneID = ZoneID;
	if (ZoneID == 0)
	{
	}
	else
	{
			DrawMapBasicInfo(FortressID2ZoneNameID(ZoneID));
	}
}



function HandleShowFortressMapInfo(string Param)
{
	//~ local int ZoneID;
	
	ParseInt(Param, "FortressID", FortressID);
	ParseInt(Param, "SiegeStatus", SiegeStatus);
	ParseInt(Param, "TotalBarrackCnt", TotalBarrackCnt);
			
	
	//~ ZoneID = GetCurrentZoneID();
	
	if (SiegeStatus == 1)
	{
		if (FortressID2ZoneNameID(G_ZoneID2) == FortressID)
		{
			//~ m_MiniMap.EraseAllRegionInfo();
			//~ m_MiniMap_Expand.EraseAllRegionInfo();
			
			//~ debug("실행" @ FortressID2ZoneNameID(G_ZoneID2) @ FortressID);
			
			DrawMapMainInfo(FortressID);
		}
		else
		{
			//~ debug ("맞지않음" @ FortressID2ZoneNameID(G_ZoneID2) @ FortressID);
		}			
	}
	
	else if (SiegeStatus == 0)
	{
		Btn_Refresh.HideWindow();
		Btn_Refresh_Expand.HideWindow();
	}
	
	else if (SiegeStatus == 2)
	{
		DrawMapAfterBarrack(FortressID);
	}
}

function HandleFortressMapBarrackInfo(string Param)
{
	local int BarrackID;
	local int BarrackStatus;
	local string DataforMap;
	if (SiegeStatus == 1)
	{
	
		ParseInt(Param, "BarrackID", BarrackID);
		ParseInt(Param, "BarrackStatus", BarrackStatus);
		
		ParamAdd(DataforMap, "Index", String(BarrackID));
		ParamAdd(DataforMap, "WorldX", BarrackID2XLoc(FortressID, BarrackID));
		ParamAdd(DataforMap, "WorldY", BarrackID2YLoc(FortressID, BarrackID));
		
	
		
		if (BarrackStatus == 1 && GlobalCurFortressStatus)
		{
			switch (BarrackID2Int( FortressID, BarrackID))
			{
				case 1711:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				break;
				
				case 1708:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
				break;
				
				case 1713:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				break;
				
				case 1710:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				break;
				
				case 1714:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				break;
				
				case 1707:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				break;
				
				case 1709:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				break;
			}
		}
		
		else if (BarrackStatus == 0 && GlobalCurFortressStatus)
		{
			switch (BarrackID2Int( FortressID, BarrackID))
			{
				case 1711:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				break;
				
				case 1708:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				break;
				
				case 1713:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				break;
				
				case 1710:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				break;
				
				case 1714:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				break;
				
				case 1707:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				break;
				
				case 1709:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				break;
			}
		}
		
		ParamAdd(DataforMap, "BtnWidth", "33");
		ParamAdd(DataforMap, "BtnHeight", "33");
		
		if (BarrackStatus == 1)
		{
			ParamAdd(DataforMap, "Description", "");
		}
		
		else if (BarrackStatus == 0)
		{
			ParamAdd(DataforMap, "Description", "");
		}
		
		ParamAdd(DataforMap, "DescOffsetX", "0");
		ParamAdd(DataforMap, "DescOffsetY", "0");
		
		if (BarrackStatus == 1)
		{
			ParamAdd(DataforMap, "Tooltip", BarrackID2Text( FortressID, BarrackID) $ "\\n" $ GetSystemString(1715));
		}
		
		else if (BarrackStatus == 0)
		{
			ParamAdd(DataforMap, "Tooltip", BarrackID2Text( FortressID, BarrackID) $ "\\n" $ GetSystemString(1716));
		}
		
		m_MiniMap.AddRegionInfo(DataforMap);
		//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
	}
}

function string BarrackID2XLoc(int FortressID, int BarrackID)
{
	local int i;
	local string returnVal;
	
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == FortressID && loc_component[i] == BarrackID)
		{
			returnVal = string( loc_xloc[i] - REGIONINFO_OFFSETX);
		}
	}
	
	return returnVal;
}

function string BarrackID2YLoc(int FortressID, int BarrackID)
{
	local int i;
	local string returnVal;
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == FortressID && loc_component[i] == BarrackID)
		{
			returnVal =  string( loc_yloc[i] - REGIONINFO_OFFSETY) ;
		}
	}
	return returnVal;
}

function string BarrackID2Text(int FortressID, int BarrackID)
{
	local int i;
	local string returnStr;
	
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == FortressID && loc_component[i] == BarrackID)
		{
			returnStr = GetSystemstring( loc_sysstr[i] );
		}
	}
	return returnStr;
}

function int BarrackID2Int(int FortressID, int BarrackID)
{
	local int i;
	local int returnInt;
	
	//~ log("길이:"@loc_fortress.length);
	
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == FortressID && loc_component[i] == BarrackID)
		{
			returnInt =  loc_sysstr[i];
		}
	}
	return returnInt;
}

function DrawMapBasicInfo(int ReturnInt)
{
	local int i;
	local Vector loc;
	local string DataforMap;
	DataforMap = "";
	m_MiniMap.EraseAllRegionInfo();
	//~ m_MiniMap_Expand.EraseAllRegionInfo();
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == ReturnInt)
		{
			DataforMap = "";
			ParamAdd(DataforMap, "Index", string(i));
			ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - REGIONINFO_OFFSETX) );
			ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - REGIONINFO_OFFSETY) );

			switch (loc_sysstr[i])
			{
				case 1711:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Archer");
				break;
				
				case 1708:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				
				loc.x = loc_xloc[i];
				loc.y = loc_yloc[i];
				
				//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,true); 
				//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd_Expand.Minimap",loc,true);
				
				break;
				
				case 1713:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery");
				break;
				
				case 1710:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Magic");
				break;
				
				case 1714:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Officer");
				break;
				
				case 1707:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Prison");
				break;
				
				case 1709:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Shield");
				break;
			}
			
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");

			ParamAdd(DataforMap, "BtnWidth", "33");
			ParamAdd(DataforMap, "BtnHeight", "33");
			ParamAdd(DataforMap, "Description", "" );
			ParamAdd(DataforMap, "DescOffsetX", "-7");
			ParamAdd(DataforMap, "DescOffsetY", "7");
			ParamAdd(DataforMap, "Tooltip", GetSystemstring( loc_sysstr[i] ));
			
			
			m_MiniMap.AddRegionInfo(DataforMap);
			//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
			
		}
	}
}


function DrawMapAfterBarrack(int ReturnInt)
{
	local int i;
	local string DataforMap;
	local Vector loc;
	
	DataforMap = "";
	m_MiniMap.EraseAllRegionInfo();
	//~ m_MiniMap_Expand.EraseAllRegionInfo();
	DrawMapBasicInfo(FortressID2ZoneNameID(G_ZoneID));
	
	
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == ReturnInt)
		{
			DataforMap = "";
			ParamAdd(DataforMap, "Index", string(i));
			ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - REGIONINFO_OFFSETX) );
			ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - REGIONINFO_OFFSETY) );

			
			switch (loc_sysstr[i])
			{
				case 1711:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
				break;
				
				case 1708:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
				
				loc.x = loc_xloc[i];
				loc.y = loc_yloc[i];
				
				//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,true); 
				//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd_Expand.Minimap",loc,true);
					
				break;
				
				case 1713:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
				break;
				
				case 1710:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
				break;
			
				case 1714:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
				break;
				
				case 1707:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
				break;
				
				case 1709:
				ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
				break;
			}
			
			ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");
			ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow");

			ParamAdd(DataforMap, "BtnWidth", "33");
			ParamAdd(DataforMap, "BtnHeight", "33");
			ParamAdd(DataforMap, "Description", "" );
			ParamAdd(DataforMap, "DescOffsetX", "-7");
			ParamAdd(DataforMap, "DescOffsetY", "7");
			ParamAdd(DataforMap, "Tooltip", GetSystemstring( loc_sysstr[i] ));
			m_MiniMap.AddRegionInfo(DataforMap);
			//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
					}
	}
}



function DrawMapMainInfo(int ReturnInt)
{
	local int i;
	local Vector loc;
	
	local string DataforMap;
	DataforMap = "";
	for (i=0;i<loc_fortress.length;++i)
	{
		if (loc_fortress[i] == ReturnInt && loc_sysstr[i] == 1708)
		{
			DataforMap = "";
			ParamAdd(DataforMap, "Index", "9");
			ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - REGIONINFO_OFFSETX) );
			ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - REGIONINFO_OFFSETY) );
			
			ParamAdd(DataforMap, "BtnTexNormal", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
			ParamAdd(DataforMap, "BtnTexPushed", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
			ParamAdd(DataforMap, "BtnTexOver", 	"l2ui_ct1.MiniMap_DF_ICN_Center");
			loc.x = loc_xloc[i];
			loc.y = loc_yloc[i];
				
			//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",loc,true); 
			//~ class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd_Expand.Minimap",loc,true);	
			
			
			ParamAdd(DataforMap, "BtnWidth", "33");
			ParamAdd(DataforMap, "BtnHeight", "33");
			ParamAdd(DataforMap, "Description", "" );
			ParamAdd(DataforMap, "DescOffsetX", "-7");
			ParamAdd(DataforMap, "DescOffsetY", "7");
			ParamAdd(DataforMap, "Tooltip", GetSystemstring( loc_sysstr[i] ));
			m_MiniMap.AddRegionInfo(DataforMap);
			//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
		}
	}
}

function InitializeLocation()
{
	local Vector Location;
	if (m_CurContinent == 0) //Aden 대륙
	{
		Location.x = -86916;
		Location.y = 222183;
		Location.z = -4656;
		
	}
	else if (m_CurContinent == 1) //Gracia 대륙
	{
		Location.x = -181823;
		Location.y = 224580;
		Location.z = -4104;
	}
		
	m_MiniMap.adjustMapView(Location,  false);
}
function HandleDominionsOwnPos(string Param)
/* 
"DominionsOwnName	고유물이름 : string     -> 고유물은 나중에 classID가 넘어오게 됩니다. ClassID가지고 이름을 찾아내세요.
"PosX"  				X :INT
"PosY"   				Y : INT
"PosZ"   				Z : INT
 */
{ 
	local int DominionID;
	local int x;
	local int y;
	local int z;
	local string DataforMap;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	ParseInt	(Param, "DominionID", DominionID );
	ParseInt	(Param, "PosX", x );
	ParseInt	(Param, "PosY", y);
	ParseInt	(Param, "PosZ", z );
	DataforMap = "";
	data1.nReserved1 = DominionID;
	data2.nReserved2 = x;
	data3.nReserved3 = y;
	data3.nReserved2 = z;
	data1.szData = GetCastleName(DominionID);
	Record.LVDataList[0] = data1;
	Record.LVDataList[1] = data2;
	Record.LVDataList[2] = data3;
	ListTrackItem3.InsertRecord( Record );
	//~ ListTrackItem3.SetSelectedNum(
	ParamAdd(DataforMap, "Index", string(DominionID));
	ParamAdd(DataforMap, "WorldX", string(x - REGIONINFO_OFFSETX) );
	ParamAdd(DataforMap, "WorldY", string(y - REGIONINFO_OFFSETY) );
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip",GetCastleName(DominionID) @ GetSystemString(2216)); //"수호물" 한글 하드코딩 수정

	switch(DominionID)
	{
		case 81:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio");
			break;
	
		case 82:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_dion");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_dion");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_dion");
			break;
	
		case 83:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_giran");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_giran");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_giran");
			break;
	
		case 84:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_oren");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_oren");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_oren");
			break;
	
		case 85:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_aden");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_aden");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_aden");
			break;
	
		case 86:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril");
			break;
	
		case 87:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_godard");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_godard");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_godard");
			break; 
	
		case 88:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_rune");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_rune");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_rune");
			break;
	
		case 89:
			ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart");
			ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart");
			ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart");
			break;
	}

	ParamAdd(DataforMap, "BtnWidth", "26");
	ParamAdd(DataforMap, "BtnHeight", "30");
	m_MiniMap.AddRegionInfo(DataforMap);
	//~ debug (DataforMap);
	m_Dominion = true;
	DrawDominionTarget();
}

function DrawCleftStatus()
{
	local int i;
	local string DataforMap;
	if (CleftCurTriggerWnd.IsShowWindow())
	{
		for (i=0;i<=5; i++)
		{
			DataforMap = "";
			ParamAdd(DataforMap, "Index", "9");
			ParamAdd(DataforMap, "WorldX", string(loc_cleftx[i] - REGIONINFO_OFFSETX) );
			ParamAdd(DataforMap, "WorldY", string(loc_clefty[i] - REGIONINFO_OFFSETY) );
			
			ParamAdd(DataforMap, "BtnTexNormal", 	loc_cleftIcon[i]);
			ParamAdd(DataforMap, "BtnTexPushed", 	loc_cleftIcon[i]);
			ParamAdd(DataforMap, "BtnTexOver", 	loc_cleftIcon[i]);
			
			//~ loc.x = loc_xloc[i];
			//~ loc.y = loc_yloc[i];
			
			ParamAdd(DataforMap, "BtnWidth", "33");
			ParamAdd(DataforMap, "BtnHeight", "33");
			ParamAdd(DataforMap, "Description", "" );
			ParamAdd(DataforMap, "DescOffsetX", "-7");
			ParamAdd(DataforMap, "DescOffsetY", "7");
			ParamAdd(DataforMap, "Tooltip", loc_cleftName[i]);
			m_MiniMap.AddRegionInfo(DataforMap);
	
		}
	}
}
function SetContinent(int continent)
{
	m_CurContinent = continent;
	m_MiniMap.SetContinent(m_CurContinent);
	if (m_CurContinent == 1)
		m_MapSelectTab.SetTopOrder(0, true);
	else if(m_CurContinent == 0)
		m_MapSelectTab.SetTopOrder(1, true);
}
function SetLocContinent(vector loc)
{
	m_CurContinent =  GetContinent(loc);
	m_MiniMap.SetContinent(m_CurContinent);
	if (m_CurContinent == 1)
		m_MapSelectTab.SetTopOrder(0, true);
	else if(m_CurContinent == 0)
		m_MapSelectTab.SetTopOrder(1, true);
}
function int GetContinent(vector loc)
{
	if (loc.X < -163840)
	{
		return 1;		//Gracia
	}
	else
	{
		return 0;		//Aden
	}
}
defaultproperties
{
}
