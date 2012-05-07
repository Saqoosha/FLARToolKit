/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.param.NyARCameraDistortionFactor;
	import jp.nyatla.nyartoolkit.as3.core.raster.NyARGrayscaleRaster;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.NyARContourPickup;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.NyARMath;
	import jp.nyatla.nyartoolkit.as3.rpf.utils.*;

	/**
	 * INyARVectorReaderの画素アクセス関数以外を実装したクラスです。
	 * 継承クラスで画素アクセス関数を実装してください。
	 *
	 */
	public class NyARVectorReader_Basic implements INyARVectorReader
	{
		private var _tmp_coord_pos:Vector.<VecLinearCoordinatePoint>;
		private var _rob_resolution:int;
		protected var _ref_base_raster:NyARGrayscaleRaster;
		private var _ref_rob_raster:NyARGrayscaleRaster;
		protected var _factor:NyARCameraDistortionFactor;
		/**
		 * 
		 * @param i_ref_raster
		 * 基本画像
		 * @param i_ref_raster_distortion
		 * 歪み解除オブジェクト(nullの場合歪み解除を省略)
		 * @param i_ref_rob_raster
		 * エッジ探索用のROB画像
		 * @param 
		 */
		public function NyARVectorReader_Basic(i_ref_raster:NyARGrayscaleRaster,i_ref_raster_distortion:NyARCameraDistortionFactor,i_ref_rob_raster:NyARGrayscaleRaster,i_contur_pickup:NyARContourPickup)
		{
			this._rob_resolution=i_ref_raster.getWidth()/i_ref_rob_raster.getWidth();
			this._ref_rob_raster=i_ref_rob_raster;
			this._ref_base_raster=i_ref_raster;
			this._coord_buf = new NyARIntCoordinates((i_ref_raster.getWidth() + i_ref_raster.getHeight()) * 4);
			this._factor=i_ref_raster_distortion;
			this._tmp_coord_pos = VecLinearCoordinatePoint.createArray(this._coord_buf.items.length);
			this._cpickup = i_contur_pickup;
		}

		public function getAreaVector33(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			// Override
			NyARException.notImplement();
			return -1;
		}
		public function getAreaVector22(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			// Override
			NyARException.notImplement();
			return -1;
		}

		/**
		 * ワーク変数
		 */
		protected var _coord_buf:NyARIntCoordinates;
		private var  _cpickup:NyARContourPickup;
		protected const _MARGE_ANG_TH:Number = NyARMath.COS_DEG_10;

		public function traceConture(i_th:int,
				i_entry:NyARIntPoint2d,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			// Robertsラスタから輪郭抽出
			if (!this._cpickup.getContour(this._ref_rob_raster, i_th, i_entry.x, i_entry.y,coord)) {
				// 輪郭線MAXならなにもできないね。
				return false;

			}
			// 輪郭線のベクトル化
			return traceConture_2(coord, this._rob_resolution,
					this._rob_resolution * 2, o_coord);
		}



		/**
		 * 点1と点2の間に線分を定義して、その線分上のベクトルを得ます。点は、画像の内側でなければなりません。 320*240の場合、(x>=0 &&
		 * x<320 x+w>0 && x+w<320),(y>0 && y<240 y+h>=0 && y+h<=319)となります。
		 * 
		 * @param i_pos1
		 *            点1の座標です。
		 * @param i_pos2
		 *            点2の座標です。
		 * @param i_area
		 *            ベクトルを検出するカーネルサイズです。1の場合(n*2-1)^2のカーネルになります。 点2の座標です。
		 * @param o_coord
		 *            結果を受け取るオブジェクトです。
		 * @return
		 * @throws NyARException
		 */
		public function traceLine(i_pos1:NyARIntPoint2d,i_pos2:NyARIntPoint2d,i_edge:int ,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			var base_s:NyARIntSize=this._ref_base_raster.getSize();
			// (i_area*2)の矩形が範囲内に収まるように線を引く
			// 移動量

			// 点間距離を計算
			var dist:int  = (int)(Math.sqrt(i_pos1.sqDist(i_pos2)));
			// 最低AREA*2以上の大きさが無いなら、ラインのトレースは不可能。
			if (dist < 4) {
				return false;
			}
			// dist最大数の決定
			if (dist > 12) {
				dist = 12;
			}
			// サンプリングサイズを決定(移動速度とサイズから)
			var s:int = i_edge * 2 + 1;
			var dx:int = (i_pos2.x - i_pos1.x);
			var dy:int = (i_pos2.y - i_pos1.y);
			var r:int = base_s.w - s;
			var b:int = base_s.h - s;

			// 最大14点を定義して、そのうち両端を除いた点を使用する。
			for (var i:int = 1; i < dist - 1; i++) {
				var x:int = i * dx / dist + i_pos1.x - i_edge;
				var y:int = i * dy / dist + i_pos1.y - i_edge;
				// limit
				coord.items[i - 1].x = x < 0 ? 0 : (x >= r ? r : x);
				coord.items[i - 1].y = y < 0 ? 0 : (y >= b ? b : y);
			}

			coord.length = dist - 2;
			// 点数は20点程度を得る。
			return traceConture_2(coord, 1, s, o_coord);
		}

		public function traceLine_2(i_pos1:NyARDoublePoint2d,i_pos2:NyARDoublePoint2d,i_edge:int,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			var base_s:NyARIntSize=this._ref_base_raster.getSize();
			// (i_area*2)の矩形が範囲内に収まるように線を引く
			// 移動量

			// 点間距離を計算
			var dist:int = (int)(Math.sqrt(i_pos1.sqDist(i_pos2)));
			// 最低AREA*2以上の大きさが無いなら、ラインのトレースは不可能。
			if (dist < 4) {
				return false;
			}
			// dist最大数の決定
			if (dist > 12) {
				dist = 12;
			}
			// サンプリングサイズを決定(移動速度とサイズから)
			var s:int = i_edge * 2 + 1;
			var dx:int = (int) (i_pos2.x - i_pos1.x);
			var dy:int = (int) (i_pos2.y - i_pos1.y);
			var r:int = base_s.w - s;
			var b:int = base_s.h - s;

			// 最大24点を定義して、そのうち両端の2個を除いた点を使用する。
			for (var i:int = 1; i < dist - 1; i++) {
				var x:int = (int) (i * dx / dist + i_pos1.x - i_edge);
				var y:int = (int) (i * dy / dist + i_pos1.y - i_edge);
				// limit
				coord.items[i - 1].x = x < 0 ? 0 : (x >= r ? r : x);
				coord.items[i - 1].y = y < 0 ? 0 : (y >= b ? b : y);
			}

			coord.length = dist - 2;
			// 点数は10点程度を得る。
			return traceConture_2(coord, 1, s, o_coord);
		}
		//ベクトルの類似度判定式
		public static function checkVecCos(i_current_vec:VecLinearCoordinatePoint,i_prev_vec:VecLinearCoordinatePoint,i_ave_dx:Number,i_ave_dy:Number):Boolean
		{
			var x1:Number=i_current_vec.dx;
			var y1:Number=i_current_vec.dy;
			var n:Number=(x1*x1+y1*y1);
			//平均ベクトルとこのベクトルがCOS_DEG_20未満であることを確認(pos_ptr.getAbsVecCos(i_ave_dx,i_ave_dy)<NyARMath.COS_DEG_20 と同じ)
			var d:Number;
			d=(x1*i_ave_dx+y1*i_ave_dy)/NyARMath.COS_DEG_20;
			if(d*d<(n*(i_ave_dx*i_ave_dx+i_ave_dy*i_ave_dy))){
				//隣接ベクトルとこのベクトルが5度未満であることを確認(pos_ptr.getAbsVecCos(i_prev_vec)<NyARMath.COS_DEG_5と同じ)
				d=(x1*i_prev_vec.dx+y1*i_prev_vec.dy)/NyARMath.COS_DEG_5;
				if(d*d<n*(i_prev_vec.dx*i_prev_vec.dx+i_prev_vec.dy*i_prev_vec.dy)){
					return true;
				}
			}
			return false;
		}
		/**
		 * 輪郭線を取得します。
		 * 取得アルゴリズムは、以下の通りです。
		 * 1.輪郭座標(n)の画素周辺の画素ベクトルを取得。
		 * 2.輪郭座標(n+1)周辺の画素ベクトルと比較。
		 * 3.差分が一定以下なら、座標と強度を保存
		 * 4.3点以上の集合になったら、最小二乗法で直線を計算。
		 * 5.直線の加重値を個々の画素ベクトルの和として返却。
		 */
		public function traceConture_2(i_coord:NyARIntCoordinates,i_pos_mag:int,i_cell_size:int ,o_coord: VecLinearCoordinates):Boolean
		{
			var pos:Vector.<VecLinearCoordinatePoint>=this._tmp_coord_pos;
			// ベクトル化
			var MAX_COORD:int = o_coord.items.length;
			var i_coordlen:int = i_coord.length;
			var coord:Vector.<NyARIntPoint2d> = i_coord.items;
			var pos_ptr:VecLinearCoordinatePoint;

			//0個目のライン探索
			var number_of_data:int = 0;
			var sq:Number;
			var sq_sum:int=0;
			//0番目のピクセル
			pos[0].scalar=sq=this.getAreaVector33(coord[0].x * i_pos_mag, coord[0].y * i_pos_mag,i_cell_size, i_cell_size,pos[0]);
			sq_sum+=int(sq);
			//[2]に0を保管

			//1点目だけは前方と後方、両方に探索をかける。
			//前方探索の終点
			var coord_last_edge:int=i_coordlen;
			//後方探索
			var sum:int=1;
			var ave_dx:Number=pos[0].dx;
			var ave_dy:Number = pos[0].dy;
			var i:int;
			for (i = i_coordlen-1; i >0; i--)
			{
				// ベクトル取得
				pos_ptr=pos[sum];
				pos_ptr.scalar=sq=this.getAreaVector33(coord[i].x * i_pos_mag,coord[i].y * i_pos_mag, i_cell_size, i_cell_size,pos_ptr);
				sq_sum+=int(sq);
				// 類似度判定
				if(checkVecCos(pos[sum],pos[sum-1],ave_dx,ave_dy))
				{
					//相関なし->前方探索へ。
					ave_dx=pos_ptr.dx;
					ave_dy=pos_ptr.dy;
					coord_last_edge=i;
					break;
				} else {
					//相関あり- 点の蓄積
					ave_dx+=pos_ptr.dx;
					ave_dy+=pos_ptr.dy;
					sum++;
				}
			}
			//前方探索
			for (i = 1; i<coord_last_edge; i++)
			{
				// ベクトル取得
				pos_ptr=pos[sum];
				pos_ptr.scalar=sq=this.getAreaVector33(coord[i].x * i_pos_mag,coord[i].y * i_pos_mag, i_cell_size, i_cell_size,pos_ptr);
				sq_sum+=int(sq);			
				if(sq==0){
					continue;
				}
				//if (pos_ptr.getAbsVecCos(pos[sum-1]) < NyARMath.COS_DEG_5 && pos_ptr.getAbsVecCos(ave_dx,ave_dy)<NyARMath.COS_DEG_20) {
				if (checkVecCos(pos[sum],pos[sum-1],ave_dx,ave_dy)) {
					//相関なし->新しい要素を作る。
					if(this.leastSquaresWithNormalize(pos,sum,o_coord.items[number_of_data],sq_sum/(sum*5))){
						number_of_data++;
					}
					ave_dx=pos_ptr.dx;
					ave_dy=pos_ptr.dy;
					//獲得した値を0へ移動
					pos[0].setValue(pos[sum]);
					sq_sum=0;
					sum=1;
				} else {
					//相関あり- 点の蓄積
					ave_dx+=pos_ptr.dx;
					ave_dy+=pos_ptr.dy;				
					sum++;
				}
				// 輪郭中心を出すための計算
				if (number_of_data == MAX_COORD) {
					// 輪郭ベクトルバッファの最大を超えたら失敗
					return false;
				}
			}
			if(this.leastSquaresWithNormalize(pos,sum,o_coord.items[number_of_data],sq_sum/(sum*5))){
				number_of_data++;
			}
			// ベクトル化2:最後尾と先頭の要素が似ていれば連結する。
			// sq_distの合計を計算
			o_coord.length = number_of_data;

			return true;
		}
		/**
		 * ノイズらしいベクトルを無視しながら最小二乗法でベクトルを統合する関数
		 * @param i_points
		 * @param i_number_of_data
		 * @param o_dest
		 * @param i_scale_th
		 * @return
		 */
		private function leastSquaresWithNormalize(i_points:Vector.<VecLinearCoordinatePoint>,i_number_of_data:int,o_dest:VecLinearCoordinatePoint,i_scale_th:Number):Boolean
		{
			var i:int;
			var num:int=0;
			var sum_xy:Number = 0, sum_x:Number = 0, sum_y:Number = 0, sum_x2:Number = 0;
			for (i=i_number_of_data-1; i>=0; i--){
				var ptr:VecLinearCoordinatePoint=i_points[i];
				//規定より小さいスケールは除外なう
				if(ptr.scalar<i_scale_th)
				{
					continue;
				}
				var xw:Number=ptr.x;
				sum_xy += xw * ptr.y;
				sum_x += xw;
				sum_y += ptr.y;
				sum_x2 += xw*xw;
				num++;
			}
			if(num<3){
				return false;
			}
			var la:Number=-(num * sum_x2 - sum_x*sum_x);
			var lb:Number=-(num * sum_xy - sum_x * sum_y);
			var cc:Number=(sum_x2 * sum_y - sum_xy * sum_x);
			var lc:Number=-(la*sum_x+lb*sum_y)/num;
			//交点を計算
			var w1:Number = -lb * lb - la * la;
			if (w1 == 0.0) {
				return false;
			}		
			o_dest.x=((la * lc - lb * cc) / w1);
			o_dest.y= ((la * cc +lb * lc) / w1);
			o_dest.dy=-lb;
			o_dest.dx=-la;
			o_dest.scalar=num;
			return true;
		}	

		private var __pt:Vector.<NyARIntPoint2d> = NyARIntPoint2d.createArray(2);
		private var __temp_l:NyARLinear = new NyARLinear();

		/**
		 * クリッピング付きのライントレーサです。
		 * 
		 * @param i_pos1
		 * @param i_pos2
		 * @param i_edge
		 * @param o_coord
		 * @return
		 * @throws NyARException
		 */
		public function traceLineWithClip(i_pos1:NyARDoublePoint2d,i_pos2:NyARDoublePoint2d, i_edge:int , o_coord:VecLinearCoordinates ):Boolean
		{
			var s:NyARIntSize=this._ref_base_raster.getSize();
			var is_p1_inside_area:Boolean, is_p2_inside_area:Boolean;

			var pt:Vector.<NyARIntPoint2d> = this.__pt;
			// 線分が範囲内にあるかを確認
			is_p1_inside_area = s.isInnerPoint_2(i_pos1);
			is_p2_inside_area = s.isInnerPoint_2(i_pos2);
			// 個数で分岐
			if (is_p1_inside_area && is_p2_inside_area) {
				// 2ならクリッピング必要なし。
				if (!this.traceLine_2(i_pos1, i_pos2, i_edge, o_coord)) {
					return false;
				}
				return true;

			}
			// 1,0個の場合は、線分を再定義
			if (!this.__temp_l.makeLinearWithNormalize_2(i_pos1, i_pos2)) {
				return false;
			}
			if (!this.__temp_l.makeSegmentLine(s.w,s.h,pt)) {
				return false;
			}
			if (is_p1_inside_area != is_p2_inside_area) {
				// 1ならクリッピング後に、外に出ていた点に近い輪郭交点を得る。

				if (is_p1_inside_area) {
					// p2が範囲外
					pt[(i_pos2.sqDist_2(pt[0]) < i_pos2.sqDist_2(pt[1])) ? 1 : 0].setValue_2(i_pos1);
				} else {
					// p1が範囲外
					pt[(i_pos1.sqDist_2(pt[0]) < i_pos2.sqDist_2(pt[1])) ? 1 : 0].setValue_2(i_pos2);
				}
			} else {
				// 0ならクリッピングして得られた２点を使う。
				if (!this.__temp_l.makeLinearWithNormalize_2(i_pos1, i_pos2)) {
					return false;
				}
				if (!this.__temp_l.makeSegmentLine(s.w,s.h, pt)) {
					return false;
				}
			}
			if (!this.traceLine(pt[0], pt[1], i_edge, o_coord)) {
				return false;
			}

			return true;
		}
	}
}