package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.FLARCameraDistortionFactor;
	import org.libspark.flartoolkit.core.raster.FLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.utils.*;

	/**
	 * FLARTrackerSourceのリファレンス実装です。
	 * 全ての画像処理を処理系のソフトウェアで実装します。
	 */
	public class FLARTrackerSource_Reference extends FLARTrackerSource
	{
		/**
		 * 反転RobertsFilter画像のインスタンス
		 */
		private var _sampler:LowResolutionLabelingSampler;
		private var _rb_source:FLARGrayscaleRaster;
		private var _rfilter:NegativeSqRoberts = new NegativeSqRoberts(FLARBufferType.INT1D_GRAY_8);
		private var _gs_graphics:IFLARGsRasterGraphics;
		/**
		 * @param i_number_of_sample
		 * サンプラが検出する最大数。
		 *　通常100~200以上を指定します。(QVGA画像あたり、100個を基準にします。)
		 * 数が少なすぎると、検出率が低下します。最低でも、FLARTrackerに設定するターゲット数の合計*2以上を指定してください。
		 * @param i_ref_raster_distortion
		 * 歪み矯正の為のオブジェクトを指定します。歪み矯正が必要ない時は、NULLを指定します。
		 * @param i_width
		 * ソース画像のサイズ
		 * @param i_height
		 * ソース画像のサイズ
		 * @param i_depth
		 * 解像度の深さ(1/(2^n))倍の画像として処理する。
		 * @param i_is_alloc
		 * ベースラスタのバッファを内部確保外部参照にするかのフラグです。
		 * trueの場合、バッファは内部に確保され、{@link #wrapBuffer}関数が使用できなくなります。
		 * @throws FLARException
		 */
		public function FLARTrackerSource_Reference(i_number_of_sample:int, i_ref_raster_distortion:FLARCameraDistortionFactor, i_width:int, i_height:int, i_depth:int, i_is_alloc:Boolean)
		{
			super((int)(Math.pow(2,i_depth)));
			//		assert(i_depth>0);
			var div:int=this._rob_resolution;
			//主GSラスタ
			this._base_raster=new FLARGrayscaleRaster(i_width,i_height,FLARBufferType.INT1D_GRAY_8,i_is_alloc);
			this._gs_graphics=FLARGsRasterGraphicsFactory.createDriver(this._base_raster);
			//Roberts変換ラスタ
			this._rb_source=new FLARGrayscaleRaster(i_width/div,i_height/div,FLARBufferType.INT1D_GRAY_8, true);
			//Robertsラスタは最も解像度の低いラスタと同じ
			this._rbraster=new FLARGrayscaleRaster(i_width/div,i_height/div,FLARBufferType.INT1D_GRAY_8, true);
			this._vec_reader=new FLARVectorReader_INT1D_GRAY_8(this._base_raster,i_ref_raster_distortion,this._rbraster);
			//samplerとsampleout
			this._sampler=new LowResolutionLabelingSampler(i_width, i_height,(int)(Math.pow(2,i_depth)));
			this._sample_out=new LowResolutionLabelingSamplerOut(i_number_of_sample);
		}
		/**
		 * GS画像をセットします。
		 * この関数を使ってセットした画像は、インスタンスから参照されます。
		 * @param i_ref_source
		 * @throws FLARException 
		 */
		public function wrapBuffer(i_ref_source:FLARGrayscaleRaster):void
		{
			//バッファのスイッチ
			this._base_raster.wrapBuffer(i_ref_source.getBuffer());
		}


		public override function syncResource():void
		{
			//内部状態の同期
			this._gs_graphics.copyTo(0,0,this._rob_resolution,this._rb_source);
			this._rfilter.doFilter(this._rb_source,this._rbraster);
		}
		/**
		 * SampleOutを計算して返します。
		 * この関数は、FLARTrackerが呼び出します。
		 * @param samplerout
		 * @throws FLARException
		 */
		public override function makeSampleOut():LowResolutionLabelingSamplerOut
		{
			syncResource();
			//敷居値自動調整はそのうちね。
			this._sampler.sampling(this._rbraster,220,this._sample_out);
			return this._sample_out;
		}
		

	}
}
