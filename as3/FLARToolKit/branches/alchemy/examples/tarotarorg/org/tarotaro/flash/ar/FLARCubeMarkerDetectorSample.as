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
	import net.saqoosha.utils.FPSMeter;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.tarotaro.flash.ar.detector.CubeMarker;
	import org.tarotaro.flash.ar.layers.FLARCubeMarkerLayer;
	import org.tarotaro.flash.ar.layers.FLARLayer;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	[SWF(width="640", height="480", backgroundColor="0xFFFFFF", frameRate="30")]
	public class FLARCubeMarkerDetectorSample extends Sprite
	{
		
		[Embed(source = "../../../../Data/camera_para.dat", mimeType = "application/octet-stream")]private var CParam:Class;
		[Embed(source = "assets/top.pat", mimeType = "application/octet-stream")]private var TopCode:Class;
		[Embed(source = "assets/front.pat", mimeType = "application/octet-stream")]private var FrontCode:Class;
		[Embed(source = "assets/left.pat", mimeType = "application/octet-stream")]private var LeftCode:Class;
		[Embed(source = "assets/right.pat", mimeType = "application/octet-stream")]private var RightCode:Class;
		[Embed(source = "assets/back.pat", mimeType = "application/octet-stream")]private var BackCode:Class;

		private var _capture:Bitmap;
		private var _video:Video;
		private var _layer:FLARLayer;
		private var _arSprite:Sprite;

		public function FLARCubeMarkerDetectorSample() 
		{
			//AR部分の設定
			//パラメータ設定
			var param:FLARParam = new FLARParam();
			param.loadARParam(new CParam() as ByteArray);
			param.changeScreenSize(320, 240);
			//パターンの設定
			var cTop:FLARCode = new FLARCode(16, 16);
			var cFront:FLARCode = new FLARCode(16,16);
			var cLeft:FLARCode = new FLARCode(16,16);
			var cRight:FLARCode = new FLARCode(16,16);
			var cBack:FLARCode = new FLARCode(16,16);
			var dTop:ByteArray = new TopCode() as ByteArray;
			var dFront:ByteArray = new FrontCode() as ByteArray;
			var dLeft:ByteArray = new LeftCode() as ByteArray;
			var dRight:ByteArray = new RightCode() as ByteArray;
			var dBack:ByteArray = new BackCode() as ByteArray;
			cTop.loadARPatt(dTop.readMultiByte(dTop.length, "shift-jis"));
			cFront.loadARPatt(dFront.readMultiByte(dFront.length, "shift-jis"));
			cLeft.loadARPatt(dLeft.readMultiByte(dLeft.length, "shift-jis"));
			cRight.loadARPatt(dRight.readMultiByte(dRight.length, "shift-jis"));
			cBack.loadARPatt(dBack.readMultiByte(dBack.length, "shift-jis"));


			var cube:CubeMarker = new CubeMarker(cTop, null, cFront, cBack, cLeft, cRight);
			
			//表示部分を設定
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);

			var raster:IFLARRgbRaster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);
			
			
			this._layer = new FLARCubeMarkerLayer(raster, param, cube);
			
			this._arSprite = new Sprite();

			this._arSprite.addChild(this._capture);
			this._arSprite.addChild(this._layer);
			this._arSprite.scaleX = this._arSprite.scaleY = 2;
			this.addChild(this._arSprite);

			this.addChild(new FPSMeter());

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void 
		{
			this._capture.bitmapData.draw(this._video);
			this._layer.update();
		}
		
	}
	
}