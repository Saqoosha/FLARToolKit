package jp.nyatla.nyartoolkit.as3.rpf.mklib 
{
	/**
	 * selectTarget関数の戻り値を格納します。
	 * 入れ子クラスの作れない処理系では、RawbitSerialIdTable_IdentifyIdResultとして宣言してください。
	 */
	public class RawbitSerialIdTable_IdentifyIdResult
	{
		/** ID番号です。*/
		public var id:Number;
		/** 名前です。*/
		public var name:String;
		/** 登録時に設定したマーカサイズです。*/
		public var marker_width:Number;
		/** ARToolKit準拠の、マーカの方位値です。*/
		public var artk_direction:int;
	}

}