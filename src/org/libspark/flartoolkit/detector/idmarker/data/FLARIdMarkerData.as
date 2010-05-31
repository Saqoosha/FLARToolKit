package org.libspark.flartoolkit.detector.idmarker.data
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
 * For further information of this class, please contact.
 * http://tarotaro.org
 * <taro(at)tarotaro.org>
 */
{
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.INyIdMarkerData;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.NyIdMarkerPattern;
	/**
	 * ...
	 * @author tarotarorg
	 */
	public class FLARIdMarkerData implements INyIdMarkerData
	{
		/**
		 * パケットデータをVectorで表現。（最大パケット数がモデル7での21+(1)なので、22で初期化している）
		 */
		private var _packet:Vector.<int> = new Vector.<int>(22);
		private var _model:int;
		private var _controlDomain:int;
		private var _controlMask:int;
		private var _check:int;

		private var _dataDot:int;
		private var _packetLength:int;

		public function FLARIdMarkerData() 
		{
		}
		
		public function isEqual(i_target:INyIdMarkerData):Boolean
		{
			if (i_target == null || !(i_target is FLARIdMarkerData)) { 
				return false;
			}
			var s:FLARIdMarkerData = i_target as FLARIdMarkerData;
			if (s.packetLength != this._packetLength		||
				s._check != this._check					||
				s._controlDomain != this._controlDomain	||
				s._controlMask != this._controlMask		||
				s._dataDot != this._dataDot				||
				s._model != this._model){
				return false;
			}

			for(var i:int = s.packetLength - 1; i>=0; i--){
				if(s._packet[i] != this._packet[i]){
					return false;
				}
			}
			return true;
		}

		public function copyFrom(i_source:INyIdMarkerData):void
		{
			var s:FLARIdMarkerData = i_source as FLARIdMarkerData;
			if (s == null) return;
			
			this._check = s._check;
			this._controlDomain = s._controlDomain;
			this._controlMask = s._controlMask;
			this._dataDot = s._dataDot;
			this._model = s._model;
			this._packetLength = s._packetLength;
			
			for (var i:int = s.packetLength - 1; i >= 0; i--) {
				this._packet[i] = s._packet[i];
			}
			return;
		}
		
///////////////////////////////////////////////////////////////////////////////////
// setters
///////////////////////////////////////////////////////////////////////////////////
		internal function setModel(value:int):void 
		{
			_model = value;
		}
		
		internal function setControlDomain(value:int):void 
		{
			_controlDomain = value;
		}
		
		internal function setControlMask(value:int):void 
		{
			_controlMask = value;
		}
		
		internal function setCheck(value:int):void 
		{
			_check = value;
		}
		
		internal function setPacketData(index:int, data:int):void
		{
			if (index < this.packetLength) {
				this._packet[index] = data;
			} else {
				throw new ArgumentError("packet index over");
			}
		}
		
		internal function setDataDotLength(value:int):void
		{
			_dataDot = value;
		}
		
		internal function setPacketLength(value:int):void
		{
			_packetLength = value;
		}
///////////////////////////////////////////////////////////////////////////////////
// getters
///////////////////////////////////////////////////////////////////////////////////
		public function get dataDotLength():int { return _dataDot; }
		
		public function get packetLength():int { return _packetLength; }
		
		public function get model():int { return _model; }
		
		public function get controlDomain():int { return _controlDomain; }
		
		public function get controlMask():int { return _controlMask; }
		
		public function get check():int { return _check; }
		
		public function getPacketData(index:int):int
		{
			if (this.packetLength <= index) throw new ArgumentError("packet index over");
			return this._packet[index];
		}
	}

}