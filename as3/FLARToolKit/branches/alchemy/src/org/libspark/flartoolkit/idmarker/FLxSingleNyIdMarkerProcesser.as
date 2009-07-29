package org.libspark.flartoolkit.idmarker 
{
	import jp.nyatla.nyartoolkit.as3.*;	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class FLxSingleNyIdMarkerProcesser extends SingleNyIdMarkerProcesser
	{
		
		public function FLxSingleNyIdMarkerProcesser(param:NyARParam,encoder:INyIdMarkerDataEncoder) 
		{
			super(param,encoder,NyARRgbRaster.BUFFERFORMAT_BYTE1D_X8R8G8B8_32);
		}
		public override function dispose():void
		{
			super.dispose();
			return;
		}		
	}
	
}