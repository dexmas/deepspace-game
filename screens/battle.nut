
class CBattleScreen extends CGameScreen
{
	pBattleMap = null;
	pExitButton = null;
	pNextTurnButton = null;
	pScale = null;

	pPlayerSquadsPrototypes = null;
	pAISquadsPrototypes = null;

	pPlayerSquads = null;
	pAISquads = null;
	pTurnQueue = null;

	pCurrentSquad = null;

	pMapPos = null;
	
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

	function SetMapPos(_i, _j)
	{
		pMapPos = {I = _i, J = _j};
	}

	function SetupPlayerSquad()
	{
		pPlayerSquadsPrototypes = [];

		::print("Setup player squads: ");

		foreach(bld in ::Game.pDatabase.Buildings)
		{
			if(bld.Type != EBuildingType.DK)
			{
				continue
			}

			if(bld.Ships <= 0)
			{
				continue;
			}

			local proto = 
			{
				Texture = "data/ships_icons.png",
				Frame = [64*1,64*0,64,64],
				Center = [32,32],
				Color = [0.6, 0.6, 1.0, 1.0],

				Type = EBattleSquadType.FIGHTER,
				Health = 30,
				MinDamage = 3,
				MaxDamage = 6,
				Count = bld.Ships,
				Steps = 3,
				AttackDistance = 1
			}

			pPlayerSquadsPrototypes.push(proto);

			::print("+");
		}

		::print("\n");
	}

	function SetupAISquad()
	{
		pAISquadsPrototypes = [];

		::print("Setup AI squads: ");

		foreach(pt in pPlayerSquadsPrototypes)
		{
			pt.Color = [1.0, 0.6, 0.6, 1.0],
			pt.Health *= 0.7;

			pAISquadsPrototypes.push(pt);

			::print("+");
		}

		::print("\n");
	}
	
	function Load()
	{
		SetName("Battle");
		
		pBattleMap = ::CBattleMap(13, 7);
		
		pScale = 1.5;
		pBattleMap.SetScale(pScale, pScale);
		
		AddChild(pBattleMap);
		
		pBattleMap.SetCamera(0.0, 0.0);

		pPlayerSquads = [];
		pAISquads = [];
		pTurnQueue = [];

		SetupPlayerSquad();

		local currJ = 0;
		local currI = 0;

		foreach(proto in pPlayerSquadsPrototypes)
		{
			local squad = ::CBattleSquad(currI, currJ, proto, EBattleFraction.PLAYER);
			pBattleMap.AddChild(squad);

			pPlayerSquads.push(squad);
			pTurnQueue.push(squad.weakref());

			currJ++;
		}

		SetupAISquad();

		currJ = 0;
		currI = pBattleMap.pSizeI - 1;

		foreach(proto in pAISquadsPrototypes)
		{
			local squad = ::CBattleSquad(currI, currJ, proto, EBattleFraction.ENEMY);
			pBattleMap.AddChild(squad);

			pAISquads.push(squad);
			pTurnQueue.push(squad.weakref());

			currJ++;
		}

		pExitButton = ::CIconButton("data/buttons.png", [128*0,128*0,128,128], null, HandleExitButton, this);
		pExitButton.SetPosition(12, ::Game.ScreenHeight - 140);
		AddChild(pExitButton);

		pNextTurnButton = ::CIconButton("data/buttons.png", [128*1,128*1,128,128], null, HandleNextTurnButton, this);
		pNextTurnButton.SetPosition(::Game.ScreenWidth - 128 - 12, ::Game.ScreenHeight - 140);
		pNextTurnButton.Lock();
		AddChild(pNextTurnButton);

		if(!pMapPos)
		{
			::print("MapPoint for buttle not seted up. Using previous point.");
			pMapPos = {I = ::Game.pDatabase.MapPos.I, J = ::Game.pDatabase.MapPos.J};
		}

		::Game.PlayBackgroundTrack("data/immortals.ogg");

		NextTurn();
		
		::print("Battle screen loaded.\n");
	}
	
	function Unload()
	{
		::Game.StopBackgroundTrack();

		pBattleMap = null;
		pExitButton = null;
		pPlayerSquads = null;
		pAISquads = null;
		pTurnQueue = null;
		pCurrentSquad = null;

		pPlayerSquadsPrototypes = null;
		pAISquadsPrototypes = null;
		pMapPos = null;
	}

	function NextTurn()
	{
		::print("[CBattleScreen]: NextTurn.\n");

		if(!pPlayerSquads.len() || !pAISquads.len())
		{
			::print("Game was ended. No more turns.\n");
			return;
		}

		if(!pTurnQueue.len())
		{
			::print("[CBattleScreen]: No squads in the buttle. Please build some.\n");
			return;
		}

		if(!pCurrentSquad)
		{
			pCurrentSquad = pTurnQueue[0];
		}
		else
		{
			pCurrentSquad.EndTurn();

			pTurnQueue.remove(0);
			pTurnQueue.push(pCurrentSquad);

			pCurrentSquad = pTurnQueue[0];
		}

		pCurrentSquad.StartTurn();

		if(pCurrentSquad.pFraction == EBattleFraction.PLAYER)
		{
			local possMoves = pBattleMap.MarkPossibleMoves(pCurrentSquad.I, pCurrentSquad.J, pCurrentSquad.pSteps);
			pNextTurnButton.Unlock();
		}
		else
		{
			pNextTurnButton.Lock();

			//AI logic here
			local targetList = [];

			foreach(target in pPlayerSquads)
			{
				targetList.push(target);
			}

			::print("AI: Choose target from " + targetList.len() + " options.\n");

			local minDist = pBattleMap.pSizeI * pBattleMap.pSizeJ + 1;
			local minDistTarget = null;

			foreach(target in targetList)
			{
				local path = [];
				if(pBattleMap.CalcPath(pCurrentSquad.I, pCurrentSquad.J, target.I, target.J, 0, path))
				{
					if(path.len() < minDist)
					{
						minDist = path.len();
						minDistTarget = target;
					}
				}
			}

			if(minDistTarget)
			{
				::print("AI: Move to choosed target: (" + minDistTarget.I + ", " + minDistTarget.J + ").\n");

				pCurrentSquad.AttackTo(minDistTarget);
			}
			else
			{
				::print("AI: No aviable targets. Next turn.\n");

				NextTurn();
			}
		}
	}

	function RemoveSquad(_squad)
	{
		::print("[CBattleScreen]: Remove squad.\n");

		local idx = pTurnQueue.find(_squad);

		if(idx != null)
		{
			pTurnQueue.remove(idx);
		}
		else
		{
			::print("[CBattleScreen]: Can't remove squad from turn queue.\n");
		}
		
		idx = pPlayerSquads.find(_squad);

		if(idx != null)
		{
			pPlayerSquads.remove(idx);
		}
		else
		{
			idx = pAISquads.find(_squad);
			
			if(idx != null)
			{
				pAISquads.remove(idx);
			}
			else
			{
				::print("[CBattleScreen]: Can't remove squad. Can't find squad in lists.\n");
				pCurrentSquad = null;
			}
		}

		pBattleMap.RemoveChild(_squad);

		if(!pPlayerSquads.len() || !pAISquads.len())
		{
			if(pPlayerSquads.len() > 0)
			{
				//Win
				::print("!Player won. Point (" + pMapPos.I + ", " + pMapPos.J + ") explored.\n");

				::Game.pDatabase.MapPos.I = pMapPos.I;
				::Game.pDatabase.MapPos.I = pMapPos.J;

				::Game.pDatabase.Map.push({Type=1, I=pMapPos.I, J=pMapPos.J});

				::Game.SaveGame();
			}
			else
			{
				//Loose
				::print("!Player loose. Point (" + pMapPos.I + ", " + pMapPos.J + ") still unexplored.\n");
			}

			::Game.PushScreen(::Game.pDebrifScreen);
			::Game.pDebrifScreen.Setup(pPlayerSquads.len() > 0, pPlayerSquads.len(), pAISquads.len());
		}
		else
		if(pCurrentSquad == _squad)
		{
			::print("[CBattleScreen]: Removing current squad.\n");

			pCurrentSquad = null;
			NextTurn();
		}
	}

	function TapOnSquad(_squad)
	{
		if(pCurrentSquad.pFraction != EBattleFraction.PLAYER || _squad.pFraction == EBattleFraction.PLAYER)
		{
			return;
		}

		pBattleMap.ClearPossibleMoves();
		pCurrentSquad.AttackTo(_squad);
	}

	function TapOnTile(tile)
	{
		if(pCurrentSquad.pFraction != EBattleFraction.PLAYER)
		{
			return;
		}

		if(tile.ID == EBattleTileType.CANMOVE)
		{
			pBattleMap.ClearPossibleMoves();
			pCurrentSquad.MoveTo(tile.I, tile.J);
		}
	}

	function InputGesture(type, p1, p2)
	{	
		if(type == 3)
		{
			foreach(sq in pPlayerSquads)
			{
				if(sq.HitTest(p1, p2))
				{
					TapOnSquad(sq);
					return;
				}
			}

			foreach(sq in pAISquads)
			{
				if(sq.HitTest(p1, p2))
				{
					TapOnSquad(sq);
					return;
				}
			}

			local tile = pBattleMap.GetTileXY(p1, p2);

			if(tile)
			{
				TapOnTile(tile);
			}

			::Game.Input.DropEvent();
		}
	}

	function HandleExitButton(_btn)
	{
		if(_btn == pExitButton)
		{
			::print("Exit the battle.\n");
			::Game.ReplaceScreen(::Game.pBaseScreen);
		}
	}

	function HandleNextTurnButton(_btn)
	{
		if(_btn == pNextTurnButton)
		{
			::print("[CBattleScreen] Next turn button pressed.\n");
			pBattleMap.ClearPossibleMoves();
			NextTurn();
		}
	}
}