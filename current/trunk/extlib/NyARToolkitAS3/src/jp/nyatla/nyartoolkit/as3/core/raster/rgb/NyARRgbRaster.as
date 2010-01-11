package jp.nyatla.nyartoolkit.as3.core.raster.rgb 
{
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	public class NyARRgbRaster extends NyARRgbRaster_BasicClass
	{
		protected var _buf:Object;
		protected var _reader:INyARRgbPixelReader;
		protected var _buffer_reader:INyARBufferReader;
		public function NyARRgbRaster(i_size:NyARIntSize, i_raster_type:int)
		{
			super(i_size);
			if(!initInstance(i_size,i_raster_type)){
				throw new NyARException();
			}
			return;
		}
		public override function getRgbPixelReader():INyARRgbPixelReader
		{
			return this._reader;
		}
		public override function getBufferReader():INyARBufferReader
		{
			return this._buffer_reader;
		}
		protected function initInstance(i_size:NyARIntSize,i_raster_type:int):Boolean
		{
			switch(i_raster_type)
			{
				case INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32:
					this._buf=new Vector.<int>(i_size.w*i_size.h);
					this._reader=new NyARRgbPixelReader_INT1D_X8R8G8B8_32(Vector.<int>(this._buf),i_size);
					break;
				default:
					return false;
			}
			this._buffer_reader=new NyARBufferReader(this._buf,i_raster_type);
			return true;
		}	
	}



}