/******************************************************************************
//                                                ��Ƽâ  �ɼ� ���� UI ��ũ��Ʈ                                                                    //
******************************************************************************/
class PartyWndOption extends UIScriptEx;
	
const NPARTYSTATUS_MAXCOUNT = 9;		//�� ��Ƽâ�� ���� �ִ� �ִ� ��Ƽ���� ��.

// �������� ����
var bool	m_OptionShow;	// ���� �ɼ�â�� �������� �ִ��� üũ�ϴ� �Լ�.
					// true�̸� ����. false  �̸� ������ ����.
var int	m_arrPetIDOpen[NPARTYSTATUS_MAXCOUNT];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����

// �̺�Ʈ �ڵ� ����
var WindowHandle	m_PartyOption;
var WindowHandle 	m_PartyWndBig;
var WindowHandle	m_PartyWndSmall;

var CheckBoxHandle	m_CheckShowAllPet;
var CheckBoxHandle	m_CheckHideAllPet;

// ������ ������ �ε�Ǵ� �Լ�
function OnLoad()
{
	m_OptionShow = false;	// ����Ʈ�� false 


	if(CREATE_ON_DEMAND==0)
	{
		m_PartyOption = GetHandle("PartyWndOption");
		m_PartyWndBig = GetHandle("PartyWnd");	
		m_PartyWndSmall = GetHandle("PartyWndCompact");
		
		m_CheckShowAllPet = CheckBoxHandle(GetHandle("PartyWndOption.showAllPet"));
		m_CheckHideAllPet = CheckBoxHandle(GetHandle("PartyWndOption.removeAllPet"));
	}
	else
	{
		m_PartyOption = GetWindowHandle("PartyWndOption");
		m_PartyWndBig = GetWindowHandle("PartyWnd");	
		m_PartyWndSmall = GetWindowHandle("PartyWndCompact");
		
		m_CheckShowAllPet = GetCheckBoxHandle("PartyWndOption.showAllPet");
		m_CheckHideAllPet = GetCheckBoxHandle("PartyWndOption.removeAllPet");
	}
}
       
// �����찡 ������������ ȣ��Ǵ� �Լ�
function OnShow()
{	
	local int i;
	local int open, hide;
	
	class'UIAPI_CHECKBOX'.static.SetCheck("ShowSmallPartyWndCheck", GetOptionBool( "Game", "SmallPartyWnd" ));
	class'UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
	m_OptionShow = true;
	
	open  = 0;
	hide  = 0;	
	// ���� ���� ���¿� ���� ��� �����ֱ� / ��� ���߱��� üũ�� ó���Ѵ�. 
	for(i=0; i<NPARTYSTATUS_MAXCOUNT ; i++)
	{
		if(m_arrPetIDOpen[i] == 1) open++;
		else if(m_arrPetIDOpen[i] == 2) hide++;
	}	
	
	if( open == 0 )	// ��� �����ִٴ� ��. ��� �ݱ��� üũ�� �ڵ����� ���ش�. 
	{
		m_CheckShowAllPet.SetCheck(false);
		m_CheckHideAllPet.SetCheck(true);
	}
	else if( hide == 0)	// ���μ�. open, hide �� ���ÿ� 0�� �� �� ����. 
	{
		m_CheckShowAllPet.SetCheck(true);
		m_CheckHideAllPet.SetCheck(false);
	}
	else	// �������͵� �հ� �ƴѰ͵� ������ �Ѵ� üũ ����
	{
		m_CheckShowAllPet.SetCheck(false);
		m_CheckHideAllPet.SetCheck(false);		
	}
		
}

// üũ�ڽ��� Ŭ���Ͽ��� ��� �̺�Ʈ
function OnClickCheckBox( string CheckBoxID)
{
	switch( CheckBoxID )
	{
	case "ShowSmallPartyWndCheck":
		//debug("Clicked  2");

		break;
	case "showAllPet":
		if(m_CheckShowAllPet.IsChecked() )
			m_CheckHideAllPet.SetCheck(false);
		break;
	case "removeAllPet":
		if(m_CheckHideAllPet.IsChecked() )
			m_CheckShowAllPet.SetCheck(false);
		break;
	}
}

// Ȯ��� ��Ƽâ�� ��ҵ� ��Ƽâ�� ��ȯ
function SwapBigandSmall()
{
	local int i;
	//~ local int open, hide;
	
	local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	local PartyWndCompact script2;	// ��ҵ� ��Ƽâ�� Ŭ����
	
	script1 = PartyWnd( GetScript("PartyWnd") );
	script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	class'UIAPI_WINDOW'.static.SetAnchor("PartyWndCompact", "PartyWnd", "TopLeft", "TopLeft", 0, 0 );	// �̰��ϳ��� ���� â�� ��ũ��. ��!
	
	for(i=0; i <NPARTYSTATUS_MAXCOUNT ; i++)
	{
		if( m_CheckShowAllPet.IsChecked()) 	// ��� ���̱Ⱑ üũ �Ǿ� ������
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 
		}
		else if( m_CheckHideAllPet.IsChecked()) 	// ��� ���߱Ⱑ üũ �Ǿ� ������
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 
		}
		
		script1.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		script2.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		// ���� ��ũ��Ʈ���� ��� ����.		
	}
	// �� ��ũ��Ʈ�� ResizeWnd()�� �ɼ��� Ȱ��ȭ�� ���� �ڽ��� �����츦 HIDE���� Ȱ��ȭ���� �����Ѵ�. 
	script1.ResizeWnd();
	script2.ResizeWnd();
}

// ��ư�� ������ ��� ����
function OnClickButton( string strID )
{
	//local PartyWnd script1;
	//local PartyWndCompact script2;
	//script1 = PartyWnd( GetScript("PartyWnd") );
	//script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	switch( strID )
	{
	case "okbtn":	// OK ��ư�� ������
		
		switch (class'UIAPI_CHECKBOX'.static.IsChecked("ShowSmallPartyWndCheck"))
		{ 
		case true:
			//SetOptionBool("Game", ... ) �� ������ Option ->�����׸񿡼� ����Ҽ� �ִ� bool ������ ����� �� �ִ�.	
			//������ ��ϵ��� ���� ������ ����ϸ� �ڵ����� Ŭ���̾�Ʈ���� �˾Ƽ� ������.
			// ���� ���� ������ ���� Documentation �� �ʿ�!
			// GetOptionBool�� ���.
			SetOptionBool( "Game", "SmallPartyWnd", true );											
			break;
		case false:
			SetOptionBool( "Game", "SmallPartyWnd", false);
			break;
		}
		SwapBigandSmall();		// ��Ȳ�� ���� ��Ƽâ�� ũ�⸦ �������ش�.
		m_PartyOption.HideWindow();	// ������ �����츦 �����
		//script1.m_OptionShow = false;
		//script2.m_OptionShow = false;
		m_OptionShow = false;
		break;
	}
}

// PartyWnd�� PartyWndCompact ���� ȣ���ϴ� �Լ�.
function ShowPartyWndOption()
{
	// ���������� ����
	if (m_OptionShow == false)
	{ 
		m_PartyOption.ShowWindow();
		m_OptionShow = true;
	}
	else	// ���������� �ݴ´�. 
	{
		m_PartyOption.HideWindow();
		m_OptionShow = false;
	}
}
defaultproperties
{
}
