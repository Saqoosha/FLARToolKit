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

	public class FLARIntCoordinates 
	{
		public var items:Vector.<FLARIntPoint2d>; 
		public var length:int ; 
		public function FLARIntCoordinates(i_length:int )
		{ 
			this.items = FLARIntPoint2d.createArray(i_length) ;
			this.length = 0 ;
		}
		public function setLineCoordinates( i_x0:int , i_y0:int , i_x1:int , i_y1:int ):Boolean
		{ 
			var ptr:Vector.<FLARIntPoint2d> = this.items ;
			var dx:int = ( i_x1 > i_x0 ) ? i_x1 - i_x0 : i_x0 - i_x1 ;
			var dy:int = ( i_y1 > i_y0 ) ? i_y1 - i_y0 : i_y0 - i_y1 ;
			var sx:int = ( i_x1 > i_x0 ) ? 1 : -1 ;
			var sy:int = ( i_y1 > i_y0 ) ? 1 : -1 ;
			var idx:int = 0 ;
			var E:int, i:int;
			if( dx >= dy ) {
				if( dx >= ptr.length ) {
					return false ;
				}
				
				E= -dx ;
				for(i = 0 ; i <= dx ; i++ ) {
					ptr[idx].x = i_x0 ;
					ptr[idx].y = i_y0 ;
					idx++ ;
					i_x0 += sx ;
					E += 2 * dy ;
					if( E >= 0 ) {
						i_y0 += sy ;
						E -= 2 * dx ;
					}
					
				}
			}
			else {
				if( dy >= this.items.length ) {
					return false ;
				}
				
				E = -dy ;
				for(i = 0 ; i <= dy ; i++ ) {
					ptr[idx].x = i_x0 ;
					ptr[idx].y = i_y0 ;
					idx++ ;
					i_y0 += sy ;
					E += 2 * dx ;
					if( E >= 0 ) {
						i_x0 += sx ;
						E -= 2 * dy ;
					}
					
				}
			}
			this.length = idx ;
			return true ;
		}	
	}
}