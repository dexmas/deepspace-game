class CIconButton extends CSprite2D
{
	pFrame1 = null;
	pFrame2 = null;
	
	fCallback = null;
	pEnvironment  = null;
	
	bMouseBtnPressed = null;
	bLocked = null;
	pParent = null;
	
	constructor(_parent, _texture, _frame1, _frame2 = null, _callback = null, _environment = null)
	{
		base.constructor();
		
		pFrame1 = _frame1;
		pFrame2 = _frame2;

		pParent = _parent.weakref();
		
		SetTexture(::Game.AssetsDB.GetTexture(_texture));
		SetFrame(pFrame1[0], pFrame1[1], pFrame1[2], pFrame1[3]);
		
		SetPressed(false);
		
		fCallback = _callback;
		pEnvironment = _environment;
		
		bMouseBtnPressed = false;
		bLocked = false;

		pParent.AddChild(this);
	}

	function SetPosition(_x, _y)
	{
		local size = GetSize();
		local parentSize = pParent.GetSize();

		if(_x != 0 && _x <= 1.0 && _x >= -1.0)
		{
			_x = parentSize.X * _x - size.X * 0.5;
		}
		if(_y != 0 && _y <= 1.0 && _y >= -1.0)
		{
			_y = parentSize.Y * _y - size.Y * 0.5;
		}

		base.SetPosition(_x, _y);
	}
	
	function SetPressed(pressed)
	{
		if(pFrame2 != null)
		{
			if(pressed)
				SetFrame(pFrame2[0], pFrame2[1], pFrame2[2], pFrame2[3]);
			else
				SetFrame(pFrame1[0], pFrame1[1], pFrame1[2], pFrame1[3]);
		}
		else
		{
			local color = [1.0,1.0,1.0,1.0];

			if(pressed)
				color = [0.5,0.5,0.5,1.0];
		
			SetColor(color[0], color[1], color[2], color[3]);
		}
	}
	
	function Lock()
	{
		if(!bLocked)
		{
			SetColor(0.3, 0.3, 0.3, 1.0);

			bLocked = true;
		}
	}
	
	function Unlock()
	{
		if(bLocked)
		{
			SetColor(1.0, 1.0, 1.0, 1.0);

			bLocked = false;
		}
	}

	function InputTouch(id, state, x, y)
	{
		local hit = HitTest(x,y);

		if(!bLocked)
		{
			SetPressed(hit && (state == 0 || state == 1));
		}
	}
	
	function InputGesture(type, p1, p2)
	{	
		if(type == 3 && HitTest(p1, p2))
		{
			if(!bLocked)
			{
				SetPressed(false);
				fCallback.call(pEnvironment, this);
			}

			::Game.Input.DropEvent();
		}
	}
}