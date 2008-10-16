/*
 *  Copyright 2008 tarotarorg(http://tarotaro.org)
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */ 
package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Transform;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	import org.tarotaro.flash.ar.layers.FLARSingleMarkerLayer;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class FLARPanoramaSphereLayer extends FLARSingleMarkerLayer
	{
		private var _matrix:Matrix3D;
		private var _view:BasicView;
		private var _panorama:Sphere;

		public function FLARPanoramaSphereLayer(src:IFLARRgbRaster,
													param:FLARParam,
													code:FLARCode,
													markerWidth:Number,
													panorama:BitmapData,
													windowWidth:Number = 640,
													windowHeight:Number = 480,
													thresh:int = 100)  
		{
			super(src, param, code, markerWidth, thresh);
			
			//Viewの作成
			this._view = new BasicView(windowWidth, windowHeight, true, false, CameraType.FREE);
			this.addChild(this._view);

			//カメラのセッティング
			this._view.camera.focus = 300;
			this._view.camera.zoom = 1;

			//パノラマ球体の構築
			//１．パノラマ用のマテリアルを作成
			var panoramaMaterial:BitmapMaterial = new BitmapMaterial(panorama, false);
			panoramaMaterial.opposite = true;
			panoramaMaterial.smooth = true;
			//２．球体を作成
			this._panorama = new Sphere(panoramaMaterial, 25000, 30, 30);
			//３．シーンに追加
			this._view.scene.addChild(this._panorama,"panorama");
			
			//カメラ画像とパラメータのサイズが合わないので、サイズチェックを飛ばす
			this._detector.sizeCheckEnabled = false;

			//４．レンダリング開始
			this._view.startRendering();
		}
		
		override public function update():void 
		{
			if (!this._source is IFLARRgbRaster) throw new IllegalOperationError("ソース画像の型が予期しないクラスです。");
			if (this._detector.detectMarkerLite(this._source as IFLARRgbRaster, this._thresh) &&
				this._detector.getConfidence() >= 0.65) {
				
				//マーカの中心点の位置を検出し、傾きとする
				var square:FLARSquare = this._detector.getSquare();

				var Mx:int = Math.max(square.sqvertex[0].x, square.sqvertex[1].x, square.sqvertex[2].x, square.sqvertex[3].x);
				var mx:int = Math.min(square.sqvertex[0].x, square.sqvertex[1].x, square.sqvertex[2].x, square.sqvertex[3].x);
				var My:int = Math.max(square.sqvertex[0].y, square.sqvertex[1].y, square.sqvertex[2].y, square.sqvertex[3].y);
				var my:int = Math.min(square.sqvertex[0].y, square.sqvertex[1].y, square.sqvertex[2].y, square.sqvertex[3].y);
				var center:Point = new Point((Mx + mx)/2, (My+my)/2);

				this._view.camera.rotationY = (center.x - this._source.getWidth()/2) * 0.6;
				this._view.camera.rotationX = -(center.y - this._source.getHeight()/2) * 0.6;
				trace(this._view.camera.rotationY, this._view.camera.rotationX);
				//マーカの大きさから、ズームを判定する
				//900-45000
				this._view.camera.zoom = 1 + square.label.area / 9000;
			} else {
			}
		}
	}
	
}