/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
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
package org.libspark.flartoolkit.core.rasterfilter.rgb2bin
{
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2bin.INyARRasterFilter_RgbToBin;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.raster.*;


	/**
	 * 定数閾値による2値化をする。
	 * 
	 */
	public class FLARRasterFilter_Threshold implements INyARRasterFilter_RgbToBin
	{
		private var _threshold:int;
		private var _do_threshold_impl:IdoThFilterImpl;

		public function FLARRasterFilter_Threshold(i_threshold:int)
		{
			this._do_threshold_impl = new doThFilterImpl_BUFFERFORMAT_OBJECT_AS3_BitmapData();
		}
		/**
		 * 画像を２値化するための閾値。暗点<=th<明点となります。
		 * @param i_threshold
		 */
		public function setThreshold(i_threshold:int ):void 
		{
			this._threshold = i_threshold;
		}
		public function doFilter(i_input:INyARRgbRaster, i_output:NyARBinRaster):void
		{
			var in_buffer_reader:INyARBufferReader=i_input.getBufferReader();	
			var out_buffer_reader:INyARBufferReader=i_output.getBufferReader();

			NyAS3Utils.assert (i_input.getSize().isEqualSize_NyARIntSize(i_output.getSize()) == true);
			this._do_threshold_impl.doThFilter(in_buffer_reader,out_buffer_reader,i_output.getSize(), this._threshold);
			return;
		}		
		
	}
}
import flash.display.BitmapData;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterfilter.*;
import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
/*
 * ここから各ラスタ用のフィルタ実装
 */
interface IdoThFilterImpl
{
	function doThFilter(i_input:INyARBufferReader,i_output:INyARBufferReader,i_size:NyARIntSize,i_threshold:int):void;
}

import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import jp.nyatla.as3utils.*;

class doThFilterImpl_BUFFERFORMAT_OBJECT_AS3_BitmapData implements IdoThFilterImpl
{
	private static const ZERO_POINT:Point = new Point();
	private static const ONE_POINT:Point = new Point(1, 1);
	private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
		0.2989, 0.5866, 0.1145, 0, 0,
		0.2989, 0.5866, 0.1145, 0, 0,
		0.2989, 0.5866, 0.1145, 0, 0,
		0, 0, 0, 1, 0
	]);
	private var _tmp:BitmapData;	
	public function doThFilter(i_input:INyARBufferReader,i_output:INyARBufferReader,i_size:NyARIntSize,i_threshold:int):void
	{
		NyAS3Utils.assert (i_input.isEqualBufferType(INyARBufferReader.BUFFERFORMAT_OBJECT_AS3_BitmapData));
		NyAS3Utils.assert (i_output.isEqualBufferType(INyARBufferReader.BUFFERFORMAT_OBJECT_AS3_BitmapData));
		
		var out_buf:BitmapData = BitmapData(i_output.getBuffer());
		var in_buf:BitmapData= BitmapData(i_input.getBuffer());

		if (!_tmp) {
			_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
		} else if (in_buf.width != _tmp.width || in_buf.height != _tmp.height) {
			_tmp.dispose();
			_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
		}
		_tmp.applyFilter(in_buf, in_buf.rect, ZERO_POINT, MONO_FILTER);
		out_buf.fillRect(out_buf.rect, 0x0);
		var rect:Rectangle = out_buf.rect;
		rect.inflate(-1, -1);
		out_buf.threshold(_tmp, rect, ONE_POINT, '<=', i_threshold, 0xffffffff, 0xff);
	}
}