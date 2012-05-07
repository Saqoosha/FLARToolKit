package org.libspark.flartoolkit.support.pv3d.rpf
{
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.NyARDoubleMatrix44;
	import org.libspark.flartoolkit.rpf.reality.nyartk.FLARReality;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.FLARRealitySource_BitmapImage;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.cameras.*;
	import org.papervision3d.core.math.*;	
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import flash.display.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	/**
	 * ...
	 * @author 
	 */
	public class FLARRealityPv3d extends NyARReality
	{
		/**
		 * 
		 * @param	i_param
		 * カメラパラメータ
		 * @param	i_is_enable_distfactor
		 * 樽型歪み除去の有効スイッチ（falseで無効）falseの方がパフォーマンスが良い。
		 * @param	i_near
		 * 視錐台のnear point
		 * @param	i_far
		 * 視錐台のfar point
		 * @param	i_number_of_unknown
		 * @param	i_number_of_known
		 */
		public function FLARRealityPv3d(i_param:NyARParam, i_is_enable_distfactor:Boolean , i_near:Number, i_far:Number, i_number_of_known:int, i_number_of_unknown:int)
		{
			super(new NyAS3Const_Inherited());
			override_NyARReality_2(i_param.getScreenSize(), i_near, i_far, i_param.getPerspectiveProjectionMatrix(),i_is_enable_distfactor?i_param.getDistortionFactor():null, i_number_of_known, i_number_of_unknown);
			this._camera3d = new FLARCamera3D(i_param);
			this.axisMode = AXIS_MODE_ORIGINAL;
		}
		public static const AXIS_MODE_ORIGINAL:int = 0;
		public static const AXIS_MODE_PV3D:int = 2;
		private var axisMode:int;
		private var _camera3d:Camera3D;
		public function refCamera3d():Camera3D
		{
			return this._camera3d;
		}
		public function setAxisMode(i_axisMode:int=AXIS_MODE_ORIGINAL) :void
		{
			this.axisMode = i_axisMode;
		}
		public function loadTransformMat(i_rt:NyARRealityTarget,o_matrix:Matrix3D):void
		{
			var r:NyARDoubleMatrix44 = i_rt.refTransformMatrix();
			if (this.axisMode == AXIS_MODE_PV3D) {
				o_matrix.n11 =  r.m00;  o_matrix.n12 =  r.m01;  o_matrix.n13 = -r.m02;  o_matrix.n14 =  r.m03;
				o_matrix.n21 = -r.m10;  o_matrix.n22 = -r.m11;  o_matrix.n23 =  r.m12;  o_matrix.n24 = -r.m13;
				o_matrix.n31 =  r.m20;  o_matrix.n32 =  r.m21;  o_matrix.n33 = -r.m22;  o_matrix.n34 =  r.m23;
			} else {
				// ARToolKit original
				o_matrix.n11 =  r.m01;  o_matrix.n12 =  r.m00;  o_matrix.n13 =  r.m02;  o_matrix.n14 =  r.m03;
				o_matrix.n21 = -r.m11;  o_matrix.n22 = -r.m10;  o_matrix.n23 = -r.m12;  o_matrix.n24 = -r.m13;
				o_matrix.n31 =  r.m21;  o_matrix.n32 =  r.m20;  o_matrix.n33 =  r.m22;  o_matrix.n34 =  r.m23;
			}
		}
		public function drawRealitySource(i_src:FLARRealitySource_BitmapImage,i_dest:Bitmap):void
		{
			i_dest.bitmapData.draw(i_src.getBufferedImage());
		}
	}

}