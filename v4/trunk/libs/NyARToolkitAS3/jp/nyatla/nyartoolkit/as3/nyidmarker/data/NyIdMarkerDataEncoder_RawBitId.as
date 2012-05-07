package jp.nyatla.nyartoolkit.as3.nyidmarker.data 
{
	import jp.nyatla.nyartoolkit.as3.nyidmarker.*;
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