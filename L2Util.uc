/**
 *   UI 관련 편의 함수  
 **/
class L2Util extends UICommonAPI;

/*
   ex) 
   var L2Util util;
   util = L2Util(GetScript("L2Util"));
*/

// 칼라
var Color White;
var Color Yellow;
var Color Blue;
var Color BrightWhite;
var Color Gold;

/**
 *  Tree 용 **************************************************************************************************************
 **/
enum ETreeItemTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD,
	COLOR_RED,
	COLOR_YELLOW
};
//************************************************************************************************************************


/**
 *  ToopTip 용 ***********************************************************************************************************
 **/
var CustomTooltip TooltipText;
var DrawItemInfo TooltipInfo;

enum ETooltipTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD
};
//************************************************************************************************************************

delegate bool myDelegate(bool bFirst, string str);






/**
 * OnLoad
 **/
function OnLoad()
{
	initColor();
}

/**
 *  칼라 값들 세팅 
 **/ 
function initColor()
{
	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;	

	White.R = 170;
	White.G = 170;
	White.B = 170;

	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;

	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;
}

/**
 * 버튼의 텍스트를 변경한다. 이때 시스템스트링의 인덱스를 주어 텍스트를 선택한다
 * 
 * @param
 * controlPath   : xml 컨트롤 경로
 * texturePath   : 패키징 된 텍스쳐 경로
 * playLoopCount : 재생되는 루프 카운트 
 * 
 * @return
 * void
 * 
 * @example 
 * animTexturePlay("testWnd.montionTexture", "l2_state_l2_...", 1);
 * 
 * */
function animTexturePlay(string controlPath, string texturePath,int playLoopCount)
{	
	GetAnimTextureHandle(controlPath).SetTexture(texturePath);
	GetAnimTextureHandle(controlPath).ShowWindow();
	GetAnimTextureHandle(controlPath).SetLoopCount(playLoopCount);
	GetAnimTextureHandle(controlPath).Stop();
	GetAnimTextureHandle(controlPath).Play();
}



/*
 * ex)	
 * //Root 노드 생성.
 * util.TreeInsertRootNode( TREENAME, ROOTNAME, "", 0, 4 );
 * //+버튼 있는 상위 노드 생성
 * util.TreeInsertExpandBtnNode( TREENAME, "LIST1", ROOTNAME );
 * //위의 노드에 글씨 아이템 추가
 * util.TreeInsertTextNodeItem( TREENAME, ROOTNAME$"."$"LIST1", GetSystemString(2370), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );
 * 
 * //아이템 배경 만들기(있는넘)
 * util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14 );
 * //아이템 배경 만들기(없는넘)
 * util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 257, 38 );
 * 아이템 만들기..아래.
	//Insert Node Item - 아이템슬롯 배경
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2 );
	//Insert Node Item - 아이템 아이콘
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );
	//Insert Node Item - 아이템 이름
	util.TreeInsertTextNodeItem( TREENAME, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
	//Insert Node Item - "Lv"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString(88),46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );
	//Insert Node Item - 레벨 값
	util.TreeInsertTextNodeItem( TREENAME, strRetName, string(iLevel), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD );
	//Insert Node Item - MP물약 아이콘 ( 소모엠피 )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test 값"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "630", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
	//Insert Node Item - 시간 아이콘 ( 시전시간 )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test 값"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "2초", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
	//Insert Node Item - 시간 아이콘 ( 재사용시간 )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test 값"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "2분", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
 */

//** 선준 Code 추가 Tree용 Node, NodeItem에 관한 코드 *******************************************************************************************************************************************************

/**
 *  트리 ROOT 노드 추가  
 *  [TreeName:노드 추가할 Tree 네임:string]   
 *  [NodeName:노드 네임:string]    
 *  [ParentName:추가할 노드의 상위 노드:string]  
 *  [offSetX:노드 x 위치:optional int]   
 *  [offSetY:노드 y 위치:optional int]
 */
function TreeInsertRootNode( string TreeName, string NodeName, string ParentName, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;
	
	infNode.strName = NodeName;	
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;

	class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/**
 *  트리 Expand 버튼 노드 추가
 *  [TreeName:노드 추가할 Tree 네임:string]
 *  [NodeName:노드 네임:string]
 *  [ParentName:추가할 노드의 상위 노드:string]
 *  [nTexBtnWidth:Expand버튼 넓이:int]
 *  [nTexBtnHeight:Expand버튼 높이:int]
 *  [strTexBtnExpand:Tree열림버튼 텍스쳐:optional string]
 *  [strTexBtnExpand_Over:Tree열림버튼 오버 텍스쳐:optional string]
 *  [strTexBtnCollapse:Tree닫힘버튼 텍스쳐:optional string]
 *  [strTexBtnCollapse_Over:Tree열림버튼 오버 텍스쳐:optional string]
 *  [offSetX:노드 x 위치:optional int]   
 *  [offSetY:노드 y 위치:optional int]
 */
function TreeInsertExpandBtnNode( string TreeName, string NodeName, string ParentName, optional int nTexBtnWidth, optional int nTexBtnHeight, 
									optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over,
									optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;

	if( nTexBtnWidth == 0 ) nTexBtnWidth = 15;
	if( nTexBtnHeight == 0 ) nTexBtnHeight = 15;
	if( strTexBtnExpand == "" ) strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	if( strTexBtnExpand_Over == "" ) strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	if( strTexBtnCollapse == "" ) strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	if( strTexBtnCollapse_Over == "" ) strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";

	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;

	class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/**
 *  트리 ITEM 노드 추가
 *  [TreeName:노드 추가할 Tree 네임:string]
 *  [NodeName:노드 네임:string]
 *  [ParentName:추가할 노드의 상위 노드:string]
 *  [nTexBtnWidth:Expand버튼 넓이:int]
 *  [nTexBtnHeight:Expand버튼 높이:int]
 *  [strTexBtnExpand:Tree열림버튼 텍스쳐:optional string]
 *  [strTexBtnExpand_Over:Tree열림버튼 오버 텍스쳐:optional string]
 *  [strTexBtnCollapse:Tree닫힘버튼 텍스쳐:optional string]
 *  [strTexBtnCollapse_Over:Tree열림버튼 오버 텍스쳐:optional string]
 *  [offSetX:노드 x 위치:optional int]   
 *  [offSetY:노드 y 위치:optional int]
 */
function string TreeInsertItemTooltipSimpleNode( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;
	
	if( TooltipSimpleText != "" ) infNode.Tooltip = MakeTooltipSimpleText( TooltipSimpleText );
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand되었을때의 BackTexture설정
	//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;		
	infNode.nTexExpandedHeight = nTexExpandedHeight;		
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;		
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth; 		
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

function string TreeInsertItemTooltipNode( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									CustomTooltip TooltipText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;	
	
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand되었을때의 BackTexture설정
	//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;		
	infNode.nTexExpandedHeight = nTexExpandedHeight;		
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;		
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth; 		
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

function string TreeInsertItemNode( string TreeName, string NodeName, string ParentName, optional bool bFollowCursor, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = bFollowCursor;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/**
 *  트리 노드에 Text 아이템 추가
 *  [TreeName:노드 추가할 Tree 네임]
 *  [NodeName:노드 네임]
 *  [ItemName:Text에 추가되 내용]
 *  [offSetX:Text x 위치]   
 *  [offSetY:Text y 위치]
 *  [E:Text 색상 ETreeItemTextType 값]
 *  [OneLine:t_bDrawOneLine 값]
 *  [bLineBreak:bLineBreak 값]
 */
function TreeInsertTextNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, optional ETreeItemTextType E, 
									optional bool OneLine, optional bool bLineBreak, optional int reserved )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = OneLine;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	
	infNodeItem = setTreeTextColor( E, infNodeItem );

	if( reserved != 0 )
	{
		infNodeItem.nReserved = reserved;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}

/**
 *  트리 노드에 Text 아이템 추가
 *  [TreeName:노드 추가할 Tree 네임]
 *  [NodeName:노드 네임]
 *  [ItemName:Text에 추가되 내용]
 *  [offSetX:Text x 위치]   
 *  [offSetY:Text y 위치]
 *  [E:Text 색상 ETreeItemTextType 값]
 *  [OneLine:t_bDrawOneLine 값]
 *  [bLineBreak:bLineBreak 값]
 */
function TreeInsertTextMultiNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, 
										optional int MaxHeight, optional ETreeItemTextType E, optional bool bLineBreak, optional int reserved, optional int reserved2 )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	if( MaxHeight == 0 ) MaxHeight = 38;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = false;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.t_nMaxHeight = MaxHeight;
	infNodeItem.t_vAlign = TVA_Middle;
	
	infNodeItem = setTreeTextColor( E, infNodeItem );

	if( reserved != 0 )
	{
		infNodeItem.nReserved = reserved;
	}
	
	infNodeItem.nReserved2 = 0;
	if( reserved2 > 0 )
	{
		infNodeItem.nReserved2 = reserved2;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}

/**
 *  트리 노드에 Text 아이템의 글씨 색상
 */
function XMLTreeNodeItemInfo setTreeTextColor( ETreeItemTextType E, XMLTreeNodeItemInfo infNodeItem )
{
	switch( E )
	{
		case ETreeItemTextType.COLOR_DEFAULT:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		
		case ETreeItemTextType.COLOR_GRAY:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.COLOR_GOLD:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_RED:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_YELLOW:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
	}
	return infNodeItem;
}

/**
 *  트리 노드에 Text 아이템 추가
 *  [TreeName:노드 추가할 Tree 네임:string]
 *  [NodeName:노드 네임:string]
 *  [TextureName:텍스쳐 이름:string]
 *  [TextureWidth:텍스쳐 넓이:int]
 *  [TextureHeight:텍스쳐 높이:int]
 *  [offSetX:Text x 위치]   
 *  [offSetY:Text y 위치]
 *  [OneLine:t_bDrawOneLine 값]
 *  [bLineBreak:bLineBreak 값]
 *  [TextureUHeight:TextureUHeight 값 ??? ]
 */
function TreeInsertTextureNodeItem( string TreeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offSetX, optional int offSetY, 
										optional bool OneLine, optional bool bLineBreak, optional int TextureUHeight )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = OneLine;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
} 

/**
 *  트리 노드에 Blank 아이템 추가 Insert Node Item - Blank::레시피 Tree에서 사용.
 *  [TreeName:노드 추가할 Tree 네임]
 *  [NodeName:노드 네임]
 */
function TreeInsertBlankNodeItem( string TreeName, string NodeName )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = 4;
	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}


function TreeClear( string str )
{
	class'UIAPI_TREECTRL'.static.Clear( str );
}

//** 선준 Code 추가 Tree용 Node, NodeItem에 관한 코드 END****************************************************************************************************************************************************






//** 선준 Code 추가 ToolTip에 관한 코드 *********************************************************************************************************************************************************************

/**
 *  툴팁 값 셋팅
 *  [T:셋팅 될 툴팁:CustomTooltip]
 */
function setCustomTooltip( CustomTooltip T )
{
	TooltipText = T;
}

function CustomTooltip getCustomTooltip()
{
	return TooltipText;
}

function ToopTipMinWidth( int width )
{
	TooltipText.MinimumWidth = width;
}

function ToopTipInsertText( string Text, optional bool OneLine, optional bool bLineBreak,optional ETooltipTextType E, optional int offSetX, optional int offSetY )
{
	if( Len( Text ) == 0 ) return;

	StartItem();
	TooltipInfo.eType = DIT_TEXT;
	TooltipInfo.t_bDrawOneLine = OneLine;
	TooltipInfo.bLineBreak = bLineBreak;
	TooltipInfo.t_strText = Text;
	TooltipInfo.nOffSetX = offSetX;
	TooltipInfo.nOffSetY = offSetY;
	TooltipInfo = setToopTipTextColor( E, TooltipInfo );
	EndItem();
}

/**
 *  툴팁에 Text 아이템의 글씨 색상
 */
function DrawItemInfo setToopTipTextColor( ETooltipTextType E, DrawItemInfo info )
{
	switch( E )
	{
		case ETooltipTextType.COLOR_DEFAULT:
			info.t_color.R = 255;
			info.t_color.G = 255;
			info.t_color.B = 255;
			info.t_color.A = 255;
			break;
		
		case ETooltipTextType.COLOR_GRAY:
			info.t_color.R = 163;
			info.t_color.G = 163;
			info.t_color.B = 163;
			info.t_color.A = 255;
			break;

		case ETooltipTextType.COLOR_GOLD:
			info.t_color.R = 176;
			info.t_color.G = 155;
			info.t_color.B = 121;
			info.t_color.A = 255;
			break;		
	}
	return info;
}

function TwoWordCombineColon( string word1, string word2, optional ETooltipTextType E1, optional ETooltipTextType E2, optional bool bLineBreak, optional int offSetX, optional int offSetY )
{
	ToopTipInsertText( word1, false, bLineBreak, E1, offSetX, offSetY );
	ToopTipInsertText( " : ", false, false, ETooltipTextType.COLOR_GRAY, offSetX, offSetY );
	ToopTipInsertText( word2, false, false, E2, offSetX, offSetY );

}

function ToopTipInsertTexture( string Texture, optional bool OneLine, optional bool bLineBreak, optional int offSetX, optional int offSetY )
{
	StartItem();
	TooltipInfo.eType = DIT_TEXTURE;
	TooltipInfo.t_bDrawOneLine = OneLine;
	TooltipInfo.bLineBreak = bLineBreak;
	TooltipInfo.u_nTextureWidth = 16;
	TooltipInfo.u_nTextureHeight = 16;
	TooltipInfo.nOffSetX = offSetX;
	TooltipInfo.nOffSetY = offSetY;
	TooltipInfo.u_nTextureUWidth = 32;
	TooltipInfo.u_nTextureUHeight = 32;

	TooltipInfo.u_strTexture = Texture;
	EndItem();
}

//빈공간의 TooltipItem을 추가한다.
function TooltipInsertItemBlank( int Height )
{
	StartItem();
	TooltipInfo.eType = DIT_BLANK;
	TooltipInfo.b_nHeight = Height;
	EndItem();
}

//빈공간의 TooltipItem을 추가한다.
function TooltipInsertItemLine()
{
	StartItem();
	TooltipInfo.eType = DIT_SPLITLINE;
	TooltipInfo.u_nTextureWidth = TooltipText.MinimumWidth;			
	TooltipInfo.u_nTextureHeight = 1;
	TooltipInfo.u_strTexture ="L2ui_ch3.tooltip_line";
	EndItem();
}

function StartItem()
{
	local DrawItemInfo infoClear;
	TooltipInfo = infoClear;
}

function EndItem()
{
	TooltipText.DrawList.Length = TooltipText.DrawList.Length + 1;
	TooltipText.DrawList[ TooltipText.DrawList.Length - 1 ] = TooltipInfo;
}

//**  선준 Code 추가 ToolTip에 관한 코드 END*****************************************************************************************************************************************************************



/**
 * 시간 --> XX : XX 으로 만듬.
 * 스케일 폼에서 사용하려 했으나 지금은 안됨..;;
 */
function String TimeNumberToString( int time )
{
	local int Min;
	local int Sec;
	
	local string strTime;
	local string SecString;

	Min = time / 60;
	Sec = time % 60;

	SecString = string( Sec );

	if(Sec < 10)
	{
		SecString = "0" $ string( Sec );
	}

	if( time > 60 )
	{
		strTime = "0" $string( Min ) $ ":" $ SecString;
	}
	else
	{
		strTime = "00:" $ SecString;
	}

	return strTime;
}

/**
 * 시간 --> XX시 XX분 으로 만듬.
 */
function String TimeNumberToHangulHourMin( int time )
{
	local int Hour;
	local int Min;
	local int Sec;	

	local string strMin;

	Min = time / 60;
	Hour = Min / 60;
	Min = Min % 60;
	Sec = time % 60;	

	strMin = string(Min);

	if( Min < 10 )
	{
		strMin = "0"$string(Min);
	}

	return MakeFullSystemMsg( GetSystemMessage(3304), string(Hour), strMin );
}


/**
 * Float 시간 + 초 만들어줌.
 */
function string MakeTimeString( float Time1, optional float Time2 )
{
	local int i;
	local float Time;
	local string strTime;
	local array<string>	arrSplit;
	
	if( Time2 != 0 )
	{
		Time = Time1+ Time2;		
	}
	else
	{
		Time = Time1;
	}

	strTime = string( Time );

	for( i = 0 ; i < Len(strTime) ; i++ )
	{
		if( Right( strTime, 1 ) == "0" )
		{
			strTime = Left( strTime, Len(strTime) - 1 );
			
		}
		else if( Right( strTime, 1 ) == "." )
		{
			break;
		}
	}		
	
	Split( strTime, ".", arrSplit);

	if( Len( arrSplit[1]) == 0 )
	{
		return arrSplit[0] $ GetSystemString(2001);
	}

	return strTime $ GetSystemString(2001);
}



function test(int a, int b, optional int x, optional string str)
{
	if (x == 0)
	{
		Debug("영이래!");
	}

	if (str =="")
	{
		Debug("스트링 꽝!");
	}
	
}



////////////////////////////////////////////
// 리스트 컨트롤 유틸
////////////////////////////////////////////

/**
 *  컨트롤 리스트에서 이름을 기준으로 검색하여 해당 인덱스를 리턴
 *  첫번째 헤더가 대부분 "이름" 이라 만든 유틸 -_-;
 **/ 
function int ctrlListSearchByName (ListCtrlHandle listCtrl, string name)
{
	// parse var
	local LVDataRecord record;
	local int i, nReturn;

	nReturn = -1;

	for (i = 0; i < listCtrl.GetRecordCount(); i++)
	{
		listCtrl.GetRec(i, record);
		if (record.LVDataList[0].szData == name)
		{
			nReturn = i;
			break;
		}
	}
	return nReturn;
}

/**
 *  현재 또는 이전에 선택되었던 친구 리스트의 값을 기준으로 Record 값을 리턴한다.
 **/
function LVDataRecord getListSelectedRecord(ListCtrlHandle list, int index)
{	
	local LVDataRecord record;

	list.SetSelectedIndex(index, true);
	list.GetRec(index, record);

	return record;
}

////////////////////////////////////////////
// int 형 배열 셔플 함수 
////////////////////////////////////////////
function arrayShuffleInt(out array<int> tempArray)
{
	local int i, ran;
	local array<int> changeArray;

	changeArray = tempArray;

	tempArray.Remove(0, tempArray.Length);

	for (i = 0; i < 10; i++)
	{
		ran = rand(changeArray.Length);
		
		tempArray[i] = changeArray[ran];
		changeArray.Remove(ran, 1);
	}
}
defaultproperties
{
}
