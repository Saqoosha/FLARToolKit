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
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 * For further information of this class, please contact.
 * http://tarotaro.org
 * <taro(at)tarotaro.org>
 */
package org.libspark.flartoolkit.detector.idmarker.data
{
	import jp.nyatla.nyartoolkit.as3.nyidmarker.*;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*;
	import org.libspark.flartoolkit.FLARException;
	public class FLARIdMarkerDataEncoder_RawBit implements INyIdMarkerDataEncoder
	{	
		private static const _DOMAIN_ID:int = 0;
		/**
		 * 制御ドット作成時のmodに使う値
		 */
		private static const _mod_data:Vector.<int> = Vector.<int>([7, 31, 127, 511, 2047, 4095]);

		public function encode(i_data:NyIdMarkerPattern,o_dest:INyIdMarkerData):Boolean
		{
			var dest:FLARIdMarkerData = o_dest as FLARIdMarkerData;
			if (dest == null) {
				throw new FLARException("type of o_dest must be \"FLARIdMarkerData\""); 
			}

			if(i_data.ctrl_domain != _DOMAIN_ID) {
				return false;
			}

			dest.setCheck(i_data.check);
			dest.setControlDomain(i_data.ctrl_domain);
			dest.setControlMask(i_data.ctrl_mask);
			dest.setModel(i_data.model);
			
			//データドット数計算
			var resolution_len:int = (i_data.model * 2 - 1); //trace("resolution", resolution_len);
			dest.setDataDotLength(resolution_len);
			
			//データドット数が、「(2 * model値 - 1)^2」となり、この2乗の元となる値がresolution_lenで、
			//パケット数は「(int)(データドット数 / 8) + 1」（最後に足す1はパケット0）となる
			var packet_length:int = (((resolution_len * resolution_len)) / 8) + 1;
			// trace("packet", packet_length);
			dest.setPacketLength(packet_length);

			var sum:int = 0;
			for(var i:int=0;i<packet_length;i++){
				dest.setPacketData(i, i_data.data[i]);
				// trace("i_data[",i,"]",i_data.data[i]);
				sum += i_data.data[i];
			}
			//チェックドット値計算
			sum = sum % _mod_data[i_data.model - 2];
			// trace("check dot", i_data.check, sum);
			//チェックドット比較
			if(i_data.check!=sum){
				return false;
			}

			return true;
		}
		public function createDataInstance():INyIdMarkerData
		{
			return new FLARIdMarkerData();
		}
	}


}