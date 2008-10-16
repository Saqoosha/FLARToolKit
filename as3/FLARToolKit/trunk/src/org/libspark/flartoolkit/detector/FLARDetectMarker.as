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
 */

package org.libspark.flartoolkit.detector {
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARSquareDetector;
	import org.libspark.flartoolkit.core.FLARSquareStack;
	import org.libspark.flartoolkit.core.IFLARSquareDetector;
	import org.libspark.flartoolkit.core.match.FLARMatchPatt_Color_WITHOUT_PCA;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.pickup.FLARColorPatt_O3;
	import org.libspark.flartoolkit.core.pickup.IFLARColorPatt;
	import org.libspark.flartoolkit.core.raster.FLARBinRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_ARToolkitThreshold;
	import org.libspark.flartoolkit.core.transmat.FLARTransMat;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.core.transmat.IFLARTransMat;
	import org.libspark.flartoolkit.core.types.FLARIntSize;	

	/**
	 * 複数のマーカーを検出し、それぞれに最も一致するARコードを、コンストラクタで登録したARコードから 探すクラスです。最大300個を認識しますが、ゴミラベルを認識したりするので100個程度が限界です。
	 * 
	 */
	public class FLARDetectMarker {

		private static const AR_SQUARE_MAX:int = 300;

		private var _is_continue:Boolean = false;

		private var _match_patt:FLARMatchPatt_Color_WITHOUT_PCA;

		private var _square_detect:IFLARSquareDetector;

		private const _square_list:FLARSquareStack = new FLARSquareStack(AR_SQUARE_MAX);

		private var _codes:Array; // FLARCode[]

		protected var _transmat:IFLARTransMat;

		private var _marker_width:Array; // double[]

		private var _number_of_code:int;

		// 検出結果の保存用
		private var _patt:IFLARColorPatt;

		private var _result_holder:FLARDetectMarkerResultHolder = new FLARDetectMarkerResultHolder();

		/**
		 * 複数のマーカーを検出し、最も一致するARCodeをi_codeから検索するオブジェクトを作ります。
		 * 
		 * @param i_param
		 * カメラパラメータを指定します。
		 * @param i_code	FLARCode[] 
		 * 検出するマーカーのARCode配列を指定します。配列要素のインデックス番号が、そのままgetARCodeIndex関数で 得られるARCodeインデックスになります。 例えば、要素[1]のARCodeに一致したマーカーである場合は、getARCodeIndexは1を返します。
		 * 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。
		 * @param i_marker_width	double[] 
		 * i_codeのマーカーサイズをミリメートルで指定した配列を指定します。 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。
		 * @param i_number_of_code
		 * i_codeに含まれる、ARCodeの数を指定します。
		 * @throws FLARException
		 */
		public function FLARDetectMarker(i_param:FLARParam, i_code:Array, i_marker_width:Array, i_number_of_code:int) {
			const scr_size:FLARIntSize = i_param.getScreenSize();
			// 解析オブジェクトを作る
			this._square_detect = new FLARSquareDetector(i_param.getDistortionFactor(), scr_size);
			this._transmat = new FLARTransMat(i_param);
			// 比較コードを保存
			this._codes = i_code;
			// 比較コードの解像度は全部同じかな？（違うとパターンを複数種つくらないといけないから）
			const cw:int = i_code[0].getWidth();
			const ch:int = i_code[0].getHeight();
			for (var i:int = 1; i < i_number_of_code; i++) {
				if (cw != i_code[i].getWidth() || ch != i_code[i].getHeight()) {
					// 違う解像度のが混ざっている。
					throw new FLARException();
				}
			}
			// 評価パターンのホルダを作る
			this._patt = new FLARColorPatt_O3(cw, ch);
			this._number_of_code = i_number_of_code;

			this._marker_width = i_marker_width;
			// 評価器を作る。
			this._match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();
			//２値画像バッファを作る
			this._bin_raster = new FLARBinRaster(scr_size.w, scr_size.h);		
		}

		private var _bin_raster:FLARBinRaster;

		private var _tobin_filter:FLARRasterFilter_ARToolkitThreshold = new FLARRasterFilter_ARToolkitThreshold(100);

		/**
		 * i_imageにマーカー検出処理を実行し、結果を記録します。
		 * 
		 * @param i_raster
		 * マーカーを検出するイメージを指定します。
		 * @param i_thresh
		 * 検出閾値を指定します。0～255の範囲で指定してください。 通常は100～130くらいを指定します。
		 * @return 見つかったマーカーの数を返します。 マーカーが見つからない場合は0を返します。
		 * @throws FLARException
		 */
		public function detectMarkerLite(i_raster:IFLARRgbRaster, i_threshold:int):int {
			// サイズチェック
			if (!this._bin_raster.getSize().isEqualSizeO(i_raster.getSize())) {
				throw new FLARException();
			}

			// ラスタを２値イメージに変換する.
			this._tobin_filter.setThreshold(i_threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);

			var l_square_list:FLARSquareStack = this._square_list;
			// スクエアコードを探す
			this._square_detect.detectMarker(this._bin_raster, l_square_list);

			const number_of_square:int = l_square_list.getLength();
			// コードは見つかった？
			if (number_of_square < 1) {
				// ないや。おしまい。
				return 0;
			}
			// 保持リストのサイズを調整
			this._result_holder.reservHolder(number_of_square);

			// 1スクエア毎に、一致するコードを決定していく
			var i:int;
			var square:FLARSquare;
			var code_index:int;
			var confidence:Number;
			var direction:int;
			var i2:int;
			var c2:Number;
			for (i = 0; i < number_of_square; i++) {
				square = l_square_list.getItem(i) as FLARSquare;
				// 評価基準になるパターンをイメージから切り出す
				if (!this._patt.pickFromRaster(i_raster, square)) {
					// イメージの切り出しは失敗することもある。
					continue;
				}
				// パターンを評価器にセット
				if (!this._match_patt.setPatt(this._patt)) {
					// 計算に失敗した。
					throw new FLARException();
				}
				// コードと順番に比較していく
				code_index = 0;
				_match_patt.evaluate(_codes[0]);
				confidence = _match_patt.getConfidence();
				direction = _match_patt.getDirection();
				for (i2 = 1;i2 < this._number_of_code; i2++) {
					// コードと比較する
					_match_patt.evaluate(_codes[i2]);
					c2 = _match_patt.getConfidence();
					if (confidence > c2) {
						continue;
					}
					// より一致するARCodeの情報を保存
					code_index = i2;
					direction = _match_patt.getDirection();
					confidence = c2;
				}
				// i番目のパターン情報を保存する。
				const result:FLARDetectMarkerResult = this._result_holder.result_array[i];
				result.arcode_id = code_index;
				result.confidence = confidence;
				result.direction = direction;
				result.ref_square = square;
			}
			return number_of_square;
		}

		/**
		 * i_indexのマーカーに対する変換行列を計算し、結果値をo_resultへ格納します。 直前に実行したdetectMarkerLiteが成功していないと使えません。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @param o_result
		 * 結果値を受け取るオブジェクトを指定してください。
		 * @throws FLARException
		 */
		public function getTransmationMatrix(i_index:int, o_result:FLARTransMatResult):void {
			const result:FLARDetectMarkerResult = this._result_holder.result_array[i_index];
			// 一番一致したマーカーの位置とかその辺を計算
			if (_is_continue) {
				_transmat.transMatContinue(result.ref_square, result.direction, _marker_width[result.arcode_id], o_result);
			} else {
				_transmat.transMat(result.ref_square, result.direction, _marker_width[result.arcode_id], o_result);
			}
			return;
		}

		/**
		 * i_indexのマーカーの一致度を返します。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @return マーカーの一致度を返します。0～1までの値をとります。 一致度が低い場合には、誤認識の可能性が高くなります。
		 * @throws FLARException
		 */
		public function getConfidence(i_index:int):Number {
			return this._result_holder.result_array[i_index].confidence;
		}

		/**
		 * i_indexのマーカーの方位を返します。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @return 0,1,2,3の何れかを返します。
		 */
		public function getDirection(i_index:int):int {
			return this._result_holder.result_array[i_index].direction;
		}

		/**
		 * i_indexのマーカーのARCodeインデックスを返します。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @return
		 */
		public function getARCodeIndex(i_index:int):int {
			return this._result_holder.result_array[i_index].arcode_id;
		}

		/**
		 * getTransmationMatrixの計算モードを設定します。
		 * 
		 * @param i_is_continue
		 * TRUEなら、transMatContinueを使用します。 FALSEなら、transMatを使用します。
		 */
		public function setContinueMode(i_is_continue:Boolean):void {
			this._is_continue = i_is_continue;
		}
	}
}

import org.libspark.flartoolkit.core.FLARSquare;	

class FLARDetectMarkerResult {

	public var arcode_id:int;

	public var direction:int;

	public var confidence:Number;

	public var ref_square:FLARSquare;
}

class FLARDetectMarkerResultHolder {

	public var result_array:Array = new Array(1); //new FLARDetectMarkerResult[1]; // FLARDetectMarkerResult[]

	/**
	 * result_holderを最大i_reserve_size個の要素を格納できるように予約します。
	 * 
	 * @param i_reserve_size
	 */
	public function reservHolder(i_reserve_size:int):void {
		if (i_reserve_size >= result_array.length) {
			var new_size:int = i_reserve_size + 5;
			result_array = new Array(new_size); //new FLARDetectMarkerResult[new_size];
			for (var i:int = 0; i < new_size; i++) {
				result_array[i] = new FLARDetectMarkerResult();
			}
		}
	}
}
