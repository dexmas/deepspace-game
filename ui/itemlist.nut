
class CItemList extends CPanel
{
	pItems = null;
	
	pItemList = null;
	pItemView = null;
	
	pLastItemPos = null;
	
	pScrollPos = null;
	pScrollBack = null;
	pScrollFront = null;
	pScrollMax = null;
	pScrollSize = null;
	
	bMovingList = null;
	bMovingBar = null;
	
	pItemWidth = null;
	pItemHeight = null;
	pItemSpace = null;
	
	fCallback = null;
	pEnvironment  = null;
	
	bVertical = null;
	
	constructor(_parent, _w, _h, _iw, _ih, _skin, _callback = null, _environment = null, _vert = false)
	{
		base.constructor(_parent, _w, _h, _skin);
		
		pItems = [];
		
		fCallback = _callback;
		pEnvironment = _environment;
		
		bVertical = _vert;
		pItemWidth = _iw;
		pItemHeight = _ih;
		pItemSpace = 10;

		local parentSize = pParent.GetSize();

		if(_iw <= 1.0)
		{
			pItemWidth = parentSize.X * _iw;
		}
		if(_ih <= 1.0)
		{
			pItemHeight = parentSize.Y * pItemHeight;
		}
		
		local baseSize = base.GetSize();

		pItemList = ::CNode2D();
		
		pItemView = ::CNode2D();
		pItemView.SetPosition(pItemSpace, pItemSpace);
		
		pItemView.SetSize(baseSize.X - pItemSpace * 2, pItemHeight);
		
		pScrollSize = 0;
		pScrollMax = 0;
		
		pScrollBack = ::CBar(pItemView.GetSize().X, ::GUISkinProgress.Back);
		pScrollBack.SetPosition(pItemSpace, pItemView.GetSize().Y + pItemSpace * 2);
	
		pScrollFront = ::CBar(pScrollSize, ::GUISkinProgress.Scroll);
		pScrollFront.SetPosition(2, 2);
		
		pItemView.SetClip(true);
		pItemView.AddChild(pItemList);
		
		AddChild(pItemView);
		
		SetSize(baseSize.X, pScrollBack.GetPosition().Y + pScrollBack.GetSize().Y + pItemSpace);
		
		pScrollFront.SetEnabled(false);
		
		pScrollBack.AddChild(pScrollFront);
		AddChild(pScrollBack);
		
		if(bVertical)
		{
			SetRotation(-90);
		}
		
		pLastItemPos = 0;
		pScrollPos = 0;
		
		bMovingList = false;
		bMovingBar = false;
	}
	
	function AddItem(_name)
	{
		local item = ::CButton(pItemList, _name, pItemWidth, pItemHeight, ::GUISkinButton, HandleButton, this);
		
		item.SetPosition(pLastItemPos, 0);
		pLastItemPos += (pItemWidth + pItemSpace);
		
		item.SetName(_name);
		
		pItems.push(item);
		
		UpdateScrollSize();
		
		return item;
	}
	
	function RemoveItem(_item)
	{
		local idx = pItems.find(_item);
		
		if(idx != null)
		{
			pItems.remove(idx);
		}
		
		_item = null;
		
		UpdateScrollSize();
	}
	
	function Clean()
	{
		foreach(itm in pItems)
		{
			RemoveItem(itm);
		}
	}
	
	function UpdateScrollSize()
	{
		pScrollSize = pItemView.GetSize().X * (pItemView.GetSize().X/((pItemWidth+pItemSpace) * pItems.len() - pItemSpace));
		
		if(pScrollSize > 6 && pScrollSize < pItemView.GetSize().X - 2 * 2)
		{
			pScrollMax = pItemView.GetSize().X - pScrollSize - 2;
			pScrollFront.SetSize(pScrollSize, 0);
			pScrollFront.SetEnabled(true);
		}
		else
		{
			pScrollSize = 0;
			pScrollMax = 0;
			pScrollFront.SetEnabled(false);
		}
		
		Scroll(0);
	}
	
	function HandleButton(btn)
	{
		if(fCallback)
		{
			fCallback.call(pEnvironment, btn);
		}
	}
	
	function Scroll(dx)
	{
		pScrollPos -= dx;
		
		local maxScroll;

		maxScroll = ((pItemWidth+pItemSpace) * pItems.len() - pItemSpace) - pItemView.GetSize().X;
		
		if(maxScroll < 0)
		{
			maxScroll = 0;
		}
		
		if(pScrollPos < 0)
		{
			pScrollPos = 0;
		}
		else
		if(pScrollPos > maxScroll)
		{
			pScrollPos = maxScroll;
		}
		
		pItemList.SetPosition(-pScrollPos, 0);
		
		if(maxScroll > 0)
		{
			local sbarpos = 2 + (pScrollMax - 2) * (pScrollPos / maxScroll);
			pScrollFront.SetPosition(sbarpos, 2);
		}
	}
	
	function InputTouch(id, state, x, y)
	{
		if(HitTest(x, y))
		{
			if(state == 0)
			{
				bMovingList = pItemView.HitTest(x,y);
				bMovingBar = pScrollFront.HitTest(x,y);
			}
			else
			if(state == 2 || state == 3)
			{
				bMovingList = false;
				bMovingBar = false;
			}
		
			::Game.Input.DropEvent();
		}
	}
	
	function InputGesture(type, p1, p2)
	{	
		if(type == 2)
		{
			local delta = 0.0;
			
			if(bVertical)
			{
				delta = p2;
			}
			else
			{
				delta = p1;
			}
			
			if(bMovingList)
			{
				Scroll(delta);
			}
			else
			if(bMovingBar)
			{
				Scroll(-delta);
			}

			::Game.Input.DropEvent();
		}
	}
}