
class CHQScreen extends CGameScreen
{
	pPanel = null;
	pExit = null;
	pItemList = null;
	
	function Load()
	{
		SetName("HQScreen");
		
		pPanel = ::CPanel(this, 0.8, 0.5, ::GUISkinPanel);
		pPanel.SetPosition(0.5, 0.5);
		pPanel.SetName("HQScreenPanel");
		
		AddChild(pPanel);
		
		pExit = ::CIconButton(pPanel, "data/cross.png", [0,0,50,50], null, HandleExit, this);
		pExit.SetScale(2.0,2.0);
		pExit.SetPosition(1.0, 0.001);
		pExit.SetName("HQScreenExit");
		
		pItemList = ::CItemList(pPanel, 0.97, 1.0, 160, 0.66, ::RectSkinPanel, HandleListItem, this);
		pItemList.SetPosition(0.5, 0.54);
		
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
			::Game.pBaseScreen.Build(::CDKBuilding, 1);
		}
		else
		if(bname == "HQScreenPanelpButton5")
		{
			::Game.pBaseScreen.Build(::CDKBuilding, 2);
		}
		else
		if(bname == "HQScreenPanelpButton6")
		{
			::Game.pBaseScreen.Build(::CDKBuilding, 3);
		}
		else
		if(bname == "HQScreenPanelpButton7")
		{
			::Game.pBaseScreen.Build(::CDKBuilding, 4);
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