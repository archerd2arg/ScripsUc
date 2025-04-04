class BR_PopupWnd extends UICommonAPI;

var WindowHandle Me;
var CharacterViewportWindowHandle AgaViewport;
var DrawPanelHandle m_hDrawPanel;
var DrawItemInfo m_kDrawInfoClear;

struct ProductInfo2
{
	var int 	iProductID;
//	var int 	iCategory;
	var int		iShowTab;
//	var int		iPrice;
	var string	strName;
	var string 	strIconName;
	var int		iDayWeek;
	var int		iStartSale;
	var int		iEndSale;
	var int		iStartHour;
	var int		iStartMin;
	var int		iEndHour;
	var int		iEndMin;
	var int		iStock;
	var int		iMaxStock;
	var int		iLimited; // CashShopWnd의 구조체와 다른 변수
	var int		iLineNum; // 따로 추가한 변수
};
var array< ProductInfo2 >	m_ProductList;
var int m_EventProductID;
var int m_ProductIndex;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_CashShopToggleWindow );
	RegisterEvent( EV_BR_CashShopAddItem );
	RegisterEvent( EV_BR_ProductListEnd );
}

function OnLoad()
{	
	Initialize();
	m_ProductIndex = 0;
}

function Initialize()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "PopupWnd" );
	}
	else	{
		Me = GetWindowHandle( "PopupWnd" );
	}	
}

function OnTimer( int TimerID )
{	
	if(TimerID == 2009)
	{
		if( IsShowWindow("PopupWnd") ) Me.HideWindow();
		Me.KillTimer( 2009 );
	}
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
		case EV_BR_CashShopAddItem :
				AddProductItem(param);
			break;
		case EV_BR_CashShopToggleWindow :	
			if(IsShowWindow("PopupWnd")) Me.HideWindow();
			m_ProductList.Length = 0;	
			break;
		case EV_BR_ProductListEnd :
			ClearDrawPanel();
			SetDrawPanel(); 		    
			break;
	}
}

function OnHide()
{
	Me.KillTimer( 2009 );
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X,int Y)
{
	local string strHandle;
	
	strHandle = string(a_WindowHandle);	

	if(len(strHandle)!=4) // 타이틀바와 종료버튼 제외
		SendClickItem();
}

function AddProductItem(string param)
{	
	//local int iId, category, showtab, price;
	local int iId, showtab;
	local string itemname, iconname;
	local int day_week, start_hour, start_min, end_hour, end_min, stock, max_stock;
	local int start_sale, end_sale;
	
	local int iCurrentIndex;
	
	ParseInt(param, "ID", iId);
	//ParseInt(param, "Category", category);	
	ParseInt(param, "ShowTab", showtab);
	
	if( (showtab&1)!=1 ) return; // 이벤트 상품이 아니면 리턴
	
	//ParseInt(param, "Price", price);
	ParseString(param, "ItemName", itemname);
	ParseString(param, "IconName", iconname);
	ParseInt(param, "StartSale", start_sale);
	ParseInt(param, "EndSale", end_sale);	
	ParseInt(param, "DayWeek", day_week);
	ParseInt(param, "StartHour", start_hour);
	ParseInt(param, "StartMin", start_min);
	ParseInt(param, "EndHour", end_hour);
	ParseInt(param, "EndMin", end_min);
	ParseInt(param, "Stock", stock);
	ParseInt(param, "MaxStock", max_stock);
	
	iCurrentIndex = m_ProductList.Length;
	m_ProductList.Length = iCurrentIndex + 1;

	m_ProductList[iCurrentIndex].iProductID = iId;
	//m_ProductList[iCurrentIndex].iCategory = category;
	m_ProductList[iCurrentIndex].iShowTab = showtab;
	//m_ProductList[iCurrentIndex].iPrice = price;
	m_ProductList[iCurrentIndex].strName = itemname;
	m_ProductList[iCurrentIndex].strIconName = iconname;
	m_ProductList[iCurrentIndex].iStartSale = start_sale;
	m_ProductList[iCurrentIndex].iEndSale = end_sale;	
	m_ProductList[iCurrentIndex].iDayWeek = day_week;
	m_ProductList[iCurrentIndex].iStartHour = start_hour;
	m_ProductList[iCurrentIndex].iStartMin = start_min;
	m_ProductList[iCurrentIndex].iEndHour = end_hour;
	m_ProductList[iCurrentIndex].iEndMin = end_min;
	m_ProductList[iCurrentIndex].iStock = stock;
	m_ProductList[iCurrentIndex].iMaxStock = max_stock;
	
	m_ProductList[iCurrentIndex].iLimited = 0;
	m_ProductList[iCurrentIndex].iLineNum = 0;
	
	if ( !(start_hour==0 && start_min==0 && end_hour==23 && end_min==59) ) {
		m_ProductList[iCurrentIndex].iLimited += 1;
		m_ProductList[iCurrentIndex].iLineNum++; 
	}
	if ( day_week != 127 ) {
		m_ProductList[iCurrentIndex].iLimited += 4;
		m_ProductList[iCurrentIndex].iLineNum++; 
	}
	if ( max_stock > 0 ) {
		m_ProductList[iCurrentIndex].iLimited += 8;
		m_ProductList[iCurrentIndex].iLineNum++; 
	}	
	if ( BR_GetDayType(m_ProductList[iCurrentIndex].iEndSale, 0) != 2037) {
		m_ProductList[iCurrentIndex].iLimited += 16;
		m_ProductList[iCurrentIndex].iLineNum++;
	}
}

function SetDrawPanel()
{
	local int nText, nText1, nText2;
	local string strTemp, strTemp2;
	local int nWidth, nHeight;
		
	if(m_ProductList.Length==0) return; // 이벤트 상품이 없으면 팝업 띄우지 않음
	
	if(m_ProductIndex>=m_ProductList.Length) m_ProductIndex=0;
	
	GetTextSizeDefault( m_ProductList[m_ProductIndex].strName, nWidth, nHeight );
	
	if( nWidth<219) {
		if( m_ProductList[m_ProductIndex].iLineNum <= 1 ) {
			nText1 = 28; nText2 = 21; 
		}		
		else if( m_ProductList[m_ProductIndex].iLineNum == 2) {
			nText1 = 28; nText2 = 12;
		}	
		else if( m_ProductList[m_ProductIndex].iLineNum == 3) {
			nText1 = 25; nText2 = 8;
		}
		else if( m_ProductList[m_ProductIndex].iLineNum == 4) {
			nText1 = 20; nText2 = 8; 
		}
		//else if( m_ProductList[m_ProductIndex].iLineNum == 5) {
		//	nText1 = 14; nText2 = 5;
		//}
	}
	else {
		if( m_ProductList[m_ProductIndex].iLineNum <= 1 ) {
			nText1 = 28; nText2 = 12; 
		}		
		else if( m_ProductList[m_ProductIndex].iLineNum == 2) {
			nText1 = 26; nText2 = 7;
		}	
		else if( m_ProductList[m_ProductIndex].iLineNum == 3) {
			nText1 = 21; nText2 = 4;
		}
		else if( m_ProductList[m_ProductIndex].iLineNum == 4) {
			nText1 = 15; nText2 = 3; 
		}
		//else if( m_ProductList[m_ProductIndex].iLineNum == 5) {
		//	nText1 = 9; nText2 = 0;
		//}
	}
	
    // DrawPanel에 그리기
	DrawIcon( m_ProductList[m_ProductIndex].strIconName );
	DrawText( m_ProductList[m_ProductIndex].strName, nWidth, nText1 );	
	
	if (m_ProductList[m_ProductIndex].iLimited==0) {
		DrawText( GetSystemString(5033), -1, nText2 ); // 오늘의 추천 상품
	}
	else {				
		nText = nText2;
		if ( (m_ProductList[m_ProductIndex].iLimited&16)==16 ) { // 판매 기간 제한
			strTemp = BR_ConvertTimetoStr(m_ProductList[m_ProductIndex].iStartSale, 1) ;
			strTemp2 = BR_ConvertTimetoStr(m_ProductList[m_ProductIndex].iEndSale, 1) ; 
			if(strTemp==strTemp2)
				DrawText(strTemp, -1, nText);	
			else			
				DrawText(strTemp $ "~" $ strTemp2, -1, nText);	
			nText = 0;				
		}
			
		if( (m_ProductList[m_ProductIndex].iLimited&4)==4 ) { // 판매 요일 제한
			DrawText( GetSystemString(5028), -1, nText );
			nText = 0;
		}		
		if( (m_ProductList[m_ProductIndex].iLimited&1)==1 ) { // 판매 시간 제한 
			strTemp = GetSystemString(5029) $ " " $ TransformTime(m_ProductList[m_ProductIndex].iStartHour) $ ":" $ TransformTime(m_ProductList[m_ProductIndex].iStartMin)  
					  $ "~" $ TransformTime(m_ProductList[m_ProductIndex].iEndHour) $ ":" $ TransformTime(m_ProductList[m_ProductIndex].iEndMin) ;
			DrawText( strTemp, -1, nText );
			nText = 0;
		}		
		if( (m_ProductList[m_ProductIndex].iLimited&8)==8 ) { // 판매 갯수 제한
			strTemp = GetSystemString(5027) $ " " $ m_ProductList[m_ProductIndex].iStock $ "/" $ m_ProductList[m_ProductIndex].iMaxStock ;
			DrawText( strTemp, -1, nText );				
			nText = 0;
		}	
	}	

	m_EventProductID = m_ProductList[m_ProductIndex].iProductID;
	
	m_ProductIndex++;
			
	Me.ShowWindow();
	Me.SetTimer( 2009, 12000 );	
}

function String TransformTime(int num)
{
	if( num<10 ) return "0" $ num;
	return string(num);			
}

function SendClickItem()
{	
	local BR_CashShopWnd script_a;	

	script_a = BR_CashShopWnd( GetScript("BR_CashShopWnd") );	
	script_a.ClickPopupItemList( m_EventProductID );
	
	Me.HideWindow();
}

function ClearDrawPanel()
{
	local int i;
	
	for( i=0; i<3; i++ )
	{
		if (m_hDrawPanel == None) {		
			m_hDrawPanel = DrawPanelHandle( Me.AddChildWnd(XCT_DrawPanel) );
			m_hDrawPanel.SetWindowSize( 256, 138 );
			m_hDrawPanel.Move(15,40);
		}
		m_hDrawPanel.Clear();
	}
}

function DrawText(string itemString, int type, int num)
{
	local DrawItemInfo kDrawInfo;
	local int nWidth, nHeight;
	
	GetTextSizeDefault(itemString, nWidth, nHeight);

	if(type==-1) {
		MakeDrawInfo_Desc(kDrawInfo, itemString, 255, 255, 200);
	}
	else {
		MakeDrawInfo_Desc(kDrawInfo, itemString, 220, 220, 0);
	}
	
	if( type<219 ) kDrawInfo.nOffSetX = 110-(nWidth/2);
	else kDrawInfo.nOffSetX = 0;

	kDrawInfo.nOffSetY = num; 	
	m_hDrawPanel.InsertDrawItem(kDrawInfo);
}

function DrawIcon(string icon)
{
	local DrawItemInfo kDrawInfo;

	MakeDrawInfo_Image(kDrawInfo, icon, 32, 32);	
	kDrawInfo.nOffSetX = 93; //(220/2)-16;
	kDrawInfo.nOffSetY = 0;
	kDrawInfo.bLineBreak = true;
	m_hDrawPanel.InsertDrawItem(kDrawInfo);
}

////////////////// for DrawPanel //////////////////

function MakeDrawInfo_Desc(out DrawItemInfo Info, string str, int r, int g, int b)
{
	Info = m_kDrawInfoClear;

	Info.eType = DIT_TEXT;
	Info.bLineBreak = true;
	Info.t_bDrawOneLine = false;
	Info.t_MaxWidth = 220;
	Info.t_color.R = r;
	Info.t_color.G = g;
	Info.t_color.B = b;
	Info.t_color.A = 255;
	Info.t_strText = str;
}

function bool MakeDrawInfo_Image(out DrawItemInfo Info, string TextureName, int width, int height)
{
	Info = m_kDrawInfoClear;
	if (Len(TextureName)>0)
	{
		Info.eType = DIT_TEXTURE;
		//Info.nOffSetX = 0;
		//Info.nOffSetY = 0;
		Info.u_nTextureWidth = width;
		Info.u_nTextureHeight = height;
		Info.u_nTextureUWidth = width;
		Info.u_nTextureUHeight = height;
		Info.u_strTexture = TextureName;
		
		return true;
	}	
	return false;
}
defaultproperties
{
}
