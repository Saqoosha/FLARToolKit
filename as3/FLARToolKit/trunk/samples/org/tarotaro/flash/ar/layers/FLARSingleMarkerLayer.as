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