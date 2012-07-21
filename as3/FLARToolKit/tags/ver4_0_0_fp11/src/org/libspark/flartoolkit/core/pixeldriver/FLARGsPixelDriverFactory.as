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
package org.libspark.flartoolkit.core.pixeldriver
{

	import org.libspark.flartoolkit.core.raster.*;

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.*;

	/**
	 * このクラスは、IFLARGsPixelDriverインタフェイスを持つオブジェクトを構築する手段を提供します。
	 */
	public class FLARGsPixelDriverFactory
	{
		/**
		 * ラスタから画素ドライバを構築します。構築したラスタドライバには、i_ref_rasterをセットします。
		 * @param i_ref_raster
		 * @return
		 * @throws FLARException
		 */
		public static function createDriver( i_ref_raster:IFLARGrayscaleRaster):IFLARGsPixelDriver
		{
			var ret:IFLARGsPixelDriver;
			switch(i_ref_raster.getBufferType()){
			case FLARBufferType.INT1D_GRAY_8:
			case FLARBufferType.INT1D_BIN_8:
				ret=new FLARGsPixelDriver_INT1D_GRAY_8();
				break;
			default:
				//RGBRasterインタフェイスがある場合
				if(i_ref_raster is IFLARRgbRaster){
					ret=new FLARGsPixelDriver_RGBX(IFLARRgbRaster(i_ref_raster));
					break;
				}
				throw new FLARException();
			}
			ret.switchRaster(i_ref_raster);
			return ret;
		}
		public static function createDriver_2(i_ref_raster:IFLARRgbRaster):IFLARGsPixelDriver
		{
			//RGBRasterインタフェイスがある場合
			return new FLARGsPixelDriver_RGBX(i_ref_raster);
		}	
	}
}
//
//	ピクセルドライバの定義
//

import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.rasterdriver.*;
import org.libspark.flartoolkit.core.pixeldriver.*;
import org.libspark.flartoolkit.core.types.*;

/**
 * INT1D_GRAY_8のドライバです。
 */
class FLARGsPixelDriver_INT1D_GRAY_8 implements IFLARGsPixelDriver
{
	protected var _ref_buf:Vector.<int>;
	private var _ref_size:FLARIntSize;
	public function getSize():FLARIntSize
	{
		return this._ref_size;
	}
	public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void
	{
		var bp:int;
		var w:int = this._ref_size.w;
		var b:Vector.<int> = this._ref_buf;
		for (var i:int = i_n - 1; i >= 0; i--) {
			bp = (i_x[i] + i_y[i] * w);
			o_buf[i_st_buf+i] = (b[bp]);
		}
		return;	
	}
	public function getPixel(i_x:int,i_y:int):int
	{
		var ref_buf:Vector.<int> = this._ref_buf;
		return ref_buf[(i_x + i_y * this._ref_size.w)];
	}
	public function setPixel(i_x:int,i_y:int,i_gs:int):void
	{
		this._ref_buf[(i_x + i_y * this._ref_size.w)]=i_gs;
	}
	public function setPixels(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,i_intgs:Vector.<int>):void
	{
		var w:int=this._ref_size.w;
		var r:Vector.<int>=this._ref_buf;
		for (var i:int = i_num - 1; i >= 0; i--){
			r[(i_x[i] + i_y[i] * w)]=i_intgs[i];
		}
	}	
	public function switchRaster(i_ref_raster:IFLARRaster):void
	{
		this._ref_buf=Vector.<int>(i_ref_raster.getBuffer());
		this._ref_size=i_ref_raster.getSize();
	}
	public function isCompatibleRaster(i_raster:IFLARRaster):Boolean
	{
		return i_raster.isEqualBufferType(FLARBufferType.INT1D_GRAY_8);
	}	
}
/**
 * 低速ドライバです。速度が必要な場合は、画素ドライバを書くこと。
 */
class FLARGsPixelDriver_RGBX implements IFLARGsPixelDriver
{
	private var _rgbd:IFLARRgbPixelDriver;
	private var _tmp:Vector.<int>= new Vector.<int>(3);
    public function FLARGsPixelDriver_RGBX(i_raster:IFLARRgbRaster)
    {
        this._rgbd = i_raster.getRgbPixelDriver();
    }	
	public function getSize():FLARIntSize
	{
		return this._rgbd.getSize();
	}
	public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void
	{
		var r:IFLARRgbPixelDriver=this._rgbd;
		var tmp:Vector.<int>=this._tmp;
		for (var i:int = i_n - 1; i >= 0; i--){
			r.getPixel(i_x[i], i_y[i],tmp);
			o_buf[i_st_buf+i] =(tmp[0]+tmp[1]+tmp[2])/3;
		}
		return;
	}
	public function getPixel(i_x:int,i_y:int):int
	{
		var tmp:Vector.<int>=this._tmp;
		this._rgbd.getPixel(i_x,i_y,tmp);
		return (tmp[0]+tmp[1]+tmp[2])/3;
	}
	public function setPixel(i_x:int,i_y:int,i_gs:int):void
	{
		this._rgbd.setPixel(i_x, i_y, i_gs,i_gs,i_gs);
	}
	public function setPixels(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,i_intgs:Vector.<int>):void
	{
		var r:IFLARRgbPixelDriver=this._rgbd;
		for (var i:int = i_num - 1; i >= 0; i--){
			var gs:int=i_intgs[i];
			r.setPixel(i_x[i], i_y[i],gs,gs,gs);
		}
	}
	public function switchRaster(i_ref_raster:IFLARRaster ):void
	{
		if(!(i_ref_raster is IFLARRgbRaster)){
			throw new FLARException();
		}
		this._rgbd=(IFLARRgbRaster(i_ref_raster)).getRgbPixelDriver();
	}
	public function isCompatibleRaster(i_raster:IFLARRaster):Boolean
	{
		return (i_raster is IFLARRgbRaster);
	}	
}
