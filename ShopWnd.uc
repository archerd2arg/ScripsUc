//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : ShopWnd  ( 상점 UC )
//
//------------------------------------------------------------------------------------------------------------------------

class ShopWnd extends UICommonAPI;


//------------------------------------------------------------------------------------------------------------------------
// const
//------------------------------------------------------------------------------------------------------------------------
const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW       = 333;

// 재매입 추가 by jin 2009.03.24.
const REFUND_ITEM = 444;

//------------------------------------------------------------------------------------------------------------------------
// Variables  
//------------------------------------------------------------------------------------------------------------------------
enum ShopType
{
	ShopNone,		// Invalid type
	ShopBuy,
	ShopSell,
	ShopPreview,
	// 재매입 추가 by jin 2009.03.18.
	ShopRefund,
};

var int		 m_merchantID;
var int		 m_npcID;				    // only for shoppreveiw
var bool	 m_isCompleteTransaction;
var INT64	 m_currentPrice;			// 구매/판매/재매입 목록에 올려놓은 아이템의 가격을 합산한 것
var INT64	 m_UserAdena;
var String   m_WindowName;			    // 상속에 사용하려고 윈도우 이름 추가 - lancelot 2006. 11. 27.

var ShopType m_LastShopType;
var ShopType m_shopType;

//------------------------------------------------------------------------------------------------------------------------
// Control Handle
//------------------------------------------------------------------------------------------------------------------------
var WindowHandle me;

// Tab Handle
var TabHandle m_TransactionTabHandle;
var TabHandle m_PreviewTabHandle;

// ItemWindow Handle
var ItemWindowHandle m_BuyTopListHandle;
var ItemWindowHandle m_SellTopListHandle;
var ItemWindowHandle m_RefundTopListHandle;

var ItemWindowHandle m_BuyBottomListHandle;
var ItemWindowHandle m_SellBottomListHandle;
var ItemWindowHandle m_RefundBottomListHandle;

var ItemWindowHandle m_PreviewTopListHandle;
var ItemWindowHandle m_PreviewBottomListHandle;

// Texture Handle
var TextureHandle m_TexTransactionBGLine;
var TextureHandle m_TexPreviewBGLine;

var TextureHandle m_TexRefundSlotBG;
var TextureHandle m_TexBuySellSlotBG;
var TextureHandle m_TexPreviewSlotBG;

// TextBox Handle
var TextBoxHandle m_PriceConstTextBoxHandle;
var TextBoxHandle m_PriceTextBoxHandle;
var TextBoxHandle m_AdenaTextBoxHandle;
var TextBoxHandle m_BottomTextBoxHandle;

// Button Handle
var ButtonHandle m_OkButtonHandle;

var ButtonHandle m_CancelButtonHandle;

var WindowHandle m_itemEnchantWndHandle;
var ItemEnchantWnd m_itemEnchantWndScript;

//------------------------------------------------------------------------------------------------------------------------
//
// Event Functions.
//
//------------------------------------------------------------------------------------------------------------------------

/** Desc : OnRegisterEvent  */
function OnRegisterEvent()
{
	registerEvent( EV_ShopOpenWindow );
	registerEvent( EV_ShopAddItem );
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );
	registerEvent( EV_OnEndTransactionList );
}

/** Desc : OnLoad  */
function OnLoad()
{
	OnRegisterEvent();

	me = GetWindowHandle("ShopWnd");

	m_TransactionTabHandle = GetTabHandle("ShopWnd.TransactionSelectTab");
	m_PreviewTabHandle = GetTabHandle("ShopWnd.PreviewSelectTab");

	m_BuyTopListHandle = GetItemWindowHandle("ShopWnd.BuyTopList");	
	m_SellTopListHandle = GetItemWindowHandle("ShopWnd.SellTopList");		
	m_RefundTopListHandle = GetItemWindowHandle("ShopWnd.RefundTopList");	
	m_BuyTopListHandle.SetTooltipType("InventoryPrice1HideEnchantStackable");
	m_SellTopListHandle.SetTooltipType("InventoryPrice2");	
	m_RefundTopListHandle.SetTooltipType("InventoryPrice1");

	m_BuyBottomListHandle = GetItemWindowHandle("ShopWnd.BuyBottomList");	
	m_SellBottomListHandle = GetItemWindowHandle("ShopWnd.SellBottomList");	
	m_RefundBottomListHandle = GetItemWindowHandle("ShopWnd.RefundBottomList");
	m_BuyBottomListHandle.SetTooltipType("InventoryPrice1");
	m_SellBottomListHandle.SetTooltipType("InventoryPrice2");
	m_RefundBottomListHandle.SetTooltipType("InventoryPrice1");

	m_PreviewTopListHandle = GetItemWindowHandle("ShopWnd.PreviewTopList");
	m_PreviewBottomListHandle = GetItemWindowHandle("ShopWnd.PreviewBottomList");

	m_TexTransactionBGLine = GetTextureHandle("ShopWnd.TransactionSelectTabBgLine");
	m_TexPreviewBGLine = GetTextureHandle("ShopWnd.Sell_TexTabBgLine");

	m_TexRefundSlotBG = GetTextureHandle("ShopWnd.RefundItemListBg");
	m_TexBuySellSlotBG = GetTextureHandle("ShopWnd.Buy_TopSlotListBg");	
	m_TexPreviewSlotBG = GetTextureHandle("ShopWnd.Sell_TopSlotListBg");

	m_PriceConstTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceConstText");
	m_PriceTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceText");
	m_AdenaTextBoxHandle = GetTextBoxHandle("ShopWnd.AdenaText");
	m_BottomTextBoxHandle = GetTextBoxHandle("ShopWnd.BottomText");

	m_OkButtonHandle = GetButtonHandle("ShopWnd.OKButton");
	m_CancelButtonHandle = GetButtonHandle("ShopWnd.CancelButton");

	m_isCompleteTransaction = false;
	m_LastShopType = ShopNone;

	m_itemEnchantWndHandle = GetWindowHandle("ItemEnchantWnd");
	m_itemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	
}

/** Desc : OnEvent  */
function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
	case EV_ShopOpenWindow:
		// 상품 인벤토리가 열려 있다면 열지 않는다.
		if (!GetWindowHandle("ProductInventoryWnd").IsShowWindow())	HandleOpenWindow(param);
		break;
	case EV_ShopAddItem:
		HandleAddItem(param);
		break;
	case EV_DialogOK:
		setEnableWindow(true);
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		setEnableWindow(true);
		break;
	case EV_OnEndTransactionList:
		HandleEndTransactionList(param);
		break;
	default:
		break;
	}
}

/** Desc : OnClickButton  */
function OnClickButton(string ControlName)
{
	local int index;
	local int bottomIndex;
	local int topIndex;
	local ItemInfo deleteItemInfo;
	local ItemInfo addItemInfo;

	if(ControlName == "UpButton")
	{
		if(m_shopType == ShopBuy)
			index = m_BuyBottomListHandle.GetSelectedNum();
		else if(m_shopType == ShopSell)
			index = m_SellBottomListHandle.GetSelectedNum();
		else if(m_shopType == ShopRefund)
			index = m_RefundBottomListHandle.GetSelectedNum();
		else
			index = m_PreviewBottomListHandle.GetSelectedNum();

		MoveItemBottomToTop(index, false);
	}
	else if(ControlName == "DownButton")
	{
		if(m_shopType == ShopBuy)
			index = m_BuyTopListHandle.GetSelectedNum();
		else if(m_shopType == ShopSell)
			index = m_SellTopListHandle.GetSelectedNum();
		else if(m_shopType == ShopRefund)
			index = m_RefundTopListHandle.GetSelectedNum();
		else
			index = m_PreviewTopListHandle.GetSelectedNum();

		MoveItemTopToBottom(index, false);
	}
	else if(ControlName == "OKButton")
	{
		setEnableWindow(true);
		HandleOKButton();
	}
	else if(ControlName == "CancelButton")
	{		
		setEnableWindow(true);
		HideWindow(m_WindowName);
	}
	// 재매입 추가 by jin 2009.03.20.
	else if(ControlName == "TransactionSelectTab0")	// 구매
	{
		if(m_shopType == ShopBuy)
			return;
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_SellBottomListHandle.GetItem(index, deleteItemInfo);
					if(IsStackableItem(deleteItemInfo.ConsumeType))
					{
						topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.ID);
						m_SellTopListHandle.GetItem(topIndex, addItemInfo);
						if(topIndex >= 0)
						{
							addItemInfo.ItemNum += deleteItemInfo.ItemNum;
							m_SellTopListHandle.SetItem(topIndex, addItemInfo);
						}
						else
							m_SellTopListHandle.AddItem(deleteItemInfo);
					}
					else
						m_SellTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}
		else if(m_shopType == ShopRefund)
		{
			bottomIndex = m_RefundBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_RefundBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
					m_RefundTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_SellBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [구매]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [구매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [구매액]

		m_shopType = ShopBuy;
	}
	else if(ControlName == "TransactionSelectTab1")	// 판매
	{
		if(m_shopType == ShopSell)
			return;
		else if(m_shopType == ShopBuy)
		{
			bottomIndex = m_BuyBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_BuyBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
				}
			}
		}
		else if(m_shopType == ShopRefund)
		{
			bottomIndex = m_RefundBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_RefundBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
					m_RefundTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_BuyBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.ShowWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.ShowWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1157));	// text : [판매]
		m_BottomTextBoxHandle.SetText(GetSystemString(137));	// text : [판매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(143));// text : [판매액]

		m_shopType = ShopSell;
		
	}
	else if(ControlName == "TransactionSelectTab2")	// 재구매
	{
		if(m_shopType == ShopRefund)
			return;
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_SellBottomListHandle.GetItem(index, deleteItemInfo);
					if(IsStackableItem(deleteItemInfo.ConsumeType))
					{
						topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.ID);
						m_SellTopListHandle.GetItem(topIndex, addItemInfo);
						if(topIndex >= 0)
						{
							addItemInfo.ItemNum += deleteItemInfo.ItemNum;
							m_SellTopListHandle.SetItem(topIndex, addItemInfo);
						}
						else
							m_SellTopListHandle.AddItem(deleteItemInfo);
					}
					else
						m_SellTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}
		else if(m_shopType == ShopBuy)
		{
			bottomIndex = m_BuyBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_BuyBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_BuyBottomListHandle.Clear();
		m_SellBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.HideWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.ShowWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.ShowWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(2028));	// text : [재구매]
		m_BottomTextBoxHandle.SetText(GetSystemString(2205));	// text : [재구매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));// text : [재구매액]

		m_shopType = ShopRefund;
	}
}

/** Desc: 아이템을 더블 클릭 했을때 */
function OnDBClickItem(string ControlName, int index)
{
	if(ControlName == "BuyTopList" || ControlName == "RefundTopList" || ControlName == "SellTopList" || ControlName == "PreviewTopList")
	{		
		MoveItemTopToBottom(index, false);
	}
	else if(ControlName == "BuyBottomList" || ControlName == "RefundBottomList" || ControlName == "SellBottomList" || ControlName == "PreviewBottomList")
	{
		MoveItemBottomToTop(index, false);
	}
}

/** Desc: 아이템을 드래그 드랍 했을때 */
function OnDropItem(string strID, ItemInfo info, int x, int y)
{
	local int index;
	//debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	if(m_shopType == ShopBuy)
	{
		if(strID == "BuyTopList" && info.DragSrcName == "BuyBottomList")
		{
			index = m_BuyBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "BuyBottomList" && info.DragSrcName == "BuyTopList")
		{
			index = m_BuyTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopSell)
	{
		if(strID == "SellTopList" && info.DragSrcName == "SellBottomList")
		{
			index = m_SellBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "SellBottomList" && info.DragSrcName == "SellTopList")
		{
			index = m_SellTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopRefund)
	{
		if(strID == "RefundTopList" && info.DragSrcName == "RefundBottomList")
		{
			index = m_RefundBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "RefundBottomList" && info.DragSrcName == "RefundTopList")
		{
			index = m_RefundTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopPreview)
	{
		if(strID == "PreviewTopList" && info.DragSrcName == "PreviewBottomList")
		{
			index = m_PreviewBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "PreviewBottomList" && info.DragSrcName == "PreviewTopList")
		{
			index = m_PreviewTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
}


//------------------------------------------------------------------------------------------------------------------------
//
// General Functions.
//
//------------------------------------------------------------------------------------------------------------------------

/** Desc : OnHide  */
function OnHide()
{
	m_LastShopType = ShopNone;

	if(m_shopType != ShopPreview)
		RequestBuySellUIClose();
	Clear();
	m_isCompleteTransaction = false;

	m_itemEnchantWndScript.SetIsShopping(false);
}

/** Desc : Clear  */
function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	m_currentPrice = IntToInt64(0);

	m_BuyTopListHandle.Clear();
	m_SellTopListHandle.Clear();
	m_RefundTopListHandle.Clear();

	m_BuyBottomListHandle.Clear();
	m_SellBottomListHandle.Clear();
	m_RefundBottomListHandle.Clear();

	m_PreviewTopListHandle.Clear();
	m_PreviewBottomListHandle.Clear();

	m_PriceTextBoxHandle.SetText("0");
	m_PriceTextBoxHandle.SetTooltipString("");

	m_AdenaTextBoxHandle.SetText("0");
	m_AdenaTextBoxHandle.SetTooltipString("");

	class'UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName$".InvenWeight");

	m_TransactionTabHandle.InitTabCtrl();
	//m_isCompleteTransaction = false;
}

/** Desc: 아이템인벤에서 위에서 아래로 이동 */
function MoveItemTopToBottom(int index, bool bAllItem)
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;

	if (index < 0) 
		return;

	if(m_shopType == ShopBuy)
		m_BuyTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopSell)
		m_SellTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopRefund)
		m_RefundTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopPreview)
		m_PreviewTopListHandle.GetItem(index, info);

	if(!bAllItem && IsStackableItem(info.ConsumeType) && (info.ItemNum!=IntToInt64(1)) && (m_shopType != ShopRefund))		// stackable?
	{
		setEnableWindow(false);
		DialogSetID(DIALOG_TOP_TO_BOTTOM);
		DialogSetReservedItemID(info.ID);
		DialogSetDefaultOK();
		if(m_shopType == ShopSell)
			DialogSetParamInt64(info.ItemNum);
		else
			DialogSetParamInt64(IntToInt64(-1));
		
		DialogSetDefaultOK();	
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), info.Name, ""));
	}
	else
	{
		info.bShowCount = false;

		if(m_shopType == ShopBuy)
		{
			info.ItemNum = IntToInt64(1);	// 상점 구매의 경우 ItemNum이 세팅 되어 있지 않은 경우가 있기 때문에 일부러 1로 해 줘야한다.
			
			m_BuyBottomListHandle.AddItem(info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.FindItem(info.ID);	// ClassID
			if(bottomIndex >= 0 && IsStackableItem(info.ConsumeType))
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				bottomInfo.ItemNum += info.ItemNum;
				m_SellBottomListHandle.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				m_SellBottomListHandle.AddItem(info);
			}
			m_SellTopListHandle.DeleteItem(index);	// 물건을 팔 경우 자신의 인벤토리 목록에서 아이템을 제거
		}
		else if( m_shopType == ShopRefund )	// 재매입 추가 by jin 2009.03.18.
		{
			info.Reserved = REFUND_ITEM;	// 재매입 아이템임을 표시하는 플래그를 사용하지 않는 속성인 info.Reserved 속성에 저장한다.
			m_RefundTopListHandle.DeleteItem(index);
			m_RefundBottomListHandle.AddItem(info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if( m_shopType == ShopPreview )
		{
			bottomIndex = m_PreviewBottomListHandle.FindItem(info.ID);	// ClassID
			info.ItemNum = IntToInt64(1);
			m_PreviewBottomListHandle.AddItem(info);
		}

		if(info.Reserved != REFUND_ITEM)
			AddPrice(info.Price * info.ItemNum);
		else
			AddPrice(info.Price);
	}
}

/** Desc: 아이템인벤에서 아래로 위로 이동 */
function MoveItemBottomToTop(int index, bool bAllItem)
{
	local ItemInfo info, info2;
	local int bottomIndex;

	if (index < 0) 
		return;

	if(m_shopType == ShopBuy)
		m_BuyBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopSell)
		m_SellBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopRefund)
		m_RefundBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopPreview)
		m_PreviewBottomListHandle.GetItem(index, info);

	
	if(!bAllItem && IsStackableItem(info.ConsumeType) && (info.ItemNum!=IntToInt64(1)) && (info.Reserved!=REFUND_ITEM))	// stackable?
	{
		setEnableWindow(false);
		DialogSetID(DIALOG_BOTTOM_TO_TOP);
		DialogSetDefaultOK();
		DialogSetReservedItemID(info.ID);
		DialogSetParamInt64(info.ItemNum);
		DialogSetDefaultOK();	
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), info.Name, ""));
	}
	else
	{
		if(m_shopType == ShopBuy)
		{
			m_BuyBottomListHandle.DeleteItem(index);

			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopSell)
		{
			m_SellBottomListHandle.DeleteItem(index);

			bottomIndex = m_SellTopListHandle.FindItem(info.ID);	// ServerID
			if(bottomIndex == -1)
				m_SellTopListHandle.AddItem(info);	// 물건을 판매하는 경우 다시 자신의 인벤토리 목록으로
			else
			{
				m_SellTopListHandle.GetItem(bottomIndex, info2);
				info2.ItemNum += info.ItemNum;
				m_SellTopListHandle.SetItem(bottomIndex, info2);
			}
		}
		else if(m_shopType == ShopRefund)
		{
			m_RefundBottomListHandle.DeleteItem(index);

			if(info.Reserved == REFUND_ITEM)	// 아이템이 재매입 된 아이템이라면 RefundItemList로 돌려보낸다.
				m_RefundTopListHandle.AddItem(info);

			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopPreview)
		{
			m_PreviewBottomListHandle.DeleteItem(index);
		}

		if(info.Reserved != REFUND_ITEM)
			AddPrice(-info.Price * info.ItemNum);
		else
			AddPrice(-info.Price);
	}
}

/** Desc: 다이얼로그 박스에서 ok를 누른 경우 */
function HandleDialogOK()
{
	local int id, index, topIndex;
	local INT64 num;
	local ItemInfo info, topInfo;
	local string param;
	local ItemID cID;

	// 현재 다이얼로그 가 열려 있나? 있으면..
	if(DialogIsMine())
	{
		id = DialogGetID();
		num = StringToInt64( DialogGetString() );
		cID = DialogGetReservedItemID();
		if(id == DIALOG_TOP_TO_BOTTOM && num > IntToInt64(0))
		{
			// Refund상태일 때 DialogOK를 호출 할 일은 없지만 차후를 대비하여 일단 추가해 놓는다.
			if(m_shopType == ShopBuy)
				topIndex = m_BuyTopListHandle.FindItem(cID);
			else if(m_shopType == ShopSell)
				topIndex = m_SellTopListHandle.FindItem(cID);
			else if(m_shopType == ShopRefund)
				topIndex = m_RefundTopListHandle.FindItem(cID);
			else if(m_shopType == ShopPreview)
				topIndex = m_PreviewTopListHandle.FindItem(cID);

			if(topIndex >= 0)
			{
				if(m_shopType == ShopBuy)
				{
					m_BuyTopListHandle.GetItem(topIndex, topInfo);

					index = m_BuyBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_BuyBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_BuyBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_BuyBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}

					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num);
				}
				else if(m_shopType == ShopSell)
				{
					m_SellTopListHandle.GetItem(topIndex, topInfo);

					// 다이얼로그에서 엉뚱한 숫자 입력하는 것 방지.
					if(topInfo.ItemNum < num)
						num = topInfo.ItemNum;

					// BottomList에 아이템 추가 (장바구니에 담기)
					index = m_SellBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_SellBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_SellBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_SellBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}

					// TopList에서 아이템 감소, 삭제
					topInfo.ItemNum -= num;
					if( topInfo.ItemNum <= IntToInt64(0) )
						m_SellTopListHandle.DeleteItem(topIndex);
					else
						m_SellTopListHandle.SetItem(topIndex, topInfo);
				}
				// 재구매시에는 갯수 다이얼로그 박스가 뜰 일이 없다.
				else if(m_shopType == ShopPreview)
				{
					m_PreviewTopListHandle.GetItem(topIndex, topInfo);

					index = m_PreviewBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_PreviewBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_PreviewBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_PreviewBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}
				}
			}
		}
		else if(id == DIALOG_BOTTOM_TO_TOP && num > IntToInt64(0))
		{
			if(m_shopType == ShopBuy)
				index = m_BuyBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopSell)
				index = m_SellBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopRefund)
				index = m_RefundBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopPreview)
				index = m_PreviewBottomListHandle.GetSelectedNum();

			if(index >= 0)
			{
				if(m_shopType == ShopBuy)
				{
					m_BuyBottomListHandle.GetItem(index, info);

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_BuyBottomListHandle.SetItem(index, info);
					else 
						m_BuyBottomListHandle.DeleteItem(index);

					class'UIAPI_INVENWEIGHT'.static.ReduceWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num );

					if(info.ItemNum <= IntToInt64(0))	// 가격이 음수가 되는 일을 방지하기 위해
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);
				}
				else if(m_shopType == ShopSell)
				{
					m_SellBottomListHandle.GetItem(index, info);

					if(info.ItemNum < num)
						num = info.ItemNum;

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_SellBottomListHandle.SetItem(index, info);
					else 
						m_SellBottomListHandle.DeleteItem(index);

					topIndex = m_SellTopListHandle.FindItem(cID);
					if(topIndex >=0 && IsStackableItem(info.ConsumeType))
					{
						m_SellTopListHandle.GetItem(topIndex, topInfo);
						topInfo.ItemNum += num;
						m_SellTopListHandle.SetItem(topIndex, topInfo);
					}
					else
					{
						info.ItemNum = num;
						m_SellTopListHandle.AddItem(info);
					}

					if(info.ItemNum <= IntToInt64(0))	// 가격이 음수가 되는 일을 방지하기 위해
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);		
				}
				else if(m_shopType == ShopPreview)
				{
					m_PreviewBottomListHandle.GetItem(index, info);

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_PreviewBottomListHandle.SetItem(index, info);
					else 
						m_PreviewBottomListHandle.DeleteItem(index);

					if(info.ItemNum <= IntToInt64(0))	// 가격이 음수가 되는 일을 방지하기 위해
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);
				}
			}
		}
		else if(id == DIALOG_PREVIEW)
		{
			num = IntToInt64(m_PreviewBottomListHandle.GetItemNum());

			if(num > IntToInt64(0))
			{
				// pack every item in BottomList
				ParamAdd(param, "merchant", string(m_merchantID));
				ParamAdd(param, "npc", string(m_npcID));
				ParamAddINT64(param, "num", num);
				for(index = 0; index < Int64ToInt(num); ++index)
				{
					m_PreviewBottomListHandle.GetItem(index, info);
					ParamAddItemIDWithIndex(param, info.ID, index);
				}

				RequestPreviewItem( param );
				HideWindow(m_WindowName);
			}
		}
	}
}

/** Desc : 윈도우가 열릴때 처리 */
function HandleOpenWindow(string param)
{
	local string type;
	local INT64 adena;
	local string adenaString;
	local WindowHandle m_inventoryWnd;

	ParseString(param, "type", type);
	if(type == "buy")
	{
		Clear();
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
		if(m_inventoryWnd.IsShowWindow())	// close the inventory window
			m_inventoryWnd.HideWindow();

		ParseInt(param, "merchant", m_merchantID); 

		ParseINT64(param, "adena", adena);	
		adenaString = MakeCostStringInt64(adena);
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(Int64ToString(adena)));

		m_UserAdena = adena;

		ShowWindow( m_WindowName );
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		m_shopType = ShopBuy;	// 통합 상점에서 가장 첫 shop type은 [구매]이다. 차후 누르는 탭에 따라 변화.
	}
	else if(type == "sell")
	{
		m_shopType = ShopSell;
	}
	else if(type == "refund")
	{
		m_shopType = ShopRefund;
	}
	else if(type == "preview")
	{
		Clear();
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
		if(m_inventoryWnd.IsShowWindow())	// close the inventory window
			m_inventoryWnd.HideWindow();

		ParseInt(param, "merchant", m_merchantID); 

		ParseINT64(param, "adena", adena);	
		adenaString = MakeCostStringInt64(adena);
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(Int64ToString(adena)));

		ShowWindow( m_WindowName );
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		m_shopType = ShopPreview;
	}
	else
		m_shopType = ShopNone;

	if(m_shopType == ShopBuy)
	{
		m_TexTransactionBGLine.ShowWindow();
		m_TexPreviewBGLine.HideWindow();
		m_TexRefundSlotBG.HideWindow();
		m_TexBuySellSlotBG.ShowWindow();
		m_TexPreviewSlotBG.HideWindow();

		m_TransactionTabHandle.ShowWindow();
		m_PreviewTabHandle.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();
		m_PreviewTopListHandle.HideWindow();		

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();
		m_PreviewBottomListHandle.HideWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [구매]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [구입목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [구매액]
	}
	else if(m_shopType == ShopPreview)
	{
		ParseInt(param, "npc", m_npcID);

		m_TexTransactionBGLine.HideWindow();
		m_TexPreviewBGLine.ShowWindow();
		m_TexRefundSlotBG.HideWindow();
		m_TexBuySellSlotBG.HideWindow();
		m_TexPreviewSlotBG.ShowWindow();

		m_TransactionTabHandle.HideWindow();
		m_PreviewTabHandle.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();
		m_PreviewTopListHandle.ShowWindow();		

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();
		m_PreviewBottomListHandle.ShowWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1337));	// text : [확인]
		m_BottomTextBoxHandle.SetText(GetSystemString(812));	// text : [선택 목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(813));// text : [비용]
	}

	if(m_itemEnchantWndHandle.IsShowWindow())
	{
		m_itemEnchantWndScript.OnClickButton("ExitBtn");
	}
	m_itemEnchantWndScript.SetIsShopping(true);
}

/** Desc : HandleAddItem */
function HandleAddItem(string param)
{
	local ItemInfo info;
	
	ParamToItemInfo(param, info);
	if(m_shopType == ShopBuy && info.ItemNum > IntToInt64(0))
		info.bShowCount = true;

	if(m_shopType == ShopBuy)
		m_BuyTopListHandle.AddItem(info);
	else if(m_shopType == ShopSell)
		m_SellTopListHandle.AddItem(info);
	else if(m_shopType == ShopRefund)
		m_RefundTopListHandle.AddItem(info);
	else if(m_shopType == ShopPreview)
		m_PreviewTopListHandle.AddItem(info);
}

/** Desc : AddPrice */
function AddPrice( INT64 price )
{
	local string adena;
	
	m_currentPrice = m_currentPrice + price;
	
	adena = MakeCostStringInt64( m_currentPrice );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".PriceText", adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".PriceText", ConvertNumToText(Int64ToString(m_currentPrice)));
}

/** Desc : HandleOKButton */
function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local INT64		limitedItemCount;
	//local int		buyCount, refundCount, indexForDisassemble;

	if(m_isCompleteTransaction)
		return;

	m_LastShopType = m_shopType;

	// 구매 상태에서 예외처리
	if(m_shopType == ShopBuy)
	{
		topCount = m_BuyTopListHandle.GetItemNum();

		for(topIndex = 0; topIndex < topCount; ++topIndex)
		{
			m_BuyTopListHandle.GetItem(topIndex, topInfo);
			if(topInfo.ItemNum > IntToInt64(0))		// this item can be purchased only by limited number
			{
				limitedItemCount = IntToInt64(0);
				// search in BottomList for same classID
				bottomCount = m_BuyBottomListHandle.GetItemNum();
				for(bottomIndex=0; bottomIndex < bottomCount; ++bottomIndex)	// match found, then check whether the number exceeds limited number
				{
					m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
					if(IsSameClassID(bottomInfo.ID, topInfo.ID))
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if(limitedItemCount > topInfo.ItemNum)
				{
					// warning dialog
					DialogShow(DIALOG_Modalless, DIALOG_WARNING, GetSystemMessage(1338));
					return;
				}
			}
		}

		if(m_currentPrice > m_UserAdena)
		{
			DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(279));
			m_isCompleteTransaction = false;
			return;
		}
	}

	// 예외 이후, 실제 처리
	if(m_shopType == ShopBuy)
	{
		bottomCount = m_BuyBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);

				ParamAdd(param, "ClassID_" $ bottomIndex, string(bottomInfo.ID.ClassID));
				ParamAddInt64(param, "Count_" $ bottomIndex, bottomInfo.ItemNum);
			}

			RequestBuyItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopSell)
	{
		bottomCount = m_SellBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAddItemIDWithIndex(param, bottomInfo.ID, bottomIndex);
				ParamAddInt64(param, "Count_" $ bottomIndex, bottomInfo.ItemNum);
			}

			RequestSellItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopRefund)
	{
		bottomCount = m_RefundBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_RefundBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAdd(param, "index_" $ bottomIndex, string(bottomInfo.ID.ServerID));
			}

			RequestRefundItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopPreview)
	{
		bottomCount = m_PreviewBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			DialogSetID(DIALOG_PREVIEW);
			DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1157));
		}	

		//HideWindow(m_WindowName);
	}
}

/** Desc : HandleEndTransactionList */
function HandleEndTransactionList(string param)
{
	local int WindowOpenType;

	ParseInt(param, "type", WindowOpenType); 

	if(m_LastShopType == ShopSell)
	{
		m_TransactionTabHandle.SetTopOrder(1, false);
		m_shopType = ShopSell;

		m_BuyBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.ShowWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.ShowWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1157));	// text : [판매]
		m_BottomTextBoxHandle.SetText(GetSystemString(137));	// text : [판매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(143));// text : [판매액]
	}
	else if(m_LastShopType == ShopRefund)
	{
		m_TransactionTabHandle.SetTopOrder(2, false);
		m_shopType = ShopRefund;

		m_BuyBottomListHandle.Clear();
		m_SellBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.HideWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.ShowWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.ShowWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(2028));	// text : [재구매]
		m_BottomTextBoxHandle.SetText(GetSystemString(2205));	// text : [재구매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));// text : [재구매액]
	}	
	else
		m_shopType = ShopBuy;

	if(WindowOpenType == 0)
	{
		m_TransactionTabHandle.SetTopOrder(0, false);
		m_shopType = ShopBuy;

		m_SellBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [구매]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [구매목록]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [구매액]	
	}
	else if(WindowOpenType == 2)
	{
		DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(279));
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 3)
	{
		DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(352));
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 1 && m_isCompleteTransaction)
	{
		//Debug("==========================================");
		//Debug("system message : " @ GetSystemMessage(3092)); : 시스템메시지가 제대로 나오는지 확인 완료

		//DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(3092));
		
		// 구매가 완료 되었다는 메세지를 뿌려준다.
		AddSystemMessage(3092);		

		m_isCompleteTransaction = false;

		// 구매 윈도우를 닫는다. 
		HideWindow(m_WindowName);	

	}
}

/** Desc: ?재 윈도우를 활성화 비활성화 시킨다. */
function setEnableWindow(bool flag)
{
	if (flag)
	{
		me.EnableWindow();
	}
	else
	{
		me.DisableWindow();
	}
}


defaultproperties
{
    m_WindowName="ShopWnd"
}
