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
	import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
	import org.libspark.flartoolkit.core.pixeldriver.IFLARRgbPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgb2GsFilterRgbAve_Any implements IFLARRgb2GsFilterRgbAve
	{
		private var _ref_raster:IFLARRgbRaster;
		public function FLARRgb2GsFilterRgbAve_Any(i_ref_raster:IFLARRgbRaster)
		{
			this._ref_raster=i_ref_raster;
		}
		private var _wk:Vector.<int>=new Vector.<int>(3);
		public function convert(i_raster:IFLARGrayscaleRaster):void
		{
			var s:FLARIntSize = this._ref_raster.getSize();
			this.convertRect(0,0,s.w,s.h,i_raster);
		}	
		public function convertRect(l:int,t:int,w:int,h:int,o_raster:IFLARGrayscaleRaster):void
		{
			var wk:Vector.<int>=this._wk;
			var b:int=t+h;
			var pix_count:int=w;
			switch(o_raster.getBufferType()){
				default:
					var out_drv:IFLARGsPixelDriver = o_raster.getGsPixelDriver();
					var in_drv:IFLARRgbPixelDriver = this._ref_raster.getRgbPixelDriver();
					for (var y:int = t; y < b; y++) {
						for (var x:int = pix_count-1; x >=0; x--){
							in_drv.getPixel(x,y,wk);
							out_drv.setPixel(x,y,(wk[0]+wk[1]+wk[2])/3);
						}
					}
					return;
			}
		}
	}
}