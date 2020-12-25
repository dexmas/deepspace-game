
class CDKScreen extends CGameScreen
{
	pPanel = null;
	pExit = null;
	//pItemList = null;
	pDock = null;
	pShipIcons = null;
	pShipPanel = null;
	pBuildButton = null;
	pSellButton = null;
	pShipModel = null;
	
	function Load()
	{
		SetName("DKScreen");
		
		pPanel = ::CPanel(this, 0.8, 0.5, ::GUISkinPanel);
		pPanel.SetPosition(0.5, 0.5);
		pPanel.SetName("DKScreenPanel");
		
		pExit = ::CIconButton(pPanel, "data/cross.png", [0,0,50,50], null, HandleExit, this);
		pExit.SetScale(2.0,2.0);
		pExit.SetPosition(1.0, 0.001);
		pExit.SetName("DKScreenExit");
		
		local icons = ::Game.AssetsDB.GetTexture("data/ships_icons.png");
		
		//pItemList = ::CItemList(pPanel, 370, 0, 80, 130, ::RectSkinPanel, HandleListItem, this);
		//pItemList.SetPosition(160, 50);
		
		if(pDock)
		{
			local cnt = pDock.pShipsMax;
			
			pShipIcons = [];
			pShipPanel = ::CNode2D();
			
			pShipModel = ::CSprite2D();
			pShipModel.SetTexture(icons);
			pShipModel.SetFrame(64,0,64,64);
			pShipModel.SetScale(3.0, 3.0);
			pShipModel.SetColor(1.0, 0.0, 0.0, 1.0);
			pShipModel.SetPosition(10, 45);
			
			pPanel.AddChild(pShipModel);
			
			for(local i=0; i<cnt; i++)
			{
				local sprite = ::CSprite2D();
				
				sprite.SetTexture(icons);
				sprite.SetFrame(64,0,64,64);
				
				if(i >= pDock.pShips)
				{
					sprite.SetColor(0.3, 0.3, 0.3, 1.0);
				}
				else
				{
					sprite.SetColor(0.4, 0.4, 1.0, 1.0);
				}
				
				sprite.SetPosition(i*64, 0);
				
				pShipIcons.push(sprite);
				pShipPanel.AddChild(sprite);
			}
			
			pShipPanel.SetPosition(pPanel.GetSize().X / 2.0 + 64.0 - (64.0*cnt)/2.0, pPanel.GetSize().Y * 0.3);
			pPanel.AddChild(pShipPanel);
			
			pBuildButton = ::CButton(pPanel, "BUILD", 120, 50, ::GUISkinButton, HandleBuild, this);
			pBuildButton.SetPosition(pPanel.GetSize().X / 2.0 - 120.0/2.0, 0.8);
			
			if(pDock.pShips >= pDock.pShipsMax)
			{
				pBuildButton.Lock();
			}

			pSellButton = ::CButton(pPanel, "SELL", 120, 50, ::GUISkinButton, HandleSell, this);
			pSellButton.SetPosition(pPanel.GetSize().X / 2.0 + 20 + 120.0/2.0, 0.8);

			if(pDock.pShips <= 0)
			{
				pSellButton.Lock();
			}
		}

		::print("DK screen loaded.\n");
	}
	
	function HandleBuild(btn)
	{
		if(btn == pBuildButton && pDock && pDock.pShips < pDock.pShipsMax)
		{
			pShipIcons[pDock.pShips].SetColor(0.4, 0.4, 1.0, 1.0);
			pDock.pShips++;

			pDock.UpdateCounter();
			
			::Game.pBaseScreen.UpdateBuilding(pDock);
			
			if(pDock.pShips >= pDock.pShipsMax)
			{
				pBuildButton.Lock();
			}

			if(pDock.pShips >= 0)
			{
				pSellButton.Unlock();
			}
		}
	}

	function HandleSell(btn)
	{
		if(btn == pSellButton && pDock && pDock.pShips > 0)
		{
			pShipIcons[pDock.pShips-1].SetColor(0.3, 0.3, 0.3, 1.0);
			pDock.pShips--;

			pDock.UpdateCounter();
			
			::Game.pBaseScreen.UpdateBuilding(pDock);
			
			if(pDock.pShips <= 0)
			{
				pSellButton.Lock();
			}

			if(pDock.pShips < pDock.pShipsMax)
			{
				pBuildButton.Unlock();
			}
		}
	}
	
	function Unload()
	{
		pPanel = null;
		pExit = null;
		//pItemList = null;
		pShipModel = null;
		pShipIcons = null;
		pShipPanel = null;
		
		::print("DK screen unloaded.\n");
	}
	
	function ShowDock(_dock)
	{
		pDock = _dock;
	}

	function HandleListItem(itm)
	{
		local iname = itm.GetName();

		::print("Pressed button: " + iname + " in DK screen.\n");
		
		::Game.PopScreen();
		
		::Game.Input.DropEvent();
	}
	
	function HandleExit(btn)
	{
		::Game.PopScreen();
		
		::Game.Input.DropEvent();
	}
}
