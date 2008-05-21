package {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.scene.FLARCamera3D;
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mx.core.BitmapAsset;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.FrustumCamera3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.renderables.Vertex3DInstance;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	

	[SWF(width=640,height=480,frameRate=60,backgroundColor=0x0)]

	public class FLARToolKitTest2 extends ARAppBase {
		
		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		private var _scene:Scene3D;;
		private var _camera3d:FLARCamera3D;
		private var _viewport:Viewport3D;
		private var _renderer:LazyRenderEngine;
		
		private var _transGrp:DisplayObject3D;
		private var _basePlane:Plane;
		private var _cube:Cube;
		
		private var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		
		public function FLARToolKitTest2() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.quality = StageQuality.LOW;
			
			this.addEventListener(Event.INIT, this._onInit);
			this.init(CAMERA_FILE, PATTERN_FILE, 320, 240);
		}
		
		private function _onInit(e:Event):void {
			this.removeEventListener(Event.INIT, this._onInit);
			
			this._capture.width = 640;
			this._capture.height = 480;
			this._capture.scaleX *= -1;
			this._capture.x = 640;
			this.addChild(this._capture);
			
			this._viewport = this.addChild(new Viewport3D(320, 240, false, false, false, false)) as Viewport3D;
			this._viewport.scaleX = -2;
			this._viewport.scaleY = 2;
			this._viewport.x = 644; // +4pix ???
			
			this._camera3d = new FLARCamera3D(this._viewport, this._param);
			
			this._scene = new Scene3D();
			this._transGrp = this._scene.addChild(new DisplayObject3D()) as DisplayObject3D;
				var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2);
				wmat.doubleSided = true;
				this._basePlane = new Plane(wmat, 80, 80);
			this._transGrp.addChild(this._basePlane);
				var light:PointLight3D = new PointLight3D();
				light.z = -1000;
				var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x0);
				fmat.opposite = true;
				this._cube = new Cube(new MaterialsList({ all: fmat }), 40, 40, 40);
				this._cube.z += 20;
			this._transGrp.addChild(this._cube);
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
			this._onEnterFrame();
			
			this.addChild(new FPSMeter());
		}
		
		private function _onEnterFrame(e:Event = null):void {
			this._capture.bitmapData.draw(this._video);
			if (this._detector.detectMarkerLite(this._raster, 80)) {
				this._detector.getTranslationMatrix(this._resultMat);
				var a:Array = this._resultMat.getArray();
				var mtx:Matrix3D = this._transGrp.transform;;
				mtx.n11 =  a[0][0];	mtx.n12 =  a[0][1];	mtx.n13 =  a[0][2];	mtx.n14 =  a[0][3];
				mtx.n21 = -a[1][0];	mtx.n22 = -a[1][1];	mtx.n23 = -a[1][2];	mtx.n24 = -a[1][3];
				mtx.n31 =  a[2][0];	mtx.n32 =  a[2][1];	mtx.n33 =  a[2][2];	mtx.n34 =  a[2][3];
				this._renderer.render();
			}
		}
		
	}
	
}