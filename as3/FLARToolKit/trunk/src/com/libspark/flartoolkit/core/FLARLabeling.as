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
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.FLARException;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FLARLabeling implements IFLARLabeling {

		private var label_holder:FLARLabelHolder;
	    private var label_num:int;
	    
	    private var width:int;
	    private var height:int;
	    
	    private var label_img:BitmapData;
	    private var tmp_img:BitmapData;
	    private var hSearch:BitmapData;
	    private var hLineRect:Rectangle;
	    
	    /**
	     * @param i_width
	     * ラベリング画像の幅。解析するラスタの幅より大きいこと。
	     * @param i_height
	     * ラベリング画像の高さ。解析するラスタの高さより大きいこと。
	     */
	    public function FLARLabeling(i_width:int, i_height:int) {
			width = i_width;
			height = i_height;
			this.label_img = new BitmapData(i_width, i_height, false, 0x0);
			this.tmp_img = new BitmapData(i_width, i_height, false, 0x0);
			this.hSearch = new BitmapData(i_width, 1, false, 0x000000);
			this.hLineRect = new Rectangle(0, 0, 1, 1);
			this.label_holder = new FLARLabelHolder(1024);
			this.label_holder.init(1023, i_width, i_height);
			label_num = 0;
	    }
	    
	    /**
	     * 検出したラベルの数を返す
	     * @return
	     */
	    public function getLabelNum():int {
			return label_num;
	    }
	    
	    /**
	     * 検出したエリア配列？
	     * @return
	     * @throws FLARException
	     */
	    public function getLabel():Array {
			if (label_num < 1) {
			    throw new FLARException();
			}
			return this.label_holder.labels;
	    }
	    
	    /**
	     * 
	     * @return
	     * @throws FLARException
	     */
	    public function getLabelRef():Array {
			if (label_num < 1) {
			    throw new FLARException();
			}
			return null;//work_holder.work;
	    }
	    
	    /**
	     * ラベリング済みイメージを返す
	     * @return
	     * @throws FLARException
	     */
	    public function getLabelImg():BitmapData {
			return this.label_img;
	    }
	    
	    /**
	     * static ARInt16 *labeling2(ARUint8 *image, int thresh,int *label_num, int **area, double **pos, int **clip,int **label_ref, int LorR)
	     * 関数の代替品
	     * ラスタimageをラベリングして、結果を保存します。
	     * @param image
	     * @param thresh
	     * @throws FLARException
	     */
		private static const ZERO_POINT:Point = new Point();
		private static const ONE_POINT:Point = new Point(1, 1);
//		private static const BLUR_FILTER:BlurFilter = new BlurFilter(2, 2, 1);
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0, 0, 0, 1, 0
		]);
		public function labeling(image:FLARBitmapData, thresh:int):void {
			this.tmp_img.applyFilter(image.bitmapData, image.bitmapData.rect, ZERO_POINT, MONO_FILTER);
//			this.tmp_img.applyFilter(this.tmp_img, this.tmp_img.rect, ZERO_POINT, BLUR_FILTER);
			this.label_img.fillRect(this.label_img.rect, 0x0);
			var rect:Rectangle = this.tmp_img.rect;
			rect.inflate(-1, -1);
			this.label_img.threshold(this.tmp_img, rect, ONE_POINT, '<=', thresh, 0xffffffff, 0xff);
			
			this.label_num = 0;
			var labels:Array = this.label_holder.labels;
			
			var currentRect:Rectangle = this.label_img.getColorBoundsRect(0xffffff, 0xffffff, true);
			hLineRect.y = 0;
			hLineRect.width = this.label_img.width;
			var hSearchRect:Rectangle;
			var labelRect:Rectangle;
			var index:int = 0;
			while (!currentRect.isEmpty()) {
				hLineRect.y = currentRect.top;
				hSearch.copyPixels(this.label_img, hLineRect, ZERO_POINT);
				hSearchRect = hSearch.getColorBoundsRect(0xffffff, 0xffffff, true);
				
				var label:FLARLabel = labels[this.label_num++];
				this.label_img.floodFill(hSearchRect.x, hLineRect.y, this.label_num);
				labelRect = this.label_img.getColorBoundsRect(0xffffff, this.label_num, true);
				label.area = labelRect.width * labelRect.height;
				label.clip0 = labelRect.left;
				label.clip1 = labelRect.right - 1;
				label.clip2 = labelRect.top;
				label.clip3 = labelRect.bottom - 1;
				label.pos_x = (labelRect.left + labelRect.right - 1) * 0.5;
				label.pos_y = (labelRect.top + labelRect.bottom - 1) * 0.5;
				currentRect = this.label_img.getColorBoundsRect(0xffffff, 0xffffff, true);
			}
		}
		
	}
	
}

import com.libspark.flartoolkit.core.FLARLabel;
import com.libspark.flartoolkit.FLARException;

class FLARLabelHolder {
	
    private static const ARRAY_APPEND_STEP:int = 128;
    public var labels:Array;
    private var allocate_size:int;
    
    /**
     * 最大i_holder_size個の動的割り当てバッファを準備する。
     * @param i_holder_size
     */
    public function FLARLabelHolder(i_holder_size:int) {
		//ポインタだけははじめに確保しておく
		this.labels = new Array(i_holder_size);//new FLARLabel[i_holder_size];
		this.allocate_size = 0;
    }
    
    /**
     * i_indexで指定した番号までのバッファを準備する。
     * @param i_index
     */
    private function reserv(i_index:int):void {
		//アロケート済みなら即リターン
		if (this.allocate_size > i_index) {
		    return;
		}
		//要求されたインデクスは範囲外
		if (i_index >= this.labels.length) {
		    throw new FLARException();
		}	
		//追加アロケート範囲を計算
		var range:int = i_index + ARRAY_APPEND_STEP;
		if (range >= this.labels.length) {
		    range = this.labels.length;
		}
		//アロケート
		for (var i:int = this.allocate_size; i < range; i++) {
		    this.labels[i] = new FLARLabel();
		}
		this.allocate_size = range;
    }
    
    /**
     * i_reserv_sizeまでのバッファを、初期条件i_lxsizeとi_lysizeで初期化する。
     * @param i_reserv_size
     * @param i_lxsize
     * @param i_lysize
     * @throws FLARException
     */
    public function init(i_reserv_size:int, i_lxsize:int, i_lysize:int):void {
		reserv(i_reserv_size);
		var l:FLARLabel;
		for (var i:int = 0; i < i_reserv_size; i++) {
		    l = this.labels[i];
		    l.area = 0;
		    l.pos_x = 0;
		    l.pos_y = 0;
		    l.clip0 = i_lxsize;
		    l.clip1 = 0;
		    l.clip2 = i_lysize;
		    l.clip3 = 0;
		}
    }
    
}
