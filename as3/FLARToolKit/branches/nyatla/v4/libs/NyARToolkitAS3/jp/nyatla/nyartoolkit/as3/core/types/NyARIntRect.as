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
	 * 基点x,yと、幅、高さで矩形を定義します。
	 *
	 */
	public class NyARIntRect
	{
		public function NyARIntRect(...args:Array)
		{
			switch(args.length) {
			case 0:
				{	//public function NyARIntRect()
					return;
				}
			case 4:
				{	//public function NyARIntSize(i_ref_object:NyARIntSize)
					override_NyARIntRect_4iiii(int(args[0]), int(args[1]), int(args[2]), int(args[3]));
					return;
				}
				break;
			default:
				break;
			}
			throw new NyARException();
		}
		/**
		 * コンストラクタです。初期値を指定してインスタンスを生成します。
		 * @param i_x
		 * {@link #x}の値
		 * @param i_y
		 * {@link #y}の値
		 * @param i_w
		 * {@link #w}の値
		 * @param i_h
		 * {@link #h}の値
		 */
		public function override_NyARIntRect_4iiii(i_x:int,i_y:int,i_w:int,i_h:int):void
		{
			this.setValue_2(i_x, i_y, i_w, i_h);
		}
		
		public var x:int;
		public var y:int;
		public var w:int;
		public var h:int;
		public function setAreaRect( i_vertex:Vector.<NyARDoublePoint2d> , i_num_of_vertex:int ):void
		{ 
			var xmax:int , xmin:int , ymax:int , ymin:int ;
			xmin = xmax = int(i_vertex[i_num_of_vertex - 1].x) ;
			ymin = ymax = int(i_vertex[i_num_of_vertex - 1].y) ;
			for( var i:int = i_num_of_vertex - 2 ; i >= 0 ; i-- ) {
				if( i_vertex[i].x < xmin ) {
					xmin = int(i_vertex[i].x) ;
				}
				else if( i_vertex[i].x > xmax ) {
					xmax = int(i_vertex[i].x) ;
				}
				
				if( i_vertex[i].y < ymin ) {
					ymin = int(i_vertex[i].y) ;
				}
				else if( i_vertex[i].y > ymax ) {
					ymax = int(i_vertex[i].y) ;
				}
				
			}
			this.h = ymax - ymin + 1 ;
			this.x = xmin ;
			this.w = xmax - xmin + 1 ;
			this.y = ymin ;
		}
	
		public function setAreaRect_2(i_vertex:Vector.<NyARIntPoint2d> , i_num_of_vertex:int ):void
		{ 
			var xmax:int , xmin:int , ymax:int , ymin:int ;
			xmin = xmax = int(i_vertex[i_num_of_vertex - 1].x) ;
			ymin = ymax = int(i_vertex[i_num_of_vertex - 1].y) ;
			for( var i:int = i_num_of_vertex - 2 ; i >= 0 ; i-- ) {
				if( i_vertex[i].x < xmin ) {
					xmin = int(i_vertex[i].x) ;
				}
				else if( i_vertex[i].x > xmax ) {
					xmax = int(i_vertex[i].x) ;
				}
				
				if( i_vertex[i].y < ymin ) {
					ymin = int(i_vertex[i].y) ;
				}
				else if( i_vertex[i].y > ymax ) {
					ymax = int(i_vertex[i].y) ;
				}
				
			}
			this.h = ymax - ymin + 1 ;
			this.x = xmin ;
			this.w = xmax - xmin + 1 ;
			this.y = ymin ;
		}
	
		public function clip( i_left:int , i_top:int , i_right:int , i_bottom:int ):void
		{ 
			var x:int = this.x ;
			var y:int = this.y ;
			var r:int = x + this.w - 1 ;
			var b:int = y + this.h - 1 ;
			if( x < i_left ) {
				x = i_left ;
			}
			else if( x > i_right ) {
				x = i_right ;
			}
			
			if( y < i_top ) {
				y = i_top ;
			}
			else if( y > i_bottom ) {
				y = i_bottom ;
			}
			
			var l:int ;
			l = ( r > i_right ) ? i_right - x : r - x ;
			if( l < 0 ) {
				this.w = 0 ;
			}
			else {
				this.w = l + 1 ;
			}
			l = ( b > i_bottom ) ? i_bottom - y : b - y ;
			if( l < 0 ) {
				this.h = 0 ;
			}
			else {
				this.h = l + 1 ;
			}
			this.x = x ;
			this.y = y ;
			return  ;
		}
		
		public function isInnerPoint( i_x:int , i_y:int ):Boolean
		{ 
			var x:int = i_x - this.x ;
			var y:int = i_y - this.y ;
			return ( 0 <= x && x < this.w && 0 <= y && y < this.h ) ;
		}
	
		public function isInnerPoint_2( i_pos:NyARDoublePoint2d ):Boolean
		{ 
			var x:int = int(i_pos.x) - this.x ;
			var y:int = int(i_pos.y) - this.y ;
			return ( 0 <= x && x < this.w && 0 <= y && y < this.h ) ;
		}
	
		public function isInnerPoint_3( i_pos:NyARIntPoint2d ):Boolean
		{ 
			var x:int = i_pos.x - this.x ;
			var y:int = i_pos.y - this.y ;
			return ( 0 <= x && x < this.w && 0 <= y && y < this.h ) ;
		}
	
		public function isInnerRect( i_rect:NyARIntRect ):Boolean
		{ 
			//assert( ! (( i_rect.w >= 0 && i_rect.h >= 0 ) ) );
			var lx:int = i_rect.x - this.x ;
			var ly:int = i_rect.y - this.y ;
			var lw:int = lx + i_rect.w ;
			var lh:int = ly + i_rect.h ;
			return ( 0 <= lx && lx < this.w && 0 <= ly && ly < this.h && lw <= this.w && lh <= this.h ) ;
		}
		
		public function isInnerRect_2( i_x:int , i_y:int , i_w:int , i_h:int ):Boolean
		{ 
			//assert( ! (( i_w >= 0 && i_h >= 0 ) ) );
			var lx:int = i_x - this.x ;
			var ly:int = i_y - this.y ;
			var lw:int = lx + i_w ;
			var lh:int = ly + i_h ;
			return ( 0 <= lx && lx < this.w && 0 <= ly && ly < this.h && lw <= this.w && lh <= this.h ) ;
		}
	
		public function sqDiagonalPointDiff( i_rect2:NyARIntRect ):int
		{ 
			var w1:int , w2:int ;
			var ret:int ;
			w1 = this.x - i_rect2.x ;
			w2 = this.y - i_rect2.y ;
			ret = w1 * w1 + w2 * w2 ;
			w1 += this.w - i_rect2.w ;
			w2 += this.h - i_rect2.h ;
			ret += w1 * w1 + w2 * w2 ;
			return ret ;
		}
		
		public function getDiagonalSqDist():int
		{ 
			var lh:int = this.h ;
			var lw:int = this.w ;
			return lh * lh + lw * lw ;
		}
		
		public function setValue( i_source:NyARIntRect ):void
		{ 
			this.x = i_source.x ;
			this.y = i_source.y ;
			this.h = i_source.h ;
			this.w = i_source.w ;
		}
		/**
		 * この関数は、インスタンスに値をセットします。
		 * @param i_x
		 * 新しい{@link #x}の値
		 * @param i_y
		 * 新しい{@link #y}の値
		 * @param i_w
		 * 新しい{@link #w}の値
		 * @param i_h
		 * 新しい{@link #h}の値
		 */
		public function setValue_2(i_x:int,i_y:int,i_w:int,i_h:int):void
		{
			this.x=i_x;
			this.y=i_y;
			this.h=i_h;
			this.w=i_w;
		}		
	}
}
