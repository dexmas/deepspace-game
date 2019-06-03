
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
		
		pPanel = ::CPanel(560, 280, ::GUISkinPanel);
		pPanel.SetPosition(::Game.ScreenWidth/2.0 - 560.0/2.0, ::Game.ScreenHeight/2.0 - 280.0/2.0);
		pPanel.SetName("DebrifScreenPanel");
		
		AddChild(pPanel);

		pChaptionText = ::CText2D();
		pChaptionText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pChaptionText.SetPosition(280, 140);
		pChaptionText.SetAlignment(1,1);

		pPanel.AddChild(pChaptionText);
		
		pExit = ::CIconButton("data/cross.png", [0,0,50,50], null, HandleExit, this);
		pExit.SetPosition(560 - 50, -60);
		pExit.SetScale(2.0,2.0);
		pExit.SetName("DebrifScreenExit");
		
		pPanel.AddChild(pExit);
		
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