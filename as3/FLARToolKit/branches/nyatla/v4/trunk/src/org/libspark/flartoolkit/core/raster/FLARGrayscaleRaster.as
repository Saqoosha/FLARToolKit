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
package org.libspark.flartoolkit.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.utils.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;
	import flash.display.*;
	import flash.geom.*;
	/**
	 * このクラスは、BitmapDataをバッファ荷物グレースケールラスタです。
	 */
	public final class FLARGrayscaleRaster extends NyARGrayscaleRaster
	{
		public function FLARGrayscaleRaster(i_width:int,i_height:int,i_is_alloc:Boolean=true)
		{
			super(i_width,i_height,NyARBufferType.OBJECT_AS3_BitmapData,i_is_alloc);
		}
		protected override function initInstance(i_size:NyARIntSize, i_raster_type:int, i_is_alloc:Boolean):void
		{
			if (i_raster_type != NyARBufferType.OBJECT_AS3_BitmapData) {
				throw new NyARException();
			}
			this._buf = i_is_alloc?new BitmapData(i_size.w, i_size.h, false):null;
			this._pixdrv = new FLARGsPixelDriver_AsBitmap();
			this._pixdrv.switchRaster(this);
			this._is_attached_buffer = i_is_alloc;
			return;
		}
		public override function createInterface(i_iid:Class):Object
		{
			if(i_iid==NyARLabeling_Rle_IRasterDriver){
				return new NyARRlePixelDriver_ASBmp(this);
			}
			if(i_iid==INyARHistogramFromRaster){
				return new NyARHistogramFromRaster_AnyGs(this);
			}
			if(i_iid==NyARContourPickup_IRasterDriver){
				return FLARContourPickupFactory.createDriver(this);
			}
			if (i_iid == FLARGs2BinFilter) {
                if (this.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData)) {
					return new FLARGs2BinFilter(this);
				}
			}			
			throw new NyARException();
		}
		public function getBitmapData():BitmapData
		{
			return BitmapData(this._buf);
		}
	}
}



import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import flash.display.*;
import flash.geom.*;
//
//画像ドライバ
//
class NyARHistogramFromRaster_AnyGs implements INyARHistogramFromRaster
{
	private var _gsr:FLARGrayscaleRaster;
	public function NyARHistogramFromRaster_AnyGs(i_raster:FLARGrayscaleRaster)
	{
		this._gsr=i_raster;
	}
	public function createHistogram_2(i_skip:int,o_histogram:NyARHistogram):void
	{
		var s:NyARIntSize=this._gsr.getSize();
		this.createHistogram(0,0,s.w,s.h,i_skip,o_histogram);
	}
	public function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:NyARHistogram):void
	{
		var hist:Vector.<Vector.<Number>>=this._gsr.getBitmapData().histogram(new Rectangle(i_l, i_t, i_w, i_h));
		o_histogram.reset();
		var data_ptr:Vector.<int> = o_histogram.data;
		var src_ptr:Vector.<Number> = hist[2];
		for (var i:int = 0; i < 256; i++) {
			data_ptr[i] = (int)(src_ptr[i]);
		}
		o_histogram.total_of_data=i_w*i_h;
		return;
	}	
}

class NyARRlePixelDriver_ASBmp implements NyARLabeling_Rle_IRasterDriver
{
	private var _ref_raster:FLARGrayscaleRaster;
	public function NyARRlePixelDriver_ASBmp(i_ref_raster:FLARGrayscaleRaster)
	{
		this._ref_raster=i_ref_raster;
	}
	public function xLineToRle(i_x:int, i_y:int, i_len:int,i_th:int,i_out:Vector.<NyARLabeling_Rle_RleElement>):int
	{
		var buf:BitmapData=BitmapData(this._ref_raster.getBitmapData());
		var current:int = 0;
		var r:int = -1;
		// 行確定開始
		var st:int=i_x+this._ref_raster.getWidth()*i_y;
		var x:int = st;
		var right_edge:int = st + i_len - 1;
		while (x < right_edge) {
			// 暗点(0)スキャン
			if (buf[x] > i_th) {
				x++;//明点
				continue;
			}
			// 暗点発見→暗点長を調べる
			r = (x - st);
			i_out[current].l = r;
			r++;// 暗点+1
			x++;
			while (x < right_edge) {
				if (buf[x] > i_th) {
					// 明点(1)→暗点(0)配列終了>登録
					i_out[current].r = r;
					current++;
					x++;// 次点の確認。
					r = -1;// 右端の位置を0に。
					break;
				} else {
					// 暗点(0)長追加
					r++;
					x++;
				}
			}
		}
		// 最後の1点だけ判定方法が少し違うの。
		if (buf[x] > i_th) {
			// 明点→rカウント中なら暗点配列終了>登録
			if (r >= 0) {
				i_out[current].r = r;
				current++;
			}
		} else {
			// 暗点→カウント中でなければl1で追加
			if (r >= 0) {
				i_out[current].r = (r + 1);
			} else {
				// 最後の1点の場合
				i_out[current].l = (i_len - 1);
				i_out[current].r = (i_len);
			}
			current++;
		}
		// 行確定
		return current;
	}
}
