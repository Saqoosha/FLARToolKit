/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package org.libspark.flartoolkit.markersystem
{


	import flash.display.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.NyARSensor;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;



	/**
	 * このクラスは、Flash向けにﾁｭｰﾆﾝｸﾞしたNyARSensorクラスです。
	 * {@link Video}、{@link BitmapData}等の{@link IBitmapDrawable}インタフェイスを持つ
	 * オブジェクトをセットできます。
	 * オブジェクトのセットには、{@link #update_2}を使います。
	 */
	public class FLARSensor extends NyARSensor
	{
		/**
		 * 画像サイズ（スクリーンサイズ）を指定して、インスタンスを生成します。
		 * @param i_size
		 * 画像のサイズ。
		 * @throws NyARException
		 */
		public function FLARSensor(i_size:NyARIntSize)
		{
			super(i_size);
			this._raster = new FLARRgbRaster(i_size.w, i_size.h);
			this.update(this._raster);
		}
		/**
		 * この関数は、画像ドライバに依存するインスタンスを生成する。
		 * 継承クラスで上書きする。
		 * @param s
		 * @throws NyARException
		 */
		protected override function initResource(s:NyARIntSize):void
		{
			//グレースケール変換
			this._gs_raster = new FLARGrayscaleRaster(s.w, s.h);
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
	}
}
