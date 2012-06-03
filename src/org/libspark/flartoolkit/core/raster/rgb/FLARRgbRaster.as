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
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.match.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.as3utils.*;
	import flash.display.*;
	import flash.media.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;

    /**
     * bitmapと互換性のあるラスタです。
     */
    public class FLARRgbRaster extends FLARRgbRaster_BaseClass_
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
				overload_FLARRgbRaster_BitmapData_4iiib(int(args[0]), int(args[1]),FLARBufferType.OBJECT_AS3_BitmapData,true);
				break;
			case 3:
				overload_FLARRgbRaster_BitmapData_4iiib(int(args[0]), int(args[1]),int(args[2]),true);
				break;				
			case 4:
				overload_FLARRgbRaster_BitmapData_4iiib(int(args[0]), int(args[1]),int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new FLARException();
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
			super.overload_FLARRgbRaster_4iiib(i_img.width, i_img.height, FLARBufferType.OBJECT_AS3_BitmapData, false);
		    this.wrapBuffer(i_img);
	    }
        public function overload_FLARRgbRaster_BitmapData_4iiib(i_width:int,i_height:int,i_raster_type:int , i_is_alloc:Boolean):void
	    {
			super.overload_FLARRgbRaster_4iiib(i_width, i_height, i_raster_type, i_is_alloc);
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
        protected override function initInstance(i_size:FLARIntSize,i_raster_type:int,i_is_alloc:Boolean):void
        {
            //バッファの構築
            switch (i_raster_type)
            {
                case FLARBufferType.OBJECT_AS3_BitmapData:
                    this._rgb_pixel_driver = new FLARRgbPixelDriver_AsBitmap();
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
					super.initInstance(i_size, i_raster_type, i_is_alloc);
            }
            //readerの構築
			return;
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
			if (this.isEqualBufferType(FLARBufferType.OBJECT_AS3_BitmapData)) {
				if (iIid == IFLARPerspectiveCopy)
				{
					return new PerspectiveCopy_AsBitmap(this);
				}
				if (iIid == FLARMatchPattDeviationColorData_IRasterDriver)
				{
					return FLARMatchPattDeviationColorData_RasterDriverFactory.createDriver(this);
				}
				if (iIid == IFLARRgb2GsFilter)
				{
					return new FLARRgb2GsFilterRgbAve_AsBitmap(this);
				}
				else if (iIid == IFLARRgb2GsFilterRgbAve)
				{
					return new FLARRgb2GsFilterRgbAve_AsBitmap(this);
				}

				if (iIid == IFLARRgb2GsFilterArtkTh)
				{
					return new FLARRgb2GsFilterArtkTh_AsBitmap(this);
				}
				if (iIid == FLARRgb2GsFilter){
					return new FLARRgb2GsFilter(this);
				}
			}
			return super.createInterface(iIid);
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

