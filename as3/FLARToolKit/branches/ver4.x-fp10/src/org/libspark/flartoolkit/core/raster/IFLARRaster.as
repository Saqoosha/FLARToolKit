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
package org.libspark.flartoolkit.core.raster {
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.types.*;			

	public interface IFLARRaster
	{
		function getWidth():int;
		function getHeight():int;
		function getSize():FLARIntSize;
		/**
		 * バッファオブジェクトを返します。
		 * @return
		 */
		function getBuffer():Object;
		/**
		 * バッファオブジェクトのタイプを返します。
		 * @return
		 */
		function getBufferType():int;
		/**
		 * バッファのタイプがi_type_valueであるか、チェックします。
		 * この値は、FLARBufferTypeに定義された定数値です。
		 * @param i_type_value
		 * @return
		 */
		function isEqualBufferType(i_type_value:int):Boolean;
		/**
		 * getBufferがオブジェクトを返せるかの真偽値です。
		 * @return
		 */
		function hasBuffer():Boolean;
		/**
		 * i_ref_bufをラップします。できる限り整合性チェックを行います。
		 * バッファの再ラッピングが可能な関数のみ、この関数を実装してください。
		 * @param i_ref_buf
		 */
		function wrapBuffer(i_ref_buf:Object):void;
		/**
		 * ARTKに必要なラスタドライバインタフェイスを返す。
		 * @return
		 */
		function createInterface(i_iid:Class):Object;
		
	}
}