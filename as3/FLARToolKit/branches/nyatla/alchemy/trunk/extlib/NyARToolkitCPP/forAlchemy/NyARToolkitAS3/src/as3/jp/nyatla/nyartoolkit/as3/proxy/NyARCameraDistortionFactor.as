package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARCameraDistortionFactor extends AlchemyClassProxy
	{
		public function NyARCameraDistortionFactor(...args:Array)
		{
			switch(args.length){
			case 0:
				//function NyARCameraDistortionFactor()
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARCameraDistortionFactor_createInstance()
				);
				return;
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyARCameraDistortionFactor(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
			}
			throw new Error("NyARCameraDistortionFactor");
		}
	}
}