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
package org.libspark.flartoolkit.core.rasterfilter.rgb2gs 
{
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;

	public class FLARRgb2GsFilterFactory
	{
		/**
		 * この関数は、(R*G*B)/3 でグレースケール化するフィルタを生成します。
		 * 最適化されている形式は以下の通りです。
		 * <ul>
		 * <li>{@link FLARBufferType#BYTE1D_B8G8R8X8_32}</li>
		 * </ul>
		 * @param i_raster
		 * @return
		 * @throws FLARException
		 */
		public static function createRgbAveDriver(i_raster:IFLARRgbRaster):IFLARRgb2GsFilterRgbAve
		{
			switch(i_raster.getBufferType()){
			case FLARBufferType.INT1D_X8R8G8B8_32:
				return new FLARRgb2GsFilterRgbAve_INT1D_X8R8G8B8_32(i_raster);
			default:
				return new FLARRgb2GsFilterRgbAve_Any(i_raster);
			}
		}
		/**
		 * この関数は、(R*G*B>>16) でグレースケール化するフィルタを生成します。
		 * 最適化されていません。
		 * @param i_raster
		 * @return
		 * @throws FLARException
		 */
//		public static function createRgbCubeDriver(i_raster:IFLARRgbRaster):IFLARRgb2GsFilterRgbAve
//		{
//			switch(i_raster.getBufferType()){
//			default:
//				return new FLARRgb2GsFilterRgbCube_Any(i_raster);
//			}
//		}
		/**
		 * この関数は(Yrcb)でグレースケール化するフィルタを生成します。
		 * 最適化されていません。
		 * @param i_raster
		 * @return
		 * @throws FLARException
		 */
//		public static function createYCbCrDriver(i_raster:IFLARRgbRaster):IFLARRgb2GsFilterYCbCr
//		{
//			switch(i_raster.getBufferType()){
//			default:
//				return new FLARRgb2GsFilterYCbCr_Any(i_raster);
//			}
//		}
	}
}

