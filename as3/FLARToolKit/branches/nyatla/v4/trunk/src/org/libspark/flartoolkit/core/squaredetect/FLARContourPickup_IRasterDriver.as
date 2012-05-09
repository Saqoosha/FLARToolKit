package jp.nyatla.nyartoolkit.as3.core.squaredetect 
{
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.*;
	
	
	/**
	 * ...
	 * @author nyatla
	 */
	public interface NyARContourPickup_IRasterDriver 
	{
		function getContour(i_l:int,i_t:int,i_r:int,i_b:int,i_entry_x:int,i_entry_y:int,i_th:int,o_coord:NyARIntCoordinates):Boolean;
	}
	
}