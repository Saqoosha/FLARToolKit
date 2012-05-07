/* 
 * PROJECT: NyARToolkit(Extension)
 * -------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2012 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.pixeldriver
{

	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;

	public interface INyARGsPixelDriver
	{
		/**
		 * この関数は、ピクセルドライバの参照する画像のサイズを返します。
		 * @return
		 * [readonly]
		 */
		function getSize():NyARIntSize;
		function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void;
		function getPixel(i_x:int,i_y:int):int;
		function switchRaster(i_ref_raster:INyARRaster):void;
		function isCompatibleRaster(i_raster:INyARRaster):Boolean;
		/**
		 * この関数は、RGBデータを指定した座標のピクセルにセットします。 実装クラスでは、バッファにRGB値を書込む処理を実装してください。
		 * 
		 * @param i_x
		 * 書込むピクセルの座標。画像の範囲内である事。
		 * @param i_y
		 * 書込むピクセルの座標。画像の範囲内である事。
		 * @param i_rgb
		 * 設定するピクセル値。
		 * @throws NyARException
		 */
		function setPixel(i_x:int,i_y:int,i_gs:int):void;
		/**
		 * この関数は、座標群にピクセルごとのRGBデータをセットします。 実装クラスでは、バッファにRGB値を書込む処理を実装してください。
		 * 
		 * @param i_x
		 * 書き込むピクセルの座標配列。画像の範囲内である事。
		 * @param i_y
		 * 書き込むピクセルの座標配列。画像の範囲内である事。
		 * @param i_intgs
		 * 設定するピクセル値の数
		 * @throws NyARException
		 */
		function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intgs:Vector.<int>):void;
	}
}
