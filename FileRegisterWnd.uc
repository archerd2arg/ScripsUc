class FileRegisterWnd extends UICommonAPI;
var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName, FolderTextureName, UpFolderTextureName;
var string CurrentForerTextureName, DesktopTextureName, MyDocumentsTextureName, DriveTextureName;
var _FileHandler FileHandler;
var bool IsIdle;
var string m_fileName;

//////////////////////////////////////////////////////////////////////// jdh84 /////////////////
//                             fileRegisterWnd의 사용법.
//
// 1. filewnd를 XXX파일 등록에 사용하고싶다.
// 2. UICommonAPI의 _FileHandler 에 새로운 ENUM(TYPE) 값을 추가한다.
// 3. 파일을 등록시키는 API를 작성한다.
// 4. UploadFile함수에 그 파일 핸들러에 맞는 API를 등록한다.
// 5-1. AddFileWndFileExt 함수와 ClearFileWndFileExt 함수를 사용해 확장자 박스를 조정한다
// 5-2. FileRegisterWndShow(2번에서 지정한 타입)함수를 호출하여 활성화한다  
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
function ShowFileRegisterWnd(_FileHandler filehandlertype) //UICommanAPI 로 사용하기 위해 Filewnd 를 캡슐화
{
	if(m_bShow) 
	{
		return; //이미 다른 파일 파일창이 떠있다. 피드백을 넣어 줍시다
	}
	
	FileHandler = filehandlertype;
	
	// 2229 시스템스트링 : 파일등록 
	// 파일 등록시 윈도우 타이틀 이름을 구분할 필요가 있다면.. 
	switch(FileHandler)
	{
		case FH_PLEDGE_CREST_UPLOAD:
			Me.SetWindowTitle(GetSystemString(2229));
			break;
		case FH_PLEDGE_EMBLEM_UPLOAD:
			Me.SetWindowTitle(GetSystemString(2229));
			break;
		case FH_ALLIANCE_CREST_UPLOAD:
		default:
			Me.SetWindowTitle(GetSystemString(2229));
			break;
	}
	Me.ShowWindow();
	Me.SetFocus();
}

function HideFileRegisterWnd() //UICommanAPI 로 사용하기 위해 Filewnd 를 캡슐화
{
	Me.HideWindow();
}

function AddFileExt(string str, array<string> strArray) //UICommanAPI 로 사용하기 위해 Filewnd 를 캡슐화
{
	FileExtComboBoxCtrl.AddStringWithFileExt(str,strArray);	
}

function ClearFileExt() //UICommanAPI 로 사용하기 위해 Filewnd 를 캡슐화
{
	FileExtComboBoxCtrl.Clear();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////////////////////////////////
function bool UploadFile(string filePath, string fileName) 
{
	local string filestr;
	filestr = filePath $ "\\" $ fileName;
	if(FileHandler >= FH_MAX) return true;
	SetOptionString("Game", "FileRegisterPath" $ string(FileHandler), filePath);
	UploadFileFullPath(filestr);
}

function bool UploadFileFullPath(string path)
{
//	debug(path);
	if(FileHandler >= FH_MAX) return true;
	
	switch(FileHandler)
	{
		case FH_NONE:
			return true;
		case FH_PLEDGE_CREST_UPLOAD:
			return RequestClanRegisterCrestByFilePath(path); //혈맹문장 등록
		case FH_PLEDGE_EMBLEM_UPLOAD:
			return RequestClanRegisterEmblemByFilePath(path); //혈맹휘장 등록
		case FH_ALLIANCE_CREST_UPLOAD:
			return RequestAllianceRegisterCrestByFilePath(path); //동맹 문장 등록
		default:
			return true;
	}
}

function OnLoad()
{
	// hard coding
	local array<string> strArray;
	//local int i;
	
	IsIdle = true; //처음에는 idle 상태(두개이상의 파일윈도우를 생성하지 않도록)
	FileHandler = FH_NONE; //초기상태는 파일 핸들러가 없음
	FileTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_BMP"; //파일의 텍스쳐
	FolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Folder"; //폴더의 텍스쳐
	UpFolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderUp";

	CurrentForerTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderOpen";
	DesktopTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Desktop";
	MyDocumentsTextureName= "L2UI_CT1.FileRegisterWnd_DF_Icon_MyDocument";
	DriveTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Drive";

	if(CREATE_ON_DEMAND==0)
	{
	}
	else
	{
		Me = GetWindowHandle( "FileRegisterWnd" );
		FileListCtrl = GetListCtrlHandle("FileWnd.fileListCtrl");
		FileListCtrl.SetHeaderAlignment(0,TA_LEFT);
		FileListCtrl.SetResizable(false);
		EditBoxCtrl = GetEditBoxHandle("FileWnd.fileNameEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileWnd.FileLocationComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileWnd.FileTypeComboBox");
		
		FileListCtrl.SetHeaderTextOffset(0,135);
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt("모든 파일", strArray);
		SetFilePathnAdjustControl(GetMydocumentPath());
	}
	m_bShow = false;
}

function SetFilePathnAdjustControl( string s )
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	UpdateFilePathComboBox(s);
	
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
	EnumerateFile(fInfoArray);
}

function int SearchFileListWithName(string s)
{
	local int i, num;
	local LVDataRecord record;
	num = FileListCtrl.GetRecordCount();

	for ( i = 0; i < num; ++i )
	{
		FileListCtrl.GetRec(i,record);
		if ( record.LVDataList[0].szData == s )
			return i;
	}
	return -1;
}

function OnCompleteEditBox( String strID )
{
	local LVDataRecord record;
	local int idx;
	local string strEdit, filePath;

	if ( strID != "fileNameEditBox" )
		return;

	strEdit = EditBoxCtrl.GetString();
	idx = SearchFileListWithName(strEdit);
	
	if ( idx < 0 )  //에디트박스의 파일명이 현 디렉토리에 없다면 Full path로 간주하자
	{
		UploadFileFullPath(strEdit);
		EditBoxCtrl.Clear();
		return;
	}

	FileListCtrl.GetRec(idx, record);

	m_fileName = record.LVDataList[0].szData;

	if ( record.nReserved1 == IntToInt64(1) ) //check
	{
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
	else
		SetFilePathnAdjustControl(filePath);
}

function OnDBClickListCtrlRecord( String strID )
{
	local int index;
	local int Idx;
	local LVDataRecord record;
	local string str;
	local string editStr;
	if ( strID != "fileListCtrl" )
		return;
	
	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	
	if(record.nReserved2 == IntToInt64(1)) //상위폴더
	{
		index = InStrFromBack(m_filePath,"\\");
		if ( index >= 0 )
		{
			editStr = Left(m_filePath,index);
			SetFilePathnAdjustControl(editStr);
		}
		return;
	}
	str = record.LVDataList[0].szData;		
	
	if ( record.nReserved1 == IntToInt64(0) )		// case of directory
	{
		
		str = m_filePath $ "\\" $ str;
		
		SetFilePathnAdjustControl(str);
		
	}
	else
	{
		m_fileName = record.LVDataList[0].szData;
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
}


function UpdateFilePathComboBox(String str)
{
	local int i, j, k, drivenum;
	
	local array<DriveInfo> arrDrvInfo;
	//local array<string> realpath;
	local int width;
	local int selectednum;
	local string desktop;
	selectednum = 0;
	if ( Len(str) <= 0 ) return;

	FilePathComboBoxCtrl.Clear();
	m_filePath = str;
	k = -1;

	desktop = GetDesktopPath();
	if(len(desktop) != 0)
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop,InstrFromBack(desktop,"\\")+1) , DesktopTextureName, desktop);			
		selectednum++;
	}
	desktop = GetMydocumentPath();
	if(len(desktop) != 0)
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop,InstrFromBack(desktop,"\\")+1) , MyDocumentsTextureName, desktop);			
		selectednum++;
	}

	arrDrvInfo = GetDrivesInfoList();
	
	for ( drivenum = 0; drivenum < arrDrvInfo.Length; ++drivenum )
	{
		if ( Left(arrDrvInfo[drivenum].driveChar,1) != Left(m_filePath,1) ) //current path와 일치하는 드라이브의 볼륨이 아니면 볼륨명만 표시한다
		{
			FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Left(arrDrvInfo[drivenum].driveChar,1) $ ":" ,DriveTextureName,1, Left(arrDrvInfo[drivenum].driveChar,1) $ ":");			
			selectednum++;
		}
		else //current path 의 drive라면 상세경로를 모두 표시한다.
		{
			i = 0; //last "\\" founded index
			j = 0;
			k = 0; //gap
			while(true)
			{
				
				j = i; //preserve "\\" index is founded in previous step
				if(j == 0) //문자열의 처음에는 "/"가 없으므로 따로해준다
				{
					i = inStr(Mid(str,j), "\\");
					width = j; //첫 / 와 다음 /의 간격
				}
				else
				{
					i = inStr(Mid(str,j+1), "\\");
					width = j + 1;
				}
					

				if(i == -1) // 경로에 "\"가 남지않음
				{	
					
					if(j == 0)
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j) , DriveTextureName, k+1, str);		
					else
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j+1) , CurrentForerTextureName, k+1, str);		
					break;
				}
				else
				{
					i += width;
				
					if(j == 0)
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j,i-j) , DriveTextureName, k+1, Left(str,i));							
					else
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j+1,i-j-1) , FolderTextureName, k+1, Left(str,i));							
					k++;
				}
			}

		FilePathComboBoxCtrl.SetSelectedNum(k+selectednum); // necessary for modifying
		}
	}

	
}


function OnClickListCtrlRecord( String strID )
{
	local int Idx;
	local LVDataRecord record;
	
	if( strID != "fileListCtrl" )
		return;

	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	EditBoxCtrl.SetString(record.LVDataList[0].szData);
}

function EnumerateFile( array<FileNameInfo> FList )
{
	local int k;
	local LVDataRecord Record;
	FileListCtrl.DeleteAllItem();
	
	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = "..";
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nsortPrior = 2;
	Record.LVDataList[0].szTexture = UpFolderTextureName;
	Record.nReserved2 = IntToInt64(1); //case of an upfolder
	k = InStrFromBack(m_filePath,"\\");
	
	if(k != -1)
		FileListCtrl.InsertRecord(Record); // not a root directory. insert Upforder.
	
	for (k = 0; k < FList.Length; k++)
	{
		
		Record.LVDataList[0].szData = FList[k].fileName;
		Record.LVDataList[0].hasIcon = true;
		Record.nReserved2 = IntToInt64(0); //case of not an upfolder

		if(FList[k].bIsFile)
		{
			Record.LVDataList[0].nsortPrior = 0;
			Record.LVDataList[0].szTexture = FileTextureName;
		}
		else
		{
			Record.LVDataList[0].nsortPrior = 1;
			Record.LVDataList[0].szData = Right(Record.LVDataList[0].szData, Len(Record.LVDataList[0].szData)-1);//폴더앞에 "/"가 끼어서 없애주자
			Record.LVDataList[0].szTexture = FolderTextureName;
		}
				
		Record.nReserved1 = BoolToInt64( FList[k].bIsFile );
		FileListCtrl.InsertRecord(Record);
	}
	FileListCtrl.AdjustColumnWidth(0,296);
	FileListCtrl.SetSelectedIndex(0,true);
}


function OnShow()
{
//	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	
	
	if(GetOptionString("Game", "FileRegisterPath" $ string(FileHandler)) == "")
		m_filePath = GetMydocumentPath();
	else
		m_filePath = GetOptionString("Game", "FileRegisterPath" $ string(FileHandler));

	if(m_filePath != "")
		SetFilePathnAdjustControl(m_filePath);
	else
	{
		m_filePath = "C:";
		SetFilePathnAdjustControl(m_filePath);
	}

	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnComboBoxItemSelected( String strID, int index )
{
	local string str;
//	local int i, s, e;
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;
	if ( index < 0 ) return;

	if (strID == "fileLocationComboBox" )
	{
		str = FilePathComboBoxCtrl.GetAdditionalString(FilePathComboBoxCtrl.GetSelectedNum());
		SetFilePathnAdjustControl(str);
	}
	else if ( strID == "fileTypeComboBox" )
	{
		fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
		fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
		EnumerateFile(fInfoArray);
	}
}

function OnClickButton( string strID )
{
	local string editStr, filePath;
	local int index;
	local LVDataRecord record;


	switch( strID )
	{
	case "registOKButton" :
		
		editStr = EditBoxCtrl.GetString();
		index = SearchFileListWithName(editStr);
		if ( index < 0 )
		{
			AddSystemMessage(528);
			EditBoxCtrl.Clear();
			break;
		}
		FileListCtrl.GetRec(index, record);

		if ( record.nReserved1 == IntToInt64(1) )
		{
			m_fileName = record.LVDataList[0].szData;
			if ( UploadFile(m_filePath, m_fileName) )
				Me.HideWindow();
			else
				;
		}
		else
		{
			filePath = m_filePath $ "\\" $record.LVDataList[0].szData;
			SetFilePathnAdjustControl(filePath);
		}
		break;
	case "registCancleButton":
		Me.HideWindow();
		break;
	case "refreshButton":
		SetFilePathnAdjustControl(m_filePath);
		break;
	
	}
}
defaultproperties
{
}
