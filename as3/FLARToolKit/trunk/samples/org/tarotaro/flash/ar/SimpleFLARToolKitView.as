package org.tarotaro.flash.ar {
	
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.scene.FLARCamera3D;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.math.Matrix3D;
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
	

	/**
	 * FLARToolKitのサンプルを、汎用的に使えるよう改造したクラス。
	 * @example <listing version="3.0" >
	 * //画面への表示方法
	 * var ar:SimpleFLARToolKitView = new SimpleFLARToolKitView();
	 * ar.addEventListener(Event.COMPLETE,function(e:Event):void 
	 * {
	 *     addChild(ar);
	 *     ar.start();
	 * });
	 * ar.setupAR();
	 * 
	 * //モデル変更方法
	 * var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2);
	 * wmat.doubleSided = true;
	 * var basePlane:Plane = new Plane(wmat, 80, 80);
	 * 
	 * ar.model = basePlane;
	 * </listing>
	 */
	public class SimpleFLARToolKitView extends ARAppBase {
		
		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		private var _base:Sprite;
		private var _scene:Scene3D;
		private var _camera3d:FLARCamera3D;
		private var _viewport:Viewport3D;
		private var _renderer:LazyRenderEngine;
		
		private var _transGrp:DisplayObject3D;
		
		private var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		private var _isMirror:Boolean = false;
		
		/**
		 * 拡張現実用のカメラ映像表示領域を作成する。
		 */
		public function SimpleFLARToolKitView() {
			this.addEventListener(Event.INIT, this._onInit);
		}
		
		/**
		 * カメラ・パターンファイルを読み込み、ARコンテンツの設定を行う。
		 * 設定完了後、Event.COMPLETEを送出する。
		 * @param	cameraFile		カメラ設定ファイル
		 * @param	codeFile		パターンファイル
		 * @param	canvasWidth		表示領域の幅
		 * @param	canvasHeight	表示領域の高さ
		 * @param	codeWidth		パターンの幅
		 */
		public function setupAR(cameraFile:String = CAMERA_FILE, 
								codeFile:String = PATTERN_FILE, 
								canvasWidth:int = 320, 
								canvasHeight:int = 240, 
								codeWidth:int = 80):void 
		{
			this.init(cameraFile, codeFile, canvasWidth, canvasHeight, codeWidth);
		}
		
		/**
		 * マーカーの認識と3次元モデルの描写を開始する
		 */
		public function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		/**
		 * マーカーの認識と3次元モデルの描写を終了する
		 */
		public function stop():void 
		{
			this.removeEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		/**
		 * @private
		 * カメラ・パターンファイル読み込み完了後の初期化処理
		 * @param	e
		 */
		private function _onInit(e:Event):void {
			this.removeEventListener(Event.INIT, this._onInit);
			
			this._base = this.addChild(new Sprite()) as Sprite;

			this._base.addChild(this._capture);
			
			this._viewport = this._base.addChild(new Viewport3D(this._capture.width, this._capture.height, false, false, false, false)) as Viewport3D;
			this._viewport.x = -4; // 4pix ???
			
			this._camera3d = new FLARCamera3D(this._param);
			
			this._scene = new Scene3D();
			this._transGrp = this._scene.addChild(new DisplayObject3D()) as DisplayObject3D;
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @private
		 * フレームごとの処理。マーカーを認識し、3次元モデルを描画する。
		 * @param	e
		 */
		private function _onEnterFrame(e:Event = null):void {
			this._capture.bitmapData.draw(this._video);
			if (this._detector.detectMarkerLite(this._raster, 80)) {
				if (this._detector.getConfidence() < .5) {
					trace("confidence:", this._detector.getConfidence());
					this._viewport.visible = false;
					return;
				}
				this._detector.getTranslationMatrix(this._resultMat);
				var a:Array = this._resultMat.getArray();
				var mtx:Matrix3D = this._transGrp.transform;
				mtx.n11 =  a[0][1];	mtx.n12 =  a[0][0];	mtx.n13 =  a[0][2];	mtx.n14 =  a[0][3];
				mtx.n21 = -a[1][1];	mtx.n22 = -a[1][0];	mtx.n23 = -a[1][2];	mtx.n24 = -a[1][3];
				mtx.n31 =  a[2][1];	mtx.n32 =  a[2][0];	mtx.n33 =  a[2][2];	mtx.n34 =  a[2][3];
				this._viewport.visible = true;
				this._renderer.render();
			} else {
				this._viewport.visible = false;
			}
		}
		
		/**
		 * 表示する3次元モデルを切り替える
		 */
		public function set model(model:DisplayObject3D):void 
		{
			try {
				this._transGrp.removeChildByName("model");
			} catch (e:Error) {
				trace("remove失敗");
			}
			if (model) {
				this._transGrp.addChild(model, "model");
			}
		}
	}
	
}