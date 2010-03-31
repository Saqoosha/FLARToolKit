package org.tarotaro.flash.ar 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.*;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	public class FLARMiyake extends Sprite
	{
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARSingleMarkerDetector;
		protected var _video:Video;
		protected var _capture:Bitmap;
		protected var _renderer:LazyRenderEngine;
		protected var _markerNode:FLARBaseNode;
		
		protected var _resultMat:FLARTransMatResult;
		
		[Embed(source = "assets/patt.miyake", mimeType = "application/octet-stream")]private var MiyakeCode:Class;

		public function FLARMiyake() 
		{
			const SCREEN_WIDTH:int = 320;
			const SCREEN_HEIGHT:int = 240;

			var codeFile:ByteArray = new MiyakeCode() as ByteArray;
			var code:FLARCode = new FLARCode(32, 32, 85, 85);
			code.loadARPatt(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			var param:FLARParam = new FLARParam();
			param.changeScreenSize(SCREEN_WIDTH, SCREEN_HEIGHT);

			// setup webcam
			var webcam:Camera = Camera.getCamera();
			if (!webcam) throw new Error('No webcam!!!!');
			webcam.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, 30);
			_video = new Video(SCREEN_WIDTH, SCREEN_HEIGHT);
			_video.attachCamera(webcam);

			_capture = new Bitmap(new BitmapData(SCREEN_WIDTH, SCREEN_HEIGHT, false, 0), PixelSnapping.AUTO, true);
			_capture.width = 640;
			_capture.height = 480;
			
			// setup ARToolkit
			_raster = new FLARRgbRaster_BitmapData(_capture.bitmapData);
			_resultMat = new FLARTransMatResult();
			_detector = new FLARSingleMarkerDetector(param, code, 80);
			_detector.setContinueMode(true);

			var base:Sprite = addChild(new Sprite()) as Sprite;
			base.addChild(_capture);
			
			var viewport:Viewport3D = base.addChild(new Viewport3D(SCREEN_WIDTH, SCREEN_HEIGHT)) as Viewport3D;
			viewport.scaleX = 640 / SCREEN_WIDTH;
			viewport.scaleY = 480 / SCREEN_HEIGHT;
			viewport.x = -4;
			
			var camera3d:FLARCamera3D = new FLARCamera3D(param);
			
			var scene:Scene3D = new Scene3D();
			_markerNode = scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;

			var wmat:WireframeMaterial = new WireframeMaterial(0xFF0000, 1, 2);
			var plane:Plane = new Plane(wmat, 80, 80);
			plane.rotationX = 180;
			_markerNode.addChild(plane);
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x75104e);
			var cube:Cube = new Cube(new MaterialsList( { all:fmat } ), 40, 40, 40);
			cube.z = 20;
			_markerNode.addChild(cube);
			_renderer = new LazyRenderEngine(scene, camera3d, viewport);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		private function _onEnterFrame(e:Event = null):void {
			_capture.bitmapData.draw(_video);
			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.5;
			} catch (e:Error) {}
			
			if (detected) {
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