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
	import flash.geom.Point;
	import flash.geom.Transform;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.FLARParam;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARTransMatResult;
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
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
	public class FLARAnotherWorldWindowLayer extends FLARSingleMarkerLayer
	{
		private var _matrix:Matrix3D;
		private var _view:BasicView;

		public function FLARAnotherWorldWindowLayer(src:FLARBitmapData,
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
			var panoSphere:Sphere = new Sphere(panoramaMaterial, 25000, 30, 30);
			//３．シーンに追加
			this._view.scene.addChild(panoSphere,"panorama");
			
			//４．レンダリング開始
			this._view.startRendering();
		}
		
		override public function update():void 
		{

			if (this._detector.detectMarkerLite(this._source, this._thresh) &&
				this._detector.getConfidence() >= 0.65) {
				
				//マーカの中心点の位置を検出し、傾きとする
				var square:FLARSquare = this._detector.getSquare();

				var Mx:int = Math.max(square.sqvertex[0][0], square.sqvertex[1][0], square.sqvertex[2][0], square.sqvertex[3][0]);
				var mx:int = Math.min(square.sqvertex[0][0], square.sqvertex[1][0], square.sqvertex[2][0], square.sqvertex[3][0]);
				var My:int = Math.max(square.sqvertex[0][1], square.sqvertex[1][1], square.sqvertex[2][1], square.sqvertex[3][1]);
				var my:int = Math.min(square.sqvertex[0][1], square.sqvertex[1][1], square.sqvertex[2][1], square.sqvertex[3][1]);
				var center:Point = new Point((Mx + mx)/2, (My+my)/2);

				this._view.camera.rotationY = (center.x - this._source.getWidth()/2) * 0.6;
				this._view.camera.rotationX = -(center.y - this._source.getHeight()/2) * 0.6;
				trace(this._view.camera.rotationY, this._view.camera.rotationX);
				//マーカの大きさから、ズームを判定する
				//900-45000
				this._view.camera.zoom = 1 + square.area / 9000;
			} else {
				
			}

			//this._view.camera.rotationY += (480 * mouseX/(this._view.width) - this._view.camera.rotationY) * .1;
			//this._view.camera.rotationX += (180 * mouseY/(this._view.height) - 90 - this._view.camera.rotationX) * .1;

		}
		private function setTranslationMatrix(mtx:Matrix3D):void {
			var a:Array = this._resultMat.getArray();
			mtx.n11 =  a[0][1];	mtx.n12 =  a[0][0];	mtx.n13 =  a[0][2];	mtx.n14 =  a[0][3];
			mtx.n21 = -a[1][1];	mtx.n22 = -a[1][0];	mtx.n23 = -a[1][2];	mtx.n24 = -a[1][3];
			mtx.n31 =  a[2][1];	mtx.n32 =  a[2][0];	mtx.n33 =  a[2][2];	mtx.n34 =  a[2][3];
		}

	}
	
}