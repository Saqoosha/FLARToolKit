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

package org.libspark.flartoolkit.alchemy.core.raster.rgb
{
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import org.libspark.flartoolkit.alchemy.IFLxAR;
	import org.libspark.flartoolkit.core.rasterreader.FLARBitmapDataReader;	
	import org.libspark.flartoolkit.core.raster.FLARRaster_BasicClass;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.rasterreader.IFLARBufferReader;
	import org.libspark.flartoolkit.core.rasterreader.IFLARRgbPixelReader;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	import org.libspark.flartoolkit.FLARException;
	import jp.nyatla.nyartoolkit.as3.*;
	
	import flash.display.BitmapData;	

	/**
	 * @author Saqoosha
	 */
	public class FLxARRgbRaster implements IFLxAR
	{
		public var _ny:NyARRgbRaster_XRGB32;
		public function FLxARRgbRaster(i_width:int,i_height:int)
		{
			this._ny = NyARRgbRaster_XRGB32.createInstance(i_width, i_height);
			return;
		}
		public function dispose():void
		{
			//dispose AlchemyMaster class
			this._ny.dispose();
			this._ny = null;
			return;			
		}
		public function setBitmapData(i_bmp:BitmapData):void
		{
			var b:ByteArray = i_bmp.getPixels(new Rectangle(0, 0, i_bmp.width,i_bmp.height));
			b.position = 0;
			this._ny.setByteArray(b);
			b = null;
		}

		public function getRgbPixelReader():IFLARRgbPixelReader {FLARException.notImplement();return null;}
		public function getBufferReader():IFLARBufferReader {FLARException.notImplement(); return null;}
		public function get bitmapData():BitmapData { FLARException.notImplement(); return null;}
	}
}
