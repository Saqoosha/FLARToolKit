package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class INyARSquareDetector extends AlchemyClassProxy
	{
		public function INyARSquareDetector(...args:Array)
		{
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function INyARSquareDetector(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
				break;
			}
			throw new Error();
		}
		public function detectMarker(i_raster:NyARBinRaster,o_square_stack:NyARSquareStack):void
		{
			this._alchemy_stub.detectMarker(
				this._alchemy_stub._native,
				i_raster._alchemy_stub._native,
				o_square_stack._alchemy_stub._native);
			return;
		}	
	}	

}