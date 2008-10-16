/* 
 * PROJECT: FLARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The FLARToolkit is Java version ARToolkit class library.
 * Copyright (C)2008 R.Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package org.libspark.flartoolkit.core.rasterfilter.rgb2bin {
	
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.libspark.flartoolkit.core.raster.FLARRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;

	public class FLARRasterFilter_BitmapDataThreshold implements IFLARRasterFilter_RgbToBin {
		
		private static const ZERO_POINT:Point = new Point();
		private static const ONE_POINT:Point = new Point(1, 1);
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0, 0, 0, 1, 0
		]);
		
		private var _threshold:int;
		
		public function FLARRasterFilter_BitmapDataThreshold(i_threshold:int) {
			this._threshold = i_threshold;
		}

		public function setThreshold(i_threshold:int):void {
			this._threshold = i_threshold;
		}

		public function doFilter(i_input:IFLARRgbRaster, i_output:IFLARRaster):void {
			var inbmp:BitmapData = FLARRgbRaster_BitmapData(i_input).bitmapData;
			inbmp.applyFilter(inbmp, inbmp.rect, ZERO_POINT, MONO_FILTER);
			var outbmp:BitmapData = FLARRaster_BitmapData(i_output).bitmapData;
			outbmp.fillRect(outbmp.rect, 0x0);
			var rect:Rectangle = outbmp.rect;
			rect.inflate(-1, -1);
			outbmp.threshold(inbmp, rect, ONE_POINT, '<=', this._threshold, 0xffffffff, 0xff);
		}
	}
}