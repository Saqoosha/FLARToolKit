package jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling 
{
	public interface NyARLabeling_Rle_IRasterDriver 
	{
		function xLineToRle(i_x:int,i_y:int,i_len:int,i_th:int,i_out:Vector.<NyARLabeling_Rle_RleElement>):int;
	}
	
}