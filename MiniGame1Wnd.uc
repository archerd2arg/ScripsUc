//////////////////////////////////////////////////////////////////////////////////////////////
//  L2 MINI GAME - 6Elements Bejeweled AKA MINIGAME1WND
//////////////////////////////////////////////////////////////////////////////////////////////
/* Note

L2 Minigame is independent UIScript game totally generated by L2 UnrealScript.
The script constructs DataObject called MG1CellData.

UI Designed and UC Programmed by Oxyzen.

*/
class MiniGame1Wnd extends UIScriptEx;
const 	MAX_COLOR = 	6;
const 	MAX_ROW = 		8;
const 	TOTAL_GRID = 	64;
const 	IDLE_NUMBER =	999;
const	TIMER_ID1	=	1260;	
const 	TIMER_DELAY1	=	300;	
const	TIMER_ID2	= 	1261;
const	TIMER_DELAY2	=	500;
const	TIMER_ID3	=	1262;
const	TIMER_DELAY3	= 	300;
const	TIMER_ID4	=	1263;
const	TIMER_DELAY4	= 	5;
const	TIMER_ID5	=	1264;
const	TIMER_DELAY5	= 	300;
const	TARGETSCORESEED = 300;

struct native MG1CellData
{
	var int			X, Y, RV;
	var String			BtnTex;		
	var Bool			isFlagged;
	var TextureHandle	TextureLoc;
	var ButtonHandle		ButtonLoc;
	var AnimTextureHandle	AnimLoc;
};
var MG1CellData			CellGridData[TOTAL_GRID];
var WindowHandle 		ME;
var TextureHandle 		MGTex0[MAX_ROW], MGTex1[MAX_ROW], MGTex2[MAX_ROW], MGTex3[MAX_ROW], MGTex4[MAX_ROW], MGTex5[MAX_ROW], MGTex6[MAX_ROW], MGTex7[MAX_ROW];
var ButtonHandle 		MGBtn0[MAX_ROW], MGBtn1[MAX_ROW], MGBtn2[MAX_ROW], MGBtn3[MAX_ROW], MGBtn4[MAX_ROW], MGBtn5[MAX_ROW], MGBtn6[MAX_ROW], MGBtn7[MAX_ROW];
var AnimTextureHandle		MGAnim0[MAX_ROW], MGAnim1[MAX_ROW], MGAnim2[MAX_ROW], MGAnim3[MAX_ROW], MGAnim4[MAX_ROW], MGAnim5[MAX_ROW], MGAnim6[MAX_ROW], MGAnim7[MAX_ROW];
var ButtonHandle			MG_BTNChallenge,MG_BTNClose;
var ProgressCtrlHandle 		ProgressBar;
var TextureHandle 		ResultTex;
var string 				TX[6];
var bool				m_InGamingBool, m_IsNewGamingBool, m_PauseBool;
var int 				m_MatchCount,m_CellBtnStatus,m_CellBtnID1,m_CellBtnID2,m_CurrentLevel,m_CurrentTimer,m_CurrentScore,m_TargetScore,m_CountNumberofChains,m_CurrentAnimID;

//branch
var ButtonHandle		BtnRanking;
var WindowHandle 		MiniGameRankWnd;
var int		m_bUseJapanStyle;
//end of branch

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowMinigame1 );
}

function OnLoad()
/* Description : Initialize CellGridData Array and window handle elements.
Referenced by: Reserved Function */
{
	local int i;

	//branch
	m_bUseJapanStyle = 0;
	GetINIBool("Localize", "UseJapanMinigame1", m_bUseJapanStyle, "L2.ini");
	//end of branch
	
	if(CREATE_ON_DEMAND==0)
	{
		//branch
		BtnRanking = ButtonHandle(GetHandle("MiniGame1Wnd.BtnRanking"));
		MiniGameRankWnd = GetHandle("BR_MiniRankWnd");
		//end of branch
		
		me = GetHandle("MiniGame1Wnd");
		ProgressBar = ProgressCtrlHandle(GetHandle("MG_Progress"));
		ResultTex = TextureHandle(GetHandle("MG_RESULT"));
		MG_BTNChallenge = ButtonHandle(GetHandle("MG_BTNChallenge"));
		MG_BTNClose = ButtonHandle(GetHandle("MG_BTNClose"));
		for (i=0; i<MAX_ROW; i++)
		{
			MGTex0[i] = 	TextureHandle(GetHandle("MG_Texture-0-"$i));
			MGBtn0[i] = 	ButtonHandle(GetHandle("MG_Button-0-"$i));
			MGAnim0[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-0-"$i));
			CellGridData[i+(MAX_ROW*0)].ButtonLoc = MGBtn0[i];
			CellGridData[i+(MAX_ROW*0)].TextureLoc = MGTex0[i];
			CellGridData[i+(MAX_ROW*0)].AnimLoc =MGAnim0[i];
			CellGridData[i+(MAX_ROW*0)].X = 0;
			CellGridData[i+(MAX_ROW*0)].Y = i;
			MGTex1[i] = TextureHandle(GetHandle("MG_Texture-1-"$i));
			MGBtn1[i] = ButtonHandle(GetHandle("MG_Button-1-"$i));
			MGAnim1[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-1-"$i));
			CellGridData[i+(MAX_ROW*1)].ButtonLoc = MGBtn1[i];
			CellGridData[i+(MAX_ROW*1)].TextureLoc = MGTex1[i];
			CellGridData[i+(MAX_ROW*1)].AnimLoc =MGAnim1[i];
			CellGridData[i+(MAX_ROW*1)].X = 1;
			CellGridData[i+(MAX_ROW*1)].Y = i;
			MGTex2[i] = TextureHandle(GetHandle("MG_Texture-2-"$i));
			MGBtn2[i] = ButtonHandle(GetHandle("MG_Button-2-"$i));
			MGAnim2[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-2-"$i));
			CellGridData[i+(MAX_ROW*2)].ButtonLoc = MGBtn2[i];
			CellGridData[i+(MAX_ROW*2)].TextureLoc = MGTex2[i];
			CellGridData[i+(MAX_ROW*2)].AnimLoc =MGAnim2[i];
			CellGridData[i+(MAX_ROW*2)].X = 2;
			CellGridData[i+(MAX_ROW*2)].Y = i;
			MGTex3[i] = TextureHandle(GetHandle("MG_Texture-3-"$i));
			MGBtn3[i] = ButtonHandle(GetHandle("MG_Button-3-"$i));
			MGAnim3[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-3-"$i));
			CellGridData[i+(MAX_ROW*3)].ButtonLoc = MGBtn3[i];
			CellGridData[i+(MAX_ROW*3)].TextureLoc = MGTex3[i];
			CellGridData[i+(MAX_ROW*3)].AnimLoc =MGAnim3[i];
			CellGridData[i+(MAX_ROW*3)].X = 3;
			CellGridData[i+(MAX_ROW*3)].Y = i;
			MGTex4[i] = TextureHandle(GetHandle("MG_Texture-4-"$i));
			MGBtn4[i] = ButtonHandle(GetHandle("MG_Button-4-"$i));
			MGAnim4[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-4-"$i));
			CellGridData[i+(MAX_ROW*4)].ButtonLoc = MGBtn4[i];
			CellGridData[i+(MAX_ROW*4)].TextureLoc = MGTex4[i];
			CellGridData[i+(MAX_ROW*4)].AnimLoc =MGAnim4[i];
			CellGridData[i+(MAX_ROW*4)].X = 4;
			CellGridData[i+(MAX_ROW*4)].Y = i;
			MGTex5[i] = TextureHandle(GetHandle("MG_Texture-5-"$i));
			MGBtn5[i] = ButtonHandle(GetHandle("MG_Button-5-"$i));
			MGAnim5[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-5-"$i));
			CellGridData[i+(MAX_ROW*5)].ButtonLoc = MGBtn5[i];
			CellGridData[i+(MAX_ROW*5)].TextureLoc = MGTex5[i];
			CellGridData[i+(MAX_ROW*5)].AnimLoc =MGAnim5[i];
			CellGridData[i+(MAX_ROW*5)].X = 5;
			CellGridData[i+(MAX_ROW*5)].Y = i;
			MGTex6[i] = TextureHandle(GetHandle("MG_Texture-6-"$i));
			MGBtn6[i] = ButtonHandle(GetHandle("MG_Button-6-"$i));
			MGAnim6[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-6-"$i));
			CellGridData[i+(MAX_ROW*6)].ButtonLoc = MGBtn6[i];
			CellGridData[i+(MAX_ROW*6)].TextureLoc = MGTex6[i];
			CellGridData[i+(MAX_ROW*6)].AnimLoc =MGAnim6[i];
			CellGridData[i+(MAX_ROW*6)].X = 6;
			CellGridData[i+(MAX_ROW*6)].Y = i;
			MGTex7[i] = TextureHandle(GetHandle("MG_Texture-7-"$i));
			MGBtn7[i] = ButtonHandle(GetHandle("MG_Button-7-"$i));
			MGAnim7[i] =	AnimTextureHandle(GetHandle("MG_AnimTexture-7-"$i));
			CellGridData[i+(MAX_ROW*7)].ButtonLoc = MGBtn7[i];
			CellGridData[i+(MAX_ROW*7)].TextureLoc = MGTex7[i];
			CellGridData[i+(MAX_ROW*7)].AnimLoc =MGAnim7[i];
			CellGridData[i+(MAX_ROW*7)].X = 7;
			CellGridData[i+(MAX_ROW*7)].Y = i;
		}
	}
	else
	{
		//branch
		BtnRanking = GetButtonHandle("MiniGame1Wnd.BtnRanking");
		MiniGameRankWnd = GetWindowHandle("BR_MiniGameRankWnd");
		//end of branch

		me = GetWindowHandle("MiniGame1Wnd");
		ProgressBar = GetProgressCtrlHandle("MG_Progress");
		ResultTex = GetTextureHandle("MG_RESULT");
		MG_BTNChallenge = GetButtonHandle("MG_BTNChallenge");
		MG_BTNClose = GetButtonHandle("MG_BTNClose");
		for (i=0; i<MAX_ROW; i++)
		{
			MGTex0[i] = 	GetTextureHandle("MG_Texture-0-"$i);
			MGBtn0[i] = 	GetButtonHandle("MG_Button-0-"$i);
			MGAnim0[i] =	GetAnimTextureHandle("MG_AnimTexture-0-"$i);
			CellGridData[i+(MAX_ROW*0)].ButtonLoc = MGBtn0[i];
			CellGridData[i+(MAX_ROW*0)].TextureLoc = MGTex0[i];
			CellGridData[i+(MAX_ROW*0)].AnimLoc =MGAnim0[i];
			CellGridData[i+(MAX_ROW*0)].X = 0;
			CellGridData[i+(MAX_ROW*0)].Y = i;
			MGTex1[i] = GetTextureHandle("MG_Texture-1-"$i);
			MGBtn1[i] = GetButtonHandle("MG_Button-1-"$i);
			MGAnim1[i] =	GetAnimTextureHandle("MG_AnimTexture-1-"$i);
			CellGridData[i+(MAX_ROW*1)].ButtonLoc = MGBtn1[i];
			CellGridData[i+(MAX_ROW*1)].TextureLoc = MGTex1[i];
			CellGridData[i+(MAX_ROW*1)].AnimLoc =MGAnim1[i];
			CellGridData[i+(MAX_ROW*1)].X = 1;
			CellGridData[i+(MAX_ROW*1)].Y = i;
			MGTex2[i] = GetTextureHandle("MG_Texture-2-"$i);
			MGBtn2[i] = GetButtonHandle("MG_Button-2-"$i);
			MGAnim2[i] =	GetAnimTextureHandle("MG_AnimTexture-2-"$i);
			CellGridData[i+(MAX_ROW*2)].ButtonLoc = MGBtn2[i];
			CellGridData[i+(MAX_ROW*2)].TextureLoc = MGTex2[i];
			CellGridData[i+(MAX_ROW*2)].AnimLoc =MGAnim2[i];
			CellGridData[i+(MAX_ROW*2)].X = 2;
			CellGridData[i+(MAX_ROW*2)].Y = i;
			MGTex3[i] = GetTextureHandle("MG_Texture-3-"$i);
			MGBtn3[i] = GetButtonHandle("MG_Button-3-"$i);
			MGAnim3[i] =	GetAnimTextureHandle("MG_AnimTexture-3-"$i);
			CellGridData[i+(MAX_ROW*3)].ButtonLoc = MGBtn3[i];
			CellGridData[i+(MAX_ROW*3)].TextureLoc = MGTex3[i];
			CellGridData[i+(MAX_ROW*3)].AnimLoc =MGAnim3[i];
			CellGridData[i+(MAX_ROW*3)].X = 3;
			CellGridData[i+(MAX_ROW*3)].Y = i;
			MGTex4[i] = GetTextureHandle("MG_Texture-4-"$i);
			MGBtn4[i] = GetButtonHandle("MG_Button-4-"$i);
			MGAnim4[i] =	GetAnimTextureHandle("MG_AnimTexture-4-"$i);
			CellGridData[i+(MAX_ROW*4)].ButtonLoc = MGBtn4[i];
			CellGridData[i+(MAX_ROW*4)].TextureLoc = MGTex4[i];
			CellGridData[i+(MAX_ROW*4)].AnimLoc =MGAnim4[i];
			CellGridData[i+(MAX_ROW*4)].X = 4;
			CellGridData[i+(MAX_ROW*4)].Y = i;
			MGTex5[i] = GetTextureHandle("MG_Texture-5-"$i);
			MGBtn5[i] = GetButtonHandle("MG_Button-5-"$i);
			MGAnim5[i] =	GetAnimTextureHandle("MG_AnimTexture-5-"$i);
			CellGridData[i+(MAX_ROW*5)].ButtonLoc = MGBtn5[i];
			CellGridData[i+(MAX_ROW*5)].TextureLoc = MGTex5[i];
			CellGridData[i+(MAX_ROW*5)].AnimLoc =MGAnim5[i];
			CellGridData[i+(MAX_ROW*5)].X = 5;
			CellGridData[i+(MAX_ROW*5)].Y = i;
			MGTex6[i] = GetTextureHandle("MG_Texture-6-"$i);
			MGBtn6[i] = GetButtonHandle("MG_Button-6-"$i);
			MGAnim6[i] =	GetAnimTextureHandle("MG_AnimTexture-6-"$i);
			CellGridData[i+(MAX_ROW*6)].ButtonLoc = MGBtn6[i];
			CellGridData[i+(MAX_ROW*6)].TextureLoc = MGTex6[i];
			CellGridData[i+(MAX_ROW*6)].AnimLoc =MGAnim6[i];
			CellGridData[i+(MAX_ROW*6)].X = 6;
			CellGridData[i+(MAX_ROW*6)].Y = i;
			MGTex7[i] = GetTextureHandle("MG_Texture-7-"$i);
			MGBtn7[i] = GetButtonHandle("MG_Button-7-"$i);
			MGAnim7[i] =	GetAnimTextureHandle("MG_AnimTexture-7-"$i);
			CellGridData[i+(MAX_ROW*7)].ButtonLoc = MGBtn7[i];
			CellGridData[i+(MAX_ROW*7)].TextureLoc = MGTex7[i];
			CellGridData[i+(MAX_ROW*7)].AnimLoc =MGAnim7[i];
			CellGridData[i+(MAX_ROW*7)].X = 7;
			CellGridData[i+(MAX_ROW*7)].Y = i;
		}
	}
	
	//branch
	if (m_bUseJapanStyle == 1) {
		TX[0] = "BranchSys.ui." $ "MiniGame_DF_Icon_DarkElf";
		TX[1] = "BranchSys.ui." $ "MiniGame_DF_Icon_Dwarf";
		TX[2] = "BranchSys.ui." $ "MiniGame_DF_Icon_Elf";
		TX[3] = "BranchSys.ui." $ "MiniGame_DF_Icon_Kamael";
		TX[4] = "BranchSys.ui." $ "MiniGame_DF_Icon_Orc";
		TX[5] = "BranchSys.ui." $ "MiniGame_DF_Icon_Human";
	}
	else {
		TX[0] = "l2ui_ct1." $ "MiniGame_DF_Icon_Dark";
		TX[1] = "l2ui_ct1." $ "MiniGame_DF_Icon_Divine";
		TX[2] = "l2ui_ct1." $ "MiniGame_DF_Icon_Earth";
		TX[3] = "l2ui_ct1." $ "MiniGame_DF_Icon_Fire";
		TX[4] = "l2ui_ct1." $ "MiniGame_DF_Icon_Water";
		TX[5] = "l2ui_ct1." $ "MiniGame_DF_Icon_Wind";
	}
	//end of branh
	
	m_InGamingBool = false;
	ClearCellGridData();
}
function OnEvent(int EvID, string param)
{
	if (EvID == EV_ShowMinigame1)
		ME.ShowWindow();
}
function ClearScoreData()
{
	m_CurrentLevel = 0;
	m_CurrentTimer = 20;
	m_CurrentScore = 0;
	PutNumberLevel(m_CurrentLevel);
	PutNumberScore(m_CurrentScore);
}
function ClearCellGridData()
/* Description : Initialize entire CellGridData Array.
Referenced by: OnLoad() */
{
	local int i;
	for (i =0; i<TOTAL_GRID; i ++)
	{
		CellGridData[i].RV = 0;
		CellGridData[i].BtnTex = "";
		CellGridData[i].isFlagged = false;
	}
}
function OnShow()
/* Description: Clear and Initialize Game Screen.
 * Referenced by: Reserved Function.
 */
{
	Initialize();
	MG_BTNClose.SetNameText( GetSystemString(908) );
	PutNumberLevel(0);
	PutNumberScore(0);
	MG_BTNChallenge.EnableWindow();
}
function ReadyCells()
{
	local int i;
	for (i = 0; i<TOTAL_GRID; i++)
	{
		Randomize(i);
	}
	MoveTillnoMatches();
}
function MoveTillnoMatches()
{
	CheckMatches(false);
	CountMatches();
	While(m_MatchCount >0)
	{
		CheckMoves();
		CheckMatches(false);
		CountMatches();
	}
}
function ClearCellGridDataFlag()
/* Description : Initialize entire CellGridData Flag Array.
Referenced by: MoveTillnoMatches() */
{
	local int i;
	for (i =0; i<TOTAL_GRID; i ++)
	{
		CellGridData[i].isFlagged = false;
	}
}
function CountMatches()
{
	local int i;
	m_MatchCount=0;
	for (i=0;i<TOTAL_GRID; i++)
	{
		if(CellGridData[i].isFlagged)
		{
			m_MatchCount = m_MatchCount +1;
		}
	}
}
function CheckMoves()
{
	local int i;
	
	for (i=0; i <TOTAL_GRID; i++)
	{
		if (CellGridData[i].isFlagged)
		{
			m_IsNewGamingBool = true;
			PushDownRow(i);
			CheckMatches(false);
		}
	}
}
function PushDownRow(int ID)
{
	local int i;
	local int startpointID;
	local ButtonHandle temp1;
	local AnimTextureHandle TempAnim;
	local int CntScore;
	CntScore = 0;
	if (CellGridData[ID].isFlagged)
	{
		startpointID = GetCellGridID(0, CellGridData[ID].Y);
		if (!m_IsNewGamingBool)
		{
			TempAnim = CellGridData[ID].AnimLoc;
			TempAnim.ShowWindow();
			TempAnim.Play();
		}
		if (CellGridData[ID] == CellGridData[startpointID] )
		{
			Randomize(ID);
			CellGridData[ID].isFlagged = false;
		}
		else
		{
			for (i=ID; i >=startpointID; i=i-MAX_ROW)
			{
				if (i !=startpointID)
				{
					CellGridData[i].RV 		=	CellGridData[i-MAX_ROW].RV; 		
					CellGridData[i].BtnTex	=	CellGridData[i-MAX_ROW].BtnTex;
					CellGridData[i].isFlagged	= 	CellGridData[i-MAX_ROW].isFlagged;
					temp1= CellGridData[i].ButtonLoc;
					temp1.SetTexture(CellGridData[i].BtnTex, CellGridData[i].BtnTex, CellGridData[i].BtnTex$"_over");
					//~ Playsound("ItemSound3.minigame_game_over");
				}
				else if (i==startpointID)
				{
					Randomize(i);
					CellGridData[ID].isFlagged = false;
				}
			}
		}
	}
	m_IsNewGamingBool = false;
}
function Initialize()
/* Description: Initializes Window Settings and resets all the data to the initial upon beginning of the game.
 * Referenced by: OnShow();
 */
{
	local int i;
	local ButtonHandle tempButton;
	local TextureHandle tempTexture;
	local AnimTextureHandle tempAnim;
	for (i=0; i<TOTAL_GRID; i++)
	{
		tempButton = CellGridData[i].ButtonLoc;
		tempTexture = CellGridData[i].TextureLoc;
		tempAnim =CellGridData[i].AnimLoc;
		tempButton.HideWindow();
		tempTexture.HideWindow();
		tempAnim.SetLoopCount(1);
		tempAnim.HideWindow();
		tempAnim.Stop();
		
		
	}
	ResultTex.HideWindow();
	ProgressBar.Reset();
	ProgressBar.Stop();
	m_CurrentAnimID = 0;
	m_CellBtnStatus = 0;
	m_CellBtnID1 = IDLE_NUMBER;
	m_CellBtnID2 = IDLE_NUMBER;
	MG_BTNClose.SetNameText( GetSystemString(908) );

	//branch	
	if (m_bUseJapanStyle != 1) {
		BtnRanking.SetNameText("");
		BtnRanking.SetTexture("","","");
		BtnRanking.HideWindow();
	}
	//end of branch
}
function Randomize(int ID)
/* Description: Randomize the MiniGameData and Reset all the texture data sequences.
 * Referenced by: OnShow()
 */
{
	local int RV;
	//~ local int i;
	//~ local string BtnParam;
	local ButtonHandle TempButton;
	RV =Rand(MAX_COLOR);
	CellGridData[ID].RV = RV;
	CellGridData[ID].BtnTex = TX[RV];
	CellGridData[ID].isFlagged = false;
	TempButton = CellGridData[ID].ButtonLoc;
	TempButton.SetTexture(CellGridData[ID].BtnTex, CellGridData[ID].BtnTex, CellGridData[ID].BtnTex$"_Over" );
	TempButton.ShowWindow();
}
function CheckMatches(bool ClearButton)
/* Description: Checks every matches on the panel and removes matched buttons on Every Move Events
 * Referenced by: OnShow();
 */
{
	//~ local int x;
	//~ local int y;
	local int i;
	local ButtonHandle TempBtn;
	local TextureHandle TempTex;
	//~ local AnimTextureHandle tempAnim;
	for (i=0; i<TOTAL_GRID; i++)
	{
		TempTex = CellGridData[i].TextureLoc;
		TempTex.HideWindow();
		CellGridData[i].isFlagged = false;
	}
	for (i=0; i<TOTAL_GRID; i++)
	{
		if(CellGridData[i].X >0 && CellGridData[i].X < MAX_ROW-1)
		{
			if (CellGridData[i].RV == CellGridData[i-MAX_ROW].RV && CellGridData[i].RV == CellGridData[i + MAX_ROW].RV)
			{ 
				CellGridData[i].isFlagged = true;
				CellGridData[i-MAX_ROW].isFlagged = true;
				CellGridData[i+MAX_ROW].isFlagged = true;
				TempTex = CellGridData[i].TextureLoc;
				TempTex.ShowWindow();
				TempTex = CellGridData[i-MAX_ROW].TextureLoc;
				TempTex.ShowWindow();
				TempTex = CellGridData[i+MAX_ROW].TextureLoc;
				TempTex.ShowWindow();
				if (ClearButton)
				{
					TempBtn = CellGridData[i].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
					TempBtn = CellGridData[i-MAX_ROW].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
					TempBtn = CellGridData[i+MAX_ROW].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
				}
			}
		}
		if (CellGridData[i].Y >0 && CellGridData[i].Y < MAX_ROW-1)
		{
			if (CellGridData[i].RV == CellGridData[i-1].RV && CellGridData[i].RV == CellGridData[i+1].RV)
			{ 
				CellGridData[i].isFlagged = true;
				CellGridData[i-1].isFlagged = true;
				CellGridData[i+1].isFlagged = true;
				
				TempTex = CellGridData[i].TextureLoc;
				TempTex.ShowWindow();
				TempTex = CellGridData[i-1].TextureLoc;
				TempTex.ShowWindow();
				TempTex = CellGridData[i+1].TextureLoc;
				TempTex.ShowWindow();
				
				if (ClearButton)
				{
					TempBtn = CellGridData[i].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
					TempBtn = CellGridData[i-1].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
					TempBtn = CellGridData[i+1].ButtonLoc;
					TempBtn.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
				}
			}
		}
	}
}
function OnClickButton( string strID )
{	
	local int BTNID;
	local int BTNID1;
	local int BTNID2;
	BTNID = Len(strID);
	if (BTNID == 13 && m_InGamingBool)
	{
		BTNID1 = int (MID (strID, 10, 1));
		BTNID2 = int (RIGHT(strID, 1));
		OnClickCellIcon(BTNID1, BTNID2);
		Playsound("ItemSound3.minigame_click");
	}
	if (strID =="MG_BTNChallenge")
	{
		if (m_InGamingBool)
		{
			PauseGame();
		}
		else 
		{
			m_CurrentLevel = 0;
			m_TargetScore = 0;
			m_CurrentScore = 0;
			m_PauseBool = false;
			StartNewGame();
			PutNumberLevel(m_CurrentLevel);
			PutNumberScore(m_CurrentScore);
		}
	}
	if (strID =="MG_BTNClose")
	{
		if (m_InGamingBool)
		{
			if (m_PauseBool)
			{
				PauseGame();
			}
			EndGame();
		}
		else 
		{
			Me.HideWindow();
		}
	}
	//branch
	if (strID == "BtnRanking" && m_bUseJapanStyle == 1)
	{
		if(MiniGameRankWnd.isShowWindow()) {
			MiniGameRankWnd.HideWindow();
		}	
		else {
			MiniGameRankWnd.ShowWindow();
			RequestBR_MinigameLoadScores(); // 랭킹 요청
		}			
	}
	//end of branch
}

function PauseGame()
{
	local int i;
	local ButtonHandle temp1;
	
	if (!m_PauseBool)
	{
		ProgressBar.Stop();
		for (i=0; i<TOTAL_GRID; i++)
		{
			temp1= CellGridData[i].ButtonLoc;
			//~ m_InGamingBool = false;
			temp1.HideWindow();
			
		}
		MG_BTNChallenge.SetNameText( GetSystemString(1731) );
		//~ MG_BTNClose.SetNameText( GetSystemString(1729) );
		
	}
	else
	{
		ProgressBar.Resume();
		for (i=0; i<TOTAL_GRID; i++)
		{
			temp1= CellGridData[i].ButtonLoc;
			//~ m_InGamingBool = false;
			temp1.ShowWindow();
		}
		MG_BTNChallenge.SetNameText( GetSystemString(1073) );
	}

	if (m_PauseBool)
		{
			m_PauseBool =false;
		}
		else
		{
			m_PauseBool =true;
		}
}
function OnHide()
{
	//branch
	MG_BTNChallenge.SetNameText( GetSystemString(1728) );
	if(m_InGamingBool && m_bUseJapanStyle == 1) {
		if(m_CurrentScore!=0) {
			RequestBR_MinigameInsertScore(m_CurrentScore); // 내 점수 서버로 전송			
		}		
	}
	if(MiniGameRankWnd.isShowWindow()) {
			MiniGameRankWnd.HideWindow(); // 랭킹 창도 닫음
	}
	//end of branch	
	m_InGamingBool = false;
	Me.KillTimer( TIMER_ID1 );
	Me.KillTimer( TIMER_ID2 );
	Me.KillTimer( TIMER_ID3 );
	Me.KillTimer( TIMER_ID4 );
	Me.KillTimer( TIMER_ID5 );
}
function StartNewGame()
{
	Initialize();
	m_InGamingBool = true;
	MG_BTNChallenge.DisableWindow(); //branch - '도전' 버튼 비활성화
	//MG_BTNChallenge.SetNameText( GetSystemString(1073) ); //branch - 게임이 시작된 이후에 '도전' 버튼이 '일시정지' 버튼으로 바뀌도록 수정. Line 750로 옮김
	MG_BTNClose.SetNameText( GetSystemString(1732) );
	ResultTex.SetAlpha( 255, 0 );
	ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Ready");
	Playsound("ItemSound3.minigame_start");
	ResultTex.ShowWindow();
	ResultTex.SetAlpha( 0, 0.9f );
	Me.SetTimer(TIMER_ID2, 1000);
}

function StartNewGameProc()
{
	ReadyCells();
	m_CurrentLevel = m_CurrentLevel + 1;
	PutNumberLevel(m_CurrentLevel);
	m_TargetScore = m_TargetScore + GetTargetScore(m_CurrentLevel);
	ProgressBar.SetProgressTime(GetCurrentTimeLimit(m_CurrentLevel));
	ProgressBar.Start();
}

function RestartCurrentGame()
{
	Initialize();
	m_InGamingBool = false;
	MG_BTNClose.SetNameText( GetSystemString(908) );
	MG_BTNChallenge.SetNameText( GetSystemString(1073) );
	ResultTex.SetAlpha( 255, 0 );
	ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Ready");
	Playsound("ItemSound3.minigame_start");
	ResultTex.ShowWindow();
	ResultTex.SetAlpha( 0, 0.9f );
	Me.SetTimer(TIMER_ID2, 1000);
}

function OnTimeOver()
{
	m_InGamingBool = false;
	EndGamewithTimeOut();
}


function OnClickCellIcon(int X, int Y)
{
	local int ID;
	local TextureHandle TempTex;
	local ButtonHandle	TempBtn;
	ID = GetCellGridID(X, Y);
	TempTex = CellGridData[ID].TextureLoc;
	TempBtn = CellGridData[ID].ButtonLoc;
	if (!TempTex.IsShowWindow() && m_CellBtnStatus==0)
	{
		TempTex.ShowWindow();
		m_CellBtnStatus = 1;
		m_CellBtnID1 = ID;
	}
	else if (TempTex.IsShowWindow() && m_CellBtnStatus==1)
	{
		TempTex.HideWindow();
		m_CellBtnID1 = IDLE_NUMBER;
		m_CellBtnStatus = 0;
	}
	else if (!TempTex.IsShowWindow() && m_CellBtnStatus==1)
	{
		TempTex.ShowWindow();
		if (CheckSwappable(m_CellBtnID1, ID))
		{
			TempTex=CellGridData[m_CellBtnID1].TextureLoc;
			m_CellBtnStatus = 0;
			m_CellBtnID1 = IDLE_NUMBER;
			//~ ProgressBar.Reset();
			//~ ProgressBar.Start();
			ProgressBar.Stop(); //branch 타이머 종료 직전 그림을 맞추었을 때 타이머가 계속 돌아 게임이 끝나버리는 것을 막기 위해.
			Me.SetTimer(TIMER_ID1,TIMER_DELAY1);
		}
		else
		{
			TempTex.HideWindow();
			TempTex=CellGridData[m_CellBtnID1].TextureLoc;
			TempTex.HideWindow();
			m_CellBtnStatus = 0;
		}
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID1)
	{
		if (CheckMovesOnTimer())
		{
			m_InGamingBool = true;
			ProgressBar.Reset();
			if (m_CurrentScore >= m_TargetScore)
			{
				Me.KillTimer( TIMER_ID1 );
				StartLevelUp();
				
			}
			else
			{
				Me.KillTimer( TIMER_ID1 );
				ProgressBar.Reset();
				ProgressBar.Start();
			}
		}
	}
	if(TimerID == TIMER_ID2)
	{
		ResultTex.SetAlpha( 255, 0 );
		ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Start");
		Playsound("ItemSound3.minigame_start");
		ResultTex.ShowWindow();
		ResultTex.SetAlpha( 0, 0.9f );
		Me.KillTimer( TIMER_ID2 );
		Me.SetTimer(TIMER_ID3, 1000);
		//~ MG_BTNChallenge.EnableWindow();
	}
	if(TimerID == TIMER_ID3)
	{
		ResultTex.HideWindow();
		Me.KillTimer( TIMER_ID3);
		m_InGamingBool = true;
		MG_BTNChallenge.SetNameText( GetSystemString(1073) ); //branch - Line 629로부터 이곳으로 이동함
		MG_BTNChallenge.EnableWindow(); //branch - '일시정지' 버튼 활성화
		StartNewGameProc();
		MG_BTNChallenge.EnableWindow();
	}
	if(TimerID == TIMER_ID4)
	{
		if (m_CurrentAnimID == TOTAL_GRID)
		{
			//branch
			if(m_CurrentScore!=0 && m_bUseJapanStyle == 1) {
				RequestBR_MinigameInsertScore(m_CurrentScore); // 내 점수 서버로 전송
				if(MiniGameRankWnd.isShowWindow()) RequestBR_MinigameLoadScores(); // 랭킹 창이 열려있다면 랭킹 요청하여 갱신함
			}
			//end of branch
			m_CurrentAnimID = 0;
			ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_GameOver");
			MG_BTNChallenge.SetNameText( GetSystemString(1728) );
			MG_BTNClose.SetNameText( GetSystemString(908) );
			//~ Playsound("ItemSound3.minigame_game_over");
			Me.KillTimer ( TIMER_ID4);
			m_InGamingBool = false;
			MG_BTNChallenge.EnableWindow();
		}
		else 
		{
			EndGameRemoveBlock(m_CurrentAnimID);
			m_CurrentAnimID = m_CurrentAnimID + 1;
		}
	}
	if(TimerID == TIMER_ID5)
	{
		if (m_CurrentAnimID == TOTAL_GRID)
		{
			m_CurrentAnimID = 0;
			ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_GameOver");
			MG_BTNChallenge.SetNameText( GetSystemString(1728) );
			MG_BTNClose.SetNameText( GetSystemString(908) );
			//~ Playsound("ItemSound3.minigame_game_over");
			StartNewGame();
			Me.KillTimer ( TIMER_ID5);
			m_InGamingBool = true;
			MG_BTNChallenge.EnableWindow();
		}
		else 
		{
			EndGameRemoveBlock(m_CurrentAnimID);
			m_CurrentAnimID = m_CurrentAnimID + 1;
		}
	}
}
function bool CheckMovesOnTimer()
{
	local int i;
	local bool b;
	m_InGamingBool = false;
	m_CountNumberofChains = 0;
	for (i=0; i <TOTAL_GRID; i++)
	{
		if (CellGridData[i].isFlagged)
		{
			m_CountNumberofChains = m_CountNumberofChains + 1;
			PushDownRow(i);
			Playsound("ItemSound3.minigame_block_down");
			m_CurrentScore = m_CurrentScore + (2 * (m_CountNumberofChains-2));
			//~ m_CurrentScore = m_CurrentScore + 10;
			PutNumberScore(m_CurrentScore);
			b = false;
			if (m_CountNumberofChains >2)
			{
				Playsound("ItemSound3.minigame_break_combo");
			}
			//~ else
			//~ {
				//~ Playsound("ItemSound3.minigame_break_normal");
			//~ }
			ProgressBar.Reset();
			ProgressBar.Start();
			
		}
		if ( i == TOTAL_GRID-1)
			b = true;
	}
	
	//~ m_CurrentScore = m_CurrentScore + (2 * (m_CountNumberofChains-2)) -2;
	m_CurrentScore = m_CurrentScore + 10;
	PutNumberScore(m_CurrentScore);
	Playsound("ItemSound3.minigame_break_normal");
	
	if (b)
	{
		CheckMatches(false);
		CountMatches();
		if (m_MatchCount ==0)
		{
			b = true;
			//~ debug ("AIμ¿ºO´E");
			//~ EndGamewithNoMove();
		}
		else
		{
			m_CurrentScore = m_CurrentScore + 10;
			PutNumberScore(m_CurrentScore);
			b = false;
		}
	}
	return b;
}
function bool CheckSwappable(int ID1, int ID2)
{
	local bool returnSwappableBoolValue;
	//~ local int i;
	local int rowcol;
	local MG1CellData tempCellGridData;
	local ButtonHandle temp1;
	returnSwappableBoolValue = false;
	rowcol = ID1-ID2;
	 if (rowcol == 1 || rowcol == -1 || rowcol == 8 || rowcol == -8)
	{
		tempCellGridData = CellGridData[ID1];
		CellGridData[ID1].RV 		=	CellGridData[ID2].RV; 		
		CellGridData[ID1].BtnTex	=	CellGridData[ID2].BtnTex;
		temp1= CellGridData[ID1].ButtonLoc;
		temp1.SetTexture(CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex $"_over");
		CellGridData[ID2].RV 		=	tempCellGridData.RV; 		
		CellGridData[ID2].BtnTex	=	tempCellGridData.BtnTex;
		temp1= CellGridData[ID2].ButtonLoc;
		temp1.SetTexture(CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex $"_over");
		CheckMatches(true);
		CountMatches();
		if (m_MatchCount > 0)
		{
			returnSwappableBoolValue = true;
			Playsound("ItemSound3.minigame_block_change");
		}
		else
		{
			CellGridData[ID2].RV 		=	CellGridData[ID1].RV; 		
			CellGridData[ID2].BtnTex	=	CellGridData[ID1].BtnTex;
			temp1= CellGridData[ID2].ButtonLoc;
			temp1.SetTexture(CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex $"_over");
			CellGridData[ID1].RV 		=	tempCellGridData.RV; 		
			CellGridData[ID1].BtnTex	=	tempCellGridData.BtnTex;
			temp1= CellGridData[ID1].ButtonLoc;
			temp1.SetTexture(CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex $"_over");
			CheckMatches(false);
			CountMatches();
			Playsound("ItemSound3.minigame_change_impossible");
		}
	}
	
	return returnSwappableBoolValue;
	
}
function int GetCellGridID(int x, int y)
{
	local int i;
	for (i=0; i<TOTAL_GRID; i++)
	{
		if (CellGridData[i].X == x && CellGridData[i].Y == y)
		{
			return i;
			break;
		}
	}
}
function OnProgressTimeUp(string strID)
{
	if (strID == "MG_Progress")
	{
		//~ if (!m_PauseBool)
			OnTimeOver();
	}
}
function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	a_WindowHandle.HideWindow();
}
function int GetCurrentTimeLimit(int CurrentLevel)
{
	local int TimeLimit;
	if (CurrentLevel <= 10)
	{
		switch(CurrentLevel)
		{
			case 1:
				TimeLimit= 20000;
			break;
			case 2:
				TimeLimit= 18000;
			break;
			case 3:
				TimeLimit= 16000;
			break;
			case 4:
				TimeLimit= 14000;
			break;
			case 5:
				TimeLimit= 12000;
			break;
			case 6:
				TimeLimit= 10000;
			break;
			case 7:
				TimeLimit= 8000;
			break;
			case 8:
				TimeLimit= 6000;
			break;
			case 9:
				TimeLimit= 4000;
			break;
			case 10:
				TimeLimit= 3000;
			break;
		}
	}
	else
	{
		TimeLimit= 2000;
	}
	return TimeLimit;
}
function int GetTargetScore(int CurrentLevel)
{
	local int TargetScore;
	TargetScore = (TARGETSCORESEED * CurrentLevel);
	return TargetScore;
}
function EndGameRemoveBlock(int ID)
{
	//~ local int i;
	local ButtonHandle temp1;
	//~ local AnimTextureHandle TempAnim;
	temp1= CellGridData[ID].ButtonLoc;
	m_InGamingBool = false;
	temp1.SetTexture("l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn","l2ui_ct1.emptyBtn");
	MG_BTNChallenge.DisableWindow();
}
function StartLevelUp()
{
	ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_Levelup");
	Playsound("ItemSound3.minigame_start");
	Me.SetTimer(TIMER_ID5, TIMER_DELAY4);
}
function EndGame()
{	
	//branch - ready, start 라는 메세지가 나올 때 게임 중단 버튼을 눌러도 그냥 게임이 시작되는 것을 막기 위함
	Me.KillTimer( TIMER_ID2 ); 
	Me.KillTimer( TIMER_ID3 );
	//end of branch
	ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_GameOver");
	//~ Playsound("ItemSound3.minigame_game_over");
	MG_BTNChallenge.SetNameText( GetSystemString(1728) );
	MG_BTNClose.SetNameText( GetSystemString(908) );
	Me.SetTimer(TIMER_ID4, TIMER_DELAY4);
}
function EndGamewithTimeOut()
{
	ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_TimeOut");
	//~ Playsound("ItemSound3.minigame_game_over");
	Me.SetTimer(TIMER_ID4, TIMER_DELAY4);
}
function ProcEndGameDefaultSetting(string SetTextureName)
{
	local int i;
	local TextureHandle temp1;
	if (!m_PauseBool)
	{
		for (i=0; i<TOTAL_GRID; i++)
		{
			temp1= CellGridData[i].TextureLoc;
			temp1.HideWindow();
		}
	}
	ProgressBar.Reset();
	ResultTex.SetAlpha( 255, 0 );
	ResultTex.SetTexture(SetTextureName);
	ResultTex.ShowWindow();
	m_InGamingBool = false;
	MG_BTNChallenge.DisableWindow();
}
function PutNumberLevel(int LevelNo)
{
	local string strtex, temptex ;
	local int strtexcnt, compcnt, i;
	temptex= "";
	strtex = String(LevelNo);
	strtexcnt = Len(strtex);
	compcnt  = 3-strtexcnt;
	for (i=1;i<=compcnt;i++)
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtLevel_0" $ string(i), "l2ui_ct1.MiniGame_df_Text_Level_0");
	}
	for (i=strtexcnt;i>0;i--)
	{
		temptex = Right(strtex, 1);
		strtex = TrimRight (strtex);
		class'UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtLevel_0" $ string(compcnt+i), "l2ui_ct1.MiniGame_df_Text_Level_" $ temptex);
	}
}
function PutNumberScore(int LevelNo)
{
	local string strtex, temptex ;
	local int strtexcnt, compcnt, i;
	temptex= "";
	strtex = String(LevelNo);
	strtexcnt = Len(strtex);
	compcnt  = 6-strtexcnt;
	for (i=1;i<=compcnt;i++)
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtScore_0" $ string(i), "l2ui_ct1.MiniGame_df_Text_Score_0");
	}
	for (i=strtexcnt;i>0;i--)
	{
		temptex = Right(strtex, 1);
		strtex = TrimRight (strtex);
		class'UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtScore_0" $ string(compcnt+i), "l2ui_ct1.MiniGame_df_Text_Score_" $ temptex);
	}
}
function string TrimRight(string S)
{
	S = Left(S, Len(S) - 1);
	return S;
}
defaultproperties
{
}
