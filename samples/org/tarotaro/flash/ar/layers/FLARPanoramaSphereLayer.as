/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 *
 */
package org.tarotaro.flash.ar.layers
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