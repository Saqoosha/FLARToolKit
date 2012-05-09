package org.libspark.flartoolkit.rpf.reality.nyartk 
{
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.NyARReality;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.*;

	/**
	 * ...
	 * @author 
	 */
	public class FLARReality extends NyARReality
	{
		
		public function FLARReality(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length) {
			case 5:
				if((args[0] is NyARParam) && (args[1] is Number) && (args[2] is Number) && (args[3] is int) && (args[4] is int))
				{
					override_NyARReality(NyARParam(args[0]), Number(args[1]), Number(args[2]), int(args[3]), int(args[4]));
					return;
				}
				break;
			case 7:
				if ((args[0] is NyARIntSize) && (args[1] is Number) && (args[2] is Number) && (args[3] is NyARPerspectiveProjectionMatrix) && ((args[4] is NyARCameraDistortionFactor) || (args[4] == null)) && (args[5] is int) && (args[6] is int))
				{
					override_NyARReality_2(NyARIntSize(args[0]), Number(args[1]), Number(args[2]), NyARPerspectiveProjectionMatrix(args[3]), NyARCameraDistortionFactor(args[4]), int(args[5]), int(args[6]));
					return;
				}
			default:
				break;
			}
			throw new NyARException();			
		}
		
	}

}