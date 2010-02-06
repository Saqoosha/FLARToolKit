package
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.*;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.*;

	
//	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="init",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]

	public class ARAppBase extends Sprite
	{		
		private var _cameraFile:String;
		private var _width:int;
		private var _height:int;
		private var _codeWidth:int;
		
		protected var _param:FLARParam;
		protected var _raster:FLARRgbRaster_BitmapData;
		
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		
		
		public function ARAppBase() {
		}
		
		protected function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void {
			this._cameraFile = cameraFile;
			this._width = canvasWidth;
			this._height = canvasHeight;
			this._codeWidth = codeWidth;
			
			
			//複数のファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				this._cameraFile,URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					_param = new FLARParam();
					_param.loadARParam(data);
					_param.changeScreenSize(320,240);
				});
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,_onLoadCode);
            mf.multiLoad();//ロード開始
            return;//dispatch event	
		}
		private function _onLoadCode(e:Event):void {
			// setup webcam
			this._webcam = Camera.getCamera();
			if (!this._webcam) {
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, 'no webcam!'));
				return;
			}
			this._webcam.setMode(this._width, this._height, 30);
			this._video = new Video(this._width, this._height);
			this._video.attachCamera(this._webcam);
			// setup ARToolkit
			this._raster = new FLARRgbRaster_BitmapData(_width,_height);
			this._capture = new Bitmap(BitmapData(_raster.getBuffer()), PixelSnapping.AUTO, true);
			
			this.dispatchEvent(new Event(Event.INIT));
		}
		
	}
	
}

