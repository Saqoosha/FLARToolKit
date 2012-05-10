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
	import org.libspark.flartoolkit.nyidmarker.*;
	public class NyIdMarkerDataEncoder_RawBitId extends NyIdMarkerDataEncoder_RawBit
	{
		private var _tmp:NyIdMarkerData_RawBit=new NyIdMarkerData_RawBit();
		public override function encode(i_data:NyIdMarkerPattern,o_dest:INyIdMarkerData):Boolean
		{
			//対象か調べるん
			if(i_data.ctrl_domain!=0)
			{
				return false;
			}
			//受け入れられるMaskは0のみ
			if(i_data.ctrl_mask!=0)
			{
				return false;
			}
			//受け入れられるModelは5未満
			if(i_data.model>=5)
			{
				return false;
			}
			//エンコードしてみる
			if(!super.encode(i_data,this._tmp)){
				return false;
			}
			//SerialIDの再構成
			var s:Number=0;
			//最大4バイト繋げて１個のint値に変換
			for (var i:int = 0; i < this._tmp.length; i++)
			{
				s= (s << 8) | this._tmp.packet[i];
			}
			(NyIdMarkerData_RawBitId(o_dest)).marker_id=s;
			return true;
		}
		/**
		 * この関数は、{@link NyIdMarkerData_RawBitId}型のオブジェクトを生成して返します。
		 */
		public override function createDataInstance():INyIdMarkerData
		{
			return new NyIdMarkerData_RawBitId();
		}			
	}
}