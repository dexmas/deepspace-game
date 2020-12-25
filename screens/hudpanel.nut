class CHUDPanel extends CPanel
{
	pPanel = null;
	pENText = null;
	pDMText = null;
	pSPText = null;
	
	constructor(_parent)
	{
		base.constructor(_parent, 1.0, 50, ::HUDSkinPanel);

		local width = GetSize().X;

		pENText = ::CText2D();
		pENText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pENText.SetPosition(width * 0.1, 25);
		pENText.SetAlignment(1,1);

		pDMText = ::CText2D();
		pDMText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pDMText.SetPosition(width * 0.5, 25);
		pDMText.SetAlignment(1,1);

		pSPText = ::CText2D();
		pSPText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pSPText.SetPosition(width * 0.9, 25);
		pSPText.SetAlignment(1,1);
		
		AddChild(pENText);
		AddChild(pDMText);
		AddChild(pSPText);
			
		Refresh();
	}
	
	function Refresh()
	{
		pENText.SetText("EN: " + ::Game.pDatabase.Energy);
		pDMText.SetText("DM: " + ::Game.pDatabase.Metal);
		pSPText.SetText("SP: 000");
	}
}