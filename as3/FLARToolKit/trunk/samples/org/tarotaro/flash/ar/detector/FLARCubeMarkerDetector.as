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

package org.tarotaro.flash.ar.detector {

	import flash.utils.Dictionary;
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

	/**
	 * 複数マーカ用のDetectorを基に作成中のキューブ用Detector。
	 * まだ上手く動きません。
	 * 
	 */
	public class FLARCubeMarkerDetector {

		private static const AR_SQUARE_MAX:int = 300;
		
		/**
		 * マーカ検索時の、画像バッファと入力画像のサイズ比較を行うかどうか
		 */
		private var _sizeCheckEnabled:Boolean = true;

		/**
		 * 
		 */
		private var _is_continue:Boolean = false;

		/**
		 * パターン評価器
		 */
		private var _match_patt:FLARMatchPatt_Color_WITHOUT_PCA;

		/**
		 * 入力画像からマーカ候補となるSquareを検出するDetector
		 */
		private var _square_detect:IFLARSquareDetector;

		/**
		 * 入力画像内のSquare一覧
		 */
		private const _square_list:FLARSquareStack = new FLARSquareStack(AR_SQUARE_MAX);

		/**
		 * キューブ型マーカ
		 */
		private var _marker:CubeMarker;

		/**
		 * 
		 */
		protected var _transmat:IFLARTransMat;

		/**
		 * マーカの幅
		 */
		private var _marker_width:int;

		// 検出結果の保存用
		private var _patt:IFLARColorPatt;

		/**
		 * 「この一致度を越えたら、その時点でキューブ発見としてよい」と言う一致度の閾値
		 */
		private var _immidiateEndConfidence:Number;
		
		/**
		 * 「Squareに対して全マーカを検査した結果、最大一致度がこの値を超えていたらマーカ発見としてよい」と言う一致度の閾値
		 */
		private var _endConfidence:Number;

		/**
		 * 検出時のフラグ
		 */
		private var _detectFlag:uint;
		private static const DETECT_FLAGS:Dictionary = new Dictionary();

		/**
		 * 
		  * @param	i_param	カメラパラメータを指定します。
		  * @param	i_code	キューブ型マーカを指定します。
		 * @param	immidateEndConfidence
		 * @param	endConfidence
		 */
		public function FLARCubeMarkerDetector(i_param:FLARParam, i_code:CubeMarker, 
												immidateEndConfidence:Number = 0.9,endConfidence:Number = 0.8) {
			
			DETECT_FLAGS[CubeMarkerDirection.TOP] = 1;
			DETECT_FLAGS[CubeMarkerDirection.BOTTOM] = 2;
			DETECT_FLAGS[CubeMarkerDirection.FRONT] = 4;
			DETECT_FLAGS[CubeMarkerDirection.BACK] = 8;
			DETECT_FLAGS[CubeMarkerDirection.LEFT] = 16;
			DETECT_FLAGS[CubeMarkerDirection.RIGHT] = 32;

			//閾値を設定
			this.setEndConfidences(immidateEndConfidence, endConfidence);

			//scrとは、「screen」の略。srcの打ち間違いではない事に注意！
			const scr_size:FLARIntSize = i_param.getScreenSize();
			
			// 解析オブジェクトを作る
			this._square_detect = new FLARSquareDetector(i_param.getDistortionFactor(), scr_size);
			this._transmat = new FLARTransMat(i_param);
			
			// キューブ型マーカを保存
			this._marker = i_code;

			//キューブ型マーカの内、nullの面を調査し、保持
			this.checkNullMarker();
			
			// 評価パターンのホルダを作る
			this._patt = new FLARColorPatt_O3(this._marker.top.getWidth(), this._marker.top.getWidth());

			//マーカの幅を記録
			this._marker_width = this._marker.size;
			
			// 評価器を作る。
			this._match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();
			
			//２値画像バッファを作る
			this._bin_raster = new FLARRaster_BitmapData(scr_size.w, scr_size.h);
			
			trace("マーカ有無:", this._detectFlag);
		}
		
		private function checkNullMarker():void
		{
			this._detectFlag = 0;
			if (this._marker == null) return;
			this._detectFlag |= this._marker.top == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.TOP];
			this._detectFlag |= this._marker.bottom == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.BOTTOM];
			this._detectFlag |= this._marker.front == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.FRONT];
			this._detectFlag |= this._marker.back == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.BACK];
			this._detectFlag |= this._marker.left == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.LEFT];
			this._detectFlag |= this._marker.right == null ? 0 : DETECT_FLAGS[CubeMarkerDirection.RIGHT];
		}

		/**
		 * 終了閾値を設定する。
		 * @param	immidate
		 * @param	end
		 */
		private function setEndConfidences(immidate:Number, end:Number):void
		{
			if (immidate < end) {
				throw new ArgumentError("即時終了条件" + immidate + "は、終了条件" + end + "以上である必要があります。");
			}
			this._immidiateEndConfidence = immidate;
			this._endConfidence = end;
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
		 * 即時終了条件：
		 * １．一致度がthis._immidiateEndConfidenceを超えるマーカが見つかった場合⇒そのマーカが一致とし、即時終了
		 * 終了条件：
		 * １．Squareに対する全マーカ評価後、そのSquareに対して最も高い一致度がthis._endConfidenceを超える
		 * 　　マーカが見つかった場合⇒そのマーカが一致とみなし、終了
		 * 探索条件：
		 * １．Squareに対して最高一致度を出したマーカは、他のSquareで評価しない
		 * 
		 * 戻り値に含まれるもの：
		 * １．square
		 * ２．マーカのdirection
		 * ３．confidence
		 * ４．キューブのdirection(TOPとか)
		 * @param i_raster
		 * マーカーを検出するイメージを指定します。
		 * @param i_thresh
		 * 検出閾値を指定します。0～255の範囲で指定してください。 通常は100～130くらいを指定します。
		 * @return 見つかったマーカーの数を返します。 マーカーが見つからない場合は0を返します。
		 * @throws FLARException
		 */
		public function detectMarkerLite(i_raster:IFLARRgbRaster, i_threshold:int):CubeMarkerDetectedResult {
			// サイズチェック
			if (!this._bin_raster.getSize().isEqualSizeO(i_raster.getSize())) {
				if (this._sizeCheckEnabled ) 
					throw new FLARException("サイズ不一致(" + this._bin_raster.getSize() + ":" + i_raster.getSize());
				else {
					//２値画像バッファを作る
					this._bin_raster = new FLARRaster_BitmapData(i_raster.getSize().w, i_raster.getSize().h);
				}
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

			// Square毎に、一致するコードを決定していく
			var square:FLARSquare;	//検査対象のSquareを格納しておく
			//結果を保存しておくオブジェクト
			var result:CubeMarkerMatchResultTemporaryHolder = new CubeMarkerMatchResultTemporaryHolder();
			var maxMarkerDirection:String;
			var detectFlagTemp:uint = this._detectFlag;

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

				//１．まずはTOPから
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.TOP]) {
					_match_patt.evaluate(this._marker.top);
					result.topConf = _match_patt.getConfidence();
					result.topDir = _match_patt.getDirection();
					result.topSq = square;
					if (result.topConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.topConf, result.topDir, square, CubeMarkerDirection.TOP);
					}
				}
				
				//２．次はFRONT
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.FRONT]) {
					_match_patt.evaluate(this._marker.front);
					result.frontConf = _match_patt.getConfidence();
					result.frontDir = _match_patt.getDirection();
					result.frontSq = square;
					if (result.frontConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.frontConf, result.frontDir, square, CubeMarkerDirection.FRONT);
					}
				}
				
				//３．次はBACK
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.BACK]) {
					_match_patt.evaluate(this._marker.back);
					result.backConf = _match_patt.getConfidence();
					result.backDir = _match_patt.getDirection();
					result.backSq = square;
					if (result.backConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.backConf, result.backDir, square, CubeMarkerDirection.BACK);
					}
				}

				//４．次はLEFT
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.LEFT]) {
					_match_patt.evaluate(this._marker.left);
					result.leftConf = _match_patt.getConfidence();
					result.leftDir = _match_patt.getDirection();
					result.leftSq = square;
					if (result.leftConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.leftConf, result.leftDir, square, CubeMarkerDirection.LEFT);
					}
				}

				//５．次はRIGHT
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.RIGHT]) {
					_match_patt.evaluate(this._marker.right);
					result.rightConf = _match_patt.getConfidence();
					result.rightDir = _match_patt.getDirection();
					result.rightSq = square;
					if (result.rightConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.rightConf, result.rightDir, square, CubeMarkerDirection.RIGHT);
					}
				}

				//６．最後はBOTTOM
				if (detectFlagTemp & DETECT_FLAGS[CubeMarkerDirection.BOTTOM]) {
					_match_patt.evaluate(this._marker.bottom);
					result.bottomConf = _match_patt.getConfidence();
					result.bottomDir = _match_patt.getDirection();
					result.bottomSq = square;
					if (result.bottomConf > this._immidiateEndConfidence) {
						//即時終了条件1に一致
						return this.createDetectedResult
							(result.bottomConf, result.bottomDir, square, CubeMarkerDirection.BOTTOM);
					}
				}
				
				//一番一致度の高かった面を調査
				result.checkMaxConfidenceDirection();
				//最高一致度が終了条件に達しているかを調査
				if (result.currentMaxConfidence > this._endConfidence) {
					//終了条件1に合致したため、終了
					return this.createDetectedResult(result.currentMaxConfidence, 
													result.currentMaxConfidenceDirection, 
													square,
													result.currentMaxConfidenceMarkerDirection);
				} else if (detectFlagTemp & DETECT_FLAGS[result.currentMaxConfidenceMarkerDirection]) {
					//最高一致したマーカは、次は評価しない
					detectFlagTemp ^= DETECT_FLAGS[result.currentMaxConfidenceMarkerDirection];
				}
				
			}
			return this.createDetectedResult(result.currentMaxConfidence, 
											result.currentMaxConfidenceDirection, 
											square,
											result.currentMaxConfidenceMarkerDirection);
			//return number_of_square;
		}

		private function createDetectedResult(confidence:Number,
												direction:int, 
												square:FLARSquare,
												markerDirection:String):CubeMarkerDetectedResult 
		{
					var ret:CubeMarkerDetectedResult = new CubeMarkerDetectedResult();
					ret._confidence = confidence;
					ret._direction = direction;
					ret._square = square;
					ret._markerDirection = markerDirection;
					return ret;
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
		public function getTransmationMatrix(result:CubeMarkerDetectedResult, o_result:FLARTransMatResult):void {
			//一番一致したマーカーの位置とかその辺を計算
			if (_is_continue) {
				_transmat.transMatContinue(result.square, result.direction, this._marker.size, o_result);
			} else {
				_transmat.transMat(result.square, result.direction, this._marker.size, o_result);
			}
			return;
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
