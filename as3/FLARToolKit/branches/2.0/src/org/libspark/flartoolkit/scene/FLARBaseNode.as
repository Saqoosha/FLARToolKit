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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package org.libspark.flartoolkit.scene {
	
	import org.libspark.flartoolkit.core.FLARTransMatResult;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class FLARBaseNode extends DisplayObject3D {
		
		public function FLARBaseNode() {
			super();
		}
		
		public function setTranslationMatrix(result:FLARTransMatResult):void {
			var a:Array = result.getArray();
			var mtx:Matrix3D = this.transform;
			mtx.n11 =  a[0][1];	mtx.n12 =  a[0][0];	mtx.n13 =  a[0][2];	mtx.n14 =  a[0][3];
			mtx.n21 = -a[1][1];	mtx.n22 = -a[1][0];	mtx.n23 = -a[1][2];	mtx.n24 = -a[1][3];
			mtx.n31 =  a[2][1];	mtx.n32 =  a[2][0];	mtx.n33 =  a[2][2];	mtx.n34 =  a[2][3];
		}
		
	}
	
}