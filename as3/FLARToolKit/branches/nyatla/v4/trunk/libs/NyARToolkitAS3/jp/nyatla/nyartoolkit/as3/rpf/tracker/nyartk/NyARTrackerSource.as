package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.NyARGrayscaleRaster;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.LowResolutionLabelingSamplerOut;

	/**
	 * LowResolutionLabelingSamplerへの入力コンテナの抽象クラスです。
	 * 基本GS画像と、1/nサイズのRobertsエッジ検出画像を持ち、これらに対する同期APIとアクセサを定義します。
	 * <p>
	 * 継承クラスでは、_rbraster,_base_raster,_vec_readerメンバ変数の実体と、abstract関数を実装してください。
	 * </p>
	 */
	public class NyARTrackerSource
	{
		protected var _rob_resolution:int;
		//継承クラスで設定されるべきオブジェクト
		protected var _rbraster:NyARGrayscaleRaster;
		protected var _base_raster:NyARGrayscaleRaster;
		protected var _vec_reader:INyARVectorReader;	
		protected var _sample_out:LowResolutionLabelingSamplerOut;
		/**
		 * Robertsエッジ画像の解像度を指定する。
		 * @param i_rob_resolution
		 */
		public function NyARTrackerSource(i_rob_resolution:int)
		{
			this._rob_resolution=i_rob_resolution;
		}
		/**
		 * 基本GS画像に対するVector読み取り機を返します。
		 * このインスタンスは、基本GS画像と同期していないことがあります。
		 * 基本GS画像に変更を加えた場合は、getSampleOut,またはsyncResource関数を実行して同期してから実行してください。
		 * @return
		 */
		public function getBaseVectorReader():INyARVectorReader
		{
			return this._vec_reader;
		}

		/**
		 * エッジ画像を返します。
		 * このインスタンスは、基本GS画像と同期していないことがあります。
		 * 基本GS画像に変更を加えた場合は、makeSampleOut,またはsyncResource関数を実行して同期してから実行してください。
		 * 継承クラスでは、エッジ画像を返却してください。
		 * @return
		 */
		public function refEdgeRaster():NyARGrayscaleRaster
		{
			return this._rbraster;
		}
		/**
		 * 基準画像を返します。
		 * 継承クラスでは、基本画像を返却してください。
		 * @return
		 */
		public function refBaseRaster():NyARGrayscaleRaster
		{
			return this._base_raster;
		}
		/**
		 * 最後に作成した{@link LowResolutionLabelingSamplerOut}へのポインタを返します。
		 * この関数は、{@link NyARTracker#progress}、または{@link #syncResource}の後に呼び出すことを想定しています。
		 * それ以外のタイミングでは、返却値の内容が同期していないことがあるので注意してください。
		 * @return
		 */
		public function refLastSamplerOut():LowResolutionLabelingSamplerOut
		{
			return this._sample_out;
		}
		/**
		 * 基準画像と内部状態を同期します。(通常、アプリケーションからこの関数を使用することはありません。)
		 * エッジ画像から{@link _sample_out}を更新する関数を実装してください。
		 * @throws NyARException
		 */
		public function syncResource():void
		{
			throw new NyARException("makeSampleOut not override");
		}
		
		/**
		 * SampleOutを計算して、参照値を返します。
		 * この関数は、{@link NyARTracker#progress}が呼び出します。
		 * 継承クラスでは、エッジ画像{@link _rbraster}から{@link _sample_out}を更新して、返却する関数を実装してください。
		 * @throws NyARException
		 */
		public function makeSampleOut():LowResolutionLabelingSamplerOut
		{
			throw new NyARException("makeSampleOut not override");
		}
	}
}
