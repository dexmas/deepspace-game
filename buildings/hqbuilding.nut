class CHQBuilding extends CBuilding
{

	constructor(_info)
	{
		local proto = 
		{
			Texture = "data/tileset.png",
			Frame = [0,64,64,64],
			Center = [32,32],
			PlaceTo = 3,
		}
		
		base.constructor(_info, proto);
		
		pType = EBuildingType.HQ;
		
		::print("HQBuilding constructing at : " + _info.I + ", " + _info.J + "\n");
	}
	
	function HandleTap()
	{
		::print("Tap on HQ building.\n");
		::Game.PushScreen(::Game.pHQScreen);
	}
}