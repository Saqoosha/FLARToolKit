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
package org.libspark.flartoolkit.rpf.utils 
{
	import org.libspark.flartoolkit.core.types.*;
	/**
	 * データ型です。
	 * 輪郭ベクトルを格納します。
	 */
	public class VecLinearCoordinatePoint extends FLARVecLinear2d
	{
		/**
		 * ベクトルの2乗値です。輪郭の強度値にもなります。
		 */
		public var scalar:Number;
		public static function createArray(i_length:int):Vector.<VecLinearCoordinatePoint>
		{
			var r:Vector.<VecLinearCoordinatePoint>=new Vector.<VecLinearCoordinatePoint>(i_length);
			for(var i:int=0;i<i_length;i++){
				r[i]=new VecLinearCoordinatePoint();
			}
			return r;
		}
	}

}