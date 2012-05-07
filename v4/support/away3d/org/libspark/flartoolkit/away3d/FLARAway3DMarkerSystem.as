package org.libspark.flartoolkit.away3d 
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
			this._camera.setParam(this._ref_param);
		}
		/**
		 * この関数は、i_idの姿勢変換行列をi_3d_objectへセットします。
		 * 座標系は、コンストラクタに設定した座標モードの影響を受けます。
		 * @param	i_id
		 * @param	i_3d_object
		 */
		public function getAway3dMarkerMatrix(i_id:int,i_mat3d:MatrixAway3D):void
		{
			var r:NyARDoubleMatrix44 = this.getMarkerMatrix(i_id);
			i_mat3d.sxx =  r.m00; i_mat3d.sxy =  r.m02; i_mat3d.sxz =  r.m01; i_mat3d.tx =  r.m03;
			i_mat3d.syx = -r.m10; i_mat3d.syy = -r.m12; i_mat3d.syz = -r.m11; i_mat3d.ty = -r.m13;
			i_mat3d.szx =  r.m20; i_mat3d.szy =  r.m22; i_mat3d.szz =  r.m21; i_mat3d.tz =  r.m23;
		}
		public override function getMarkerPlanePos(i_id:int, i_x:int, i_y:int, i_out:NyARDoublePoint3d):NyARDoublePoint3d
		{
			var p:NyARDoublePoint3d = super.getMarkerPlanePos(i_id, i_x, i_y, i_out);
			var pz:Number = p.z;
			p.z = p.y;
			p.y = pz;
			return p;
		}		
	}
}
