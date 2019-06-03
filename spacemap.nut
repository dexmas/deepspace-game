
enum EMapTileType
{
	SPACE = 1,		// Empty space
	CANEXPLORE = 2, // Can build platform
	EXPLORED = 3,	// Free platform
}

class CSpaceMap extends CTileMap2D
{
	cTexturePath = "data/tileset.png";
	
	pCameraX = null;
	pCameraY = null;
	
	pSizeI = null;
	pSizeJ = null;
	
	cTileSizeX = 64;
	cTileSizeY = 56;
	
	constructor(_w, _h)
	{
		base.constructor();
		
		pCameraX = 0.0;
		pCameraY = 0.0;
		
		pSizeI = _w;
		pSizeJ = _h;
		
		Init(3, _w, _h, cTileSizeX, cTileSizeY);
		
		SetTexture(::Game.AssetsDB.GetTexture(cTexturePath));
		
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
	
	function Scroll(_dx, _dy)
	{
		pCameraX += _dx;
		pCameraY += _dy;
		
		SetPosition(pCameraX, pCameraY);
	}
	
	function SetCamera(_x, _y)
	{
		pCameraX = _x;
		pCameraY = _y;
		
		SetPosition(pCameraX, pCameraY);
	}
}