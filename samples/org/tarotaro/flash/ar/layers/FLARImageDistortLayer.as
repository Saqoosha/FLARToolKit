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
org.tarotaro.flash.ar.layers 
{
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARSquare;
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import org.flashsandy.display.DistortImage;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARImageDistortLayer extends FLARSingleMarkerLayer
	{
		private var _image:DisplayObject;
		private var _distort:DistortImage;
		private var _square:FLARSquare;
		private var _bitmap:BitmapData;

		public function FLARImageDistortLayer(src:FLARBitmapData, 
												param:FLARParam,
												code:FLARCode,
												markerWidth:Number, 
												img:DisplayObject, 
												thresh:int = 100) 
		{
			super(src, param, code, markerWidth, thresh);
			trace("src:",src.getWidth(), src.getHeight());
			this._image = img;
			this._bitmap = new BitmapData(this._image.width, this._image.height,true,0xffffff);
			this._distort = new DistortImage(this._image.width,this._image.height, 4, 4);
		}
		
		override public function update():void 
		{
			this.graphics.clear();
			if (this._detector.detectMarkerLite(this._source, this._thresh) ) {
				this._detector.getTranslationMatrix(this._resultMat);
				this._square = this._detector.getSquare();
				this._bitmap.draw(this._image);
				var points:Array = new Array();
				for (var i:uint = 0; i < 4; i++) {
					points.push(new Point(this._square.sqvertex[i][0], this._square.sqvertex[i][1]));
				}
				this._distort.setTransform(this.graphics, this._bitmap, points[2], points[3], points[0], points[1]);
				this.visible = true;
			} else {
				this.visible = false;
			}
		}
	}
	
}