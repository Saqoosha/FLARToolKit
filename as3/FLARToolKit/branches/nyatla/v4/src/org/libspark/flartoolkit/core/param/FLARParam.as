/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
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
package org.libspark.flartoolkit.core.param 
{
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	public class FLARParam extends NyARParam
	{
		/**
		 * 複数の関数パラメータがあります。
		 * overload_FLARParam_3oii(i_stream:ByteArray,i_width:int,i_height:int)
		 *  ByteArrayを指定サイズに変更してインスタンスを生成する。
		 * overload_FLARParam_2ii(i_width:int,i_height:int)
		 *  デフォルトパラメータを指定サイズに変更してインスタンスを生成する。
		 * @param	...args
		 */
		public function FLARParam(...args:Array) 
		{
			super();
			switch(args.length) {
			case 0:
				return;
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					return;
				}
				break;
			case 2:
				if((args[0] is int) && (args[1] is int))
				{
					overload_FLARParam_2ii(int(args[0]), int(args[1]));
					return;
				}
				break;
			case 3:
				if((args[0] is ByteArray) && (args[1] is int) && (args[2] is int))
				{
					overload_FLARParam_3oii(ByteArray(args[0]), int(args[1]), int(args[2]));
					return;
				}
				break;
			default:
				break;
			}
			throw new NyARException();
			
		}
		public function overload_FLARParam_2ii(i_width:int,i_height:int):void
		{
			this.loadDefaultParameter();
			this.changeScreenSize(i_width, i_height);
		}		
		public function overload_FLARParam_3oii(i_stream:ByteArray,i_width:int,i_height:int):void
		{
			this.loadARParam(i_stream);
			this.changeScreenSize(i_width, i_height);
		}
	}

}