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
package org.libspark.flartoolkit.core.raster.rgb
{
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import flash.display.BitmapData;

	public class FLARRgbRaster_BitmapData extends NyARRgbRaster_BasicClass
	{
		private var _bitmapData:BitmapData;
		private var _rgb_reader:RgbReader;
		private var _buffer_reader:NyARBufferReader;

		public function FLARRgbRaster_BitmapData(i_width:int,i_height:int)
		{
			super(new NyARIntSize(i_width, i_height));
			this._bitmapData = new BitmapData(i_width,i_height,false);
			this._rgb_reader = new RgbReader(this._bitmapData);
			this._buffer_reader = new NyARBufferReader(this._bitmapData, INyARBufferReader.BUFFERFORMAT_OBJECT_AS3_BitmapData);
		}

		public override function getRgbPixelReader():INyARRgbPixelReader
		{
			return this._rgb_reader;
		}

		public override function getBufferReader():INyARBufferReader
		{
			return this._buffer_reader;
		}
	}
}

import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
import flash.display.BitmapData;
import jp.nyatla.nyartoolkit.as3.*;



	
class RgbReader implements INyARRgbPixelReader
{
	private var _ref_bitmap:BitmapData;

	public function RgbReader(i_buffer:BitmapData)
	{
		this._ref_bitmap = i_buffer;
	}

	public function getPixel(i_x:int, i_y:int, o_rgb:Vector.<int>):void
	{
		var c:int = this._ref_bitmap.getPixel(i_x, i_y);
		o_rgb[0] = (c >> 16) & 0xff;// R
		o_rgb[1] = (c >> 8) & 0xff;// G
		o_rgb[2] = c & 0xff;// B
		return;
	}
	
	public function getPixelSet(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, o_rgb:Vector.<int>):void
	{
		var bmp:BitmapData = this._ref_bitmap;
		var c:int;
		var i:int;
		for (i = 0; i < i_num; i++) {
			c = bmp.getPixel(i_x[i], i_y[i]);
			o_rgb[i*3+0] = (c >> 16) & 0xff;
			o_rgb[i*3+1] = (c >> 8) & 0xff;
			o_rgb[i*3+2] = c & 0xff;
		}
	}

	public function setPixel(i_x:int, i_y:int, i_rgb:Vector.<int>):void
	{
		NyARException.notImplement();
	}
	public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
	{
		NyARException.notImplement();
	}
	
	
}

