/**
 * FLARToolKit example
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 nyatla, rokubou
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
 *	<saq(at)saqoosha.net>
 * 
 */
package examples
{
	import examples.manager.FLSingleNyIdMarkerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.errors.*;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*
	import jp.nyatla.as3utils.NyMultiFileLoader;

	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.typography.Font3D;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.typography.fonts.HelveticaBold;

	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	
	public class FLARTK_Example_SingleNyIDManager extends FLSingleNyIdMarkerManager
	{
		private var baseSprite:Sprite;
		/**
		 * 
		 * @see org.libspark.flartoolkit.core.param.FLARParam
		 */
		private var param:FLARParam;
		
		/**
		 * 
		 * @see org.libspark.flartoolkit.core.FLARCode
		 */
		private var code:FLARCode;
		
		/**
		 * @see flash.media.Camera
		 */
		private var webcam:Camera;
		
		private var video:Video;
		
		/**
		 * ラスタイメージ
		 * @see org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData
		 */
		private var raster:FLARRgbRaster_BitmapData;
		
		/**
		 * Webカメラからの入力
		 * @see flash.display.Bitmap
		 */
		private var capture:Bitmap;
		
		/**
		 * 画面の幅と高さ
		 */
		private var canvasWidth:int;
		private var canvasHeight:int;
		
		/**
		 * 画面の幅と高さ
		 */
		private var captureWidth:int;
		private var captureHeight:int;
		
		/**
		 * マーカーの長さ(px)
		 */
		private var codeWidth:int;
		
		
		protected var _markerNode:FLARBaseNode;
		
		protected var _camera3d:FLARCamera3D;
		protected var _viewport:Viewport3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		
		private var _plane:Plane;
		private var _textdata:Text3D;
		private var _container:DisplayObject3D;
		
		/**
		 * 認識中のマーカーのID
		 */
		public var current_id:int = -1;
		
		/**
		 * マーカーIDの解析用
		 */
		private var _encoder:NyIdMarkerDataEncoder_RawBit;
		
		/**
		 * 
		 * 初期化など
		 */
		public function FLARTK_Example_SingleNyIDManager()
		{
			// Manager側の初期化
			super();
			
			// 各種サイズの初期化
			this.captureWidth = 320;
			this.captureHeight = 240;
			this.canvasWidth = 640;
			this.canvasHeight = 480;
			this.codeWidth = 100;
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
				"../resources/Data/camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
	 				param=new FLARParam();
					param.loadARParam(data);
					param.changeScreenSize(captureWidth,captureHeight);
				});
			
			//終了後initializationに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE, initialization);
			mf.multiLoad();//ロード開始
			return;
		}
		
		/**
		 * 初期化
		 * @return void
		 */
		private function initialization(e:Event): void
		{
			trace("[initialization]");
			this.removeEventListener(Event.COMPLETE, initialization);
			
			// IDマーカーのエンコーダー
			this._encoder = new NyIdMarkerDataEncoder_RawBit();

			// initialization manager
			initInstance(this.param, this._encoder, this.codeWidth);
			
			// Setup camera
			webcam = Camera.getCamera();
			if (!webcam) {
				throw new Error('No webcam!!!!');
			}
			webcam.setMode( captureWidth, captureHeight, 30);
			video = new Video( captureWidth, captureHeight);
			video.attachCamera(webcam);
			
			_camera3d = new FLARCamera3D(this.param);
			
			// setup ARToolkit
			this.raster = new FLARRgbRaster_BitmapData( captureWidth, captureHeight);
			this.capture = new Bitmap( BitmapData(this.raster.getBuffer()), PixelSnapping.AUTO, true);
			capture.width = this.canvasWidth;
			capture.height = this.canvasHeight;
			this.addChild(this.capture);
			
			_viewport = this.addChild(new Viewport3D(this.captureWidth, this.captureHeight)) as Viewport3D;
			_viewport.scaleX = this.canvasWidth / this.captureWidth;
			_viewport.scaleY = this.canvasHeight / this.captureHeight;
			_viewport.x = -4; // 理由は不明だけれど何故かずれる
			
			//
			_scene = new Scene3D();
			_markerNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			// モデル格納用のコンテナ作成
			_container = new DisplayObject3D();
			
			// Create Plane with same size of the marker with wireframe.
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2);
			_plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			
			_container.addChild(_plane);
			
			//
			// ID表示用のデータを作成する。
			var textFormat:Letter3DMaterial = new Letter3DMaterial(0xcc0000, 0.9);
			_textdata = new Text3D("aaa", new HelveticaBold(), textFormat, "textdata")
			_textdata.rotationX = 180;
			_textdata.rotationZ = 90;
			_textdata.scale = 0.5;
			
			_container.addChild(_textdata);
						
 			// attach to _markerNode to follow the marker.
 			// _markerNode に addChild するとマーカーに追従する。
 			_markerNode.addChild(_container);
			
			// Place the light at upper front.
			// ライトの設定。手前、上のほう。
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			_renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);
			
			this.start();
		}
		
		/**
		 * マーカーの認識と3次元モデルの描写を開始する
		 */
		public function start():void
		{
			trace("[start]");
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		
		public function run(e:Event):void
		{
			this.capture.bitmapData.draw(this.video);
			this.detectMarker(this.raster);
		}
		
		
		protected override function onEnterHandler(i_code:INyIdMarkerData):void
		{
			var code:NyIdMarkerData_RawBit = i_code as NyIdMarkerData_RawBit;
			
			//read data from i_code via Marsial--Marshal経由で読み出す
			var i:int;
			if(code.length>4){
				//4バイト以上の時はint変換しない。
				this.current_id=-1;//undefined_id
			}else{
				this.current_id=0;
				//最大4バイト繋げて１個のint値に変換
				for(i=0;i<code.length;i++){
					this.current_id=(this.current_id<<8)|code.packet[i];
				}
			}
			trace("[add] : ID = " + this.current_id);
			
			//　IDを表示する。
			_textdata.text = String(this.current_id);
	
			this._markerNode.visible = true;
		}
		
		
		protected override function onLeaveHandler():void
		{
			// hide the square.
			this._markerNode.visible = false;
			this.current_id = -1;
			_renderer.render();
			trace("[remove]");
		}
		
		protected override function onUpdateHandler(i_square:FLARSquare,result:FLARTransMatResult):void
		{
			_markerNode.setTransformMatrix(result);
			_renderer.render();
			trace("[update] : ID = " + this.current_id);
		}
	}
}