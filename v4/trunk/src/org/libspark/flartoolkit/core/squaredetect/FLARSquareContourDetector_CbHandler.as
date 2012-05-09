package jp.nyatla.nyartoolkit.as3.core.squaredetect 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public interface NyARSquareContourDetector_CbHandler 
	{
		/**
		 * 通知ハンドラです。
		 * この関数は、detectMarker関数のコールバック関数として機能します。
		 * 継承先のクラスで、矩形の発見時の処理をここに記述してください。
		 * @param i_coord
		 * @param i_coor_num
		 * @param i_vertex_index
		 * @throws NyARException
		 */
		function detectMarkerCallback(i_coord:NyARIntCoordinates, i_vertex_index:Vector.<int>):void;		
	}

}