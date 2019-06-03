
import("ui/ui.nut")

import("basemap.nut")
import("battlemap.nut")
import("spacemap.nut")
import("battlesquad.nut")

import("buildings/builder.nut")
import("buildings/fabricator.nut")
import("buildings/building.nut")
import("buildings/platform.nut")
import("buildings/hqbuilding.nut")
import("buildings/esbuilding.nut")
import("buildings/dmbuilding.nut")
import("buildings/dkbuilding.nut")

import("screens/screen.nut")
import("screens/spacebase.nut")
import("screens/hqscreen.nut")
import("screens/dkscreen.nut")
import("screens/editpopup.nut")
import("screens/hudpanel.nut")
import("screens/map.nut")
import("screens/battle.nut")
import("screens/debrifing.nut")

import("data/localization.nut")

Localization <- ::CLocalization.EN;

class CDeepSpaceGame extends CGame
{
	pScreens = null;
	
	pBaseScreen = null;
	pHQScreen = null;
	pDKScreen = null;
	pMapScreen = null;
	pBattleScreen = null;
	pDebrifScreen = null;
	
	pDatabase = null;

	pBackgroundMusic = null;
	sSaveVersion = 2;
	
	function Configure()
	{
		//Set this values only for desktop platforms now
		//SetScreenSize(ScreenWidth, ScreenHeight);

		EnableDebug(true);
		EnableConsole(true);
		SetFPSLimit(60);
	}

	function Init()
	{
		pScreens = [];
		
		pBaseScreen = ::CSpaceBaseScreen();
		pHQScreen = ::CHQScreen();
		pDKScreen = ::CDKScreen();
		pMapScreen = ::CMapScreen();
		pBattleScreen = ::CBattleScreen();
		pDebrifScreen = ::CDebrifScreen();
		
		local save = ::CSaveFile("data.save", false);
		
		pDatabase = save.Read();
		
		if(pDatabase == null || !("Version" in pDatabase) || pDatabase.Version != sSaveVersion)
		{
			if(pDatabase)
			{
				::print("Save file version missmatch. Required: " + sSaveVersion + ", present: " + (("Version" in pDatabase) ? pDatabase.Version : "<none>") + "\n");
			}

			InitDatabase();
		}

		pBackgroundMusic = ::CSoundSource();
		AddComponent(pBackgroundMusic);

		pBackgroundMusic.SetVolume(0.5);
		
		PushScreen(pBaseScreen);
	}
	
	function Free()
	{
		::print("Free game resources. Save game state.\n");
		
		SaveGame();
		
		pBaseScreen = null;
		pHQScreen = null;
		pDKScreen = null;
	}
	
	function SaveGame()
	{
		local save = ::CSaveFile("data.save", true);
		
		save.Write(pDatabase);
	}
	
	function InitDatabase()
	{
		pDatabase = 
		{
			Version = sSaveVersion,
			Energy = 500,
			Metal = 800,
			XRay = 450,
			
			Platforms = [{I = 4, J = 3}],
			Buildings = [{Type = 1, I = 4, J = 3}],
			Map = [{Type = 1, I = 6, J = 3}],
			MapPos = {I = 6, J = 3},
			
			Camera = {Scale = 2.0, X = 0.0, Y = 0.0}
		};

		SaveGame();
	}
	
	function Bill(_energy, _metal)
	{
		pDatabase.Energy += _energy;
		pDatabase.Metal += _metal;
		
		pBaseScreen.pHUDPanel.Refresh();
	}
	
	function PushScreen(_screen)
	{	
		_screen.Load();
		AddChild(_screen);
		
		pScreens.push(_screen);
	}
	
	function PopScreen()
	{	
		if(pScreens.len())
		{	
			RemoveChild(pScreens.top());
			pScreens.top().Unload();
			
			pScreens.pop();
		}
	}
	
	function ReplaceScreen(_screen)
	{
		foreach(scr in pScreens)
		{
			scr.Unload();
			RemoveChild(scr);
		}
		
		pScreens.clear();
		
		PushScreen(_screen)
	}

	function PlayBackgroundTrack(_name)
	{
		pBackgroundMusic.SetSound(AssetsDB.GetSound(_name));
		pBackgroundMusic.Play(true);
	}

	function StopBackgroundTrack()
	{
		pBackgroundMusic.Stop();
	}
}

Game <- ::CDeepSpaceGame();