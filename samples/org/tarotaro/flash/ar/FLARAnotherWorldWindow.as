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
	import org.libspark.flartoolkit.core.FLARParam;
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class FLARAnotherWorldWindow extends Sprite
	{
		//フォルダ構造の変更に注意すること！！
		[Embed(source = "../../../../Data/camera_para.dat", mimeType = "application/octet-stream")]
		private var CParam:Class;
		[Embed(source = "../../../../Data/patt.hiro", mimeType = "application/octet-stream")]
		private var CodeData:Class;
		//panorama.jpgはFlickrなどから調達して、Data以下に格納してください。
		[Embed(source = '../../../../Data/panorama.jpg')]private var PanoBitmap:Class;
		private var _capture:Bitmap;
		private var _video:Video;
		private var _windowLayer:FLARPanoramaSphereLayer;
		private var _arSprite:Sprite;

		public function FLARAnotherWorldWindow() 
		{
			//AR部分の設定
			var param:FLARParam = new FLARParam();
			param.loadFromARFile(new CParam()as ByteArray);
			var code:FLARCode = new FLARCode(16,16);
			var codeFile:ByteArray = new CodeData() as ByteArray;
			code.loadFromARFile(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			var raster:FLARBitmapData = new FLARBitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);
			

			var panoBMP:Bitmap = new PanoBitmap() as Bitmap;
			
			this._windowLayer = new FLARPanoramaSphereLayer(raster, param, code, 80,panoBMP.bitmapData);
			this.addChild(this._windowLayer);
			
			this._capture.scaleX = this._capture.scaleY = 0.5;
			this.addChild(this._capture);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}

		private function onEnterFrame(e:Event):void 
		{
			this._capture.bitmapData.draw(this._video);
			this._windowLayer.update();
		}
	}
	
}