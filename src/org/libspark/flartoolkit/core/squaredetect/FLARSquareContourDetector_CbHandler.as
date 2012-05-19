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
	import org.libspark.flartoolkit.core.types.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public interface FLARSquareContourDetector_CbHandler 
	{
		/**
		 * 通知ハンドラです。
		 * この関数は、detectMarker関数のコールバック関数として機能します。
		 * 継承先のクラスで、矩形の発見時の処理をここに記述してください。
		 * @param i_coord
		 * @param i_coor_num
		 * @param i_vertex_index
		 * @throws FLARException
		 */
		function detectMarkerCallback(i_coord:FLARIntCoordinates, i_vertex_index:Vector.<int>):void;		
	}

}