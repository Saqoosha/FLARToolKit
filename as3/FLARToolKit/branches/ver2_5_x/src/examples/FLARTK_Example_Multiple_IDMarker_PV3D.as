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
 *  rokubou at The Sixwish project
 * 
 * comment
 *  今回のサンプルは Model 2 に限定している。
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
	import org.libspark.flartoolkit.detector.idmarker.FLARMultiIdMarkerDetector;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.typography.fonts.HelveticaBold;
	import org.papervision3d.view.Viewport3D;
	public class FLARTK_Example_Multiple_IDMarker_PV3D extends Sprite 
	{
		/**
		 * ID Model number
		 */
		protected var idModelNumber:int = 2;
		
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
		private var detector:FLARMultiIdMarkerDetector;
		
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
		 * 3D Renderer
		 * @see org.papervision3d.render.LazyRenderEngine
		 */
		protected var renderer:LazyRenderEngine;
		
		/**
		 * Constructor
		 * ここから初期化処理を呼び出して処理をスタート
		 */
		public function FLARTK_Example_Multiple_IDMarker_PV3D():void 
		{
			this.init();
		}
		
		private function init():void 
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
			this.detector = new FLARMultiIdMarkerDetector( this.cameraParam,	this.codeWidth);
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
			this.viewport3d = new Viewport3D(this.captureWidth,this.captureHeight);
			this.addChild(this.viewport3d);
			this.viewport3d.scaleX = this.canvasWidth / this.captureWidth;
			this.viewport3d.scaleY = this.canvasHeight / this.captureHeight;
			this.viewport3d.x = -4; // 4pix ???
			
			// シーンの生成
			this.scene3d = new Scene3D();
			
			// 3Dモデル表示時の視点を設定
			this.camera3d = new FLARCamera3D(this.cameraParam);
			
			// setup renderer
			this.renderer = new LazyRenderEngine(this.scene3d, this.camera3d, this.viewport3d);
		}
		
		/**
		 * 3Dオブジェクト生成
		 */
		private var _textFormat:Letter3DMaterial;
		private var _textdata:Text3D;
		
		protected function createObject(_nyId:int):DisplayObject3D
		{
			var _container:DisplayObject3D = new DisplayObject3D();
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff, 1, 2);
			var _plane:Plane = new Plane(wmat, this.codeWidth, this.codeWidth); // 80mm x 80mm。
			_plane.rotationX = 180;
			
			// ID表示用のデータを作成する。
			_textFormat = new Letter3DMaterial(0xcc0000, 0.9);
			_textdata = new Text3D( "Id:"+_nyId, new HelveticaBold(), _textFormat, "textdata");
			_textdata.rotationX = 180;
			_textdata.rotationZ = 90;
			_textdata.scale = 0.5;
			
			// _container に 追加
			_container.addChild(_plane);
			_container.addChild(_textdata);
			
			return _container;
		}
		
		protected var markerList:Vector.<MarkerData>;
		protected var markerListIndex:Vector.<int>;
		/**
		 * 3Dオブジェクトの生成と登録
		 * マーカーイベント方式を採用しているため、markerイベントを登録
		 * スレッドのスタート
		 */
		protected function start():void
		{
			// 識別したマーカーの情報を管理するVectorを作成
			this.markerList = new Vector.<MarkerData>();
			this.markerListIndex = new Vector.<int>();
			// 処理開始
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		/**
		 * ここで処理振り分けを行っている
		 * 
		 * 今回も表示切替方式で実装しているため、新たに認識するたびに FLARBaseNode を追加
		 * 認識に失敗しても削除せず、visibleを切り替えるだけ
		 * 数多くの種類のマーカーを認識させると、メモリを大量に消費する仕様です。
		 * キャッシュにライフタイムを設定して、定期的にリストを縮小する方式を実装してください。
		 */
		public function run(e:Event):void
		{
			this.capture.bitmapData.draw(this.video);
			
			// Marker detect
			var detectedNumber:int = 0;
			try {
				// 検出できたマーカー数を取得
				detectedNumber = this.detector.detectMarkerLite(this.raster, this._threshold);
			} catch (e:Error) {}
			
			// 今回認識したマーカーの情報を確保するVector
			var _markerList:Vector.<MarkerData> = new Vector.<MarkerData>();
			
			// 認識したマーカーを選別して処理を行う
			// trace("[Marker] Detected Number : " + detectedNumber);
			var i:int=0;
			for (i=0; i<detectedNumber; i++) {
//				trace("[Marker] Model : " + this.detector.getIdMarkerData(i).model + " id:" + this.detector.getARCodeIndex(i));
				// 認識したマーカーの情報を確保
				if (this.idModelNumber!=this.detector.getIdMarkerData(i).model) {
					continue;
				}
				var _markerData:MarkerData = new MarkerData(this.detector.getIdMarkerData(i).model, this.detector.getARCodeIndex(i));
				this.detector.getTransformMatrix(i, _markerData.resultMat);
				_markerData.isDetect = true;
				_markerList.push(_markerData);
			}
			
			// trace("[MarkerList] Now length : " + _markerList.length + " / Cache :" + this.markerList.length);
			
			// 既存リストの  visible をすべて  false にする
			for (i=0; i<this.markerList.length; i++) {
				this.markerList[i].flarNode.visible = false;
			}
			// 認識中のリストを更新
			if (_markerList.length!=0) {
				// 既存のリストと比較
				var _hitIndex:int = -1;
				for (i=0; i<_markerList.length; i++) {
					_hitIndex = this.markerListIndex.indexOf(_markerList[i].markerId);
					if (_hitIndex !=-1) {
						// リストにある場合は、 Transmat を更新、 visible を true にする
						this.markerList[_hitIndex].setTransMat(_markerList[i].resultMat);
						this.markerList[_hitIndex].flarNode.visible = true;
					} else {
						// リストにない場合は、FLARBaseNode を new、リストに追加
						_markerList[i].flarNode = new FLARBaseNode();
						_markerList[i].flarNode.addChild(this.createObject(_markerList[i].markerId));
						
						_markerList[i].flarNode.visible = true;
						this.markerList.push(_markerList[i].clone());
						var lastIndex:int = this.markerList.length-1;
						this.markerListIndex.push(_markerList[i].markerId);
						
						// this.scene3d に Node 追加
						this.scene3d.addChild(this.markerList[lastIndex].flarNode);
					}
				}
			}
			// マーカがなければ、探索+DualPTailで基準輝度検索
			// マーカーが見つからない場合、処理が重くなるので状況に応じてコメントアウトすると良い
			if (_markerList.length==0) {
				var th:int=this._threshold_detect.analyzeRaster(this.raster);
				this._threshold=(this._threshold+th)/2;
			}
			this.renderer.render();
		}
	}
}

import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;

/**
 * マーカー情報を詰め込んでおくクラス
 */
internal class MarkerData
{
	/**
	 * Model
	 */
	public var IdModel:int;
	
	/**
	 * マーカーのID
	 */
	public var markerId:int;
	
	/**
	 * 
	 */
	public var resultMat:FLARTransMatResult;
	
	/**
	 * 
	 */
	public var flarNode:FLARBaseNode;
	
	/**
	 * 認識中かどうかのフラグ
	 */
	public var isDetect:Boolean = false;
	
	/**
	 * 
	 */
	public function MarkerData(_model:int, _markerId:int)
	{
		this.IdModel = _model;
		this.markerId = _markerId;
		this.resultMat = new FLARTransMatResult();
	}
	
	public function setTransMat(_transMat:FLARTransMatResult):void
	{
		this.resultMat = _transMat;
		this.flarNode.setTransformMatrix(_transMat);
	}
	
	public function clone():MarkerData
	{
		var newObject:MarkerData = new MarkerData(this.IdModel, this.markerId);
		newObject.resultMat = this.resultMat;
		newObject.flarNode = this.flarNode;
		newObject.isDetect = this.isDetect;
		
		return newObject;
	}
}
