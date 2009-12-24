package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.type.*;
	
	public class SingleARMarkerProcesserAS extends NyARBaseClassAS
	{
		private var _ma:Marshal=new Marshal();

		/**オーナーが自由に使えるタグ変数です。
		 */
		public var tag:Object;
	
		private var _lost_delay_count:int = 0;
	
		private var _lost_delay:int = 5;
	
		private var _square_detect:INyARSquareDetector;
	
		protected var _transmat:INyARTransMat;
	
		private var _marker_width:Number;
	
		private var _match_patt:Vector.<NyARMatchPatt_Color_WITHOUT_PCA>;
	
		private var _square_list:NyARSquareStack = new NyARSquareStack(100);
	
		private var _patt:INyARColorPatt = null;
	
		private var _cf_threshold_new:Number = 0.30;
		private var _cf_threshold_exist:Number = 0.15;
		
		private var _threshold:int = 110;
		// [AR]検出結果の保存用
		private var _bin_raster:NyARBinRaster;
	
		private var _tobin_filter:NyARRasterFilter_ARToolkitThreshold;
	
		protected var _current_arcode_index:int = -1;
	
		private var _deviation_data:NyARMatchPattDeviationColorData;
		private var _threshold_detect:NyARRasterThresholdAnalyzer_SlidePTile;
		
		public function SingleARMarkerProcesserAS()
		{
			return;
		}

		private function freeARCodeTable():void
		{
			//割当済のオブジェクトを削除
			this._patt.dispose();
			this._deviation_data.dispose();
			if(this._match_patt!=null){
				for(var i:int=0;i<this._match_patt.length;i++){
					this._match_patt[i].dispose();
				}
			}
			return;
		}
		public override function dispose():void
		{
			super.dispose();
			//setARCodeTableで割り当てられたオブジェクトを開放
			freeARCodeTable();
			this._square_list.dispose();
			if(this._initialized==true){
				//initInstanceで割り当てたオブジェクトを開放
				this._square_detect.dispose();
				this._transmat.dispose();
				this._bin_raster.dispose();
				this._tobin_filter.dispose();
				this._threshold_detect.dispose();
			}
			return;
		}
	
		private var _initialized:Boolean=false;
	
		protected function initInstance(i_param:NyARParam,i_raster_type:int):void
		{
			//初期化済？
			
			NyARToolkitAS3.Assert(this._initialized==false);
			
			var scr_size:NyARIntSize = i_param.getScreenSize();
			// 解析オブジェクトを作る
			this._square_detect = new NyARSquareDetector_Rle(i_param.getDistortionFactor(), scr_size);
			this._transmat = new NyARTransMat(i_param);
			this._tobin_filter=new NyARRasterFilter_ARToolkitThreshold(110,i_raster_type);

			//サイズの読み出し
			scr_size.getValue(_ma);
			_ma.prepareRead();
			var size_w:int=_ma.readInt();
			var size_h:int=_ma.readInt();
	
	
			// ２値画像バッファを作る
			this._bin_raster = new NyARBinRaster(size_w,size_h);
			this._threshold_detect=new NyARRasterThresholdAnalyzer_SlidePTile(15,i_raster_type,4);
			this._initialized=true;
			return;
		}
	
		/*自動・手動の設定が出来ないので、コメントアウト
		public void setThreshold(int i_threshold)
		{
			this._threshold = i_threshold;
			return;
		}*/
	
		/**検出するマーカコードの配列を指定します。 検出状態でこの関数を実行すると、
		 * オブジェクト状態に強制リセットがかかります。
		 */
		public function setARCodeTable(i_ref_code_table:Vector.<NyARCode>,i_code_resolution:int,i_marker_width:Number):void
		{
			if (this._current_arcode_index != -1) {
				// 強制リセット
				reset(true);
			}
			//検出するマーカセット、情報、検出器を作り直す。(1ピクセル4ポイントサンプリング,マーカのパターン領域は50%)
			this._patt = new NyARColorPatt_Perspective_O2(i_code_resolution, i_code_resolution,4,25);
			this._deviation_data=new NyARMatchPattDeviationColorData(i_code_resolution, i_code_resolution);
			this._marker_width = i_marker_width;
	
			this._match_patt = new Vector.<NyARMatchPatt_Color_WITHOUT_PCA>(i_ref_code_table.length);
			for(var i:int=0;i<i_ref_code_table.length;i++){
				this._match_patt[i]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code_table[i]);
			}
			return;
		}
	
		public function reset(i_is_force:Boolean):void
		{
			if (this._current_arcode_index != -1 && i_is_force == false) {
				// 強制書き換えでなければイベントコール
				this.onLeaveHandler();
			}
			// カレントマーカをリセット
			this._current_arcode_index = -1;
			return;
		}
	
		public function detectMarker(i_raster:INyARRgbRaster):void
		{
			// サイズチェック
			//assert(this._bin_raster.getSize().isEqualSize(i_raster.getSize().w, i_raster.getSize().h));
	
			// コードテーブルが無ければここで終わり
			if (this._match_patt== null) {
				return;
			}
	
			// ラスタを(1/4の画像の)２値イメージに変換する.
			this._tobin_filter.setThreshold(this._threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);
	
			var square_stack:NyARSquareStack = this._square_list;
			// スクエアコードを探す
			this._square_detect.detectMarker(this._bin_raster, square_stack);
			// 認識処理
			if (this._current_arcode_index == -1) { // マーカ未認識
				detectNewMarker(i_raster, square_stack);
			} else { // マーカ認識中
				detectExistMarker(i_raster, square_stack, this._current_arcode_index);
			}
			return;
		}
	
		
		private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
		
		/**ARCodeのリストから、最も一致するコード番号を検索します。
		 */
		private function selectARCodeIndexFromList(i_raster:INyARRgbRaster,i_square:NyARSquare,o_result:TResult_selectARCodeIndex):Boolean
		{
			// 現在コードテーブルはアクティブ？
			if (this._match_patt==null) {
				return false;
			}
			// 評価基準になるパターンをイメージから切り出す
			if (!this._patt.pickFromRaster(i_raster, i_square)) {
				return false;
			}
			//評価データを作成して、評価器にセット
			this._deviation_data.setRaster(this._patt);		
			var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
			var code_index:int = 0;
			var dir:int = 0;
			var c1:Number = 0;
			// コードと比較する
			var ma:Marshal=this._ma;
			for (var i:int = 0; i < this._match_patt.length; i++) {
				this._match_patt[i].evaluate(this._deviation_data,mr);
				
				//mrから値を読み出し
				mr.getValue(ma);
				ma.prepareRead();
				var mr_direction:int =ma.readInt();				
				var c2:Number = ma.readDouble();
				if (c1 < c2) {
					code_index = i;
					c1 = c2;
					dir = mr_direction;
				}
			}
			o_result.code_index = code_index;
			o_result.direction = dir;
			o_result.confidence = c1;
			return true;
		}
	
		private var __detect_X_Marker_detect_result:TResult_selectARCodeIndex = new TResult_selectARCodeIndex();
	
		/**新規マーカ検索 現在認識中のマーカがないものとして、最も認識しやすいマーカを１個認識します。
		 */
		private function detectNewMarker(i_raster:INyARRgbRaster,i_stack:NyARSquareStack):void
		{
			var number_of_square:int = i_stack.getLength();
			var cf:Number = 0;
			var dir:int = 0;
			var code_index:int = -1;
			var square_index:int = 0;
			var detect_result:TResult_selectARCodeIndex = this.__detect_X_Marker_detect_result;
			for (var i:int = 0; i < number_of_square; i++) {
				if (!selectARCodeIndexFromList(i_raster, (i_stack.getItem(i)), detect_result)) {
					// 見つからない。
					return;
				}
				if (detect_result.confidence < this._cf_threshold_new) {
					continue;
				}
				if (detect_result.confidence < cf) {
					// 一致度が低い。
					continue;
				}
				cf = detect_result.confidence;
				code_index = detect_result.code_index;
				square_index = i;
				dir = detect_result.direction;
			}
			// 認識状態を更新
			var is_id_found:Boolean=updateStatus(this._square_list.getItem(square_index), code_index, cf, dir);
			//閾値フィードバック(detectExistMarkerにもあるよ)
			if(!is_id_found){
				//マーカがなければ、探索+DualPTailで基準輝度検索
				this._threshold_detect.analyzeRaster(i_raster);
				this._threshold=(this._threshold+this._threshold_detect.getThreshold())/2;
			}
		}
	
		/**マーカの継続認識 現在認識中のマーカを優先して認識します。 
		 * （注）この機能はたぶん今後いろいろ発展するからNewと混ぜないこと。
		 */
		private function detectExistMarker(i_raster:INyARRgbRaster,i_stack:NyARSquareStack,i_current_id:int):void
		{
			var number_of_square:int = i_stack.getLength();
			var cf:Number = 0;
			var dir:int = 0;
			var code_index:int = -1;
			var square_index:int = 0;
			var detect_result:TResult_selectARCodeIndex = this.__detect_X_Marker_detect_result;
			for (var i:int = 0; i < number_of_square; i++) {
				if (!selectARCodeIndexFromList(i_raster,i_stack.getItem(i), detect_result)) {
					// 見つからない。
					return;
				}
				// 現在のマーカを認識したか？
				if (detect_result.code_index != i_current_id) {
					// 認識中のマーカではないので無視
					continue;
				}
				if (detect_result.confidence < this._cf_threshold_exist) {
					continue;
				}
				if (detect_result.confidence < cf) {
					// 一致度が高い方を選ぶ
					continue;
				}
				cf = detect_result.confidence;
				code_index = detect_result.code_index;
				dir = detect_result.direction;
				square_index = i;
			}
			// 認識状態を更新
			var is_id_found:Boolean=updateStatus(this._square_list.getItem(square_index), code_index, cf, dir);
			//閾値フィードバック(detectExistMarkerにもあるよ)
			if(!is_id_found){
				//マーカがなければ、探索+DualPTailで基準輝度検索
				this._threshold_detect.analyzeRaster(i_raster);
				this._threshold=(this._threshold+this._threshold_detect.getThreshold())/2;
			}
			
		}
	
		private var __NyARSquare_result:NyARTransMatResult = new NyARTransMatResult();
	
		/**	オブジェクトのステータスを更新し、必要に応じてハンドル関数を駆動します。
		 * 	戻り値は、「実際にマーカを発見する事ができたか」です。クラスの状態とは異なります。
		 */
		private function updateStatus(i_square:NyARSquare,i_code_index:int,i_cf:Number,i_dir:int):Boolean
		{
			var result:NyARTransMatResult = this.__NyARSquare_result;
			if (this._current_arcode_index < 0) {// 未認識中
				if (i_code_index < 0) {// 未認識から未認識の遷移
					// なにもしないよーん。
					return false;
				} else {// 未認識から認識の遷移
					this._current_arcode_index = i_code_index;
					// イベント生成
					// OnEnter
					this.onEnterHandler(i_code_index);
					// 変換行列を作成
					this._transmat.transMat(i_square, i_dir, this._marker_width, result);
					// OnUpdate
					this.onUpdateHandler(i_square, result);
					this._lost_delay_count = 0;
					return true;
				}
			} else {// 認識中
				if (i_code_index < 0) {// 認識から未認識の遷移
					this._lost_delay_count++;
					if (this._lost_delay < this._lost_delay_count) {
						// OnLeave
						this._current_arcode_index = -1;
						this.onLeaveHandler();
					}
					return false;
				} else if (i_code_index == this._current_arcode_index) {// 同じARCodeの再認識
					// イベント生成
					// 変換行列を作成
					this._transmat.transMat(i_square, i_dir, this._marker_width, result);
					// OnUpdate
					this.onUpdateHandler(i_square, result);
					this._lost_delay_count = 0;
					return true;
				} else {// 異なるコードの認識→今はサポートしない。
					throw new  Error("updateStatus");
				}
			}
		}
	
		protected virtual function onEnterHandler(i_code:int):void
		{
		}
	
		protected virtual function onLeaveHandler():void
		{
		}
	
		protected virtual function onUpdateHandler(i_square:NyARSquare,result:NyARTransMatResult):void
		{
		}
	}
}

/**selectARCodeIndexFromListが値を返す時に使う変数型です。
 */

class TResult_selectARCodeIndex
{
	public var direction:int;

	public var confidence:Number;

	public var code_index:int;
}
