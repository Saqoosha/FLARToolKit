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
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.as3utils.*;
	import flash.display.*;
	import flash.media.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;

    /**
     * bitmapと互換性のあるラスタです。
     */
    public class FLARRgbRaster extends NyARRgbRaster
    {
		public function FLARRgbRaster(...args:Array)
		{
			super(NyAS3Const_Inherited);
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}else {
					override_FLARRgbRaster_BitmapData_1o(BitmapData(args[0]));
				}
				break;
			case 2:
				overload_FLARRgbRaster_BitmapData_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				overload_FLARRgbRaster_BitmapData_4iiib(int(args[0]), int(args[1]),NyARBufferType.OBJECT_AS3_BitmapData,Boolean(args[2]));
				break;
			case 4:
				overload_FLARRgbRaster_BitmapData_4iiib(int(args[0]), int(args[1]),int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new NyARException();
			}			
		}

        /// <summary>
        /// Bitmapを参照するインスタンスを生成する。
        /// </summary>
        /// <param name="i_img">
        /// PixelFormat.Format32bppRgb形式のビットマップである必要がある。
        /// 形式な不明なビットマップからインスタンスを作るときは、一度同じサイズのビットマップを作って、copyFrom関数でコピーします。
        /// </param>
        public function override_FLARRgbRaster_BitmapData_1o(i_img:BitmapData):void
	    {
			super.overload_NyARRgbRaster_4iiib(i_img.width, i_img.height, NyARBufferType.OBJECT_AS3_BitmapData, false);
		    this.wrapBuffer(i_img);
	    }
        public function overload_FLARRgbRaster_BitmapData_4iiib(i_width:int,i_height:int,i_raster_type:int , i_is_alloc:Boolean):void
	    {
			super.overload_NyARRgbRaster_4iiib(i_width, i_height, i_raster_type, i_is_alloc);
	    }
        /**
         * インスタンスを生成します。インスタンスは、PixelFormat.Format32bppRgb形式のビットマップをバッファに持ちます。
         */
        public function overload_FLARRgbRaster_BitmapData_2ii(i_width:int,i_height:int):void
        {
			super.overload_NyARRgbRaster_4iiib(i_width,i_height,NyARBufferType.OBJECT_AS3_BitmapData,true);
        }
        /// <summary>
        /// i_srcからインスタンスにビットマップをコピーします。
        /// </summary>
        /// <param name="i_src"></param>
        public function copyFrom(i_src:BitmapData):void
        {
			this._bm_cache.draw(i_src);
        }
        /**
         * Readerとbufferを初期化する関数です。コンストラクタから呼び出します。
         * 継承クラスでこの関数を拡張することで、対応するバッファタイプの種類を増やせます。
         * @param i_size
         * ラスタのサイズ
         * @param i_raster_type
         * バッファタイプ
         * @param i_is_alloc
         * 外部参照/内部バッファのフラグ
         * @return
         * 初期化が成功すると、trueです。
         * @ 
         */
        protected override function initInstance(i_size:NyARIntSize,i_raster_type:int,i_is_alloc:Boolean):Boolean
        {
            //バッファの構築
            switch (i_raster_type)
            {
                case NyARBufferType.OBJECT_AS3_BitmapData:
                    this._rgb_pixel_driver = new NyARRgbPixelDriver_AsBitmap();
                    if (i_is_alloc)
                    {
                        this._buf = new BitmapData(i_size.w, i_size.h,false);
                        this._rgb_pixel_driver.switchRaster(this);
                    }
                    else
                    {
                        this._buf = null;
                    }
                    this._is_attached_buffer = i_is_alloc;
                    break;
                default:
					throw new NyARException();
            }
            //readerの構築
            return true;
        }
        /**
         * この関数は、ラスタに外部参照バッファをセットします。
         * 外部参照バッファの時にだけ使えます。
         */
        public override function wrapBuffer(i_ref_buf:Object):void
        {
            NyAS3Utils.assert(!this._is_attached_buffer);//バッファがアタッチされていたら機能しない。
            this._buf = i_ref_buf;
            //ピクセルリーダーの参照バッファを切り替える。
            this._rgb_pixel_driver.switchRaster(this);
        }

        public override function createInterface(iIid:Class):Object
        {
            if (iIid == INyARPerspectiveCopy)
            {
                return this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData) ? new PerspectiveCopy_AsBitmap(this) : NyARPerspectiveCopyFactory.createDriver(this);
            }
            if (iIid == NyARMatchPattDeviationColorData_IRasterDriver)
            {
                return NyARMatchPattDeviationColorData_RasterDriverFactory.createDriver(this);
            }
            if (iIid == INyARRgb2GsFilter)
            {
                return this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData) ? new NyARRgb2GsFilterRgbAve_AsBitmap(this) : NyARRgb2GsFilterFactory.createRgbAveDriver(this);
            }
            else if (iIid == INyARRgb2GsFilterRgbAve)
            {
                return this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData) ? new NyARRgb2GsFilterRgbAve_AsBitmap(this) : NyARRgb2GsFilterFactory.createRgbAveDriver(this);
            }

            if (iIid == INyARRgb2GsFilterArtkTh)
            {
                return this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData) ? new NyARRgb2GsFilterArtkTh_AsBitmap(this) : NyARRgb2GsFilterArtkThFactory.createDriver(this);
            }
			if (iIid == FLARRgb2GsFilter) {
                if (this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData)) {
					return new FLARRgb2GsFilter(this);
				}
			}
            throw new NyARException();
        }
        private var _bm_cache:BitmapData;

        public function getBitmapData():BitmapData
        {
            return BitmapData(this._buf);
        }
		public function setVideo(i_video:Video):void
		{
			BitmapData(this._buf).draw(i_video);
		}		
    }
}

	import flash.geom.Rectangle;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.as3utils.*;
	import flash.display.*;
	import flash.media.*;
	import flash.geom.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import flash.filters.ColorMatrixFilter;

    class NyARRgb2GsFilterRgbAve_AsBitmap implements INyARRgb2GsFilterRgbAve
    {
        private var _ref_raster:FLARRgbRaster;
        public function NyARRgb2GsFilterRgbAve_AsBitmap(i_ref_raster:FLARRgbRaster)
        {
            NyAS3Utils.assert(i_ref_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
            this._ref_raster = i_ref_raster;
        }
        public function convert(i_raster:INyARGrayscaleRaster):void
        {
            var s:NyARIntSize = this._ref_raster.getSize();
            this.convertRect(0, 0, s.w, s.h, i_raster);
        }
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0, 0, 0, 0,0,
			0,0,0,0,0,
			0.33, 0.34, 0.33,0,0,
			0, 0, 0,0,0
		]);		
		private var _dest:Point = new Point(0,0);
		private var _src:Rectangle = new Rectangle();
        public function convertRect(l:int,t:int,w:int,h:int,o_raster:INyARGrayscaleRaster):void
        {
            var bm:BitmapData = this._ref_raster.getBitmapData();
            var size:NyARIntSize = this._ref_raster.getSize();
            var b:int = t + h;
            switch (o_raster.getBufferType())
            {
			case NyARBufferType.OBJECT_AS3_BitmapData:
				var out_buf:BitmapData = BitmapData(BitmapData(o_raster.getBuffer()));
				var in_buf:BitmapData = BitmapData(this._ref_raster.getBitmapData());
				this._src.left  =l;
				this._src.top   =t;
				this._src.width =w;
				this._src.height = h;
				this._dest.x = l;
				this._dest.y = t;
				out_buf.applyFilter(in_buf,this._src,this._dest, MONO_FILTER);
				break;
			default:
				var out_drv:INyARGsPixelDriver = o_raster.getGsPixelDriver();
				var r:int = w+l;
				for (var y:int = t; y < b; y++)
				{
					for (var x:int = l; x < r; x++)
					{
						var p:int = bm.getPixel(x, y);
						out_drv.setPixel(x, y, (((p >> 16) & 0xff) + ((p >> 8) & 0xff) + (p & 0xff)) / 3);
					}
				}
				return;
            }
        }
    }


    class NyARRgb2GsFilterArtkTh_AsBitmap implements INyARRgb2GsFilterArtkTh
    {
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0,0,0, 0, 0,
			0,0,0, 0, 0,
			1/3,1/3,1/3, 0,
			0, 0, 0, 1, 0
		]);		
        private var _ref_raster:FLARRgbRaster;
        public function NyARRgb2GsFilterArtkTh_AsBitmap(i_ref_raster:FLARRgbRaster)
        {
            NyAS3Utils.assert(i_ref_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
            this._ref_raster = i_ref_raster;
        }		
		private var _dest:Point = new Point(0,0);
		private var _src:Rectangle = new Rectangle();
		private var _tmp:BitmapData;	
		public function doFilter(i_th:int, i_gsraster:INyARGrayscaleRaster):void
		{
			var s:NyARIntSize = this._ref_raster.getSize();
			this.doFilter_2(0, 0, s.w, s.h, i_th, i_gsraster);
			return;
		}
		public function doFilter_2(i_l:int,i_t:int,i_w:int,i_h:int,i_th:int,i_gsraster:INyARGrayscaleRaster):void
        {
			NyAS3Utils.assert (i_gsraster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));			
			var out_buf:BitmapData = (BitmapData)(i_gsraster.getBuffer());
			var in_buf:BitmapData = this._ref_raster.getBitmapData();
			this._src.left  =i_l;
			this._src.top   =i_t;
			this._src.width =i_w;
			this._src.height = i_h;
			this._dest.x = i_l;
			this._dest.y = i_t;
			if (!_tmp) {
				_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
			} else if (in_buf.width != _tmp.width || in_buf.height != _tmp.height) {
				_tmp.dispose();
				_tmp = new BitmapData(in_buf.width, in_buf.height, false, 0x0);
			}
			_tmp.applyFilter(in_buf,this._src,this._dest, MONO_FILTER);
			out_buf.fillRect(out_buf.rect, 0x0);
			out_buf.threshold(_tmp,this._src,this._dest, '<=', i_th, 0xff0000ff, 0xff);
        }
    }
    class NyARRgbPixelDriver_AsBitmap implements INyARRgbPixelDriver
    {
        /** 参照する外部バッファ */
        private var _ref_raster:FLARRgbRaster;
        private var _ref_size:NyARIntSize;
        public function getSize():NyARIntSize
        {
            return this._ref_size;
        }
        /**
         * この関数は、指定した座標の1ピクセル分のRGBデータを、配列に格納して返します。
         */
        public function getPixel(i_x:int,i_y:int,o_rgb:Vector.<int>):void
        {
			var c:int = this._ref_raster.getBitmapData().getPixel(i_x, i_y);
			o_rgb[0] = (c >> 16) & 0xff;// R
			o_rgb[1] = (c >> 8) & 0xff;// G
			o_rgb[2] = c & 0xff;// B
            return;
        }

        /**
         * この関数は、座標群から、ピクセルごとのRGBデータを、配列に格納して返します。
         */
        public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,o_rgb:Vector.<int>):void
        {
            var bm:BitmapData = this._ref_raster.getBitmapData();
            for (var i:int = i_num - 1; i >= 0; i--)
            {
				var c:int = bm.getPixel(i_x[i], i_y[i]);
				o_rgb[0] = (c >> 16) & 0xff;// R
				o_rgb[1] = (c >> 8) & 0xff;// G
				o_rgb[2] = c & 0xff;// B
            }
            return;
        }
		public function setPixel_2(i_x:int, i_y:int, i_rgb:Vector.<int>):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			var pix:int = (0x00ff0000 & (i_rgb[0] << 16)) | (0x0000ff00 & (i_rgb[1] << 8)) | (0x0000ff & (i_rgb[2]));
			bm.setPixel(i_x,i_y,pix);
			return;
		}
		public function setPixel(i_x:int, i_y:int, i_r:int, i_g:int, i_b:int):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			var pix:int = (0x00ff0000 & (i_r << 16)) | (0x0000ff00 & (i_g << 8)) | (0x0000ff & (i_b));
			bm.setPixel(i_x,i_y,pix);
			return;
		}
		
		public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
		{
			NyARException.notImplement();
		}

        public function switchRaster( i_raster:INyARRgbRaster):void
        {
            this._ref_raster = FLARRgbRaster(i_raster);
            this._ref_size = i_raster.getSize();
        }

    }
    class PerspectiveCopy_AsBitmap extends NyARPerspectiveCopy_Base
    {
        private var _ref_raster:FLARRgbRaster;
        public function PerspectiveCopy_AsBitmap(i_ref_raster:FLARRgbRaster)
        {
            NyAS3Utils.assert(i_ref_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
            this._ref_raster = i_ref_raster;
        }
        protected override function onePixel(pk_l:int,pk_t:int,cpara:Vector.<Number>, o_out:INyARRaster):Boolean
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
                case NyARBufferType.INT1D_X8R8G8B8_32:
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
                default:
                    if (o_out is FLARRgbRaster)
                    {
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
                    }
                    else if (o_out is INyARRgbRaster)                    
                    {
                        //ANY to RGBx
                        var out_reader:INyARRgbPixelDriver = (INyARRgbRaster(o_out)).getRgbPixelDriver();
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
        protected override function multiPixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,i_resolution:int,o_out:INyARRaster):Boolean
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
            if (o_out is FLARRgbRaster)
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
            else if (o_out is INyARRgbRaster)
            {
                var out_reader:INyARRgbPixelDriver = (INyARRgbRaster(o_out)).getRgbPixelDriver();
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
                throw new NyARException();
            }
        }
    }	
	

