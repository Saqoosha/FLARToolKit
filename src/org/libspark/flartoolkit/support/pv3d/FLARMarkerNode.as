/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008,2009 Saqoosha
 * 
 * 2009.06.11:nyatla
 * Branched for Alchemy version FLARToolKit.
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

package org.libspark.flartoolkit.support.pv3d {
	
	import jp.nyatla.nyartoolkit.as3.NyARTransMatResult;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class FLARMarkerNode extends DisplayObject3D {
		
		public static const AXIS_MODE_ORIGINAL:int = 0;
		public static const AXIS_MODE_PV3D:int = 2;
		
		public var axisMode:int;
		
		public function FLARMarkerNode(axisMode:int = AXIS_MODE_PV3D) {
			super();
			this.axisMode = axisMode;
		}
		
		private var _wk:Array = new Array(16);
		public function setTransformMatrix(r:NyARTransMatResult):void {
			var w:Array = this._wk;
			r.getValue(w);
			var m:Matrix3D = this.transform;
			if (this.axisMode == AXIS_MODE_PV3D) {
				m.n11 =  w[0*4+0];  m.n12 =  w[0*4+1];  m.n13 = -w[0*4+2];  m.n14 =  w[0*4+3];
				m.n21 = -w[1*4+0];  m.n22 = -w[1*4+1];  m.n23 =  w[1*4+2];  m.n24 = -w[1*4+3];
				m.n31 =  w[2*4+0];  m.n32 =  w[2*4+1];  m.n33 = -w[2*4+2];  m.n34 =  w[2*4+3];
			} else {
				// ARToolKit original
				m.n11 =  w[0*4+1];  m.n12 =  w[0*4+0];  m.n13 =  w[0*4+2];  m.n14 =  w[0*4+3];
				m.n21 = -w[1*4+1];  m.n22 = -w[1*4+0];  m.n23 = -w[1*4+2];  m.n24 = -w[1*4+3];
				m.n31 =  w[2*4+1];  m.n32 =  w[2*4+0];  m.n33 =  w[2*4+2];  m.n34 =  w[2*4+3];
			}
		}
	}
}