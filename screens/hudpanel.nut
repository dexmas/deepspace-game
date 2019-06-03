class CHUDPanel extends CNode2D
{
	pPanel = null;
	pENText = null;
	pDMText = null;
	
	constructor()
	{
		base.constructor();
		
		pPanel = ::CPanel(::Game.ScreenWidth, 50, ::HUDSkinPanel);
		
		pENText = ::CText2D();
		pENText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pENText.SetPosition(100, 25);
		pENText.SetAlignment(1,1);

		pDMText = ::CText2D();
		pDMText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pDMText.SetPosition(400, 25);
		pDMText.SetAlignment(1,1);
		
		pPanel.AddChild(pENText);
		pPanel.AddChild(pDMText);
		
		AddChild(pPanel);
		
		Refresh();
	}
	
	function Refresh()
	{
		pENText.SetText("EN: " + ::Game.pDatabase.Energy);
		pDMText.SetText("DM: " + ::Game.pDatabase.Metal);
	}
}