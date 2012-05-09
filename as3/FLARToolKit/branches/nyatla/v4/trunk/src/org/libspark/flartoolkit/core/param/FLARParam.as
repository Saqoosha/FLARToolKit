package jp.nyatla.nyartoolkit.as3.core.param
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import flash.utils.*;
	
	/**
	 * typedef struct { int xsize, ysize; double mat[3][4]; double dist_factor[4]; } ARParam;
	 * NyARの動作パラメータを格納するクラス
	 *
	 */
	public class NyARParam
	{
		protected var _screen_size:NyARIntSize=new NyARIntSize();
		private static const SIZE_OF_PARAM_SET:int = 4 + 4 + (3 * 4 * 8) + (4 * 8);
		private var _dist:NyARCameraDistortionFactor =new NyARCameraDistortionFactor();
		private var _projection_matrix:NyARPerspectiveProjectionMatrix =new NyARPerspectiveProjectionMatrix();
		public function loadDefaultParameter():void
		{
			var tmp:Vector.<Number>=Vector.<Number>([318.5,263.5,26.2,1.0127565206658486]);
			this._screen_size.setValue(640,480);
			this._dist.setValue(tmp);
			this._projection_matrix.m00=700.9514702992245;
			this._projection_matrix.m01=0;
			this._projection_matrix.m02=316.5;
			this._projection_matrix.m03=0;
			this._projection_matrix.m10=0;
			this._projection_matrix.m11=726.0941816535367;
			this._projection_matrix.m12=241.5;
			this._projection_matrix.m13=0.0;
			this._projection_matrix.m20=0.0;
			this._projection_matrix.m21=0.0;
			this._projection_matrix.m22=1.0;
			this._projection_matrix.m23=0.0;
			this._projection_matrix.m30=0.0;
			this._projection_matrix.m31=0.0;
			this._projection_matrix.m32=0.0;
			this._projection_matrix.m33=1.0;
		}
		public function getScreenSize():NyARIntSize
		{
			return this._screen_size;
		}

		public function getPerspectiveProjectionMatrix():NyARPerspectiveProjectionMatrix 
		{
			return this._projection_matrix;
		}
		public function getDistortionFactor():NyARCameraDistortionFactor
		{
			return this._dist;
		}
		/**
		 * 
		 * @param i_factor
		 * NyARCameraDistortionFactorにセットする配列を指定する。要素数は4であること。
		 * @param i_projection
		 * NyARPerspectiveProjectionMatrixセットする配列を指定する。要素数は12であること。
		 */
		public function setValue(i_factor:Vector.<Number>,i_projection:Vector.<Number>):void
		{
			this._dist.setValue(i_factor);
			this._projection_matrix.setValue(i_projection);
			return;
		}
		/**
		 * int arParamChangeSize( ARParam *source, int xsize, int ysize, ARParam *newparam );
		 * 関数の代替関数 サイズプロパティをi_xsize,i_ysizeに変更します。
		 * @param i_xsize
		 * @param i_ysize
		 * @param newparam
		 * @return
		 * 
		 */
		public function changeScreenSize(i_xsize:int,i_ysize:int):void
		{
			var scale:Number = Number(i_xsize) / Number(this._screen_size.w);// scale = (double)xsize / (double)(source->xsize);
			//スケールを変更
			this._dist.changeScale(scale);
			this._projection_matrix.changeScale(scale);
			this._screen_size.w = i_xsize;// newparam->xsize = xsize;
			this._screen_size.h = i_ysize;// newparam->ysize = ysize;
			return;
		}
		/**
		 * この関数は、現在のスクリーンサイズを変更します。
		 * {@link #changeScreenSize(int, int)のラッパーです。
		 * @param i_s
		 */
		public function changeScreenSize_2(i_s:NyARIntSize):void
		{
			this.changeScreenSize(i_s.w,i_s.h);
		}
		/**
		 * 右手系の視錐台を作ります。
		 * 計算結果を多用するときは、キャッシュするようにして下さい。
		 * @param i_dist_min
		 * @param i_dist_max
		 * @param o_frustum
		 */
		public function makeCameraFrustumRH(i_dist_min:Number,i_dist_max:Number,o_frustum:NyARDoubleMatrix44):void
		{
			this._projection_matrix.makeCameraFrustumRH(this._screen_size.w, this._screen_size.h, i_dist_min, i_dist_max, o_frustum);
			return;
		}
		public function loadARParam(i_stream:ByteArray):void
		{
			var tmp:Vector.<Number> = new Vector.<Number>(16);//new double[12];

			i_stream.endian = Endian.BIG_ENDIAN;
			this._screen_size.w = i_stream.readInt();//bb.getInt();
			this._screen_size.h = i_stream.readInt();//bb.getInt();
			//double値を12個読み込む
			var i:int;
			for(i = 0; i < 12; i++){
				tmp[i] = i_stream.readDouble();//bb.getDouble();
			}
			//パディング
			tmp[12]=tmp[13]=tmp[14]=0;
			tmp[15]=1;			
			//Projectionオブジェクトにセット
			this._projection_matrix.setValue(tmp);
			//double値を4個読み込む
			for (i = 0; i < 4; i++) {
				tmp[i] = i_stream.readDouble();//bb.getDouble();
			}
			//Factorオブジェクトにセット
			this._dist.setValue(tmp);

			return;
		}
	}
}