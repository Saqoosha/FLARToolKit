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
package org.libspark.flartoolkit.core.raster 
{
	import flash.display.BitmapData;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	public class FLARGsPixelDriver_AsBitmap implements INyARGsPixelDriver
	{
		protected var _ref_buf:BitmapData;
		private var _ref_size:NyARIntSize;
		public function getSize():NyARIntSize
		{
			return this._ref_size;
		}
		public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void
		{
			for (var i:int = i_n - 1; i >= 0; i--) {
				o_buf[i_st_buf+i] = _ref_buf.getPixel(i_x[i],i_y[i]);
			}
			return;	
		}
		public function getPixel(i_x:int,i_y:int):int
		{
			return _ref_buf.getPixel(i_x,i_y)& 0x000000ff;;
		}
		public function setPixel(i_x:int,i_y:int,i_gs:int):void
		{
			this._ref_buf.setPixel(i_x, i_y, i_gs);
		}
		public function setPixels(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,i_intgs:Vector.<int>):void
		{
			for (var i:int = i_num - 1; i >= 0; i--){
				this._ref_buf.setPixel(i_x[i], i_y[i], i_intgs[i]);
			}
		}	
		public function switchRaster(i_ref_raster:INyARRaster):void
		{
			this._ref_buf=BitmapData(i_ref_raster.getBuffer());
			this._ref_size=i_ref_raster.getSize();
		}
		public function isCompatibleRaster(i_raster:INyARRaster):Boolean
		{
			return i_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData);
		}	
	}	
	
	

}