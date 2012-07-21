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
package org.libspark.flartoolkit.core.squaredetect
{
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.types.FLARIntCoordinates;
	
	internal class FLARContourPickup_Base implements FLARContourPickup_IRasterDriver
	{
		//巡回参照できるように、テーブルを二重化
		//                                           0  1  2  3  4  5  6  7   0  1  2  3  4  5  6
		/**
		 * 8方位探索の座標マップ
		 */
		protected static var _getContour_xdir:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0,-1,-1,-1 , 0, 1, 1, 1, 0,-1,-1]);
		
		/**
		 * 8方位探索の座標マップ
		 */
		protected static var _getContour_ydir:Vector.<int> = Vector.<int>([-1,-1, 0, 1, 1, 1, 0,-1 ,-1,-1, 0, 1, 1, 1, 0]);
		
		public function getContour(i_l:int, i_t:int, i_r:int, i_b:int, i_entry_x:int, i_entry_y:int, i_th:int, o_coord:FLARIntCoordinates):Boolean
		{
			throw new FLARException();
		}
	}
}