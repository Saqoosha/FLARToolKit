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



	/**
	 * このクラスは、{@link NyIdMarkerDataEncoder_RawBitId}の出力するデータを
	 * 格納します。
	 */
	public class NyIdMarkerData_RawBitId implements INyIdMarkerData
	{
		/** RawbitドメインのNyIdから作成したID値です。*/
		public var marker_id:Number;
		/**
		 * この関数は、i_targetのマーカデータとインスタンスのデータを比較します。
		 * 引数には、{@link NyIdMarkerData_RawBitId}型のオブジェクトを指定してください。
		 */
		public function isEqual(i_target:INyIdMarkerData):Boolean
		{
			var s:NyIdMarkerData_RawBitId=NyIdMarkerData_RawBitId(i_target);
			return s.marker_id==this.marker_id;
		}
		/**
		 * この関数は、i_sourceからインスタンスにマーカデータをコピーします。
		 * 引数には、{@link NyIdMarkerData_RawBit}型のオブジェクトを指定してください。
		 */	
		public function copyFrom(i_source:INyIdMarkerData):void
		{
			var s:NyIdMarkerData_RawBitId=NyIdMarkerData_RawBitId(i_source);
			this.marker_id=s.marker_id;
			return;
		}
	}
}