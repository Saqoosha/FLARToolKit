package sample.away3d_4x.sketch
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.partition.LightNode;
	import away3d.lights.DirectionalLight;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.media.Video;
	
	import jp.nyatla.as3utils.sketch.FLSketch;
	
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	import org.libspark.flartoolkit.markersystem.FLARMarkerSystemConfig;
	import org.libspark.flartoolkit.markersystem.FLARSensor;
	import org.libspark.flartoolkit.support.away3dv40.FLARAway3DMarkerSystem;
	import org.libspark.flartoolkit.support.away3dv40.FLARWebCamTexture;
	
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
		protected var markerSys:FLARAway3DMarkerSystem;
		
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
		protected var container:ObjectContainer3D;
		
		/**
		 * 3D Renderer
		 */
		protected var view3d:View3D;
		
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
			// View3d初期化
			view3d = new View3D();
			// 起点
			view3d.x = 0;
			view3d.y = 0;
			// サイズ
			view3d.width  = stage.width;
			view3d.height = stage.height;
			
			view3d.scaleX = canvasWidth / captureWidth;
			view3d.scaleY = canvasHeight / captureHeight;
			
			view3d.background = new FLARWebCamTexture(captureWidth, captureHeight);
			view3d.camera = markerSys.getAway3DCamera();
			//3d object
			container = createObject();
			container.visible = false;
			
			view3d.scene.addChild(container);
			
			// Add View
			addChild(view3d);
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected function createObject():ObjectContainer3D
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
			
			// FLMarkerSystem
			// make configlation
			var markerSysConf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(getSketchFile(fileId[0]), rasterWidth, rasterHeight);
			arSensor  = new FLARSensor(new FLARIntSize(rasterWidth, rasterHeight));
			markerSys = new FLARAway3DMarkerSystem(markerSysConf);
			
			//register AR Marker
			marker_id = this.markerSys.addARMarker_2(getSketchFile(fileId[1]), 16, 25, 80);
			
			//setup Away3d
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
			
			FLARWebCamTexture(view3d.background).update(video);
			
			if (markerSys.isExistMarker(marker_id)){
				container.visible = true;
				var resultMat:Matrix3D = new Matrix3D();
				markerSys.getAway3dMarkerMatrix(marker_id, resultMat);
				container.transform = resultMat;
				_objectTransform(container);
				
			}else {
				container.visible = false;
			}
			// 解析中のにちか画像を確認するための処理
			if (isShowBinRaster) {
				this.addChild(new Bitmap(arSensor.getBinImage(markerSys.getCurrentThreshold()).getBitmapData()));
			}
			// 
			view3d.render();
		}
		
		/**
		 * transmatを適応後に何かする場合はオーバーライドして実装すること。
		 */
		protected function _objectTransform(_container:ObjectContainer3D):void
		{
			// 何もしない
		}
	}
}