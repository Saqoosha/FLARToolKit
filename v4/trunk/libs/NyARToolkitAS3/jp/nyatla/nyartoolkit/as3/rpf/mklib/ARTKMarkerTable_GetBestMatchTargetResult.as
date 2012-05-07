package jp.nyatla.nyartoolkit.as3.rpf.mklib 
{
	/**
	 * selectTarget関数の戻り値を格納します。
	 * 入れ子クラスの作れない処理系では、ARTKMarkerTable_GetBestMatchTargetResultとして宣言してください。
	 */	
	public class ARTKMarkerTable_GetBestMatchTargetResult
	{
		/** 登録時に設定したIDです。*/
		public var idtag:int;
		/** 登録時に設定した名前です。*/
		public var name:String;
		/** 登録時に設定したマーカサイズです。*/
		public var marker_width:Number;
		/** 登録時に設定したマーカサイズです。*/
		public var marker_height:Number;
		/** ARToolKit準拠の、マーカの方位値*/
		public var artk_direction:int;
		/** 一致率*/
		public var confidence:Number;
	}

}