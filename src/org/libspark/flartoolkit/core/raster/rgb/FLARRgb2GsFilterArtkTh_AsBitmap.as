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
package org.libspark.flartoolkit.core.raster.rgb
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.nyatla.as3utils.NyAS3Utils;
	
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.IFLARRgb2GsFilterArtkTh;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterArtkTh_AsBitmap implements IFLARRgb2GsFilterArtkTh
	{
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0,0,0, 0, 0,
			0,0,0, 0, 0,
			1/3,1/3,1/3, 0,
			0, 0, 0, 1, 0
		]);
		
		private var _ref_raster:FLARRgbRaster;
		
		public function FLARRgb2GsFilterArtkTh_AsBitmap(i_ref_raster:FLARRgbRaster)
		{
			NyAS3Utils.assert(i_ref_raster.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData));
			this._ref_raster = i_ref_raster;
		}
		
		private var _dest:Point = new Point(0,0);
		private var _src:Rectangle = new Rectangle();
		private var _tmp:BitmapData;
		
		public function doFilter(i_th:int, i_gsraster:IFLARGrayscaleRaster):void
		{
			var s:FLARIntSize = this._ref_raster.getSize();
			this.doFilter_2(0, 0, s.w, s.h, i_th, i_gsraster);
			return;
		}
		
		public function doFilter_2(i_l:int,i_t:int,i_w:int,i_h:int,i_th:int,i_gsraster:IFLARGrayscaleRaster):void
		{
			NyAS3Utils.assert (i_gsraster.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData));			
			var out_buf:BitmapData = (BitmapData)(i_gsraster.getBuffer());
			var in_buf:BitmapData = this._ref_raster.getBitmapData();
			this._src.left  =i_l;
			this._src.top   =i_t;
			this._src.width =i_w;
			this._src.height = i_h;
			this._dest.x = i_l;
			this._dest.y = i_t;
			if (!_tmp) {
				_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
			} else if (in_buf.width != _tmp.width || in_buf.height != _tmp.height) {
				_tmp.dispose();
				_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
			}
			_tmp.applyFilter(in_buf,this._src,this._dest, MONO_FILTER);
			out_buf.fillRect(out_buf.rect, 0x0);
			out_buf.threshold(_tmp,this._src,this._dest, '<=', i_th, 0xff0000ff, 0xff);
		}
	}
}