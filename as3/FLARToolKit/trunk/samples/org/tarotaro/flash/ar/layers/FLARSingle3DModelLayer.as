package org.tarotaro.flash.ar.layers 
{
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import com.libspark.flartoolkit.scene.FLARBaseNode;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARSingle3DModelLayer extends FLARSingleMarkerLayer
	{
		private var _model:FLARBaseNode;

		/**
		 * 
		 * @param	src
		 * @param	param
		 * @param	code
		 * @param	markerWidth
		 * @param	thresh
		 */
		public function FLARSingle3DModelLayer(src:FLARBitmapData,
												param:FLARParam,
												code:FLARCode,
												markerWidth:Number, 
												model:FLARBaseNode,
												thresh:int=100) 
		{
			super(src, param, code, markerWidth, thresh);
			this._model = model;
		}

		override public function update():void 
		{
			if (this._detector.detectMarkerLite(this._source, this._thresh) ) {
				this._detector.getTranslationMatrix(this._resultMat);
				this._model.setTranslationMatrix(this._resultMat);
				this._model.visible = true;
			} else {
				this._model.visible = false;
			}
		}
	}
}