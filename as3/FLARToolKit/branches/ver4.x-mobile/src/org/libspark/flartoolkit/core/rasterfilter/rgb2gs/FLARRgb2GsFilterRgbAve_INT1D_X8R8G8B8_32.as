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
	
	import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterRgbAve_INT1D_X8R8G8B8_32 implements IFLARRgb2GsFilterRgbAve
	{
		private var _ref_raster:IFLARRaster;
		public function FLARRgb2GsFilterRgbAve_INT1D_X8R8G8B8_32(i_ref_raster:IFLARRaster)
		{
			NyAS3Utils.assert(i_ref_raster.isEqualBufferType(FLARBufferType.INT1D_X8R8G8B8_32));
			this._ref_raster=i_ref_raster;
		}
		public function convert(i_raster:IFLARGrayscaleRaster):void
		{
			var s:FLARIntSize=this._ref_raster.getSize();
			this.convertRect(0,0,s.w,s.h,i_raster);
		}
		public function convertRect(l:int,t:int,w:int,h:int,o_raster:IFLARGrayscaleRaster):void
		{
			var size:FLARIntSize=this._ref_raster.getSize();
			var bp:int = (l+t*size.w);
			var b:int=t+h;
			var row_padding_dst:int=(size.w-w);
			var row_padding_src:int=row_padding_dst;
			var pix_count:int=w;
			var pix_mod_part:int=pix_count-(pix_count%8);
			var src_ptr:int=t*size.w+l;
			var in_buf:Vector.<int> = Vector.<int>(this._ref_raster.getBuffer());
			switch(o_raster.getBufferType()){
				case FLARBufferType.INT1D_GRAY_8:
					var v:int;
					var x:int, y:int;
					var out_buf:Vector.<int>=Vector.<int>(o_raster.getBuffer());
					for (y = t; y < b; y++) {
						x=0;
						for (x = pix_count-1; x >=pix_mod_part; x--){
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
						}
						for (;x>=0;x-=8){
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
							v=in_buf[src_ptr++];out_buf[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3;
						}
						bp+=row_padding_dst;
						src_ptr+=row_padding_src;
					}
					return;
				default:
					var out_drv:IFLARGsPixelDriver = o_raster.getGsPixelDriver();
					for (y = t; y < b; y++) {
						for (x = 0; x<pix_count; x++){
							v=in_buf[src_ptr++];
							out_drv.setPixel(x,y,(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))/3);
						}
					}
					return;
			}
		}
	}
}