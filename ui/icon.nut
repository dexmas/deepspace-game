class CIcon extends CSprite2D
{
	constructor(_texture, _rect)
	{
		base.constructor();
		
		SetTexture(::Game.AssetsDB.GetTexture(_texture));
		SetFrame(_rect[0], _rect[1], _rect[2], _rect[3]);
	}
	
	function InputTouch(i, state, x, y)
	{
		return HitTest(x, y);
	}
}