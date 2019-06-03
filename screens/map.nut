
class CMapScreen extends CGameScreen
{
	pSpaceMap = null;
	pExitButton = null;
	pScale = null;
	
	function Lock()
	{
		if(Input)
			Input.Disable();
	}
	
	function Unlock()
	{
		if(Input)
			Input.Enable();
	}

	function Load()
	{
		SetName("SpaceMap");
		
		pSpaceMap = ::CSpaceMap(13, 7);
		
		pScale = 1.5;
		pSpaceMap.SetScale(pScale, pScale);
		
		AddChild(pSpaceMap);
		
		pSpaceMap.SetCamera(0.0, 0.0);

		foreach(tile in ::Game.pDatabase.Map)
		{
			if(tile.Type == 1)
			{
				pSpaceMap.SetTileID(tile.I, tile.J, EMapTileType.EXPLORED);
				pSpaceMap.UpdateMap(tile.I, tile.J);
			}
			else
			if(tile.Type == 2)
			{
				pSpaceMap.SetTileID(tile.I, tile.J, EMapTileType.CANEXPLORE);
			}
		}

		pExitButton = ::CIconButton("data/buttons.png", [128*0,128*0,128,128], null, HandleExitButton, this);
		pExitButton.SetPosition(12, ::Game.ScreenHeight - 140);
		AddChild(pExitButton);

		::Game.PlayBackgroundTrack("data/immortals.ogg");
		
		::print("SpaceMap screen loaded.\n");
	}
	
	function Unload()
	{
		::Game.StopBackgroundTrack();

		pSpaceMap = null;
		pExitButton = null;
	}

	function TapOnTile(_tile)
	{
		if(_tile.ID == EMapTileType.CANEXPLORE)
		{
			::Game.pBattleScreen.SetMapPos(_tile.I, _tile.J);

			//Go to battle
			::print("Try to explore new hex. Go to the battle.\n");

			::Game.ReplaceScreen(::Game.pBattleScreen);
		}
	}

	function InputGesture(type, p1, p2)
	{	
		if(type == 3)
		{
			local tile = pSpaceMap.GetTileXY(p1, p2);

			if(tile)
			{
				TapOnTile(tile);
			}

			::Game.Input.DropEvent();
		}
	}

	function HandleExitButton(_btn)
	{
		if(_btn == pExitButton)
		{
			::print("Exit the space map.\n");
			::Game.ReplaceScreen(::Game.pBaseScreen);
		}
	}
}