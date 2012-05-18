package sketch
{
	import flash.accessibility.Accessibility;
	import flash.media.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import jp.nyatla.as3utils.sketch.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.alternativa3d.*;
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.controllers.*;
	import alternativa.engine3d.objects.*;
	import alternativa.engine3d.primitives.*;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.resources.*;
	/**
	 * MarkerSystemを使ったSimpleLiteの実装です。
	 * このサンプルは、FLSketchを使用したプログラムです。
	 * Away3Dの初期化、Flashオブジェクトの配置などを省略せずに実装しています。
	 */
	public class SimpleLite extends FLSketch
	{
		private static const _CAM_W:int = 320;
		private static const _CAM_H:int = 240;
		private var _ss:FLARSensor;
		private var _ms:FLARAlternativa3DMarkerSystem;

		private var _video:Video;
		private var stage3D:Stage3D;
		private var controller:SimpleObjectController;

		private var _camera:FLARCamera3D;
		private var _box:Box;
		private var  _bg:FLARBackgroundPanel;
		private var marker_id:int;
		

		private var _fid:Vector.<int>=new Vector.<int>(3);
		public override function setup():void
		{
			//setup content files...
			this._fid[0]=this.setSketchFile("../../../data/camera_para.dat", URLLoaderDataFormat.BINARY);//0
			this._fid[1]=this.setSketchFile("../../../data/patt.hiro", URLLoaderDataFormat.TEXT);//1
		}
		public override function main():void
		{
			//webcam
			var webcam:Camera = Camera.getCamera();
			if (!webcam) {
				throw new Error('No webcam!!!!');
			}
			webcam.setMode(_CAM_W, _CAM_H, 30);
			this._video = new Video(_CAM_W, _CAM_H);
			this._video.attachCamera(webcam);
			
			//FLMarkerSystem
			var cf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(this.getSketchFile(this._fid[0]),_CAM_W, _CAM_H);//make configlation
			this._ss = new FLARSensor(new NyARIntSize(_CAM_W, _CAM_H));
			this._ms = new FLARAlternativa3DMarkerSystem(cf);
			this.marker_id = this._ms.addARMarker_2(this.getSketchFile(this._fid[1]), 16, 25, 80); //register AR Marker	
			//setup stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, init);
			stage3D.requestContext3D();	
		}
		private function init(event:Event):void
		{
			//setup Alternativa3D objects
			var rootContainer:Object3D = new Object3D();
			//camera
			this._camera = this._ms.getAlternativa3DCamera();
			this._camera.view = new View(640, 480, false, 0x202020, 0, 0);
			//These are magic number to fill edge spaces. 0.8 - 0.7?
			//I do not know why the magic number is required and how to calculate it.
			this._camera.scaleX = 0.8;
			this._camera.scaleY = 0.8;
			rootContainer.addChild(this._camera);
			addChild(this._camera.view);
			//background panel
			this._bg = this._camera.createBackgroundPanel();
			rootContainer.addChild(this._bg);
			
			//setup a light and a box object.
			{
				var light:OmniLight;
				light = new OmniLight(0xffffff, 100, 1000);
				light.x = 300;
				light.y = -100;
				light.z = -100;
				rootContainer.addChild(light);
				var material:VertexLightTextureMaterial  = new VertexLightTextureMaterial(new BitmapTextureResource(new BitmapData(8, 8, false, 0xff0000)));
				this._box = new Box(40, 40, 40, 1, 1, 1, false, material);
				rootContainer.addChild(this._box);
			}
			//
			for each (var resource:Resource in rootContainer.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
			//start update
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		/**
		 * MainLoop
		 * @param	e
		 */
		private function _onEnterFrame(e:Event = null):void
		{
			this._ss.update_2(this._video);           //update sensor status
			this._ms.update(this._ss);                //update markersystem status
			if (this._ms.isExistMarker(marker_id)) {
				var m:Matrix3D = new Matrix3D();
				m.position = new Vector3D(0, 0, 20);
				this._ms.appendAlternativa3DMarkerMatrixRH(this.marker_id, m);
				this._box.matrix = m;
				this._box.visible = true;
			}else {
				this._box.visible = false;
			}
			this._bg.update(this._video,this.stage3D);//update background
			this._camera.render(stage3D);//render all
		}	
	}
}
