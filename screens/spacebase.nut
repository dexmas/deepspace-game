
class CSpaceBaseScreen extends CGameScreen
{
	pBaseMap = null;
	pBuildings = null;
	pHUDPanel = null;
	pButtleButton = null;
	
	pScale = null;
	
	function Lock()
	{
		if(Input)
			Input.Disable();
	}
	
	function Unlock()
	{
		if(Input)
			Input.Enable();
	}
	
	function Load()
	{
		SetName("SpaceBase");
		
		pBaseMap = ::CBaseMap(9, 7);
		
		pScale = ::Game.pDatabase.Camera.Scale;
		pBaseMap.SetScale(pScale);
		
		AddChild(pBaseMap);
		
		pBuildings = [];
		
		foreach(pl in ::Game.pDatabase.Platforms)
		{
			pBaseMap.SetTileID(pl.I, pl.J, EBaseTileType.PLATFORM);
		}
		
		foreach(bl in ::Game.pDatabase.Buildings)
		{
			local pbuild = null;
			
			if(bl.Type == EBuildingType.HQ)
			{
				pbuild = ::CHQBuilding(bl);
			}
			else
			if(bl.Type == EBuildingType.ES)
			{
				pbuild = ::CESBuilding(bl);
			}
			else
			if(bl.Type == EBuildingType.DM)
			{
				pbuild = ::CDMBuilding(bl);
			}
			else
			if(bl.Type == EBuildingType.DK)
			{
				pbuild = ::CDKBuilding(bl);
			}
			
			if(pbuild)
			{
				pbuild.StartFabrication();
				
				pBuildings.push(pbuild);
				
				pBaseMap.AddChild(pbuild);
				
				pBaseMap.SetTileID(bl.I, bl.J, EBaseTileType.BUILDING);
			}
		}
		
		pBaseMap.SetCamera(::Game.pDatabase.Camera.X, ::Game.pDatabase.Camera.Y);

		pHUDPanel = ::CHUDPanel(this);

		pButtleButton = ::CIconButton(this, "data/buttons.png", [128*0,128*3,128,128], null, HandleBattleButton, this);
		pButtleButton.SetPosition(::Game.ScreenWidth - 140, ::Game.ScreenHeight - 140);
		
		::print("[CSpaceBaseScreen] Loaded\n");
	}
	
	function Build(_class, _param = -1)
	{
		local item = null;
		
		local info = {I=3, J=3};
		
		if(_class == ::CPlatform)
		{
			::print("Build platform.\n");
			
			item = ::CPlatform(info);
			
			pBaseMap.Highlight(true);
		}
		else
		if(_class == ::CDKBuilding)
		{
			local dkinfo = {I=3, J=3, ShipType=_param, ShipsMax=5, Ships=0};
			
			::print("Build dock type: " + _param + "\n");
			
			item = _class(dkinfo);
			
		}
		else
		{
			::print("Build module: " + _class + "\n");
			
			item = _class(info);
		}
		
		item.StartEdit(true);
		
		pBaseMap.AddChild(item);
	}
	
	function StartBuilding(_bld)
	{
		pBaseMap.Highlight(false);
	}
	
	function FinishtBuilding(_bld)
	{			
		if(_bld.getclass() == ::CPlatform)
		{
			pBaseMap.SetTileID(_bld.I, _bld.J, EBaseTileType.PLATFORM);
			pBaseMap.RemoveChild(_bld);

			::Game.pDatabase.Platforms.push({I=_bld.I, J=_bld.J});
			
			_bld = null;
		}
		else
		{
			pBuildings.push(_bld);
			
			::Game.pDatabase.Buildings.push(_bld.Serialize());
			
			_bld.StartFabrication();
		}
		
		::Game.SaveGame();
		
		::print("Finish building.\n");
	}
	
	function UpdateBuilding(_bld)
	{
		foreach(idx, item in ::Game.pDatabase.Buildings)
		{
			if(item.Type == _bld.pType && item.I == _bld.I && item.J == _bld.J)
			{
				::print("Remove item from database. idx=" + idx + "\n");
				
				::Game.pDatabase.Buildings.remove(idx);
			}
		}
		
		::Game.pDatabase.Buildings.push(_bld.Serialize());
		
		::Game.SaveGame();
		
		::print("Update building.\n");
	}
	
	function DeleteBuilding(_bld)
	{
		pBaseMap.Highlight(false);
	
		pBaseMap.RemoveChild(_bld);
		
		local idx = pBuildings.find(_bld);
		
		if(idx != null)
		{
			pBuildings.remove(idx)
		}
		
		foreach(idx, item in ::Game.pDatabase.Buildings)
		{
			if(item.Type == _bld.pType && item.I == _bld.I && item.J == _bld.J)
			{
				::print("Remove item from database. idx=" + idx + "\n");
				
				::Game.pDatabase.Buildings.remove(idx);
			}
		}
		
		_bld = null;
		
		::Game.SaveGame();
		
		::print("Delete building.\n");
	}
	
	function Unload()
	{
		pBaseMap = null;
		pButtleButton = null;
		pHUDPanel = null;
		pBuildings = [];

		::print("[CSpaceBaseScreen] Unloaded\n");
	}
	
	function InputGesture(type, p1, p2)
	{
		if(type == 2)
		{	
			pBaseMap.Scroll(p1, p2);

			::Game.pDatabase.Camera.X = pBaseMap.pCameraX;
			::Game.pDatabase.Camera.Y = pBaseMap.pCameraY;
			
			::Game.Input.DropEvent();
		}
		else
		if(type == 1)
		{
			pScale += p2 * 0.01;
			if(pScale < 0.5)
				pScale = 0.5;
			else
			if(pScale > 4.0)
				pScale = 4.0;
				
			pBaseMap.SetScale(pScale);
			pBaseMap.Scroll(-p2, -p2);

			::Game.pDatabase.Camera.Scale = pScale;
			
			::Game.Input.DropEvent();
		}
	}

	function HandleBattleButton(_btn)
	{
		if(_btn == pButtleButton)
		{
			::Game.ReplaceScreen(::Game.pMapScreen);
		}
	}
}