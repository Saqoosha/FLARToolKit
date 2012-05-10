/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.core.rasterdriver 
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.pixeldriver.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.*;

	/**
	 * IFLARHistogramFromRasterを生成します。
	 * 対応しているラスタは、以下の通りです。
	 * <ul>
	 * <li>{@link IFLARGrayscaleRaster}の継承ラスタ</li>
	 * <li>{@link IFLARRgbRaster}の継承ラスタ</li>
	 * <li>{@link FLARBufferType#INT1D_GRAY_8}形式のバッファを持つもの<li>
	 * <li>{@link FLARBufferType#INT1D_BIN_8}形式のバッファを持つもの<li>
	 */
	public class FLARHistogramFromRasterFactory
	{
		public static function createInstance(i_raster:IFLARGrayscaleRaster):IFLARHistogramFromRaster
		{
			switch(i_raster.getBufferType()){
			case FLARBufferType.INT1D_GRAY_8:
			case FLARBufferType.INT1D_BIN_8:
				return new FLARHistogramFromRaster_INTGS8(i_raster);
			default:
				if(i_raster is IFLARGrayscaleRaster){
					return new FLARHistogramFromRaster_AnyGs(IFLARGrayscaleRaster(i_raster));
				}
				if(i_raster is IFLARRgbRaster){
					return new FLARHistogramFromRaster_AnyRgb(IFLARRgbRaster(i_raster));
				}
				break;
			}
			throw new FLARException();
		}
		public static function createInstance_2(i_raster:IFLARRgbRaster):IFLARHistogramFromRaster
		{
			if(i_raster is IFLARRgbRaster){
				return new FLARHistogramFromRaster_AnyRgb(IFLARRgbRaster(i_raster));
			}
			throw new FLARException();
		}
		
	}
}

import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.pixeldriver.*;
import org.libspark.flartoolkit.core.rasterdriver.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.types.*;

//ラスタドライバ

class FLARHistogramFromRaster_AnyGs implements IFLARHistogramFromRaster
{
	private var _gsr:IFLARGrayscaleRaster;
	public function FLARHistogramFromRaster_AnyGs(i_raster:IFLARGrayscaleRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:FLARHistogram):void
	{
		var s:FLARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:FLARHistogram):void
	{
		o_histogram.reset();
		var data_ptr:Vector.<int>=o_histogram.data;
		var drv:IFLARGsPixelDriver=this._gsr.getGsPixelDriver();
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

class FLARHistogramFromRaster_AnyRgb implements IFLARHistogramFromRaster
{
	private var _gsr:IFLARRgbRaster;
	public function FLARHistogramFromRaster_AnyRgb(i_raster:IFLARRgbRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:FLARHistogram):void
	{
		var s:FLARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	private var tmp:Vector.<int>=new Vector.<int>[3];
	public function createHistogram(i_l:int, i_t:int, i_w:int, i_h:int, i_skip:int, o_histogram:FLARHistogram):void
	{
		o_histogram.reset();
		var data_ptr:Vector.<int>=o_histogram.data;
		var drv:IFLARRgbPixelDriver=this._gsr.getRgbPixelDriver();
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


class FLARHistogramFromRaster_INTGS8 implements IFLARHistogramFromRaster
{
	private var _gsr:IFLARRaster;
	public function FLARHistogramFromRaster_INTGS8(i_raster:IFLARRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:FLARHistogram):void
	{
		var s:FLARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:FLARHistogram):void
	{
		o_histogram.reset();
		var input:Vector.<int>=Vector.<int>(this._gsr.getBuffer());
		var s:FLARIntSize=this._gsr.getSize();
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

