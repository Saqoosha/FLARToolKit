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

package org.libspark.flartoolkit.support.alternativa3d
{
	import alternativa.engine3d.core.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.types.FLARIntSize;	
	import org.libspark.flartoolkit.utils.ArrayUtil;

	public class FLARCamera3D extends Camera3D {
		private static const NEAR_CLIP:Number = 10;
		private static const FAR_CLIP:Number = 10000;		
		
		public function FLARCamera3D(param:FLARParam = null)
		{
			super(NEAR_CLIP, FAR_CLIP);
			if (!param) {
				this.setParam(param,NEAR_CLIP,FAR_CLIP);
			}else {
				this.setParam(FLARParam.createDefaultParameter(), NEAR_CLIP, FAR_CLIP);
			}
			this.x = 0;
			this.y = 0;
			this.z = 0;
		}
		private var _ref_param:FLARParam;
		private var _frustum:FLARFrustum = new FLARFrustum();
		public function setParam(param:FLARParam,i_near:int,i_far:int):void
		{
			var s:FLARIntSize = param.getScreenSize();
			this._frustum.setValue_2(param.getPerspectiveProjectionMatrix(), s.w, s.h,i_near,i_far);
			var ap:FLARFrustum_PerspectiveParam = this._frustum.getPerspectiveParam(new FLARFrustum_PerspectiveParam());
			this._ref_param = param;
			this.nearClipping = i_near;
			this.farClipping = i_far;
			this.fov = 2 *ap.fovy;
		}
		public function createBackgroundPanel(i_backbuffer_size:int=512):FLARBackgroundPanel
		{
			var bgp:FLARBackgroundPanel = new FLARBackgroundPanel(1,1,i_backbuffer_size);
			
			var fp:FLARFrustum_FrustumParam=this._frustum.getFrustumParam(new FLARFrustum_FrustumParam());
			var bg_pos:Number = fp.far-0.1;
			bgp.z=bg_pos;
			var b:Number=bg_pos/fp.near;// 10?
			bgp.scaleX = -((fp.right - fp.left) * b);
			bgp.scaleY = -((fp.top - fp.bottom) * b);
			return bgp;
		}
		
	}
}