class CESBuilding extends CBuilding
{	
	pFabricator = null;
	
	constructor(_info)
	{
		local proto = 
		{
			Texture = "data/tileset.png",
			Frame = [64,64,64,64],
			Center = [32,32],
			PlaceTo = 3,
		}
		
		base.constructor(_info, proto);
		
		pType = EBuildingType.ES;
		
		::print("ESBuilding constructing at : " + _info.I + ", " + _info.J + "\n");
	}
	
	function StartFabrication()
	{
		pFabricator = ::CFabricator(this, 100, 1.0);
		AddChild(pFabricator);
	}
	
	function HandleTap()
	{	
		if(pFabricator)
		{
			::Game.Bill(pFabricator.pAmount.tointeger(), 0.0);
			
			pFabricator.Claim();
		}
		::print("Tap on ES building.\n");
	}
}