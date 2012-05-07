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
	 * MarkerSystemを使ったSimpleLiteMの実装です。
	 * hiroマーカ、kanjiマーカの２つを同時に認識します。
	 * このサンプルは、FLSketchを使用したプログラムです。
	 * PV3Dの初期化、Flashオブジェクトの配置などを省略せずに実装しています。
	 */
	public class SimpleLiteM extends FLSketch
	{
		private static const _CAM_W:int = 320;
		private static const _CAM_H:int = 240;
		private var _ss:FLARSensor;
		private var _ms:FLARPV3DMarkerSystem;
		public var bitmap:Bitmap = new Bitmap(new BitmapData(_CAM_W,_CAM_H));

		private var _video:Video;
		private var _render:LazyRenderEngine;
		
		private var marker1_id:int;
		private var marker1_node:DisplayObject3D;
		private var marker2_id:int;
		private var marker2_node:DisplayObject3D;
		
		public function SimpleLiteM()
		{
			//setup UI
			this.bitmap.x = 0;
			this.bitmap.y = 0;
			this.bitmap.width = _CAM_W;
			this.bitmap.height = _CAM_H;
            this.addChild(bitmap);
		}
		private var _fid:Vector.<int>=new Vector.<int>(4);
		public override function setup():void
		{
			//setup content files...
			this._fid[0]=this.setSketchFile("../../../data/camera_para.dat", URLLoaderDataFormat.BINARY);//0
			this._fid[1]=this.setSketchFile("../../../data/patt.hiro", URLLoaderDataFormat.TEXT);//1
			this._fid[2]=this.setSketchFile("../../../data/patt.kanji", URLLoaderDataFormat.TEXT);//2
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
			var cf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(_CAM_W, _CAM_H);//make configlation
			this._ss = new FLARSensor(new NyARIntSize(_CAM_W, _CAM_H));
			this._ms = new FLARPV3DMarkerSystem(cf);
			this.marker1_id = this._ms.addARMarker_2(String(this.getSketchFile(this._fid[1])), 16, 25, 80); //register AR Marker #1
			this.marker2_id = this._ms.addARMarker_2(String(this.getSketchFile(this._fid[2])), 16, 25, 80); //register AR Marker #2
			
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
			this.marker1_node = PV3DHelper.createFLARCube(light,80,0x00ff00, 0x0);
			this.marker1_node.visible = false;
			this.marker2_node = PV3DHelper.createFLARCube(light,80,0xff0000, 0x0);
			this.marker2_node.visible = false;
			//scene
			var s:Scene3D = new Scene3D();
			s.addChild(this.marker1_node);
			s.addChild(this.marker2_node);
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
			if (this._ms.isExistMarker(marker1_id)){
				this.marker1_node.visible = true;
				this._ms.getPv3dMarkerMatrix(this.marker1_id, this.marker1_node.transform);
			}else {
				this.marker1_node.visible = false;
			}
			if (this._ms.isExistMarker(marker2_id)){
				this.marker2_node.visible = true;
				this._ms.getPv3dMarkerMatrix(this.marker2_id, this.marker2_node.transform);
			}else {
				this.marker2_node.visible = false;
			}
			this.bitmap.bitmapData.draw(this._video);
			this._render.render();
		}
	}
}