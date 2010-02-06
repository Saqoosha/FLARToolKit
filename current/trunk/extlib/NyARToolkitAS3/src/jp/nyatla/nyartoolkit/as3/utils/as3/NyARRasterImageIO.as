/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.utils.as3 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.as3utils.*;
	import flash.display.BitmapData;
	public class NyARRasterImageIO
	{
		/**
		 * i_inの内容を、このイメージにコピーします。
		 * @param i_in
		 * @throws NyARException
		 */
		public static function copy(i_in:INyARRgbRaster,o_out:BitmapData):void
		{
			NyAS3Utils.assert(i_in.getSize().isEqualSize_int(o_out.getWidth(), o_out.getHeight()));
			
			//thisへ転写
			reader:INyARRgbPixelReader=i_in.getRgbPixelReader();
			var rgb:Vector.<int>=new Vector.<int>(3);

			for(var y:int=o_out.getHeight()-1;y>=0;y--){
				for(var x:int=o_out.getWidth()-1;x>=0;x--){
					reader.getPixel(x,y,rgb);
					o_out.setPixel(x,y,(rgb[0]<<16)|(rgb[1]<<8)|rgb[2]);
				}
			}
			return;
		}
		public static function copy(i_in:BitmapData, o_out:INyARRgbRaster):void
		{
			NyAS3Utils.assert(o_out.getSize().isEqualSize_int(i_in.getWidth(), i_in.getHeight()));
			
			//thisへ転写
			var reader:INyARRgbPixelReader=o_out.getRgbPixelReader();
			var rgb:Vector.<int> =new Vector.<int>(3);
			for(var y:int=i_in.getHeight()-1;y>=0;y--){
				for(var x:int=i_in.getWidth()-1;x>=0;x--){
					var pix:int=i_in.getPixel(x, y);
					rgb[0]=(pix>>16)&0xff;
					rgb[1]=(pix>>8)&0xff;
					rgb[2]=(pix)&0xff;
					reader.setPixel(x,y,rgb);
				}
			}
			return;
		}		
	}

}