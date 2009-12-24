package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARRasterThresholdAnalyzer_SlidePTile extends INyARRasterThresholdAnalyzer
	{	
		public function NyARRasterThresholdAnalyzer_SlidePTile(...args:Array)
		{
			super(NyARToolkitAS3.BASECLASS);
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{
					//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyARRasterFilter_ARToolkitThreshold(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			case 3:
				//function NyARRasterFilter_ARToolkitThreshold(i_persentage:int,i_raster_format:int,i_vertical_interval:int)
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARRasterThresholdAnalyzer_SlidePTile_createInstance(int(args[0]),int(args[1]),int(args[2])));
				return;
			default:
				break;
			}
			throw new Error("NyARRasterFilter_ARToolkitThreshold");
		}		
	}
}