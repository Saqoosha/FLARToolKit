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
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 * 
 */

package org.libspark.flartoolkit.detector {
	import org.libspark.flartoolkit.core.raster.FLARRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_BitmapDataThreshold;
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
	import org.tarotaro.flash.ar.detector.CubeMarker;

	/**
	 * 複数マーカ用のDetectorを基に作成中のキューブ用Detector。
	 * まだ上手く動きません。
	 * 
	 */
	public class CubeMarkerDetector {

		private static const AR_SQUARE_MAX:int = 300;
		private var _sizeCheckEnabled:Boolean = true;

		private var _is_continue:Boolean = false;

		private var _match_patt:FLARMatchPatt_Color_WITHOUT_PCA;

		private var _square_detect:IFLARSquareDetector;

		private const _square_list:FLARSquareStack = new FLARSquareStack(AR_SQUARE_MAX);

		private var _codes:Array; // FLARCode[]
		private var _marker:CubeMarker;
		private var _codeResult:Array;

		protected var _transmat:IFLARTransMat;

		private var _marker_width:Array; // double[]

		private var _number_of_code:int;

		// 検出結果の保存用
		private var _patt:IFLARColorPatt;

		private var _result_holder:FLARMultiMarkerDetectorResultHolder = new FLARMultiMarkerDetectorResultHolder();

		 /**
		  * 
		  * @param	i_param	カメラパラメータを指定します。
		  * @param	i_code	キューブ型マーカを指定します。
		  */
		public function CubeMarkerDetector(i_param:FLARParam, i_code:CubeMarker) {
			
			//scrとは、「screen」の略。srcの打ち間違いではない事に注意！
			const scr_size:FLARIntSize = i_param.getScreenSize();
			
			// 解析オブジェクトを作る
			this._square_detect = new FLARSquareDetector(i_param.getDistortionFactor(), scr_size);
			this._transmat = new FLARTransMat(i_param);
			
			// 比較コードを保存
			this._marker = i_code;

			// 評価パターンのホルダを作る
			this._patt = new FLARColorPatt_O3(this._marker.top.getWidth(), this._marker.top.getWidth());

			//マーカの幅を記録
			this._marker_width = this._marker.size;
			
			// 評価器を作る。
			this._match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();
			
			//２値画像バッファを作る
			this._bin_raster = new FLARRaster_BitmapData(scr_size.w, scr_size.h);
		}

		/**
		 * #detectMarkerLiteで使用する作業領域
		 */
		private var _bin_raster:IFLARRaster;

		/**
		 * #detectMarkerLiteで使用するフィルタ(画像を2値化)
		 */
		private var _tobin_filter:FLARRasterFilter_BitmapDataThreshold = new FLARRasterFilter_BitmapDataThreshold(100);

		/**
		 * i_rasterにマーカー検出処理を実行し、結果を記録します。
		 * 終了条件：
		 * １．一致度が0.9を超えるマーカが見つかった場合⇒そのマーカが一致とし、即時終了
		 * ２．Squareに対する全マーカ発見後、一致度が0.75を超えるマーカが見つかり、かつそれがSquareに対する最高一致度⇒そのマーカが一致とみなす
		 * 探索条件：
		 * １．Squareに対して最高一致度を出したマーカは、他のSquareで評価しない
		 *
		 * @param i_raster
		 * マーカーを検出するイメージを指定します。
		 * @param i_thresh
		 * 検出閾値を指定します。0～255の範囲で指定してください。 通常は100～130くらいを指定します。
		 * @return 見つかったマーカーの数を返します。 マーカーが見つからない場合は0を返します。
		 * @throws FLARException
		 */
		public function detectMarkerLite(i_raster:IFLARRgbRaster, i_threshold:int):FLARMultiMarkerDetectorResult {
			// サイズチェック
			if(this._sizeCheckEnabled && !this._bin_raster.getSize().isEqualSizeO(i_raster.getSize())) {
				throw new FLARException("サイズ不一致(" + this._bin_raster.getSize() + ":" + i_raster.getSize());
			}

			// ラスタを２値イメージに変換する.
			this._tobin_filter.setThreshold(i_threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);

			// マーカ候補となるSquareを探す
			var l_square_list:FLARSquareStack = this._square_list;
			this._square_detect.detectMarker(this._bin_raster, l_square_list);

			// マーカ候補となるSquareが1個も無い場合、終了
			const number_of_square:int = l_square_list.getLength();
			if (number_of_square < 1) {
				return null;
			}

			// 保持リストのサイズを調整
			this._result_holder.reservHolder(number_of_square);

			// Square毎に、一致するコードを決定していく
			var square:FLARSquare;	//検査対象のSquareを格納しておく
			var code_index:int;		//
			var confidence:Number;	//マーカパターンとSquareの一致度
			var direction:int;		//マーカの向き
			var i2:int;				//
			var c2:Number;			//一致度2
			
			//Squareリストを走査する
			for (var i:int = 0; i < number_of_square; i++) {
				//Squareを取り出す
				square = l_square_list.getItem(i) as FLARSquare;
				
				// 評価基準になるパターンをイメージから切り出す
				if (!this._patt.pickFromRaster(i_raster, square)) {
					// イメージの切り出しは失敗することもある。
					continue;
				}
				// パターンを評価器にセット
				if (!this._match_patt.setPatt(this._patt)) {
					// 計算に失敗した。
					throw new FLARException("パターンを評価器にセット：失敗！");
				}
				// コードと順番に比較していく
				
				
				//まずはTOPから
				_match_patt.evaluate(this._marker.top);
				confidence = _match_patt.getConfidence();
				direction = _match_patt.getDirection();
				if (confidence > 0.9) {
					//終了条件1に一致
					return ;
				}
				for (i2 = 1; i2 < this._number_of_code; i2++) {
					if (this._codeResult[i2]) continue;
					// コードと比較する
					_match_patt.evaluate(_codes[i2]);
					c2 = _match_patt.getConfidence();
					trace(i, i2, c2,"(",square.label.area,")");
					if (confidence > c2) {
						continue;
					}
					// より一致するARCodeの情報を保存
					code_index = i2;
					direction = _match_patt.getDirection();
					confidence = c2;
				}
				//if (confidence > 0.8) trace("GREAT!!",i, code_index, confidence);
				// i番目のパターン情報を保存する。
				var result:FLARMultiMarkerDetectorResult = this._result_holder.result_array[i];
				result._codeId = code_index;
				result._confidence = confidence;
				result._direction = direction;
				result._square = square;
				this._codeResult[code_index] = true;
				if (confidence > 0.8) return result;
			}
			return null;
			//return number_of_square;
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
			const result:FLARMultiMarkerDetectorResult = this._result_holder.result_array[i_index];
			// 一番一致したマーカーの位置とかその辺を計算
			if (_is_continue) {
				_transmat.transMatContinue(result.square, result.direction, _marker_width[result.codeId], o_result);
			} else {
				_transmat.transMat(result.square, result.direction, _marker_width[result.codeId], o_result);
			}
			return;
		}

		public function getResult(i_index:int):FLARMultiMarkerDetectorResult
		{
			return this._result_holder.result_array[i_index];
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
		
		/**
		 * 入力画像のサイズチェックをする／しない的な。（デフォルトではチェックする）
		 */
		public function get sizeCheckEnabled():Boolean {
			return this._sizeCheckEnabled;
		}
		public function set sizeCheckEnabled(value:Boolean):void {
			this._sizeCheckEnabled = value;
		}

	}
}
