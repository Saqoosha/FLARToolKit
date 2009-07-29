/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 *
 */
package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.tarotaro.flash.ar.layers.FLARPanoramaSphereLayer;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class FLARPanoramaSphere extends Sprite
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
		private var _layer:FLARPanoramaSphereLayer;
		private var _arSprite:Sprite;

		public function FLARPanoramaSphere() 
		{
			//AR部分の設定
			var param:FLARParam = new FLARParam();
			param.loadARParam(new CParam() as ByteArray);
			param.changeScreenSize(320, 240);
			var code:FLARCode = new FLARCode(16,16);
			var codeFile:ByteArray = new CodeData() as ByteArray;
			code.loadARPatt(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			var raster:IFLARRgbRaster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);
			

			var panoBMP:Bitmap = new PanoBitmap() as Bitmap;
			
			this._layer = new FLARPanoramaSphereLayer(raster, param, code, 80,panoBMP.bitmapData);
			this.addChild(this._layer);
			
			this._capture.scaleX = this._capture.scaleY = 0.5;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addChild(this._capture);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			trace("clicked");
			if (this.stage.displayState == StageDisplayState.FULL_SCREEN) { 
				this.stage.displayState = StageDisplayState.NORMAL;
			} else {
				this.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}

		private function onEnterFrame(e:Event):void 
		{
			this._capture.bitmapData.draw(this._video);
			this._layer.update();
		}
	}
	
}