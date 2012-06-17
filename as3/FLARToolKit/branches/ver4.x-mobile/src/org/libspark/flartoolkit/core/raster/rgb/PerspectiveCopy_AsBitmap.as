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
package org.libspark.flartoolkit.core.raster.rgb
{
	import flash.display.BitmapData;
	
	import jp.nyatla.as3utils.NyAS3Utils;
	
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.pixeldriver.IFLARRgbPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.rasterdriver.FLARPerspectiveCopy_Base;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	
	internal class PerspectiveCopy_AsBitmap extends FLARPerspectiveCopy_Base
	{
		private var _ref_raster:FLARRgbRaster;
		public function PerspectiveCopy_AsBitmap(i_ref_raster:FLARRgbRaster)
		{
			NyAS3Utils.assert(i_ref_raster.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData));
			this._ref_raster = i_ref_raster;
		}
		protected override function onePixel(pk_l:int,pk_t:int,cpara:Vector.<Number>, o_out:IFLARRaster):Boolean
		{
			var in_bmp:BitmapData = this._ref_raster.getBitmapData();
			var in_w:int = this._ref_raster.getWidth();
			var in_h:int = this._ref_raster.getHeight();
			
			//ピクセルリーダーを取得
			var cp0:Number = cpara[0];
			var cp3:Number = cpara[3];
			var cp6:Number = cpara[6];
			var cp1:Number = cpara[1];
			var cp4:Number = cpara[4];
			var cp7:Number = cpara[7];
			
			var out_w:int = o_out.getWidth();
			var out_h:int = o_out.getHeight();
			var cp7_cy_1:Number = cp7 * pk_t + 1.0 + cp6 * pk_l;
			var cp1_cy_cp2:Number = cp1 * pk_t + cpara[2] + cp0 * pk_l;
			var cp4_cy_cp5:Number = cp4 * pk_t + cpara[5] + cp3 * pk_l;
			var r:int, g:int, b:int, p:int;
			var x:int, y:int;
			var ix:int, iy:int;
			var d:Number;
			switch (o_out.getBufferType())
			{
				case FLARBufferType.INT1D_X8R8G8B8_32:
					var pat_data:Vector.<int> = Vector.<int>(o_out.getBuffer());
					p = 0;
					for (iy= 0; iy < out_h; iy++)
					{
						//解像度分の点を取る。
						var cp7_cy_1_cp6_cx:Number = cp7_cy_1;
						var cp1_cy_cp2_cp0_cx:Number = cp1_cy_cp2;
						var cp4_cy_cp5_cp3_cx:Number = cp4_cy_cp5;
						
						for (ix = 0; ix < out_w; ix++)
						{
							//1ピクセルを作成
							d = 1 / (cp7_cy_1_cp6_cx);
							x = (int)((cp1_cy_cp2_cp0_cx) * d);
							y = (int)((cp4_cy_cp5_cp3_cx) * d);
							if (x < 0) { x = 0; } else if (x >= in_w) { x = in_w - 1; }
							if (y < 0) { y = 0; } else if (y >= in_h) { y = in_h - 1; }
							
							//
							pat_data[p] = in_bmp.getPixel(x, y);
							//r = (px >> 16) & 0xff;// R
							//g = (px >> 8) & 0xff; // G
							//b = (px) & 0xff;    // B
							cp7_cy_1_cp6_cx += cp6;
							cp1_cy_cp2_cp0_cx += cp0;
							cp4_cy_cp5_cp3_cx += cp3;
							//pat_data[p] = (r << 16) | (g << 8) | ((b & 0xff));
							//pat_data[p] = px;
							p++;
						}
						cp7_cy_1 += cp7;
						cp1_cy_cp2 += cp1;
						cp4_cy_cp5 += cp4;
					}
					return true;
				case FLARBufferType.OBJECT_AS3_BitmapData:
					var bmr:FLARRgbRaster = FLARRgbRaster(o_out);
					var bm:BitmapData = bmr.getBitmapData();
					p = 0;
					for (iy = 0; iy < out_h; iy++)
					{
						//解像度分の点を取る。
						cp7_cy_1_cp6_cx = cp7_cy_1;
						cp1_cy_cp2_cp0_cx = cp1_cy_cp2;
						cp4_cy_cp5_cp3_cx = cp4_cy_cp5;
						
						for (ix = 0; ix < out_w; ix++)
						{
							//1ピクセルを作成
							d = 1 / (cp7_cy_1_cp6_cx);
							x = (int)((cp1_cy_cp2_cp0_cx) * d);
							y = (int)((cp4_cy_cp5_cp3_cx) * d);
							if (x < 0) { x = 0; } else if (x >= in_w) { x = in_w - 1; }
							if (y < 0) { y = 0; } else if (y >= in_h) { y = in_h - 1; }
							bm.setPixel(ix,iy,in_bmp.getPixel(x,y));
							cp7_cy_1_cp6_cx += cp6;
							cp1_cy_cp2_cp0_cx += cp0;
							cp4_cy_cp5_cp3_cx += cp3;
							p++;
						}
						cp7_cy_1 += cp7;
						cp1_cy_cp2 += cp1;
						cp4_cy_cp5 += cp4;
					}
					return true;	
				default:
					if (o_out is IFLARRgbRaster)
					{
						//ANY to RGBx
						var out_reader:IFLARRgbPixelDriver = (IFLARRgbRaster(o_out)).getRgbPixelDriver();
						for (iy = 0; iy < out_h; iy++)
						{
							//解像度分の点を取る。
							cp7_cy_1_cp6_cx = cp7_cy_1;
							cp1_cy_cp2_cp0_cx = cp1_cy_cp2;
							cp4_cy_cp5_cp3_cx = cp4_cy_cp5;
							
							for (ix = 0; ix < out_w; ix++)
							{
								//1ピクセルを作成
								d = 1 / (cp7_cy_1_cp6_cx);
								x = int((cp1_cy_cp2_cp0_cx) * d);
								y = int((cp4_cy_cp5_cp3_cx) * d);
								if (x < 0) { x = 0; } else if (x >= in_w) { x = in_w - 1; }
								if (y < 0) { y = 0; } else if (y >= in_h) { y = in_h - 1; }
								
								var px:int = in_bmp.getPixel(x, y);
								r = (px >> 16) & 0xff;// R
								g = (px >> 8) & 0xff; // G
								b = (px) & 0xff;    // B
								cp7_cy_1_cp6_cx += cp6;
								cp1_cy_cp2_cp0_cx += cp0;
								cp4_cy_cp5_cp3_cx += cp3;
								out_reader.setPixel(ix, iy, r, g, b);
							}
							cp7_cy_1 += cp7;
							cp1_cy_cp2 += cp1;
							cp4_cy_cp5 += cp4;
						}
						return true;
					}
					break;
			}
			return false;
		}
		protected override function multiPixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,i_resolution:int,o_out:IFLARRaster):Boolean
		{
			var in_bmp:BitmapData = this._ref_raster.getBitmapData();
			var in_w:int = this._ref_raster.getWidth();
			var in_h:int = this._ref_raster.getHeight();
			var res_pix:int = i_resolution * i_resolution;
			var ix:int, iy:int;
			
			//ピクセルリーダーを取得
			var cp0:Number = cpara[0];
			var cp3:Number = cpara[3];
			var cp6:Number = cpara[6];
			var cp1:Number = cpara[1];
			var cp4:Number = cpara[4];
			var cp7:Number = cpara[7];
			var cp2:Number = cpara[2];
			var cp5:Number = cpara[5];
			
			var out_w:int = o_out.getWidth();
			var out_h:int = o_out.getHeight();
			var r:int, g:int, b:int;
			var cx:int, cy:int;
			var x:int, y:int;
			var i2x:int, i2y:int;
			var cp7_cy_1_cp6_cx_b:Number, cp1_cy_cp2_cp0_cx_b:Number, cp4_cy_cp5_cp3_cx_b:Number, cp7_cy_1_cp6_cx:Number, cp1_cy_cp2_cp0_cx:Number, cp4_cy_cp5_cp3_cx:Number;
			if (o_out.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData))
			{
				var bmr:FLARRgbRaster=FLARRgbRaster(o_out);
				var bm:BitmapData = bmr.getBitmapData();
				for (iy = out_h - 1; iy >= 0; iy--)
				{
					//解像度分の点を取る。
					for (ix = out_w - 1; ix >= 0; ix--)
					{
						r = g = b = 0;
						cy = pk_t + iy * i_resolution;
						cx = pk_l + ix * i_resolution;
						cp7_cy_1_cp6_cx_b = cp7 * cy + 1.0 + cp6 * cx;
						cp1_cy_cp2_cp0_cx_b = cp1 * cy + cp2 + cp0 * cx;
						cp4_cy_cp5_cp3_cx_b = cp4 * cy + cp5 + cp3 * cx;
						for (i2y = i_resolution - 1; i2y >= 0; i2y--)
						{
							cp7_cy_1_cp6_cx = cp7_cy_1_cp6_cx_b;
							cp1_cy_cp2_cp0_cx = cp1_cy_cp2_cp0_cx_b;
							cp4_cy_cp5_cp3_cx = cp4_cy_cp5_cp3_cx_b;
							for (i2x = i_resolution - 1; i2x >= 0; i2x--)
							{
								//1ピクセルを作成
								var d:Number = 1 / (cp7_cy_1_cp6_cx);
								x= (int)((cp1_cy_cp2_cp0_cx) * d);
								y= (int)((cp4_cy_cp5_cp3_cx) * d);
								if (x < 0) { x = 0; } else if (x >= in_w) { x = in_w - 1; }
								if (y < 0) { y = 0; } else if (y >= in_h) { y = in_h - 1; }
								var px:int = in_bmp.getPixel(x, y);
								r += (px >> 16) & 0xff;// R
								g += (px >> 8) & 0xff; // G
								b += (px) & 0xff;    // B
								cp7_cy_1_cp6_cx += cp6;
								cp1_cy_cp2_cp0_cx += cp0;
								cp4_cy_cp5_cp3_cx += cp3;
							}
							cp7_cy_1_cp6_cx_b += cp7;
							cp1_cy_cp2_cp0_cx_b += cp1;
							cp4_cy_cp5_cp3_cx_b += cp4;
						}
						bm.setPixel(ix,iy,(0x00ff0000 & ((r / res_pix) << 16)) | (0x0000ff00 & ((g / res_pix) << 8)) | (0x0000ff & (b / res_pix)));
					}
				}
				return true;
			}
			else if (o_out is IFLARRgbRaster)
			{
				var out_reader:IFLARRgbPixelDriver = (IFLARRgbRaster(o_out)).getRgbPixelDriver();
				for (iy = out_h - 1; iy >= 0; iy--)
				{
					//解像度分の点を取る。
					for (ix = out_w - 1; ix >= 0; ix--)
					{
						r = g = b = 0;
						cy = pk_t + iy * i_resolution;
						cx = pk_l + ix * i_resolution;
						cp7_cy_1_cp6_cx_b = cp7 * cy + 1.0 + cp6 * cx;
						cp1_cy_cp2_cp0_cx_b= cp1 * cy + cp2 + cp0 * cx;
						cp4_cy_cp5_cp3_cx_b= cp4 * cy + cp5 + cp3 * cx;
						for (i2y = i_resolution - 1; i2y >= 0; i2y--)
						{
							cp7_cy_1_cp6_cx = cp7_cy_1_cp6_cx_b;
							cp1_cy_cp2_cp0_cx = cp1_cy_cp2_cp0_cx_b;
							cp4_cy_cp5_cp3_cx = cp4_cy_cp5_cp3_cx_b;
							for (i2x = i_resolution - 1; i2x >= 0; i2x--)
							{
								//1ピクセルを作成
								d = 1 / (cp7_cy_1_cp6_cx);
								x = (int)((cp1_cy_cp2_cp0_cx) * d);
								y = (int)((cp4_cy_cp5_cp3_cx) * d);
								if (x < 0) { x = 0; } else if (x >= in_w) { x = in_w - 1; }
								if (y < 0) { y = 0; } else if (y >= in_h) { y = in_h - 1; }
								px = in_bmp.getPixel(x, y);
								r += (px >> 16) & 0xff;// R
								g += (px >> 8) & 0xff; // G
								b += (px) & 0xff;    // B
								cp7_cy_1_cp6_cx += cp6;
								cp1_cy_cp2_cp0_cx += cp0;
								cp4_cy_cp5_cp3_cx += cp3;
							}
							cp7_cy_1_cp6_cx_b += cp7;
							cp1_cy_cp2_cp0_cx_b += cp1;
							cp4_cy_cp5_cp3_cx_b += cp4;
						}
						out_reader.setPixel(ix, iy, r / res_pix, g / res_pix, b / res_pix);
					}
				}
				return true;
			}
			else
			{
				throw new FLARException();
			}
		}
	}
}