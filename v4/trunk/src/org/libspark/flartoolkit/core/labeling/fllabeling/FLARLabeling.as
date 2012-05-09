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
package org.libspark.flartoolkit.core.labeling.fllabeling
{
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class FLARLabeling
	{
		private var AR_AREA_MAX:int = 100000;// #define AR_AREA_MAX 100000
		private var AR_AREA_MIN:int = 70;// #define AR_AREA_MIN 70
		
		private static const ZERO_POINT:Point = new Point();
		
	    private var hSearch:BitmapData;
	    private var hLineRect:Rectangle;
		private var _tmp_bmp:BitmapData;
		private var _fllstack:FLLabelInfoStack;
		public function FLARLabeling(i_width:int,i_height:int)
		{
			this._tmp_bmp = new BitmapData(i_width, i_height, false,0x00);
			this.hSearch = new BitmapData(i_width, 1, false, 0x00);
			this.hLineRect = new Rectangle(0, 0, 1, 1);			
			this._fllstack=new FLLabelInfoStack(i_width*i_height*2048/(320*240)+32);
			return;
		}
		public function labeling(i_bin_raster:NyARBinRaster):void
		{
			var label_img:BitmapData = this._tmp_bmp;
			//BIN
			label_img.copyPixels(BitmapData(i_bin_raster.getBuffer()), label_img.rect, ZERO_POINT);
			this.labeling_impl(label_img);
		}
		public function labeling_2(i_bin_raster:NyARBinRaster,i_area:NyARIntRect):void
		{
			NyARException.notImplement();
		}		
		public function labeling_3(i_gs_raster:NyARGrayscaleRaster,i_th:int):void
		{
			var label_img:BitmapData = this._tmp_bmp;
			//GS->BIN
			var s:BitmapData =BitmapData(i_gs_raster.getBuffer());

			label_img.fillRect(label_img.rect, 0x0);		
			label_img.threshold(BitmapData(i_gs_raster.getBuffer()), label_img.rect, ZERO_POINT, '<=', i_th, 0xff0000ff, 0x000000ff);
			this.labeling_impl(label_img);
		}

		
		protected function onLabelFound(i_ref_label:NyARRleLabelFragmentInfo):void
		{
			throw new NyARException();
		}		
		/**
		 * 
		 * @param	label_img
		 * ラべリングの準備をしたbitmapdata
		 * @param	o_stack
		 * @return
		 */
		public function labeling_impl(label_img:BitmapData):void
		{
			var tmp_label:NyARRleLabelFragmentInfo;
			var fllstack:FLLabelInfoStack=this._fllstack;
			fllstack.clear();

			var currentRect:Rectangle = label_img.getColorBoundsRect(0x0000ff, 0x0000ff, true);
			hLineRect.y = 0;
			hLineRect.width = label_img.width;
			var hSearchRect:Rectangle;
			var labelRect:Rectangle;
			var index:int = 0x100;
			try {
				while (!currentRect.isEmpty()) {
					hLineRect.y = currentRect.top;
					hSearch.copyPixels(label_img, hLineRect, ZERO_POINT);
					hSearchRect = hSearch.getColorBoundsRect(0xffffff, 0x0000ff, true);
					
					label_img.floodFill(hSearchRect.x, hLineRect.y, ++index);
					labelRect = label_img.getColorBoundsRect(0xffffff, index, true);
					//エリアは近似値
					var area:int = labelRect.width * labelRect.height;
					//エリア規制
					if (area <= AR_AREA_MAX && area >= AR_AREA_MIN) {

						tmp_label = NyARRleLabelFragmentInfo(fllstack.prePush());
						if (tmp_label == null) {
							break;
						}
						tmp_label.area = area;
						tmp_label.clip_l = labelRect.left;
						tmp_label.clip_r = labelRect.right - 1;
						tmp_label.clip_t = labelRect.top;
						tmp_label.clip_b = labelRect.bottom - 1;
						tmp_label.pos_x = (labelRect.left + labelRect.right - 1) * 0.5;
						tmp_label.pos_y = (labelRect.top + labelRect.bottom - 1) * 0.5;
						//エントリ・ポイントを探す
						tmp_label.entry_x = getTopClipTangentX(label_img, index, tmp_label);
						//コール
						this.onLabelFound(tmp_label);
					}
					currentRect = label_img.getColorBoundsRect(0xffffff, 0x0000ff, true);
				}
			} catch (e:Error){
				trace('Too many labeled area!! gave up....');
			}
			return;
		}
		private function getTopClipTangentX(i_image:BitmapData, i_index:int, i_label:NyARRleLabelFragmentInfo):int
		{
			var w:int;
			const clip1:int = i_label.clip_r;
			var i:int;
			for (i = i_label.clip_l; i <= clip1; i++) { // for( i = clip[0]; i <=clip[1]; i++, p1++ ) {
				w = i_image.getPixel(i, i_label.clip_t);
				if (w == i_index) {
					return i;
				}
			}
			//あれ？見つからないよ？
			throw new NyARException();
		}
		public function setAreaRange(i_max:int, i_min:int):void
		{
			this.AR_AREA_MAX = i_max;
			this.AR_AREA_MIN = i_min;
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;

class FLLabelInfoStack extends NyARObjectStack
{
	public function FLLabelInfoStack(i_length:int)
	{
		super();
		super.initInstance(i_length);
		return;
	}
	protected override function createElement():Object
	{
		return new NyARRleLabelFragmentInfo();
	}
}