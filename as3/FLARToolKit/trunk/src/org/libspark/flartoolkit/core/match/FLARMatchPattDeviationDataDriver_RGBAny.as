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
package org.libspark.flartoolkit.core.match
{
	import org.libspark.flartoolkit.core.pixeldriver.IFLARRgbPixelDriver;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARMatchPattDeviationDataDriver_RGBAny implements FLARMatchPattDeviationColorData_IRasterDriver
	{
		private var _ref_raster:IFLARRgbRaster;
		
		public function FLARMatchPattDeviationDataDriver_RGBAny(i_raster:IFLARRgbRaster)
		{
			this._ref_raster=i_raster;
		}
		private var __rgb:Vector.<int>=new Vector.<int>(3);
		public function makeColorData(o_out:Vector.<int>):Number
		{
			var size:FLARIntSize = this._ref_raster.getSize();
			var pixdev:IFLARRgbPixelDriver = this._ref_raster.getRgbPixelDriver();
			var rgb:Vector.<int>=this.__rgb;
			var width:int=size.w;
			//<平均値計算>
			var x:int,y:int;
			var ave:int = 0;//<PV/>		
			for(y=size.h-1;y>=0;y--){
				for(x=width-1;x>=0;x--){
					pixdev.getPixel(x,y,rgb);
					ave += rgb[0]+rgb[1]+rgb[2];
				}
			}
			//<平均値計算>
			var number_of_pix:int=size.w*size.h;
			ave=number_of_pix*255*3-ave;
			ave =255-(ave/ (number_of_pix * 3));//(255-R)-ave を分解するための事前計算
			
			var sum:int = 0,w_sum:int;
			var input_ptr:int=number_of_pix*3-1;
			//<差分値計算>
			for(y=size.h-1;y>=0;y--){
				for(x=width-1;x>=0;x--){
					pixdev.getPixel(x,y,rgb);
					w_sum = (ave - rgb[2]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
					w_sum = (ave - rgb[1]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
					w_sum = (ave - rgb[0]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
				}
			}
			//<差分値計算(FORの1/8展開)/>
			var p:Number=Math.sqrt(Number(sum));
			return p!=0.0?p:0.0000001;
			
		}
	}
}