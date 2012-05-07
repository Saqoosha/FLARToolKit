package sketch 
{
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
	import org.libspark.flartoolkit.pv3d.*;
	import org.papervision3d.render.*;
	import org.papervision3d.view.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.lights.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.scenes.*;
	/**
	 * MarkerSystemの、マーカ平面画像取得のデモです。
	 * 撮影画像から、マーカパターンを取得します。
	 * マーカには、hiroマーカを使います。
	 * このサンプルは、FLSketchを使用したプログラムです。
	 * PV3Dの初期化、Flashオブジェクトの配置などを省略せずに実装しています。
	 */
	public class ImagePickup extends FLSketch
	{
		private static const _CAM_W:int = 320;
		private static const _CAM_H:int = 240;
		private var _ss:FLARSensor;
		private var _ms:FLARPV3DMarkerSystem;
		public var bitmap:Bitmap = new Bitmap(new BitmapData(_CAM_W,_CAM_H));
		public var patt:Bitmap = new Bitmap(new BitmapData(64,64));

		private var _video:Video;
		private var _render:LazyRenderEngine;
		
		private var marker_id:int;
		private var marker_node:DisplayObject3D;
		
		public function ImagePickup()
		{
			//setup UI
			this.bitmap.x = 0;
			this.bitmap.y = 0;
			this.bitmap.width = _CAM_W;
			this.bitmap.height = _CAM_H;
            this.addChild(this.bitmap);
			this.patt.x = 0;
			this.patt.y = 0;
            this.addChild(this.patt);
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
			this._ms = new FLARPV3DMarkerSystem(cf);
			this.marker_id = this._ms.addARMarker_2(this.getSketchFile(this._fid[1]), 16, 25, 80); //register AR Marker
			
			//setup PV3d
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;			
			var viewport3d:Viewport3D = new Viewport3D(_CAM_W,_CAM_H);
			viewport3d.scaleX = 1;
			viewport3d.scaleY = 1;
			viewport3d.x = -4; // 4pix ???
			this.addChild(viewport3d);
			//3d object
			this.marker_node = PV3DHelper.createFLText("detect", 80, 0.5, 0xff0000);
			this.marker_node.visible = false;
			//scene
			var s:Scene3D = new Scene3D();
			s.addChild(this.marker_node);
			this._render=new LazyRenderEngine(s,this._ms.getPV3DCamera(),viewport3d);
			
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
				this.marker_node.visible = true;
				this.patt.visible = true;
				this._ms.getPv3dMarkerMatrix(this.marker_id, this.marker_node.transform);
				this._ms.getMarkerPlaneImage_4(this.marker_id, this._ss, -40, -40, 80, 80, this.patt.bitmapData);
			}else {
				this.marker_node.visible = false;
				this.patt.visible = false;
			}
			this.bitmap.bitmapData.draw(this._video);
			this._render.render();
		}
	}

}