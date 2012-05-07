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
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.geom.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.markersystem.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import away3d.cameras.*;
	import away3d.cameras.lenses.*;
	import away3d.core.math.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class FLARAway3DMarkerSystem extends FLARMarkerSystem
	{
		private var _camera:FLARCamera3D;
		private var _axix_mode:int;
		
		public function FLARAway3DMarkerSystem(i_config:INyARMarkerSystemConfig)
		{
			super(i_config);
		}
		protected override function initInstance(i_config:INyARMarkerSystemConfig):void
		{
			//super part
			super.initInstance(i_config);
			//next part
			this._camera = new FLARCamera3D(this._ref_param);
		}
		/**
		 * AR映像向けにセットしたPaperVision3Dカメラを返します。
		 * @return
		 */
		public function getAway3DCamera():Camera3D
		{
			return this._camera;
		}
		public override function setProjectionMatrixClipping(i_near:Number,i_far:Number):void
		{
			super.setProjectionMatrixClipping(i_near, i_far);
			this._camera.setParam(this._ref_param,i_near,i_far);
		}
		/**
		 * この関数は、i_idの姿勢変換行列をi_3d_objectへセットします。
		 * 座標系は、コンストラクタに設定した座標モードの影響を受けます。
		 * @param	i_id
		 * @param	i_3d_object
		 */
		public function getAway3dMarkerMatrix(i_id:int,i_mat3d:Matrix3D):void
		{
			var r:NyARDoubleMatrix44 = this.getMarkerMatrix(i_id);
			var m:Vector.<Number>=i_mat3d.rawData;
			i_mat3d.copyRawDataFrom(Vector.<Number>([
					-r.m00,r.m10,-r.m20,0,
					r.m01,-r.m11, r.m21,0,
					r.m02,-r.m12, r.m22,0,
					r.m03,-r.m13, r.m23, 1]), 0);
//			i_mat3d.appendRotation(Math.PI, new Vector3D(0, 1, 0));
//			i_mat3d.appendRotation(Math.PI / 2, new Vector3D(1, 0, 0));
		}
		public override function getMarkerPlanePos(i_id:int, i_x:int, i_y:int, i_out:NyARDoublePoint3d):NyARDoublePoint3d
		{
			var p:NyARDoublePoint3d = super.getMarkerPlanePos(i_id, i_x, i_y, i_out);
			var py:Number = p.y;
			p.x = -p.x;
			p.y = p.y;
			return p;
		}
	}
}
