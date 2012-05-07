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

package org.libspark.flartoolkit.away3d4
{
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;	
	import away3d.cameras.lenses.PerspectiveLens;
	import flash.geom.*;
	import away3d.cameras.Camera3D;
	import away3d.core.math.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;	
	import org.libspark.flartoolkit.utils.ArrayUtil;

	public class FLARCamera3D extends Camera3D {
		private var _viewProjection:Matrix3D = new Matrix3D();
		private var _projectionMatrix:Matrix3D = new Matrix3D();
		private static const NEAR_CLIP:Number = 10;
		private static const FAR_CLIP:Number = 10000;		
		public function FLARCamera3D(param:NyARParam = null) {
			super(new ARLens());
			this.z = 0;
			if (param) {
				this.setParam(param);
			}
		}
		public function setParam(param:NyARParam,i_near:Number=10,i_far:Number=10000):void
		{
			var lens:ARLens = ARLens(this.lens);
			lens.setParam(param, i_near, i_far);
		}
	}
}
import away3d.cameras.lenses.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
import jp.nyatla.as3utils.*;
import jp.nyatla.nyartoolkit.as3.utils.as3.*;
import org.libspark.flartoolkit.utils.ArrayUtil;
import away3d.core.math.Matrix3DUtils;
class ARLens extends LensBase
{
	private var _ref_param:NyARParam=new NyARParam();
	public function ARLens()
	{
		super();
	}
	public function setParam(i_param:NyARParam,i_near:int,i_far:int):void
	{
		if (this._ref_param == i_param) {
			return;
		}
		this._near =i_near;
		this._far = i_far;
		this._ref_param = i_param;
		invalidateMatrix();
	}
	/**
	 * @inheritDoc
	 */
	protected override function updateMatrix() : void
	{
		var raw : Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
		var s:NyARIntSize =this._ref_param.getScreenSize();
		var fm:NyARFrustum = new NyARFrustum(this._ref_param.getPerspectiveProjectionMatrix(), s.w, s.h,near, far);
		var f:NyARDoubleMatrix44 = fm.getMatrix();
		this._matrix.copyRawDataFrom(Vector.<Number>([
			f.m00,f.m10,f.m20, f.m30,
			f.m01,f.m11,f.m21, f.m31,
			f.m02,f.m12,-f.m22,-f.m32,
			f.m03,f.m13,f.m23, f.m33,
			]), 0);
		
		var ap:NyARFrustum_PerspectiveParam = fm.getPerspectiveParam(new NyARFrustum_PerspectiveParam());
		var fi:Number = Math.tan(ap.fovy*Math.PI/180);
		var _yMax:Number = ap.near*fi;
		var _xMax:Number = _yMax*_aspectRatio;

		var yMaxFar : Number = ap.far*fi/2;
		var xMaxFar : Number = yMaxFar*_aspectRatio;

		_frustumCorners[0] = _frustumCorners[9] = -_xMax;
		_frustumCorners[3] = _frustumCorners[6] = _xMax;
		_frustumCorners[1] = _frustumCorners[4] = -_yMax;
		_frustumCorners[7] = _frustumCorners[10] = _yMax;

		_frustumCorners[12] = _frustumCorners[21] = -xMaxFar;
		_frustumCorners[15] = _frustumCorners[18] = xMaxFar;
		_frustumCorners[13] = _frustumCorners[16] = -yMaxFar;
		_frustumCorners[19] = _frustumCorners[22] = yMaxFar;

		_frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = ap.near;
		_frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = ap.far;

		_matrixInvalid = false;
		invalidateMatrix();
	}
}