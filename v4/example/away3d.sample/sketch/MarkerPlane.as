package sketch 
{
	import away3d.core.math.MatrixAway3D;
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
	import org.libspark.flartoolkit.away3d.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
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
		public var bitmap:Bitmap = new Bitmap(new BitmapData(_CAM_W,_CAM_H));

		private var _video:Video;
		private var _view3d:View3D;
		
		private var marker_id:int;
		private var marker_node:ObjectContainer3D;
		
		public function MarkerPlane()
		{
			//setup Away3d
			this._view3d = new View3D();
			//setup UI
			//640x480 is Magic number. I do not know why those number becomes so. Does anyone know reason?
			//何故640x480で正しいサイズ計算が出来るか、その理由は判りませんでした。誰か知ってる？
			this._view3d.x = 640 / 2;
			this._view3d.y = 480 / 2;
			this.bitmap.x = -640 / 2;
			this.bitmap.y = -480 / 2;
			this.bitmap.width = 640;
			this.bitmap.height = 480;
            this._view3d.background.addChild(bitmap);
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
			// PV3DのViewport3Dと似たようなもの
			this._view3d.scene=new Scene3D();
			this._view3d.camera = this._ms.getAway3DCamera();			

			// 微調整
			this.addChild(this._view3d);
			//3d object
			this.marker_node = Away3DHelper.createFLARCube(80);
			this.marker_node.visible = true;
			this._view3d.scene.addChild(this.marker_node);
			//start camera
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		/**
		 * MainLoop
		 * @param	e
		 */
		private function _onEnterFrame(e:Event = null):void
		{
			this._ss.update_2(this._video);//update sensor status
			this._ms.update(this._ss);//update markersystem status
			if (this._ms.isExistMarker(marker_id)) {
				var p:NyARDoublePoint3d = new NyARDoublePoint3d();
				this._ms.getMarkerPlanePos(this.marker_id,this.bitmap.mouseX,this.bitmap.mouseY,p);

				var m:MatrixAway3D = new MatrixAway3D();
				m.clear();
				m.tx = p.x;
				m.ty = p.y;
				m.tz = p.z;
				var m2:MatrixAway3D = new MatrixAway3D();
				this._ms.getAway3dMarkerMatrix(this.marker_id,m2);
				m.multiply4x4(m2, m);
				this.marker_node.transform = m;
				this.marker_node.visible = true;
			}else {
				this.marker_node.visible = false;
			}
			this.bitmap.bitmapData.draw(this._video);
			this._view3d.render();
		}
	}
}