

class CProgress extends CNode2D
{
	pBack = null;
	pFront = null;
	pSkin = null;

	Value = null;
	Width = null;
	Height = null;
	
	pTimer = null;

	constructor(_w, _h, _skin)
	{
		base.constructor();
		
		pSkin = _skin;

		pBack = ::CBar(_w, pSkin.Back);
		pFront = ::CBar(_w, pSkin.Front);
		
		Width = _w;
		Height = _h;

		AddChild(pBack);
		AddChild(pFront);
		
		base.SetSize(_w, _h);

		SetValue(0.0);
		
		pTimer = 0.0;
	}

	function SetValue(_val)
	{
		if(_val < 0.0)
			_val = 0.0;
		
		if(_val > 1.0)
			_val = 1.0;

		Value = _val;
		
		pFront.SetSize(Width * _val, Height);
	}
	
	function SetSize(_w, _h)
	{
		Width = _w;
		Height = _h;
		
		pBack.SetSize(Width, Height);
		pFront.SetSize(Width * Value, Height);
		
		base.SetSize(_w, _h);
	}
	
	function InputTouch(i, state, x, y)
	{
		return HitTest(x, y);
	}
	
	function Update(_dt)
	{
		pTimer += _dt * 12.0;
		SetValue(::Math.Abs(::Math.Sin(pTimer)));
	}
}