/* 
 * PROJECT: NyARToolkit(Extension)
 * -------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2012 Ryo Iizuka
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.rasterdriver 
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	/**
	 * INyARHistogramFromRasterを生成します。
	 * 対応しているラスタは、以下の通りです。
	 * <ul>
	 * <li>{@link INyARGrayscaleRaster}の継承ラスタ</li>
	 * <li>{@link INyARRgbRaster}の継承ラスタ</li>
	 * <li>{@link NyARBufferType#INT1D_GRAY_8}形式のバッファを持つもの<li>
	 * <li>{@link NyARBufferType#INT1D_BIN_8}形式のバッファを持つもの<li>
	 */
	public class NyARHistogramFromRasterFactory
	{
		public static function createInstance(i_raster:INyARGrayscaleRaster):INyARHistogramFromRaster
		{
			switch(i_raster.getBufferType()){
			case NyARBufferType.INT1D_GRAY_8:
			case NyARBufferType.INT1D_BIN_8:
				return new NyARHistogramFromRaster_INTGS8(i_raster);
			default:
				if(i_raster is INyARGrayscaleRaster){
					return new NyARHistogramFromRaster_AnyGs(INyARGrayscaleRaster(i_raster));
				}
				if(i_raster is INyARRgbRaster){
					return new NyARHistogramFromRaster_AnyRgb(INyARRgbRaster(i_raster));
				}
				break;
			}
			throw new NyARException();
		}
		public static function createInstance_2(i_raster:INyARRgbRaster):INyARHistogramFromRaster
		{
			if(i_raster is INyARRgbRaster){
				return new NyARHistogramFromRaster_AnyRgb(INyARRgbRaster(i_raster));
			}
			throw new NyARException();
		}
		
	}
}

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;

//ラスタドライバ

class NyARHistogramFromRaster_AnyGs implements INyARHistogramFromRaster
{
	private var _gsr:INyARGrayscaleRaster;
	public function NyARHistogramFromRaster_AnyGs(i_raster:INyARGrayscaleRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:NyARHistogram):void
	{
		var s:NyARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:NyARHistogram):void
	{
		o_histogram.reset();
		var data_ptr:Vector.<int>=o_histogram.data;
		var drv:INyARGsPixelDriver=this._gsr.getGsPixelDriver();
		var pix_count:int=i_w;
		var pix_mod_part:int=pix_count-(pix_count%8);
		//左上から1行づつ走査していく
		for (var y:int = i_h-1; y >=0 ; y-=i_skip){
			for (var x:int = pix_count-1; x >=pix_mod_part; x--){
				data_ptr[drv.getPixel(x,y)]++;
			}
		}
		o_histogram.total_of_data=i_w*i_h/i_skip;
		return;
	}	
}

class NyARHistogramFromRaster_AnyRgb implements INyARHistogramFromRaster
{
	private var _gsr:INyARRgbRaster;
	public function NyARHistogramFromRaster_AnyRgb(i_raster:INyARRgbRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:NyARHistogram):void
	{
		var s:NyARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	private var tmp:Vector.<int>=new Vector.<int>[3];
	public function createHistogram(i_l:int, i_t:int, i_w:int, i_h:int, i_skip:int, o_histogram:NyARHistogram):void
	{
		o_histogram.reset();
		var data_ptr:Vector.<int>=o_histogram.data;
		var drv:INyARRgbPixelDriver=this._gsr.getRgbPixelDriver();
		var pix_count:int=i_w;
		var pix_mod_part:int=pix_count-(pix_count%8);			
		//左上から1行づつ走査していく
		for (var y:int = i_h-1; y >=0 ; y-=i_skip){
			for (var x:int = pix_count-1; x >=pix_mod_part; x--){
				drv.getPixel(x,y,tmp);
				data_ptr[(tmp[0]+tmp[1]+tmp[2])/3]++;
			}
		}
		o_histogram.total_of_data=i_w*i_h/i_skip;
		return;
	}	
}


class NyARHistogramFromRaster_INTGS8 implements INyARHistogramFromRaster
{
	private var _gsr:INyARRaster;
	public function NyARHistogramFromRaster_INTGS8(i_raster:INyARRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:NyARHistogram):void
	{
		var s:NyARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:NyARHistogram):void
	{
		o_histogram.reset();
		var input:Vector.<int>=Vector.<int>(this._gsr.getBuffer());
		var s:NyARIntSize=this._gsr.getSize();
		var skip:int=(i_skip*s.w-i_w);
		var pix_count:int=i_w;
		var pix_mod_part:int=pix_count-(pix_count%8);			
		//左上から1行づつ走査していく
		var pt:int=(i_t*s.w+i_l);
		var data:Vector.<int>=o_histogram.data;
		for (var y:int= i_h-1; y >=0 ; y-=i_skip){
			var x:int;
			for (x = pix_count-1; x >=pix_mod_part; x--){
				data[input[pt++]]++;
			}
			for (;x>=0;x-=8){
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
				data[input[pt++]]++;
			}
			//スキップ
			pt+=skip;
		}
		o_histogram.total_of_data=i_w*i_h/i_skip;
		return;
	}
}

