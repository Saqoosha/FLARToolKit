package jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2bin
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;


	/**
	 * 定数閾値による2値化をする。
	 * 
	 */
	public class NyARRasterFilter_ARToolkitThreshold implements INyARRasterFilter_RgbToBin
	{
		private var _threshold:int;
		private var _do_threshold_impl:IdoThFilterImpl;

		public function NyARRasterFilter_ARToolkitThreshold(i_threshold:int, i_input_raster_type:int)
		{
			this._threshold = i_threshold;
			switch (i_input_raster_type) {
			case INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32:
				this._do_threshold_impl=new doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32();
				break;
			default:
				throw new NyARException();
			}

			
		}
		/**
		 * 画像を２値化するための閾値。暗点<=th<明点となります。
		 * @param i_threshold
		 */
		public function setThreshold(i_threshold:int ):void 
		{
			this._threshold = i_threshold;
		}
		public function doFilter(i_input:INyARRgbRaster,i_output:NyARBinRaster):void
		{
			var in_buffer_reader:INyARBufferReader=i_input.getBufferReader();	
			var out_buffer_reader:INyARBufferReader=i_output.getBufferReader();

			NyAS3Utils.assert (out_buffer_reader.isEqualBufferType(INyARBufferReader.BUFFERFORMAT_INT1D_BIN_8));
			NyAS3Utils.assert (i_input.getSize().isEqualSize_NyARIntSize(i_output.getSize()) == true);
			this._do_threshold_impl.doThFilter(in_buffer_reader,out_buffer_reader,i_output.getSize(), this._threshold);
			return;
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterfilter.*;
import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.as3utils.*;
/*
 * ここから各ラスタ用のフィルタ実装
 */
interface IdoThFilterImpl
{
	function doThFilter(i_input:INyARBufferReader,i_output:INyARBufferReader,i_size:NyARIntSize,i_threshold:int):void;
}


class doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32 implements IdoThFilterImpl
{
	public function doThFilter(i_input:INyARBufferReader,i_output:INyARBufferReader,i_size:NyARIntSize,i_threshold:int):void
	{
		NyAS3Utils.assert (i_output.isEqualBufferType(INyARBufferReader.BUFFERFORMAT_INT1D_BIN_8));
		var out_buf:Vector.<int> = (Vector.<int>)(i_output.getBuffer());
		var in_buf:Vector.<int> = (Vector.<int>)(i_input.getBuffer());
		
		var th:int=i_threshold*3;
		var w:int;
		var xy:int;
		var pix_count:int=i_size.h*i_size.w;
		var pix_mod_part:int=pix_count-(pix_count%8);

		for(xy=pix_count-1;xy>=pix_mod_part;xy--){
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
		}
		//タイリング
		for (;xy>=0;) {
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
			w=in_buf[xy];
			out_buf[xy]=(((w>>16)&0xff)+((w>>8)&0xff)+(w&0xff))<=th?0:1;
			xy--;
		}			
	}		
}