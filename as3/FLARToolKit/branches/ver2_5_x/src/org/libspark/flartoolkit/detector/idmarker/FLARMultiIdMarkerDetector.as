/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 * For further information of this class, please contact.
 * http://sixwish.jp
 * <rokubou(at)gmail.com>
 */
package org.libspark.flartoolkit.detector.idmarker
{
	import flash.display.BitmapData;
	
	import jp.nyatla.nyartoolkit.as3.core.transmat.INyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.transmat.NyARRectOffset;
	import jp.nyatla.nyartoolkit.as3.core.transmat.NyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.INyIdMarkerData;
	
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.FLARBinRaster;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_Threshold;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquareContourDetector;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerDataEncoder_RawBit;

	public class FLARMultiIdMarkerDetector
	{
		private var _is_continue:Boolean = false;
		private var _square_detect:FLARSquareContourDetector;
		private var _offset:NyARRectOffset; 
		private var _current_threshold:int=110;
		// [AR]検出結果の保存用
		private var _bin_raster:FLARBinRaster;
		private var _tobin_filter:FLARRasterFilter_Threshold;
		private var _callback:FLARMultiIdMarkerDetectCB;
		private var _data_current:INyIdMarkerData;
		
		private var _threshold_detect:FLARRasterThresholdAnalyzer_SlidePTile;
		
		protected var _transmat:INyARTransMat;

		public function FLARMultiIdMarkerDetector(i_param:FLARParam ,i_marker_width:int):void
		{
			var scr_size:NyARIntSize = i_param.getScreenSize();
			var encoder:FLARIdMarkerDataEncoder_RawBit = new FLARIdMarkerDataEncoder_RawBit();
			// 解析オブジェクトを作る
			this._square_detect = new FLARSquareContourDetector(scr_size);
			this._callback = new FLARMultiIdMarkerDetectCB(i_param, encoder);
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
		
		public function detectMarkerLite(i_raster:FLARRgbRaster_BitmapData, i_threshold:int):int
		{
			// サイズチェック
			if (!this._bin_raster.getSize().isEqualSize_int(i_raster.getSize().w, i_raster.getSize().h)) {
				throw new FLARException();
			}
			// ラスタを２値イメージに変換する.
			this._tobin_filter.setThreshold(i_threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);
			
			// スクエアコードを探す(第二引数に指定したマーカ、もしくは新しいマーカを探す。)
			this._callback.init(i_raster);
			this._square_detect.detectMarkerCB(this._bin_raster, this._callback);
			
			//見付かった数を返す。
			return this._callback.result_stack.getLength();
		}
		
		/**
		 * i_indexのマーカーに対する変換行列を計算し、結果値をo_resultへ格納します。 直前に実行したdetectMarkerLiteが成功していないと使えません。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @param o_result
		 * 結果値を受け取るオブジェクトを指定してください。
		 * @throws NyARException
		 */
		public function getTransformMatrix(i_index:int, o_result:FLARTransMatResult):void
		{
			var result:FLARDetectIdMarkerResult = this._callback.result_stack.getItem(i_index);
			// 一番一致したマーカーの位置とかその辺を計算
			if (_is_continue) {
				_transmat.transMatContinue(result.square, this._offset, o_result);
			} else {
				_transmat.transMat(result.square, this._offset, o_result);
			}
			return;
		}
		
		public function getIdMarkerData(i_index:int):FLARIdMarkerData
		{
			var result:FLARIdMarkerData = new FLARIdMarkerData();
			result.copyFrom(this._callback.result_stack.getItem(i_index).markerdata);
			return result;
		}
		
		/**
		 * i_indexのマーカーのARCodeインデックスを返します。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @return
		 */
		public function getARCodeIndex(i_index:int):int
		{
			return this._callback.result_stack.getItem(i_index).arcode_id;
		}
		
		/**
		 * 検出したマーカーの方位を返します。
		 * 0,1,2,3の何れかを返します。
		 * 
		 * @return Returns whether any of 0,1,2,3.
		 */
		public function getDirection(i_index:int):int
		{
			return this._callback.result_stack.getItem(i_index).direction;
		}
		
		/**
		 * 検出した FLARSquare 1 個返す。検出できなかったら null。
		 * @return Total return detected FLARSquare 1. Detection Dekinakattara null.
		 */
		public function getSquare(i_index:int):FLARSquare
		{
			return this._callback.result_stack.getItem(i_index).square;
		}
		
		/**
		 * getTransmationMatrixの計算モードを設定します。
		 * 
		 * @param i_is_continue
		 * TRUEなら、transMatContinueを使用します。 FALSEなら、transMatを使用します。
		 */
		public function setContinueMode(i_is_continue:Boolean):void
		{
			this._is_continue = i_is_continue;
		}
		/**
		 * 2値化した画像を返却します。
		 * 
		 * @return 画像情報を返却します
		 */
		public function get thresholdedBitmapData() :BitmapData
		{
			try {
				return BitmapData(FLARBinRaster(this._bin_raster).getBuffer());
			} catch (e:Error) {
				return null;
			}
			return null;
		}
	}
}