package jp.nyatla.nyartoolkit.as3.markersystem 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	
	public interface INyARMarkerSystemSquareDetect 
	{
		/**
		 * この関数は、自己コールバック関数です。{@link #detectMarker}が検出結果を通知する為に使います。
		 * 実装クラスでは、ここに矩形の発見時の処理を記述してください。
		 * @param i_coord
		 * 輪郭線オブジェクト
		 * @param i_vertex_index
		 * 矩形の４頂点に対応する、輪郭線オブジェクトのインデクス番号。
		 * @throws NyARException
		 */
		function detectMarkerCb(i_sensor:NyARSensor,i_th:int,i_handler:NyARSquareContourDetector_CbHandler):void
		
	}
	
}