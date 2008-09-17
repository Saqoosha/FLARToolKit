/*
 *  Copyright 2008 tarotarorg(http://tarotaro.org)
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */ 
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