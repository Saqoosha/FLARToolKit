package org.libspark.flartoolkit.core.labeling.rlelabeling 
{
	public class FLARLabeling_Rle_RleElement
	{
		public var l:int;
		public var r:int;
		public var fid:int;
		public static function createArray(i_length:int):Vector.<FLARLabeling_Rle_RleElement>
		{
			var ret:Vector.<FLARLabeling_Rle_RleElement> = new Vector.<FLARLabeling_Rle_RleElement>(i_length);
			for (var i:int = 0; i < i_length; i++) {
				ret[i] = new FLARLabeling_Rle_RleElement();
			}
			return ret;
		}
	}

}