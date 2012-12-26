package org.libspark.flartoolkit.alternativa3d 
{
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.geom.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import alternativa.engine3d.core.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class FLARAlternativa3DMarkerSystem extends FLARMarkerSystem
	{
		private var _camera:FLARCamera3D;
		private var _axix_mode:int;
		
		public function FLARAlternativa3DMarkerSystem(i_config:IFLARMarkerSystemConfig)
		{
			super(i_config);
			this._camera = new FLARCamera3D(this._ref_param);
			this.addObserver(new Observer(this._camera));
		}
		/**
		 * AR映像向けにセットしたPaperVision3Dカメラを返します。
		 * @return
		 */
		public function getAlternativa3DCamera():FLARCamera3D
		{
			return this._camera;
		}
		/**
		 * この関数は、i_idの姿勢変換行列をi_3d_objectへセットします。
		 * 座標系は、コンストラクタに設定した座標モードの影響を受けます。
		 * @param	i_id
		 * @param	i_3d_object
		 */
		public function getAlternativa3DMarkerMatrix(i_id:int,i_mat3d:Matrix3D):void
		{
			var r:FLARDoubleMatrix44 = this.getMarkerMatrix(i_id);
			i_mat3d.copyRawDataFrom(Vector.<Number>([
					r.m00,r.m10,r.m20,0,
					r.m01,r.m11, r.m21,0,
					r.m02,r.m12, r.m22,0,
					r.m03,r.m13, r.m23, 1]), 0);
		}
		private var _wmat:Matrix3D = new Matrix3D();
		public function appendAlternativa3DMarkerMatrixRH(i_id:int, i_rhs:Matrix3D):void
		{
			this.getAlternativa3DMarkerMatrix(i_id, this._wmat);
			i_rhs.append(this._wmat);
		}
		
		
		public override function getMarkerPlanePos(i_id:int, i_x:int, i_y:int, i_out:FLARDoublePoint3d):FLARDoublePoint3d
		{
			var p:FLARDoublePoint3d = super.getMarkerPlanePos(i_id, i_x, i_y, i_out);
			var py:Number = p.y;
			p.x = p.x;
			p.y = p.y;
			return p;
		}
	}
}
import org.libspark.flartoolkit.markersystem.*;
import org.libspark.flartoolkit.alternativa3d.*;
import org.libspark.flartoolkit.core.param.*;
class Observer implements IFLARSingleCameraSystemObserver
{
	private var _ref_camera:FLARCamera3D;
	public function Observer(i_ref_camera:FLARCamera3D)
	{
		this._ref_camera = i_ref_camera;
	}
	public function onUpdateCameraParametor(i_param:FLARParam, i_near:Number, i_far:Number):void	
	{
		this._ref_camera.setParam(i_param, i_near, i_far);
	}
}