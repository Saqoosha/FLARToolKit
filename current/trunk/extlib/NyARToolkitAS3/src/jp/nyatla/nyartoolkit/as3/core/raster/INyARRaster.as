package jp.nyatla.nyartoolkit.as3.core.raster {
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;			

	public interface INyARRaster
	{

		function getWidth():int;

		function getHeight():int;

		function getSize():NyARIntSize;

		function getBufferReader():INyARBufferReader;
	}
}