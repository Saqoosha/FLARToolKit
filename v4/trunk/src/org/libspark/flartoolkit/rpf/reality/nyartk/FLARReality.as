package org.libspark.flartoolkit.rpf.reality.nyartk 
{
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;

	/**
	 * ...
	 * @author 
	 */
	public class FLARReality extends FLARReality_BaseClass_
	{
		
		public function FLARReality(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length) {
			case 5:
				if((args[0] is FLARParam) && (args[1] is Number) && (args[2] is Number) && (args[3] is int) && (args[4] is int))
				{
					override_FLARReality(FLARParam(args[0]), Number(args[1]), Number(args[2]), int(args[3]), int(args[4]));
					return;
				}
				break;
			case 7:
				if ((args[0] is FLARIntSize) && (args[1] is Number) && (args[2] is Number) && (args[3] is FLARPerspectiveProjectionMatrix) && ((args[4] is FLARCameraDistortionFactor) || (args[4] == null)) && (args[5] is int) && (args[6] is int))
				{
					override_FLARReality_2(FLARIntSize(args[0]), Number(args[1]), Number(args[2]), FLARPerspectiveProjectionMatrix(args[3]), FLARCameraDistortionFactor(args[4]), int(args[5]), int(args[6]));
					return;
				}
			default:
				break;
			}
			throw new FLARException();			
		}
		
	}

}