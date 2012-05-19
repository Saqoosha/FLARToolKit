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
package org.libspark.flartoolkit.core.raster
{
	import flash.geom.Rectangle;
	
	import org.libspark.flartoolkit.core.rasterdriver.IFLARHistogramFromRaster;
	import org.libspark.flartoolkit.core.types.FLARHistogram;
	import org.libspark.flartoolkit.core.types.FLARIntSize;

	//
	//画像ドライバ
	//
	internal class FLARHistogramFromRaster_AnyGs implements IFLARHistogramFromRaster
	{
		private var _gsr:FLARGrayscaleRaster;
		public function FLARHistogramFromRaster_AnyGs(i_raster:FLARGrayscaleRaster)
		{
			this._gsr=i_raster;
		}
		public function createHistogram_2(i_skip:int,o_histogram:FLARHistogram):void
		{
			var s:FLARIntSize = this._gsr.getSize();
			this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
		}
		public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:FLARHistogram):void
		{
			var hist:Vector.<Vector.<Number>>=this._gsr.getBitmapData().histogram(new Rectangle(i_l, i_t, i_w, i_h));
			o_histogram.reset();
			var data_ptr:Vector.<int> = o_histogram.data;
			var src_ptr:Vector.<Number> = hist[2];
			for (var i:int = 0; i < 256; i++) {
				data_ptr[i] = (int)(src_ptr[i]);
			}
			o_histogram.total_of_data=i_w*i_h;
			return;
		}	
	}
}
