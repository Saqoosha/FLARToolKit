/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.pca2d 
{
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	public interface INyARPca2d
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
		 * @throws NyARException
		 */
		function pca(i_v1:Vector.<Number>, i_v2:Vector.<Number>, i_number_of_point:int, o_evec:NyARDoubleMatrix22, o_ev:Vector.<Number>, o_mean:Vector.<Number>):void;
	}

	
}