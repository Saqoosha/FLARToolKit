/* 
 * PROJECT: NyARToolkit(Extension)
 * -------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2012 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.rasterdriver 
{

	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.INyARRgbPixelDriver;
	import jp.nyatla.nyartoolkit.as3.core.raster.INyARRaster;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.INyARRgbRaster;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	public class NyARPerspectiveCopyFactory
	{
		/**
		 * 指定したIN/OUTに最適な{@link INyARPerspectiveReaader}を生成します。
		 * <p>出力ラスタについて
		 * 基本的には全ての{@link NyARBufferType#INT1D_X8R8G8B8_32}形式のバッファを持つラスタを使用してください。
		 * 他の形式でも動作しますが、低速な場合があります。
		 * </p>
		 * <p>高速化について - 
		 * 出力ラスタ形式が、{@link NyARBufferType#INT1D_X8R8G8B8_32}の物については、単体サンプリングモードの時のみ、さらに高速に動作します。
		 * 他の形式のラスタでは、以上のものよりも低速転送で対応します。
		 * @param i_in_raster_type
		 * 入力ラスタの形式です。
		 * @param i_out_raster_type
		 * 出力ラスタの形式です。
		 * @return
		 */
		public static function createDriver(i_raster:INyARRgbRaster):INyARPerspectiveCopy
		{
			//新しいモードに対応したら書いてね。
			switch(i_raster.getBufferType()){
			default:
				return new PerspectiveCopy_ANYRgb(i_raster);
			}
		}
	}
}
//
//ラスタドライバ
//

import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;



/**
 * RGBインタフェイスを持つラスタをソースにしたフィルタ
 */
class PerspectiveCopy_ANYRgb extends NyARPerspectiveCopy_Base
{
	protected var _ref_raster:INyARRgbRaster;
	private var __pickFromRaster_rgb_tmp:Vector.<int> = new Vector.<int>(3);
	public function PerspectiveCopy_ANYRgb(i_ref_raster:INyARRaster)
	{
		this._ref_raster=INyARRgbRaster(i_ref_raster);
	}
	protected override function onePixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,o_out:INyARRaster):Boolean
	{
		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp;
		var in_w:int=this._ref_raster.getWidth();
		var in_h:int=this._ref_raster.getHeight();

		//ピクセルリーダーを取得
		var cp0:Number=cpara[0];
		var cp3:Number=cpara[3];
		var cp6:Number=cpara[6];
		var cp1:Number=cpara[1];
		var cp4:Number=cpara[4];
		var cp7:Number=cpara[7];
		
		var out_w:int=o_out.getWidth();
		var out_h:int=o_out.getHeight();
		var cp7_cy_1:Number  =cp7*pk_t+1.0+cp6*pk_l;
		var cp1_cy_cp2:Number=cp1*pk_t+cpara[2]+cp0*pk_l;
		var cp4_cy_cp5:Number=cp4*pk_t+cpara[5]+cp3*pk_l;
		
		var i_in_reader:INyARRgbPixelDriver = this._ref_raster.getRgbPixelDriver();
		var iy:int, ix:int;
		var cp7_cy_1_cp6_cx:Number, cp1_cy_cp2_cp0_cx:Number, cp4_cy_cp5_cp3_cx:Number;
		var d:Number;
		var x:int,y:int;
		switch(o_out.getBufferType())
		{
		case NyARBufferType.INT1D_X8R8G8B8_32:
			var pat_data:Vector.<Number>=Vector.<Number>(o_out.getBuffer());
			var p:int=0;
			for(iy=out_h-1;iy>=0;iy--){
				//解像度分の点を取る。
				cp7_cy_1_cp6_cx=cp7_cy_1;
				cp1_cy_cp2_cp0_cx=cp1_cy_cp2;
				cp4_cy_cp5_cp3_cx=cp4_cy_cp5;
				
				for(ix=out_w-1;ix>=0;ix--){
					//1ピクセルを作成
					d=1/(cp7_cy_1_cp6_cx);
					x=int((cp1_cy_cp2_cp0_cx)*d);
					y=int((cp4_cy_cp5_cp3_cx)*d);
					if(x<0){x=0;}else if(x>=in_w){x=in_w-1;}
					if(y<0){y=0;}else if(y>=in_h){y=in_h-1;}
							
					i_in_reader.getPixel(x, y, rgb_tmp);
					cp7_cy_1_cp6_cx+=cp6;
					cp1_cy_cp2_cp0_cx+=cp0;
					cp4_cy_cp5_cp3_cx+=cp3;

					pat_data[p]=(rgb_tmp[0]<<16)|(rgb_tmp[1]<<8)|((rgb_tmp[2]&0xff));
					p++;
				}
				cp7_cy_1+=cp7;
				cp1_cy_cp2+=cp1;
				cp4_cy_cp5+=cp4;
			}
			return true;
		default:
			//ANY to RGBx
			if(o_out is INyARRgbRaster){
				var out_reader:INyARRgbPixelDriver=(INyARRgbRaster(o_out)).getRgbPixelDriver();	
				for(iy=0;iy<out_h;iy++){
					//解像度分の点を取る。
					cp7_cy_1_cp6_cx  =cp7_cy_1;
					cp1_cy_cp2_cp0_cx=cp1_cy_cp2;
					cp4_cy_cp5_cp3_cx=cp4_cy_cp5;
					for(ix=0;ix<out_w;ix++){
						//1ピクセルを作成
						d=1/(cp7_cy_1_cp6_cx);
						x=(int)((cp1_cy_cp2_cp0_cx)*d);
						y=(int)((cp4_cy_cp5_cp3_cx)*d);
						if(x<0){x=0;}else if(x>=in_w){x=in_w-1;}
						if(y<0){y=0;}else if(y>=in_h){y=in_h-1;}
								
						i_in_reader.getPixel(x, y, rgb_tmp);
						cp7_cy_1_cp6_cx+=cp6;
						cp1_cy_cp2_cp0_cx+=cp0;
						cp4_cy_cp5_cp3_cx+=cp3;
		
						out_reader.setPixel_2(ix,iy,rgb_tmp);
					}
					cp7_cy_1+=cp7;
					cp1_cy_cp2+=cp1;
					cp4_cy_cp5+=cp4;
				}
				return true;
			}
			break;
		}
		return false;
	}
	protected override function multiPixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,i_resolution:int,o_out:INyARRaster):Boolean
	{
		var res_pix:int=i_resolution*i_resolution;

		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp;
		var in_w:int=this._ref_raster.getWidth();
		var in_h:int=this._ref_raster.getHeight();
		var i_in_reader:INyARRgbPixelDriver=this._ref_raster.getRgbPixelDriver();

		//ピクセルリーダーを取得
		var cp0:Number=cpara[0];
		var cp3:Number=cpara[3];
		var cp6:Number=cpara[6];
		var cp1:Number=cpara[1];
		var cp4:Number=cpara[4];
		var cp7:Number=cpara[7];
		var cp2:Number=cpara[2];
		var cp5:Number=cpara[5];
		
		var out_w:int=o_out.getWidth();
		var out_h:int=o_out.getHeight();
		switch(o_out.getBufferType())
		{
		case NyARBufferType.INT1D_X8R8G8B8_32:
			var pat_data:Vector.<int>=Vector.<int>(o_out.getBuffer());
			var p:int = (out_w * out_h - 1);
			var r:int, g:int, b:int;
			var ix:int, iy:int, cx:int, cy:int;
			var cp7_cy_1_cp6_cx_b:Number, cp1_cy_cp2_cp0_cx_b:Number, cp4_cy_cp5_cp3_cx_b:Number;
			var i2y:int, i2x:int;
			var cp7_cy_1_cp6_cx:Number, cp1_cy_cp2_cp0_cx:Number, cp4_cy_cp5_cp3_cx:Number;
			var d:Number;
			var x:int, y:int;
			for(iy=out_h-1;iy>=0;iy--){
				//解像度分の点を取る。
				for(ix=out_w-1;ix>=0;ix--){
					r=g=b=0;
					cy=pk_t+iy*i_resolution;
					cx=pk_l+ix*i_resolution;
					cp7_cy_1_cp6_cx_b  =cp7*cy+1.0+cp6*cx;
					cp1_cy_cp2_cp0_cx_b=cp1*cy+cp2+cp0*cx;
					cp4_cy_cp5_cp3_cx_b=cp4*cy+cp5+cp3*cx;
					for(i2y=i_resolution-1;i2y>=0;i2y--){
						cp7_cy_1_cp6_cx  =cp7_cy_1_cp6_cx_b;
						cp1_cy_cp2_cp0_cx=cp1_cy_cp2_cp0_cx_b;
						cp4_cy_cp5_cp3_cx=cp4_cy_cp5_cp3_cx_b;
						for(i2x=i_resolution-1;i2x>=0;i2x--){
							//1ピクセルを作成
							d=1/(cp7_cy_1_cp6_cx);
							x=(int)((cp1_cy_cp2_cp0_cx)*d);
							y=(int)((cp4_cy_cp5_cp3_cx)*d);
							if(x<0){x=0;}else if(x>=in_w){x=in_w-1;}
							if(y<0){y=0;}else if(y>=in_h){y=in_h-1;}
							
							i_in_reader.getPixel(x, y, rgb_tmp);
							r+=rgb_tmp[0];
							g+=rgb_tmp[1];
							b+=rgb_tmp[2];
							cp7_cy_1_cp6_cx+=cp6;
							cp1_cy_cp2_cp0_cx+=cp0;
							cp4_cy_cp5_cp3_cx+=cp3;
						}
						cp7_cy_1_cp6_cx_b+=cp7;
						cp1_cy_cp2_cp0_cx_b+=cp1;
						cp4_cy_cp5_cp3_cx_b+=cp4;
					}
					r/=res_pix;
					g/=res_pix;
					b/=res_pix;
					pat_data[p]=((r&0xff)<<16)|((g&0xff)<<8)|((b&0xff));
					p--;
				}
			}
			return true;
		default:
			//ANY to RGBx
			if(o_out is INyARRgbRaster){
				var out_reader:INyARRgbPixelDriver=(INyARRgbRaster(o_out)).getRgbPixelDriver();
				for(iy=out_h-1;iy>=0;iy--){
					//解像度分の点を取る。
					for(ix=out_w-1;ix>=0;ix--){
						r=g=b=0;
						cy=pk_t+iy*i_resolution;
						cx=pk_l+ix*i_resolution;
						cp7_cy_1_cp6_cx_b  =cp7*cy+1.0+cp6*cx;
						cp1_cy_cp2_cp0_cx_b=cp1*cy+cp2+cp0*cx;
						cp4_cy_cp5_cp3_cx_b=cp4*cy+cp5+cp3*cx;
						for(i2y=i_resolution-1;i2y>=0;i2y--){
							cp7_cy_1_cp6_cx=cp7_cy_1_cp6_cx_b;
							cp1_cy_cp2_cp0_cx=cp1_cy_cp2_cp0_cx_b;
							cp4_cy_cp5_cp3_cx=cp4_cy_cp5_cp3_cx_b;
							for(i2x=i_resolution-1;i2x>=0;i2x--){
								//1ピクセルを作成
								d=1/(cp7_cy_1_cp6_cx);
								x=(int)((cp1_cy_cp2_cp0_cx)*d);
								y=(int)((cp4_cy_cp5_cp3_cx)*d);
								if(x<0){x=0;}else if(x>=in_w){x=in_w-1;}
								if(y<0){y=0;}else if(y>=in_h){y=in_h-1;}
								
								i_in_reader.getPixel(x, y, rgb_tmp);
								r+=rgb_tmp[0];
								g+=rgb_tmp[1];
								b+=rgb_tmp[2];
								cp7_cy_1_cp6_cx+=cp6;
								cp1_cy_cp2_cp0_cx+=cp0;
								cp4_cy_cp5_cp3_cx+=cp3;
							}
							cp7_cy_1_cp6_cx_b+=cp7;
							cp1_cy_cp2_cp0_cx_b+=cp1;
							cp4_cy_cp5_cp3_cx_b+=cp4;
						}
						out_reader.setPixel(ix,iy,r/res_pix,g/res_pix,b/res_pix);
					}
				}
				return true;
			}
			break;
		}
		return false;
	}

}



