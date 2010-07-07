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
 * Contributor(s)
 *  rokubou
 * 
 * Comment
 *  This is not a too good sample. 
 *  If you want to handle the multi marker, I am recommending FLARManager to be used.
 *  FLARManager
 *  http://words.transmote.com/wp/flarmanager/
 * 
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
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetector;
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
	

	public class FLARTK_Example_Multiple_SimpleCube_PV3D extends Sprite
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
		 * カメラパラメータのファイル名
		 * 内部的に初期化される処理が含まれるので読み込む必要は無い。
		 * 例外的に 16:9 で使う場合は、それようのパラメータファイルを読み込むこと。
		 */
		protected var cameraParamFile:String;
		
		/**
		 * マーカーパターンのファイル名
		 */
		protected var markerPatternFileList:Vector.<String>;

		/**
		 * カメラパラメータデータ
		 * アスペクト比や歪みなどの補正のための情報が含まれる
		 * @see org.libspark.flartoolkit.core.param.FLARParam
		 */
		protected var cameraParam:FLARParam;
		
		/**
		 * マーカーパターンのリスト
		 * マーカーを複数パターン使うので、パターン情報をVectorで管理する
		 * @see org.libspark.flartoolkit.core.FLARCode
		 */
		protected var markerPatternList:Vector.<FLARCode>;
		
		/**
		 * マーカーの一辺の長さのリスト(px)
		 */
		protected var codeWidthList:Vector.<Number>;
		
		/**
		 * マーカーリスト
		 * マーカーの情報を詰め込んでおく
		 */
		protected var markerList:Vector.<MarkerData>;
		
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
		 * @see org.libspark.flartoolkit.detector.FLARMultiMarkerDetector
		 */
		private var detector:FLARMultiMarkerDetector;
		
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
		protected var markerNodeList:Vector.<FLARBaseNode>;
		
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
		public function FLARTK_Example_Multiple_SimpleCube_PV3D()
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
			
			// カメラパラメータファイル
			// 16：9 の比率で使う場合は、camera_para_16x9.dat を使ってください
			this.cameraParamFile = '../resources/Data/camera_para.dat';
			
			// マーカーパラメータ初期化
			this.markerPatternList = new Vector.<FLARCode>();
			
			// マーカーのパターンファイル
			this.markerPatternFileList = new Vector.<String>();
			this.markerPatternFileList.push('../resources/Data/flarlogo.pat',
											'../resources/Data/hiro.pat');
			
			// マーカーの一辺の長さ(px)
			this.codeWidthList = new Vector.<Number>();
			this.codeWidthList.push( 80, 80);
			
			// パラメータのロード
			this.paramLoad();
			for (var i:int=0; i<markerPatternFileList.length; i++) {
			}
		}
		
		/**
		 * カメラパラメータを読み込み、変数にロード
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
			// 分割数(縦・横)、黒枠の幅(縦・横)
			var markerPatternCode0:FLARCode = new FLARCode(16, 16);
			
			mf.addTarget(
				this.markerPatternFileList[0], URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					markerPatternCode0.loadARPattFromFile(data);
				}
			);
			// 分割数(縦・横)、黒枠の幅(縦・横)
			var markerPatternCode1:FLARCode = new FLARCode(16, 16);
			
			mf.addTarget(
				this.markerPatternFileList[1], URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					markerPatternCode1.loadARPattFromFile(data);
				}
			);
			//ロード開始
			mf.multiLoad();
			
			this.markerPatternList.push(markerPatternCode0);
			this.markerPatternList.push(markerPatternCode1);
			
			//終了後、初期化処理に遷移するように設定
			mf.addEventListener(Event.COMPLETE, initialization);
			
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
			this.detector = new FLARMultiMarkerDetector( this.cameraParam,
														  this.markerPatternList,
														  this.codeWidthList,
														  this.markerPatternList.length);
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
			this.viewport3d = new Viewport3D(this.captureWidth,
											  this.captureHeight);
			this.addChild(this.viewport3d);
			this.viewport3d.scaleX = this.canvasWidth / this.captureWidth;
			this.viewport3d.scaleY = this.canvasHeight / this.captureHeight;
			this.viewport3d.x = -4; // 4pix ???
			
			// シーンの生成
			this.scene3d = new Scene3D();
			
			// マーカーノード、マーカーデータの初期化とシーンへの追加
			this.markerNodeList = new Vector.<FLARBaseNode>();
			this.markerList = new Vector.<MarkerData>();
			for (var i:int=0; i<this.markerPatternList.length; i++) {
				this.markerList.push(new MarkerData(i));
				this.markerList[i].confidence = 0;
				
				this.markerNodeList[i] = new FLARBaseNode();
				this.scene3d.addChild(this.markerNodeList[i]);
			}
			
			// 3Dモデル表示時の視点を設定
			this.camera3d = new FLARCamera3D(this.cameraParam);
			
			// setup renderer
			this.renderer = new LazyRenderEngine(this.scene3d, this.camera3d, this.viewport3d);
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		protected function createObject(_lightColor:Number,_ambientColor:Number):DisplayObject3D
		{
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(_lightColor, 1, 2);
			var _plane:Plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			
			// ライトの設定。手前、上のほう。
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			// Cube
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, _lightColor, _ambientColor);
			var _cube:Cube = new Cube(new MaterialsList( { all:fmat } ), 40, 40, 40);
			_cube.z = 20;
			
 			// _container に 追加
			var _container:DisplayObject3D = new DisplayObject3D();
			_container.addChild(_plane);
			_container.addChild(_cube);
			
			return _container;
		}
		
		/**
		 * 3Dオブジェクトの生成と登録
		 * マーカーイベント方式を採用しているため、markerイベントを登録
		 * スレッドのスタート
		 */
		protected function start():void
		{
			// 3Dオブジェクト生成してMarker Node に追加
			this.markerNodeList[0].addChild(this.createObject(0xFF0000, 0x660000));
			this.markerNodeList[1].addChild(this.createObject(0x0000FF, 0x000066));
			
			// 処理開始
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		/**
		 * ここでフレームごとに処理
		 * イベント方式での実装は、FLARManager で実装されているためここでは作らない。
		 */
		public function run(e:Event):void
		{
			this.capture.bitmapData.draw(this.video);
			
			// Marker detect
			var detectedNumber:int = 0;
			try {
				// Single Marker detector と違い、一度、認識した数を取得する
				detectedNumber = this.detector.detectMarkerLite(this.raster, this._threshold);
			} catch (e:Error) {}
			
			// 非認識状態に切替
			var i:int=0;
			for (i=0; i<this.markerPatternList.length; i++) {
				this.markerList[i].isPrevDetect = this.markerList[i].isDetect;
				this.markerList[i].isDetect = false;
				this.markerList[i].confidence = 0.0;
			}
			
			// 認識したマーカーを選別して処理を行う
//			trace("[Marker] Detected Number " + detectedNumber);
			for (i=0; i<detectedNumber; i++) {
				// 一致率が一定以下なら処理しない
//				trace("[Marker] Confidence("+ i +") : " + this.detector.getConfidence(i));
				if (this.detector.getConfidence(i) > 0.5) {
					// 認識したマーカーとその一致率
					var detectMarkerID:int = this.detector.getARCodeIndex(i);
					var congidence:Number = this.detector.getConfidence(i);
					//
					if (this.markerList[detectMarkerID].confidence < congidence) {
						this.markerList[detectMarkerID].confidence = congidence;
						this.detector.getTransformMatrix(i, this.markerList[detectMarkerID].resultMat);
						this.markerList[detectMarkerID].isDetect = true;
					}
				}
					
			}
			
			// 認識時の処理
			for (i=0; i<this.markerPatternList.length; i++) {
				var markerData:MarkerData = this.markerList[i];
				if (markerData.isDetect && markerData.isPrevDetect) {
//					trace("[upd] id : " + i);
					this.markerNodeList[i].setTransformMatrix(markerData.resultMat);
				} else if (markerData.isDetect) {
//					trace("[add] id : " + i +"[confidence]"+markerData.confidence);
					this.markerNodeList[i].setTransformMatrix(markerData.resultMat);
					this.markerNodeList[i].visible = true;
				// 非認識時
				} else {
//					trace("[rem] id : " + i +"[confidence]"+markerData.confidence);
					this.markerNodeList[i].visible = false;
				}
			}
			
			// マーカがなければ、探索+DualPTailで基準輝度検索
			// マーカーが見つからない場合、処理が重くなるので状況に応じてコメントアウトすると良い
			if (this.markerPatternList.length==0) {
				var th:int=this._threshold_detect.analyzeRaster(this.raster);
				this._threshold=(this._threshold+th)/2;
			}
			this.renderer.render();
		}
	}
}

import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;

/**
 * マーカー情報を詰め込んでおくクラス
 */
internal class MarkerData
{
	/**
	 * 最後に認識した時の一致率
	 */
	public var confidence:Number;
	
	/**
	 * マーカーのインデックス
	 */
	public var markerIndex:int;
	
	/**
	 * 
	 */
	public var resultMat:FLARTransMatResult;
	
	/**
	 * 認識中かどうかのフラグ
	 */
	public var isDetect:Boolean = false;
	
	/**
	 * 一つ前の段階で認識していたかどうかのフラグ
	 */
	public var isPrevDetect:Boolean = false;
	
	/**
	 * 
	 */
	public function MarkerData(_markerIndex:int)
	{
		this.markerIndex = _markerIndex;
		this.resultMat = new FLARTransMatResult();
	}
}