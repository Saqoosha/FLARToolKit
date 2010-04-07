/**
 * FLARToolKit example launcher
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
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class FLARToolKit_Sample_SimpleCube_PV3D extends Sprite
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
		 * パラメータファイル、マーカーパターンファイルの読込み用
		 * @see flash.net.URLLoader
		 */
		private var urlLoader:URLLoader;
		
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
		 */
		protected var scene:Scene3D;
		
		/**
		 * 3Dモデル表示用
		 */
		protected var viewport:Viewport3D;
		
		/**
		 * 3Dモデル表示字の視点
		 */
		protected var camera3D:FLARCamera3D;
		
		/**
		 * Marker base node
		 */
		protected var markerNode:FLARBaseNode;
		
		/**
		 * 3D Renderer
		 */
		protected var renderer:LazyRenderEngine;
		
		/**
		 * 表示モデルを一括して押し込めるコンテナ
		 */
		protected var container:DisplayObject3D;
		
		private var plane:Plane;
		// private var _cube:Cube;
		
		/**
		 * Constructor
		 * ここから初期化処理を呼び出して処理をスタート
		 */
		public function FLARToolKit_Sample_SimpleCube_PV3D()
		{
			
			this.initialize();
		}
		
		/**
		 * initialize
		 *  各種サイズの初期化
		 */
		protected function initialize():void
		{
			// 各種サイズの初期化
			captureWidth = 320;
			captureHeight = 240;
			canvasWidth = 640
			canvasHeight = 480;
			codeWidth = 80;
			
			//
			markerPatternFile = '../resources/Data/flarlogo.pat';
			
			// パラメータファイルの読込み
			// 今回は省略して初期値を用いる
			this.cameraParam = new FLARParam();
			this.cameraParam.changeScreenSize(captureWidth, captureHeight);
			
			// マーカーパターンファイルの読込み
			this.urlLoader = new URLLoader();
			this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			this.urlLoader.addEventListener(Event.COMPLETE, this.onLoadCode);
			this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			this.urlLoader.load(new URLRequest(markerPatternFile));
		}
		
		/**
		 * マーカーパターンを読み込む
		 * @param e Event
		 */
		protected function onLoadCode(e:Event):void
		{
			// URL Loader関連のイベントを削除
			this.urlLoader.removeEventListener(Event.COMPLETE, this.onLoadCode);
			
			// 分割数(縦・横)、黒枠の幅(縦・横)
			this.markerPatternCode = new FLARCode(16, 16, 50, 50);
			this.markerPatternCode.loadARPatt(this.urlLoader.data);
			// loaderがgc対象になるようにnullを突っ込む
			this.urlLoader = null;
			
			// 初期化
			dispatchEvent(new Event(Event.INIT));
			this.onInit();
		}
		
		/**
		 * Webカメラの設定と、ARToolKitの準備
		 */
		protected function onInit():void
		{
			// setup webcam
			this.webCamera = Camera.getCamera();
			if (!this.webCamera) {
				throw new Error('No webcamera!');
			}
			this.webCamera.setMode(this.captureWidth, this.captureHeight, 30);
			
			this.video = new Video( this.captureWidth, this.captureHeight);
			this.video.attachCamera(this.webCamera);
			
			// setup ARToolKit
			this.capture = new Bitmap(new BitmapData(this.captureWidth, this.captureHeight, false, 0),
									   PixelSnapping.AUTO,
									   true);
			// ウェブカメラの解像度と表示サイズが異なる場合は拡大する
			this.capture.width = this.canvasWidth;
			this.capture.height= this.canvasHeight;
			this.addChild(this.capture);
			
			this.raster = new FLARRgbRaster_BitmapData(this.capture.bitmapData);
			// setup Single marker detector
			this.detector = new FLARSingleMarkerDetector(this.cameraParam,
														  this.markerPatternCode,
														  this.codeWidth);
			this.detector.setContinueMode(true);
			
			// 表示関係の設定(使用するライブラリによって変化します)
			this.viewport = this.addChild(new Viewport3D(this.captureWidth,
														  this.captureHeight)) as Viewport3D;
			this.viewport.scaleX = this.canvasWidth / this.captureWidth;
			this.viewport.scaleY = this.canvasHeight / this.captureHeight;
			this.viewport.x = -4; // なぜかずれるので補正
			
			// 
			this.scene = new Scene3D();
			this.markerNode = this.scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			// 3Dモデル表示時の視点を設定
			this.camera3D = new FLARCamera3D(this.cameraParam);
			
			// setup renderer
			this.renderer = new LazyRenderEngine(this.scene, this.camera3D, this.viewport);
			
			// モデル格納用のコンテナ作成
			this.container = new DisplayObject3D();
			// モデルデータ
			this.setModelData();
			// モデルデータを登録
			this.markerNode.addChild(this.container);
			
			// start
			this.start();
		}
		
		/**
		 * モデルデータを書く場所
		 */
		protected function setModelData():void
		{
			// ワイヤーフレームで、マーカーと同じサイズのPlaneを作成
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff, 1, 2);
			this.plane = new Plane(wmat, 80, 80);
			this.plane.rotationX = 180;
			this.container.addChild(this.plane);
		}
		
		/**
		 * マーカーの認識と3次元モデルの描写を開始する
		 */
		public function start():void
		{
			// マーカー認識・非認識時用のイベントを登録
			this.addEventListener(MarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.addEventListener(MarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.addEventListener(MarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			// 処理開始
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		/**
		 * 認識したマーカーの情報を格納
		 */
		protected var resultMat:FLARTransMatResult = new FLARTransMatResult();

		public function onMarkerAdded(e:Event=null):void
		{
//			trace("[add]");
			this.detector.getTransformMatrix(this.resultMat);
			this.markerNode.setTransformMatrix(this.resultMat);
			this.markerNode.visible = true;
		}
		
		public function onMarkerUpdated(e:Event=null):void
		{
			// 今回は実装していない
		}

		public function onMarkerRemoved(e:Event=null):void
		{
			this.markerNode.visible = false;
//			this.renderer.render();
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
