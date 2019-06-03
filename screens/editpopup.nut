class CEditPopup extends CNode2D
{
	pAcept = null;
	pCancel = null;
	
	pEnviropment = null;
	fAcceptHandler = null;
	fCancelHandler = null;
	
	constructor(_env, _acphdlr, _canchdlr)
	{
		base.constructor();
		
		pEnviropment = _env;
		fAcceptHandler = _acphdlr;
		fCancelHandler = _canchdlr;
		
		pAcept = ::CIconButton("data/checkmark.png", [0,0,50,50], [50,0,50,50], fAcceptHandler, pEnviropment);
		pAcept.SetPosition(-57, -80);
		
		AddChild(pAcept);
		
		pCancel = ::CIconButton("data/cross.png", [0,0,50,50], [50,0,50,50], fCancelHandler, pEnviropment);
		pCancel.SetPosition(0, -80);
		
		AddChild(pCancel);
	}
	
	function AllowAccept(_allow)
	{
		pAcept.SetEnabled(_allow);
	}
}