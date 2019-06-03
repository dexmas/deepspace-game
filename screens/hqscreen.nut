
class CHQScreen extends CGameScreen
{
	pPanel = null;
	pExit = null;
	pItemList = null;
	
	function Load()
	{
		SetName("HQScreen");
		
		pPanel = ::CPanel(560, 280, ::GUISkinPanel);
		pPanel.SetPosition(::Game.ScreenWidth/2.0 - 560.0/2.0, ::Game.ScreenHeight/2.0 - 280.0/2.0);
		pPanel.SetName("HQScreenPanel");
		
		AddChild(pPanel);
		
		pExit = ::CIconButton("data/cross.png", [0,0,50,50], null, HandleExit, this);
		pExit.SetPosition(560 - 50, -60);
		pExit.SetScale(2.0,2.0);
		pExit.SetName("HQScreenExit");
		
		pItemList = ::CItemList(520, 0, 160, 160, ::RectSkinPanel, HandleListItem, this);
		pItemList.SetPosition(20, 50);
		
		pPanel.AddChild(pItemList);
		pPanel.AddChild(pExit);
		
		
		local button = pItemList.AddItem("HQScreenPanelpButton1");
		button.SetText("Build\nPlace");
		
		button = pItemList.AddItem("HQScreenPanelpButton2");
		button.SetText("Energo\nPlant");
		
		button = pItemList.AddItem("HQScreenPanelpButton3");
		button.SetText("Metal\nPlant");
		
		button = pItemList.AddItem("HQScreenPanelpButton4");
		button.SetText("Dock #1");
		
		button = pItemList.AddItem("HQScreenPanelpButton5");
		button.SetText("Dock #2");
		
		button = pItemList.AddItem("HQScreenPanelpButton6");
		button.SetText("Dock #3");
		
		button = pItemList.AddItem("HQScreenPanelpButton7");
		button.SetText("Dock #4");
		
		::print("HQ screen loaded.\n");
	}
	
	function Unload()
	{
		pPanel = null;
		pExit = null;
		pItemList = null;
		
		::print("HQ screen unloaded.\n");
	}
	
	function HandleListItem(itm)
	{
		local bname = itm.GetName();

		if(bname == "HQScreenPanelpButton1")
		{
			::Game.pBaseScreen.Build(::CPlatform);
		}
		else
		if(bname == "HQScreenPanelpButton2")
		{
			::Game.pBaseScreen.Build(::CESBuilding);
		}
		else
		if(bname == "HQScreenPanelpButton3")
		{
			::Game.pBaseScreen.Build(::CDMBuilding);
		}
		if(bname == "HQScreenPanelpButton4")
		{
			::Game.pBaseScreen.Build(::CDKBuilding);
		}
		else
		{
			::print("Pressed button: " + bname + " in HQ screen.\n");
		}
		
		::Game.PopScreen();
		
		::Game.Input.DropEvent();
	}
	
	function HandleExit(btn)
	{
		::Game.PopScreen();
		
		::Game.Input.DropEvent();
	}
}