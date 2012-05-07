/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.*;


	// RleImageをラベリングする。
	public class NyARLabeling_Rle
	{
		private static const AR_AREA_MAX:int = 100000;// #define AR_AREA_MAX 100000
		private static const AR_AREA_MIN:int = 70;// #define AR_AREA_MIN 70
		
		private var _rlestack:RleInfoStack;
		private var _rle1:Vector.<NyARLabeling_Rle_RleElement>;
		private var _rle2:Vector.<NyARLabeling_Rle_RleElement>;
		private var _max_area:int;
		private var _min_area:int;
		protected var _raster_size:NyARIntSize=new NyARIntSize();
		public function NyARLabeling_Rle(i_width:int,i_height:int)
		{
			this.initInstance(i_width, i_height);
		}
		protected function initInstance(i_width:int,i_height:int):void
		{
			this._raster_size.setValue(i_width,i_height);
			var t:int=(int)((Number(i_width))*i_height*2048/(320*240)+32);//full HD support
			this._rlestack=new RleInfoStack(t);
			this._rle1 = NyARLabeling_Rle_RleElement.createArray(i_width/2+1);
			this._rle2 = NyARLabeling_Rle_RleElement.createArray(i_width/2+1);
			this._max_area=AR_AREA_MAX;
			this._min_area=AR_AREA_MIN;
			return;
		}
		/**
		 * 対象サイズ
		 * @param i_max
		 * @param i_min
		 */
		public function setAreaRange(i_max:int,i_min:int):void
		{
			//assert(i_min > 0 && i_max > i_min);
			this._max_area=i_max;
			this._min_area=i_min;
			return;
		}



		private function addFragment(i_rel_img:NyARLabeling_Rle_RleElement,i_nof:int,i_row_index:int,o_stack:RleInfoStack):Boolean
		{
			var l:int =i_rel_img.l;
			var len:int=i_rel_img.r - l;
			i_rel_img.fid = i_nof;// REL毎の固有ID
			var v:NyARRleLabelFragmentInfo = NyARRleLabelFragmentInfo(o_stack.prePush());
			if(v==null){
				return false;
			}
			v.entry_x = l;
			v.area =len;
			v.clip_l=l;
			v.clip_r=i_rel_img.r-1;
			v.clip_t=i_row_index;
			v.clip_b=i_row_index;
			v.pos_x=(len*(2*l+(len-1)))/2;
			v.pos_y=i_row_index*len;

			return true;
		}
		/**
		 * この関数は、ラスタを敷居値i_thで2値化して、ラベリングします。
		 * 検出したラベルは、自己コールバック関数{@link #onLabelFound}で通知します。
		 * @param i_bin_raster
		 * 入力画像。対応する形式は、クラスの説明を参照してください。
		 * @param i_th
		 * 敷居値を指定します。2値画像の場合は、0を指定してください。
		 * @throws NyARException
		 */
		public function labeling(i_raster:INyARGrayscaleRaster,i_th:int):void
		{
			var size:NyARIntSize=i_raster.getSize();
			this.imple_labeling(i_raster,i_th,0,0,size.w,size.h);
		}
		/**
		 * この関数は、ラスタを敷居値i_thで2値化して、ラベリングします。
		 * 検出したラベルは、自己コールバック関数{@link #onLabelFound}で通知します。
		 * @param i_bin_raster
		 * 入力画像。対応する形式は、クラスの説明を参照してください。
		 * @param i_area
		 * ラべリングする画像内の範囲
		 * @param i_th
		 * 敷居値
		 * @throws NyARException
		 */
		public function labeling_2(i_raster:INyARGrayscaleRaster,i_area:NyARIntRect,i_th:int):void
		{
			this.imple_labeling(i_raster,0,i_area.x,i_area.y,i_area.w,i_area.h);
		}		

		private var _last_input_raster:INyARRaster=null;
		private var _image_driver:NyARLabeling_Rle_IRasterDriver;
		
		private function imple_labeling(i_raster:INyARRaster,i_th:int,i_left:int,i_top:int,i_width:int,i_height:int):void
		{			
			//assert(i_raster.getSize().isEqualSize(this._raster_size));
			//ラスタドライバのチェック
			if(_last_input_raster!=i_raster){
				this._image_driver=NyARLabeling_Rle_IRasterDriver(i_raster.createInterface(NyARLabeling_Rle_IRasterDriver));
			}
			var pixdrv:NyARLabeling_Rle_IRasterDriver=this._image_driver;
			var rle_prev:Vector.<NyARLabeling_Rle_RleElement> = this._rle1;
			var rle_current:Vector.<NyARLabeling_Rle_RleElement> = this._rle2;
			// リセット処理
			var rlestack:RleInfoStack=this._rlestack;
			rlestack.clear();

			//
			var len_prev:int = 0;
			var len_current:int = 0;
			var bottom:int=i_top+i_height;
			var row_stride:int=this._raster_size.w;
			var in_buf:Vector.<int> = (Vector.<int>)(i_raster.getBuffer());

			var id_max:int = 0;
			var label_count:int = 0;
			var rle_top_index:int=i_left+row_stride*i_top;
			
			var ypos:int=i_top;
			// 初段登録
			len_prev = pixdrv.xLineToRle(i_left,ypos,i_width,i_th,rle_prev);

			var i:int;
			for (i = 0; i < len_prev; i++) {
				// フラグメントID=フラグメント初期値、POS=Y値、RELインデクス=行
				if(addFragment(rle_prev[i], id_max, i_top,rlestack)){
					id_max++;
					// nofの最大値チェック
					label_count++;
				}
			}
			var f_array:Vector.<Object> = Vector.<Object>(rlestack.getArray());
			// 次段結合
			for (var y:int = i_top + 1; y < bottom; y++)
			{
				// カレント行の読込
				ypos++;
				len_current = pixdrv.xLineToRle(i_left,ypos,i_width,i_th, rle_current);
				var index_prev:int = 0;

				SCAN_CUR: for (i = 0; i < len_current; i++) {
					// index_prev,len_prevの位置を調整する
					var id:int = -1;
					// チェックすべきprevがあれば確認
					SCAN_PREV: while (index_prev < len_prev) {
						if (rle_current[i].l - rle_prev[index_prev].r > 0) {// 0なら8方位ラベリング
							// prevがcurの左方にある→次のフラグメントを探索
							index_prev++;
							continue;
						} else if (rle_prev[index_prev].l - rle_current[i].r > 0) {// 0なら8方位ラベリングになる
							// prevがcur右方にある→独立フラグメント
							if(addFragment(rle_current[i], id_max, y,rlestack)){
								id_max++;
								label_count++;
							}
							// 次のindexをしらべる
							continue SCAN_CUR;
						}
						id=rle_prev[index_prev].fid;//ルートフラグメントid
						var id_ptr:NyARRleLabelFragmentInfo = NyARRleLabelFragmentInfo(f_array[id]);
						//結合対象(初回)->prevのIDをコピーして、ルートフラグメントの情報を更新
						rle_current[i].fid = id;//フラグメントIDを保存
						//
						var l:int= rle_current[i].l;
						var r:int= rle_current[i].r;
						var len:int=r-l;
						//結合先フラグメントの情報を更新する。
						id_ptr.area += len;
						//tとentry_xは、結合先のを使うので更新しない。
						id_ptr.clip_l=l<id_ptr.clip_l?l:id_ptr.clip_l;
						id_ptr.clip_r=r>id_ptr.clip_r?r-1:id_ptr.clip_r;
						id_ptr.clip_b=y;
						id_ptr.pos_x+=(len*(2*l+(len-1)))/2;
						id_ptr.pos_y+=y*len;
						//多重結合の確認（２個目以降）
						index_prev++;
						while (index_prev < len_prev) {
							if (rle_current[i].l - rle_prev[index_prev].r > 0) {// 0なら8方位ラベリング
								// prevがcurの左方にある→prevはcurに連結していない。
								break SCAN_PREV;
							} else if (rle_prev[index_prev].l - rle_current[i].r > 0) {// 0なら8方位ラベリングになる
								// prevがcurの右方にある→prevはcurに連結していない。
								index_prev--;
								continue SCAN_CUR;
							}
							// prevとcurは連結している→ルートフラグメントの統合
							
							//結合するルートフラグメントを取得
							var prev_id:int =rle_prev[index_prev].fid;
							var prev_ptr:NyARRleLabelFragmentInfo = NyARRleLabelFragmentInfo(f_array[prev_id]);
							if (id != prev_id){
								label_count--;
								//prevとcurrentのフラグメントidを書き換える。
								var i2:int;
								for(i2=index_prev;i2<len_prev;i2++){
									//prevは現在のidから最後まで
									if(rle_prev[i2].fid==prev_id){
										rle_prev[i2].fid=id;
									}
								}
								for(i2=0;i2<i;i2++){
									//currentは0から現在-1まで
									if(rle_current[i2].fid==prev_id){
										rle_current[i2].fid=id;
									}
								}
								
								//現在のルートフラグメントに情報を集約
								id_ptr.area +=prev_ptr.area;
								id_ptr.pos_x+=prev_ptr.pos_x;
								id_ptr.pos_y+=prev_ptr.pos_y;
								//tとentry_xの決定
								if (id_ptr.clip_t > prev_ptr.clip_t) {
									// 現在の方が下にある。
									id_ptr.clip_t = prev_ptr.clip_t;
									id_ptr.entry_x = prev_ptr.entry_x;
								}else if (id_ptr.clip_t < prev_ptr.clip_t) {
									// 現在の方が上にある。prevにフィードバック
								} else {
									// 水平方向で小さい方がエントリポイント。
									if (id_ptr.entry_x > prev_ptr.entry_x) {
										id_ptr.entry_x = prev_ptr.entry_x;
									}else{
									}
								}
								//lの決定
								if (id_ptr.clip_l > prev_ptr.clip_l) {
									id_ptr.clip_l=prev_ptr.clip_l;
								}else{
								}
								//rの決定
								if (id_ptr.clip_r < prev_ptr.clip_r) {
									id_ptr.clip_r=prev_ptr.clip_r;
								}else{
								}
								//bの決定

								//結合済のルートフラグメントを無効化する。
								prev_ptr.area=0;
							}


							index_prev++;
						}
						index_prev--;
						break;
					}
					// curにidが割り当てられたかを確認
					// 右端独立フラグメントを追加
					if (id < 0){
						if(addFragment(rle_current[i], id_max, y,rlestack)){
							id_max++;
							label_count++;
						}
					}
				}
				// prevとrelの交換
				var tmp:Vector.<NyARLabeling_Rle_RleElement> = rle_prev;
				rle_prev = rle_current;
				len_prev = len_current;
				rle_current = tmp;
			}		
			//対象のラベルだけを追記
			var max:int=this._max_area;
			var min:int=this._min_area;
			for(i=id_max-1;i>=0;i--){
				var src_info:NyARRleLabelFragmentInfo=NyARRleLabelFragmentInfo(f_array[i]);
				var area:int=src_info.area;
				if(area<min || area>max){//対象外のエリア0のもminではじく
					continue;
				}
				//値を相対位置に補正
				src_info.clip_l+=i_left;
				src_info.clip_r+=i_left;
				src_info.entry_x+=i_left;
				src_info.pos_x/=area;
				src_info.pos_y/=area;
				//コールバック関数コール
				this.onLabelFound(src_info);		
			}
		}
		/**
		 * ハンドラ関数です。継承先クラスでオーバライドしてください。
		 * i_labelのインスタンスは、次のラべリング実行まで保証されていますが、将来にわたり保証されないかもしれません。(恐らく保証されますが)
		 * コールバック関数から参照を使用する場合は、互換性を確認するために、念のため、assertで_af_label_array_safe_referenceフラグをチェックしてください。
		 * @param i_label
		 */
		protected function onLabelFound(i_ref_label:NyARRleLabelFragmentInfo):void
		{
			throw new NyARException();
		}
		
		/**
		 * クラスの仕様確認フラグです。ラベル配列の参照アクセスが可能かを返します。
		 * 
		 */
		public const _sf_label_array_safe_reference:Boolean=true;
	}


}

import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;

final class RleInfoStack extends NyARObjectStack
{
	public function RleInfoStack(i_length:int)
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





