
enum EBattleTileType
{
	SPACE = 1,	// Empty space
	CANMOVE = 2,// Can move to this tile
}

class CBattleMap extends CTileMap2D
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
		
		RegisterTile(EBattleTileType.SPACE, 0, 0, cTileSizeX, cTileSizeY); 
		RegisterTile(EBattleTileType.CANMOVE, 64, 0, cTileSizeX, cTileSizeY);
		
		for(local i=0;i<_w;i++)
		{
			for(local j=0;j<_h;j++)
			{
				SetTileID(i, j, EBattleTileType.SPACE);
				SetTileFlags(i, j, 1);
			}
		}
	}

	function MarkPossibleMoves(_i, _j, _steps)
	{
		/*if(_steps <= 0)
		{
			return 0;
		}

		local neibors = [{I=_i-1, J=_j}, {I=_i, J=_j-1}, {I=_i+1, J=_j}, {I=_i, J=_j+1}];

		if(_i%2)
		{
			neibors.push({I=_i+1, J=_j+1});
			neibors.push({I=_i-1, J=_j+1});
		}
		else
		{
			neibors.push({I=_i-1, J=_j-1});
			neibors.push({I=_i+1, J=_j-1});
		}

		local result = 0;

		local cellList = [];

		foreach(nb in neibors)
		{
			if(nb.I >= 0 && nb.I < pSizeI && nb.J >= 0 && nb.J < pSizeJ)
			{
				local tile = GetTileIJ(nb.I, nb.J);
			
				if(tile.ID == EBattleTileType.SPACE && tile.Flags >= 1)
				{
					cellList.push(nb);

					SetTileID(nb.I, nb.J, EBattleTileType.CANMOVE);

					if(_steps == 1)
					{
						SetTileColor(nb.I, nb.J, 0xFFFFFF80);
					}

					result++;
				}
			}
		}

		foreach(nb in cellList)
		{
			result += MarkPossibleMoves(nb.I, nb.J, _steps - 1);
		}*/

		local tiles = [];
		
		local count = FindTiles(_i, _j, _steps, EBattleTileType.SPACE, 1, tiles);

		foreach(tile in tiles)
		{
			SetTileID(tile.I, tile.J, EBattleTileType.CANMOVE);

			if(tile.H < 1.0)
			{
				SetTileColor(tile.I, tile.J, 0xFFFFFF80);
			}
		}

		return count;
	}

	function ClearPossibleMoves()
	{
		for(local i=0;i<pSizeI;i++)
		{
			for(local j=0;j<pSizeJ;j++)
			{
				local tile = GetTileIJ(i, j);
			
				if(tile.ID == EBattleTileType.CANMOVE)
				{
					SetTileID(i, j, EBattleTileType.SPACE);
					SetTileColor(i, j, 0xFFFFFFFF);
				}
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