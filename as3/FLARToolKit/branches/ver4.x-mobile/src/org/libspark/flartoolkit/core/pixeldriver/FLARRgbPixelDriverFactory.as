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
package org.libspark.flartoolkit.core.pixeldriver
{

	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.*;

	/**
	 * この関数は、FLARRgbRasterからコールします。
	 */
	public class FLARRgbPixelDriverFactory
	{
		/**
		 * この関数は、i_rasterを操作するピクセルドライバインスタンスを生成します。
		 * @param i_raster
		 * @return
		 * @throws FLARException
		 */
		public static function createDriver(i_raster:IFLARRgbRaster):IFLARRgbPixelDriver
		{
			var ret:IFLARRgbPixelDriver;
			switch(i_raster.getBufferType()){
			case FLARBufferType.INT1D_GRAY_8:
				ret=new FLARRgbPixelDriver_INT1D_GRAY_8();
				break;
			case FLARBufferType.INT1D_X8R8G8B8_32:
				ret= new FLARRgbPixelDriver_INT1D_X8R8G8B8_32();
				break;
			default:
				throw new FLARException();		
			}
			ret.switchRaster(i_raster);
			return ret;
		}
	}
}

