package org.tarotaro.flash.ar.layers 
{
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.FLARParam;
	import org.libspark.flartoolkit.core.FLARTransMatResult;
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARSingleMarkerLayer extends FLARLayer
	{
		protected var _detector:FLARSingleMarkerDetector;
		protected var _resultMat:FLARTransMatResult;
		
		/**
		 * 単一マーカ用レイヤ
		 * @param	src
		 * @param	param
		 * @param	code
		 * @param	markerWidth
		 * @param	thresh
		 */
		public function FLARSingleMarkerLayer(src:FLARBitmapData, 
												param:FLARParam, 
												code:FLARCode, 
												markerWidth:Number, 
												thresh:int = 100) 
		{
			super(src, thresh);
			this._detector = new FLARSingleMarkerDetector(param, code, markerWidth);
			this._resultMat = new FLARTransMatResult();
		}
	}
	
}