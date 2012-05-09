package org.libspark.flartoolkit.core.match 
{
	public interface FLARMatchPattDeviationColorData_IRasterDriver
	{
		/**
		 * この関数は、参照するラスタの差分画像データを取得する。
		 * @param o_out
		 * 差分画像データ
		 * @return
		 * pow値
		 */
		function makeColorData(o_out:Vector.<int>):Number;		
	}
	
}