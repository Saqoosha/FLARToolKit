/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
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
package org.libspark.flartoolkit.core.raster 
{
	import flash.display.*;
	import flash.media.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;	
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	
	public class FLARContourPickupFactory
	{
		public static function createDriver(i_ref_raster:INyARRaster):NyARContourPickup_IRasterDriver
		{
			if (i_ref_raster is FLARBinRaster) {
				return new BinReader(FLARBinRaster(i_ref_raster));
			}else if (i_ref_raster is FLARGrayscaleRaster) {
				return new GsReader(FLARGrayscaleRaster(i_ref_raster));
			}
			throw new NyARException();
		}
	}	
}
import flash.display.*;
import flash.media.*;
import jp.nyatla.as3utils.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;	
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import org.libspark.flartoolkit.core.raster.*;
class BaseReader implements NyARContourPickup_IRasterDriver
{
	protected static var _getContour_xdir:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0,-1,-1,-1 , 0, 1, 1, 1, 0,-1,-1]);
	protected static var _getContour_ydir:Vector.<int> = Vector.<int>([ -1, -1, 0, 1, 1, 1, 0, -1 , -1, -1, 0, 1, 1, 1, 0]);
	public function getContour(i_l:int, i_t:int, i_r:int, i_b:int, i_entry_x:int, i_entry_y:int, i_th:int, o_coord:NyARIntCoordinates):Boolean
	{
		throw new NyARException();
	}

}
class GsReader extends BaseReader
{
	private var _ref_raster:FLARGrayscaleRaster;
	public function GsReader(i_ref_raster:FLARGrayscaleRaster)
	{
		NyAS3Utils.assert(i_ref_raster is FLARGrayscaleRaster);
		this._ref_raster=i_ref_raster;
	}
	/**
	 * @param	i_l
	 * @param	i_t
	 * @param	i_r
	 * @param	i_b
	 * @param	i_entry_x
	 * @param	i_entry_y
	 * @param	i_th
	 * 無効引数0固定。
	 * @param	o_coord
	 * @return
	 */
	public override function getContour(i_l:int,i_t:int,i_r:int,i_b:int,i_entry_x:int,i_entry_y:int,i_th:int,o_coord:NyARIntCoordinates):Boolean
	{
		var coord:Vector.<NyARIntPoint2d> = o_coord.items ;
		var xdir:Vector.<int> = _getContour_xdir ;
		var ydir:Vector.<int> = _getContour_ydir ;
		var buf:BitmapData = BitmapData(this._ref_raster.getBitmapData());
		var width:int = this._ref_raster.getWidth() ;
		var max_coord:int = o_coord.items.length ;
		var coord_num:int = 1 ;
		coord[0].x = i_entry_x ;
		coord[0].y = i_entry_y ;
		var dir:int = 5 ;
		var c:int = i_entry_x ;
		var r:int = i_entry_y ;
		for (  ;  ;  ) {
			dir = ( dir + 5 ) % 8 ;
			if( c > i_l && c < i_r && r > i_t && r < i_b ) {
				for(  ;  ;  ) {
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) ))  <= i_th ) {
						break ;
					}
					throw new NyARException(  ) ;
				}
			}
			else {
				for( i = 0 ; i < 8 ; i++ ) {
					x = c + xdir[dir] ;
					y = r + ydir[dir] ;
					if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
						if((buf.getPixel(x,y )) <= i_th ) {
							break ;
						}
						
					}
					
					dir++ ;
				}
				if( i == 8 ) {
					throw new NyARException(  ) ;
				}
				
			}
			
			c = c + xdir[dir] ;
			r = r + ydir[dir] ;
			coord[coord_num].x = c ;
			coord[coord_num].y = r ;
			var x:int, y:int,i:int;
			if ( (c == i_entry_x) && (r == i_entry_y) ) {
				
				coord_num++ ;
				if( coord_num == max_coord ) {
					return false ;
				}
				
				dir = ( dir + 5 ) % 8 ;
				for( i = 0 ; i < 8 ; i++ ) {
					x= c + xdir[dir] ;
					y= r + ydir[dir] ;
					if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
						if((buf.getPixel(x,y)) <= i_th ) {
							break ;
						}
						
					}
					
					dir++ ;
				}
				if( i == 8 ) {
					throw new NyARException(  ) ;
				}
				
				c = c + xdir[dir] ;
				r = r + ydir[dir] ;
				if( coord[1].x == c && coord[1].y == r ) {
					o_coord.length = coord_num ;
					break ;
				}
				else {
					coord[coord_num].x = c ;
					coord[coord_num].y = r ;
				}
			}
			
			coord_num++ ;
			if( coord_num == max_coord ){
				return false ;
			}	
		}
		return true;
	}
}


class BinReader extends BaseReader
{
	private var _ref_raster:FLARBinRaster;
	public function BinReader(i_ref_raster:FLARBinRaster)
	{
		NyAS3Utils.assert(i_ref_raster is FLARBinRaster);
		this._ref_raster=i_ref_raster;
	}
	public override function getContour(i_l:int,i_t:int,i_r:int,i_b:int,i_entry_x:int,i_entry_y:int,i_th:int,o_coord:NyARIntCoordinates):Boolean
	{
		var coord:Vector.<NyARIntPoint2d> = o_coord.items ;
		var xdir:Vector.<int> = _getContour_xdir ;
		var ydir:Vector.<int> = _getContour_ydir ;
		var buf:BitmapData = BitmapData(this._ref_raster.getBitmapData());
		var width:int = this._ref_raster.getWidth() ;
		var max_coord:int = o_coord.items.length ;
		var coord_num:int = 1 ;
		coord[0].x = i_entry_x ;
		coord[0].y = i_entry_y ;
		var dir:int = 5 ;
		var c:int = i_entry_x ;
		var r:int = i_entry_y ;
		for (  ;  ;  ) {
			dir = ( dir + 5 ) % 8 ;
			if( c > i_l && c < i_r && r > i_t && r < i_b ) {
				for(  ;  ;  ) {
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					
					dir++ ;
					if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
						break ;
					}
					throw new NyARException(  ) ;
				}
			}
			else {
				for( i = 0 ; i < 8 ; i++ ) {
					x = c + xdir[dir] ;
					y = r + ydir[dir] ;
					if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
						if((buf.getPixel(x,y ))>0 ) {
							break ;
						}
						
					}
					
					dir++ ;
				}
				if( i == 8 ) {
					throw new NyARException(  ) ;
				}
				
			}
			
			c = c + xdir[dir] ;
			r = r + ydir[dir] ;
			coord[coord_num].x = c ;
			coord[coord_num].y = r ;
			var x:int, y:int,i:int;
			if ( (c == i_entry_x) && (r == i_entry_y) ) {
				
				coord_num++ ;
				if( coord_num == max_coord ) {
					return false ;
				}
				
				dir = ( dir + 5 ) % 8 ;
				for( i = 0 ; i < 8 ; i++ ) {
					x= c + xdir[dir] ;
					y= r + ydir[dir] ;
					if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
						if((buf.getPixel(x,y)&0xff)>0 ) {
							break ;
						}
						
					}
					
					dir++ ;
				}
				if( i == 8 ) {
					throw new NyARException(  ) ;
				}
				
				c = c + xdir[dir] ;
				r = r + ydir[dir] ;
				if( coord[1].x == c && coord[1].y == r ) {
					o_coord.length = coord_num ;
					break ;
				}
				else {
					coord[coord_num].x = c ;
					coord[coord_num].y = r ;
				}
			}
			
			coord_num++ ;
			if( coord_num == max_coord ){
				return false ;
			}	
		}
		return true;
	}
}

