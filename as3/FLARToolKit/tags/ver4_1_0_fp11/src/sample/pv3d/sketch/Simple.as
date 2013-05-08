package sample.pv3d.sketch
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import jp.nyatla.as3utils.sketch.*;
	
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.support.pv3d.*;
	import org.papervision3d.lights.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.render.*;
	import org.papervision3d.scenes.*;
	import org.papervision3d.view.*;
	
	import sample.pv3d.sketchSimple.PV3DHelper;

	/**
	 * MarkerSystemを使ったSimpleLiteの実装です。
	 * このサンプルは、FLSketchを使用し、ARAppBaseを模したベースを使用したプログラムです。
	 * 一つのマーカーしか扱えません。
	 */
	public class Simple extends ARAppBase
	{
		
		public function Simple()
		{
			super();
			
			isShowBinRaster = false;
		}
		
		public override function setup():void
		{
			// setup content files...
			fileId.push(setSketchFile("./resources/camera_param/camera_para.dat", URLLoaderDataFormat.BINARY));
			
			// Marker pattern file or marker png file
			fileId.push( setSketchFile("./resources/marker/flarlogo.pat", URLLoaderDataFormat.TEXT));
		}
		/**
		 * 3Dオブジェクト生成
		 */
		protected override function createObject():DisplayObject3D
		{
			//setup PV3d
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			return PV3DHelper.createFLARCube(light,80,0xff22aa, 0x75104e);
		}
	}
}