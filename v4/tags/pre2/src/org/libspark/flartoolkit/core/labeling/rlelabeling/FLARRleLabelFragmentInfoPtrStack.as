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
package org.libspark.flartoolkit.core.labeling.rlelabeling 
{
	import org.libspark.flartoolkit.core.types.stack.*;
	/**
	 * ...
	 * @author 
	 */
	public class FLARRleLabelFragmentInfoPtrStack extends FLARPointerStack 
	{
		public function FLARRleLabelFragmentInfoPtrStack( i_length:int )
		{ 
			this.initInstance(i_length) ;
			return  ;
		}
		
		public function sortByArea():void
		{ 
			var len:int = this._length ;
			if( len < 1 ) {
				return  ;
			}
			
			var h:int = len * 13 / 10 ;
			var item:Vector.<Object> = this._items ;
			for(  ;  ;  ) {
				var swaps:int = 0 ;
				for( var i:int = 0 ; i + h < len ; i++ ){
					if( ((FLARRleLabelFragmentInfo)(item[i + h])).area > item[i].area ){
						var temp:Object = item[i + h] ;
						item[i + h] = item[i] ;
						item[i] = temp ;
						swaps++ ;
					}
					
				}
				if( h == 1 ) {
					if( swaps == 0 ) {
						break ;
					}
					
				}
				else {
					h = h * 10 / 13 ;
				}
			}
		}
		
	}


}