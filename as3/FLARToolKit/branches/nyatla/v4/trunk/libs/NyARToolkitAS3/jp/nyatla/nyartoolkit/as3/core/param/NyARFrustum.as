package jp.nyatla.nyartoolkit.as3.core.param 
{
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	/**
	 * 視錐台と、これを使った演算関数を定義します。
	 * @author nyatla
	 *
	 */
	public class NyARFrustum
	{
		/** frastum行列*/
		protected var _frustum_rh:NyARDoubleMatrix44=new NyARDoubleMatrix44();
		/** frastum逆行列*/
		protected var _inv_frustum_rh:NyARDoubleMatrix44=new NyARDoubleMatrix44();	
		protected var _screen_size:NyARIntSize = new NyARIntSize();
		/**
		 * コンストラクタです。ARToolkitの射影変換行列から、インスタンスを作ります。
		 * @param i_projection
		 * @param i_width
		 * スクリーンサイズです。
		 * @param i_height
		 * スクリーンサイズです。
		 * @param i_near
		 * 近平面までの距離です。単位はmm
		 * @param i_far
		 * 遠平面までの距離です。単位はmm
		 */
		public function NyARFrustum(...args:Array)
		{
			switch(args.length) {
			case 0:
				break;
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 5:
				override_NyARFrustum_5oiinn(NyARPerspectiveProjectionMatrix(args[0]), int(args[1]),int(args[2]),Number(args[3]),Number(args[4]));
				break;
			default:
				throw new NyARException();
			}			
		}		
		 
		 
		 
		private function override_NyARFrustum_5oiinn(i_perspective_mat:NyARPerspectiveProjectionMatrix,i_width:int,i_height:int,i_near:Number,i_far:Number):void
		{
			this.setValue_2(i_perspective_mat, i_width, i_height, i_near, i_far);
		}
		/**
		 * この関数は、視錐台行列をインスタンスにセットします。
		 * @param i_projection
		 * ARToolKitスタイルの射影変換行列
		 * @param i_width
		 * スクリーンサイズです。
		 * @param i_height
		 * スクリーンサイズです。
		 */
		public function setValue(i_projection_mat:NyARDoubleMatrix44,i_width:int,i_height:int):void
		{
			this._frustum_rh.setValue_2(i_projection_mat);
			this._inv_frustum_rh.inverse(this._frustum_rh);
			this._screen_size.setValue(i_width,i_height);
		}		
		/**
		 * ARToolKitスタイルの射影変換行列から、視錐台をセットします。
		 * @param i_projection
		 * @param i_width
		 * @param i_height
		 * @param i_near
		 * nearポイントをmm単位で指定します。
		 * @param i_far
		 * farポイントをmm単位で指定します。
		 */
		public function setValue_2(i_artk_perspective_mat:NyARPerspectiveProjectionMatrix,i_width:int,i_height:int,i_near:Number,i_far:Number):void
		{
			i_artk_perspective_mat.makeCameraFrustumRH(i_width, i_height, i_near, i_far,this._frustum_rh);
			this._inv_frustum_rh.inverse(this._frustum_rh);
			this._screen_size.setValue(i_width,i_height);
		}	
		/**
		 * 画像上の座標を、撮像点座標に変換します。
		 * この座標は、カメラ座標系です。
		 * @param ix
		 * 画像上の座標
		 * @param iy
		 * 画像上の座標
		 * @param o_point_on_screen
		 * 撮像点座標
		 * <p>
		 * この関数は、gluUnprojectのビューポートとモデルビュー行列を固定したものです。
		 * 公式は、以下の物使用。
		 * http://www.opengl.org/sdk/docs/man/xhtml/gluUnProject.xml
		 * ARToolKitの座標系に合せて計算するため、OpenGLのunProjectとはix,iyの与え方が違います。画面上の座標をそのまま与えてください。
		 * </p>
		 */
		public final function unProject(ix:Number,iy:Number,o_point_on_screen:NyARDoublePoint3d):void
		{
			var n:Number=(this._frustum_rh.m23/(this._frustum_rh.m22-1));
			var m44:NyARDoubleMatrix44=this._inv_frustum_rh;
			var v1:Number=(this._screen_size.w-ix-1)*2/this._screen_size.w-1.0;//ARToolKitのFrustramに合せてる。
			var v2:Number=(this._screen_size.h-iy-1)*2/this._screen_size.h-1.0;
			var v3:Number=2*n-1.0;
			var b:Number=1/(m44.m30*v1+m44.m31*v2+m44.m32*v3+m44.m33);
			o_point_on_screen.x=(m44.m00*v1+m44.m01*v2+m44.m02*v3+m44.m03)*b;
			o_point_on_screen.y=(m44.m10*v1+m44.m11*v2+m44.m12*v3+m44.m13)*b;
			o_point_on_screen.z=(m44.m20*v1+m44.m21*v2+m44.m22*v3+m44.m23)*b;
			return;
		}
		/**
		 * 画面上の点と原点を結ぶ直線と任意姿勢の平面の交差点を、カメラの座標系で取得します。
		 * この座標は、カメラ座標系です。
		 * @param ix
		 * @param iy
		 * @param i_mat
		 * 平面の姿勢行列です。
		 * @param o_pos
		 */
		public function unProjectOnCamera(ix:Number,iy:Number,i_mat:NyARDoubleMatrix44,o_pos:NyARDoublePoint3d):void
		{
			//画面→撮像点
			this.unProject(ix,iy,o_pos);
			//撮像点→カメラ座標系
			var nx:Number=i_mat.m02;
			var ny:Number=i_mat.m12;
			var nz:Number=i_mat.m22;
			var mx:Number=i_mat.m03;
			var my:Number=i_mat.m13;
			var mz:Number=i_mat.m23;
			var t:Number=(nx*mx+ny*my+nz*mz)/(nx*o_pos.x+ny*o_pos.y+nz*o_pos.z);
			o_pos.x=t*o_pos.x;
			o_pos.y=t*o_pos.y;
			o_pos.z=t*o_pos.z;
		}	
		/**
		 * 画面上の点と原点を結ぶ直線と任意姿勢の平面の交差点を、平面の座標系で取得します。
		 * ARToolKitの本P175周辺の実装と同じです。
		 * @param ix
		 * @param iy
		 * @param i_mat
		 * 平面の姿勢行列です。
		 * @param o_pos
		 * @return
		 * <p>
		 * このAPIは繰り返し使用には最適化されていません。同一なi_matに繰り返しアクセスするときは、展開してください。
		 * </p>
		 */
		public function unProjectOnMatrix(ix:Number,iy:Number,i_mat:NyARDoubleMatrix44,o_pos:NyARDoublePoint3d):Boolean
		{
			//交点をカメラ座標系で計算
			unProjectOnCamera(ix,iy,i_mat,o_pos);
			//座標系の変換
			var m:NyARDoubleMatrix44=new NyARDoubleMatrix44();
			if(!m.inverse(i_mat)){
				return false;
			}
			m.transform3d_2(o_pos, o_pos);
			return true;
		}
		/**
		 * カメラ座標系を、画面座標へ変換します。
		 * @param i_x
		 * @param i_y
		 * @param i_z
		 * @param o_pos2d
		 */
		public function project(i_x:Number,i_y:Number,i_z:Number,o_pos2d:NyARDoublePoint2d):void
		{
			var m:NyARDoubleMatrix44=this._frustum_rh;
			var v3_1:Number=1/i_z*m.m32;
			var w:Number=this._screen_size.w;
			var h:Number=this._screen_size.h;
			o_pos2d.x=w-(1+(i_x*m.m00+i_z*m.m02)*v3_1)*w/2;
			o_pos2d.y=h-(1+(i_y*m.m11+i_z*m.m12)*v3_1)*h/2;
			return;
		}
		/**
		 * カメラ座標系の点を、スクリーン座標の点へ変換します。
		 * @param i_pos
		 * カメラ座標系の点
		 * @param o_pos2d
		 * 結果を受け取るオブジェクトです。
		 */
		public function project_2(i_pos:NyARDoublePoint3d,o_pos2d:NyARDoublePoint2d):void
		{
			this.project(i_pos.x,i_pos.y,i_pos.z,o_pos2d);
		}
		/**
		 * 透視変換行列の参照値を返します。
		 * この値は読出し専用です。変更しないでください。
		 * @return
		 */
		public function getMatrix():NyARDoubleMatrix44
		{
			return this._frustum_rh;
		}
		/**
		 * 透視変換行列の逆行列を返します。
		 * この値は読出し専用です。変更しないでください。
		 * @return
		 */
		public function getInvMatrix():NyARDoubleMatrix44
		{
			return this._inv_frustum_rh;
		}
		public function getFrustumParam(o_value:NyARFrustum_FrustumParam):NyARFrustum_FrustumParam
		{
			var near:Number;
			var mat:NyARDoubleMatrix44 =this._frustum_rh;
			o_value.far=mat.m23/(mat.m22+1);
			o_value.near=near=mat.m23/(mat.m22-1);
			o_value.left=(mat.m02-1)*near/mat.m00;
			o_value.right=(mat.m02+1)*near/mat.m00;
			o_value.bottom=(mat.m12-1)*near/mat.m11;
			o_value.top=(mat.m12+1)*near/mat.m11;
			return o_value;
		}
		public function getPerspectiveParam(o_value:NyARFrustum_PerspectiveParam):NyARFrustum_PerspectiveParam
		{
			var mat:NyARDoubleMatrix44=this._frustum_rh;
			o_value.far=mat.m23/(mat.m22+1);
			o_value.near=mat.m23/(mat.m22-1);
			o_value.aspect=mat.m11/mat.m00;
			o_value.fovy=2*Math.atan(1/(mat.m00*o_value.aspect));
			return o_value;
		}
	
	}
		

}