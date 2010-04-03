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
	import org.papervision3d.objects.primitives.Cube;
	import examples.manager.FLSingleARMarkerManager;
	import org.papervision3d.materials.utils.MaterialsList;
	
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
	
	import jp.nyatla.as3utils.NyMultiFileLoader;

	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.objects.DisplayObject3D;

	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	
	public class FLARTK_Example_SingleManager_PV3D extends FLSingleARMarkerManager
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

		/**
		 * マーカーの情報
		 */
		protected var codes:Vector.<FLARCode>;
		
		/**
		 * マーカーの長さ(px)
		 * codes:FLARCode に対応したマーカーの長さを管理している
		 * 
		 */
		protected var codes_width:Vector.<Number>;

		protected var _markerNode:FLARBaseNode;
		
		protected var _camera3d:FLARCamera3D;
		protected var _viewport:Viewport3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;

		private var _plane:Plane;
		private var _container:DisplayObject3D;

		/**
		 * 
		 * 初期化など
		 */
		public function FLARTK_Example_SingleManager_PV3D()
		{
			// Manager側の初期化
			super();
			
			// 各種サイズの初期化
			captureWidth = 320;
			captureHeight = 240;
			canvasWidth = 640
			canvasHeight = 480;
			codeWidth = 80;
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
			mf.addTarget(
				"../resources/Data/flarlogo.pat",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=new FLARCode(16, 16);
					code.loadARPattFromFile(data);
				}
			);
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
			// initialization manager
			initInstance(this.param);
			
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
			this.capture = new Bitmap(new BitmapData(this.captureWidth, this.captureHeight, false, 0), PixelSnapping.AUTO, true);
			capture.width = this.canvasWidth;
			capture.height = this.canvasHeight;
			this.addChild(this.capture);
			
			this.raster = new FLARRgbRaster_BitmapData(this.capture.bitmapData);
			
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
 			// attach to _markerNode to follow the marker.
 			// _markerNode に addChild するとマーカーに追従する。
			_container.addChild(_plane);
			
			// Cube
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xFF0000, 0x660000);
			var cube:Cube = new Cube(new MaterialsList( { all:fmat } ), 40, 40, 40);
			cube.z = 20;
			_container.addChild(cube);
			
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
			this.codes = new Vector.<FLARCode>();
			this.codes[0] = this.code;
			
			this.setARCodeTable(this.codes, 16, this.codeWidth);
			
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		
		public function run(e:Event):void
		{
			this.capture.bitmapData.draw(this.video);
			this.detectMarker(this.raster);
		}
		
		
		protected override function onEnterHandler(i_code:int):void
		{
			trace("[add]");
			this._markerNode.visible = true;
		}
		
		
		protected override function onLeaveHandler():void
		{
			// hide the square.
			this._markerNode.visible = false;
			_renderer.render();
			trace("[remove]");
		}
		
		protected override function onUpdateHandler(i_square:FLARSquare,result:FLARTransMatResult):void
		{
			_markerNode.setTransformMatrix(result);
			_renderer.render();
			trace("[update]");
		}
	}
}