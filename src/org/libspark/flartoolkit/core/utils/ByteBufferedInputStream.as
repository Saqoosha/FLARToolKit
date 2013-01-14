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
package org.libspark.flartoolkit.core.utils 
{

	import flash.utils.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.*;
	/**
	 * このクラスは、{@link InputStream}からバッファリングしながら読み出します。
	 *
	 */
	public class ByteBufferedInputStream
	{
		public static const ENDIAN_LITTLE:int=1;
		public static const ENDIAN_BIG:int=2;
		private var _bb:ByteArray;
		public function ByteBufferedInputStream(i_stream:ByteArray)
		{
			this._bb=i_stream;
			this._bb.endian=Endian.LITTLE_ENDIAN;
		}
		/**
		 * マルチバイト読み込み時のエンディアン.{@link #ENDIAN_BIG}か{@link #ENDIAN_LITTLE}を設定してください。
		 * @param i_order
		 */
		public function order(i_order:int):void
		{
			this._bb.endian=(i_order==ENDIAN_LITTLE?Endian.LITTLE_ENDIAN:Endian.BIG_ENDIAN);
		}
		/**
		 * streamからi_bufへi_sizeだけ読み出します。
		 * @param i_buf
		 * @param i_size
		 * @return
		 * 読み出したバイト数
		 * @throws FLARException
		 */
		public function readBytes(i_buf:ByteArray, i_size:int):int
		{
			this._bb.readBytes(i_buf, 0, i_size);
			return i_size;
		}	
		public function getInt():int
		{
			return this._bb.readInt();
		}
		public function getByte():int
		{
			return this._bb.readByte();
		}
		public function getFloat():Number
		{
			return this._bb.readFloat();
		}
		public function getDouble():Number
		{
			return this._bb.readDouble();
		}
	}
}