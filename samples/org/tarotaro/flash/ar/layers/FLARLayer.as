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
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARLayer extends Sprite
	{
		protected var _source:FLARBitmapData;
		protected var _thresh:int;

		public function FLARLayer(src:FLARBitmapData,thresh:int) 
		{
			this._source = src;
			this._thresh = thresh;
		}
		
		public function update():void
		{
			throw new ArgumentError("update()は、オーバーライドして使用してください。");
		}		
	}
	
}