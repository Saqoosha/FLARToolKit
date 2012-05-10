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
package org.libspark.flartoolkit.core.raster
{
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.pixeldriver.*;
	import org.libspark.flartoolkit.core.labeling.rlelabeling.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	/**
	 * このクラスは、0/ 255 の二値GrayscaleRasterです。
	 */
	public class FLARBinRaster_BaseClass_ extends FLARGrayscaleRaster_BaseClass_
	{
		/**
		 * コンストラクタです。
		 * 画像のサイズパラメータを指定して、{@link FLARBufferType#INT2D_BIN_8}形式のバッファを持つインスタンスを生成します。
		 * このラスタは、内部参照バッファを持ちます。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @throws FLARException
		 */
		public function FLARBinRaster_BaseClass_(i_width:int,i_height:int,i_raster_type:int=-1,i_is_attach:Boolean=true)
		{
			super(i_width,i_height,i_raster_type==-1?FLARBufferType.INT1D_BIN_8:i_raster_type,i_is_attach);
		}
		/*
		 * この関数は、インスタンスの初期化シーケンスを実装します。
		 * コンストラクタから呼び出します。
		 * @param i_size
		 * ラスタのサイズ
		 * @param i_buf_type
		 * バッファ形式定数
		 * @param i_is_alloc
		 * 内部バッファ/外部バッファのフラグ
		 * @return
		 * 初期化に成功するとtrue
		 * @throws FLARException 
		 */
		protected override function initInstance(i_size:FLARIntSize,i_buf_type:int,i_is_alloc:Boolean):void
		{
			switch(i_buf_type)
			{
				case FLARBufferType.INT1D_BIN_8:
					this._buf = i_is_alloc?new Vector.<int>(i_size.w*i_size.h):null;
					break;
				default:
					super.initInstance(i_size, i_buf_type, i_is_alloc);
					return;
			}
			this._pixdrv=FLARGsPixelDriverFactory.createDriver(this);
			this._is_attached_buffer=i_is_alloc;
			return;
		}
		public override function createInterface(i_iid:Class):Object
		{
			if(i_iid==FLARLabeling_Rle_IRasterDriver){
				return FLARLabeling_Rle_RasterDriverFactory.createDriver(this);
			}
			if(i_iid==FLARContourPickup_IRasterDriver){
				return FLARContourPickup_ImageDriverFactory.createDriver(this);
			}
			throw new FLARException();
		}
	}
}