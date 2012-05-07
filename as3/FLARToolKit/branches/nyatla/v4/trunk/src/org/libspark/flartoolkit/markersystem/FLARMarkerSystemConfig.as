package org.libspark.flartoolkit.markersystem 
{
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import flash.utils.*;	
	public class FLARMarkerSystemConfig extends NyARMarkerSystemConfig
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
					this.NyARMarkerSystemConfig_1o(NyARParam(args[0]));
					break;
				}
				throw new NyARException();
			case 2:
				this.NyARMarkerSystemConfig_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				this.NyARMarkerSystemConfig_3oii(ByteArray(args[0]), int(args[1]),int(args[2]));
				break;
			default:
				throw new NyARException();
			}
		}		
		
	}

}