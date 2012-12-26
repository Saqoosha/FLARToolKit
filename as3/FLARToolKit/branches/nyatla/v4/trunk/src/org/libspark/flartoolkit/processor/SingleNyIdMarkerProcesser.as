/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.processor 
{
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.match.*;
	import org.libspark.flartoolkit.core.pickup.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.nyidmarker.data.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.nyidmarker.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.analyzer.histogram.*;
	public class SingleNyIdMarkerProcesser
	{
		/**
		 * オーナーが自由に使えるタグ変数です。
		 */
		public var tag:Object;

		/**
		 * ロスト遅延の管理
		 */
		private var _lost_delay_count:int = 0;
		private var _lost_delay:int = 5;

		private var _square_detect:RleDetector;
		protected var _transmat:IFLARTransMat;
		private var _offset:FLARRectOffset; 
		private var _is_active:Boolean;
		private var _current_threshold:int=110;
		// [AR]検出結果の保存用
		private var _gs_raster:FLARGrayscaleRaster ;
		private var _data_current:INyIdMarkerData;
		private var _threshold_detect:FLARHistogramAnalyzer_SlidePTile;
		private var _hist:FLARHistogram=new FLARHistogram(256);
		private var _histmaker:IFLARHistogramFromRaster;


		public function SingleNyIdMarkerProcesser()
		{
			return;
		}
		private var _initialized:Boolean=false;
		protected function initInstance(i_param:FLARParam, i_encoder:INyIdMarkerDataEncoder ,i_marker_width:Number, i_raster_format:int):void
		{
			//初期化済？
			NyAS3Utils.assert(this._initialized==false);
			
			var scr_size:FLARIntSize  = i_param.getScreenSize();
			// 解析オブジェクトを作る
			this._square_detect = new RleDetector(
				i_param,
				i_encoder,
				new NyIdMarkerPickup());
			this._transmat = new FLARTransMat(i_param);

			// ２値画像バッファを作る
			this._gs_raster = new FLARGrayscaleRaster(scr_size.w, scr_size.h);
			this._histmaker=IFLARHistogramFromRaster(this._gs_raster.createInterface(IFLARHistogramFromRaster));
			//ワーク用のデータオブジェクトを２個作る
			this._data_current=i_encoder.createDataInstance();
			this._threshold_detect=new FLARHistogramAnalyzer_SlidePTile(15);
			this._initialized=true;
			this._is_active=false;
			this._offset=new FLARRectOffset();
			this._offset.setSquare(i_marker_width);
			return;
		}

		public function setMarkerWidth(i_width:int):void
		{
			this._offset.setSquare(i_width);
			return;
		}

		public function reset(i_is_force:Boolean):void
		{
			if (i_is_force == false && this._is_active){
				// 強制書き換えでなければイベントコール
				this.onLeaveHandler();
			}
			//マーカ無効
			this._is_active=false;
			return;
		}
		private var _last_input_raster:IFLARRgbRaster;
		private var _togs_filter:IFLARRgb2GsFilter;
		public function detectMarker(i_raster:IFLARRgbRaster):void
		{
			// サイズチェック
			if (!this._gs_raster.getSize().isEqualSize(i_raster.getSize().w, i_raster.getSize().h)) {
				throw new FLARException();
			}
			// ラスタをGSへ変換する。
			if(this._last_input_raster!=i_raster){
				this._togs_filter=IFLARRgb2GsFilter(i_raster.createInterface(IFLARRgb2GsFilter));
				this._last_input_raster=i_raster;
			}
			this._togs_filter.convert(this._gs_raster);

			// スクエアコードを探す(第二引数に指定したマーカ、もしくは新しいマーカを探す。)
			this._square_detect.init(this._gs_raster,this._is_active?this._data_current:null);
			this._square_detect.detectMarker_2(this._gs_raster,this._current_threshold,this._square_detect);

			// 認識状態を更新(マーカを発見したなら、current_dataを渡すかんじ)
			var is_id_found:Boolean=updateStatus(this._square_detect.square,this._square_detect.marker_data);

			//閾値フィードバック(detectExistMarkerにもあるよ)
			if(is_id_found){
				//マーカがあれば、マーカの周辺閾値を反映
				this._current_threshold=(this._current_threshold+this._square_detect.threshold)/2;
			}else{
				//マーカがなければ、探索+DualPTailで基準輝度検索
				this._histmaker.createHistogram_2(4,this._hist);
				var th:int= this._threshold_detect.getThreshold(this._hist);
				this._current_threshold=(this._current_threshold+th)/2;
			}		

		}

		
		private var _transmat_result:FLARDoubleMatrix44 = new FLARDoubleMatrix44();
		private var _last_result_param:FLARTransMatResultParam = new FLARTransMatResultParam();

		/**オブジェクトのステータスを更新し、必要に応じてハンドル関数を駆動します。
		 */
		private function updateStatus(i_square:FLARSquare,i_marker_data:INyIdMarkerData):Boolean
		{
			var is_id_found:Boolean=false;
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
					this._transmat.transMat(i_square, this._offset,this._transmat_result,this._last_result_param);
					// OnUpdate
					this.onUpdateHandler(i_square, this._transmat_result);
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
					if(!this._transmat.transMatContinue(i_square,  this._offset, this._transmat_result, this._last_result_param.last_error, this._transmat_result, this._last_result_param)){
						this._transmat.transMat(i_square, this._offset,this._transmat_result,this._last_result_param);
					}
					// OnUpdate
					this.onUpdateHandler(i_square, this._transmat_result);
					this._lost_delay_count = 0;
					is_id_found=true;
				} else {// 異なるコードの認識→今はサポートしない。
					throw new  FLARException();
				}
			}
			return is_id_found;
		}	
		//通知ハンドラ
		protected function onEnterHandler(i_code:INyIdMarkerData):void
		{
			throw new FLARException("onEnterHandler not implemented.");
		}
		protected function onLeaveHandler():void
		{
			throw new FLARException("onLeaveHandler not implemented.");
		}
		protected function onUpdateHandler(i_square:FLARSquare,o_result:FLARDoubleMatrix44): void
		{
			throw new FLARException("onUpdateHandler not implemented.");
		}
	}
}
import org.libspark.flartoolkit.core.param.*;
import org.libspark.flartoolkit.core.match.*;
import org.libspark.flartoolkit.core.pickup.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.core.transmat.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.*;
import org.libspark.flartoolkit.nyidmarker.data.*;
import org.libspark.flartoolkit.nyidmarker.*;

/**
 * detectMarkerのコールバック関数
 */
class RleDetector extends FLARSquareContourDetector_Rle implements FLARSquareContourDetector_CbHandler
{
	//公開プロパティ
	public var square:FLARSquare=new FLARSquare();
	public var marker_data:INyIdMarkerData;
	public var threshold:int;

	
	//参照
	private var _ref_raster:IFLARGrayscaleRaster;
	//所有インスタンス
	private var _current_data:INyIdMarkerData;
	private var _id_pickup:NyIdMarkerPickup;
	private var _coordline:FLARCoord2Linear;
	private var _encoder:INyIdMarkerDataEncoder;

	
	private var _data_temp:INyIdMarkerData;
	private var _prev_data:INyIdMarkerData;
	
	public function RleDetector(i_param:FLARParam,i_encoder:INyIdMarkerDataEncoder,i_id_pickup:NyIdMarkerPickup)
	{
		super(i_param.getScreenSize());
		this._coordline=new FLARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
		this._data_temp=i_encoder.createDataInstance();
		this._current_data=i_encoder.createDataInstance();
		this._encoder = i_encoder;
		this._id_pickup=i_id_pickup;		
		return;
	}
	private var __ref_tmp_vertex:Vector.<FLARIntPoint2d>=FLARIntPoint2d.createArray(4);
	/**
	 * Initialize call back handler.
	 */
	public function init(i_raster:IFLARGrayscaleRaster,i_prev_data:INyIdMarkerData):void
	{
		this.marker_data=null;
		this._prev_data=i_prev_data;
		this._ref_raster=i_raster;
	}
	private var _marker_param:NyIdMarkerParam=new NyIdMarkerParam();
	private var _marker_data:NyIdMarkerPattern =new NyIdMarkerPattern();

	/**
	 * 矩形が見付かるたびに呼び出されます。
	 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
	 */
	public function detectMarkerCallback(i_coord:FLARIntCoordinates,i_vertex_index:Vector.<int>):void
	{
		//既に発見済なら終了
		if(this.marker_data!=null){
			return;
		}
		//輪郭座標から頂点リストに変換
		var vertex:Vector.<FLARIntPoint2d>=this.__ref_tmp_vertex;
		vertex[0]=i_coord.items[i_vertex_index[0]];
		vertex[1]=i_coord.items[i_vertex_index[1]];
		vertex[2]=i_coord.items[i_vertex_index[2]];
		vertex[3] = i_coord.items[i_vertex_index[3]];
		
		var param:NyIdMarkerParam=this._marker_param;
		var patt_data:NyIdMarkerPattern=this._marker_data;			
		// 評価基準になるパターンをイメージから切り出す
		if (!this._id_pickup.pickFromRaster_2(this._ref_raster.getGsPixelDriver(),vertex, patt_data, param)){
			return;
		}
		//エンコード
		if(!this._encoder.encode(patt_data,this._data_temp)){
			return;
		}

		//継続認識要求されている？
		if (this._prev_data==null){
			//継続認識要求なし
			this._current_data.copyFrom(this._data_temp);
		}else{
			//継続認識要求あり
			if(!this._prev_data.isEqual((this._data_temp))){
				return;//認識請求のあったIDと違う。
			}
		}
		//新しく認識、または継続認識中に更新があったときだけ、Square情報を更新する。
		//ココから先はこの条件でしか実行されない。
		var sq:FLARSquare=this.square;
		//directionを考慮して、squareを更新する。
		var i:int;
		for(i=0;i<4;i++){
			var idx:int=(i+4 - param.direction) % 4;
			this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
		}
		for (i= 0; i < 4; i++) {
			//直線同士の交点計算
			if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
				throw new FLARException();//ここのエラー復帰するならダブルバッファにすればOK
			}
		}
		this.threshold=param.threshold;
		this.marker_data=this._current_data;//みつかった。
	}
}	