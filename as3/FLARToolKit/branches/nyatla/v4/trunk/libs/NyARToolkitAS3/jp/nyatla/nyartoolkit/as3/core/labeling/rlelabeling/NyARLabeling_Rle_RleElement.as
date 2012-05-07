package jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling 
{
	public class NyARLabeling_Rle_RleElement
	{
		public var l:int;
		public var r:int;
		public var fid:int;
		public static function createArray(i_length:int):Vector.<NyARLabeling_Rle_RleElement>
		{
			var ret:Vector.<NyARLabeling_Rle_RleElement> = new Vector.<NyARLabeling_Rle_RleElement>(i_length);
			for (var i:int = 0; i < i_length; i++) {
				ret[i] = new NyARLabeling_Rle_RleElement();
			}
			return ret;
		}
	}

}