
class CBar extends CNode2D
{
	pBegin = null;
	pEnd = null;
	pMiddle = null;
	
	pSkin = null;
	
	constructor(_w, _skin)
	{
		base.constructor();

		pSkin = _skin;
		
		local texture = ::Game.AssetsDB.GetTexture(pSkin.TexturePath);
		local width = pSkin.Slice3.W;
		local height = pSkin.Slice3.H;
		
		if(_w < width)
		{
			_w = width;
		}
		
		pBegin  = ::CSprite2D();
		pEnd    = ::CSprite2D();
		pMiddle = ::CSprite2D();
		
		pBegin.SetTexture(texture);
		pBegin.SetFrame(pSkin.Slice3.X, pSkin.Slice3.Y, pSkin.Slice3.L, height);
		pBegin.SetSize(pSkin.Slice3.L, pSkin.Slice3.H);
		pBegin.SetPosition(0, 0);

		pMiddle.SetTexture(texture);
		pMiddle.SetFrame(pSkin.Slice3.X + pSkin.Slice3.L, pSkin.Slice3.Y, pSkin.Slice3.W - pSkin.Slice3.L - pSkin.Slice3.R, height);
		pMiddle.SetSize(_w - pSkin.Slice3.L - pSkin.Slice3.R, height);
		pMiddle.SetPosition(pSkin.Slice3.L, 0);
		
		pEnd.SetTexture(texture);
		pEnd.SetFrame(pSkin.Slice3.X + (pSkin.Slice3.W - pSkin.Slice3.R), pSkin.Slice3.Y, pSkin.Slice3.R, height);
		pEnd.SetSize(pSkin.Slice3.R, height);
		pEnd.SetPosition(_w - pSkin.Slice3.R,0);
		
		AddChild(pBegin);
		AddChild(pMiddle);
		AddChild(pEnd);
		
		base.SetSize(_w, height);
	}
	
	function SetSize(_w, _h)
	{
		local width = pSkin.Slice3.W;
		local height = pSkin.Slice3.H;
		
		if(_w < width)
		{
			_w = width;
		}
		
		base.SetSize(_w, height);
		
		pMiddle.SetSize(_w - pSkin.Slice3.L - pSkin.Slice3.R, height);
		pEnd.SetPosition(_w - pSkin.Slice3.R,0);
	}
	
	function InputTouch(i, state, x, y)
	{
		return HitTest(x, y);
	}
}