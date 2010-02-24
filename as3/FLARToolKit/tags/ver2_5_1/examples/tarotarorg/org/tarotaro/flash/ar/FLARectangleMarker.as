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
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Sound;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;

	/**
	 * ...
	 * @author ...
	 */
	[SWF(width="640", height="480", backgroundColor="0x000000", frameRate="30")]
	public class FLARectangleMarker extends Sprite
	{
		protected var _param:FLARParam;
		protected var _code:FLARCode;
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARSingleMarkerDetector;
		
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		protected var _base:Sprite;
		protected var _detected:Boolean = false;
		
		protected var _helloVoice:Sound;
		protected var _taroVoice:Sound;
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		[Embed(source = "assets/camera_para.dat", mimeType = "application/octet-stream")]
		private var CParam:Class;
		[Embed(source = "assets/taro.pat", mimeType = "application/octet-stream")]
		private var CodeData:Class;
		
		[Embed(source = 'assets/z_hello.mp3')]private const HelloVoice:Class;
		[Embed(source = 'assets/z_taro.mp3')]private const TaroVoice:Class;
		public function FLARectangleMarker() 
		{
			setup();
		}

		private function setup():void
		{
			var codeFile:ByteArray = new CodeData() as ByteArray;
			
			_param = new FLARParam();
			_param.loadARParam(new CParam() as ByteArray);
			_param.changeScreenSize(320, 240);
			_code = new FLARCode(16, 16, 70, 70);
			_code.loadARPatt(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			// setup webcam
			_webcam = Camera.getCamera();
			if (!_webcam) {
				throw new Error('No webcam!!!!');
			}
			_webcam.setMode(320, 240, 30);
			_video = new Video(320, 240);
			_video.attachCamera(_webcam);
			_capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			
			// setup ARToolkit
			_raster = new FLARRgbRaster_BitmapData(_capture.bitmapData);
			_detector = new FLARSingleMarkerDetector(_param, _code, 80);
			_detector.setContinueMode(true);
			
			_base = addChild(new Sprite()) as Sprite;
			
			_capture.width = 640;
			_capture.height = 480;
			_base.addChild(_capture);
			
			_helloVoice = new HelloVoice();
			_taroVoice = new TaroVoice();
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);

			dispatchEvent(new Event(Event.INIT));

		}
		private function _onEnterFrame(e:Event = null):void {
			_capture.bitmapData.draw(_video);
			
			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.5;
			} catch (e:Error) {}
			if (detected && !_detected) {
				var voiceChoice:uint = Math.floor(Math.random() * 100);
				if (voiceChoice < 5) {
					_taroVoice.play();
				} else {
					_helloVoice.play();
				}
				_detected = detected;
			} else if (!detected) {
					_detected = detected;
			}
		}

	}
}