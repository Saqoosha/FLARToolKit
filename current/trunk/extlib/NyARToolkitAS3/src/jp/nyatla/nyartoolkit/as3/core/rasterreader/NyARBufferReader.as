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
package jp.nyatla.nyartoolkit.as3.core.rasterreader {

	public class NyARBufferReader extends INyARBufferReader
	{
		protected var _buffer:Object;
		protected var _buffer_type:int;

		public function NyARBufferReader(i_buffer:Object, i_buffer_type:int) {
			this._buffer = i_buffer;
			this._buffer_type = i_buffer_type;
		}

		public override function getBuffer():Object
		{
			return this._buffer;
		}

		public override function getBufferType():int
		{
			return _buffer_type;
		}

		public override function isEqualBufferType(i_type_value:int):Boolean
		{
			return this._buffer_type == i_type_value;
		}
	}
}