package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="init",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]

	public class ARAppBase extends Sprite {
		
		private var _loader:URLLoader;
		private var _cameraFile:String;
		private var _codeFile:String;
		private var _width:int;
		private var _height:int;
		private var _codeWidth:int;
		
		protected var _param:FLARParam;
		protected var _code:FLARCode;
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARSingleMarkerDetector;
		
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		
		public function ARAppBase() {
		}
		
		protected function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void {
			_cameraFile = cameraFile;
			_width = canvasWidth;
			_height = canvasHeight;
			_codeFile = codeFile;
			_codeWidth = codeWidth;
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, _onLoadParam);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader.load(new URLRequest(_cameraFile));
		}
		
		private function _onLoadParam(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, _onLoadParam);
			_param = new FLARParam();
			_param.loadARParam(_loader.data);
			_param.changeScreenSize(_width, _height);
			
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onLoadCode);
			_loader.load(new URLRequest(_codeFile));
		}
		
		private function _onLoadCode(e:Event):void {
			_code = new FLARCode(16, 16);
			_code.loadARPatt(_loader.data);
			
			_loader.removeEventListener(Event.COMPLETE, _onLoadCode);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader = null;

			// setup webcam
			_webcam = Camera.getCamera();
			if (!_webcam) {
				throw new Error('No webcam!!!!');
			}
			_webcam.setMode(_width, _height, 30);
			_video = new Video(_width, _height);
			_video.attachCamera(_webcam);
			
			// setup ARToolkit
			_raster = new FLARRgbRaster_BitmapData(_width,_height);
			_capture = new Bitmap(BitmapData(_raster.getBufferReader().getBuffer()), PixelSnapping.AUTO, true);
			_detector = new FLARSingleMarkerDetector(_param, _code, _codeWidth);
			_detector.setContinueMode(true);
			
			dispatchEvent(new Event(Event.INIT));
		}
		
		protected function onInit():void {
		}
	}
}