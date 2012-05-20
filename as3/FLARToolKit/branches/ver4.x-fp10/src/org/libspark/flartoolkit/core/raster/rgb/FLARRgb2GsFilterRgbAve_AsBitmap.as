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
*/
package org.libspark.flartoolkit.core.raster.rgb
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.nyatla.as3utils.NyAS3Utils;
	
	import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.IFLARRgb2GsFilterRgbAve;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterRgbAve_AsBitmap implements IFLARRgb2GsFilterRgbAve
	{
		private var _ref_raster:FLARRgbRaster;
		
		public function FLARRgb2GsFilterRgbAve_AsBitmap(i_ref_raster:FLARRgbRaster)
		{
			NyAS3Utils.assert(i_ref_raster.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData));
			this._ref_raster = i_ref_raster;
		}
		public function convert(i_raster:IFLARGrayscaleRaster):void
		{
			var s:FLARIntSize = this._ref_raster.getSize();
			this.convertRect(0, 0, s.w, s.h, i_raster);
		}
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0, 0, 0, 0,0,
			0,0,0,0,0,
			0.33, 0.34, 0.33,0,0,
			0, 0, 0,0,0
		]);		
		private var _dest:Point = new Point(0,0);
		private var _src:Rectangle = new Rectangle();
		public function convertRect(l:int,t:int,w:int,h:int,o_raster:IFLARGrayscaleRaster):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			var size:FLARIntSize = this._ref_raster.getSize();
			var b:int = t + h;
			switch (o_raster.getBufferType())
			{
				case FLARBufferType.OBJECT_AS3_BitmapData:
					var out_buf:BitmapData = BitmapData(BitmapData(o_raster.getBuffer()));
					var in_buf:BitmapData = BitmapData(this._ref_raster.getBitmapData());
					this._src.left  =l;
					this._src.top   =t;
					this._src.width =w;
					this._src.height = h;
					this._dest.x = l;
					this._dest.y = t;
					out_buf.applyFilter(in_buf,this._src,this._dest, MONO_FILTER);
					break;
				default:
					var out_drv:IFLARGsPixelDriver = o_raster.getGsPixelDriver();
					var r:int = w+l;
					for (var y:int = t; y < b; y++)
					{
						for (var x:int = l; x < r; x++)
						{
							var p:int = bm.getPixel(x, y);
							out_drv.setPixel(x, y, (((p >> 16) & 0xff) + ((p >> 8) & 0xff) + (p & 0xff)) / 3);
						}
					}
					return;
			}
		}
	}
}