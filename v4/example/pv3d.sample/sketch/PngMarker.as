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
	 * MarkerSystemを使ったSimpleLiteの実装です。
	 * Webcamの画像の変わりに、既にあるJpeg画像を使います。
	 * このサンプルは、FLSketchを使用したプログラムです。
	 * PV3Dの初期化、Flashオブジェクトの配置などを省略せずに実装しています。
	 */
	public class PngMarker extends FLSketch
	{
		private static const _CAM_W:int = 320;
		private static const _CAM_H:int = 240;
		private var _ss:FLARSensor;
		private var _ms:FLARPV3DMarkerSystem;
		public var bitmap:Bitmap = new Bitmap(new BitmapData(_CAM_W,_CAM_H));

		private var _video:Video;
		private var _render:LazyRenderEngine;
		
		private var marker_id:int;
		private var marker_node:DisplayObject3D;
		
		public function PngMarker()
		{
			//setup UI
			this.bitmap.x = 0;
			this.bitmap.y = 0;
			this.bitmap.width = _CAM_W;
			this.bitmap.height = _CAM_H;
            this.addChild(bitmap);
		}
		private var _fid:Vector.<int>=new Vector.<int>(3);
		public override function setup():void
		{
			//setup content files...
			this._fid[0]=this.setSketchFile("../../../data/camera_para.dat", URLLoaderDataFormat.BINARY);//0
			this._fid[1] = this.setSketchFile("../../../data/hiro.png","AS_OBJECT");//1
			this._fid[2] = this.setSketchFile("../../../data/320x240ABGR.jpg","AS_OBJECT");//2
		}
		private var _patt:Bitmap;

		public override function main():void
		{
			//image
			var ld:Loader = new Loader();
			this._patt = this.getSketchFile(this._fid[2]);
			//FLMarkerSystem
			var cf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(this.getSketchFile(this._fid[0]),_CAM_W, _CAM_H);//make configlation
			this._ss = new FLARSensor(new NyARIntSize(_CAM_W, _CAM_H));
			this._ms = new FLARPV3DMarkerSystem(cf);
			this.marker_id = this._ms.addARMarker_5(this.getSketchFile(this._fid[1]), 16, 25, 80); //register AR Marker
			
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
			this.marker_node = PV3DHelper.createFLARCube(light,80,0xff22aa, 0x75104e);
			this.marker_node.visible = false;
			//scene
			var s:Scene3D = new Scene3D();
			s.addChild(this.marker_node);
			this._render=new LazyRenderEngine(s,this._ms.getPV3DCamera(),viewport3d);
			
			update();// 1 st not effective...??
			update();
		}
		/**
		 * MainLoop
		 * @param	e
		 */
		private function update():void
		{
			this._ss.update_2(this._patt);//update sensor status
			this._ms.update(this._ss);//update markersystem status
			if (this._ms.isExistMarker(marker_id)){
				this.marker_node.visible = true;
				this._ms.getPv3dMarkerMatrix(this.marker_id, this.marker_node.transform);
			}else {
				this.marker_node.visible = false;
			}
			this.bitmap.bitmapData.draw(this._patt);
			this._render.render();
		}
	}


}