package org.libspark.flartoolkit.markersystem 
{
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.core.param.*;
	import flash.utils.*;	
	public class FLARMarkerSystemConfig extends FLARMarkerSystemConfig_BaseClass_
	{
		public function FLARMarkerSystemConfig(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length){
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					break;
					//blank
				}else {
					this.FLARMarkerSystemConfig_1o(FLARParam(args[0]));
					break;
				}
				throw new FLARException();
			case 2:
				this.FLARMarkerSystemConfig_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				this.FLARMarkerSystemConfig_3oii(ByteArray(args[0]), int(args[1]),int(args[2]));
				break;
			default:
				throw new FLARException();
			}
		}		
		
	}

}