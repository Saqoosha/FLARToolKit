/* 
 * PROJECT: AlchemyMaster
 * --------------------------------------------------------------------------------
 * The AlchemyMaster is helper classes and templates for Adobe Alchemy.
 *
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as 
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this program. If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/
 *	<airmail(at)ebony.plala.or.jp>
 */

package jp.nyatla.alchemymaster
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;	
	
	public class AlchemyClassProxy
	{
		protected var _alchemy_stub:Object;
		public var _alchemy_ptr:uint;
		protected var _ma:Marshal=new Marshal();
		public var debug_str:String=new String();
		public function dumpMarshalStr():String
		{
			return this._ma.toString();
		}
		public function dumpMarshalInt(i_len:int):String
		{
			var s:String=new String();
			this._ma.position=0;
			for(var i:int=0;i<i_len;i++){
				s+=(this._ma.readInt().toString()+",");
			}
			return s;
		}

		public function dispose():void
		{
			this._alchemy_stub.dispose(this._alchemy_ptr);
			this._alchemy_stub=null;
			return;
		}
	}
}
