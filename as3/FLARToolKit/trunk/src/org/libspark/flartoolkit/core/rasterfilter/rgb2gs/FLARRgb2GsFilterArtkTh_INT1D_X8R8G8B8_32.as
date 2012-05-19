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
	
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterArtkTh_INT1D_X8R8G8B8_32 extends FLARRgb2GsFilterArtkTh_Base
	{
		public function FLARRgb2GsFilterArtkTh_INT1D_X8R8G8B8_32(i_raster:IFLARRgbRaster)
		{
			NyAS3Utils.assert(i_raster.isEqualBufferType(FLARBufferType.INT1D_X8R8G8B8_32));
			this._raster=i_raster;
		}
		public override function doFilter_2(i_l:int,i_t:int,i_w:int,i_h:int,i_th:int,i_gsraster:IFLARGrayscaleRaster):void
		{
			NyAS3Utils.assert(i_gsraster.isEqualBufferType(FLARBufferType.INT1D_BIN_8));
			var input:Vector.<int> =Vector.<int>(this._raster.getBuffer());
			var output:Vector.<int>=Vector.<int>(i_gsraster.getBuffer());
			var th:int=i_th*3;
			
			var s:FLARIntSize = this._raster.getSize();
			var skip_src:int = (s.w-i_w);
			var skip_dst:int = skip_src;
			var pix_count:int = i_w;
			var pix_mod_part:int = pix_count-(pix_count%8);
			//左上から1行づつ走査していく
			var pt_dst:int=(i_t*s.w+i_l);
			var pt_src:int=pt_dst;
			for (var y:int= i_h-1; y >=0 ; y-=1){
				var x:int,v:int;
				for (x = pix_count-1; x >=pix_mod_part; x--){
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
				}
				for (;x>=0;x-=8){
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
					v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v& 0xff))<=th?0:1;
				}
				//スキップ
				pt_src+=skip_src;
				pt_dst+=skip_dst;
			}
			return;	
		}
	}
}