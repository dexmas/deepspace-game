

class CPanel extends CNode2D
{
	pCorners = null;
	pBorders = null;
	pBackground = null;
	
	pSkin = null;

	constructor(_w, _h, _skin)
	{
		base.constructor();
		
		pSkin = _skin;

		local texture = ::Game.AssetsDB.GetTexture(pSkin.TexturePath);
		local width = pSkin.Slice9.W;
		local height = pSkin.Slice9.H;
		
		if(_w < width)
		{
			_w = width;
		}
		if(_h < height)
		{
			_h = height;
		}

		pCorners = [];

		pCorners.push(::CSprite2D());
		pCorners.push(::CSprite2D());
		pCorners.push(::CSprite2D());
		pCorners.push(::CSprite2D());

		pBorders = [];

		pBorders.push(::CSprite2D());
		pBorders.push(::CSprite2D());
		pBorders.push(::CSprite2D());
		pBorders.push(::CSprite2D());

		pBackground = ::CSprite2D();
		pBackground.SetTexture(texture);
		pBackground.SetFrame(pSkin.Slice9.X + pSkin.Slice9.L, pSkin.Slice9.Y + pSkin.Slice9.T, pSkin.Slice9.W - pSkin.Slice9.R - pSkin.Slice9.L, pSkin.Slice9.H - pSkin.Slice9.B - pSkin.Slice9.T);
		pBackground.SetSize(_w - pSkin.Slice9.L - pSkin.Slice9.R, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		pBackground.SetPosition(pSkin.Slice9.L, pSkin.Slice9.T)

		pCorners[0].SetFrame(pSkin.Slice9.X, pSkin.Slice9.Y, pSkin.Slice9.L, pSkin.Slice9.T);
		pCorners[0].SetSize(pSkin.Slice9.L, pSkin.Slice9.T);
		pCorners[0].SetPosition(0, 0);

		pCorners[1].SetFrame(pSkin.Slice9.X, pSkin.Slice9.Y + (pSkin.Slice9.H - pSkin.Slice9.B), pSkin.Slice9.L, pSkin.Slice9.B);
		pCorners[1].SetSize(pSkin.Slice9.L,pSkin.Slice9.B);
		pCorners[1].SetPosition(0, _h - pSkin.Slice9.B);
		
		pCorners[2].SetFrame(pSkin.Slice9.X + (pSkin.Slice9.W - pSkin.Slice9.R), pSkin.Slice9.Y, pSkin.Slice9.R, pSkin.Slice9.T);
		pCorners[2].SetSize(pSkin.Slice9.R, pSkin.Slice9.T);
		pCorners[2].SetPosition(_w - pSkin.Slice9.R,0);

		pCorners[3].SetFrame(pSkin.Slice9.X + (pSkin.Slice9.W - pSkin.Slice9.R), pSkin.Slice9.Y + (pSkin.Slice9.H - pSkin.Slice9.B), pSkin.Slice9.R, pSkin.Slice9.B);
		pCorners[3].SetSize(pSkin.Slice9.R, pSkin.Slice9.B);
		pCorners[3].SetPosition(_w - pSkin.Slice9.R, _h - pSkin.Slice9.B);

		pBorders[0].SetFrame(pSkin.Slice9.X + pSkin.Slice9.L, pSkin.Slice9.Y, pSkin.Slice9.W - pSkin.Slice9.R - pSkin.Slice9.L, pSkin.Slice9.T);
		pBorders[0].SetSize(_w - (pSkin.Slice9.L + pSkin.Slice9.R), pSkin.Slice9.T);
		pBorders[0].SetPosition(pSkin.Slice9.L, 0);

		pBorders[1].SetFrame(pSkin.Slice9.X + pSkin.Slice9.L, pSkin.Slice9.Y + (pSkin.Slice9.H - pSkin.Slice9.B), pSkin.Slice9.W - pSkin.Slice9.R - pSkin.Slice9.L, pSkin.Slice9.B);
		pBorders[1].SetSize(_w - (pSkin.Slice9.L + pSkin.Slice9.R), pSkin.Slice9.B);
		pBorders[1].SetPosition(pSkin.Slice9.L, _h - pSkin.Slice9.B);

		pBorders[2].SetFrame(pSkin.Slice9.X, pSkin.Slice9.Y + pSkin.Slice9.T, pSkin.Slice9.L, pSkin.Slice9.H - pSkin.Slice9.B - pSkin.Slice9.T);
		pBorders[2].SetSize(pSkin.Slice9.L, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		pBorders[2].SetPosition(0, pSkin.Slice9.T);

		pBorders[3].SetFrame(pSkin.Slice9.X + (pSkin.Slice9.W - pSkin.Slice9.R), pSkin.Slice9.Y + pSkin.Slice9.T, pSkin.Slice9.R, pSkin.Slice9.H - pSkin.Slice9.B - pSkin.Slice9.T);
		pBorders[3].SetSize(pSkin.Slice9.R, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		pBorders[3].SetPosition(_w - pSkin.Slice9.R, pSkin.Slice9.T);

		AddChild(pBackground);

		foreach(cor in pCorners)
		{
			cor.SetTexture(texture);
			AddChild(cor);
		}

		foreach(bor in pBorders)
		{
			bor.SetTexture(texture);
			AddChild(bor);
		}
		
		base.SetSize(_w, _h);
	}
	
	function SetSize(_w, _h)
	{
		local width = pSkin.Slice9.W;
		local height = pSkin.Slice9.H;
		
		if(_w < width)
		{
			_w = width;
		}
		if(_h < height)
		{
			_h = height;
		}
		
		pBackground.SetSize(_w - pSkin.Slice9.L - pSkin.Slice9.R, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		
		pCorners[1].SetPosition(0, _h - pSkin.Slice9.B);
		pCorners[2].SetPosition(_w - pSkin.Slice9.R,0);
		pCorners[3].SetPosition(_w - pSkin.Slice9.R, _h - pSkin.Slice9.B);
		pCorners[3].SetPosition(_w - pSkin.Slice9.R, _h - pSkin.Slice9.B);
		
		pBorders[0].SetSize(_w - (pSkin.Slice9.L + pSkin.Slice9.R), pSkin.Slice9.T);
		pBorders[1].SetSize(_w - (pSkin.Slice9.L + pSkin.Slice9.R), pSkin.Slice9.B);
		pBorders[1].SetPosition(pSkin.Slice9.L, _h - pSkin.Slice9.B);
		pBorders[2].SetSize(pSkin.Slice9.L, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		pBorders[3].SetSize(pSkin.Slice9.R, _h - pSkin.Slice9.T - pSkin.Slice9.B);
		pBorders[3].SetPosition(_w - pSkin.Slice9.R, pSkin.Slice9.T);
		
		base.SetSize(_w, _h);
	}
	
	function InputTouch(id, state, x, y)
	{
		
	}
	
	function InputGesture(type, p1, p2)
	{
		
	}
}