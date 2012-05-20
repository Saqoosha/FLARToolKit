/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
package org.libspark.flartoolkit.markersystem
{


	import flash.display.*;
	import flash.geom.Matrix;
	
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.markersystem.FLARSensor;



	/**
	 * このクラスは、Flash向けにﾁｭｰﾆﾝｸﾞしたFLARSensorクラスです。
	 * {@link Video}、{@link BitmapData}等の{@link IBitmapDrawable}インタフェイスを持つ
	 * オブジェクトをセットできます。
	 * オブジェクトのセットには、{@link #update_2}を使います。
	 */
	public class FLARSensor extends FLARSensor_BaseClass_
	{
		/**
		 * 画像サイズ（スクリーンサイズ）を指定して、インスタンスを生成します。
		 * @param i_size
		 * 画像のサイズ。
		 * @throws FLARException
		 */
		public function FLARSensor(i_size:FLARIntSize)
		{
			super(i_size);
			this._raster = new FLARRgbRaster(i_size.w, i_size.h);
			this.update(this._raster);
		}
		/**
		 * この関数は、画像ドライバに依存するインスタンスを生成する。
		 * 継承クラスで上書きする。
		 * @param s
		 * @throws FLARException
		 */
		protected override function initResource(s:FLARIntSize):void
		{
			//グレースケール変換
			this._gs_raster = new FLARGrayscaleRaster(s.w, s.h,FLARBufferType.OBJECT_AS3_BitmapData);
			this._bin_raster = new FLARBinRaster(s.w, s.h);
			this._gstobin = FLARGs2BinFilter(this._gs_raster.createInterface(FLARGs2BinFilter));
		}
		private var _gstobin:FLARGs2BinFilter;
		private var _bin_raster:FLARBinRaster
		private var _bin_id_ts:int;
		private var _bin_th:int = -1;
		private var _raster:FLARRgbRaster;
		/**
		 * i_thで2値化した画像の参照値を得ます。この関数は{@link FLARMarkerSystem}用の関数です。
		 * @return
		 * [readonly]
		 */
		public function getBinImage(i_th:int):FLARBinRaster
		{
			if((this._gs_id_ts!=this._bin_id_ts)||(this._bin_th!=i_th)){
				this._gstobin.convert(i_th,this._bin_raster);
				this._bin_id_ts = this._gs_id_ts;
				this._bin_th = i_th;
			}
			return this._bin_raster;
		}
		
		public function update_2(i_bmp:IBitmapDrawable):void
		{
			this._raster.getBitmapData().draw(i_bmp);
			this.updateTimeStamp();
		}
		
		/**
		 * scaleRatio で設定したサイズに拡縮して raster化する
		 */
		public function update_3(i_bmp:IBitmapDrawable, scaleRatio:Matrix):void
		{
			this._raster.getBitmapData().draw(i_bmp, scaleRatio);
			this.updateTimeStamp();
		}
	}
}
