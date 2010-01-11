package jp.nyatla.nyartoolkit.as3.core.raster.rgb {
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;

	/**
	 * NyARRasterインタフェイスの基本関数/メンバを実装したクラス
	 * 
	 * 
	 */
	public class NyARRgbRaster_BasicClass implements INyARRgbRaster
	{
		protected var _size:NyARIntSize;
		public function getWidth():int
		{
			return this._size.w;
		}

		public function getHeight():int
		{
			return this._size.h;
		}

		public function getSize():NyARIntSize
		{
			return this._size;
		}	
		public function NyARRgbRaster_BasicClass(i_size:NyARIntSize)
		{
			this._size= i_size;
		}
		public function getBufferReader():INyARBufferReader
		{
			NyARException.trap("getBufferReader not implemented.");
			return null;
		}		
		public function getRgbPixelReader():INyARRgbPixelReader
		{
			NyARException.trap("getRgbPixelReader not implemented.");
			return null;
		}
	}
}