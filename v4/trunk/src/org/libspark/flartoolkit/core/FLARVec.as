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
package org.libspark.flartoolkit.core
{

	public class FLARVec
	{
		private var clm:int;
		public function FLARVec(i_clm:int)
		{
			this.v = new Vector.<Number>(i_clm);
			clm = i_clm;
		}

		private var v:Vector.<Number>;

		public function getClm():int
		{
			return clm;
		}
		public function getArray():Vector.<Number>
		{
			return v;
		}

//		*****************************
//		There are not used by FLARToolKit.
//		*****************************
//		public function realloc(i_clm:int):void
//		public function arVecDisp():int
//		public function vecInnerproduct(y:FLARVec,i_start:int):Number
//		public function vecHousehold(i_start:int):Number
//		public function setNewArray(double[] i_array:Vector.<Number>,i_clm:int):void
	}
}