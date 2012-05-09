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
 */
package jp.nyatla.nyartoolkit.as3.processor 
{
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.as3utils.*;
	
	/**
	 * このクラスは、同時に１個のマーカを処理することのできる、アプリケーションプロセッサです。
	 * マーカの出現・移動・消滅を、イベントで通知することができます。
	 * クラスには複数のマーカを登録できます。一つのマーカが見つかると、プロセッサは継続して同じマーカを
	 * １つだけ認識し続け、見失うまでの間は他のマーカを認識しません。
	 * 
	 * イベントは、 OnEnter→OnUpdate[n]→OnLeaveの順で発生します。
	 * マーカが見つかるとまずOnEnterが１度発生して、何番のマーカが発見されたかがわかります。
	 * 次にOnUpdateにより、現在の変換行列が連続して渡されます。最後にマーカを見失うと、OnLeave
	 * イベントが発生します。
	 * 
	 */
	public class SingleARMarkerProcesser
	{

		/**オーナーが自由に使えるタグ変数です。
		 */
		public var tag:Object;

		private var _lost_delay_count:int = 0;

		private var _lost_delay:int = 5;

		protected var _transmat:INyARTransMat;

		private var _offset:NyARRectOffset; 
		private var _threshold:int = 110;
		// [AR]検出結果の保存用
		private var _gs_raster:NyARGrayscaleRaster;
		protected var _current_arcode_index:int = -1;

		
		public function SingleARMarkerProcesser()
		{
			return;
		}

		private var _initialized:Boolean=false;

		protected function initInstance(i_param:NyARParam):void
		{
			//初期化済？
			NyAS3Utils.assert(this._initialized==false);
			
			var scr_size:NyARIntSize = i_param.getScreenSize();
			// 解析オブジェクトを作る
			this._transmat = new NyARTransMat(i_param);
			this._thdetect=new NyARHistogramAnalyzer_SlidePTile(15);

			// ２値画像バッファを作る
			this._gs_raster = new NyARGrayscaleRaster(scr_size.w, scr_size.h);
			this._initialized=true;
			//コールバックハンドラ
			this._detectmarker=new DetectSquare(i_param);
			this._offset=new NyARRectOffset();
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
			this._detectmarker.setNyARCodeTable(i_ref_code_table,i_code_resolution);
			this._offset.setSquare(i_marker_width);
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
		private var _detectmarker:DetectSquare;
		private var _last_input_raster:INyARRaster=null;
		
		private var _togs_filter:INyARRgb2GsFilter;
		private var _histmaker:INyARHistogramFromRaster;
		private var _thdetect:NyARHistogramAnalyzer_SlidePTile;
		private var _hist:NyARHistogram=new NyARHistogram(256);
		public function detectMarker(i_raster:INyARRgbRaster):void
		{
			// サイズチェック			
			NyAS3Utils.assert(this._gs_raster.getSize().isEqualSize(i_raster.getSize().w, i_raster.getSize().h));
			if(this._last_input_raster!=i_raster){
				this._histmaker=INyARHistogramFromRaster(this._gs_raster.createInterface(INyARHistogramFromRaster));
				this._togs_filter=INyARRgb2GsFilter(i_raster.createInterface(INyARRgb2GsFilter));
				this._last_input_raster=i_raster;
			}

			//GSイメージへの変換とヒストグラムの生成
			this._togs_filter.convert(this._gs_raster);
			this._histmaker.createHistogram_2(4, this._hist);
			
			// スクエアコードを探す
			this._detectmarker.init(i_raster,this._current_arcode_index);
			this._detectmarker.detectMarker_2(this._gs_raster,this._thdetect.getThreshold(this._hist),this._detectmarker);
			
			// 認識状態を更新
			this.updateStatus(this._detectmarker.square,this._detectmarker.code_index);
			
			
			return;
		}
		/**
		 * 
		 * @param i_new_detect_cf
		 * @param i_exist_detect_cf
		 */
		public function setConfidenceThreshold(i_new_cf:Number,i_exist_cf:Number):void
		{
			this._detectmarker.cf_threshold_exist=i_exist_cf;
			this._detectmarker.cf_threshold_new=i_new_cf;
		}
		private var __NyARSquare_result:NyARTransMatResult = new NyARTransMatResult();

		/**	オブジェクトのステータスを更新し、必要に応じてハンドル関数を駆動します。
		 * 	戻り値は、「実際にマーカを発見する事ができたか」です。クラスの状態とは異なります。
		 */
		private function updateStatus(i_square:NyARSquare,i_code_index:int):Boolean
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
					this._transmat.transMat(i_square, this._offset, result);
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
					this._transmat.transMatContinue(i_square, this._offset, result,result);
					// OnUpdate
					this.onUpdateHandler(i_square, result);
					this._lost_delay_count = 0;
					return true;
				} else {// 異なるコードの認識→今はサポートしない。
					throw new  NyARException();
				}
			}
		}

		protected function onEnterHandler(i_code:int):void
		{
			throw new NyARException("onEnterHandler not implemented.");
		}

		protected function onLeaveHandler():void
		{
			throw new NyARException("onLeaveHandler not implemented.");
		}

		protected function onUpdateHandler(i_square:NyARSquare, result:NyARTransMatResult):void
		{
			throw new NyARException("onUpdateHandler not implemented.");
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.match.*;
import jp.nyatla.nyartoolkit.as3.core.pickup.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.*;

/**
 * detectMarkerのコールバック関数
 */
class DetectSquare extends NyARSquareContourDetector_Rle implements NyARSquareContourDetector_CbHandler
{
	//公開プロパティ
	public var square:NyARSquare=new NyARSquare();
	public var confidence:Number=0.0;
	public var code_index:int=-1;		
	public var cf_threshold_new:Number = 0.50;
	public var cf_threshold_exist:Number = 0.30;
	
	//参照
	private var _ref_raster:INyARRgbRaster;
	//所有インスタンス
	private var _inst_patt:INyARColorPatt;
	private var _deviation_data:NyARMatchPattDeviationColorData;
	private var _match_patt:Vector.<NyARMatchPatt_Color_WITHOUT_PCA>;
	private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
	private var _coordline:NyARCoord2Linear;
	public function DetectSquare(i_param:NyARParam)
	{
		super(i_param.getScreenSize());
		this._match_patt = null;
		this._coordline=new NyARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
		return;
	}
	public function setNyARCodeTable(i_ref_code:Vector.<NyARCode>,i_code_resolution:int):void
	{
		/*unmanagedで実装するときは、ここでリソース解放をすること。*/
		this._deviation_data=new NyARMatchPattDeviationColorData(i_code_resolution,i_code_resolution);
		this._inst_patt=new NyARColorPatt_Perspective(i_code_resolution,i_code_resolution,4,25);
		this._match_patt = new Vector.<NyARMatchPatt_Color_WITHOUT_PCA>(i_ref_code.length);
		for(var i:int=0;i<i_ref_code.length;i++){
			this._match_patt[i]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code[i]);
		}
	}
	private var __ref_vertex:Vector.<NyARIntPoint2d>=NyARIntPoint2d.createArray(4);
	private var _target_id:int;

	/**
	 * Initialize call back handler.
	 */
	public function init(i_raster:INyARRgbRaster,i_target_id:int):void
	{
		this._ref_raster = i_raster;
		this._target_id=i_target_id;
		this.code_index=-1;
		this.confidence = Number.MIN_VALUE;
	}

	/**
	 * 矩形が見付かるたびに呼び出されます。
	 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
	 */
	public function detectMarkerCallback(i_coord:NyARIntCoordinates,i_vertex_index:Vector.<int>):void
	{
		if (this._match_patt==null) {
			return;
		}
		//輪郭座標から頂点リストに変換
		var vertex:Vector.<NyARIntPoint2d>=this.__ref_vertex;
		vertex[0]=i_coord.items[i_vertex_index[0]];
		vertex[1]=i_coord.items[i_vertex_index[1]];
		vertex[2]=i_coord.items[i_vertex_index[2]];
		vertex[2]=i_coord.items[i_vertex_index[3]];

	
		//画像を取得
		if (!this._inst_patt.pickFromRaster(this._ref_raster,vertex)){
			return;//取得失敗
		}
		//取得パターンをカラー差分データに変換して評価する。
		this._deviation_data.setRaster(this._inst_patt);

		
		//code_index,dir,c1にデータを得る。
		var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
		var lcode_index:int = 0;
		var dir:int = 0;
		var c1:Number = 0;
		var i:int;
		for (i = 0; i < this._match_patt.length; i++) {
			this._match_patt[i].evaluate(this._deviation_data,mr);
			var c2:Number = mr.confidence;
			if (c1 < c2) {
				lcode_index = i;
				c1 = c2;
				dir = mr.direction;
			}
		}
		
		//認識処理
		if (this._target_id == -1) { // マーカ未認識
			//現在は未認識
			if (c1 < this.cf_threshold_new) {
				return;
			}
			if (this.confidence > c1) {
				// 一致度が低い。
				return;
			}
			//認識しているマーカIDを保存
			this.code_index=lcode_index;
		}else{
			//現在はマーカ認識中				
			// 現在のマーカを認識したか？
			if (lcode_index != this._target_id) {
				// 認識中のマーカではないので無視
				return;
			}
			//認識中の閾値より大きいか？
			if (c1 < this.cf_threshold_exist) {
				return;
			}
			//現在の候補よりも一致度は大きいか？
			if (this.confidence>c1) {
				return;
			}
			this.code_index=this._target_id;
		}
		//新しく認識、または継続認識中に更新があったときだけ、Square情報を更新する。
		//ココから先はこの条件でしか実行されない。
		
		//一致率の高い矩形があれば、方位を考慮して頂点情報を作成
		this.confidence=c1;
		var sq:NyARSquare=this.square;
		//directionを考慮して、squareを更新する。
		for(i=0;i<4;i++){
			var idx:int=(i+4 - dir) % 4;
			this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
		}
		for (i = 0; i < 4; i++) {
			//直線同士の交点計算
			if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
				throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
			}
		}
	}
}
