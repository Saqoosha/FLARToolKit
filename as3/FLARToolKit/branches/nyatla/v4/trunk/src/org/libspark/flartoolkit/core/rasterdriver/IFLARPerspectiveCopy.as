package org.libspark.flartoolkit.core.rasterdriver 
{
/**
 * このインタフェイスは、ラスタから射影変換画像を取得するインタフェイスを提供します。
 *
 */
public interface IFLARPerspectiveCopy
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	/**
	 * この関数は、i_outへパターンを出力します。
	 * @param i_vertex
	 * @param i_edge_x
	 * @param i_edge_y
	 * @param i_resolution
	 * @param i_out
	 * @return
	 * @throws FLARException
	 */
	function copyPatt(i_vertex:Vector.<FLARIntPoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean;
	function copyPatt_2(i_vertex:Vector.<FLARDoublePoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean;
	function copyPatt_3(i_x1:Number,i_y1:Number,i_x2:Number,i_y2:Number,i_x3:Number,i_y3:Number,i_x4:Number,i_y4:Number,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean;
}

	
}