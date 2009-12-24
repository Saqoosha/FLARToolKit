package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyIdMarkerPickup extends AlchemyClassProxy
	{
	
		public function NyIdMarkerPickup(...args:Array)
		{
			switch(args.length){
			case 0:
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyIdMarkerPickup_createInstance()
				);
				return;			
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyIdMarkerPickup(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
				break;
			}
			throw new Error();
		}
		//
		public function pickFromRaster(image:INyARRgbRaster,i_square:NyARSquare,o_data:NyIdMarkerPattern,o_param:NyIdMarkerParam):Boolean
		{
			return this._alchemy_stub.pickFromRaster(
				this._alchemy_stub._native,
				image._alchemy_stub._native,
				i_square._alchemy_stub._native,
				o_data._alchemy_stub._native,
				o_param._alchemy_stub._native
				);
		}		
	}
}