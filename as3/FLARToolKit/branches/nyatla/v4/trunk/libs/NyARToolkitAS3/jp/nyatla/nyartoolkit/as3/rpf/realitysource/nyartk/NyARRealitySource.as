package jp.nyatla.nyartoolkit.as3.rpf.realitysource.nyartk
{


	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;

	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;
	/**
	 * NyARRealityクラスの入力コンテナです。
	 * NyARRealityへ入力する情報セットを定義します。
	 * 
	 * このクラスは、元画像、元画像に対するPerspectiveReader,元画像からのSampleOutを提供します。
	 * </ul>
	 */
	public class NyARRealitySource
	{
		/**
		 * RealitySourceの主ラスタ。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _rgb_source:INyARRgbRaster;
		/**
		 * RealitySourceの主ラスタにリンクしたPerspectiveReader。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _source_perspective_reader:INyARPerspectiveCopy;

		/**
		 * TrackerSorceのホルダ。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _tracksource:NyARTrackerSource;

		
		public function NyARRealitySource(){};
		

		/**
		 * このRealitySourceに対する読出し準備ができているかを返します。
		 * @return
		 * trueならば、{@link #makeTrackSource}が実行可能。
		 */
		public function isReady():Boolean
		{
			throw new NyARException("isReady is not override");

		}
		/**
		 * 現在のRGBラスタを{@link NyARTrackerSource}の基本ラスタに書込み、その参照値を返します。
		 * この関数は、{@link NyARReality#progress}が呼び出します。
		 * この関数は、{@link NyARTrackerSource}内の基本ラスタに書き込みを行うだけで、その内容を同期しません。
		 * 継承クラスでは、{@link #_tracksource}の基本GS画像を、{@link #_rgb_source}の内容で更新する実装をしてください。
		 * @throws NyARException 
		 */
		public function makeTrackSource():NyARTrackerSource
		{
			throw new NyARException("makeTrackSource has not override");
		}
		/**
		 * 現在のRGBラスタを{@link NyARTrackerSource}の基本ラスタに書込み、{@link NyARTrackerSource}も含めて同期します。
		 * 通常、この関数は使用することはありません。デバックなどで、{@link NyARReality#progress}以外の方法でインスタンスの同期を行いたいときに使用してください。
		 * 継承クラスでは、{@link #_tracksource}の基本GS画像を、{@link #_rgb_source}の内容で更新してから、この関数を呼び出して同期する処理を実装をしてください。
		 * @throws NyARException 
		　*/
		public function syncResource():void
		{
			//下位の同期
			throw new NyARException("syncResource has not override")
		}
		/**
		 * {@link #_rgb_source}を参照するPerspectiveRasterReaderを返します。
		 * @return
		 */
		public function refPerspectiveRasterReader():INyARPerspectiveCopy
		{
			return this._source_perspective_reader;
		}
		
		/**
		 * 元画像への参照値を返します。
		 * @return
		 */
		public function refRgbSource():INyARRgbRaster
		{
			return this._rgb_source;
		}
		/**
		 * 最後に作成したTrackSourceへのポインタを返します。
		 * この関数は、{@link NyARReality#progress}、または{@link #syncResource}の後に呼び出すことを想定しています。
		 * それ以外のタイミングでは、返却値の内容が同期していないことがあるので注意してください。
		 * @return
		 */
		public function refLastTrackSource():NyARTrackerSource
		{
			return this._tracksource;
		}
	}

}
