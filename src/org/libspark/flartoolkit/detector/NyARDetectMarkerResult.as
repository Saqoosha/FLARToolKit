package org.libspark.flartoolkit.detector
{
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.NyARSquare;
	internal class NyARDetectMarkerResult
	{
		public var arcode_id:int;
		public var confidence:Number;

		public var square:NyARSquare=new NyARSquare();
	}
}