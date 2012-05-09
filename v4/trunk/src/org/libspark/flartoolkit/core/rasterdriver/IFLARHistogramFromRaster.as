package org.libspark.flartoolkit.core.rasterdriver 
{
	import org.libspark.flartoolkit.core.types.*;
	
	/**
	 * ヒストグラムを生成するインタフェイスです。
	 * @author nyatla
	 *
	 */
	public interface IFLARHistogramFromRaster
	{
		//GSRaster
		function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:FLARHistogram):void;
		function createHistogram_2(i_skip:int,o_histogram:FLARHistogram):void;
	}


}