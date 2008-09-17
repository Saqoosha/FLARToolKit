package org.tarotaro.flash.ar.layers 
{
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARLayer extends Sprite
	{
		protected var _source:FLARBitmapData;
		protected var _thresh:int;

		public function FLARLayer(src:FLARBitmapData,thresh:int) 
		{
			this._source = src;
			this._thresh = thresh;
		}
		
		public function update():void
		{
			throw new ArgumentError("update()は、オーバーライドして使用してください。");
		}		
	}
	
}