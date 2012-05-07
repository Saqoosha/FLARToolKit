package org.libspark.flartoolkit.rpf.realitysource.nyartk 
{
	import flash.display.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.rpf.realitysource.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
	import org.libspark.flartoolkit.rpf.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;

	/**
	 * このクラスは、BufferedImageと互換性のあるNyARRealitySourceです。
	 * @author nyatla
	 *
	 */
	public class FLARRealitySource_BitmapImage extends NyARRealitySource
	{
		protected var _filter:INyARRgb2GsFilter;

		/**
		 * ビットマップのアタッチされていない、
		 * @param i_width
		 * ラスタのサイズを指定します。i_attach_bitmapがnullの時のみ有効です。
		 * @param i_height
		 * ラスタのサイズを指定します。i_attach_bitmapがnullの時のみ有効です。
		 * @param i_ref_raster_distortion
		 * 歪み矯正の為のオブジェクトを指定します。歪み矯正が必要ない時は、NULLを指定します。
		 * @param i_depth
		 * エッジ画像のサイズを1/(2^n)で指定します。(例:QVGA画像で1を指定すると、エッジ検出画像は160x120になります。)
		 * 数値が大きいほど高速になり、検出精度は低下します。実用的なのは、1<=n<=3の範囲です。標準値は2です。
		 * @param i_number_of_sample
		 * サンプリングするターゲット数を指定します。大体100以上をしておけばOKです。具体的な計算式は、{@link NyARTrackerSource_Reference#NyARTrackerSource_Reference}を参考にして下さい。
		 * @param i_attach_bitmap
		 * アタッチするビットマップデータを指定します。nullを指定した場合は、後でsetImageで有効なビットマップに切り替えられます。
		 * @throws NyARException
		 */
		public function FLARRealitySource_BitmapImage(i_width:int,i_height:int,i_ref_raster_distortion:NyARCameraDistortionFactor,i_depth:int,i_number_of_sample:int,i_attach_bitmap:BitmapData)
		{
			this._rgb_source = i_attach_bitmap == null
				?new FLARRgbRaster(i_width, i_height, false)
				:new FLARRgbRaster(i_attach_bitmap);
			this._filter=INyARRgb2GsFilter(this._rgb_source.createInterface(INyARRgb2GsFilter));			
			this._source_perspective_reader =INyARPerspectiveCopy(this._rgb_source.createInterface(INyARPerspectiveCopy));
			this._tracksource=new FLARTrackerSource_Reference(i_number_of_sample,i_ref_raster_distortion,this._rgb_source.getWidth(),this._rgb_source.getHeight(),i_depth,true);
			return;
		}
		/**
		 * 入力ラスタとリンクしたBufferedImageを返します。
		 * @return
		 */
		public function getBufferedImage():BitmapData
		{
			return (BitmapData(this._rgb_source.getBuffer()));
		}

		public override function isReady():Boolean
		{
			return this._rgb_source.hasBuffer();
		}
		public override function syncResource():void
		{
			this._filter.convert(this._tracksource.refBaseRaster());
			super.syncResource();
		}
		public override function makeTrackSource():NyARTrackerSource
		{
			this._filter.convert(this._tracksource.refBaseRaster());
			
			return this._tracksource;
		}
		/**
		 * コンストラクタでi_attach_bitmapを指定したときだけ使えます。
		 * @param	i_buffer
		 */
		public function setImage(i_buffer:BitmapData):void
		{
			(FLARRgbRaster(this._rgb_source)).wrapBuffer(i_buffer);
		}
	}	

}