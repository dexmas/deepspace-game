class CDMBuilding extends CBuilding
{
	pFabricator = null;
	
	constructor(_info)
	{
		local proto = 
		{
			Texture = "data/tileset.png",
			Frame = [128,64,64,64],
			Center = [32,32],
			PlaceTo = 3,
		}
		
		base.constructor(_info, proto);
		
		pType = EBuildingType.DM;
		
		::print("DMBuilding constructing at : " + _info.I + ", " + _info.J + "\n");
	}
	
	function StartFabrication()
	{
		pFabricator = ::CFabricator(this, 60, 0.2);
		AddChild(pFabricator);
	}
	
	function HandleTap()
	{	
		if(pFabricator)
		{
			::Game.Bill(0.0, pFabricator.pAmount.tointeger());
			
			pFabricator.Claim();
		}
		::print("Tap on DM building.\n");
	}
}