
class CHexMap extends CTileMap2D
{
	cTexturePath = "data/tileset.png";
	
	pCameraX = null;
	pCameraY = null;
	
	pSizeI = null;
	pSizeJ = null;
	
	cTileSizeX = 64;
	cTileSizeY = 56;

	pScale = null;
	
	constructor(_w, _h)
	{
		base.constructor();
		
		pCameraX = 0.0;
		pCameraY = 0.0;
		
		pSizeI = _w;
		pSizeJ = _h;

		pScale = 1.0;
		
		Init(3, _w, _h, cTileSizeX, cTileSizeY);
		
		SetTexture(::Game.AssetsDB.GetTexture(cTexturePath));
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

	function SetScale(_scale)
	{
		pScale = _scale;
		base.SetScale(_scale, _scale);
	}

	function GetTileXY(_x, _y)
	{
		::print("GetTileXY (" + _x + ", " + _y + "). pScale = " + pScale + ". Camera (" + pCameraX + ", " + pCameraY + ")\n");

		return base.GetTileXY(_x + pCameraX, _y + pCameraY);
	}
}