
class CPlatform extends CBuilding
{
	constructor(_info)
	{
		local proto = 
		{
			Texture = "data/tileset.png",
			Frame = [128,0,64,56],
			Center = [32,28],
			PlaceTo = 2,
		}
		
		base.constructor(_info, proto);
	}
}