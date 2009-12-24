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
	import flash.utils.*;
	
	public class Marshal extends ByteArray
	{
		private var _st:int;
		public function Marshal()
		{
			this.endian=Endian.LITTLE_ENDIAN;
			return;
		}
		/**
		 * This function prepares to write from ByteArray.
		 * Must call this function to write ByteArray before call setValue API in proxy class.
		 * --
		 * この関数は、Marshalクラスに値をセットする準備をします。ByteArrayに値をセットする前に呼び出してください。
		 * 
		 */
		public function prepareWrite():void
		{
			this.position=0;
		}
		/**
		 * This function prepares to read from ByteArray.
		 * Must call this function to read ByteArray after called getValue API in proxy class.		 * --
		 * この関数は、Marshalクラスから値をゲットする準備をします。ByteArrayから値をゲットする前に呼び出してください。 		 */
		public function prepareRead():void
		{
			this.position=0;
		}
		public function prepareCallAlchmy():void
		{
			this.position=0;
		}
		
	}
	
}
