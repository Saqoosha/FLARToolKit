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
package org.libspark.flartoolkit.nyidmarker.data 
{
	
	public interface INyIdMarkerData
	{
		/**
		 * i_targetのマーカデータと自身のデータが等しいかを返します。
		 * @param i_target
		 * 比較するマーカオブジェクト
		 * @return
		 * 等しいかの真偽値
		 */
		function isEqual(i_target:INyIdMarkerData):Boolean;
		/**
		 * i_sourceからマーカデータをコピーします。
		 * @param i_source
		 */
		function copyFrom(i_source:INyIdMarkerData):void;
	}
}