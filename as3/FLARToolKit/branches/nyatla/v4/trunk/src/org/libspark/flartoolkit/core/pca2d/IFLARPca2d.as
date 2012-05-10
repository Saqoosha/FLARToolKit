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
package org.libspark.flartoolkit.core.pca2d 
{
	import org.libspark.flartoolkit.core.types.matrix.*;
	public interface IFLARPca2d
	{
		/**
		 * 通常のPCA
		 * @param i_v1
		 * @param i_v2
		 * @param i_start
		 * @param i_number_of_point
		 * @param o_evec
		 * 要素2の変数を指定してください。
		 * @param o_ev
		 * 要素2の変数を指定してください。
		 * @param o_mean
		 * @throws FLARException
		 */
		function pca(i_v1:Vector.<Number>, i_v2:Vector.<Number>, i_number_of_point:int, o_evec:FLARDoubleMatrix22, o_ev:Vector.<Number>, o_mean:Vector.<Number>):void;
	}

	
}