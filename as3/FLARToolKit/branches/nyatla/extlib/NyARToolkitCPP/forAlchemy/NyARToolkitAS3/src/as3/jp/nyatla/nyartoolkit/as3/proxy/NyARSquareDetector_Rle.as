package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARSquareDetector_Rle extends INyARSquareDetector
	{	
		public function NyARSquareDetector_Rle(...args:Array)
		{
			super(NyARToolkitAS3.BASECLASS);
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{
					//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyARSquareDetector_Rle(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			case 2:
				//function NyARSquareDetector_Rle(NyARCameraDistorsionFactor,NyARIntSize)
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARSquareDetector_Rle_createInstance(args[0]._alchemy_stub._native,args[1]._alchemy_stub._native)
				);
				return;
			default:
				break;
			}
			throw new Error("NyARSquareDetector_Rle");
		}
	}
}