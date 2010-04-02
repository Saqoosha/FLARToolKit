package org.libspark.flartoolkit.detector.multi
{
	import jp.nyatla.nyartoolkit.as3.core.types.stack.NyARObjectStack;

	public class FLARDetectMarkerResultStack extends NyARObjectStack
{
	public function FLARDetectMarkerResultStack(i_length:int)
	{
		super(i_length);
	}
	protected override function createArray(i_length:int):Vector.<*>
	{
		var ret:Vector.<FLARDetectMarkerResult>= new Vector.<FLARDetectMarkerResult>(i_length);
		for (var i:int =0; i < i_length; i++){
			ret[i] = new FLARDetectMarkerResult();
		}
		return Vector.<*>(ret);
	}	
}
}