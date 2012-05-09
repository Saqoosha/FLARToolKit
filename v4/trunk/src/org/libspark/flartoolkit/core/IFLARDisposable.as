package org.libspark.flartoolkit.core 
{
	public interface IFLARDisposable 
	{
		/**
		 * オブジェクトの終期化のタイミングを与えます。オブジェクトの終期化に必要な処理を実装します。
		 */
		function dispose():void;		
	}
	
}