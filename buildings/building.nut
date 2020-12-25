enum EBuildingType
{
	NONE = -1,
	HQ = 1,
	ES = 2,
	DM = 3,
	DK = 4
}

class CBuilding extends CSprite2D
{
	pMap = null;
	
	I = null;
	J = null;
	
	pPos = null;
	
	bTouched = null;
	bPlaced = null;
	bEdit = null;
	bBuilded = null;
	
	pPlaceID = null;
	
	pBuilder = null;
	pEditPopup = null;
	
	pType = null;
	
	constructor(_info, _proto)
	{
		base.constructor();
		
		pMap = ::Game.pBaseScreen.pBaseMap.weakref();
		
		I = _info.I;
		J = _info.J;
		
		SetTexture(::Game.AssetsDB.GetTexture(_proto.Texture));
		SetFrame(_proto.Frame[0], _proto.Frame[1], _proto.Frame[2], _proto.Frame[3]);
		SetCenter(_proto.Center[0], _proto.Center[1])
		
		local tile = pMap.GetTileIJ(I, J);
		pPos = ::CVector2(tile.X + pMap.cTileSizeX/2.0, tile.Y + pMap.cTileSizeY/2.0);
		
		SetPosition(pPos.X, pPos.Y);
		
		pPlaceID = _proto.PlaceTo;
		bPlaced = true;
		bTouched = false;
		bBuilded = true;
		bEdit = false;
		
		pType = EBuildingType.NONE;
	}
	
	function StartEdit(_build = false)
	{
		if(bEdit || pType == EBuildingType.HQ)
		{
			return;
		}
		
		bBuilded = !_build;
		bEdit = true;
		
		pEditPopup = ::CEditPopup(this, HandleAccept, HandleCancel);
		AddChild(pEditPopup);
		
		if(!bBuilded)
		{
			pEditPopup.AllowAccept(false);
		}
		else
		{
			pMap.SetTileID(I, J, EBaseTileType.PLATFORM);
		}
	}
	
	function Move(_dx, _dy)
	{	
		local scale = ::Game.pBaseScreen.pScale;
			
		pPos += ::CVector2(_dx / scale, _dy / scale);
		
		local tile = pMap.GetTileXY((pPos.X + pMap.pCameraX) * scale - pMap.pCameraX, (pPos.Y + pMap.pCameraY) * scale  - pMap.pCameraY);
		
		if(tile)
		{
			local tilepos = ::CVector2(tile.X + pMap.cTileSizeX/2.0, tile.Y + pMap.cTileSizeY/2.0);
			
			if(tile.ID == pPlaceID && pPos.Distance(tilepos) < 15.0)
			{
				I = tile.I;
				J = tile.J;
				
				if(!bPlaced)
				{
					bPlaced = true;
					pEditPopup.AllowAccept(true);
				}
					
				SetPosition(tilepos.X, tilepos.Y);
				
				return;
			}
		}
		
		if(bPlaced)
		{
			bPlaced = false;
			pEditPopup.AllowAccept(false);
		}
		
		SetPosition(pPos.X, pPos.Y);
	}
	
	function Serialize()
	{
		local item = {Type=this.pType, I=this.I, J=this.J};
		
		return item;
	}
	
	function HandleAccept(_btn)
	{
		bEdit = false;
		pEditPopup = null;
		
		pMap.SetTileID(I, J, EBaseTileType.BUILDING);
		
		if(bBuilded)
		{
			::Game.pBaseScreen.UpdateBuilding(this);
		}
		else
		{
			SetColor(0.2, 0.2, 0.2, 1.0);
			
			pBuilder = ::CBuilder(this, 60.0);
			AddChild(pBuilder);
		}
		
		::Game.pBaseScreen.StartBuilding(this);
	}
	
	function HandleCancel(_btn)
	{
		pEditPopup = null;
		pBuilder = null;
		
		::Game.pBaseScreen.DeleteBuilding(this);
	}
	
	function OnBuildingFinished()
	{
		bBuilded = true;
		
		SetColor(1.0, 1.0, 1.0, 1.0);
		pBuilder = null;
		
		::Game.pBaseScreen.FinishtBuilding(this);
	}
	
	function HandleTap()
	{
	}
	
	function StartFabrication()
	{
	}
	
	function OnFabricateFinished()
	{
	}
	
	function InputTouch(id, state, x, y)
	{
		if(state == 0)
		{
			bTouched = HitTest(x,y);
		}
		else
		if(state == 2 || state == 3)
		{
			bTouched = false;
		}
	}
	
	function InputGesture(type, p1, p2)
	{	
		if(type == 2 && bTouched && bEdit)
		{
			Move(p1, p2);

			::Game.Input.DropEvent();
		}
		else
		if(bTouched)
		{
			if(type == 3 && !bEdit)
			{
				HandleTap();
			}
			else
			if(type == 4 && !bEdit)
			{
				StartEdit();
			}
			
            ::Game.Input.DropEvent();
		}
	}
}