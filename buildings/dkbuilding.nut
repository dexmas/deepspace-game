class CDKBuilding extends CBuilding
{	
	pFabricator = null;
	pShips = null;
	pShipsMax = null;
	pCountText = null;
	
	constructor(_info)
	{
		local proto = 
		{
			Texture = "data/tileset.png",
			Frame = [0,128,64,64],
			Center = [32,32],
			PlaceTo = 3,
		}
		
		base.constructor(_info, proto);
		
		pType = EBuildingType.DK;
		
		pShips = _info.Ships;
		pShipsMax = _info.ShipsMax;

		pCountText = ::CText2D();
		pCountText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pCountText.SetPosition(0, -25);
		pCountText.SetAlignment(1,1);
		pCountText.SetScale(0.4, 0.4);
		pCountText.SetText(pShips.tointeger() + "/" + pShipsMax.tointeger());

		AddChild(pCountText);
		
		::print("DKBuilding constructing at : " + _info.I + ", " + _info.J + "\n");
	}

	function UpdateCounter()
	{
		pCountText.SetText(pShips.tointeger() + "/" + pShipsMax.tointeger());
	}
	
	function Serialize()
	{
		local item = {Type=this.pType, I=this.I, J=this.J, ShipsMax=this.pShipsMax, Ships=this.pShips};
		
		return item;
	}
	
	function HandleTap()
	{	
		::print("Tap on DK building.\n");
		
		::Game.pDKScreen.ShowDock(this);
		::Game.PushScreen(::Game.pDKScreen);
	}
}