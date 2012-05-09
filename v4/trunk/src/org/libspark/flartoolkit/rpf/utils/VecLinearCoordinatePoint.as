package org.libspark.flartoolkit.rpf.utils 
{
	import org.libspark.flartoolkit.core.types.*;
	/**
	 * データ型です。
	 * 輪郭ベクトルを格納します。
	 */
	public class VecLinearCoordinatePoint extends FLARVecLinear2d
	{
		/**
		 * ベクトルの2乗値です。輪郭の強度値にもなります。
		 */
		public var scalar:Number;
		public static function createArray(i_length:int):Vector.<VecLinearCoordinatePoint>
		{
			var r:Vector.<VecLinearCoordinatePoint>=new Vector.<VecLinearCoordinatePoint>(i_length);
			for(var i:int=0;i<i_length;i++){
				r[i]=new VecLinearCoordinatePoint();
			}
			return r;
		}
	}

}