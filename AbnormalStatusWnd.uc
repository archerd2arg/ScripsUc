class AbnormalStatusWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int m_NormalStatusRow;
var int m_DebuffRow;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var int m_SongDanceStatusRow;
var int m_TriggerSkillRow;
var bool m_bOnCurState;

var WindowHandle		Me;
var StatusIconHandle	StatusIcon;

function OnRegisterEvent()
{
	RegisterEvent( EV_AbnormalStatusNormalItem );
	RegisterEvent( EV_AbnormalStatusEtcItem );
	RegisterEvent( EV_AbnormalStatusShortItem );
	
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_Die );
	RegisterEvent( EV_ShowReplayQuitDialogBox );
	RegisterEvent( EV_LanguageChanged );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_DebuffRow = -1;
	m_NormalStatusRow = -1;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_SongDanceStatusRow = -1;
	m_TriggerSkillRow = -1;
	m_bOnCurState = false;
	
	InitHandle();
}

function InitHandle()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AbnormalStatusWnd" );
		StatusIcon = StatusIconHandle( GetHandle( "AbnormalStatusWnd.StatusIcon" ) );
	}
	else
	{
		Me = GetWindowHandle( "AbnormalStatusWnd" );
		StatusIcon = GetStatusIconHandle( "AbnormalStatusWnd.StatusIcon" );
	}
}

function OnEnterState( name a_PreStateName )
{
	m_bOnCurState = true;
	UpdateWindowSize();
}

function OnExitState( name a_NextStateName )
{
	m_bOnCurState = false;
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_AbnormalStatusNormalItem)
	{
		HandleAddNormalStatus(param);
	}
	else if (Event_ID == EV_AbnormalStatusEtcItem)
	{
		HandleAddEtcStatus(param);
	}
	else if (Event_ID == EV_AbnormalStatusShortItem)
	{
		HandleAddShortStatus(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HandleRestart();
	}
	else if (Event_ID == EV_Die)
	{
		HandleDie();
	}
	else if (Event_ID == EV_ShowReplayQuitDialogBox)
	{
		HandleShowReplayQuitDialogBox();
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
}

//����ŸƮ�� �ϸ� ��Ŭ����
function HandleRestart()
{
	ClearAll();
}

//�׾�����, Normal/Short�� Ŭ����
function HandleDie()
{
	ClearStatus(false, false);
	ClearStatus(false, true);
}

function HandleShowReplayQuitDialogBox()
{
	Me.HideWindow();
}

//������ UI�� ������ ��, �������� �������� ���� ���´�
function OnShow()
{
	local int RowCount;
	RowCount = StatusIcon.GetRowCount();
	if (RowCount<1)
	{
		Me.HideWindow();
	}
}

//Ư���� Status���� �ʱ�ȭ�Ѵ�.
function ClearStatus(bool bEtcItem, bool bShortItem)
{
	local int i;
	local int j;
	local int RowCount;
	local int RowCountTmp;
	local int ColCount;
	local StatusIconInfo info;
	
	//Normal�������� �ʱ�ȭ�ϴ� �����, Normal�������� �������� �ʱ�ȭ�Ѵ�.
	if (bEtcItem==false && bShortItem==false)
	{
		m_NormalStatusRow = -1;
		m_SongDanceStatusRow = -1;
		m_DebuffRow = -1;
		m_TriggerSkillRow = -1;
	}
	//Etc�������� �ʱ�ȭ�ϴ� �����, Etc�������� �������� �ʱ�ȭ�Ѵ�.
	if (bEtcItem==true && bShortItem==false)
	{
		m_EtcStatusRow = -1;
		//~ m_ShortStatusRow = -1;
	}
	//Short�������� �ʱ�ȭ�ϴ� �����, Short�������� �������� �ʱ�ȭ�Ѵ�.
	if (bEtcItem==false && bShortItem==true)
	{
		m_ShortStatusRow = -1;
		//~ m_EtcStatusRow = -1;
	}
	
	RowCount = StatusIcon.GetRowCount();
	for (i=0; i<RowCount; i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		for (j=0; j<ColCount; j++)
		{
			StatusIcon.GetItem(i, j, info);
			
			//����� �������� ���Դٸ�
			if (IsValidItemID(info.ID))
			{
				if (info.bEtcItem==bEtcItem && info.bShortItem==bShortItem)
				{
					StatusIcon.DelItem(i, j);
					j--;
					ColCount--;
					
					RowCountTmp = StatusIcon.GetRowCount();
					if (RowCountTmp != RowCount)
					{
						i--;
						RowCount--;
					}
				}
			}
		}
	}
}

function ClearAll()
{
	ClearStatus(false, false);
	ClearStatus(true, false);
	ClearStatus(false, true);
}

//Normal Status �߰�
function HandleAddNormalStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local StatusIconInfo info;
	
	local int temp1;

	// �ߵ� ���� ���� �и� - gorillazin 10.05.24.
	local int TriggerBuffCount;
	
	//NormalStatus �ʱ�ȭ
	ClearStatus(false, false);
	
	//info �ʱ�ȭ
	info.Size = 24;
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;

	BuffCnt = 0;

	// �ߵ� ���� ���� �и� - gorillazin 10.05.24.
	TriggerBuffCount = 0;

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);

	debug("//////////////////////////test_abnormal////////////////////////" $ Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		//debug("ID : " $ i $ "info.RemainTime : " $ info.RemainTime $ "info.Name :" $ info.Name);
		temp1 = Asc(info.Name);
		//debug("ASCII : " $ temp1);

		// �� ���Ͽ����� ��ųȿ������ ǥ�� ������ �����մϴ�.
		// ���� ������ ���� �ֽ��ϴ�.
		// Ŭ���̾�Ʈ�κ��� �������� �����Ϳ� ��� �������� ������
		//	1. �Ϲ� ���� (m_NormalStatusRow)
		//	2. �����	(m_DebuffRow)
		//	3. ��/��	(m_SongDanceStatusRow)
		//	4. �ߵ� ���� (m_TriggerSkillRow)
		// �Դϴ�. �׷���, ���� Ŭ���̾�Ʈ ȭ�鿡 ������� �� ��ųȿ������ ������
		//	1. �Ϲ� ����
		//	2. ��/��
		//	3. �ߵ� ����
		//	4. �����
		// �Դϴ�.
		// ���� ��ųȿ���� ǥ���� �� ���Ǹ� ���մϴ�.
		// ���� ***�� �޸� �ּ��� �� ��Ȳ�� �ذ��ϱ� ���� �ּ��̹Ƿ� �����Ͻø� �ǰڽ��ϴ�.
		// - by gorillazin - �ߵ� ���� ���� �и� 10.06.01.
		if (IsValidItemID(info.ID))
		{
			if (IsSongDance( info.ID, info.Level))
			{
				//debug("/////////////////songdance come in./////////////////");				
				if (m_SongDanceStatusRow == -1)
				{
					m_SongDanceStatusRow = m_NormalStatusRow +1;
					StatusIcon.InsertRow(m_SongDanceStatusRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}
				
				StatusIcon.AddCol(m_SongDanceStatusRow, info);
				//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
			else if (IsTriggerSkill(info.ID, info.Level))
			{
				//debug("/////////////////trigger come in./////////////////");
				if (m_TriggerSkillRow == -1 && m_SongDanceStatusRow == -1)
				{
					m_TriggerSkillRow = m_NormalStatusRow + 1;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}
				else if (m_TriggerSkillRow == -1 && m_SongDanceStatusRow > -1)
				{
					m_TriggerSkillRow = m_SongDanceStatusRow +1;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}

				if (TriggerBuffCount == NSTATUSICON_MAXCOL)
				{
					m_TriggerSkillRow++;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}

				StatusIcon.AddCol(m_TriggerSkillRow, info);

				TriggerBuffCount++;
				//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
			else if (IsDebuff( info.ID, info.Level))
			{
				//debug("/////////////////debuff come in./////////////////");
				if (m_DebuffRow == -1 && m_SongDanceStatusRow == -1 && m_TriggerSkillRow == -1)
				{
					m_DebuffRow = m_NormalStatusRow + 1;
					StatusIcon.InsertRow(m_DebuffRow);
				}
				else if (m_DebuffRow == -1 && m_SongDanceStatusRow > -1 && m_TriggerSkillRow == -1)
				{					
					m_DebuffRow = m_SongDanceStatusRow + 1;
					StatusIcon.InsertRow(m_DebuffRow);
				}
				else if (m_DebuffRow == -1 && m_SongDanceStatusRow == -1 && m_TriggerSkillRow > -1)
				{
					m_DebuffRow = m_TriggerSkillRow + 1;
					StatusIcon.InsertRow(m_DebuffRow);
				}
				else if (m_DebuffRow == -1 && m_SongDanceStatusRow > -1 && m_TriggerSkillRow > -1)
				{
					m_DebuffRow = m_TriggerSkillRow + 1;
					StatusIcon.InsertRow(m_DebuffRow);
				}				
				StatusIcon.AddCol(m_DebuffRow, info);
				//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
			else 
			{				
				//debug("/////////////////normal come in./////////////////");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					m_NormalStatusRow++;
					StatusIcon.InsertRow(m_NormalStatusRow);
				}
	
				StatusIcon.AddCol(m_NormalStatusRow, info);	
				
				BuffCnt++;
			}
		}		
	}
	
	//���� Etc, Short�������� ǥ�õǰ� �ִ� ���̶��, ���� ����/���� �Ǿ��� ��찡 �ֱ� ������
	if (m_EtcStatusRow > -1)
	{
		m_EtcStatusRow = m_NormalStatusRow + 1;	
		//debug("normal exist. etcRow = " $ m_EtcStatusRow);
		//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		if (m_SongDanceStatusRow > -1)
		{			
			m_EtcStatusRow = m_SongDanceStatusRow + 1;
			//debug("songdance exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_TriggerSkillRow > -1)
		{
			m_EtcStatusRow = m_TriggerSkillRow + 1;
			//debug("trigger exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_DebuffRow > -1)
		{
			m_EtcStatusRow = m_DebuffRow + 1;
			//debug("debuff exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
	}

	if (m_ShortStatusRow > -1)
	{
		m_ShortStatusRow = m_NormalStatusRow + 1;	
		//debug("normal exist. etcRow = " $ m_EtcStatusRow);
		//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		if (m_SongDanceStatusRow > -1)
		{			
			m_ShortStatusRow = m_SongDanceStatusRow + 1;
			//debug("songdance exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_TriggerSkillRow > -1)
		{
			m_ShortStatusRow = m_TriggerSkillRow + 1;
			//debug("trigger exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_DebuffRow > -1)
		{
			m_ShortStatusRow = m_DebuffRow + 1;
			//debug("debuff exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
	}
	
	UpdateWindowSize();
}

//Etc Status �߰�
function HandleAddEtcStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local int CurRow;
	local bool bNewRow;
	local StatusIconInfo info;
	
	//EtcStatus �ʱ�ȭ
	ClearStatus(true, false);
	//~ ClearStatus(true, true);
	//info �ʱ�ȭ
	info.Size = 24;
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = true;
	info.bShortItem = false;
	
	//�߰� ������(Normal������ ������, Short������ ���� ���� �߰��Ѵ�)
	if (m_ShortStatusRow>-1)
	{
		bNewRow = false;
		CurRow = m_ShortStatusRow;
	}
	else 
	{
		bNewRow = true;
		CurRow = m_NormalStatusRow;
		if (m_SongDanceStatusRow > -1)
		{
			CurRow= m_SongDanceStatusRow;
		}
		if (m_TriggerSkillRow > -1)
		{
			CurRow = m_TriggerSkillRow;
		}
		if (m_DebuffRow > -1)
		{
			CurRow = m_DebuffRow;
		}
	}

	//debug("//////////////////////////test_etc////////////////////////");
	//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
	//debug("etc_curRow before = " $ CurRow);

	BuffCnt = 0;
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		
		if (IsValidItemID(info.ID))
		{
			//Etc�������� �ִ� �� �࿡�� ǥ���Ѵ�.(Short������ �ڿ�...)
			if (bNewRow)
			{
				bNewRow = !bNewRow;
				CurRow++;
				StatusIcon.InsertRow(CurRow);
			}
			StatusIcon.AddCol(CurRow, info);

			//debug("etc_curRow after = " $ CurRow);
			
			m_EtcStatusRow = CurRow;
			
			BuffCnt++;
		}
	}
	
	UpdateWindowSize();
}

//Short Status �߰�
function HandleAddShortStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local int CurRow;
	local int CurCol;
	local bool bNewRow;
	local StatusIconInfo info;
	
	//ShortStatus �ʱ�ȭ
	ClearStatus(false, true);
	//~ ClearStatus(true, true);
	//info �ʱ�ȭ
	info.Size = 24;
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = true;
	
/* 		m_DebuffRow = -1;
	m_NormalStatusRow = -1;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_SongDanceStatusRow = -1;
	m_bOnCurState = false;
	 */
	//�߰� ������(Normal������ ������, Etc������ ���� �߰��Ѵ�)
	CurCol = -1;
	
	if (m_EtcStatusRow>-1)
	{
		bNewRow = false;
		CurRow = m_EtcStatusRow;
	}
	else
	{
		bNewRow = true;
		CurRow = m_NormalStatusRow;
		if (m_SongDanceStatusRow > -1)
		{
			CurRow= m_SongDanceStatusRow;
		}
		if (m_TriggerSkillRow > -1)
		{
			CurRow = m_TriggerSkillRow;
		}
		if (m_DebuffRow > -1)
		{
			CurRow= m_DebuffRow;
		}
	}

	//debug("//////////////////////////test_short////////////////////////");
	//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
	//debug("short_curRow before = " $ CurRow);
	
	//~ if (m_NormalStatusRow>-1 && m_EtcStatusRow>-1 )
	//~ {
		
		//~ bNewRow = false;
		//~ CurRow = m_EtcStatusRow;
		//~ debug ("CurRow_proc1" @ CurRow @ m_ShortStatusRow);
	//~ }
	//~ else if  (m_NormalStatusRow>-1 && m_EtcStatusRow<0)
	//~ {
		//~ bNewRow = true;
		//~ CurRow = m_EtcStatusRow;
		//~ debug ("CurRow_proc2" @ CurRow @ m_ShortStatusRow);
	//~ }
	//~ else if  (m_NormalStatusRow<0 && m_EtcStatusRow <0 )
	//~ {
		//~ bNewRow = true;
		//~ CurRow = m_EtcStatusRow;
		//~ debug ("CurRow_proc3" @ CurRow @ m_ShortStatusRow);
	//~ }
	//~ else  if  (m_NormalStatusRow<0 && m_EtcStatusRow >-1)
	//~ {
		//~ bNewRow = false;
		//~ CurRow = m_EtcStatusRow;
		//~ debug ("CurRow_proc4" @ CurRow @ m_ShortStatusRow);
	//~ }
	
	//~ debug ("CurRow" @ CurRow);
	
	BuffCnt = 0;
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
			
		if (IsValidItemID(info.ID))
		{
			//Short�������� �ִ� �� �࿡�� ǥ���Ѵ�.(Etc�����۰� �Բ�..)
			if (bNewRow)
			{
				bNewRow = !bNewRow;
				CurRow++;	
				StatusIcon.InsertRow(CurRow);
			}
			CurCol++;
			StatusIcon.InsertCol(CurRow, CurCol, info);

			//debug("short_curRow after = " $ CurRow);
			
			m_ShortStatusRow = CurRow;
			
			BuffCnt++;
		}
	}	
	UpdateWindowSize();	
}

//������ ������ ����
function UpdateWindowSize()
{
	local int RowCount;
	local Rect rectWnd;
	
	RowCount = StatusIcon.GetRowCount();
	if (RowCount>0)
	{
		//���� GameState�� �ƴϸ� �����츦 ������ �ʴ´�.
		if (m_bOnCurState)
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		
		//������ ������ ����
		rectWnd = StatusIcon.GetRect();
		Me.SetWindowSize(rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
		
		//���� ������ ������ ����
		Me.SetFrameSize(NSTATUSICON_FRAMESIZE, rectWnd.nHeight);	
	}
	else
	{
		Me.HideWindow();
	}
}

//��� ���� ó��
function HandleLanguageChanged()
{
	local int i;
	local int j;
	local int RowCount;
	local int ColCount;
	local StatusIconInfo info;
	
	RowCount = StatusIcon.GetRowCount();
	for (i=0; i<RowCount; i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		for (j=0; j<ColCount; j++)
		{
			StatusIcon.GetItem(i, j, info);
			if (IsValidItemID(info.ID))
			{
				info.Name = class'UIDATA_SKILL'.static.GetName( info.ID, info.Level );
				info.Description = class'UIDATA_SKILL'.static.GetDescription( info.ID, info.Level );
				StatusIcon.SetItem(i, j, info);
			}
		}
	}
}

// ��ų�� Ŭ��
function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// ��ų ����. ������ų���� Ȯ���ؾ� �ϴϱ�
	
	col = index / 10;
	row = index - (col * 10);
	
	StatusIcon.GetItem(row, col, info);
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"StatusIcon" ) > -1 )
	{
		if (skillInfo.IsDebuff == false && skillInfo.OperateType == 1) 		{	RequestDispel(info.ServerID, info.ID, info.Level);	}					//���� ��� ��û
		else												{	AddSystemMessage(2318);	}	//��ȭ ��ų�� ��쿡�� ���� ��Ұ� �����մϴ�. 
	}
}
defaultproperties{}
