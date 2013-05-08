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
package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;

	/**
	 * ->
	 * FLARReality用のエッジ検出フィルタ。
	 * Roberts勾配の2乗値16倍に最大値制限をかけ、反転した値です。
	 * 右端と左端の1ピクセルは、常に0が入ります。
	 * X=|-1, 0|  Y=|0,-1|
	 *   | 0, 1|    |1, 0|
	 * V=sqrt(X^2+Y+2)/2
	 */
	public class FLARNegativeSqRoberts extends NegativeSqRoberts
	{
		private var _do_filter_impl:IdoFilterImpl; 
		public function FLARNegativeSqRoberts()
		{
			super(FLARBufferType.OBJECT_AS3_BitmapData);
		}
		public override function doFilter(i_input:IFLARRaster,i_output:IFLARRaster):void
		{
			this._do_filter_impl.doFilter(i_input,i_output,i_input.getSize());
		}
		protected override function initInstance(i_raster_type:int):void
		{
			switch (i_raster_type) {
			case FLARBufferType.OBJECT_AS3_BitmapData:
				this._do_filter_impl=new IdoFilterImpl_BitmapData();
				break;
			default:
				throw new FLARException();
			}			
		}		
	}
}

import flash.display.BitmapData;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.types.*;
class IdoFilterImpl
{
	public function doFilter(i_input:IFLARRaster, i_output:IFLARRaster, i_size:FLARIntSize):void
	{
		
	}
	protected static const SH:int=4;

}
class IdoFilterImpl_BitmapData extends IdoFilterImpl
{
	public override function doFilter(i_input:IFLARRaster,i_output:IFLARRaster,i_size:FLARIntSize):void
	{
		//assert (i_input.isEqualBufferType(FLARBufferType.INT1D_GRAY_8));
		//assert (i_output.isEqualBufferType(FLARBufferType.INT1D_GRAY_8));
		var in_ptr:BitmapData =BitmapData(i_input.getBuffer());
		var out_ptr:BitmapData=BitmapData(i_output.getBuffer());
		var width:int=i_size.w;
		var ix:int=0;
		var iy:int = 0;
		var fx:int,fy:int;
		var mod_p:int = (width - 2) - (width - 2) % 4;
		var x:int, y:int;
		for (y = i_size.h - 2; y >= 0; y--) {
			//1Lineづつ取得
			var p00:int = in_ptr.getPixel(ix, iy);
			var p10:int = in_ptr.getPixel(ix, iy + 1);
			ix++;
			var p01:int,p11:int;
			x=width-2;
			for(;x>=mod_p;x--){
				p01 = in_ptr.getPixel(ix, iy);
				p11 = in_ptr.getPixel(ix, iy + 1);
				fx=p11-p00;fy=p10-p01;
				fx=(fx*fx+fy*fy)>>SH;out_ptr.setPixel(ix-1,iy,(fx>255?0:255-fx));
				ix++;
				p00=p01;
				p10=p11;
			}
			for (; x >= 0; x -= 4) {
				p01 = in_ptr.getPixel(ix, iy);
				p11 = in_ptr.getPixel(ix, iy + 1);
				fx=p11-p00;fy=p10-p01;
				fx=(fx*fx+fy*fy)>>SH;out_ptr.setPixel(ix-1,iy,(fx>255?0:255-fx));
				ix++;
				p00=p01;
				p10 = p11;

				p01 = in_ptr.getPixel(ix, iy);
				p11 = in_ptr.getPixel(ix, iy + 1);
				fx=p11-p00;fy=p10-p01;
				fx=(fx*fx+fy*fy)>>SH;out_ptr.setPixel(ix-1,iy,(fx>255?0:255-fx));
				ix++;
				p00=p01;
				p10 = p11;

				p01 = in_ptr.getPixel(ix, iy);
				p11 = in_ptr.getPixel(ix, iy + 1);
				fx=p11-p00;fy=p10-p01;
				fx=(fx*fx+fy*fy)>>SH;out_ptr.setPixel(ix-1,iy,(fx>255?0:255-fx));
				ix++;
				p00=p01;
				p10 = p11;

				p01 = in_ptr.getPixel(ix, iy);
				p11 = in_ptr.getPixel(ix, iy + 1);
				fx=p11-p00;fy=p10-p01;
				fx=(fx*fx+fy*fy)>>SH;out_ptr.setPixel(ix-1,iy,(fx>255?0:255-fx));
				ix++;
				p00=p01;
				p10 = p11;

			}
			out_ptr.setPixel(ix-1, iy,0xff);
			ix = 0;
			iy++;
		}
		for(x=width-1;x>=0;x--){
			out_ptr.setPixel(x, iy,0xff);
		}

		return;
	}
}