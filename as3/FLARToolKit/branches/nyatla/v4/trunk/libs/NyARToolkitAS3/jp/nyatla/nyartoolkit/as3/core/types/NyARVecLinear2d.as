package jp.nyatla.nyartoolkit.as3.core.types 
{
	/**
	 * 定点と傾きのパラメータで、直線を表現します。
	 *
	 */
	public class NyARVecLinear2d
	{
		public var x:Number;
		public var y:Number;
		public var dx:Number;
		public var dy:Number;
		public static function createArray(i_length:int):Vector.<NyARVecLinear2d>
		{
			var r:Vector.<NyARVecLinear2d>=new Vector.<NyARVecLinear2d>(i_length);
			for(var i:int=0;i<i_length;i++){
				r[i]=new NyARVecLinear2d();
			}
			return r;
		}
		/**
		 * 法線ベクトルを計算します。
		 * @param i_src
		 * 元のベクトルを指定します。この値には、thisを指定できます。
		 */
		public function normalVec(i_src:NyARVecLinear2d):void
		{
			var w:Number=this.dx;
			this.dx=i_src.dy;
			this.dy=-w;
		}
		public function setValue(i_value:NyARVecLinear2d):void
		{
			this.dx=i_value.dx;
			this.dy=i_value.dy;
			this.x=i_value.x;
			this.y=i_value.y;
		}
		/**
		 * このベクトルと指定した直線が作るCos値を返します。
		 * @param i_v1
		 * @return
		 */
		public function getVecCos(i_v1:NyARVecLinear2d):Number
		{
			var x1:Number=i_v1.dx;
			var y1:Number=i_v1.dy;
			var x2:Number=this.dx;
			var y2:Number=this.dy;
			var d:Number=(x1*x2+y1*y2)/Math.sqrt((x1*x1+y1*y1)*(x2*x2+y2*y2));
			return d;
		}
		/**
		 * このベクトルと指定したベクトルが作るCos値を返します。
		 * @param i_dx
		 * @param i_dy
		 * @return
		 */
		public function getVecCos_2(i_dx:Number,i_dy:Number):Number
		{
			var x1:Number=this.dx;
			var y1:Number=this.dy;
			var d:Number=(x1*i_dx+y1*i_dy)/Math.sqrt((x1*x1+y1*y1)*(i_dx*i_dx+i_dy*i_dy));
			return d;
		}		
		public function getAbsVecCos(i_v1:NyARVecLinear2d):Number
		{
			var x1:Number=i_v1.dx;
			var y1:Number=i_v1.dy;
			var x2:Number=this.dx;
			var y2:Number=this.dy;
			var d:Number=(x1*x2+y1*y2)/Math.sqrt((x1*x1+y1*y1)*(x2*x2+y2*y2));
			return d>=0?d:-d;
		}

		public function getAbsVecCos_2(i_v2_x:Number,i_v2_y:Number):Number
		{
			var x1:Number=this.dx;
			var y1:Number=this.dy;
			var d:Number=(x1*i_v2_x+y1*i_v2_y)/Math.sqrt((x1*x1+y1*y1)*(i_v2_x*i_v2_x+i_v2_y*i_v2_y));
			return d>=0?d:-d;
		}
		/**
		 * このベクトルと、i_pos1とi_pos2を結ぶ線分が作るcos値の絶対値を返します。
		 * @param i_pos1
		 * @param i_pos2
		 * @return
		 */
		public function getAbsVecCos_3(i_pos1:NyARDoublePoint2d,i_pos2:NyARDoublePoint2d):Number
		{
			var d:Number=getAbsVecCos_2(i_pos2.x-i_pos1.x,i_pos2.y-i_pos1.y);
			return d>=0?d:-d;
		}
		
		/**
		 * 交点を求めます。
		 * @param i_vector1
		 * @param i_vector2
		 * @param o_point
		 * @return
		 */
		public function crossPos(i_vector1:NyARVecLinear2d,o_point:NyARDoublePoint2d):Boolean
		{
			var a1:Number= i_vector1.dy;
			var b1:Number=-i_vector1.dx;
			var c1:Number=(i_vector1.dx*i_vector1.y-i_vector1.dy*i_vector1.x);
			var a2:Number= this.dy;
			var b2:Number=-this.dx;
			var c2:Number=(this.dx*this.y-this.dy*this.x);
			var w1:Number = a1 * b2 - a2 * b1;
			if (w1 == 0.0) {
				return false;
			}
			o_point.x = (b1 * c2 - b2 * c1) / w1;
			o_point.y = (a2 * c1 - a1 * c2) / w1;
			return true;
		}
		/**
		 * 直線と、i_sp1とi_sp2の作る線分との二乗距離値の合計を返します。
		 * 線分と直線の類似度を
		 * @param i_sp1
		 * @param i_sp2
		 * @param o_point
		 * @return
		 * 距離が取れないときは無限大です。
		 */
		public function sqDistBySegmentLineEdge(i_sp1:NyARDoublePoint2d,i_sp2:NyARDoublePoint2d):Number
		{
			var sa:Number,sb:Number,sc:Number;
			sa= this.dy;
			sb=-this.dx;
			sc=(this.dx*this.y-this.dy*this.x);
			

			var lc:Number;
			var x:Number,y:Number,w1:Number;
			//thisを法線に変換

			//交点を計算
			w1 = sa * (-sa) - sb * sb;
			if (w1 == 0.0) {
				return Number.POSITIVE_INFINITY;
			}
			//i_sp1と、i_linerの交点
			lc=-(sb*i_sp1.x-sa*i_sp1.y);
			x = ((sb * lc +sa * sc) / w1)-i_sp1.x;
			y = ((sb * sc - sa * lc) / w1)-i_sp1.y;
			var sqdist:Number=x*x+y*y;

			lc=-(sb*i_sp2.x-sa*i_sp2.y);
			x = ((sb * lc + sa * sc) / w1)-i_sp2.x;
			y = ((sb * sc - sa * lc) / w1)-i_sp2.y;

			return sqdist+x*x+y*y;
		}

		/**
		 * i_lineの直線をセットします。x,yの値は、(i_x,i_y)を通過するi_lineの法線とi_lineの交点をセットします。
		 * @param i_line
		 * @param i_x
		 * @param i_y
		 */
		public function setLinear(i_line:NyARLinear,i_x:Number,i_y:Number):Boolean
		{
			var la:Number=i_line.b;
			var lb:Number=-i_line.a;
			var lc:Number=-(la*i_x+lb*i_y);
			//交点を計算
			var w1:Number = -lb * lb - la * la;
			if (w1 == 0.0) {
				return false;
			}		
			this.x=((la * lc - lb * i_line.c) / w1);
			this.y= ((la * i_line.c +lb * lc) / w1);
			this.dy=-lb;
			this.dx=-la;
			return true;
		}
		/**
		 * 点群から最小二乗法で直線を計算してセットします。
		 * 通過点x,yは、点群の中央値を通過する、算出された直線の法線との交点です。
		 * @param i_points
		 * @param i_number_of_data
		 * @return
		 */
		public function leastSquares( i_points:Vector.<NyARDoublePoint2d> , i_number_of_data:int ):Boolean
		{
			var i:int ;
			var sum_xy:Number = 0 , sum_x:Number = 0 , sum_y:Number = 0 , sum_x2:Number = 0 ;
			for( i = 0 ; i < i_number_of_data ; i++ ) {
				var ptr:NyARDoublePoint2d = i_points[i] ;
				var xw:Number = ptr.x ;
				sum_xy += xw * ptr.y ;
				sum_x += xw ;
				sum_y += ptr.y ;
				sum_x2 += xw * xw ;
			}
			var la:Number = -(i_number_of_data * sum_x2 - sum_x * sum_x) ;
			var lb:Number = -(i_number_of_data * sum_xy - sum_x * sum_y) ;
			var cc:Number = ( sum_x2 * sum_y - sum_xy * sum_x ) ;
			var lc:Number = -(la * sum_x + lb * sum_y) / i_number_of_data ;
			var w1:Number = -lb * lb - la * la ;
			if( w1 == 0.0 ) {
				return false ;
			}
			
			this.x = ( ( la * lc - lb * cc ) / w1 ) ;
			this.y = ( ( la * cc + lb * lc ) / w1 ) ;
			this.dy = -lb ;
			this.dx = -la ;
			return true ;
		}

		/**
		 * 正規化したベクトルを出力する{@link #leastSquares}です。
		 * @param i_points
		 * @param i_number_of_data
		 * @return
		 */
		public function leastSquaresWithNormalize( i_points:Vector.<NyARDoublePoint2d> , i_number_of_data:int ):Boolean
		{
			var ret:Boolean = this.leastSquares(i_points , i_number_of_data) ;
			var sq:Number = 1 / Math.sqrt(this.dx * this.dx + this.dy * this.dy) ;
			this.dx *= sq ;
			this.dy *= sq ;
			return ret ;
		}


	}

}