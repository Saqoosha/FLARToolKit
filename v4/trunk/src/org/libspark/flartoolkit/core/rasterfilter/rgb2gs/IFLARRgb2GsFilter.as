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
	import org.libspark.flartoolkit.core.raster.rgb.*;
	
	public interface IFLARRgb2GsFilter
	{
		/**
		 * 元画像の指定範囲の矩形から、グレイスケール画像を生成して、i_rasterへコピーします。
		 * 範囲が元画像の一部の場合、その部分だけをコピーします。
		 * @param l
		 * @param t
		 * @param w
		 * @param h
		 * @param i_raster
		 * @throws FLARException
		 */
		function convertRect(l:int,t:int,w:int,h:int,i_raster:IFLARGrayscaleRaster):void;
		/**
		 * 同一サイズの画像にグレースケール画像を生成します。
		 * @param i_raster
		 * @throws FLARException
		 */
		function convert(i_raster:IFLARGrayscaleRaster):void;
	}
}