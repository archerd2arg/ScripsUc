/**
 *   UI ���� ���� �Լ�  
 **/
class L2Util extends UICommonAPI;

/*
   ex) 
   var L2Util util;
   util = L2Util(GetScript("L2Util"));
*/

// Į��
var Color White;
var Color Yellow;
var Color Blue;
var Color BrightWhite;
var Color Gold;

/**
 *  Tree �� **************************************************************************************************************
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
 *  ToopTip �� ***********************************************************************************************************
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
 *  Į�� ���� ���� 
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
 * ��ư�� �ؽ�Ʈ�� �����Ѵ�. �̶� �ý��۽�Ʈ���� �ε����� �־� �ؽ�Ʈ�� �����Ѵ�
 * 
 * @param
 * controlPath   : xml ��Ʈ�� ���
 * texturePath   : ��Ű¡ �� �ؽ��� ���
 * playLoopCount : ����Ǵ� ���� ī��Ʈ 
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
 * //Root ��� ����.
 * util.TreeInsertRootNode( TREENAME, ROOTNAME, "", 0, 4 );
 * //+��ư �ִ� ���� ��� ����
 * util.TreeInsertExpandBtnNode( TREENAME, "LIST1", ROOTNAME );
 * //���� ��忡 �۾� ������ �߰�
 * util.TreeInsertTextNodeItem( TREENAME, ROOTNAME$"."$"LIST1", GetSystemString(2370), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );
 * 
 * //������ ��� �����(�ִ³�)
 * util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14 );
 * //������ ��� �����(���³�)
 * util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 257, 38 );
 * ������ �����..�Ʒ�.
	//Insert Node Item - �����۽��� ���
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2 );
	//Insert Node Item - ������ ������
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );
	//Insert Node Item - ������ �̸�
	util.TreeInsertTextNodeItem( TREENAME, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
	//Insert Node Item - "Lv"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString(88),46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );
	//Insert Node Item - ���� ��
	util.TreeInsertTextNodeItem( TREENAME, strRetName, string(iLevel), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD );
	//Insert Node Item - MP���� ������ ( �Ҹ��� )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test ��"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "630", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
	//Insert Node Item - �ð� ������ ( �����ð� )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test ��"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "2��", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
	//Insert Node Item - �ð� ������ ( ����ð� )
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
	//Insert Node Item - "Test ��"
	util.TreeInsertTextNodeItem( TREENAME, strRetName, "2��", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
 */

//** ���� Code �߰� Tree�� Node, NodeItem�� ���� �ڵ� *******************************************************************************************************************************************************

/**
 *  Ʈ�� ROOT ��� �߰�  
 *  [TreeName:��� �߰��� Tree ����:string]   
 *  [NodeName:��� ����:string]    
 *  [ParentName:�߰��� ����� ���� ���:string]  
 *  [offSetX:��� x ��ġ:optional int]   
 *  [offSetY:��� y ��ġ:optional int]
 */
function TreeInsertRootNode( string TreeName, string NodeName, string ParentName, optional int offSetX, optional int offSetY )
{
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;
	
	infNode.strName = NodeName;	
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;

	class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/**
 *  Ʈ�� Expand ��ư ��� �߰�
 *  [TreeName:��� �߰��� Tree ����:string]
 *  [NodeName:��� ����:string]
 *  [ParentName:�߰��� ����� ���� ���:string]
 *  [nTexBtnWidth:Expand��ư ����:int]
 *  [nTexBtnHeight:Expand��ư ����:int]
 *  [strTexBtnExpand:Tree������ư �ؽ���:optional string]
 *  [strTexBtnExpand_Over:Tree������ư ���� �ؽ���:optional string]
 *  [strTexBtnCollapse:Tree������ư �ؽ���:optional string]
 *  [strTexBtnCollapse_Over:Tree������ư ���� �ؽ���:optional string]
 *  [offSetX:��� x ��ġ:optional int]   
 *  [offSetY:��� y ��ġ:optional int]
 */
function TreeInsertExpandBtnNode( string TreeName, string NodeName, string ParentName, optional int nTexBtnWidth, optional int nTexBtnHeight, 
									optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over,
									optional int offSetX, optional int offSetY )
{
	//Ʈ�� ��� ����
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
 *  Ʈ�� ITEM ��� �߰�
 *  [TreeName:��� �߰��� Tree ����:string]
 *  [NodeName:��� ����:string]
 *  [ParentName:�߰��� ����� ���� ���:string]
 *  [nTexBtnWidth:Expand��ư ����:int]
 *  [nTexBtnHeight:Expand��ư ����:int]
 *  [strTexBtnExpand:Tree������ư �ؽ���:optional string]
 *  [strTexBtnExpand_Over:Tree������ư ���� �ؽ���:optional string]
 *  [strTexBtnCollapse:Tree������ư �ؽ���:optional string]
 *  [strTexBtnCollapse_Over:Tree������ư ���� �ؽ���:optional string]
 *  [offSetX:��� x ��ġ:optional int]   
 *  [offSetY:��� y ��ġ:optional int]
 */
function string TreeInsertItemTooltipSimpleNode( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;
	
	if( TooltipSimpleText != "" ) infNode.Tooltip = MakeTooltipSimpleText( TooltipSimpleText );
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
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
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;	
	
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
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
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = bFollowCursor;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/**
 *  Ʈ�� ��忡 Text ������ �߰�
 *  [TreeName:��� �߰��� Tree ����]
 *  [NodeName:��� ����]
 *  [ItemName:Text�� �߰��� ����]
 *  [offSetX:Text x ��ġ]   
 *  [offSetY:Text y ��ġ]
 *  [E:Text ���� ETreeItemTextType ��]
 *  [OneLine:t_bDrawOneLine ��]
 *  [bLineBreak:bLineBreak ��]
 */
function TreeInsertTextNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, optional ETreeItemTextType E, 
									optional bool OneLine, optional bool bLineBreak, optional int reserved )
{
	//Ʈ�� �������� ����
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
 *  Ʈ�� ��忡 Text ������ �߰�
 *  [TreeName:��� �߰��� Tree ����]
 *  [NodeName:��� ����]
 *  [ItemName:Text�� �߰��� ����]
 *  [offSetX:Text x ��ġ]   
 *  [offSetY:Text y ��ġ]
 *  [E:Text ���� ETreeItemTextType ��]
 *  [OneLine:t_bDrawOneLine ��]
 *  [bLineBreak:bLineBreak ��]
 */
function TreeInsertTextMultiNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, 
										optional int MaxHeight, optional ETreeItemTextType E, optional bool bLineBreak, optional int reserved, optional int reserved2 )
{
	//Ʈ�� �������� ����
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
 *  Ʈ�� ��忡 Text �������� �۾� ����
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
 *  Ʈ�� ��忡 Text ������ �߰�
 *  [TreeName:��� �߰��� Tree ����:string]
 *  [NodeName:��� ����:string]
 *  [TextureName:�ؽ��� �̸�:string]
 *  [TextureWidth:�ؽ��� ����:int]
 *  [TextureHeight:�ؽ��� ����:int]
 *  [offSetX:Text x ��ġ]   
 *  [offSetY:Text y ��ġ]
 *  [OneLine:t_bDrawOneLine ��]
 *  [bLineBreak:bLineBreak ��]
 *  [TextureUHeight:TextureUHeight �� ??? ]
 */
function TreeInsertTextureNodeItem( string TreeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offSetX, optional int offSetY, 
										optional bool OneLine, optional bool bLineBreak, optional int TextureUHeight )
{
	//Ʈ�� �������� ����
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
 *  Ʈ�� ��忡 Blank ������ �߰� Insert Node Item - Blank::������ Tree���� ���.
 *  [TreeName:��� �߰��� Tree ����]
 *  [NodeName:��� ����]
 */
function TreeInsertBlankNodeItem( string TreeName, string NodeName )
{
	//Ʈ�� �������� ����
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

//** ���� Code �߰� Tree�� Node, NodeItem�� ���� �ڵ� END****************************************************************************************************************************************************






//** ���� Code �߰� ToolTip�� ���� �ڵ� *********************************************************************************************************************************************************************

/**
 *  ���� �� ����
 *  [T:���� �� ����:CustomTooltip]
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
 *  ������ Text �������� �۾� ����
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

//������� TooltipItem�� �߰��Ѵ�.
function TooltipInsertItemBlank( int Height )
{
	StartItem();
	TooltipInfo.eType = DIT_BLANK;
	TooltipInfo.b_nHeight = Height;
	EndItem();
}

//������� TooltipItem�� �߰��Ѵ�.
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

//**  ���� Code �߰� ToolTip�� ���� �ڵ� END*****************************************************************************************************************************************************************



/**
 * �ð� --> XX : XX ���� ����.
 * ������ ������ ����Ϸ� ������ ������ �ȵ�..;;
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
 * �ð� --> XX�� XX�� ���� ����.
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
 * Float �ð� + �� �������.
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
		Debug("���̷�!");
	}

	if (str =="")
	{
		Debug("��Ʈ�� ��!");
	}
	
}



////////////////////////////////////////////
// ����Ʈ ��Ʈ�� ��ƿ
////////////////////////////////////////////

/**
 *  ��Ʈ�� ����Ʈ���� �̸��� �������� �˻��Ͽ� �ش� �ε����� ����
 *  ù��° ����� ��κ� "�̸�" �̶� ���� ��ƿ -_-;
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
 *  ���� �Ǵ� ������ ���õǾ��� ģ�� ����Ʈ�� ���� �������� Record ���� �����Ѵ�.
 **/
function LVDataRecord getListSelectedRecord(ListCtrlHandle list, int index)
{	
	local LVDataRecord record;

	list.SetSelectedIndex(index, true);
	list.GetRec(index, record);

	return record;
}

////////////////////////////////////////////
// int �� �迭 ���� �Լ� 
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
