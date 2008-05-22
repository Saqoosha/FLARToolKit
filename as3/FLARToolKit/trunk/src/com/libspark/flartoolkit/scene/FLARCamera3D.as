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

package com.libspark.flartoolkit.scene {
	
	import com.libspark.flartoolkit.core.FLARMat;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.util.ArrayUtil;
	
	import org.papervision3d.cameras.FrustumCamera3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.view.Viewport3D;

	public class FLARCamera3D extends FrustumCamera3D {
		
		private static const NEAR_CLIP:Number = 10;
		private static const FAR_CLIP:Number = 10000;
		
		public function FLARCamera3D(viewport3D:Viewport3D, param:FLARParam) {
			super(viewport3D);
			this.z = 0;
			
			var m_projection:Array = new Array(16);//new double[16];
			var trans_mat:FLARMat = new FLARMat(3,4);
			var icpara_mat:FLARMat = new FLARMat(3,4);
			var p:Array = ArrayUtil.createMultidimensionalArray(3, 3);//new double[3][3], q=new double[4][4];
			var q:Array = ArrayUtil.createMultidimensionalArray(4, 4);
			var width:int;
			var height:int;
			var i:int;
			var j:int;
			
			width  = param.getX();
			height = param.getY();
			
			param.decompMat(icpara_mat, trans_mat);
			
			var icpara:Array = icpara_mat.getArray();
			var trans:Array = trans_mat.getArray();
			for (i = 0; i < 4; i++) {
				icpara[1][i] = (height - 1) * (icpara[2][i]) - icpara[1][i];
			}
			
			for(i = 0; i < 3; i++) {
				for(j = 0; j < 3; j++) {
					p[i][j] = icpara[i][j] / icpara[2][2];
				}
			}
			q[0][0] = (2.0 * p[0][0] / (width - 1));
			q[0][1] = (2.0 * p[0][1] / (width - 1));
			q[0][2] = -((2.0 * p[0][2] / (width - 1))  - 1.0);
			q[0][3] = 0.0;
			
			q[1][0] = 0.0;
			q[1][1] = -(2.0 * p[1][1] / (height - 1));
			q[1][2] = -((2.0 * p[1][2] / (height - 1)) - 1.0);
			q[1][3] = 0.0;
			
			q[2][0] = 0.0;
			q[2][1] = 0.0;
			q[2][2] = -(FAR_CLIP + NEAR_CLIP) / (NEAR_CLIP - FAR_CLIP);
			q[2][3] = 2.0 * FAR_CLIP * NEAR_CLIP / (NEAR_CLIP - FAR_CLIP);
			
			q[3][0] = 0.0;
			q[3][1] = 0.0;
			q[3][2] = 1.0;
			q[3][3] = 0.0;
			
			for (i = 0; i < 4; i++) { // Row.
				// First 3 columns of the current row.
				for (j = 0; j < 3; j++) { // Column.
					m_projection[i*4 + j] =
						q[i][0] * trans[0][j] +
						q[i][1] * trans[1][j] +
						q[i][2] * trans[2][j];
				}
				// Fourth column of the current row.
				m_projection[i*4 + 3]=
					q[i][0] * trans[0][3] +
					q[i][1] * trans[1][3] +
					q[i][2] * trans[2][3] +
					q[i][3];
			}
			
			this._projection = new Matrix3D(m_projection);
		}
		
	}
	
}