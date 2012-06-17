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
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	/**
	 * このクラスは、{@link FLARBufferType#INT1D_GRAY_8}形式のラスタバッファに対応する、ピクセルリーダです。
	 */
	internal class FLARRgbPixelDriver_INT1D_GRAY_8 implements IFLARRgbPixelDriver
	{
		/** 参照する外部バッファ */
		private var _ref_buf:Vector.<int>;
		
		private var _ref_size:FLARIntSize;
		public function getSize():FLARIntSize
		{
			return this._ref_size;
		}
		/**
		 * この関数は、指定した座標の1ピクセル分のRGBデータを、配列に格納して返します。
		 */
		public function getPixel(i_x:int,i_y:int,o_rgb:Vector.<int>):void
		{
			o_rgb[0] = o_rgb[1] = o_rgb[2] = this._ref_buf[i_x + i_y * this._ref_size.w];
			return;
		}
		
		/**
		 * この関数は、座標群から、ピクセルごとのRGBデータを、配列に格納して返します。
		 */
		public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>, i_num:int, o_rgb:Vector.<int>):void
		{
			var width:int = this._ref_size.w;
			var ref_buf:Vector.<int> = this._ref_buf;
			for (var i:int = i_num - 1; i >= 0; i--) {
				o_rgb[i * 3 + 0] = o_rgb[i * 3 + 1] = o_rgb[i * 3 + 2] = ref_buf[i_x[i]+ i_y[i] * width];
			}
			return;
		}
		
		/**
		 * この関数は、機能しません。
		 */
		public function setPixel_2(i_x:int,i_y:int,i_rgb:Vector.<int>):void
		{
			FLARException.notImplement();
		}
		
		/**
		 * この関数は、機能しません。
		 */
		public function setPixel(i_x:int,i_y:int,i_r:int,i_g:int,i_b:int):void
		{
			FLARException.notImplement();
		}
		
		/**
		 * この関数は、機能しません。
		 */
		public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
		{
			FLARException.notImplement();
		}
		
		public function switchRaster(i_raster:IFLARRgbRaster):void
		{
			this._ref_buf = (Vector.<int>)(i_raster.getBuffer());
			this._ref_size = i_raster.getSize();
		}
	}
}