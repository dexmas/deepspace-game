class CFabricator extends CNode2D
{
	//pProgress = null;
	pProgressText = null;
	pBuilding = null;
	pAmount = null;
	pProductivity = null;
	pCapacity = null;
	
	constructor(_building, _capacity, _productivity)
	{
		base.constructor();
		
		pBuilding = _building;
		pCapacity = _capacity;
		pProductivity = _productivity;
		pAmount = 0.0;
		
		/*pProgress = ::CProgress2D();
		pProgress.SetTexture(::Game.AssetsDB.GetTexture("data/tileset.png"));
		pProgress.SetFrame(0, 128, 64, 64);
		pProgress.SetType(1);*/
		
		pProgressText = ::CText2D();
		pProgressText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pProgressText.SetPosition(0, -25);
		pProgressText.SetAlignment(1,1);
		pProgressText.SetScale(0.4, 0.4);
		pProgressText.SetText("0%");
		
		//AddChild(pProgress);
		AddChild(pProgressText);
	}
	
	function Claim()
	{
		pAmount = 0.0;
		
		pProgressText.SetColor(1.0, 1.0, 1.0, 1.0);
		pProgressText.SetText("0%");
	}
	
	function Update(dt)
	{
		if(pAmount < pCapacity)
		{
			pAmount += dt * pProductivity;
			
			if(pAmount > pCapacity)
			{
				pAmount = pCapacity;
				pBuilding.OnFabricateFinished();
				
				pProgressText.SetColor(1.0, 0.0, 0.0, 1.0);
				pProgressText.SetText("DONE");
			}
			else
			{
				local progress = pAmount / pCapacity;
				
				//pProgress.SetValue(progress);
				pProgressText.SetText((progress * 100.0).tointeger() + "%");
			}
		}
	}
}