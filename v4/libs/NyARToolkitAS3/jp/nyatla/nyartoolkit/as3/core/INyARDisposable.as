package jp.nyatla.nyartoolkit.as3.core 
{
	public interface INyARDisposable 
	{
		/**
		 * オブジェクトの終期化のタイミングを与えます。オブジェクトの終期化に必要な処理を実装します。
		 */
		function dispose():void;		
	}
	
}