package org.libspark.flartoolkit.core.squaredetect 
{
	import org.libspark.flartoolkit.core.types.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public interface FLARSquareContourDetector_CbHandler 
	{
		/**
		 * 通知ハンドラです。
		 * この関数は、detectMarker関数のコールバック関数として機能します。
		 * 継承先のクラスで、矩形の発見時の処理をここに記述してください。
		 * @param i_coord
		 * @param i_coor_num
		 * @param i_vertex_index
		 * @throws FLARException
		 */
		function detectMarkerCallback(i_coord:FLARIntCoordinates, i_vertex_index:Vector.<int>):void;		
	}

}