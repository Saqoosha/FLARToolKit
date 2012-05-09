package org.libspark.flartoolkit.core.labeling.rlelabeling 
{
	public interface FLARLabeling_Rle_IRasterDriver 
	{
		function xLineToRle(i_x:int,i_y:int,i_len:int,i_th:int,i_out:Vector.<FLARLabeling_Rle_RleElement>):int;
	}
	
}