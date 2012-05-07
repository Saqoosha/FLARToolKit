package jp.nyatla.nyartoolkit.as3.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	public interface INyARGrayscaleRaster extends INyARRaster
	{
		function getGsPixelDriver() :INyARGsPixelDriver;
	}
	
}