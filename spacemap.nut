
enum EMapTileType
{
	SPACE = 1,		// Empty space
	CANEXPLORE = 2, // Can build platform
	EXPLORED = 3,	// Free platform
}

class CSpaceMap extends CHexMap
{
	constructor(_w, _h)
	{
		base.constructor(_w, _h);
		
		RegisterTile(EMapTileType.SPACE, 0, 0, cTileSizeX, cTileSizeY);
		RegisterTile(EMapTileType.CANEXPLORE, 64, 0, cTileSizeX, cTileSizeY);
		RegisterTile(EMapTileType.EXPLORED, 128, 0, cTileSizeX, cTileSizeY);
		
		for(local i=0;i<_w;i++)
		{
			for(local j=0;j<_h;j++)
			{
				SetTileID(i, j, EMapTileType.SPACE);
			}
		}
	}
	
	function SafeMarkTile(i, j)
	{
		if(i >= 0 && i < pSizeI && j >= 0 && j < pSizeJ)
		{
			local tile = GetTileIJ(i, j);
			
			if(tile.ID == EMapTileType.SPACE)
			{
				SetTileID(i, j, EMapTileType.CANEXPLORE);
			}
		
		}
	}
	
	function UpdateMap(_i, _j)
	{
		local tid = GetTileID(_i, _j);
					
		if(tid == EMapTileType.EXPLORED)
		{
			SafeMarkTile(_i-1, _j);
			SafeMarkTile(_i, _j-1);
			SafeMarkTile(_i+1, _j);
			SafeMarkTile(_i, _j+1);
							
			if(_i%2)
			{							
				SafeMarkTile(_i+1, _j+1);
				SafeMarkTile(_i-1, _j+1);
			}
			else
			{
				SafeMarkTile(_i-1, _j-1);
				SafeMarkTile(_i+1, _j-1);
			}
		}
	}
}