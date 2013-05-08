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
package org.libspark.flartoolkit.detector 
{
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.core.pickup.*;


	/**
	 * 複数のマーカーを検出し、それぞれに最も一致するARコードを、コンストラクタで登録したARコードから 探すクラスです。最大300個を認識しますが、ゴミラベルを認識したりするので100個程度が限界です。
	 * 
	 */
	public class FLARDetectMarker
	{
		public static const AR_SQUARE_MAX:int = 300;
		private var _is_continue:Boolean = false;
		private var _square_detect:RleDetector;
		protected var _transmat:IFLARTransMat;
		private var _offset:Vector.<FLARRectOffset>;


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
		 * 入力ラスタのピクセルタイプを指定します。この値は、IFLARBufferReaderインタフェイスのgetBufferTypeの戻り値を指定します。
		 * @throws FLARException
		 */
		public function FLARDetectMarker(i_param:FLARParam, i_code:Vector.<FLARCode>, i_marker_width:Vector.<Number>, i_number_of_code:int, i_input_raster_type:int)
		{
			initInstance(i_param,i_code,i_marker_width,i_number_of_code);
			return;
		}
		protected function initInstance(
			i_ref_param:FLARParam,
			i_ref_code:Vector.<FLARCode>,
			i_marker_width:Vector.<Number>,
			i_number_of_code:int):void
		{

			var scr_size:FLARIntSize=i_ref_param.getScreenSize();
			// 解析オブジェクトを作る
			var cw:int = i_ref_code[0].getWidth();
			var ch:int = i_ref_code[0].getHeight();

			//detectMarkerのコールバック関数
			this._square_detect=new RleDetector(
				new FLARColorPatt_Perspective(cw, ch,4,25),
				i_ref_code,i_number_of_code,i_ref_param);
			this._transmat = new FLARTransMat(i_ref_param);

			//実サイズ保存
			this._offset = FLARRectOffset.createArray(i_number_of_code);
			for(var i:int=0;i<i_number_of_code;i++){
				this._offset[i].setSquare(i_marker_width[i]);
			}
			//２値画像バッファを作る
			this._bin_raster=new FLARBinRaster(scr_size.w,scr_size.h);
			return;		
		}
		
		private var _bin_raster:FLARBinRaster;

		private var _tobin_filter:IFLARRgb2GsFilterArtkTh ;
		private var _last_input_raster:IFLARRgbRaster=null;


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
		public function detectMarkerLite(i_raster:IFLARRgbRaster,i_threshold:int):int
		{
			// サイズチェック
			if (!this._bin_raster.getSize().isEqualSize_2(i_raster.getSize())) {
				throw new FLARException();
			}
			if(this._last_input_raster!=i_raster){
				this._tobin_filter=IFLARRgb2GsFilterArtkTh(i_raster.createInterface(IFLARRgb2GsFilterArtkTh));
				this._last_input_raster=i_raster;
			}
			this._tobin_filter.doFilter(i_threshold,this._bin_raster);
			//detect
			this._square_detect.init(i_raster);
			this._square_detect.detectMarker_2(this._bin_raster,0,this._square_detect);

			//見付かった数を返す。
			return this._square_detect.result_stack.getLength();
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
		public function getTransmationMatrix(i_index:int,o_result:FLARDoubleMatrix44):void
		{
			//Debug.Assert(o_result!=null);
			var result:FLARDetectMarkerResult = FLARDetectMarkerResult(this._square_detect.result_stack.getItem(i_index));
			// 一番一致したマーカーの位置とかその辺を計算
			if (this._is_continue){
				//履歴が使えそうか判定
				if(result.ref_last_input_matrix==o_result){
					if(this._transmat.transMatContinue(result.square, this._offset[result.arcode_id],o_result, result.last_result_param.last_error,o_result, result.last_result_param)){
						return;
					}
				}
			}
			//履歴使えないor継続認識失敗
			this._transmat.transMat(result.square, this._offset[result.arcode_id],o_result,result.last_result_param);
			result.ref_last_input_matrix=o_result;
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
		public function getConfidence(i_index:int):Number
		{
			return this._square_detect.result_stack.getItem(i_index).confidence;
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
			return this._square_detect.result_stack.getItem(i_index).arcode_id;
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

import org.libspark.flartoolkit.core.match.*;
import org.libspark.flartoolkit.core.pickup.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.*;
import org.libspark.flartoolkit.core.types.stack.*;
import org.libspark.flartoolkit.core.match.*;
import org.libspark.flartoolkit.core.param.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.detector.*;
import org.libspark.flartoolkit.core.types.*;
/**
 * detectMarkerのコールバック関数
 */
class RleDetector extends FLARSquareContourDetector_Rle implements FLARSquareContourDetector_CbHandler
{
	//公開プロパティ
	public var result_stack:FLARDetectMarkerResultStack=new FLARDetectMarkerResultStack(FLARDetectMarker.AR_SQUARE_MAX);
	//参照インスタンス
	public var _ref_raster:IFLARRgbRaster;
	//所有インスタンス
	private var _inst_patt:IFLARColorPatt;
	private var _deviation_data:FLARMatchPattDeviationColorData;
	private var _match_patt:Vector.<FLARMatchPatt_Color_WITHOUT_PCA>;
	private var __detectMarkerLite_mr:FLARMatchPattResult=new FLARMatchPattResult();
	private var _coordline:FLARCoord2Linear;
	
	public function RleDetector(i_inst_patt:IFLARColorPatt, i_ref_code:Vector.<FLARCode>, i_num_of_code:int, i_param:FLARParam)
	{
		super(i_param.getScreenSize());
		var cw:int = i_ref_code[0].getWidth();
		var ch:int = i_ref_code[0].getHeight();

		this._inst_patt=i_inst_patt;
		this._coordline=new FLARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
		this._deviation_data=new FLARMatchPattDeviationColorData(cw,ch);

		//FLARMatchPatt_Color_WITHOUT_PCA[]の作成
		this._match_patt=new Vector.<FLARMatchPatt_Color_WITHOUT_PCA>(i_num_of_code);
		this._match_patt[0]=new FLARMatchPatt_Color_WITHOUT_PCA(i_ref_code[0]);
		for (var i:int = 1; i < i_num_of_code; i++){
			//解像度チェック
			if (cw != i_ref_code[i].getWidth() || ch != i_ref_code[i].getHeight()) {
				throw new FLARException();
			}
			this._match_patt[i]=new FLARMatchPatt_Color_WITHOUT_PCA(i_ref_code[i]);
		}
		this._inst_patt=i_inst_patt;
		this._coordline=new FLARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
		this._deviation_data=new FLARMatchPattDeviationColorData(cw,ch);
		return;
	}
	private var __ref_vertex:Vector.<FLARIntPoint2d>=new Vector.<FLARIntPoint2d>(4);
	/**
	 * 矩形が見付かるたびに呼び出されます。
	 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
	 */
	public function detectMarkerCallback(i_coord:FLARIntCoordinates, i_vertex_index:Vector.<int>):void
	{
		var mr:FLARMatchPattResult=this.__detectMarkerLite_mr;
		//輪郭座標から頂点リストに変換
		var vertex:Vector.<FLARIntPoint2d>=this.__ref_vertex;
		vertex[0]=i_coord.items[i_vertex_index[0]];
		vertex[1]=i_coord.items[i_vertex_index[1]];
		vertex[2]=i_coord.items[i_vertex_index[2]];
		vertex[3]=i_coord.items[i_vertex_index[3]];	
		//画像を取得
		if (!this._inst_patt.pickFromRaster(this._ref_raster,vertex)){
			return;
		}
		//取得パターンをカラー差分データに変換して評価する。
		this._deviation_data.setRaster(this._inst_patt);

		//最も一致するパターンを割り当てる。
		var square_index:int,direction:int;
		var confidence:Number;
		this._match_patt[0].evaluate(this._deviation_data,mr);
		square_index=0;
		direction=mr.direction;
		confidence=mr.confidence;
		//2番目以降
		var i:int;
		for(i=1;i<this._match_patt.length;i++){
			this._match_patt[i].evaluate(this._deviation_data,mr);
			if (confidence > mr.confidence) {
				continue;
			}
			// もっと一致するマーカーがあったぽい
			square_index = i;
			direction = mr.direction;
			confidence = mr.confidence;
		}
		//最も一致したマーカ情報を、この矩形の情報として記録する。
		var result:FLARDetectMarkerResult = FLARDetectMarkerResult(this.result_stack.prePush());
		result.arcode_id = square_index;
		result.confidence = confidence;

		var sq:FLARSquare=result.square;
		//directionを考慮して、squareを更新する。
		for(i=0;i<4;i++){
			var idx:int=(i+4 - direction) % 4;
			this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
		}
		for (i = 0; i < 4; i++) {
			//直線同士の交点計算
			if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
				throw new FLARException();//ここのエラー復帰するならダブルバッファにすればOK
			}
		}
	}
	public function init(i_raster:IFLARRgbRaster):void
	{
		this._ref_raster=i_raster;
		this.result_stack.clear();
		
	}
}
import org.libspark.flartoolkit.core.types.matrix.*;
import org.libspark.flartoolkit.core.transmat.*;

class FLARDetectMarkerResult
{
	public var arcode_id:int;
	public var confidence:Number;
	public var ref_last_input_matrix:FLARDoubleMatrix44;
	public var last_result_param:FLARTransMatResultParam=new FLARTransMatResultParam();

	public var square:FLARSquare=new FLARSquare();
}


class FLARDetectMarkerResultStack extends FLARObjectStack
{
	public function FLARDetectMarkerResultStack(i_length:int)
	{
		super();
		this.initInstance(i_length);
	}
	protected override function createElement():Object
	{
		return new FLARDetectMarkerResult();
	}
}