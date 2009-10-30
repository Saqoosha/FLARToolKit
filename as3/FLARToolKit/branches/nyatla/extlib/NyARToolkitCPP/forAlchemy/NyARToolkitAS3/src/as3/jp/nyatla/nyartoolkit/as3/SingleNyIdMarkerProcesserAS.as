package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.type.*;
	


public class SingleNyIdMarkerProcesserAS extends NyARBaseClassAS
{
	private var _ma:Marshal=new Marshal();
	/**
	 * オーナーが自由に使えるタグ変数です。
	 */
	public var tag:Object;
	/**
	 * ロスト遅延の管理
	 */
	private var _lost_delay_count:int = 0;
	private var _lost_delay:int = 5;

	private var _square_detect:NyARSquareDetector_Rle;
	protected var _transmat:INyARTransMat;
	private var _marker_width:Number=100;

	private var _square_list:NyARSquareStack = new NyARSquareStack(100);
	private var _encoder:INyIdMarkerDataEncoder;
	private var _is_active:Boolean;
	private var _data_temp:INyIdMarkerData;
	private var _data_current:INyIdMarkerData;

	private var _current_threshold:int=110;
	// [AR]検出結果の保存用
	private var _bin_raster:NyARBinRaster;

	private var _tobin_filter:NyARRasterFilter_ARToolkitThreshold;

	private var _id_pickup:NyIdMarkerPickup = new NyIdMarkerPickup();
	private var _initialized:Boolean=false;

	private var _threshold_detect:NyARRasterThresholdAnalyzer_SlidePTile;
	
	private var _marker_data:NyIdMarkerPattern=new NyIdMarkerPattern();
	private var _marker_param:NyIdMarkerParam=new NyIdMarkerParam();
	private var __NyARSquare_result:NyARTransMatResult = new NyARTransMatResult();


	public function SingleNyIdMarkerProcesserAS()
	{
		return;
	}
	public override function dispose():void
	{		
		super.dispose();
		this._square_list.dispose();
		this._id_pickup.dispose();
		this._marker_data.dispose();
		this._marker_param.dispose();
		this.__NyARSquare_result.dispose();

		if(this._initialized==true){
			this._square_detect.dispose();
			this._transmat.dispose();
			this._bin_raster.dispose();
			this._data_temp.dispose();
			this._data_current.dispose();
			this._tobin_filter.dispose();
			this._threshold_detect.dispose();
			this._initialized=false;
		}
		return;
	}
	protected function initInstance(i_param:NyARParam,i_encoder:INyIdMarkerDataEncoder,i_raster_format:int):void
	{
		NyARToolkitAS3.Assert(this._initialized==false);
		
		var scr_size:NyARIntSize = i_param.getScreenSize();
		// 解析オブジェクトを作る
		this._square_detect = new NyARSquareDetector_Rle(i_param.getDistortionFactor(), scr_size);
		this._transmat = new NyARTransMat(i_param);
		this._encoder=i_encoder;

		//サイズの読み出し
		scr_size.getValue(_ma);
		_ma.prepareRead();
		var size_w:int=_ma.readInt();
		var size_h:int=_ma.readInt();

		// ２値画像バッファを作る
		this._bin_raster = new NyARBinRaster(size_w,size_h);
		//ワーク用のデータオブジェクトを２個作る
		this._is_active=false;
		this._data_temp=i_encoder.createDataInstance();
		this._data_current=i_encoder.createDataInstance();
		this._tobin_filter = new NyARRasterFilter_ARToolkitThreshold(110,i_raster_format);
		this._threshold_detect=new NyARRasterThresholdAnalyzer_SlidePTile(15,i_raster_format,4);
		this._initialized=true;
		return;
		
	}

	public function setMarkerWidth(i_width:int):void
	{
		this._marker_width=i_width;
		return;
	}

	public function reset(i_is_force:Boolean):void
	{
		if (this._data_current!=null && i_is_force == false) {
			// 強制書き換えでなければイベントコール
			this.onLeaveHandler();
		}
		// カレントマーカをリセット
		this._data_current = null;
		return;
	}

	public function detectMarker(i_raster:INyARRgbRaster):void
	{
		// サイズチェック
		//if (!this._bin_raster.getSize().isEqualSize(i_raster.getSize().w, i_raster.getSize().h)) {
		//	throw new NyARException();
		//}
		// ラスタを２値イメージに変換する.
		this._tobin_filter.setThreshold(this._current_threshold);
		this._tobin_filter.doFilter(i_raster, this._bin_raster);

		var square_stack:NyARSquareStack = this._square_list;
		// スクエアコードを探す
		this._square_detect.detectMarker(this._bin_raster, square_stack);
		// 認識処理
		if (!this._is_active) {
			// マーカ未認識→新規認識
			detectNewMarker(i_raster, square_stack);
		} else {
			// マーカ認識依頼→継続認識
			detectExistMarker(i_raster, square_stack);
		}
		return;
	}

	
	
	/**新規マーカ検索 現在認識中のマーカがないものとして、最も認識しやすいマーカを１個認識します。
	 */
	private function detectNewMarker(i_raster:INyARRgbRaster,i_stack:NyARSquareStack):void
	{
		var param:NyIdMarkerParam=this._marker_param;
		var patt_data:NyIdMarkerPattern=this._marker_data;
		var number_of_square:int = i_stack.getLength();
		var current_square:NyARSquare=null;
		var marker_id:INyIdMarkerData=null;
		for (var i:int = 0; i < number_of_square; i++) {
			// 評価基準になるパターンをイメージから切り出す
			current_square=i_stack.getItem(i);
			if (!this._id_pickup.pickFromRaster(i_raster,current_square, patt_data, param)) {
				continue;
			}
			//エンコード
			if(!this._encoder.encode(patt_data,this._data_temp)){
				continue;
			}
			//認識率が一番高いもの（占有面積が一番大きいもの）を選択する(省略)
			//id認識が成功したら終了
			marker_id=this._data_temp;
			break;
		}
		param.getValue(_ma);
		_ma.prepareRead();
		var param_dir:int=_ma.readInt();
		var param_th:int=_ma.readInt();
		
		// 認識状態を更新
		var is_id_found:Boolean=updateStatus(current_square,marker_id, param_dir);

		//閾値フィードバック(detectExistMarkerにもあるよ)
		if(is_id_found){
			//マーカがあれば、マーカの周辺閾値を反映
			this._current_threshold=(this._current_threshold+param_th)/2;
		}else{
			//マーカがなければ、探索+DualPTailで基準輝度検索
			this._threshold_detect.analyzeRaster(i_raster);
			this._current_threshold=(this._current_threshold+this._threshold_detect.getThreshold())/2;
		}
		return;
	}

	/**マーカの継続認識 現在認識中のマーカを優先して認識します。 
	 * （注）この機能はたぶん今後いろいろ発展するからNewと混ぜないこと。
	 */
	private function detectExistMarker(i_raster:INyARRgbRaster,i_stack:NyARSquareStack):void
	{
		var param:NyIdMarkerParam=this._marker_param;
		var patt_data:NyIdMarkerPattern  =this._marker_data;
		var number_of_square:int = i_stack.getLength();
		var current_square:NyARSquare=null;
		var marker_id:INyIdMarkerData=null;
		for (var i:int = 0; i < number_of_square; i++){
			//idマーカを認識
			current_square=i_stack.getItem(i);
			if (!this._id_pickup.pickFromRaster(i_raster, current_square, patt_data, param)) {
				continue;
			}
			if(!this._encoder.encode(patt_data,this._data_temp)){
				continue;
			}
			//現在認識中のidか確認
			if(!this._data_current.isEqual((this._data_temp))){
				continue;
			}
			//現在認識中のものであれば、終了
			marker_id=this._data_temp;
			break;
		}
		param.getValue(_ma);
		_ma.prepareRead();
		var param_dir:int=_ma.readInt();
		var param_th:int=_ma.readInt();
			
		// 認識状態を更新
		var is_id_found:Boolean=updateStatus(current_square,marker_id,param_dir);

		//閾値フィードバック(detectExistMarkerにもあるよ)
		if(is_id_found){
			//マーカがあれば、マーカの周辺閾値を反映
			this._current_threshold=(this._current_threshold+param_th)/2;
		}else{
			//マーカがなければ、探索+DualPTailで基準輝度検索
			this._threshold_detect.analyzeRaster(i_raster);
			this._current_threshold=(this._current_threshold+this._threshold_detect.getThreshold())/2;
		}
		return;
	}


	/**オブジェクトのステータスを更新し、必要に応じてハンドル関数を駆動します。
	 */
	private function updateStatus(i_square:NyARSquare, i_marker_data:INyIdMarkerData,i_param_direction:int):Boolean
	{
		var is_id_found:Boolean=false;
		var result:NyARTransMatResult = this.__NyARSquare_result;
		if (!this._is_active) {// 未認識中
			if (i_marker_data==null) {// 未認識から未認識の遷移
				// なにもしないよーん。
				this._is_active=false;
			} else {// 未認識から認識の遷移
			
				this._data_current.copyFrom(i_marker_data);

				// イベント生成
				// OnEnter
				this.onEnterHandler(this._data_current);
				// 変換行列を作成
				this._transmat.transMat(i_square,i_param_direction, this._marker_width, result);
				// OnUpdate
				this.onUpdateHandler(i_square, result);
				this._lost_delay_count = 0;
				this._is_active=true;
				is_id_found=true;
			}
		} else {// 認識中
			if (i_marker_data==null) {
				// 認識から未認識の遷移
				this._lost_delay_count++;
				if (this._lost_delay < this._lost_delay_count) {
					// OnLeave
					this.onLeaveHandler();
					this._is_active=false;
				}
			} else if(this._data_current.isEqual(i_marker_data)) {
				//同じidの再認識
				this._transmat.transMat(i_square, i_param_direction, this._marker_width, result);
				// OnUpdate
				this.onUpdateHandler(i_square, result);
				this._lost_delay_count = 0;
				is_id_found=true;
			} else {// 異なるコードの認識→今はサポートしない。
				throw new  Error("updateStatus");
			}
		}
		return is_id_found;
	}	
	//通知ハンドラ
	protected virtual function onEnterHandler(i_code:INyIdMarkerData):void{};
	protected virtual function onLeaveHandler():void{};
	protected virtual function onUpdateHandler(i_square:NyARSquare,result:NyARTransMatResult):void{};
}
}
