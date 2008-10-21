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
package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.tarotaro.flash.ar.layers.FLARSquareLayer;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	[SWF(width="640", height="480", backgroundColor="0xFFFFFF", frameRate="30")]
	public class FLARSquareMarkerSample extends Sprite
	{
		[Embed(source = "../../../../Data/camera_para.dat", mimeType = "application/octet-stream")]
		private var CParam:Class;
		private var _capture:Bitmap;
		private var _video:Video;
		private var _layer:FLARSquareLayer;
		private var _arSprite:Sprite;
		
		public function FLARSquareMarkerSample() 
		{
			//AR部分の設定
			var param:FLARParam = new FLARParam();
			param.loadARParam(new CParam()as ByteArray);
			var code:FLARCode = new FLARCode(16,16);
			
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			var raster:IFLARRgbRaster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);
			
			this._layer = new FLARSquareLayer(raster, param);
			this._layer.lineStyle(2, 0xFF0000);
			
			this._capture.scaleX = this._capture.scaleY = 2;
			this._layer.scaleX = this._layer.scaleY = 2;

			this.addChild(this._capture);
			this.addChild(this._layer);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void 
		{
			this._capture.bitmapData.draw(this._video);
			this._layer.update();
		}
	}
	
}