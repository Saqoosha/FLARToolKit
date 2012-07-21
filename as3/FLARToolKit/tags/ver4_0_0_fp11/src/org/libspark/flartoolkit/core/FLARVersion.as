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
package org.libspark.flartoolkit.core
{
	/**
	 * このクラスは、FLARToolkitライブラリのバージョン情報を保持します。
	 */
	public class FLARVersion
	{
		/**モジュール名*/
		public static const MODULE_NAME:String="FLARToolkit";
		/**メジャーバージョン*/
		public static const VERSION_MAJOR:int= 4;
		/**マイナバージョン*/
		public static const VERSION_MINOR:int=0;
		/**タグ*/
		public static const VERSION_TAG:int=3;
		/**バージョン文字列*/
		public static const VERSION_STRING:String=MODULE_NAME+"/"+VERSION_MAJOR+"."+VERSION_MINOR+"."+VERSION_TAG;
	}
}