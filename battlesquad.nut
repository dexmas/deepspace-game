
enum EBattleSquadType
{
	FIGHTER = 1,
	CRUISER = 2
}

enum EBattleFraction
{
	PLAYER = 0,
	ENEMY = 1
}

enum EBattleSquadState
{
	IDDLE = 0,
	MOVE = 1,
	ATTACK = 2,
	DAMAGE = 3,
	DIE = 4
}

class CBattleSquad extends CNode2D
{
	pType = null;
	pFraction = null;

	pMaxCount = null;
	pCount = null;
	pMaxHealth = null;
	pHealth = null;
	pMinDamage = null;
	pMaxDamage = null;
	pMaxSteps = null;
	pSteps = null;
	pAttackDistance = null;

	I = null;
	J = null;

	pMap = null;
	pPos = null;
	bTouched = null;
	bSelected = null;

	pCountText = null;

	pState = null;
	pPath = null;
	pAnimTimer = null;

	pSprite = null;
	pActiveMark = null;
	pCenter = null;
	pColor = null;
	pTarget = null;
	pDamage = null;
	pNextTurn = null;

	constructor(_i, _j, _proto, _fract)
	{
		base.constructor();

		bTouched = false;
		bSelected = false;

		pFraction = _fract;
		pType = _proto.Type;
		pMaxCount = _proto.Count;
		pCount = _proto.Count;
		pMaxHealth = _proto.Health;
		pHealth = _proto.Health;
		pMinDamage = _proto.MinDamage;
		pMaxDamage = _proto.MaxDamage;
		pMaxSteps = _proto.Steps;
		pSteps = _proto.Steps;
		pAttackDistance = _proto.AttackDistance;

		pState = EBattleSquadState.IDDLE;
		pAnimTimer = 0.0;

		pCenter = _proto.Center;
		pColor = _proto.Color;
		pTarget = null;
		pDamage = 0;
		pNextTurn = false;

		SetSize(_proto.Frame[2], _proto.Frame[3]);
		SetCenter(pCenter[0], pCenter[1]);

		pSprite = ::CSprite2D();
		pSprite.SetTexture(::Game.AssetsDB.GetTexture(_proto.Texture));
		pSprite.SetFrame(_proto.Frame[0], _proto.Frame[1], _proto.Frame[2], _proto.Frame[3]);
		pSprite.SetCenter(pCenter[0], pCenter[1]);
		pSprite.SetColor(pColor[0], pColor[1], pColor[2], pColor[3]);

		pActiveMark = ::CSprite2D();
		pActiveMark.SetTexture(::Game.AssetsDB.GetTexture("data/ships_icons.png"));
		pActiveMark.SetFrame(64*0, 64*0, 64, 64);
		pActiveMark.SetCenter(32, 32);

		if(pFraction != EBattleFraction.PLAYER)
		{
			pSprite.SetRotation(-90.0);
		}
		else
		{
			pSprite.SetRotation(90.0);
		}

		AddChild(pSprite);
		AddChild(pActiveMark);

		pActiveMark.SetEnabled(false);

		I = _i;
		J = _j;

		pMap = ::Game.pBattleScreen.pBattleMap.weakref();

		local tile = pMap.GetTileIJ(I, J);
		pPos = ::CVector2(tile.X + pMap.cTileSizeX/2.0, tile.Y + pMap.cTileSizeY/2.0);

		pMap.SetTileFlags(I, J, 0);
		
		SetPosition(pPos.X, pPos.Y);

		pCountText = ::CText2D();
		pCountText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pCountText.SetAlignment(1,1);
		pCountText.SetScale(0.4, 0.4);
		pCountText.SetText(pCount + "/" + pMaxCount);
		pCountText.SetPosition(20, -20);

		AddChild(pCountText);
	}

	function RotateTo(_x, _y)
	{
		local rot = ::Math.Atan2(pPos.X - _x, _y - pPos.Y);
		pSprite.SetRotation(rot + 180);
	}

	function StartTurn()
	{
		pNextTurn = false;
		pSteps = pMaxSteps;
		pAnimTimer = 0;
		pActiveMark.SetEnabled(true);
	}

	function EndTurn()
	{
		pActiveMark.SetEnabled(false);
	}

	function GetDamage()
	{
		local minDamage = pMinDamage * pCount;
		local maxDamage = pMaxCount * pCount;

		local damage = ::Math.Rand(minDamage, maxDamage);

		return damage;
	}

	function RecieveDamage(_damage)
	{
		::print("[BattleSquad]: Recieve " + pDamage + " damage.\n");

		while(_damage >= pHealth)
		{
			_damage -= pHealth;

			pCount--;
			pHealth = pMaxHealth;

			pCountText.SetText(pCount + "/" + pMaxCount);

			if(pCount <= 0)
			{
				Die();

				return;
			}
		}

		pHealth -= _damage;

		if(pNextTurn)
		{
			::Game.pBattleScreen.NextTurn();
		}
	}

	function MoveTo(_i, _j)
	{
		if(pState != EBattleSquadState.IDDLE)
		{
			return;
		}

		pTarget = null;
		pPath = [];

		if(pMap.CalcPath(I, J, _i, _j, 1, pPath))
		{
			::print("[BattleSquad]: Move to: (" + pPath[pPath.len() - 1].I + ", " + pPath[pPath.len() - 1].J + ")\n");

			pState = EBattleSquadState.MOVE;
			pAnimTimer = 0.0;
		}
		else
		{
			::print("[BattleSquad]: No way to target. End move.\n");

			pState = EBattleSquadState.IDDLE;

			::Game.pBattleScreen.NextTurn();
		}
	}

	function AttackTo(_target)
	{
		if(pState != EBattleSquadState.IDDLE || !_target)
		{
			return;
		}

		pAnimTimer = 0.0;
		pTarget = null;
		pPath = [];

		if(!pMap.CalcPath(I, J, _target.I, _target.J, 0, pPath) || !pPath.len())
		{
			::print("[BattleSquad] Error while attack. Can't find tile. '" + _target.GetName() + "'.\n");

			::Game.pBattleScreen.NextTurn();

			return;
		}

		if(pPath.len() <= pAttackDistance)
		{
			pTarget = _target;
			pState = EBattleSquadState.ATTACK;
		}
		else
		{
			//Get path to target
			local tile = pMap.GetTileIJ(_target.I, _target.J);
			local flags = tile.Flags;
			tile.Flags = 1;
			pPath = [];

			if(tile && pMap.CalcPath(I, J, tile.I, tile.J, 1, pPath) && pPath.len() > 1)
			{
				pPath.pop();
				tile.Flags = flags;
				pTarget = _target;

				if(pPath.len() >= pSteps)
				{
					pPath.resize(pSteps)
					pTarget = null;
				}

				::print("[BattleSquad] Move to '" + _target.GetName() + "' for attack it.\n");

				pState = EBattleSquadState.MOVE;
			}
			else
			{
				::print("[BattleSquad] No way to target for attack. End move.\n");

				tile.Flags = flags;
				::Game.pBattleScreen.NextTurn();
			}
		}
	}

	function Damage(_value, _nextTurn = false)
	{
		::print("[BattleSquad]: Damage.\n");

		if(pState != EBattleSquadState.IDDLE)
		{
			return;
		}

		pDamage = _value;

		pNextTurn = _nextTurn;

		pState = EBattleSquadState.DAMAGE;

		pAnimTimer = 0.0;
	}

	function Die()
	{
		::print("[BattleSquad]: Die.\n");

		if(pState != EBattleSquadState.IDDLE)
		{
			return;
		}

		pState = EBattleSquadState.DIE;

		pMap.SetTileFlags(I, J, 1);

		pAnimTimer = 0.0;
	}

	function Update(_dt)
	{
		if(pState == EBattleSquadState.IDDLE)
		{
		}
		else
		if(pState == EBattleSquadState.MOVE)
		{
			pAnimTimer += _dt;

			if(pAnimTimer > 1.0)
			{
				pMap.SetTileFlags(I, J, 1);

				I = pPath[0].I;
				J = pPath[0].J;

				pMap.SetTileFlags(I, J, 0);

				local tile = pMap.GetTileIJ(I, J);
				pPos = ::CVector2(tile.X + pMap.cTileSizeX/2.0, tile.Y + pMap.cTileSizeY/2.0);

				pPath.remove(0);

				pSteps--;

				pAnimTimer = 0.0;

				if(!pPath.len())
				{
					if(pTarget)
					{
						::print("[BattleSquad] Target reached. Start attack.\n");

						pState = EBattleSquadState.ATTACK;
					}
					else
					{
						::print("[BattleSquad] End move. Steps left: " + pSteps + "\n");

						pState = EBattleSquadState.IDDLE;

						if(pSteps <= 0)
						{
							::Game.pBattleScreen.NextTurn();
						}
						else
						{
							pMap.MarkPossibleMoves(I, J, pSteps);
						}
					}
				}
			}
			else
			{
				local prevTile = pMap.GetTileIJ(I, J);
				local nextTile = pMap.GetTileIJ(pPath[0].I, pPath[0].J);

				local prevCellPos = ::CVector2(prevTile.X + pMap.cTileSizeX/2.0, prevTile.Y + pMap.cTileSizeY/2.0);
				local nextCellPos = ::CVector2(nextTile.X + pMap.cTileSizeX/2.0, nextTile.Y + pMap.cTileSizeY/2.0);

				pPos.Interpolate(prevCellPos, nextCellPos, pAnimTimer);

				RotateTo(nextCellPos.X, nextCellPos.Y);
			}

			SetPosition(pPos.X, pPos.Y);
		}
		else
		if(pState == EBattleSquadState.ATTACK)
		{
			pAnimTimer += _dt;

			if(pAnimTimer > 1.0)
			{
				pSteps--;

				SetCenter(pCenter[0], pCenter[1]);

				pState = EBattleSquadState.IDDLE;

				pTarget.Damage(GetDamage(), true);

				pTarget = null;
			}
			else
			{
				local mult = ::Math.Sin(::Math.RADTODEG * (pAnimTimer * ::Math.PI));

				pSprite.SetCenter(pCenter[0], pCenter[1]  + mult * 15);

				RotateTo(pTarget.pPos.X, pTarget.pPos.Y);
			}
		}
		else
		if(pState == EBattleSquadState.DAMAGE)
		{
			pAnimTimer += _dt;

			if(pAnimTimer > 1.0)
			{
				SetCenter(pCenter[0], pCenter[1]);

				pState = EBattleSquadState.IDDLE;

				pAnimTimer = 0.0;

				RecieveDamage(pDamage);
			}
			else
			{
				local mult = ::Math.Sin(::Math.RADTODEG * (pAnimTimer * ::Math.PI));

				pSprite.SetCenter(pCenter[0], pCenter[1]  - mult * 15);
			}
		}
		else
		if(pState == EBattleSquadState.DIE)
		{
			pAnimTimer += _dt;

			if(pAnimTimer > 1.0)
			{
				::Game.pBattleScreen.RemoveSquad(this);

				if(pNextTurn)
				{
					::Game.pBattleScreen.NextTurn();
				}
			}
			else
			{
				local mult = 1.0 - pAnimTimer;
				pSprite.SetColor(pColor[0], pColor[1], pColor[2], mult * pColor[3]);
			}
		}
	}
}