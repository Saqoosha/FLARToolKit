package sample.pv3d.sketch
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	
	import jp.nyatla.as3utils.sketch.FLSketch;
	
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	import org.libspark.flartoolkit.markersystem.FLARMarkerSystemConfig;
	import org.libspark.flartoolkit.markersystem.FLARSensor;
	import org.libspark.flartoolkit.support.pv3d.FLARPV3DMarkerSystem;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	import sample.pv3d.sketchSimple.PV3DHelper;
	
	public class ARAppBase extends FLSketch
	{
		
		/**
		 * 画面の幅と高さ
		 */
		protected var canvasWidth:int;
		protected var canvasHeight:int;
		
		/**
		 * Webcameraのキャプチャーサイズの幅と高さ
		 */
		protected var captureWidth:int;
		protected var captureHeight:int;
		
		/**
		 * ARマーカー検出に使用する解析画像の幅と高さ
		 */
		protected var rasterWidth:int;
		protected var rasterHeight:int;
		
		/**
		 * rasterサイズ変形用パラメータ
		 */
		protected var scaleRatio:Matrix;
		
		/**
		 * マーカーの一辺の長さ(px)
		 */
		protected var codeWidth:int;
		
		/**
		 * @see flash.media.Camera
		 */
		protected var webCamera:Camera;
		
		/**
		 * flash.media.Video
		 */
		protected var video:Video;
		
		/**
		 * 入力映像などを管理するクラス
		 */
		protected var arSensor:FLARSensor;
		
		/**
		 * Marker System
		 */
		protected var markerSys:FLARPV3DMarkerSystem;
		
		/**
		 * fileID 管理用
		 */
		protected var fileId:Vector.<int>=new Vector.<int>();
		
		/**
		 * マーカー管理用スタック
		 */
		protected var marker_id:int;
		
		/**
		 * 表示モデルを一括して押し込めるコンテナ
		 */
		protected var container:DisplayObject3D;
		
		/**
		 * 3D Renderer
		 * @see org.papervision3d.render.LazyRenderEngine
		 */
		protected var renderer:LazyRenderEngine;
		
		/**
		 * 二値化画像を表示するためのフラグ
		 */
		protected var isShowBinRaster:Boolean = false;
		
		/**
		 * コンストラクタ
		 */
		public function ARAppBase()
		{
			sizeParamSetup();
			super();
		}
		
		/**
		 * 各種サイズの初期化
		 * 値を変更する場合は、このメソッドをオーバーライドしてください。
		 */
		public function sizeParamSetup():void
		{
			// ウェブカメラからの取り込みサイズを設定
			captureWidth  = 640;
			captureHeight = 480;
			
			// マーカー検出に使う画像のサイズを設定
			rasterWidth  = 320;
			rasterHeight = 240;
			
			// W:H の比率は必ず captureWidth:captureHeight=canvasWidth:canvasHeight にすること
			canvasWidth  = captureWidth
			canvasHeight = captureHeight;
			
			// マーカーの一辺の長さ(px)
			codeWidth = 80;
			
			// resize parametor
			scaleRatio = new Matrix();
			scaleRatio.scale( rasterWidth/captureWidth, rasterHeight/captureHeight)
			
		}
		
		/**
		 * 3Dオブジェクト関係の初期化
		 * 使用する3Dライブラリに応じてこの部分を書き換える。
		 */
		public function supportLibsInit(): void
		{
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;			
			var viewport3d:Viewport3D = new Viewport3D(canvasWidth, canvasHeight);
			
			viewport3d.scaleX = canvasWidth / captureWidth;
			viewport3d.scaleY = canvasHeight / captureHeight;
			// ズレが生じるため調整。ズレる理由は不明。
			viewport3d.x = -4;
			addChild(viewport3d);
			
			//3d object
			container = createObject();
			container.visible = false;
			
			//scene
			var s:Scene3D = new Scene3D();
			s.addChild(container);
			renderer = new LazyRenderEngine(s, markerSys.getPV3DCamera(), viewport3d);
			
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected function createObject():DisplayObject3D
		{
			throw new FLARException();
		}
		
		/* 
		 * orverride
		 */
		public override function main():void
		{
			//webcam
			var webcam:Camera = Camera.getCamera();
			if (!webcam) {
				throw new Error('No webcam!!!!');
			}
			webcam.setMode(captureWidth, captureHeight, 30);
			video = new Video(captureWidth, captureHeight);
			video.clear();
			video.attachCamera(webcam);
			
			// キャプチャーしている内容を addChild
			addChild(video);
			
			// FLMarkerSystem
			// make configlation
			var markerSysConf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(getSketchFile(fileId[0]), rasterWidth, rasterHeight);
			arSensor  = new FLARSensor(new FLARIntSize(rasterWidth, rasterHeight));
			markerSys = new FLARPV3DMarkerSystem(markerSysConf);
			//register AR Marker
			marker_id = this.markerSys.addARMarker_2(getSketchFile(fileId[1]), 16, 25, 80);
			
			//setup PV3d
			supportLibsInit();
			
			//start camera
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		/**
		 * MainLoop
		 * @param	e
		 */
		protected function _onEnterFrame(e:Event = null):void
		{
			// update sensor status
			arSensor.update_3(video, scaleRatio);
			
			// update markersystem status
			markerSys.update(arSensor);
			
			if (markerSys.isExistMarker(marker_id)){
				container.visible = true;
				markerSys.getPv3dMarkerMatrix(marker_id, container.transform);
			}else {
				container.visible = false;
			}
			// 解析中のにちか画像を確認するための処理
			if (isShowBinRaster) {
				this.addChild(new Bitmap(arSensor.getBinImage(markerSys.getCurrentThreshold()).getBitmapData()));
			}
			renderer.render();
		}

	}
}