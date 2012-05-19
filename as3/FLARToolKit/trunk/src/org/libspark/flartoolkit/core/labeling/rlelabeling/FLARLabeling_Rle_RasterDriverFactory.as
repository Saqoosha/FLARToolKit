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
package org.libspark.flartoolkit.core.labeling.rlelabeling 
{
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	/**
	 * Labeling用の画像ドライバを構築します。
	 */
	public class FLARLabeling_Rle_RasterDriverFactory
	{
		/**
		 * この関数はラスタから呼ばれる。
		 * @param i_raster
		 * @return
		 */
		public static function createDriver(i_raster:IFLARGrayscaleRaster):FLARLabeling_Rle_IRasterDriver
		{
			switch(i_raster.getBufferType()){
			case FLARBufferType.INT1D_GRAY_8:
			case FLARBufferType.INT1D_BIN_8:
				return new FLARRlePixelDriver_BIN_GS8(i_raster);
			default:
				if(i_raster is IFLARGrayscaleRaster){
					return new FLARRlePixelDriver_GSReader(IFLARGrayscaleRaster(i_raster));
				}
				throw new FLARException();
			}
		}
	}

}
