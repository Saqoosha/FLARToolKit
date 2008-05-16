/* 
 * PROJECT: NyARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkit is Java version ARToolkit class library.
 * Copyright (C)2008 R.Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package com.libspark.flartoolkit.core.raster {
	
	public interface IFLARRaster{
	    //RGBの合計値を返す
	    function getPixelTotal(i_x:int, i_y:int):int;
	    /**
	     * 一行単位でi_row番目の合計値配列を計算して返す。
	     * @param i_row
	     * @param o_line
	     * getWidth()の戻り値以上のサイズが必要。
	     */
	    function getPixelTotalRowLine(i_row:int, o_line:Array):void;
	    function getWidth():int;
	    function getHeight():int;
	    function getPixel(i_x:int, i_y:int, i_rgb:Array):void;
	    /**
	     * 複数のピクセル値をi_rgbへ返します。
	     * @param i_x
	     * xのインデックス配列
	     * @param i_y
	     * yのインデックス配列
	     * @param i_num
	     * 返すピクセル値の数
	     * @param i_rgb
	     * ピクセル値を返すバッファ
	     */
	    function getPixelSet(i_x:Array, i_y:Array, i_num:int, o_rgb:Array):void;
	}

}
