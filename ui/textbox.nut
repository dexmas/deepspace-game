class CTextBox extends CText2D
{
	constructor(text, w, h, skin, halig, valig)
	{
		base.constructor();
		
		SetFont(::Game.AssetsDB.GetFont(skin.FontPath));
		SetSize(w, h);
		SetAlignment(halig, valig);
		SetColor(skin.Color[0], skin.Color[1], skin.Color[2], skin.Color[3]);
		SetText(text);
	}
}