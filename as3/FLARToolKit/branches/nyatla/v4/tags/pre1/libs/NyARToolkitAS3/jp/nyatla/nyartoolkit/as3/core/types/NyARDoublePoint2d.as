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
	import jp.nyatla.nyartoolkit.as3.core.*;
	/**
	 * データ型です。
	 * 2次元の浮動小数点方の点を格納します。
	 */
	public class NyARDoublePoint2d
	{
		public var x:Number;
		public var y:Number;
		/**
		 * 配列ファクトリ
		 * @param i_number
		 * @return
		 */
		public static function createArray(i_number:int):Vector.<NyARDoublePoint2d>
		{
			var ret:Vector.<NyARDoublePoint2d>=new Vector.<NyARDoublePoint2d>(i_number);
			for(var i:int=0;i<i_number;i++)
			{
				ret[i]=new NyARDoublePoint2d();
			}
			return ret;
		}
		public function NyARDoublePoint2d(...args:Array)
		{
			switch(args.length) {
			case 0:
				{//public function NyARDoublePoint2d()
					this.x = 0;
					this.y = 0;
				}
				return;
			case 1:
				if(args[0] is NyARDoublePoint2d)
				{
					//public function NyARDoublePoint2d(i_src:NyARDoublePoint2d)
					this.x=args[0].x;
					this.y=args[0].y;
					return;
				}else if (args[0] is NyARIntPoint2d)
				{
					//public function NyARDoublePoint2d(i_src:NyARIntPoint2d)
					this.x=(Number)(args[0].x);
					this.y=(Number)(args[0].y);
					return;
				}
				break;
			case 2:
				{	//public function NyARDoublePoint2d(i_x:Number,i_y:Number)
					this.x = Number(args[0]);
					this.y = Number(args[1]);
					return;
				}
			default:
				break;
			}
			throw new NyARException();
		}
		/**
		 * p2-p1間の距離の二乗値を計算します。
		 * @param i_p1
		 * @param i_p2
		 * @return
		 */	
		public function sqDist( i_p1:NyARDoublePoint2d):Number
		{
			var x:Number,y:Number;
			x=this.x-i_p1.x;
			y=this.y-i_p1.y;
			return x*x+y*y;
		}
		public function sqDist_2(i_p1:NyARIntPoint2d):Number
		{
			var x:Number,y:Number;
			x=this.x-i_p1.x;
			y=this.y-i_p1.y;
			return x*x+y*y;
		}
		public static function crossProduct3Point( p1:NyARDoublePoint2d , p2:NyARDoublePoint2d , p3:NyARDoublePoint2d ):Number
		{
			return ( p2.x - p1.x ) * ( p3.y - p2.y ) - ( p2.y - p1.y ) * ( p3.x - p2.x ) ;
		}
	
		public static function crossProduct3Point_2( p1:NyARDoublePoint2d , p2:NyARDoublePoint2d , p3_x:Number , p3_y:Number ):Number
		{
			return ( p2.x - p1.x ) * ( p3_y - p2.y ) - ( p2.y - p1.y ) * ( p3_x - p2.x ) ;
		}
	
		public static function makeCenter( i_points:Vector.<NyARDoublePoint2d> , i_number_of_data:int , o_out:NyARDoublePoint2d ):void
		{
			var x:Number , y:Number ;
			x = y = 0 ;
			for( var i:int = i_number_of_data - 1 ; i >= 0 ; i-- ) {
				x += i_points[i].x ;
				y += i_points[i].y ;
			}
			o_out.x = x / i_number_of_data ;
			o_out.x = y / i_number_of_data ;
		}
		
		public static function makeCenter_2( i_points:Vector.<NyARDoublePoint2d> , i_number_of_data:int , o_out:NyARIntPoint2d ):void
		{
			var lx:Number , ly:Number ;
			lx = ly = 0 ;
			for( var i:int = i_number_of_data - 1 ; i >= 0 ; i-- ) {
				lx += i_points[i].x ;
				ly += i_points[i].y ;
			}
			o_out.x = int(( lx / i_number_of_data )) ;
			o_out.y = int(( ly / i_number_of_data )) ;
		}
	
	
		public function setValue(i_src:NyARDoublePoint2d):void
		{
			this.x=i_src.x;
			this.y=i_src.y;
			return;
		}
		public function setValue_2(i_src:NyARIntPoint2d):void
		{
			this.x=Number(i_src.x);
			this.y=Number(i_src.y);
			return;
		}
		public function setValue_3(x:Number,y:Number):void
		{
			this.x=x;
			this.y=y;
			return;
		}

		public function sqNorm():Number
		{
			return this.x*this.x+this.y+this.y;
		}
		/**
		 * この関数は、頂点を移動します。
		 * @param i_tx
		 * 移動する距離x
		 * @param i_ty
		 * 移動する距離y
		 */
		public function translate(i_tx:Number,i_ty:Number):void
		{
			this.x+=i_tx;
			this.y+=i_ty;
		}
	}

}