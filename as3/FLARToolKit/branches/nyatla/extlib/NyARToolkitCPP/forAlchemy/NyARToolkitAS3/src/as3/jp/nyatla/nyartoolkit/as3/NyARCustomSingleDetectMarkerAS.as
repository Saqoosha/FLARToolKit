package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.type.*;
	
	/**
	 * 画像からARCodeに最も一致するマーカーを1個検出し、その変換行列を計算するクラスです。
	 * 変換行列を求めるには、detectMarkerLite関数にラスタイメージを入力して、計算対象の矩形を特定します。
	 * detectMarkerLiteが成功すると、getTransmationMatrix等の関数が使用可能な状態になり、変換行列を求めることができます。
	 * 
	 * 
	 */
	public class NyARCustomSingleDetectMarkerAS extends NyARBaseClassAS
	{	
		private var _ma:Marshal=new Marshal();
		private static const AR_SQUARE_MAX:int=100;
		private var _is_continue:Boolean=false;
		private var _match_patt:NyARMatchPatt_Color_WITHOUT_PCA;
		private var _square_detect:INyARSquareDetector;
		private var _square_list:NyARSquareStack = new NyARSquareStack(AR_SQUARE_MAX);
	
		protected var _transmat:INyARTransMat;	
		private var _marker_width:Number;
		// 検出結果の保存用
		private var _detected_direction:int;
		private var _detected_confidence:Number;
		private var _detected_square:NyARSquare;
		public var _patt:INyARColorPatt;
		//画処理用
		private var _bin_raster:NyARBinRaster;
		protected var _tobin_filter:INyARRasterFilter_RgbToBin;
		private var _deviation_data:NyARMatchPattDeviationColorData;
		
	public override function dispose():void
	{		
		super.dispose();
		this._square_list.dispose();
		this._bin_raster.dispose();
		this._match_patt.dispose();
		this._deviation_data.dispose();
		this._transmat.dispose();
		this._patt.dispose();
		this._square_detect.dispose();
		return;
	}
	public function NyARCustomSingleDetectMarkerAS()
	{
		return;
	}
	protected virtual function initInstance(...args:Array):void
	{
		var i_patt_inst:INyARColorPatt          =args[0];
		var i_sqdetect_inst:INyARSquareDetector =args[1];
		var i_transmat_inst:INyARTransMat       =args[2];
		var i_filter:INyARRasterFilter_RgbToBin =args[3];
		var i_ref_param:NyARParam               =args[4];
		var i_ref_code:NyARCode                 =args[5];
		var i_marker_width:Number               =args[6];	
		//
		var scr_size:NyARIntSize=i_ref_param.getScreenSize();
		//サイズの読み出し
		scr_size.getValue(_ma);
		_ma.prepareRead();
		var w:int=_ma.readInt();
		var h:int=_ma.readInt();
		
		// 解析オブジェクトを作る
		this._square_detect = i_sqdetect_inst;
		this._transmat = i_transmat_inst;
		this._tobin_filter=i_filter;
		// 比較コードを保存
		this._marker_width = i_marker_width;
		//パターンピックアップを作成
		this._patt = i_patt_inst;
		//取得パターンの差分データ器を作成
		this._deviation_data=new NyARMatchPattDeviationColorData(i_ref_code.getWidth(),i_ref_code.getHeight());
		//i_code用の評価器を作成
		this._match_patt = new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code);
		//２値画像バッファを作る
		this._bin_raster=new NyARBinRaster(w,h);
		
		return;
		
	}

	private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();

	/**
	 * i_imageにマーカー検出処理を実行し、結果を記録します。
	 * 
	 * @param i_raster
	 * マーカーを検出するイメージを指定します。イメージサイズは、カメラパラメータ
	 * と一致していなければなりません。
	 * @return マーカーが検出できたかを真偽値で返します。
	 * @throws NyARException
	 */
	public virtual function detectMarkerLite(...args:Array):Boolean
	{
		//argument
		var i_raster:INyARRgbRaster=args[0];
		
//		//サイズチェック　
//		if(!this._bin_raster.getSize().isEqualSize(i_raster.getSize())){
//			throw new NyARException();
//		}
//
		//ラスタを２値イメージに変換する.
		this._tobin_filter.doFilter(i_raster,this._bin_raster);


	
		this._detected_square = null;
		var l_square_list:NyARSquareStack = this._square_list;
		// スクエアコードを探す
		this._square_detect.detectMarker(this._bin_raster, l_square_list);


		var number_of_square:int = l_square_list.getLength();
		// コードは見つかった？
		if (number_of_square < 1) {
			return false;
		}
				
		var result:Boolean=false;
		var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
		var square_index:int = 0;
		var direction:int = NyARSquare.DIRECTION_UNKNOWN;
		var confidence:Number = 0;

		for(var i:int=0;i<number_of_square;i++){
			// 評価基準になるパターンをイメージから切り出す
			if (!this._patt.pickFromRaster(i_raster, l_square_list.getItem(i))){
				continue;
			}
			//取得パターンをカラー差分データに変換して評価する。
			this._deviation_data.setRaster(this._patt);
			if(!this._match_patt.evaluate(this._deviation_data,mr)){
				continue;
			}
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
			square_index = i;
			direction = mr_direction;
			confidence = c2;
			result=true;
		}
		
		// マーカー情報を保存
		this._detected_square = l_square_list.getItem(square_index);
		this._detected_direction = direction;
		this._detected_confidence = confidence;

		return result;
	}

	/**
	 * 検出したマーカーの変換行列を計算して、o_resultへ値を返します。
	 * 直前に実行したdetectMarkerLiteが成功していないと使えません。
	 * 
	 * @param o_result
	 * 変換行列を受け取るオブジェクトを指定します。
	 * @throws NyARException
	 */
	public function getTransmationMatrix(o_result:NyARTransMatResult):void
	{
		// 一番一致したマーカーの位置とかその辺を計算
		if (this._is_continue) {
			this._transmat.transMatContinue(this._detected_square,this._detected_direction,this._marker_width, o_result);
		} else {
			this._transmat.transMat(this._detected_square,this._detected_direction,this._marker_width, o_result);
		}
		return;
	}
	/**
	 * 検出したマーカー情報を格納した、NyARSquareオブジェクトを返します。
	 * 直前に実行したdetectMarkerLiteが成功していないと使えません。
	 */
	public function getDetectSquare():NyARSquare
	{
		return this._detected_square;
	}

	/**
	 * 検出したマーカーの一致度を返します。
	 * 
	 * @return マーカーの一致度を返します。0～1までの値をとります。 一致度が低い場合には、誤認識の可能性が高くなります。
	 * @throws NyARException
	 */
	public function getConfidence():Number
	{
		return this._detected_confidence;
	}

	/**
	 * 検出したマーカーの方位を返します。
	 * 
	 * @return 0,1,2,3の何れかを返します。
	 */
	public function getDirection():int
	{
		return this._detected_direction;
	}

	/**
	 * getTransmationMatrixの計算モードを設定します。 初期値はTRUEです。
	 * 
	 * @param i_is_continue
	 * TRUEなら、transMatCont互換の計算をします。 FALSEなら、transMat互換の計算をします。
	 */
	public function setContinueMode(i_is_continue:Boolean):void
	{
		this._is_continue = i_is_continue;
	}
}
};