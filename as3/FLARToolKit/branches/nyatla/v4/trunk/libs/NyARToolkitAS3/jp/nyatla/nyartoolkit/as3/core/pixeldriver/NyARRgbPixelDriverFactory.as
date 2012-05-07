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
package jp.nyatla.nyartoolkit.as3.core.pixeldriver
{

	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARBufferType;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	/**
	 * この関数は、NyARRgbRasterからコールします。
	 */
	public class NyARRgbPixelDriverFactory
	{
		/**
		 * この関数は、i_rasterを操作するピクセルドライバインスタンスを生成します。
		 * @param i_raster
		 * @return
		 * @throws NyARException
		 */
		public static function createDriver(i_raster:INyARRgbRaster):INyARRgbPixelDriver
		{
			var ret:INyARRgbPixelDriver;
			switch(i_raster.getBufferType()){
			case NyARBufferType.INT1D_GRAY_8:
				ret=new NyARRgbPixelDriver_INT1D_GRAY_8();
				break;
			case NyARBufferType.INT1D_X8R8G8B8_32:
				ret= new NyARRgbPixelDriver_INT1D_X8R8G8B8_32();
				break;
			default:
				throw new NyARException();		
			}
			ret.switchRaster(i_raster);
			return ret;
		}
	}
}
//--------------------------------------------------------------------------------
//ピクセルドライバの定義
//--------------------------------------------------------------------------------
import jp.nyatla.nyartoolkit.as3.core.NyARException;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.types.NyARBufferType;
import jp.nyatla.nyartoolkit.as3.core.types.*;


/**
* このクラスは、{@link NyARBufferType#INT1D_GRAY_8}形式のラスタバッファに対応する、ピクセルリーダです。
*/
class NyARRgbPixelDriver_INT1D_GRAY_8 implements INyARRgbPixelDriver
{
	/** 参照する外部バッファ */
	private var _ref_buf:Vector.<int>;

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
		o_rgb[0] = o_rgb[1] = o_rgb[2] = this._ref_buf[i_x + i_y * this._ref_size.w];
		return;
	}

	/**
	 * この関数は、座標群から、ピクセルごとのRGBデータを、配列に格納して返します。
	 */
	public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>, i_num:int, o_rgb:Vector.<int>):void
	{
		var width:int = this._ref_size.w;
		var ref_buf:Vector.<int> = this._ref_buf;
		for (var i:int = i_num - 1; i >= 0; i--) {
			o_rgb[i * 3 + 0] = o_rgb[i * 3 + 1] = o_rgb[i * 3 + 2] = ref_buf[i_x[i]+ i_y[i] * width];
		}
		return;
	}

	/**
	 * この関数は、機能しません。
	 */
	public function setPixel_2(i_x:int,i_y:int,i_rgb:Vector.<int>):void
	{
		NyARException.notImplement();
	}

	/**
	 * この関数は、機能しません。
	 */
	public function setPixel(i_x:int,i_y:int,i_r:int,i_g:int,i_b:int):void
	{
		NyARException.notImplement();
	}

	/**
	 * この関数は、機能しません。
	 */
	public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
	{
		NyARException.notImplement();
	}

	public function switchRaster(i_raster:INyARRgbRaster):void
	{
		this._ref_buf = (Vector.<int>)(i_raster.getBuffer());
		this._ref_size = i_raster.getSize();
	}
}

/**
* このクラスは、{@link NyARBufferType#INT1D_X8R8G8B8_32}形式のラスタバッファに対応する、ピクセルリーダです。
*/
class NyARRgbPixelDriver_INT1D_X8R8G8B8_32 implements INyARRgbPixelDriver
{
	/** 参照する外部バッファ */
	private var _ref_buf:Vector.<int>;

	private var _ref_size:NyARIntSize;
	public function getSize():NyARIntSize
	{
		return this._ref_size;
	}
	/**
	 * この関数は、指定した座標の1ピクセル分のRGBデータを、配列に格納して返します。
	 */
	public function getPixel(i_x:int,i_y:int, o_rgb:Vector.<int>):void
	{
		var rgb:int = this._ref_buf[i_x + i_y * this._ref_size.w];
		o_rgb[0] = (rgb >> 16) & 0xff;// R
		o_rgb[1] = (rgb >> 8) & 0xff;// G
		o_rgb[2] = rgb & 0xff;// B
		return;
	}

	/**
	 * この関数は、座標群から、ピクセルごとのRGBデータを、配列に格納して返します。
	 */
	public function getPixelSet(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, o_rgb:Vector.<int>):void
	{
		var width:int = this._ref_size.w;
		var ref_buf:Vector.<int> = this._ref_buf;
		for (var i:int = i_num - 1; i >= 0; i--) {
			var rgb:int = ref_buf[i_x[i] + i_y[i] * width];
			o_rgb[i * 3 + 0] = (rgb >> 16) & 0xff;// R
			o_rgb[i * 3 + 1] = (rgb >> 8) & 0xff;// G
			o_rgb[i * 3 + 2] = rgb & 0xff;// B
		}
		return;
	}

	/**
	 * この関数は、RGBデータを指定した座標のピクセルにセットします。
	 */
	public function setPixel_2(i_x:int,i_y:int,i_rgb:Vector.<int>):void
	{
		this._ref_buf[i_x + i_y * this._ref_size.w] = (i_rgb[0] << 16)
				| (i_rgb[1] << 8) | (i_rgb[2]);
	}

	/**
	 * この関数は、RGBデータを指定した座標のピクセルにセットします。
	 */
	public function setPixel(i_x:int, i_y:int, i_r:int, i_g:int, i_b:int):void
	{
		this._ref_buf[i_x + i_y * this._ref_size.w] = (i_r << 16) | (i_g << 8) | (i_b);
	}

	/**
	 * この関数は、機能しません。
	 */
	public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
	{
		NyARException.notImplement();
	}

	public function switchRaster(i_raster:INyARRgbRaster):void
	{
		this._ref_buf = Vector.<int>(i_raster.getBuffer());
		this._ref_size = i_raster.getSize();
	}
}
