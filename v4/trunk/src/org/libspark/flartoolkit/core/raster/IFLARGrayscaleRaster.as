package org.libspark.flartoolkit.core.raster 
{
	import org.libspark.flartoolkit.core.pixeldriver.*;
	public interface IFLARGrayscaleRaster extends IFLARRaster
	{
		function getGsPixelDriver() :IFLARGsPixelDriver;
	}
	
}