/**
 * FLARToolKit example - Simple cube PV3D
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 rokubou
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 * 
 * Contributors
 *  rokubou
 * 
 * !!ATTENTION!!
 *  This is a source code while experimenting. 
 *  I want you to teach when there is a good correction method. 
 */
package examples
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Cube6;
	import away3dlite.primitives.Plane;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import jp.nyatla.as3utils.NyMultiFileLoader;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.away3d_lite.FLARBaseNode;
	import org.libspark.flartoolkit.support.away3d_lite.FLARCamera3D;
	

	public class FLARTK_Example_Single_SimpleCube_Away3DLite extends Sprite
	{
		
		/**
		 * 画面の幅と高さ
		 */
		protected var canvasWidth:int;
		protected var canvasHeight:int;
		
		/**
		 * 画面の幅と高さ
		 */
		protected var captureWidth:int;
		protected var captureHeight:int;
		
		/**
		 * マーカーの一辺の長さ(px)
		 */
		protected var codeWidth:int;
		
		/**
		 * カメラパラメータのファイル名
		 * 内部的に初期化される処理が含まれるので読み込む必要は無い。
		 * 例外的に 16:9 で使う場合は、それようのパラメータファイルを読み込むこと。
		 */
		protected var cameraParamFile:String;
		
		/**
		 * マーカーパターンのファイル名
		 */
		protected var markerPatternFile:String;

		/**
		 * カメラパラメータデータ
		 * アスペクト比や歪みなどの補正のための情報が含まれる
		 * @see org.libspark.flartoolkit.core.param.FLARParam
		 */
		protected var cameraParam:FLARParam;
		
		/**
		 * マーカーパターン
		 * マーカーを複数パターン使う場合はVectorなどで管理する
		 * @see org.libspark.flartoolkit.core.FLARCode
		 */
		protected var markerPatternCode:FLARCode;
		
		/**
		 * @see flash.media.Camera
		 */
		protected var webCamera:Camera;
		
		/**
		 * flash.media.Video
		 */
		protected var video:Video;
		
		/**
		 * Webカメラからの入力をBitmapに確保する
		 * @see flash.display.Bitmap
		 */
		private var capture:Bitmap;
		
		/**
		 * ラスタイメージ
		 * @see org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData
		 */
		private var raster:FLARRgbRaster_BitmapData;
		
		/**
		 * Marker detector
		 * @see org.libspark.flartoolkit.detector.FLARSingleMarkerDetector
		 */
		private var detector:FLARSingleMarkerDetector;
		
		/**
		 * 画像二値化の際のしきい値
		 * 固定値で使用する場合は、使用場所を想定して値を設定してください。
		 * 認識に差が生じます。
		 */
		private var _threshold:int = 110;
		
		/**
		 *  しきい値の自動調整用のクラス
		 * @see org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile
		 */
		private var _threshold_detect:FLARRasterThresholdAnalyzer_SlidePTile;
		
		/**
		 * 3Dモデル表示用
		 * @see away3d.containers.View3D
		 */
		protected var view3d:View3D;
		
		/**
		 * 3Dモデル表示用
		 * @see org.papervision3d.scenes.Scene3D
		 */
		protected var scene3d:Scene3D;
		
		/**
		 * 3Dモデル表示字の視点
		 * @see org.libspark.flartoolkit.support.away3d_lite.FLARCamera3D
		 */
		protected var camera3d:FLARCamera3D;
		
		/**
		 * Marker base node
		 * @see org.libspark.flartoolkit.support.away3d_lite.FLARBaseNode
		 */
		protected var markerNode:FLARBaseNode;
		
		/**
		 * 表示モデルを一括して押し込めるコンテナ
		 * @see away3d.containers.ObjectContainer3D
		 */
		protected var container:ObjectContainer3D;
		
		/**
		 * 認識したマーカーの情報を格納
		 * @see org.libspark.flartoolkit.core.transmat.FLARTransMatResult
		 */
		protected var resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		/**
		 * Constructor
		 * ここから初期化処理を呼び出して処理をスタート
		 */
		public function FLARTK_Example_Single_SimpleCube_Away3DLite()
		{
			this.init();
		}
		
		/**
		 * initialize
		 *	各種サイズの初期化
		 */
		protected function init():void
		{
			// 各種サイズの初期化
			this.captureWidth = 320;
			this.captureHeight = 240;
			
			// W:H の比率は必ず captureWidth:captureHeight=canvasWidth:canvasHeight にすること
			this.canvasWidth = 640
			this.canvasHeight = 480;
			
			// マーカーの一辺の長さ(px)
			this.codeWidth = 80;
			
			// カメラパラメータファイル
			// 16：9 の比率で使う場合は、camera_para_16x9.dat を使ってください
			this.cameraParamFile = '../resources/Data/camera_para.dat';
			
			// マーカーのパターンファイル
			this.markerPatternFile = '../resources/Data/flarlogo.pat';

			// パラメータのロード
			this.paramLoad();
		}
		
		/**
		 * カメラパラメータなどを読み込み、変数にロード
		 *@return void
		 */
		private function paramLoad():void
		{
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				this.cameraParamFile, URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
	 				cameraParam = new FLARParam();
					cameraParam.loadARParam(data);
					cameraParam.changeScreenSize(captureWidth, captureHeight);
				});
			mf.addTarget(
				this.markerPatternFile, URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					// 分割数(縦・横)、黒枠の幅(縦・横)
					markerPatternCode = new FLARCode(16, 16);
					markerPatternCode.loadARPattFromFile(data);
				}
			);
			//終了後、初期化処理に遷移するように設定
			mf.addEventListener(Event.COMPLETE, initialization);
			//ロード開始
			mf.multiLoad();
			
			return;
		}
		
		/**
		 * webカメラや表示、detectorの初期化
		 * @return void
		 */
		private function initialization(e:Event): void
		{
			this.removeEventListener(Event.COMPLETE, initialization);
			
			// Setup camera
			this.webCamera = Camera.getCamera();
			if (!this.webCamera) {
				throw new Error('No webcam!!!!');
			}
			this.webCamera.setMode( this.captureWidth, this.captureHeight, 30);
			this.video = new Video( this.captureWidth, this.captureHeight);
			this.video.attachCamera(this.webCamera);
			
			// setup ARToolkit
			this.capture = new Bitmap(new BitmapData(this.captureWidth, this.captureHeight, false, 0),
										  PixelSnapping.AUTO,
										  true);
			// ウェブカメラの解像度と表示サイズが異なる場合は拡大する
			this.capture.width = this.canvasWidth;
			this.capture.height = this.canvasHeight;
			
			// キャプチャーしている内容からラスタ画像を生成
			this.raster = new FLARRgbRaster_BitmapData( this.capture.bitmapData);
			
			// キャプチャーしている内容を addChild
			this.addChild(this.capture);
			
			// setup Single marker detector
			this.detector = new FLARSingleMarkerDetector( this.cameraParam,
														  this.markerPatternCode,
														  this.codeWidth);
			// 継続認識モード発動
			this.detector.setContinueMode(true);
			// しきい値調整
			this._threshold_detect=new FLARRasterThresholdAnalyzer_SlidePTile(15,4);
			
			// 初期化完了
			dispatchEvent(new Event(Event.INIT));
			
			// 3Dオブジェクト関係の初期化へ
			this.supportLibsInit();
			
			// スタート
			this.start();
		}
		
		/**
		 * 3Dオブジェクト関係の初期化
		 * 使用する3Dライブラリに応じてこの部分を書き換える。
		 */
		protected function supportLibsInit(): void
		{
			
			// シーンの生成
			this.scene3d = new Scene3D();
			
			// 3Dモデル表示時の視点を設定
			var _viewportToSourceWidthRatio:Number = this.canvasWidth/this.captureWidth;
			trace("viewRatio :"+_viewportToSourceWidthRatio+"/width"+this.captureWidth);
			this.camera3d = new FLARCamera3D(this.cameraParam, _viewportToSourceWidthRatio);
			
			
			// PV3DのViewport3Dと似たようなもの
			this.view3d = new View3D(this.scene3d, this.camera3d);
			
			// 微調整
			this.view3d.scaleX = this.canvasWidth;
			this.view3d.scaleY = this.canvasHeight;
//			this.view3d.x = this.canvasWidth/_viewportToSourceWidthRatio ;
//			this.view3d.y = this.canvasHeight/_viewportToSourceWidthRatio;
			this.view3d.z = 0;
			
			this.addChild(this.view3d);
			
			this.markerNode = new FLARBaseNode();
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected function createObject():void
		{
			
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff);
			// 透過度を設定
			wmat.alpha = 1;
			
			var _plane:Plane = new Plane(); // 80mm x 80mm。
			_plane.width = 80;
			_plane.height = 80;
			_plane.material = wmat;
			
			// Cube
			var mat:WireColorMaterial = new WireColorMaterial(0xFF1919, 1, 0x730000);
			var _cube:Cube6 = new Cube6( mat, 40, 40, 40);
			_cube.y = -20
			
 			// _container に 追加
			this.container.addChild(_plane);
			this.container.addChild(_cube);
		}
		
		/**
		 * 3Dオブジェクトの生成と登録
		 * マーカーイベント方式を採用しているため、markerイベントを登録
		 * スレッドのスタート
		 */
		protected function start():void
		{
			// モデル格納用のコンテナ作成
			this.container = new ObjectContainer3D();
			
			// 3Dオブジェクト生成
			this.createObject();
			
			// Marker Node に追加
			this.markerNode.addChild(this.container);

			// Scene に追加
			this.scene3d.addChild(this.markerNode);
			
			// マーカー認識・非認識時用のイベントを登録
			this.addEventListener(MarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.addEventListener(MarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.addEventListener(MarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			// 処理開始
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		/**
		 * マーカーを認識するとこの処理が呼ばれる
		 */
		public function onMarkerAdded(e:Event=null):void
		{
//			trace("[add]");
			this.detector.getTransformMatrix(this.resultMat);
			this.markerNode.setTransformMatrix(this.resultMat);
			this.view3d.visible = true;
		}
		
		/**
		 * マーカーの継続認識中はここ
		 * このサンプルではこの処理が呼ばれるような実装していない。
		 */
		public function onMarkerUpdated(e:Event=null):void
		{
			// 今回は実装していない
		}
		
		/**
		 * マーカーが認識できなくなるとこれが呼ばれる
		 */
		public function onMarkerRemoved(e:Event=null):void
		{
			this.view3d.visible = false;
		}
		
		/**
		 * ここで処理振り分けを行っている
		 */
		public function run(e:Event):void
		{
			this.capture.bitmapData.draw(this.video);
			
			// Marker detect
			var detected:Boolean = false;
			try {
				detected = this.detector.detectMarkerLite(this.raster, this._threshold) && this.detector.getConfidence() > 0.5;
			} catch (e:Error) {}
			
			// 認識時の処理
			if (detected) {
				// 一工夫できる場所
				// 前回認識した場所と今回認識した場所の距離を測り、
				// 一定範囲なら位置情報更新 MARKER_UPDATED を発行するなど、
				// 楽しい工夫が出来る。 参照: FLARManager
				this.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_ADDED));
			// 非認識時
			} else {
				this.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_REMOVED));
				// マーカがなければ、探索+DualPTailで基準輝度検索
				// マーカーが見つからない場合、処理が重くなるので状況に応じてコメントアウトすると良い
				var th:int=this._threshold_detect.analyzeRaster(this.raster);
				this._threshold=(this._threshold+th)/2;
			}
			this.view3d.render();
		}
	}
}

import flash.events.Event;

/**
 * イベント制御用の簡易クラス
 */
class MarkerEvent extends Event
{
	/**
	 * Markerを認識した時
	 */
	public static const MARKER_ADDED:String = "markerAdded";
	
	/**
	 * Marker更新時
	 */
	public static const MARKER_UPDATED:String = "markerUpdated";
	
	/**
	 * Markerが認識しなくなった時
	 */
	public static const MARKER_REMOVED:String = "markerRemoved";
	
	public function MarkerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
}