
enum EBaseTileType
{
	SPACE = 1,		// Empty space
	BUILDPLACE = 2, // Can build platform
	PLATFORM = 3,	// Free platform
	BUILDING = 4	// Busy platform
}

class CBaseMap extends CHexMap
{
	constructor(_w, _h)
	{
		base.constructor(_w, _h);
		
		RegisterTile(EBaseTileType.SPACE, 0, 0, cTileSizeX, cTileSizeY);
		RegisterTile(EBaseTileType.BUILDPLACE, 64, 0, cTileSizeX, cTileSizeY);
		RegisterTile(EBaseTileType.PLATFORM, 128, 0, cTileSizeX, cTileSizeY);
		RegisterTile(EBaseTileType.BUILDING, 128, 0, cTileSizeX, cTileSizeY);
		
		for(local i=0;i<_w;i++)
		{
			for(local j=0;j<_h;j++)
			{
				SetTileID(i, j, EBaseTileType.SPACE);
			}
		}
	}
	
	function SafeMarkTile(i, j)
	{
		if(i >= 0 && i < pSizeI && j >= 0 && j < pSizeJ)
		{
			local tile = GetTileIJ(i, j);
			
			if(tile.ID == EBaseTileType.SPACE)
			{
				SetTileID(i, j, EBaseTileType.BUILDPLACE);
			}
		
		}
	}
	
	function Highlight(_enable)
	{
		for(local i=0;i<pSizeI;i++)
		{
			for(local j=0;j<pSizeJ;j++)
			{
				if(_enable)
				{
					local tid = GetTileID(i, j);
					
					if(tid == EBaseTileType.PLATFORM || tid == EBaseTileType.BUILDING)
					{
						SafeMarkTile(i-1, j);
						SafeMarkTile(i, j-1);
						SafeMarkTile(i+1, j);
						SafeMarkTile(i, j+1);
							
						if(i%2)
						{							
							SafeMarkTile(i+1, j+1);
							SafeMarkTile(i-1, j+1);
						}
						else
						{
							SafeMarkTile(i-1, j-1);
							SafeMarkTile(i+1, j-1);
						}
					}
				}
				else
				{
					if(GetTileID(i, j) == EBaseTileType.BUILDPLACE)
					{
						SetTileID(i, j, EBaseTileType.SPACE);
					}
				}
			}
		}
	}
}