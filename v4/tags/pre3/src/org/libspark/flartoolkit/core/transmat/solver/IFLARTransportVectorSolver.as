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
package org.libspark.flartoolkit.core.transmat.solver 
{
	import org.libspark.flartoolkit.core.types.*;
	public interface IFLARTransportVectorSolver
	{
		function set2dVertex(i_ref_vertex_2d:Vector.<FLARDoublePoint2d>,i_number_of_vertex:int):void;
		/**
		 * 画面座標群と3次元座標群から、平行移動量を計算します。
		 * 2d座標系は、直前に実行したset2dVertexのものを使用します。
		 * @param i_vertex_2d
		 * 直前のset2dVertexコールで指定したものと同じものを指定してください。
		 * @param i_vertex3d
		 * 3次元空間の座標群を設定します。頂点の順番は、画面座標群と同じ順序で格納してください。
		 * @param o_transfer
		 * @throws FLARException
		 */
		function solveTransportVector(i_vertex3d:Vector.<FLARDoublePoint3d>, o_transfer:FLARDoublePoint3d):void;
	}
	
}