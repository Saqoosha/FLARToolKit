package sketch 
{
	import away3d.cameras.Camera3D;
	import away3d.core.partition.LightNode;
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
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.away3d4.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.containers.*;
	import away3d.core.math.*;
	import away3d.textures.*;
	/**
	 * MarkerSystemを使ったSimpleLiteの実装です。
	 * このサンプルは、FLSketchを使用したプログラムです。
	 * Away3Dの初期化、Flashオブジェクトの配置などを省略せずに実装しています。
	 */
	public class MarkerPlane extends FLSketch
	{
		private static const _CAM_W:int = 320;
		private static const _CAM_H:int = 240;
		private var _ss:FLARSensor;
		private var _ms:FLARAway3DMarkerSystem;

		private var _video:Video;
		private var _view3d:View3D;
		
		private var marker_id:int;
		private var marker_node:ObjectContainer3D;
		private var light:LightNode;
		
		public function MarkerPlane()
		{

		}
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
			this._ms = new FLARAway3DMarkerSystem(cf);
			this.marker_id = this._ms.addARMarker_2(this.getSketchFile(this._fid[1]), 16, 25, 80); //register AR Marker
			//setup Away3d
			this._view3d = new View3D();
			this._view3d.x = 0;
			this._view3d.y = 0;
			this._view3d.width = stage.width;
			this._view3d.height = stage.height;
			this._view3d.scene=new Scene3D();
			this._view3d.background = new FLARWebCamTexture(_CAM_W, _CAM_H);
			var light:DirectionalLight = new DirectionalLight();
            light.direction = new Vector3D( -1, -1, -1);
			light.ambient = 0.5;
			light.diffuse = 0.9;
			light.specular = 0.5;
			this._view3d.camera = this._ms.getAway3DCamera();
			this.addChild(this._view3d);
			//3d object
			this.marker_node = Away3DHelper.createFLARCube(80,light);
			this.marker_node.visible = true;
			this._view3d.scene.addChild(this.marker_node);
			//start camera
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);

		}		
		private function _onEnterFrame(e:Event = null):void
		{
			this._ss.update_2(this._video);//update sensor status
			this._ms.update(this._ss);//update markersystem status
			FLARWebCamTexture(this._view3d.background).update(this._video); //update background
			if (this._ms.isExistMarker(marker_id)) {
				var p:NyARDoublePoint3d = new NyARDoublePoint3d();
				this._ms.getMarkerPlanePos(this.marker_id,_CAM_W*this.stage.mouseX/this.stage.width,_CAM_H*this.stage.mouseY/this.stage.height,p);

				var m:Matrix3D = new Matrix3D();
				m.identity();
				m.position = new Vector3D(p.x, p.y, p.z);
				var m2:Matrix3D = new Matrix3D();
				this._ms.getAway3dMarkerMatrix(this.marker_id,m2);
				m.append(m2);
				this.marker_node.transform = m;
				this.marker_node.visible = true;
				
			}else {
				this.marker_node.visible = false;
			}
			this._view3d.render();			
			
			this._ss.update_2(this._video);//update sensor status
			this._ms.update(this._ss);//update markersystem status
			if (this._ms.isExistMarker(marker_id)) {

			}else {
				this.marker_node.visible = false;
			}
			this._view3d.render();
		}
	}
}