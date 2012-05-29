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
package org.libspark.flartoolkit.rpf.realitysource.nyartk 
{
	import org.libspark.flartoolkit.rpf.realitysource.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
	import org.libspark.flartoolkit.core.param.*;
	/**
	 * RGBラスタをラップしたRealitySourceです。
	 * @author nyatla
	 *
	 */
	public class FLARRealitySource_Reference extends FLARRealitySource
	{
		protected var _filter:IFLARRgb2GsFilter;
		/**
		 * 
		 * @param i_width
		 * ラスタのサイズを指定します。
		 * @param i_height
		 * ラスタのサイズを指定します。
		 * @param i_ref_raster_distortion
		 * 歪み矯正の為のオブジェクトを指定します。歪み矯正が必要ない時は、NULLを指定します。
		 * @param i_depth
		 * エッジ画像のサイズを1/(2^n)で指定します。(例:QVGA画像で1を指定すると、エッジ検出画像は160x120になります。)
		 * 数値が大きいほど高速になり、検出精度は低下します。実用的なのは、1<=n<=3の範囲です。標準値は2です。
		 * @param i_number_of_sample
		 * サンプリングするターゲット数を指定します。大体100以上をしておけばOKです。具体的な計算式は、{@link FLARTrackerSource_Reference#FLARTrackerSource_Reference}を参考にして下さい。
		 * @param i_raster_type
		 * ラスタタイプ
		 * @throws FLARException
		 */
		public function FLARRealitySource_Reference(i_width:int, i_height:int , i_ref_raster_distortion:FLARCameraDistortionFactor , i_depth:int , i_number_of_sample:int , i_raster_type:int )
		{
			this._rgb_source = new FLARRgbRaster(i_width, i_height, i_raster_type);
			this._filter=IFLARRgb2GsFilter(this._rgb_source.createInterface(IFLARRgb2GsFilter));
			this._source_perspective_reader=IFLARPerspectiveCopy(this._rgb_source.createInterface(IFLARPerspectiveCopy));
			this._tracksource=new FLARTrackerSource_Reference(i_number_of_sample,i_ref_raster_distortion,i_width,i_height,i_depth,true);
			return;
		}
		public override function isReady():Boolean
		{
			return this._rgb_source.hasBuffer();
		}
		public override function syncResource():void
		{
			this._filter.convert(this._tracksource.refBaseRaster());
			super.syncResource();
		}
		public override function makeTrackSource():FLARTrackerSource
		{
			this._filter.convert(this._tracksource.refBaseRaster());		
			return this._tracksource;
		}

	}

}