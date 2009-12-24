package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyIdMarkerParam extends AlchemyClassProxy
	{
		public static const DIRECTION_UNKNOWN:int =-1;
	
		public function NyIdMarkerParam(...args:Array)
		{
			switch(args.length){
			case 0:
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyIdMarkerParam_createInstance()
				);
				return;			
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyIdMarkerParam(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
				break;
			}
			throw new Error();
		}
		/**
		 * Marshal
 		 * [GET] direction:int,threshold:int
		 */		
		public function getValue(o_argument:Marshal):void
		{
			o_argument.prepareCallAlchmy();
			this._alchemy_stub.getValue(this._alchemy_stub._native,o_argument);
			return;
		}
	}
}