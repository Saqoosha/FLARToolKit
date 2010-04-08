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
 */
package examples
{
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
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	

	public class FLARTK_Example_Single_SimpleCube_PV3D extends Sprite
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
		 * 3Dモデル表示用
		 * @see org.papervision3d.view.Viewport3D
		 */
		protected var viewport3d:Viewport3D;
		
		/**
		 * 3Dモデル表示用
		 * @see org.papervision3d.scenes.Scene3D
		 */
		protected var scene3d:Scene3D;
		
		/**
		 * 3Dモデル表示字の視点
		 * @see org.libspark.flartoolkit.support.pv3d.FLARCamera3D
		 */
		protected var camera3d:FLARCamera3D;
		
		/**
		 * Marker base node
		 * @see org.libspark.flartoolkit.support.pv3d.FLARBaseNode
		 */
		protected var markerNode:FLARBaseNode;
		
		/**
		 * 3D Renderer
		 * @see org.papervision3d.render.LazyRenderEngine
		 */
		protected var renderer:LazyRenderEngine;
		
		/**
		 * 表示モデルを一括して押し込めるコンテナ
		 * @see org.papervision3d.objects.DisplayObject3D
		 */
		protected var container:DisplayObject3D;
		
		/**
		 * 認識したマーカーの情報を格納
		 * @see org.libspark.flartoolkit.core.transmat.FLARTransMatResult
		 */
		protected var resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		/**
		 * Constructor
		 * ここから初期化処理を呼び出して処理をスタート
		 */
		public function FLARTK_Example_Single_SimpleCube_PV3D()
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
			this.viewport3d = new Viewport3D(this.captureWidth,
											  this.captureHeight);
			this.addChild(this.viewport3d);
			this.viewport3d.scaleX = this.canvasWidth / this.captureWidth;
			this.viewport3d.scaleY = this.canvasHeight / this.captureHeight;
			this.viewport3d.x = -4; // 4pix ???
			
			// シーンの生成
			this.scene3d = new Scene3D();
			this.markerNode = this.scene3d.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			// 3Dモデル表示時の視点を設定
			this.camera3d = new FLARCamera3D(this.cameraParam);
			
			// setup renderer
			this.renderer = new LazyRenderEngine(this.scene3d, this.camera3d, this.viewport3d);
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected function createObject(_container:DisplayObject3D):void
		{
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff, 1, 2);
			var _plane:Plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			
			// ライトの設定。手前、上のほう。
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			// Cube
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0x0000FF, 0x000066);
			var _cube:Cube = new Cube(new MaterialsList( { all:fmat } ), 40, 40, 40);
			_cube.z = 20;
			
 			// _container に 追加
			_container.addChild(_plane);
			_container.addChild(_cube);
		}
		
		/**
		 * 3Dオブジェクトの生成と登録
		 * マーカーイベント方式を採用しているため、markerイベントを登録
		 * スレッドのスタート
		 */
		protected function start():void
		{
			// モデル格納用のコンテナ作成
			this.container = new DisplayObject3D();
			// 3Dオブジェクト生成
			this.createObject(this.container);
			// Marker Node に追加
			this.markerNode.addChild(this.container);
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
			this.markerNode.visible = true;
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
			this.markerNode.visible = false;
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
				detected = this.detector.detectMarkerLite(this.raster, 80) && this.detector.getConfidence() > 0.5;
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
			}
			this.renderer.render();
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