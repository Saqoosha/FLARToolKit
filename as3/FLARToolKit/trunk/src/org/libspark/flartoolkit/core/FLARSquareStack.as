/* 
 * PROJECT: FLARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The FLARToolkit is Java version ARToolkit class library.
 * Copyright (C)2008 R.Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package org.libspark.flartoolkit.core {
	import org.libspark.flartoolkit.utils.NyObjectStack;		

	public class FLARSquareStack extends NyObjectStack {

		public function FLARSquareStack(i_length:int) {
//			var arr:Array = new Array(i_length);
//			var n:int = i_length;
//			while (n--) {
//				arr[n] = new FLARSquare();
//			}
			super(FLARSquare, i_length);
		}

//		protected override function onReservRequest(i_start:int, i_end:int, i_buffer:Array):void {
//			for (var i:int = i_start; i < i_end; i++) {
//				i_buffer[i] = new FLARSquare();
//			}
//		}
	}
}