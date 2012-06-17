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
package org.libspark.flartoolkit.core.rasterfilter.rgb2gs
{
	import jp.nyatla.as3utils.NyAS3Utils;
	
	import org.libspark.flartoolkit.core.pixeldriver.IFLARRgbPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterArtkTh_Any extends FLARRgb2GsFilterArtkTh_Base
	{
		public function FLARRgb2GsFilterArtkTh_Any(i_raster:IFLARRgbRaster)
		{
			this._raster=i_raster;
		}
		private var __rgb:Vector.<int> = new Vector.<int>(3);
		public override function doFilter_2(i_l:int,i_t:int,i_w:int,i_h:int,i_th:int,i_gsraster:IFLARGrayscaleRaster):void
		{
			NyAS3Utils.assert(i_gsraster.isEqualBufferType(FLARBufferType.INT1D_BIN_8));
			var input:IFLARRgbPixelDriver = this._raster.getRgbPixelDriver();
			var output:Vector.<int> = Vector.<int>(i_gsraster.getBuffer());
			var th:int=i_th*3;
			var s:FLARIntSize = i_gsraster.getSize();
			var skip_dst:int=(s.w-i_w);
			//左上から1行づつ走査していく
			var pt_dst:int=(i_t*s.w+i_l);
			var rgb:Vector.<int>=this.__rgb;
			for (var y:int = 0; y<i_h ; y++){
				var x:int;
				for (x =0; x<i_w; x++){
					input.getPixel(x+i_l,y+i_t,rgb);
					output[pt_dst++]=(rgb[0]+rgb[1]+rgb[2])<=th?0:1;
				}
				//スキップ
				pt_dst+=skip_dst;
			}
			return;	
		}
	}
}