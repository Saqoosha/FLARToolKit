package org.libspark.flartoolkit.core.squaredetect 
{
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.rasterdriver.*;
import org.libspark.flartoolkit.core.pixeldriver.*;
import org.libspark.flartoolkit.core.*;
	
	
	/**
	 * ...
	 * @author nyatla
	 */
	public interface FLARContourPickup_IRasterDriver 
	{
		function getContour(i_l:int,i_t:int,i_r:int,i_b:int,i_entry_x:int,i_entry_y:int,i_th:int,o_coord:FLARIntCoordinates):Boolean;
	}
	
}