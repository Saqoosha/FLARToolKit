package {
	
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.scene.FLARBaseNode;
	import com.libspark.flartoolkit.scene.FLARCamera3D;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.BitmapViewport3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	

	[SWF(width=640,height=480,frameRate=60,backgroundColor=0x0)]

	public class PV3DARApp extends ARAppBase {
		
		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _baseNode:FLARBaseNode;
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		
		public function PV3DARApp() {
		}
		
		protected override function init(cameraFile:String, codeFile:String, canvasWidth:int=320, canvasHeight:int=240, codeWidth:int=80):void {
			this.addEventListener(Event.INIT, this._onInit, false, int.MAX_VALUE);
			super.init(cameraFile, codeFile);
		}
		
		private function _onInit(e:Event):void {
			this.removeEventListener(Event.INIT, this._onInit);
			
			this._base = this.addChild(new Sprite()) as Sprite;
			
			this._capture.width = 640;
			this._capture.height = 480;
			this._base.addChild(this._capture);
			
			this._viewport = this._base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			this._viewport.scaleX = 640 / 320;
			this._viewport.scaleY = 480 / 240;
			this._viewport.x = -4; // 4pix ???
			
			this._camera3d = new FLARCamera3D(this._param);
			
			this._scene = new Scene3D();
			this._baseNode = this._scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
//			this.stage.addChild(new StatsView(this._renderer));
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event = null):void {
			this._capture.bitmapData.draw(this._video);
			if (this._detector.detectMarkerLite(this._raster, 80)) {
				this._detector.getTranslationMatrix(this._resultMat);
				this._baseNode.setTranslationMatrix(this._resultMat);
				this._baseNode.visible = true;
			} else {
				this._baseNode.visible = false;
			}
			this._renderer.render();
		}
		
		public function set mirror(value:Boolean):void {
			if (value) {
				this._base.scaleX = -1;
				this._base.x = 640;
			} else {
				this._base.scaleX = 1;
				this._base.x = 0;
			}
		}
		
		public function get mirror():Boolean {
			return this._base.scaleX < 0;
		}
		
	}
	
}