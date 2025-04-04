class UICommonAPI extends UIScriptEx;

const EV_USER_CharacterSelectionChanged = 50000;

//FileWnd FileHandler TYPE
enum _FileHandler
{
	FH_NONE,
	FH_PLEDGE_CREST_UPLOAD,
	FH_PLEDGE_EMBLEM_UPLOAD,
	FH_ALLIANCE_CREST_UPLOAD,
	FH_MAX
	// ���������쿡�� ������ ó���� �Լ��� ���ϰ� ������ �뵵�� ���� �߰��սô� 
};


// Dialog API
enum EDialogType
{
	DIALOG_OKCancel,
	DIALOG_OK,
	DIALOG_OKCancelInput,
	DIALOG_OKInput,
	DIALOG_Warning,
	DIALOG_Notice,
	DIALOG_NumberPad,
	DIALOG_Progress,
};
enum EDialogModalType
{
	DIALOG_Modal,
	DIALOG_Modalless,
};

enum DialogDefaultAction
{
	EDefaultNone,
	EDefaultOK,
	EDefaultCancel,
};





function ShowOnScreenMessage(int msgType, int msgNo, int windowType, int fontType, color MsgColor, int lifeTime, string MessageText)
{
	local string out_Param;
	
	ParamAdd( out_Param, "MsgType",         string(msgType) );
	ParamAdd( out_Param, "MsgNo",           string(msgNo) );
	ParamAdd( out_Param, "WindowType",      string(windowType) );
	ParamAdd( out_Param, "FontSize",        "10" );
	ParamAdd( out_Param, "FontType",        string(fontType) );
	
	ParamAdd( out_Param, "MsgColor",        "1" );
	ParamAdd( out_Param, "MsgColorR",       string(MsgColor.R));
	ParamAdd( out_Param, "MsgColorG",       string(MsgColor.G));
	ParamAdd( out_Param, "MsgColorB",       string(MsgColor.B));
	ParamAdd( out_Param, "ShadowType",      "0" );
	ParamAdd( out_Param, "BackgroundType",  "1" );
	ParamAdd( out_Param, "LifeTime",        string(lifeTime) );
	ParamAdd( out_Param, "AnimationType",   "0" );
	ParamAdd( out_Param, "Msg",             MessageText );
	
	ExecuteEvent(EV_ShowScreenMessage, out_Param);
}

function bool IsNoble(int m_skillID)
{
	local bool	bIsNoblessID;
	bIsNoblessID = false;
	switch( m_skillID )
	{
		case 1323:
			 bIsNoblessID = true;
			 break;
	}	
	return bIsNoblessID;
}


function int intPercent(int what, int from)
{
	return (float(what) / float(from))*100;
}

function float getPercent(int what, int from)
{
	return float(what) / float(from);
}

function printUserInfo(UserInfo a_UserInfo)
{
	AddSystemMessageString("nID"@a_UserInfo.nID);
	AddSystemMessageString("Name"@a_UserInfo.Name);
	AddSystemMessageString("strNickName"@a_UserInfo.strNickName);
	AddSystemMessageString("RealName"@a_UserInfo.RealName);
	AddSystemMessageString("nSex"@a_UserInfo.nSex);
	AddSystemMessageString("Class"@a_UserInfo.Class);
	AddSystemMessageString("nLevel"@a_UserInfo.nLevel);
	AddSystemMessageString("nClassID"@a_UserInfo.nClassID);
	AddSystemMessageString("nSubClass"@a_UserInfo.nSubClass);
	AddSystemMessageString("nSP"@a_UserInfo.nSP);
	AddSystemMessageString("nCurHP"@a_UserInfo.nCurHP);
	AddSystemMessageString("nMaxHP"@a_UserInfo.nMaxHP);
	AddSystemMessageString("nCurMP"@a_UserInfo.nCurMP);
	AddSystemMessageString("nMaxMP"@a_UserInfo.nMaxMP);
	AddSystemMessageString("nCurCP"@a_UserInfo.nCurCP);
	AddSystemMessageString("nMaxCP"@a_UserInfo.nMaxCP);
	//AddSystemMessageString("nCurExp"@a_UserInfo.nCurExp);
	
	AddSystemMessageString("nUserRank"@a_UserInfo.nUserRank);
	AddSystemMessageString("nClanID"@a_UserInfo.nClanID);
	AddSystemMessageString("nAllianceID"@a_UserInfo.nAllianceID);
	AddSystemMessageString("nCarryWeight"@a_UserInfo.nCarryWeight);
	AddSystemMessageString("nCarringWeight"@a_UserInfo.nCarringWeight);
	
	AddSystemMessageString("nPhysicalAttack"@a_UserInfo.nPhysicalAttack);
	AddSystemMessageString("nPhysicalDefense"@a_UserInfo.nPhysicalDefense);
	AddSystemMessageString("nHitRate"@a_UserInfo.nHitRate);
	AddSystemMessageString("nCriticalRate"@a_UserInfo.nCriticalRate);
	AddSystemMessageString("nPhysicalAttackSpeed"@a_UserInfo.nPhysicalAttackSpeed);
	AddSystemMessageString("nMagicalAttack"@a_UserInfo.nMagicalAttack);
	AddSystemMessageString("nMagicDefense"@a_UserInfo.nMagicDefense);
	AddSystemMessageString("nPhysicalAvoid"@a_UserInfo.nPhysicalAvoid);
	AddSystemMessageString("nWaterMaxSpeed"@a_UserInfo.nWaterMaxSpeed);
	AddSystemMessageString("nWaterMinSpeed"@a_UserInfo.nWaterMinSpeed);
	AddSystemMessageString("nAirMaxSpeed"@a_UserInfo.nAirMaxSpeed);
	AddSystemMessageString("nAirMinSpeed"@a_UserInfo.nAirMinSpeed);
	AddSystemMessageString("nGroundMaxSpeed"@a_UserInfo.nGroundMaxSpeed);
	AddSystemMessageString("nGroundMinSpeed"@a_UserInfo.nGroundMinSpeed);
	AddSystemMessageString("fNonAttackSpeedModifier"@a_UserInfo.fNonAttackSpeedModifier);
	AddSystemMessageString("nMagicCastingSpeed"@a_UserInfo.nMagicCastingSpeed);
	
	AddSystemMessageString("nStr"@a_UserInfo.nStr);
	AddSystemMessageString("nDex"@a_UserInfo.nDex);
	AddSystemMessageString("nCon"@a_UserInfo.nCon);
	AddSystemMessageString("nInt"@a_UserInfo.nInt);
	AddSystemMessageString("nWit"@a_UserInfo.nWit);
	AddSystemMessageString("nMen"@a_UserInfo.nMen);
	
	AddSystemMessageString("nCriminalRate"@a_UserInfo.nCriminalRate);
	AddSystemMessageString("nDualCount"@a_UserInfo.nDualCount);
	AddSystemMessageString("nPKCount"@a_UserInfo.nPKCount);
	AddSystemMessageString("nSociality"@a_UserInfo.nSociality);
	AddSystemMessageString("nRemainSulffrage"@a_UserInfo.nRemainSulffrage);
	
	AddSystemMessageString("bHero"@a_UserInfo.bHero);
	AddSystemMessageString("bNobless"@a_UserInfo.bNobless);
	AddSystemMessageString("bNpc"@a_UserInfo.bNpc);
	AddSystemMessageString("bPet"@a_UserInfo.bPet);
	AddSystemMessageString("bCanBeAttacked"@a_UserInfo.bCanBeAttacked);
	
	AddSystemMessageString("Loc"@a_UserInfo.Loc);

	// ĳ���� �Ӽ� - lancelot 2007. 5. 18.
	AddSystemMessageString("AttrAttackType"@a_UserInfo.AttrAttackType);
	AddSystemMessageString("AttrAttackValue"@a_UserInfo.AttrAttackValue);
	AddSystemMessageString("AttrDefenseValFire"@a_UserInfo.AttrDefenseValFire);
	AddSystemMessageString("AttrDefenseValWater"@a_UserInfo.AttrDefenseValWater);
	AddSystemMessageString("AttrDefenseValWind"@a_UserInfo.AttrDefenseValWind);
	AddSystemMessageString("AttrDefenseValEarth"@a_UserInfo.AttrDefenseValEarth);
	AddSystemMessageString("AttrDefenseValHoly"@a_UserInfo.AttrDefenseValHoly);
	AddSystemMessageString("AttrDefenseValUnholy"@a_UserInfo.AttrDefenseValUnholy);
	
	// ����
	AddSystemMessageString("nTransformID"@a_UserInfo.nTransformID);
	AddSystemMessageString("m_bPawnChanged"@a_UserInfo.m_bPawnChanged);
	
	//Inven Item Order, ttmayrin
	AddSystemMessageString("nInvenLimit"@a_UserInfo.nInvenLimit);

	// 2008/03/05 PvP Point Restrain - NeverDie
	AddSystemMessageString("PvPPointRestrain"@a_UserInfo.PvPPointRestrain);

	// 2008/03/05 PvP Point - NeverDie
	AddSystemMessageString("PvPPoint"@a_UserInfo.PvPPoint);

	AddSystemMessageString("NicknameColor"@a_UserInfo.NicknameColor.R@a_UserInfo.NicknameColor.G@a_UserInfo.NicknameColor.B);

	AddSystemMessageString("nVitality"@a_UserInfo.nVitality);

	// Decoy - anima
	AddSystemMessageString("nMasterID"@a_UserInfo.nMasterID);

	// 2008/8/4 Talisman Num
	AddSystemMessageString("nTalismanNum"@a_UserInfo.nTalismanNum);
	// 2008/8/7 FullArmor Check
	AddSystemMessageString("nFullArmor"@a_UserInfo.nFullArmor);

	AddSystemMessageString("JoinedDominionID"@a_UserInfo.JoinedDominionID);		// lancelot 2008. 8. 28.
	AddSystemMessageString("WantHideName"@a_UserInfo.WantHideName);
	AddSystemMessageString("DominionIDForVirtualName"@a_UserInfo.DominionIDForVirtualName);
	
	// EXP percent rate - 2010/05/19 sori
	AddSystemMessageString("fExpPercentRate"@a_UserInfo.fExpPercentRate);
}

function bool IsNotDisplaySkill(int m_skillID)
{
	local bool	bIsNotDisplaySkill;
	bIsNotDisplaySkill = false;
	switch( m_skillID )
	{
		case 2039:// Soulshot:NoGrade
		case 2150:// Soulshot:D-Grade
		case 2151:// Soulshot:C-Grade
		case 2152:// Soulshot:B-Grade
		case 2153:// Soulshot:A-Grade
		case 2154:// Soulshot:S-Grade
		case 2047:// Spiritshot:NoGrade
		case 2155:// Spiritshot:D-Grade
		case 2156:// Spiritshot:C-Grade
		case 2157:// Spiritshot:B-Grade
		case 2158:// Spiritshot:A-Grade
		case 2159:// Spiritshot:S-Grade
		case 2061:// BlessedSpiritshot:NoGrade
		case 2160:// BlessedSpiritshot:D-Grade
		case 2161:// BlessedSpiritshot:C-Grade
		case 2162:// BlessedSpiritshot:B-Grade
		case 2163:// BlessedSpiritshot:A-Grade
		case 2164:// BlessedSpiritshot:S-Grade
		case 26060:// Soulshot - D grade
		case 26061:// Soulshot - C grade
		case 26062:// Soulshot -  B grade
		case 26063:// Soulshot - A grade
		case 26064:// Soulshot - S grade
		case 22036:// Beast Soulshot
		case 22037:// Beast Spiritshot
		case 22038:// Blessed Beast Spiritshot
		case 2033://[s_beast_soul_shot]
		case 2008://[s_beast_spirit_shot]
		case 2009://[s_blessed_beast_spirit_shot]
		case 26050://Blessed Spiritshot - D grade
		case 26051://Blessed Spiritshot - C grade
		case 26052://Blessed Spiritshot - B grade
		case 26053://Blessed Spiritshot - A grade
		case 26054://Blessed Spiritshot - S grade
		case 26055://Spiritshot - D grade
		case 26056://Spiritshot - C grade
		case 26057://Spiritshot -  B grade
		case 26058://Spiritshot - A grade
		case 26059://Spiritshot - S grade
		case 22369://Blessed Spiritshot - S grade
		bIsNotDisplaySkill = true;
			 break;
	}	
	return bIsNotDisplaySkill;
}

//���������츦 �����ش�. �ڵ鷯�� �����ϰ�, 
//FileWnd.uc�� Upload�Լ��� �����ؼ� ���ϵ�Ͻ� ����� �Լ��� ������ ����.
function FileRegisterWndShow(_FileHandler filehandlertype) 
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ShowFileRegisterWnd(filehandlertype);
}

function AddFileRegisterWndFileExt(string str, array<string> strArray)
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.AddFileExt(str, strArray);
}

function ClearFileRegisterWndFileExt()
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ClearFileExt();
}

//���������츦 �����ش�
function FileRegisterWndHide() 
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.HideFileRegisterWnd();
}

// ���̾�α׸� �����ش�. strMessage : �Բ� ������ ��Ʈ��( ������� "������ �Է��� �ּ���" )
// ��ô ������ ���̾�αװ� �ƴ� �̻� DialogSetID() ���� �ҷ���� �Ѵ�.
function DialogShow( EDialogModalType modalType, EDialogType dialogType, string strMessage )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.ShowDialog(modalType, dialogType, strMessage, string(Self) );
	//script.SetModal(true);

}

// ���̾�α׸� �����. ���̾�αװ� �� �ִ� ��Ȳ���� �ٸ� ���̾�α׸� �����ַ��� DialogHide() �� ���� ȣ���ؾ��Ѵ�.
function DialogHide()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.HideDialog();
}

// ���� Ű�� ������ ��� ���̾�αװ� � ������ �������� �����ϴ� �Լ��̴�.
// �� �Լ��� �θ��� ������ ����Ű�� ������ Cancel ��ư�� ���� �Ͱ� ���� ������ �Ѵ�.
// �ѹ� ���ǰ��� �ʱ�ȭ �ǹǷ� ����Ʈ �׼��� OK�� �ϰ������ �Ź� ���̾�α� ��� �� ���� �ҷ�����Ѵ�.
function DialogSetDefaultOK()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction( EDefaultOK );
}
//�׹ݴ�� cancle�� �ν��Ѵ�
function DialogSetDefaultCancle()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction( EDefaultCancel );
}
// EV_DialogOK ���� ���̾�α� �̺�Ʈ�� ���� ��, �� ���̾�αװ� �ڽ��� ��� ���̾�α� ������ �Ǻ��� �� ���δ�. ���� ��� ���̾�α׶�� �Ű澵 �ʿ䰡 ����~
function bool DialogIsMine()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	if( script.GetTarget() == string(Self) )
		return true;
	return false;
}

// �Ѱ��� uc���� ���̾�α׸� �ѹ��� ���ٸ� �� �ʿ䰡 ��������, ���̾�α׸� ���� ��Ȳ���� ���ٸ�, ���� ��� ����.uc����  �������̵� ���µ��� ����
// ���� ȣĪ�� �Է� �޴� ���� ����Ѵٸ�, ���̾�α� �̺�Ʈ�� ������ �ڽ��� � ���̾�α׸� ��������� �� �ʿ䰡 �ִ�.
// �̷� ��� ���̾�α׸� ��� �� �����ϰ� �ƹ� ���ڳ� DialogSetID() �� �ְ� �̺�Ʈ ó�� �κп��� DialogGetID()�� �ؼ� �׿� �°� �ڵ带 ¥��ȴ�.
function DialogSetID( int id )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetID( id );
}

// ���̾�α��� ����Ʈ �ڽ��� �Է� Ÿ���� ������ �� �� �ִ�. �Ϲ� ���ڿ�, ����, �н����� ��, XML �������� ���� ����.
function DialogSetEditType( string strType )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditType( strType );
}

// ���̾�α��� ����Ʈ�ڽ��� �Էµ� ��Ʈ���� �޾ƿ´�
function string DialogGetString()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetEditMessage();
}

// ���̾�α��� ����Ʈ�ڽ��� ��Ʈ���� �Է��Ѵ�
function DialogSetString(string strInput)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditMessage(strInput);
}

function int DialogGetID()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetID();
}

// ParamInt�� ���̾�α��� ���۰� ���õ� ������� ������ �ִµ� ���δ�. Progress�� timeup �ð�, NumberPad���� max�� ��.
function DialogSetParamInt64( int64 param )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetParamInt64( param );
}

// ReservedXXX ������ ���̾�α׿� �־���ٰ� �ٽ� ���� �� �� �ִٴ� ������ ParamXXX�ʹ� �ٸ���.
function DialogSetReservedInt( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt( value );
}

function DialogSetReservedInt2( INT64 value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt2( value );
}

function DialogSetReservedInt3( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt3( value );
}

function DialogSetReservedItemID( ItemID ID )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemID( ID );
}
function DialogSetReservedItemInfo( ItemInfo info)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemInfo( info );
}
function int DialogGetReservedInt()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt();
}

function INT64 INT64_0()
{
	return IntToInt64(0);
}

function INT64 DialogGetReservedInt2()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt2();
}

function int DialogGetReservedInt3()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt3();
}

function ItemID DialogGetReservedItemID()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedItemID();
}
function  DialogGetReservedItemInfo(out ItemInfo info)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.GetReservedItemInfo(info);
}
function DialogSetEditBoxMaxLength(int maxLength)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditBoxMaxLength(maxLength);
}
//function DialogSetHostWndScript(UIScript host)
//{
//	local DialogBox	script;
//	script = DialogBox(GetScript("DialogBox"));
//	script.SetHostWndScript(host);
//}
function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim)>0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length-1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim)+1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length-1] = strInput;
	arrSize = arrSize + 1;
	
	return arrSize;
}

function ShowWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
}

function ShowWindowWithFocus( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
	class'UIAPI_WINDOW'.static.SetFocus( a_ControlID );
}
function string reverseString(coerce string[255] str)
{
	local string reverseStr;
	local int i;
	for ( i = Len(str) - 1; i >= 0; --i )
	{
		reverseStr = reverseStr $ Mid(str,i,1);
	}

	return reverseStr;
}

function string trim(string s)
{
	local int i;
	if ( Len(s) == 0 ) return s;
	i = 0;
	while ( Mid(s,i,1) == " " || Mid(s,i,1) == "\t" )		//necessary for adding tab
		++i;

	s = Right(s,Len(s)-i);
	
	if ( Len(s) == 0 ) return s;

	i = Len(s) - 1;

	while ( Mid(s,i,1) == " " || Mid(s,i,1) == "\t" )	//necessary for adding tab
		--i;

	s = Left(s,i+1);

	return s;
}


function int InStrFromBack(string s, string t)
{
	local string reverseStr;
	local int i;
	reverseStr = reverseString(s);
	i = InStr(reverseStr, t);

	if ( i >= 0 )
		return Len(s) - 1 - i;
	else
		return i;
}


function HideWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.HideWindow( a_ControlID );
}

function bool IsShowWindow( string a_ControlID )
{
	return class'UIAPI_WINDOW'.static.IsShowWindow( a_ControlID );
}

function ParamToItemInfo( string param, out ItemInfo info )
{
	local int tmpInt;
	local int i;

	ParseItemID( param, info.ID );
	//ParseInt( param, "classID", info.ClassID );
	ParseInt( param, "level", info.Level);
	ParseString( param, "name", info.Name);
	ParseString( param, "additionalName", info.AdditionalName);
	ParseString( param, "iconName", info.IconName);
	ParseString( param, "iconPanel", info.IconPanel );
	ParseString( param, "description", info.Description);
	ParseInt( param, "itemType", info.ItemType);
	//ParseInt( param, "serverID", info.ServerID );
	ParseINT64( param, "itemNum", info.ItemNum);
	ParseInt( param, "slotBitType", info.SlotBitType);
	ParseInt( param, "enchanted", info.Enchanted);
	ParseInt( param, "blessed", info.Blessed);
	ParseInt( param, "damaged", info.Damaged);
	if( ParseInt( param, "equipped", tmpInt ) )
		info.bEquipped = bool(tmpInt);
	ParseINT64( param, "price", info.Price );
	ParseInt( param, "reserved", info.Reserved );
	ParseINT64( param, "reserved64", info.Reserved64 );
	ParseINT64( param, "defaultPrice", info.DefaultPrice );
	ParseInt( param, "refineryOp1", info.RefineryOp1 );
	ParseInt( param, "refineryOp2", info.RefineryOp2 );
	ParseInt( param, "currentDurability", info.CurrentDurability );
	ParseInt( param, "CurrentPeriod", info.CurrentPeriod);

	ParseInt(param, "enchantOption1", info.EnchantOption1);
	ParseInt(param, "enchantOption2", info.EnchantOption2);
	ParseInt(param, "enchantOption3", info.EnchantOption3);

	ParseInt( param, "weight", info.Weight );
	ParseInt( param, "materialType", info.MaterialType);
	ParseInt( param, "weaponType", info.WeaponType);
	ParseInt( param, "physicalDamage", info.PhysicalDamage);
	ParseInt( param, "magicalDamage", info.MagicalDamage);
	ParseInt( param, "shieldDefense", info.ShieldDefense);
	ParseInt( param, "shieldDefenseRate", info.ShieldDefenseRate);
	ParseInt( param, "durability", info.Durability);
	ParseInt( param, "crystalType", info.CrystalType);
	ParseInt( param, "randomDamage", info.RandomDamage);
	ParseInt( param, "critical", info.Critical);
	ParseInt( param, "hitModify", info.HitModify);
	ParseInt( param, "attackSpeed", info.AttackSpeed);
	ParseInt( param, "mpConsume", info.MpConsume);
	ParseInt( param, "avoidModify", info.AvoidModify);
	ParseInt( param, "soulshotCount", info.SoulshotCount);
	ParseInt( param, "spiritshotCount", info.SpiritshotCount);
		
	ParseInt( param, "armorType", info.ArmorType);
	ParseInt( param, "physicalDefense", info.PhysicalDefense);
	ParseInt( param, "magicalDefense", info.MagicalDefense);
	ParseInt( param, "mpBonus", info.MpBonus);

	ParseInt( param, "consumeType", info.ConsumeType);
	ParseInt( param, "ItemSubType", info.ItemSubType );
	ParseString( param, "iconNameEx1", info.IconNameEx1 );
	ParseString( param, "iconNameEx2", info.IconNameEx2 );
	ParseString( param, "iconNameEx3", info.IconNameEx3 );
	ParseString( param, "iconNameEx4", info.IconNameEx4 );
	if( ParseInt( param, "arrow", tmpInt ) )
		info.bArrow = bool(tmpInt);
	if( ParseInt( param, "recipe", tmpInt ) )
		info.bRecipe = bool(tmpInt);
	//ParseInt( param, "etcItemType", info.EtcItemType);
	ParseInt( param, "AttackAttributeType", info.AttackAttributeType);
	ParseInt( param, "AttackAttributeValue", info.AttackAttributeValue);
	ParseInt( param, "DefenseAttributeValueFire", info.DefenseAttributeValueFire);
	ParseInt( param, "DefenseAttributeValueWater", info.DefenseAttributeValueWater);
	ParseInt( param, "DefenseAttributeValueWind", info.DefenseAttributeValueWind);
	ParseInt( param, "DefenseAttributeValueEarth", info.DefenseAttributeValueEarth);
	ParseInt( param, "DefenseAttributeValueHoly", info.DefenseAttributeValueHoly);
	ParseInt( param, "DefenseAttributeValueUnholy", info.DefenseAttributeValueUnholy);

	tmpInt=0;
	ParseInt( param, "RelatedQuestCnt", tmpInt);
	if(tmpInt>0)
	{
		for(i=0; i<tmpInt; ++i)
			ParseInt(param, "RelatedQuestID"$i, info.RelatedQuestID[i]);
	}
	//branch
	ParseInt ( param, "IsBRPremium", info.IsBRPremium);
	ParseInt ( param, "BR_CurrentEnergy", info.BR_CurrentEnergy);
	ParseInt ( param, "BR_MaxEnergy", info.BR_MaxEnergy);
	//end of branch

	
}

function ParamToRecord( string param, out LVDataRecord record )
{
	local int idx;
	local int MaxColumn;
	
	ParseString( param, "szReserved", record.szReserved );
	ParseINT64( param, "nReserved1", record.nReserved1 );
	ParseINT64( param, "nReserved2", record.nReserved2 );
	ParseINT64( param, "nReserved3", record.nReserved3 );

	ParseInt( param, "MaxColumn", MaxColumn );
	record.LVDataList.Length = MaxColumn;
	for (idx=0; idx<MaxColumn; idx++)
	{
		ParseString( param, "szData_" $ idx, record.LVDataList[idx].szData );
		ParseString( param, "szReserved_" $ idx, record.LVDataList[idx].szReserved );
		ParseInt( param, "nReserved1_" $ idx, record.LVDataList[idx].nReserved1 );
		ParseInt( param, "nReserved2_" $ idx, record.LVDataList[idx].nReserved2 );
		ParseInt( param, "nReserved3_" $ idx, record.LVDataList[idx].nReserved3 );
	}
}

function CustomTooltip MakeTooltipSimpleText(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}

////////////////////////////////////////////////////////////
//Function For ItemID

function bool IsValidItemID(ItemID Id)
{
	if( Id.ClassID<1 && Id.ServerID<1 )
		return false;
	return true;
}

function ItemID GetItemID(int ID)
{
	local ItemID cID;
	cID.ClassID = ID;
	return cID;
}

function bool ParseItemID(string param, out ItemID ID)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID", ID.ClassID);
	bRet2 = ParseInt(param, "ServerID", ID.ServerID);
	return bRet1 || bRet2;
}

function bool ParseItemIDWithIndex(string param, out ItemID ID, int idx)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID_" $ idx, ID.ClassID);
	bRet2 = ParseInt(param, "ServerID_" $ idx, ID.ServerID);
	return bRet1 || bRet2;
}

function ParamAddItemID(out string param, ItemID ID)
{
	if (ID.ClassID>0)
		ParamAdd(param, "ClassID", string(ID.ClassID));
	if (ID.ServerID>0)
		ParamAdd(param, "ServerID", string(ID.ServerID));
}

function ParamAddItemIDWithIndex(out string param, ItemID ID, int idx)
{
	if (ID.ClassID>0)
		ParamAdd(param, "ClassID_" $ idx, string(ID.ClassID));
	if (ID.ServerID>0)
		ParamAdd(param, "ServerID_" $ idx, string(ID.ServerID));
}

function ClearItemID(out ItemID ID)
{
	ID.ClassID = -1;
	ID.ServerID = -1;
}

function bool IsSameItemID(ItemID src, ItemID des)
{
	if (src.ClassID==des.ClassID && src.ServerID==des.ServerID)
		return true;
	return false;
}

function bool IsSameClassID(ItemID src, ItemID des)
{
	if (src.ClassID==des.ClassID)
		return true;
	return false;
}

function bool IsSameServerID(ItemID src, ItemID des)
{
	if (src.ServerID==des.ServerID)
		return true;
	return false;
}

function bool IsAdena(ItemID ID)
{
	if (ID.ClassID==57)
		return true;
	return false;
}

//branch
function string GetPrimeItemSymbolName()
{
	return "BranchSys.ui.primeitem_symbol";
}
//end of branch

// Chat Color
/*
function Color GetChatColorByType( EChatType a_Type )
{
	local Color ResultColor;

	ResultColor.A = 255;

	switch( a_Type )
	{
	case CHAT_NORMAL:
	case CHAT_PARTY_ROOM_CHAT :
	case CHAT_USER_PET :				// '^'	
		ResultColor.R = 220;
		ResultColor.G = 220;
		ResultColor.B = 220;
		break;
	case CHAT_SHOUT:					// '!'
	case CHAT_CUSTOM :
		ResultColor.R = 255;
		ResultColor.G = 114;
		ResultColor.B = 0;
		break;
	case CHAT_TELL:						// ' " '
		ResultColor.R = 255;
		ResultColor.G = 0;
		ResultColor.B = 255;
		break;
	case CHAT_PARTY:					// '#'
		ResultColor.R = 0;
		ResultColor.G = 255;
		ResultColor.B = 0;
		break;
	case CHAT_CLAN:						// '@'
		ResultColor.R = 125;
		ResultColor.G = 119;
		ResultColor.B = 255;
		break;
	case CHAT_SYSTEM :			 		// ''
		ResultColor.R = 176;
		ResultColor.G = 155;
		ResultColor.B = 121;
		break;
	case CHAT_GM_PET :					// '&'	
	case CHAT_ANNOUNCE :
		ResultColor.R = 128;
		ResultColor.G = 255;
		ResultColor.B = 255;
		break;
	case CHAT_MARKET:					// '+'
		ResultColor.R = 234;
		ResultColor.G = 165;
		ResultColor.B = 245;
		break;
	case CHAT_ALLIANCE:					// '%'	
		ResultColor.R = 119;
		ResultColor.G = 255;
		ResultColor.B = 153;
		break;
	case CHAT_COMMANDER_CHAT :
	case CHAT_SCREEN_ANNOUNCE :
		ResultColor.R = 255;
		ResultColor.G = 150;
		ResultColor.B = 149;
		break;
	case CHAT_INTER_PARTYMASTER_CHAT :
		ResultColor.R = 255;
		ResultColor.G = 248;
		ResultColor.B = 178;
		break;
	case CHAT_CRITICAL_ANNOUNCE :
		ResultColor.R = 0;
		ResultColor.G = 255;
		ResultColor.B = 255;
		break;
	case CHAT_HERO :
		ResultColor.R = 64;
		ResultColor.G = 140;
		ResultColor.B = 255;
		break;
	}

	return ResultColor;
}
*/
defaultproperties
{
}
