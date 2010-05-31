package org.libspark.flartoolkit.detector.idmarker 
/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 * For further information of this class, please contact.
 * http://tarotaro.org
 * <taro(at)tarotaro.org>
 */
{
	import jp.nyatla.nyartoolkit.as3.core.analyzer.raster.threshold.NyARRasterThresholdAnalyzer_SlidePTile;
	import jp.nyatla.nyartoolkit.as3.core.transmat.INyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.transmat.NyARRectOffset;
	import jp.nyatla.nyartoolkit.as3.core.transmat.NyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.INyIdMarkerData;
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.FLARBinRaster;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_Threshold;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquareContourDetector;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerDataEncoder_RawBit;
	import org.libspark.flartoolkit.FLARException;
	

	public class FLARSingleIdMarkerDetector {

		private var _is_continue:Boolean = false;
		private var _square_detect:FLARSquareContourDetector;
		private var _offset:NyARRectOffset; 
		private var _is_active:Boolean;
		private var _current_threshold:int=110;
		// [AR]検出結果の保存用
		private var _bin_raster:FLARBinRaster;
		private var _tobin_filter:FLARRasterFilter_Threshold;
		private var _callback:FLARSingleIdMarkerDetectCB;
		private var _data_current:INyIdMarkerData;

		private var _threshold_detect:NyARRasterThresholdAnalyzer_SlidePTile;

		protected var _transmat:INyARTransMat;

		public function FLARSingleIdMarkerDetector(i_param:FLARParam ,i_marker_width:int):void
		{			
			var scr_size:NyARIntSize = i_param.getScreenSize();
			var encoder:FLARIdMarkerDataEncoder_RawBit = new FLARIdMarkerDataEncoder_RawBit();
			// 解析オブジェクトを作る
			this._square_detect = new FLARSquareContourDetector(scr_size);
			this._callback = new FLARSingleIdMarkerDetectCB(i_param, encoder);
			this._transmat = new NyARTransMat(i_param);

			// ２値画像バッファを作る
			this._bin_raster = new FLARBinRaster(scr_size.w, scr_size.h);
			//ワーク用のデータオブジェクトを２個作る
			this._data_current = encoder.createDataInstance();
			this._tobin_filter = new FLARRasterFilter_Threshold(110);
			this._threshold_detect = new FLARRasterThresholdAnalyzer_SlidePTile(15, 4);
			this._offset = new NyARRectOffset();
			this._offset.setSquare(i_marker_width);
			return;
			
		}

		public function detectMarkerLite(i_raster:FLARRgbRaster_BitmapData, i_threshold:int):Boolean
		{
			// サイズチェック
			if (!this._bin_raster.getSize().isEqualSize_int(i_raster.getSize().w, i_raster.getSize().h)) {
				throw new FLARException();
			}
			// ラスタを２値イメージに変換する.
			this._tobin_filter.setThreshold(i_threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);

			// スクエアコードを探す(第二引数に指定したマーカ、もしくは新しいマーカを探す。)
			this._callback.init(i_raster, null);
			this._square_detect.detectMarkerCB(this._bin_raster, this._callback);
			return (this._callback.marker_data != null);
		}

		public function getIdMarkerData():FLARIdMarkerData
		{
			var result:FLARIdMarkerData = new FLARIdMarkerData();
			result.copyFrom(this._callback.marker_data);
			return result;
		}
		
		public function getDirection():int 
		{
			return this._callback.direction;
		}
		
		public function getTransformMatrix(o_result:FLARTransMatResult):void
		{
			if (this._is_continue) this._transmat.transMatContinue(this._callback.square, this._offset, o_result);
			else this._transmat.transMat(this._callback.square, this._offset, o_result);
			return;
		}

		public function setContinueMode(i_is_continue:Boolean):void
		{
			this._is_continue = i_is_continue;
		}
	}
}