package org.libspark.flartoolkit.rpf.realitysource.nyartk
{


	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;

	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	/**
	 * FLARRealityクラスの入力コンテナです。
	 * FLARRealityへ入力する情報セットを定義します。
	 * 
	 * このクラスは、元画像、元画像に対するPerspectiveReader,元画像からのSampleOutを提供します。
	 * </ul>
	 */
	public class FLARRealitySource
	{
		/**
		 * RealitySourceの主ラスタ。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _rgb_source:IFLARRgbRaster;
		/**
		 * RealitySourceの主ラスタにリンクしたPerspectiveReader。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _source_perspective_reader:IFLARPerspectiveCopy;

		/**
		 * TrackerSorceのホルダ。継承先のコンストラクタで実体を割り当ててください。
		 */
		protected var _tracksource:FLARTrackerSource;

		
		public function FLARRealitySource(){};
		

		/**
		 * このRealitySourceに対する読出し準備ができているかを返します。
		 * @return
		 * trueならば、{@link #makeTrackSource}が実行可能。
		 */
		public function isReady():Boolean
		{
			throw new FLARException("isReady is not override");

		}
		/**
		 * 現在のRGBラスタを{@link FLARTrackerSource}の基本ラスタに書込み、その参照値を返します。
		 * この関数は、{@link FLARReality#progress}が呼び出します。
		 * この関数は、{@link FLARTrackerSource}内の基本ラスタに書き込みを行うだけで、その内容を同期しません。
		 * 継承クラスでは、{@link #_tracksource}の基本GS画像を、{@link #_rgb_source}の内容で更新する実装をしてください。
		 * @throws FLARException 
		 */
		public function makeTrackSource():FLARTrackerSource
		{
			throw new FLARException("makeTrackSource has not override");
		}
		/**
		 * 現在のRGBラスタを{@link FLARTrackerSource}の基本ラスタに書込み、{@link FLARTrackerSource}も含めて同期します。
		 * 通常、この関数は使用することはありません。デバックなどで、{@link FLARReality#progress}以外の方法でインスタンスの同期を行いたいときに使用してください。
		 * 継承クラスでは、{@link #_tracksource}の基本GS画像を、{@link #_rgb_source}の内容で更新してから、この関数を呼び出して同期する処理を実装をしてください。
		 * @throws FLARException 
		　*/
		public function syncResource():void
		{
			//下位の同期
			throw new FLARException("syncResource has not override")
		}
		/**
		 * {@link #_rgb_source}を参照するPerspectiveRasterReaderを返します。
		 * @return
		 */
		public function refPerspectiveRasterReader():IFLARPerspectiveCopy
		{
			return this._source_perspective_reader;
		}
		
		/**
		 * 元画像への参照値を返します。
		 * @return
		 */
		public function refRgbSource():IFLARRgbRaster
		{
			return this._rgb_source;
		}
		/**
		 * 最後に作成したTrackSourceへのポインタを返します。
		 * この関数は、{@link FLARReality#progress}、または{@link #syncResource}の後に呼び出すことを想定しています。
		 * それ以外のタイミングでは、返却値の内容が同期していないことがあるので注意してください。
		 * @return
		 */
		public function refLastTrackSource():FLARTrackerSource
		{
			return this._tracksource;
		}
	}

}
