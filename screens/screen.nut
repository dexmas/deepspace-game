
class CGameScreen extends CNode2D
{
	constructor()
	{
		base.constructor();
	
		local sw = ::Game.ScreenWidth;
		local sh = ::Game.ScreenHeight;
		
		SetSize(sw, sh);
	}

	function Load()
	{
	}
	
	function Unload()
	{
	}
	
	function InputTouch(i, state, x, y)
	{
		::Game.Input.DropEvent();
	}
	
	function InputGesture(type, p1, p2)
	{
		::Game.Input.DropEvent();
	}
}