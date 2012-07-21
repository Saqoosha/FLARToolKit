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
package org.libspark.flartoolkit.rpf.utils
{

	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.core.types.FLARIntSize;


	/**
	 * この関数は、FLARRgbRasterからコールします。
	 */
	public class FLARGsRasterGraphicsFactory
	{
		/**
		 * この関数は、i_rasterを操作するピクセルドライバインスタンスを生成します。
		 * @param i_raster
		 * @return
		 * @throws FLARException
		 */
		public static function createDriver(i_raster:IFLARGrayscaleRaster):IFLARGsRasterGraphics
		{
			switch(i_raster.getBufferType()){
			case FLARBufferType.INT1D_GRAY_8:
				return new FLARGsRasterGraphics_GS_INT8(i_raster);
			default:
				break;
			}
			throw new FLARException();
		}
	}
}

import jp.nyatla.as3utils.*;
import org.libspark.flartoolkit.core.FLARException;
import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.rpf.utils.*;
/**
 * このインタフェイスは、グレースケール画像に対するグラフィクス機能を定義します。
 */
class FLARGsRasterGraphics_GS_INT8 implements IFLARGsRasterGraphics
{
	private var _raster:IFLARGrayscaleRaster;

	public function FLARGsRasterGraphics_GS_INT8(i_raster:IFLARGrayscaleRaster)
	{
		this._raster=i_raster;
	}
	public function fill(i_value:int):void
	{
		var buf:Vector.<int>=Vector.<int>(this._raster.getBuffer());
		var s:FLARIntSize=this._raster.getSize();
		for (var i:int = s.h * s.w - 1; i >= 0; i--) {
			buf[i] = i_value;
		}
	}
	public function copyTo(i_left:int,i_top:int,i_skip:int ,o_output:IFLARGrayscaleRaster):void
	{
		NyAS3Utils.assert (this._raster.getSize().isInnerSize(i_left + o_output.getWidth() * i_skip, i_top+ o_output.getHeight() * i_skip));		
		var input:Vector.<int> = Vector.<int>(this._raster.getBuffer());
		switch(o_output.getBufferType())
		{
		case FLARBufferType.INT1D_GRAY_8:
			var output:Vector.<int> = Vector.<int>(o_output.getBuffer());
			var dest_size:FLARIntSize = o_output.getSize();
			var src_size:FLARIntSize = this._raster.getSize();
			var skip_src_y:int = (src_size.w - dest_size.w * i_skip) + src_size.w * (i_skip - 1);
			var pix_count:int = dest_size.w;
			var pix_mod_part:int = pix_count - (pix_count % 8);
			// 左上から1行づつ走査していく
			var pt_dst:int = 0;
			var pt_src:int = (i_top * src_size.w + i_left);
			for (var y:int = dest_size.h - 1; y >= 0; y -= 1) {
				var x:int;
				for (x = pix_count - 1; x >= pix_mod_part; x--) {
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
				}
				for (; x >= 0; x -= 8) {
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
					output[pt_dst++] = input[pt_src];
					pt_src += i_skip;
				}
				// スキップ
				pt_src += skip_src_y;
			}
			return;			
		default:
			throw new FLARException();
		}
	}
}
