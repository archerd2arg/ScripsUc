class ProductInventoryHelpHtmlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle texBack;
var HtmlHandle htmlViewerProductInventoryHelp;

function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "ProductInventoryHelpHtmlWnd" );
	texBack = GetTextureHandle( "ProductInventoryHelpHtmlWnd.texBack" );
	htmlViewerProductInventoryHelp = GetHtmlHandle( "ProductInventoryHelpHtmlWnd.htmlViewerProductInventoryHelp" );
}

function OnShow()
{
	ShowHelp("..\\L2text\\product_inventory_help00.htm");
	//ShowHelp("..\\L2text\\event_2010_bless00_1.htm");
}

function Load()
{

}

function ShowHelp(string strPath)
{
	if (Len(strPath)>0)
	{		
		htmlViewerProductInventoryHelp.LoadHtml(strPath);

		Me.ShowWindow();
		Me.SetFocus();
	}			
}
defaultproperties
{
}
