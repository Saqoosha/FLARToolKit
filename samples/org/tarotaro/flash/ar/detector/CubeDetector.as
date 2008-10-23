package org.tarotaro.flash.ar.detector 
{
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARSquareStack;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_ARToolkitThreshold;
	import org.libspark.flartoolkit.FLARException;
	
	/**
	 * キューブ型マーカを検出するDetector
	 * まだ使えません
	 * @author 太郎(tarotaro.org)
	 */
	public class CubeDetector 
	{
		/**
		 * キューブ型マーカ
		 */
		private var _cube:CubeMarker;
		/**
		 * キューブ内にあるマーカとキューブの間の余白の大きさ
		 */
		private var _space:int;

		/**
		 * マーカ検出時に使う画像領域
		 */
		private var _bin_raster:FLARBinRaster;
		/**
		 * マーカ検出時に使うフィルタ
		 */
		private var _tobin_filter:FLARRasterFilter_ARToolkitThreshold = new FLARRasterFilter_ARToolkitThreshold(100);

		public function CubeDetector(cube:CubeMarker,space:int = 0) 
		{
			this._cube = cube;
			this._space = space;
		}
		
		public function detectMarkerLite(i_raster:IFLARRgbRaster, i_threshold:int):int 
		{
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
			
			//スクエアを大きさ順に並べる
			var sqArray:Array = l_square_list.getArray();
			sqArray.sort(function(a:Object, b:Object):Number {
				return a.label.size - b.label.size;
			}
			
			//スクエアを調査
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
				//前⇒左⇒右⇒後⇒頂点の順番
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
		}
		
		return true;
	}
	
}