package sample.away3d_4x.sketch
{
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	
	import sample.away3d_4x.sketchSimple.Away3DHelper;
	

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
		protected override function createObject():ObjectContainer3D
		{
			// light
			var light:DirectionalLight = new DirectionalLight();
			light.direction = new Vector3D( -1, -1, -1);
			light.ambient  = 0.5;
			light.diffuse  = 0.9;
			light.specular = 0.5;
			
			return Away3DHelper.createFLARCube(80, light);
		}
		
		protected override function _objectTransform(_container:ObjectContainer3D):void
		{
			_container.getChildAt(1).rotate(new Vector3D(0, 0, 1), 2);
		}

	}
}