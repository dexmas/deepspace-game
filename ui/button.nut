class CButton extends CPanel
{
	pText = null;

	fCallback = null;
	pEnvironment  = null;
	bMouseBtnPressed = null;
	bLocked = null;

	constructor(_parent, text, w, h, skin, callback = null, environment = null)
	{
		base.constructor(_parent, w, h, skin);

		pText = ::CText2D();
		pText.SetFont(::Game.AssetsDB.GetFont(skin.FontPath));
		pText.SetPosition(w/2.0, h/2.0);
		pText.SetAlignment(1,1);
		pText.SetText(text);

		AddChild(pText);

		SetPressed(false);

		fCallback = callback;
		pEnvironment = environment;
		
		bMouseBtnPressed = false;
		bLocked = false;
	}
	
	function SetText(_text)
	{
		pText.SetText(_text);
	}

	function SetPressed(pressed)
	{
		if(bLocked)
		{
			return;
		}
			
		local color = [1.0,1.0,1.0,1.0];

		if(pressed)
			color = [0.5,0.5,0.5,1.0];
		
		foreach(cor in pCorners)
		{
			cor.SetColor(color[0], color[1], color[2], color[3]);
		}

		foreach(bor in pBorders)
		{
			bor.SetColor(color[0], color[1], color[2], color[3]);
		}

		pBackground.SetColor(color[0], color[1], color[2], color[3]);
	}
	
	function Lock()
	{
		if(!bLocked)
		{
			::print("Button locked.\n");
			
			local color = [0.3,0.3,0.3,1.0];
			
			foreach(cor in pCorners)
			{
				cor.SetColor(color[0], color[1], color[2], color[3]);
			}

			foreach(bor in pBorders)
			{
				bor.SetColor(color[0], color[1], color[2], color[3]);
			}

			pBackground.SetColor(color[0], color[1], color[2], color[3]);
		
			bLocked = true;
		}
	}
	
	function Unlock()
	{
		if(bLocked)
		{
			::print("Button unlocked.\n");
			
			local color = [1.0,1.0,1.0,1.0];
			
			foreach(cor in pCorners)
			{
				cor.SetColor(color[0], color[1], color[2], color[3]);
			}

			foreach(bor in pBorders)
			{
				bor.SetColor(color[0], color[1], color[2], color[3]);
			}

			pBackground.SetColor(color[0], color[1], color[2], color[3]);
			
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
			
				if(fCallback)
				{
					fCallback.call(pEnvironment, this);
				}
			}
			::Game.Input.DropEvent();
		}
	}
}