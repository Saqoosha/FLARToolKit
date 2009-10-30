package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.type.*;


	/**
	 * 複数のマーカーを検出し、それぞれに最も一致するARコードを、コンストラクタで登録したARコードから 探すクラスです。最大300個を認識しますが、ゴミラベルを認識したりするので100個程度が限界です。
	 * 
	 */
	public class NyARDetectMarkerAS extends NyARBaseClassAS
	{
		private var _ma:Marshal=new Marshal();
		
		private static const AR_SQUARE_MAX:int = 300;
	
		private var _is_continue:Boolean = false;
	
		private var _match_patt:Vector.<NyARMatchPatt_Color_WITHOUT_PCA>;
	
		private var _square_detect:INyARSquareDetector;
	
		private var _square_list:NyARSquareStack = new NyARSquareStack(AR_SQUARE_MAX);
	
		protected var _transmat:INyARTransMat;
	
		private var _marker_width:Vector.<Number>;
	
		// 検出結果の保存用
		private var _patt:INyARColorPatt;
	
		private var _result_holder:NyARDetectMarkerResultHolder = new NyARDetectMarkerResultHolder();
		private var _deviation_data:NyARMatchPattDeviationColorData;
		/**
		 * 複数のマーカーを検出し、最も一致するARCodeをi_codeから検索するオブジェクトを作ります。
		 * 
		 * @param i_param
		 * カメラパラメータを指定します。
		 * @param i_code
		 * 検出するマーカーのARCode配列を指定します。
		 * 配列要素のインデックス番号が、そのままgetARCodeIndex関数で得られるARCodeインデックスになります。 
		 * 例えば、要素[1]のARCodeに一致したマーカーである場合は、getARCodeIndexは1を返します。
		 * @param i_marker_width
		 * i_codeのマーカーサイズをミリメートルで指定した配列を指定します。 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。
		 * @param i_number_of_code
		 * i_codeに含まれる、ARCodeの数を指定します。
		 * @param i_input_raster_type
		 * 入力ラスタのピクセルタイプを指定します。この値は、INyARBufferReaderインタフェイスのgetBufferTypeの戻り値を指定します。
		 * @throws NyARException
		 */
		public function NyARDetectMarkerAS(i_param:NyARParam,i_code:Vector.<NyARCode>,i_marker_width:Vector.<Number>, i_number_of_code:int,i_input_raster_type:int)
		{
			initInstance(i_param,i_code,i_marker_width,i_number_of_code,i_input_raster_type);
			return;
		}
		
		public override function dispose():void
		{		
			super.dispose();
			this._square_list.dispose();
			this._transmat.dispose();
			for(var i:int=0;i<this._match_patt.length;i++){
				this._match_patt[i].dispose();
			}
			this._patt.dispose();
			this._square_detect.dispose();
			this._tobin_filter.dispose();
			this._deviation_data.dispose();
			this._bin_raster.dispose();
			return;
		}
		
		protected function initInstance(
			i_ref_param:NyARParam,
			i_ref_code:Vector.<NyARCode>,
			i_marker_width:Vector.<Number>,
			i_number_of_code:int,
			i_input_raster_type:int):void
		{
	
			var scr_size:NyARIntSize=i_ref_param.getScreenSize();
			// 解析オブジェクトを作る

			this._transmat = new NyARTransMat(i_ref_param);
			//各コード用の比較器を作る。
			this._match_patt=new Vector.<NyARMatchPatt_Color_WITHOUT_PCA>(i_number_of_code);
			var cw:int = i_ref_code[0].getWidth();
			var ch:int = i_ref_code[0].getHeight();
			this._match_patt[0]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code[0]);
			for (var i:int = 1; i < i_number_of_code; i++){
				//解像度チェック
				if (cw != i_ref_code[i].getWidth() || ch != i_ref_code[i].getHeight()) {
					throw new Error("NyARDetectMarker");
				}
				this._match_patt[i]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code[i]);
			}
			//NyARToolkitプロファイル
			this._patt =new NyARColorPatt_Perspective_O2(cw, ch,4,25);
			this._square_detect =new NyARSquareDetector_Rle(i_ref_param.getDistortionFactor(),i_ref_param.getScreenSize());
			this._tobin_filter=new NyARRasterFilter_ARToolkitThreshold(100,i_input_raster_type);
	
			//実サイズ保存
			this._marker_width = i_marker_width;
			//差分データインスタンスの作成
			this._deviation_data=new NyARMatchPattDeviationColorData(cw,ch);

			//サイズの読み出し
			scr_size.getValue(_ma);
			_ma.prepareRead();
			var scr_size_w:int=_ma.readInt();
			var scr_size_h:int=_ma.readInt();
			//２値画像バッファを作る
			this._bin_raster=new NyARBinRaster(scr_size_w,scr_size_h);
			return;		
		}
		
		private var _bin_raster:NyARBinRaster;
	
		private var _tobin_filter:INyARRasterFilter_RgbToBin;
		private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
	
		/**
		 * i_imageにマーカー検出処理を実行し、結果を記録します。
		 * 
		 * @param i_raster
		 * マーカーを検出するイメージを指定します。
		 * @param i_thresh
		 * 検出閾値を指定します。0～255の範囲で指定してください。 通常は100～130くらいを指定します。
		 * @return 見つかったマーカーの数を返します。 マーカーが見つからない場合は0を返します。
		 * @throws NyARException
		 */
		public function detectMarkerLite(i_raster:INyARRgbRaster,i_threshold:int):int
		{
			// サイズチェック
			//if (!this._bin_raster.getSize().isEqualSize(i_raster.getSize())) {
			//	throw new NyARException();
			//}
	
			// ラスタを２値イメージに変換する.
			((NyARRasterFilter_ARToolkitThreshold)(this._tobin_filter)).setThreshold(i_threshold);
			this._tobin_filter.doFilter(i_raster, this._bin_raster);
	
			var l_square_list:NyARSquareStack = this._square_list;
			// スクエアコードを探す
			this._square_detect.detectMarker(this._bin_raster, l_square_list);
	
			var number_of_square:int = l_square_list.getLength();
			// コードは見つかった？
			if (number_of_square < 1) {
				// ないや。おしまい。
				return 0;
			}
			// 保持リストのサイズを調整
			this._result_holder.reservHolder(number_of_square);
			var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
	
			// 1スクエア毎に、一致するコードを決定していく
			for (var i:int = 0; i < number_of_square; i++) {
				var square:NyARSquare = (l_square_list.getItem(i));
	
				// 評価基準になるパターンをイメージから切り出す
				if (!this._patt.pickFromRaster(i_raster, square)) {
					// イメージの切り出しは失敗することもある。
					continue;
				}
				//取得パターンをカラー差分データに変換する。
				this._deviation_data.setRaster(this._patt);
				var square_index:int = 0;
				var direction:int = NyARSquare.DIRECTION_UNKNOWN;
				var confidence:Number = 0;
				for(var i2:int=0;i2<this._match_patt.length;i2++){
					this._match_patt[i2].evaluate(this._deviation_data,mr);
	
					//mrから値を読み出し
					var ma:Marshal=this._ma;
					mr.getValue(ma);
					
					ma.prepareRead();
					var mr_direction:int =ma.readInt();     //direction [0]
					var c2:Number        =ma.readDouble();  //confidence[1]

					if (confidence > c2) {
						continue;
					}
					// もっと一致するマーカーがあったぽい
					square_index = i2;
					direction = mr_direction;
					confidence = c2;
				}
				// i番目のパターン情報を記録する。
				var result:NyARDetectMarkerResult  = this._result_holder.result_array[i];
				result.arcode_id = square_index;
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
		 * @throws NyARException
		 */
		public function getTransmationMatrix(i_index:int,o_result:NyARTransMatResult):void
		{
			var result:NyARDetectMarkerResult = this._result_holder.result_array[i_index];
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
		 * @throws NyARException
		 */
		public function getConfidence(i_index:int):Number
		{
			return this._result_holder.result_array[i_index].confidence;
		}
	
		/**
		 * i_indexのマーカーの方位を返します。
		 * 
		 * @param i_index
		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
		 * @return 0,1,2,3の何れかを返します。
		 */
		public function getDirection(i_index:int):int
		{
			return this._result_holder.result_array[i_index].direction;
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
			return this._result_holder.result_array[i_index].arcode_id;
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
	
	}
}

import jp.nyatla.alchemymaster.*;
import flash.utils.ByteArray;
import jp.nyatla.as3utils.*;	
import jp.nyatla.nyartoolkit.as3.proxy.*;
import jp.nyatla.nyartoolkit.as3.type.*;

class NyARDetectMarkerResult
{
	public var arcode_id:int;

	public var direction:int;

	public var confidence:Number;

	public var ref_square:NyARSquare;
}

class NyARDetectMarkerResultHolder
{
	public var result_array:Vector.<NyARDetectMarkerResult> = new Vector.<NyARDetectMarkerResult>();

	/**
	 * result_holderを最大i_reserve_size個の要素を格納できるように予約します。
	 * 
	 * @param i_reserve_size
	 */
	public function reservHolder(i_reserve_size:int):void
	{
		if (i_reserve_size >= result_array.length) {
			var new_size:int = i_reserve_size + 5;
			this.result_array= new Vector.<NyARDetectMarkerResult>(new_size);
			for (var i:int = 0; i < new_size; i++) {
				result_array[i] = new NyARDetectMarkerResult();
			}
		}
	}
}
