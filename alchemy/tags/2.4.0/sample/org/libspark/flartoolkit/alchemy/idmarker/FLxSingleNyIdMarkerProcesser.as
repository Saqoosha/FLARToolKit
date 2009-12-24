package org.libspark.flartoolkit.alchemy.idmarker 
{
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.*;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class FLxSingleNyIdMarkerProcesser extends SingleNyIdMarkerProcesserAS
	{
		
		public function FLxSingleNyIdMarkerProcesser(param:NyARParam,encoder:INyIdMarkerDataEncoder) 
		{
			super();
			initInstance(param, encoder, INyARBufferReader.BUFFERFORMAT_BYTE1D_X8R8G8B8_32);
		}
		public override function dispose():void
		{
			super.dispose();
			return;
		}		
	}
	
}