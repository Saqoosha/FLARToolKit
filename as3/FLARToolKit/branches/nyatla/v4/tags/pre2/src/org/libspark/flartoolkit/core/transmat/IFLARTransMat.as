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
package org.libspark.flartoolkit.core.transmat
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	/**
	 * This class calculates ARMatrix from square information. -- 変換行列を計算するクラス。
	 * 
	 */
	public interface IFLARTransMat
	{
		/**
		 * 理想座標系の四角系から、i_offsetのパラメタで示される矩形を(0,0,0)の点から移動するための行列式を計算し、o_resultへ格納します。
		 * @param i_square
		 * @param i_offset
		 * @param o_result
		 * @throws FLARException
		 */
		function transMat(i_square:FLARSquare,i_offset:FLARRectOffset,o_result:FLARTransMatResult):Boolean;
		/**
		 * 理想座標系の四角系から、i_offsetのパラメタで示される矩形を(0,0,0)の点から移動するための行列式を計算し、o_resultへ格納します。
		 * i_prev_resultにある過去の情報を参照するため、変移が少ない場合はより高精度な値を返します。
		 * @param i_square
		 * @param i_offset
		 * @param i_prev_result
		 * 参照する過去のオブジェクトです。このオブジェクトとo_resultには同じものを指定できます。
		 * @param o_result
		 * 結果を格納するオブジェクトです。
		 * @throws FLARException
		 */
		function transMatContinue(i_square:FLARSquare,i_offset:FLARRectOffset,i_prev_result:FLARTransMatResult,o_result:FLARTransMatResult):Boolean;
	}
}