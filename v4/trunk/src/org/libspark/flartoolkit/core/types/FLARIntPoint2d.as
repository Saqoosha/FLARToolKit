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
package org.libspark.flartoolkit.core.types 
{
	/**
	 * int型の二次元の点を格納します。
	 *
	 */
	public class FLARIntPoint2d
	{
		public var x:int;

		public var y:int;
		/**
		 * 配列ファクトリ
		 * @param i_number
		 * @return
		 */
		public static function createArray(i_number:int):Vector.<FLARIntPoint2d>
		{
			var ret:Vector.<FLARIntPoint2d>=new Vector.<FLARIntPoint2d>(i_number);
			for(var i:int=0;i<i_number;i++)
			{
				ret[i]=new FLARIntPoint2d();
			}
			return ret;
		}
		/**
		 * i_fromからi_toへ配列をコピーします。
		 * @param i_from
		 * @param i_to
		 */
		public static function copyArray(i_from:Vector.<FLARIntPoint2d>,i_to:Vector.<FLARIntPoint2d>):void
		{
			for(var i:int=i_from.length-1;i>=0;i--)
			{
				i_to[i].x=i_from[i].x;
				i_to[i].y=i_from[i].y;
			}
			return;
		}
		public function sqDist( i_p1:FLARIntPoint2d ):int
		{ 
			var x:int = this.x - i_p1.x ;
			var y:int = this.y - i_p1.y ;
			return x * x + y * y ;
		}
		
		public function setCenterPos( i_point:Vector.<FLARIntPoint2d> , i_number_of_vertex:int ):void
		{ 
			var cx:int , cy:int ;
			cx = cy = 0 ;
			for( var i:int = i_number_of_vertex - 1 ; i >= 0 ; i-- ) {
				cx += i_point[i].x ;
				cy += i_point[i].y ;
			}
			this.x = cx / i_number_of_vertex ;
			this.y = cy / i_number_of_vertex ;
		}
		
		public function setValue( i_source:FLARIntPoint2d ):void
		{ 
			this.x = i_source.x ;
			this.y = i_source.y ;
		}
		
		public function setValue_2( i_source:FLARDoublePoint2d ):void
		{ 
			this.x = int(i_source.x) ;
			this.y = int(i_source.y) ;
		}
		
		public function setValue_3( i_x:int , i_y:int ):void
		{ 
			this.x = i_x ;
			this.y = i_y ;
		}
		public static function shiftCopy(i_src:Vector.<FLARDoublePoint2d>,i_dst:Vector.<FLARIntPoint2d>,i_shift:int):void
		{
			var l:int=i_src.length;
			for(var i:int=l-1;i>=0;i--){
				var n:int=(i+i_shift)%l;
				i_dst[i].x=int(i_src[n].x);
				i_dst[i].y=int(i_src[n].y);
			}		
		}
		public static function shiftCopy_2(i_src:Vector.<FLARIntPoint2d>,i_dst:Vector.<FLARIntPoint2d>,i_shift:int):void
		{
			var l:int=i_src.length;
			for(var i:int=l-1;i>=0;i--){
				var n:int=(i+i_shift)%l;
				i_dst[i].x=i_src[n].x;
				i_dst[i].y=i_src[n].y;
			}		
		}
		/**
		 * この関数は、頂点集合から、中央値(Σp[n]/n)を求めます。
		 * @param i_points
		 * 頂点集合を格納した配列です。
		 * @param i_number_of_data
		 * 配列中の有効な頂点数です。
		 * @param o_out
		 * 中央値を受け取るオブジェクトです。
		 * @deprecated
		 * {@link #setCenterPos(FLARIntPoint2d[], int)を使用してください。
		 */
		public static function makeCenter(i_points:Vector.<FLARIntPoint2d>,i_number_of_data:int,o_out:FLARIntPoint2d):void
		{
			o_out.setCenterPos(i_points,i_number_of_data);
		}		
	}


}