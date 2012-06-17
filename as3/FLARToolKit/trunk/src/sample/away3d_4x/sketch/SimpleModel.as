package sample.away3d_4x.sketch
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.LoaderEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import sample.away3d_4x.sketchSimple.Away3DHelper;
	

	/**
	 * MarkerSystemを使ったSimpleLiteの実装で、モデルデータを表示するサンプルです。
	 * このサンプルは、FLSketchを使用し、ARAppBaseを模したベースを使用したプログラムです。
	 * 一つのマーカーしか扱えません。
	 * 
	 * あまり良い実装方法ではありません。
	 * ARAppBaseを改良して実装し直すことをおすすめします。
	 */
	public class SimpleModel extends ARAppBase
	{
		
		protected var _loader3d:Loader3D;
		
		protected var _isResourceComplete:Boolean = false;
		
		public function SimpleModel()
		{
			super();
			
			isShowBinRaster = false;
			
			loadModel();
		}
		
		protected function loadModel():void
		{
			Parsers.enableAllBundled();
			
			_loader3d = new Loader3D();
			
			_loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader3d.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			
			_loader3d.load( new URLRequest("./resources/model/earth.3ds"));
		}
		
		protected function onResourceComplete(evt:LoaderEvent):void
		{
			_isResourceComplete = true;
		}
		
		private function onLoadError(ev : LoaderEvent) : void
		{
			_loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader3d.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader3d = null;
		}
		
		public override function setup():void
		{
			// setup content files...
			fileId.push(setSketchFile("./resources/camera_param/camera_para.dat", URLLoaderDataFormat.BINARY));
			
			// Marker pattern file or marker png file
			fileId.push(setSketchFile("./resources/marker/flarlogo.pat", URLLoaderDataFormat.TEXT));
			
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected override function createObject():ObjectContainer3D
		{
			// ここで変形しても、onEnterFrameで打ち消される
			return _loader3d;
		}
		
		protected override function _objectTransform(_container:ObjectContainer3D):void
		{
			_container.rotate(new Vector3D(1, 0, 0), 90);
			_container.scale(8);
		}
	}
}