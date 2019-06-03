class CBuilder extends CNode2D
{
	pProgress = null;
	pProgressText = null;
	pBuilding = null;
	pBuildTime = null;
	pTimer = null;
	
	constructor(_building, _buildtime)
	{
		base.constructor();
		
		pBuilding = _building;
		pBuildTime = _buildtime;
		pTimer = 0.0;
		
		pProgress = ::CProgress2D();
		pProgress.SetTexture(::Game.AssetsDB.GetTexture("data/tileset.png"));
		pProgress.SetFrame(0, 192, 64, 64);
		pProgress.SetType(1);
		
		pProgressText = ::CText2D();
		pProgressText.SetFont(::Game.AssetsDB.GetFont("data/gui_font.xml"));
		pProgressText.SetPosition(0, 0);
		pProgressText.SetAlignment(1,1);
		pProgressText.SetScale(0.7, 0.7);
		pProgressText.SetText("0%");
		
		pProgress.AddChild(pProgressText);
		
		AddChild(pProgress);
	}
	
	function Update(dt)
	{
		if(pTimer < pBuildTime)
		{
			pTimer += dt;
			
			if(pTimer > pBuildTime)
			{
				pBuilding.OnBuildingFinished();
			}
			else
			{
				local progress = pTimer / pBuildTime;
				
				pProgress.SetValue(progress);
				pProgressText.SetText((progress * 100.0).tointeger() + "%");
			}
		}
	}
}