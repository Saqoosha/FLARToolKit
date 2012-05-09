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
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;


	public class FLARMultiMarkerDetector
	{
		private var _is_continue:Boolean = false;
		private var _square_detect:FLDetector;
		protected var _transmat:INyARTransMat;
		private var _offset:Vector.<NyARRectOffset>;


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
		public function FLARMultiMarkerDetector(i_param:NyARParam, i_code:Vector.<NyARCode>, i_marker_width:Vector.<Number>, i_number_of_code:int)
		{
			initInstance(i_param,i_code,i_marker_width,i_number_of_code);
			return;
		}
		protected function initInstance(
			i_ref_param:NyARParam,
			i_ref_code:Vector.<NyARCode>,
			i_marker_width:Vector.<Number>,
			i_number_of_code:int):void
		{

			var scr_size:NyARIntSize=i_ref_param.getScreenSize();
			// 解析オブジェクトを作る
			var cw:int = i_ref_code[0].getWidth();
			var ch:int = i_ref_code[0].getHeight();

			this._transmat = new NyARTransMat(i_ref_param);
			//NyARToolkitプロファイル
			this._square_detect =new FLDetector(new NyARColorPatt_Perspective(cw, ch,4,25),i_ref_code,i_number_of_code,i_ref_param);

			//実サイズ保存
			this._offset = NyARRectOffset.createArray(i_number_of_code);
			for(var i:int=0;i<i_number_of_code;i++){
				this._offset[i].setSquare(i_marker_width[i]);
			}
			//２値画像バッファを作る
			this._bin_raster=new FLARBinRaster(scr_size.w,scr_size.h);
			return;		
		}
		
		private var _bin_raster:FLARBinRaster;

		private var _tobin_filter:INyARRgb2GsFilterArtkTh;
		private var _last_input_raster:INyARRgbRaster=null;
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
			if (!this._bin_raster.getSize().isEqualSize_2(i_raster.getSize())) {
				throw new NyARException();
			}
			if(this._last_input_raster!=i_raster){
				this._tobin_filter=INyARRgb2GsFilterArtkTh(i_raster.createInterface(INyARRgb2GsFilterArtkTh));
				this._last_input_raster=i_raster;
			}
			this._tobin_filter.doFilter(i_threshold,this._bin_raster);
			//detect
			this._square_detect.init(i_raster);
			this._square_detect.detectMarker(this._bin_raster,this._square_detect);

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
		 * @throws NyARException
		 */
		public function getTransformMatrix(i_index:int,o_result:NyARTransMatResult):void
		{
			var result:NyARDetectMarkerResult = NyARDetectMarkerResult(this._square_detect.result_stack.getItem(i_index));
			// 一番一致したマーカーの位置とかその辺を計算
			if (_is_continue) {
				_transmat.transMatContinue(result.square, this._offset[result.arcode_id], o_result,o_result);
			} else {
				_transmat.transMat(result.square, this._offset[result.arcode_id], o_result);
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

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;
import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.pickup.*;
import jp.nyatla.nyartoolkit.as3.core.match.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;


import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.*;
import org.libspark.flartoolkit.core.raster.rgb.*;


class NyARDetectMarkerResult
{
	public var arcode_id:int;
	public var confidence:Number;
	public var square:NyARSquare=new NyARSquare();
}


class NyARDetectMarkerResultStack extends NyARObjectStack
{
	public function NyARDetectMarkerResultStack(i_length:int)
	{
		super();
		this.initInstance(i_length);
		return;
	}
	protected override function createElement():Object
	{
		return new NyARDetectMarkerResult();
	}	
}	
	
class FLDetector extends FLARSquareContourDetector_FlaFill implements NyARSquareContourDetector_CbHandler
{
		private static const AR_SQUARE_MAX:int = 300;
	
	//公開プロパティ
	public var result_stack:NyARDetectMarkerResultStack=new NyARDetectMarkerResultStack(AR_SQUARE_MAX);
	//参照インスタンス
	public var _ref_raster:INyARRgbRaster;
	//所有インスタンス
	private var _inst_patt:INyARColorPatt;
	private var _deviation_data:NyARMatchPattDeviationColorData;
	private var _match_patt:Vector.<NyARMatchPatt_Color_WITHOUT_PCA>;
	private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
	private var _coordline:NyARCoord2Linear;

	public function FLDetector(i_inst_patt:INyARColorPatt,i_ref_code:Vector.<NyARCode>,i_num_of_code:int,i_param:NyARParam)
	{
		super(i_param.getScreenSize());
		var cw:int = i_ref_code[0].getWidth();
		var ch:int = i_ref_code[0].getHeight();
		//NyARMatchPatt_Color_WITHOUT_PCA[]の作成
		this._match_patt=new Vector.<NyARMatchPatt_Color_WITHOUT_PCA>(i_num_of_code);
		this._match_patt[0]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code[0]);
		for (var i:int = 1; i < i_num_of_code; i++){
			//解像度チェック
			if (cw != i_ref_code[i].getWidth() || ch != i_ref_code[i].getHeight()) {
				throw new NyARException();
			}
			this._match_patt[i]=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code[i]);
		}
		this._inst_patt=i_inst_patt;
		this._coordline=new NyARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
		this._deviation_data=new NyARMatchPattDeviationColorData(cw,ch);
		return;
	}
	private var __ref_vertex:Vector.<NyARIntPoint2d> = NyARIntPoint2d.createArray(4);
	/**
	 * 矩形が見付かるたびに呼び出されます。
	 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
	 */
	public function detectMarkerCallback(i_coord:NyARIntCoordinates, i_vertex_index:Vector.<int>):void
	{
		var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
		//輪郭座標から頂点リストに変換
		var vertex:Vector.<NyARIntPoint2d>=this.__ref_vertex;
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
		confidence = mr.confidence;
		var i:int;
		//2番目以降
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
		var result:NyARDetectMarkerResult = NyARDetectMarkerResult(this.result_stack.prePush());
		result.arcode_id = square_index;
		result.confidence = confidence;

		var sq:NyARSquare=result.square;
		//directionを考慮して、squareを更新する。
		for(i=0;i<4;i++){
			var idx:int=(i+4 - direction) % 4;
			this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
		}
		for (i = 0; i < 4; i++) {
			//直線同士の交点計算
			if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
				throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
			}
		}
	}
	public function init(i_raster:INyARRgbRaster):void
	{
		this._ref_raster=i_raster;
		this.result_stack.clear();
		
	}
}
		