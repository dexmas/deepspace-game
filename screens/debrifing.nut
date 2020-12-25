
class CDebrifScreen extends CGameScreen
{
	pPanel = null;
	pExit = null;
	pChaptionText = null;

	function Setup(_isWin, _die, _kill)
	{
		if(_isWin == true)
		{
			pChaptionText.SetColor(0.0, 0.0, 1.0, 1.0);
			pChaptionText.SetText("You won! \nlosted " + _die + " ships, \ndestroyed " + _kill + " ships.");
		}
		else
		{
			pChaptionText.SetColor(1.0, 0.0, 0.0, 1.0);
			pChaptionText.SetText("You loose. \nlosted " + _die + " ships, \ndestroyed " + _kill + " ships.");
		}
	}
	
	function Load()
	{
		SetName("DebrifScreen");
		
		pPanel = ::CPanel(this, 0.8, 0.5, ::GUISkinPanel);
		pPanel.SetPosition(0.5, 0.5);
		pPanel.SetName("DebrifScreenPanel");

		pChaptionText = ::CText2D();
		pChaptionText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pChaptionText.SetPosition(pPanel.GetSize().X / 2.0, pPanel.GetSize().Y / 2.0);
		pChaptionText.SetAlignment(1,1);

		pPanel.AddChild(pChaptionText);
		
		pExit = ::CIconButton(pPanel, "data/cross.png", [0,0,50,50], null, HandleExit, this);
		pExit.SetScale(2.0,2.0);
		pExit.SetPosition(1.0, 0.001);
		pExit.SetName("DebrifScreenExit");
		
		::print("DebrifScreen screen loaded.\n");
	}
	
	function Unload()
	{
		pPanel = null;
		pExit = null;
		
		::print("DebrifScreen screen unloaded.\n");
	}
	
	function HandleExit(btn)
	{
		::Game.PopScreen();

		::Game.ReplaceScreen(::Game.pBaseScreen);
		
		::Game.Input.DropEvent();
	}
}