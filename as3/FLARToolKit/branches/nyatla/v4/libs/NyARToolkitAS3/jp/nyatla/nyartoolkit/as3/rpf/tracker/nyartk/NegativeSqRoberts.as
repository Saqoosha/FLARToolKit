/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	/**
	 * NyARReality用のエッジ検出フィルタ。
	 * Roberts勾配の2乗値16倍に最大値制限をかけ、反転した値です。
	 * 右端と左端の1ピクセルは、常に0が入ります。
	 * X=|-1, 0|  Y=|0,-1|
	 *   | 0, 1|    |1, 0|
	 * V=sqrt(X^2+Y+2)/2
	 */
	public class NegativeSqRoberts
	{
		private var _do_filter_impl:IdoFilterImpl; 
		public function NegativeSqRoberts(i_raster_type:int)
		{
			initInstance(i_raster_type);
		}
		protected function initInstance(i_raster_type:int):void
		{
			switch (i_raster_type) {
			case NyARBufferType.INT1D_GRAY_8:
				this._do_filter_impl=new IdoFilterImpl_GRAY_8();
				break;
			default:
				throw new NyARException();
			}			
		}
		public function doFilter(i_input:INyARRaster,i_output:INyARRaster):void
		{
			this._do_filter_impl.doFilter(i_input,i_output,i_input.getSize());
		}
	}
}

import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
class IdoFilterImpl
{
	public function doFilter(i_input:INyARRaster, i_output:INyARRaster, i_size:NyARIntSize):void
	{
		
	}
	protected static const SH:int=4;

}
class IdoFilterImpl_GRAY_8 extends IdoFilterImpl
{
	public override function doFilter(i_input:INyARRaster,i_output:INyARRaster,i_size:NyARIntSize):void
	{
		//assert (i_input.isEqualBufferType(NyARBufferType.INT1D_GRAY_8));
		//assert (i_output.isEqualBufferType(NyARBufferType.INT1D_GRAY_8));
		var in_ptr:Vector.<int> =Vector.<int>(i_input.getBuffer());
		var out_ptr:Vector.<int>=Vector.<int>(i_output.getBuffer());
		var width:int=i_size.w;
		var idx:int=0;
		var idx2:int=width;
		var fx:int,fy:int;
		var mod_p:int = (width - 2) - (width - 2) % 8;
		var x:int, y:int;
		for(y=i_size.h-2;y>=0;y--){
			var p00:int=in_ptr[idx++];
			var p10:int=in_ptr[idx2++];
			var p01:int,p11:int;
			x=width-2;
			for(;x>=mod_p;x--){
				p01=in_ptr[idx++];p11=in_ptr[idx2++];
				fx=p11-p00;fy=p10-p01;
//					out_ptr[idx-2]=255-(((fx<0?-fx:fx)+(fy<0?-fy:fy))>>1);
				fx=(fx*fx+fy*fy)>>SH;out_ptr[idx-2]=(fx>255?0:255-fx);
				p00=p01;
				p10=p11;
			}
			for(;x>=0;x-=4){
				p01=in_ptr[idx++];p11=in_ptr[idx2++];
				fx=p11-p00;
				fy=p10-p01;
//					out_ptr[idx-2]=255-(((fx<0?-fx:fx)+(fy<0?-fy:fy))>>1);
				fx=(fx*fx+fy*fy)>>SH;out_ptr[idx-2]=(fx>255?0:255-fx);
				p00=p01;p10=p11;

				p01=in_ptr[idx++];p11=in_ptr[idx2++];
				fx=p11-p00;
				fy=p10-p01;
//					out_ptr[idx-2]=255-(((fx<0?-fx:fx)+(fy<0?-fy:fy))>>1);
				fx=(fx*fx+fy*fy)>>SH;out_ptr[idx-2]=(fx>255?0:255-fx);
				p00=p01;p10=p11;
				p01=in_ptr[idx++];p11=in_ptr[idx2++];
				
				fx=p11-p00;
				fy=p10-p01;
//					out_ptr[idx-2]=255-(((fx<0?-fx:fx)+(fy<0?-fy:fy))>>1);
				fx=(fx*fx+fy*fy)>>SH;out_ptr[idx-2]=(fx>255?0:255-fx);
				p00=p01;p10=p11;

				p01=in_ptr[idx++];p11=in_ptr[idx2++];
				fx=p11-p00;
				fy=p10-p01;
//					out_ptr[idx-2]=255-(((fx<0?-fx:fx)+(fy<0?-fy:fy))>>1);
				fx=(fx*fx+fy*fy)>>SH;out_ptr[idx-2]=(fx>255?0:255-fx);
				p00=p01;p10=p11;

			}
			out_ptr[idx-1]=255;
		}
		for(x=width-1;x>=0;x--){
			out_ptr[idx++]=255;
		}
		return;
	}
}