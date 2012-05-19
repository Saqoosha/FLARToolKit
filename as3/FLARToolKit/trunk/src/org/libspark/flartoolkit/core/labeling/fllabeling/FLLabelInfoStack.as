package org.libspark.flartoolkit.core.labeling.fllabeling
{
	import org.libspark.flartoolkit.core.labeling.rlelabeling.FLARRleLabelFragmentInfo;
	import org.libspark.flartoolkit.core.types.stack.FLARObjectStack;
	
	internal class FLLabelInfoStack extends FLARObjectStack
	{
		public function FLLabelInfoStack(i_length:int)
		{
			super();
			super.initInstance(i_length);
			return;
		}
		protected override function createElement():Object
		{
			return new FLARRleLabelFragmentInfo();
		}
	}
}