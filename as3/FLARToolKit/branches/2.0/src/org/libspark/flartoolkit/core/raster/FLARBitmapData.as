/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package org.libspark.flartoolkit.core.raster {
	
	import flash.display.BitmapData;
	
	
	public class FLARBitmapData implements IFLARRaster {
		
		private var _bmp:BitmapData
		
		public function FLARBitmapData(bmp:BitmapData) {
			this._bmp = bmp;
		}

		public function getPixelTotal(i_x:int, i_y:int):int {
			var c:int = this._bmp.getPixel(i_x, i_y);
			return ((c >> 16) & 0xff) + ((c >> 8) & 0xff) + (c & 0xff);
		}
		
		public function getPixelTotalRowLine(i_row:int, o_line:Array):void {
			var w:int = this._bmp.width;
			while (w--) {
				var c:int = this._bmp.getPixel(w, i_row);
				o_line[w] = ((c >> 16) & 0xff) + ((c >> 8) & 0xff) + (c & 0xff);
			}
		}
		
		public function getWidth():int {
			return this._bmp.width;
		}
		
		public function getHeight():int {
			return this._bmp.height;
		}
		
		public function getPixel(i_x:int, i_y:int, i_rgb:Array):void {
			var c:int = this._bmp.getPixel(i_x, i_y);
			i_rgb[0] = (c >> 16) & 0xff;
			i_rgb[1] = (c >> 8) & 0xff;
			i_rgb[2] = c & 0xff;
		}
		
		public function getPixelSet(i_x:Array, i_y:Array, i_num:int, o_rgb:Array):void {
			for (var i:int = 0; i < i_num; i++) {
				var c:int = this._bmp.getPixel(i_x[i], i_y[i]);
				o_rgb[i*3+0] = (c >> 16) & 0xff;
			    o_rgb[i*3+1] = (c >> 8) & 0xff;
			    o_rgb[i*3+2] = c & 0xff;
			}
		}
		
		public function get bitmapData():BitmapData {
			return this._bmp;
		}
		
		public function clone():FLARBitmapData {
			return new FLARBitmapData(this._bmp.clone());
		}
		
	}
	
}