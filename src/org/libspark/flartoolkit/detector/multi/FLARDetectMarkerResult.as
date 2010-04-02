package org.libspark.flartoolkit.detector.multi
{
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;

	public class FLARDetectMarkerResult
	{
		public var arcode_id:int;
		public var confidence:Number;
		public var direction:int;

		public var square:FLARSquare=new FLARSquare();
	}
}