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
package jp.nyatla.nyartoolkit.as3.core.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	public class NyARMath
	{
		public static const SQ_40:int=40*40;
		public static const SQ_20:int=20*20;
		public static const SQ_10:int=10*10;
		public static const SQ_8:int=8*8;
		public static const SQ_5:int=5*5;
		public static const SQ_2:int=2*2;

		
		public static const COS_DEG_30:Number=0.8660;
		public static const COS_DEG_25:Number=0.9063;
		public static const COS_DEG_20:Number=0.9396;
		public static const COS_DEG_15:Number=0.9395;
		public static const COS_DEG_10:Number=0.9848;
		public static const COS_DEG_8:Number =0.9902;
		public static const COS_DEG_5:Number =0.9961;
		public static function sqNorm(i_p1x:Number,i_p1y:Number,i_p2x:Number,i_p2y:Number):Number
		{
			var x:Number,y:Number;
			x=i_p2x-i_p1x;
			y=i_p2y-i_p1y;
			return x*x+y*y;
		}
		public static function dist(i_x1:Number,i_y1:Number,i_x2:Number,i_y2:Number):Number
		{
			return Math.sqrt(i_x1*i_y1+i_x2+i_y2);
		}
		/**
		 * 3乗根を求められないシステムで、３乗根を求めます。
		 * http://aoki2.si.gunma-u.ac.jp/JavaScript/src/3jisiki.html
		 * @param i_in
		 * @return
		 */
		public static function cubeRoot(i_in:Number):Number
		{
			var res:Number = Math.pow(Math.abs(i_in), 1.0 / 3.0);
			return (i_in >= 0) ? res : -res;
		}
		/**
		 * ユークリッドの互除法により、2変数の最大公約数を求める。
		 * http://ja.wikipedia.org/wiki/%E3%83%A6%E3%83%BC%E3%82%AF%E3%83%AA%E3%83%83%E3%83%89%E3%81%AE%E4%BA%92%E9%99%A4%E6%B3%95
		 * @param i_x
		 * @param i_y
		 * @return
		 */
		public static function gcd(i_x:int,i_y:int):int
		{
			var x:int=i_x;
			var y:int=i_y;
			var r:int;
			while (y != 0) {
				r = x % y;
				x = y;
				y = r;
			}
			return x;
		}

	}


}