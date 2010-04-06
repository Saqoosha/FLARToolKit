/**
 * FLARToolKit example launcher
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 saqoosha
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
 * Contributors
 *  saqoosha
 *  rokubou
 */
package examples {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class PV3DARApp extends ARAppBase {
		/**
		 * @see flash.display.Sprite
		 */
		protected var _base:Sprite;
		
		/**
		 * @see org.papervision3d.view.Viewport3D
		 */
		protected var _viewport:Viewport3D;
		
		/**
		 * @see org.libspark.flartoolkit.support.pv3d.FLARCamera3D
		 */
		protected var _camera3d:FLARCamera3D;
		
		/**
		 * @see org.papervision3d.scenes.Scene3D
		 */
		protected var _scene:Scene3D;
		
		/**
		 * @see org.papervision3d.render.LazyRenderEngine
		 */
		protected var _renderer:LazyRenderEngine;
		
		/**
		 * @see org.libspark.flartoolkit.support.pv3d.FLARBaseNode
		 */
		protected var _markerNode:FLARBaseNode;
		
		/**
		 * @see org.libspark.flartoolkit.core.transmat.FLARTransMatResult
		 */
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
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
		 * 二値化画像を重ねて表示する場合のフラグ
		 * isRasterViewMode() を呼び出して切り替えてください
		 */
		protected var _is_raster_view:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function PV3DARApp() {
		}
		
		public function isRasterViewMode(onView:Boolean = true):void
		{
			this._is_raster_view = onView;
		}
		
		protected override function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void {
			addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);
			super.init(cameraFile, codeFile, canvasWidth, canvasHeight, codeWidth);
		}
		
		private function _onInit(e:Event):void {
			_base = addChild(new Sprite()) as Sprite;
			
			_capture.width = 640;
			_capture.height = 480;
			_base.addChild(_capture);
			
			_viewport = _base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			_viewport.scaleX = 640 / 320;
			_viewport.scaleY = 480 / 240;
			_viewport.x = -4; // 4pix ???
			
			_camera3d = new FLARCamera3D(_param);
			
			_scene = new Scene3D();
			_markerNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			_renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);
			
			this._threshold_detect=new FLARRasterThresholdAnalyzer_SlidePTile(15,4);
			
			// 二値化画像を見るための部分
			if (this._is_raster_view) {
				var binRasterBitmap:Bitmap = new Bitmap(this._detector.thresholdedBitmapData);
				_base.addChild(binRasterBitmap);
			}
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event = null):void {
			_capture.bitmapData.draw(_video);
			
			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, _threshold) && _detector.getConfidence() > 0.5;
			} catch (e:Error) {}
			
			if (detected) {
				_detector.getTransformMatrix(_resultMat);
				_markerNode.setTransformMatrix(_resultMat);
				_markerNode.visible = true;
			} else {
				_markerNode.visible = false;
				// マーカがなければ、探索+DualPTailで基準輝度検索
				// マーカーが見つからない場合、処理が重くなるので状況に応じてコメントアウトすると良い
				var th:int=this._threshold_detect.analyzeRaster(_raster);
				this._threshold=(this._threshold+th)/2;
				// trace("[threshold] : " + this._threshold);
			}
			_renderer.render();
		}
		
		public function set mirror(value:Boolean):void {
			if (value) {
				_base.scaleX = -1;
				_base.x = 640;
			} else {
				_base.scaleX = 1;
				_base.x = 0;
			}
		}
		
		public function get mirror():Boolean {
			return _base.scaleX < 0;
		}
	}
}