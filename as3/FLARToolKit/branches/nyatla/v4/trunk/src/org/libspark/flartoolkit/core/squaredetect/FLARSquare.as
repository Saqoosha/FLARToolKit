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
package jp.nyatla.nyartoolkit.as3.core.squaredetect
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * ARMarkerInfoに相当するクラス。 矩形情報を保持します。
	 * 
	 */
	public class NyARSquare
	{
		public var line:Vector.<NyARLinear> = NyARLinear.createArray(4);
		public var sqvertex:Vector.<NyARDoublePoint2d>= NyARDoublePoint2d.createArray(4);
		/**
		 * 中心点を計算します。
		 * @param o_out
		 * 結果を格納するバッファ。
		 */
		public function getCenter2d(o_out:NyARDoublePoint2d):void
		{
			o_out.x=(this.sqvertex[0].x+this.sqvertex[1].x+this.sqvertex[2].x+this.sqvertex[3].x)/4;
			o_out.y=(this.sqvertex[0].y+this.sqvertex[1].y+this.sqvertex[2].y+this.sqvertex[3].y)/4;
			return;
		}
		public function checkVertexShiftValue( i_square:NyARSquare ):int
		{ 
			var a:Vector.<NyARDoublePoint2d> = this.sqvertex ;
			var b:Vector.<NyARDoublePoint2d> = i_square.sqvertex ;
			var min_dist:int = int.MAX_VALUE ;
			var min_index:int = 0 ;
			var xd:int , yd:int ;
			for( var i:int = 3 ; i >= 0 ; i-- ) {
				var d:int = 0 ;
				for( var i2:int = 3 ; i2 >= 0 ; i2-- ) {
					xd = int(( a[i2].x - b[( i2 + i ) % 4].x )) ;
					yd = int(( a[i2].y - b[( i2 + i ) % 4].y )) ;
					d += xd * xd + yd * yd ;
				}
				if( min_dist > d ) {
					min_dist = d ;
					min_index = i ;
				}
				
			}
			return min_index ;
		}
		
		private static const _gcd_table4:Vector.<int>=Vector.<int>([ -1 , 1 , 2 , 1 ]); 
		public function rotateVertexL( i_shift:int ):void
		{ 
			//assert( ! (( i_shift < 4 ) ) );
			var vertext:NyARDoublePoint2d ;
			var linet:NyARLinear ;
			if( i_shift == 0 ) {
				return  ;
			}
			
			var t1:int , t2:int ;
			var d:int , i:int , j:int , mk:int ;
			var ll:int = 4 - i_shift ;
			d = _gcd_table4[ll] ;
			mk = ( 4 - ll ) % 4 ;
			for( i = 0 ; i < d ; i++ ) {
				linet = this.line[i] ;
				vertext = this.sqvertex[i] ;
				for( j = 1 ; j < 4 / d ; j++ ) {
					t1 = ( i + ( j - 1 ) * mk ) % 4 ;
					t2 = ( i + j * mk ) % 4 ;
					this.line[t1] = this.line[t2] ;
					this.sqvertex[t1] = this.sqvertex[t2] ;
				}
				t1 = ( i + ll ) % 4 ;
				this.line[t1] = linet ;
				this.sqvertex[t1] = vertext ;
			}
		}
	}
}