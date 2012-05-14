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
package org.libspark.flartoolkit.core.raster
{
	import jp.nyatla.as3utils.*;
	
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.types.*;

	public class FLARRaster_BasicClass implements IFLARRaster
	{
		protected var _size:FLARIntSize;
		protected var _buffer_type:int;
		/*
		 * public function FLARRaster_BasicClass(int i_width,int i_height,int i_buffer_type)
		 */
		public function FLARRaster_BasicClass(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 3:
				if (args[0] is int && args[1] is int && args[2] is int){
					overload_FLARRaster_BasicClass(int(args[0]),int(args[1]),int(args[2]));
				}
				break;
			default:
				throw new FLARException();
			}
		}
		protected function overload_FLARRaster_BasicClass(i_width:int ,i_height:int,i_buffer_type:int):void
		{
			this._size = new FLARIntSize(i_width, i_height);
			this._buffer_type=i_buffer_type;
		}

		final public function getWidth():int
		{
			return this._size.w;
		}

		final public function getHeight():int
		{
			return this._size.h;
		}

		final public function getSize():FLARIntSize
		{
			return this._size;
		}
		
		final public function getBufferType():int
		{
			return _buffer_type;
		}
		
		final public function isEqualBufferType(i_type_value:int):Boolean
		{
			return this._buffer_type==i_type_value;
		}

		public function getBuffer():Object
		{
			throw new FLARException();
		}
		
		public function hasBuffer():Boolean
		{
			throw new FLARException();
		}
		
		public function wrapBuffer(i_ref_buf:Object):void
		{
			throw new FLARException();
		}
		
		public function createInterface(i_iid:Class):Object
		{
			return null;
		}
	}
}