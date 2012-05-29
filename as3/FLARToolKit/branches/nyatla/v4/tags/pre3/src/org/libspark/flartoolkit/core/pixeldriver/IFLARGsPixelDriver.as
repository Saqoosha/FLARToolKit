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
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.types.FLARIntSize;

	public interface IFLARGsPixelDriver
	{
		/**
		 * この関数は、ピクセルドライバの参照する画像のサイズを返します。
		 * @return
		 * [readonly]
		 */
		function getSize():FLARIntSize;
		function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void;
		function getPixel(i_x:int,i_y:int):int;
		function switchRaster(i_ref_raster:IFLARRaster):void;
		function isCompatibleRaster(i_raster:IFLARRaster):Boolean;
		/**
		 * この関数は、RGBデータを指定した座標のピクセルにセットします。 実装クラスでは、バッファにRGB値を書込む処理を実装してください。
		 * 
		 * @param i_x
		 * 書込むピクセルの座標。画像の範囲内である事。
		 * @param i_y
		 * 書込むピクセルの座標。画像の範囲内である事。
		 * @param i_rgb
		 * 設定するピクセル値。
		 * @throws FLARException
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
		 * @throws FLARException
		 */
		function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intgs:Vector.<int>):void;
	}
}
