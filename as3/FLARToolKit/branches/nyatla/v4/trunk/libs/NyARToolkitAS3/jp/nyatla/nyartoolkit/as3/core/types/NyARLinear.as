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
package jp.nyatla.nyartoolkit.as3.core.types
{

	/**
	 * 0=a*x+b*y+cのパラメータを格納します。
	 * x,yの増加方向は、x=L→R,y=B→Tです。 y軸が反転しているので注意してください。
	 *
	 */
	public class NyARLinear
	{
		public var b:Number;//係数b
		public var a:Number;//係数a
		public var c:Number;//切片
		public static function createArray(i_number:int):Vector.<NyARLinear>
		{
			var ret:Vector.<NyARLinear>=new Vector.<NyARLinear>(i_number);
			for(var i:int=0;i<i_number;i++)
			{
				ret[i]=new NyARLinear();
			}
			return ret;
		}	
		public final function copyFrom(i_source:NyARLinear):void
		{
			this.b=i_source.b;
			this.a=i_source.a;
			this.c=i_source.c;
			return;
		}
		/**
		 * 2直線の交点を計算します。
		 * @param l_line_i
		 * @param l_line_2
		 * @param o_point
		 * @return
		 */
		public function crossPos(l_line_2:NyARLinear ,o_point:NyARDoublePoint2d):Boolean
		{
			var w1:Number = this.a * l_line_2.b - l_line_2.a * this.b;
			if (w1 == 0.0) {
				return false;
			}
			o_point.x = (this.b * l_line_2.c - l_line_2.b * this.c) / w1;
			o_point.y = (l_line_2.a * this.c - this.a * l_line_2.c) / w1;
			return true;
		}	
		/**
		 * 指定したパラメータの式との交点を得る。
		 * @param i_a
		 * @param i_b
		 * @param i_c
		 * @param o_point
		 * @return
		 */
		public function crossPos_2(i_a:Number,i_b:Number,i_c:Number,o_point:NyARDoublePoint2d):Boolean
		{
			var w1:Number = this.a * i_b - i_a * this.b;
			if (w1 == 0.0) {
				return false;
			}
			o_point.x = (this.b * i_c - i_b * this.c) / w1;
			o_point.y = (i_a * this.c - this.a * i_c) / w1;
			return true;
		}
		public function crossPos_3(i_a:Number,i_b:Number,i_c:Number,o_point:NyARIntPoint2d):Boolean
		{
			var w1:Number = this.a * i_b - i_a * this.b;
			if (w1 == 0.0) {
				return false;
			}
			o_point.x = (int)((this.b * i_c - i_b * this.c) / w1);
			o_point.y = (int)((i_a * this.c - this.a * i_c) / w1);
			return true;
		}
		/**
		 * 2直線が交差しているかを返します。
		 * @param l_line_2
		 * @return
		 */
		public function isCross(l_line_2:NyARLinear):Boolean
		{
			var w1:Number = this.a * l_line_2.b - l_line_2.a * this.b;
			return (w1 == 0.0)?false:true;
		}
		
		/**
		 * ２点を結ぶ直線の式を得る。この式は正規化されている。
		 * @param i_point1
		 * @param i_point2
		 * @return
		 */
		public function makeLinearWithNormalize(i_point1:NyARIntPoint2d,i_point2:NyARIntPoint2d):Boolean
		{
			return makeLinearWithNormalize_3(i_point1.x,i_point1.y,i_point2.x,i_point2.y);
		}
		/**
		 * ２点を結ぶ直線の式を得る。この式は正規化されている。
		 * @param i_point1
		 * @param i_point2
		 * @return
		 */
		public function makeLinearWithNormalize_2(i_point1:NyARDoublePoint2d,i_point2:NyARDoublePoint2d):Boolean
		{
			return makeLinearWithNormalize_3(i_point1.x,i_point1.y,i_point2.x,i_point2.y);
		}
		/**
		 * ２点を結ぶ直線の式を得る。この式は正規化されている。
		 * @param i_point1
		 * @param i_point2
		 * @return
		 */	
		public function makeLinearWithNormalize_3(x1:Number,y1:Number,x2:Number,y2:Number):Boolean
		{
			var dx:Number=y2-y1;
			var dy:Number=x1-x2;
			var sq:Number=Math.sqrt(dx*dx+dy*dy);
			if(sq==0){
				return false;
			}
			sq=1/sq;
			this.a=dx*sq;
			this.b=dy*sq;
			this.c=(x1*(y1-y2)+y1*(x2-x1))*sq;
			return true;
		}
		/**
		 * 傾きと通過点を入力して、その直線式をセットする。
		 * @param i_dx
		 * @param i_dy
		 * @param i_x
		 * @param i_y
		 */
		public function setVector(i_dx:Number,i_dy:Number,i_x:Number,i_y:Number):void
		{
			this.a= i_dy;
			this.b=-i_dx;
			this.c=(i_dx*i_y-i_dy*i_x);
			return;
		}
		public function setVector_2(i_vector:NyARVecLinear2d):void
		{
			this.a= i_vector.dy;
			this.b=-i_vector.dx;
			this.c=(i_vector.dx*i_vector.y-i_vector.dy*i_vector.x);
			return;		
		}
		public function setVectorWithNormalize(i_vector:NyARVecLinear2d):Boolean
		{
			var dx:Number=i_vector.dx;
			var dy:Number=i_vector.dy;
			var sq:Number=Math.sqrt(dx*dx+dy*dy);
			if(sq==0){
				return false;
			}
			sq=1/sq;
			this.a= dy*sq;
			this.b=-dx*sq;
			this.c=-(this.a*i_vector.x+this.b*i_vector.y);		
			return true;
		}
		/**
		 * i_x,i_yを通過する、i_linearの法線を計算して、格納します。
		 */
		public function normalLine(i_x:Number,i_y:Number,i_linear:NyARLinear):void
		{
			var la:Number=i_linear.a;
			var lb:Number=i_linear.b;
			this.a=lb;
			this.b=-la;
			this.c=-(lb*i_x-la*i_y);
		}
		/**
		 * i_x,i_yを通るこの直線の法線と、i_linearが交わる点を返します。
		 * @param i_x
		 * @param i_y
		 * @param i_linear
		 * @param o_point
		 * @return
		 */
		public function normalLineCrossPos(i_x:Number,i_y:Number,i_linear:NyARLinear,o_point:NyARDoublePoint2d):Boolean
		{
			//thisを法線に変換
			var la:Number=this.b;
			var lb:Number=-this.a;
			var lc:Number=-(la*i_x+lb*i_y);
			//交点を計算
			var w1:Number = i_linear.a * lb - la * i_linear.b;
			if (w1 == 0.0) {
				return false;
			}
			o_point.x = ((i_linear.b * lc - lb * i_linear.c) / w1);
			o_point.y = ((la * i_linear.c - i_linear.a * lc) / w1);
			return true;
		}


		/**
		 * この矩形を任意の範囲でクリッピングしたときの2頂点を返します。
		 * @param i_width
		 * @param i_height
		 * @param o_point
		 * @return
		 */
		public function makeSegmentLine(i_width:int,i_height:int,o_point:Vector.<NyARIntPoint2d>):Boolean
		{	
			var idx:int=0;
			var ptr:NyARIntPoint2d=o_point[0];
			if(this.crossPos_3(0,-1,0,ptr) && ptr.x>=0 && ptr.x<i_width)
			{
				//y=rect.yの線
				idx++;
				ptr=o_point[idx];
			}
			if(this.crossPos_3(0,-1,i_height-1,ptr) && ptr.x>=0 && ptr.x<i_width)
			{
				//y=(rect.y+rect.h-1)の線
				idx++;
				if(idx==2){
					return true;
				}
				ptr=o_point[idx];
			}
			if(this.crossPos_3(-1,0,0,ptr) && ptr.y>=0 && ptr.y<i_height)
			{
				//x=i_leftの線
				idx++;
				if(idx==2){
					return true;
				}
				ptr=o_point[idx];
			}
			if(this.crossPos_3(-1,0,i_width-1, ptr) && ptr.y>=0 && ptr.y<i_height)
			{
				//x=i_right-1の線
				idx++;
				if(idx==2){
					return true;
				}
			}
			return false;
		}	
		/**
		 * この直線を、任意の矩形でクリッピングしたときに得られる線分の2頂点を返します。
		 * @param i_left
		 * @param i_top
		 * @param i_width
		 * @param i_height
		 * @param o_point
		 * @return
		 */
		public function makeSegmentLine_2(i_left:int,i_top:int,i_width:int,i_height:int,o_point:Vector.<NyARIntPoint2d>):Boolean
		{	
			var bottom:int=i_top+i_height;
			var right:int=i_left+i_width;
			var idx:int=0;
			var ptr:NyARIntPoint2d=o_point[0];
			if(this.crossPos_3(0,-1,i_top,ptr) && ptr.x>=i_left && ptr.x<right)
			{
				//y=rect.yの線
				idx++;
				ptr=o_point[idx];
			}
			if(this.crossPos_3(0,-1,bottom-1,ptr) && ptr.x>=i_left && ptr.x<right)
			{
				//y=(rect.y+rect.h-1)の線
				idx++;
				if(idx==2){
					return true;
				}
				ptr=o_point[idx];
			}
			if(this.crossPos_3(-1,0,i_left,ptr) && ptr.y>=i_top && ptr.y<bottom)
			{
				//x=i_leftの線
				idx++;
				if(idx==2){
					return true;
				}
				ptr=o_point[idx];
			}
			if(this.crossPos_3(-1,0,right-1, ptr) && ptr.y>=i_top && ptr.y<bottom)
			{
				//x=i_right-1の線
				idx++;
				if(idx==2){
					return true;
				}
			}
			return false;
		}
		/**
		 * 直線と、i_sp1とi_sp2の作る線分との二乗距離値の合計を返します。計算方法は、線分の２端点を通過する直線の法線上での、２端点と直線の距離の合計です。
		 * 線分と直線の類似度を判定する数値になります。
		 * @param i_sp1
		 * @param i_sp2
		 * @param o_point
		 * @return
		 * 距離が取れないときは無限大です。
		 */
		public function sqDistBySegmentLineEdge(i_sp1:NyARDoublePoint2d,i_sp2:NyARDoublePoint2d):Number
		{
			var la:Number,lb:Number,lc:Number;
			var x:Number,y:Number,w1:Number;
			//thisを法線に変換
			la=this.b;
			lb=-this.a;

			//交点を計算
			w1 = this.a * lb - la * this.b;
			if (w1 == 0.0) {
				return Number.POSITIVE_INFINITY;
			}
			//i_sp1と、i_linerの交点
			lc=-(la*i_sp1.x+lb*i_sp1.y);
			x = ((this.b * lc - lb * this.c) / w1)-i_sp1.x;
			y = ((la * this.c - this.a * lc) / w1)-i_sp1.y;
			var sqdist:Number=x*x+y*y;

			lc=-(la*i_sp2.x+lb*i_sp2.y);
			x = ((this.b * lc - lb * this.c) / w1)-i_sp2.x;
			y = ((la * this.c - this.a * lc) / w1)-i_sp2.y;

			return sqdist+x*x+y*y;
		}	
		/**
		 * 最小二乗法を使用して直線を計算します。
		 * @param i_points
		 * @param i_number_of_data
		 * @return
		 */
		public function leastSquares(i_points:Vector.<NyARDoublePoint2d>,i_number_of_data:int):Boolean
		{
			//assert(i_number_of_data>1);
			var i:int;
			var sum_xy:Number = 0, sum_x:Number = 0, sum_y:Number = 0, sum_x2:Number = 0;
			for (i=0; i<i_number_of_data; i++){
				var ptr:NyARDoublePoint2d=i_points[i];
				var xw:Number=ptr.x;
				sum_xy += xw * ptr.y;
				sum_x += xw;
				sum_y += ptr.y;
				sum_x2 += xw*xw;
			}
			this.b =-(i_number_of_data * sum_x2 - sum_x*sum_x);
			this.a = (i_number_of_data * sum_xy - sum_x * sum_y);
			this.c = (sum_x2 * sum_y - sum_xy * sum_x);
			return true;
		}
	}

}