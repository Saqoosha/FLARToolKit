package examples
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
	import org.libspark.flartoolkit.detector.idmarker.FLARSingleIdMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.typography.fonts.HelveticaBold;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.view.Viewport3D;
	
	/**
	 * ...
	 * @author tarotarorg
	 */
	public class FLARIDMarkerSample extends Sprite 
	{
		private static const CAMERA_WIDTH:uint = 320;
		private static const CAMERA_HEIGHT:uint = 240;
		private var _raster:FLARRgbRaster_BitmapData;
		private var _detector:FLARSingleIdMarkerDetector;
		private var _video:Video;
		private var _capture:Bitmap;
		private var _renderer:LazyRenderEngine;
		private var _textdata:Text3D;
		private var _textFormat:Letter3DMaterial;
		private var _markerNode:FLARBaseNode;
		
		private var _resultMat:FLARTransMatResult;
		
		public function FLARIDMarkerSample():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var webcam:Camera = Camera.getCamera();
			if (!webcam) throw new Error('No webcam!!!!');
			webcam.setMode(CAMERA_WIDTH, CAMERA_HEIGHT, 30);
			this._video = new Video(CAMERA_WIDTH, CAMERA_HEIGHT);
			this._video.attachCamera(webcam);
			
			_capture = new Bitmap(new BitmapData(320, 240, false, 0), 
								  PixelSnapping.AUTO, true);
			_capture.width = 640;_capture.height = 480;
			_raster = new FLARRgbRaster_BitmapData(_capture.bitmapData);
			var base:Sprite = addChild(new Sprite()) as Sprite;
			base.addChild(_capture);

			var param:FLARParam = new FLARParam();
			param.changeScreenSize(CAMERA_WIDTH, CAMERA_HEIGHT);
			
			this._resultMat = new FLARTransMatResult();
			
			this._detector = new FLARSingleIdMarkerDetector(param, 80);
			this._detector.setContinueMode(true);
			
			var scene:Scene3D = new Scene3D();
			_markerNode = scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			var viewport:Viewport3D = 
				base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			viewport.scaleX = 640 / 320;viewport.scaleY = 480 / 240;
			viewport.x = -4;
			
			var camera3d:FLARCamera3D = new FLARCamera3D(param);
			// ID表示用のデータを作成する。
			_textFormat = new Letter3DMaterial(0xcc0000, 0.9);
			_textdata = new Text3D("aaa", new HelveticaBold(), _textFormat, "textdata")
			_textdata.rotationX = 180;
			_textdata.rotationZ = 90;
			_textdata.scale = 0.5;
			_markerNode.addChild(_textdata);
			_renderer = new LazyRenderEngine(scene, camera3d, viewport);

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event = null):void 
		{
			_capture.bitmapData.draw(_video);

			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, 80);
			} catch (e:Error) { trace(e); }
			
			if (detected) {
				var id:FLARIdMarkerData = _detector.getIdMarkerData();
				//read data from i_code via Marsial--Marshal経由で読み出す
				var currId:int;
				if (id.packetLength > 4) {
					currId = -1;
				}else{
					currId=0;
					//最大4バイト繋げて１個のint値に変換
					for (var i:int = 0; i < id.packetLength; i++ ) {
						currId = (currId << 8) | id.getPacketData(i); trace("id[", i, "]=", id.getPacketData(i));
					}
				}
				trace("[add] : ID = " + currId);
				_textdata.text = "" + currId;
				if (id.model == 3) {
					_textFormat.fillColor = (id.getPacketData(1) << 26) | (id.getPacketData(2) << 8) | (id.getPacketData(3));
				} else {
					_textFormat.fillColor = 0xCC0000;
				}
				_textFormat.updateBitmap();
				_detector.getTransformMatrix(_resultMat);
				_markerNode.setTransformMatrix(_resultMat);
				
				_markerNode.visible = true;
			} else {
				_markerNode.visible = false;
			}
			_renderer.render();
		}
		
	}
	
}