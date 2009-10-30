package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyIdMarkerPattern extends AlchemyClassProxy
	{
		public static const DIRECTION_UNKNOWN:int =-1;
	
		public function NyIdMarkerPattern(...args:Array)
		{
			switch(args.length){
			case 0:
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyIdMarkerPattern_createInstance()
				);
				return;			
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyIdMarkerPattern(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
				break;
			}
			throw new Error();
		}	
	}
}