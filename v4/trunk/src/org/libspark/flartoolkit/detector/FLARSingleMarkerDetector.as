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
	import flash.display.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.NyARDoubleMatrix44;
	import org.libspark.flartoolkit.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	public class FLARSingleMarkerDetector
	{	
		/** 一致率*/
		private var _confidence:Number;
		private var _square:NyARSquare=new NyARSquare();
		
		//所有インスタンス
		private var _inst_patt:INyARColorPatt;
		private var _deviation_data:NyARMatchPattDeviationColorData;
		private var _match_patt:NyARMatchPatt_Color_WITHOUT_PCA;
		private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
		private var _coordline:NyARCoord2Linear;
		

		private var __ref_vertex:Vector.<NyARIntPoint2d>=new Vector.<NyARIntPoint2d>(4);

		/**
		 * 矩形が見付かるたびに呼び出されます。
		 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
		 */
		public function updateSquareInfo(i_coord:NyARIntCoordinates,i_vertex_index:Vector.<int>):void
		{
			var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
			//輪郭座標から頂点リストに変換
			var vertex:Vector.<NyARIntPoint2d>=this.__ref_vertex;	//C言語ならポインタ扱いで実装
			vertex[0]=i_coord.items[i_vertex_index[0]];
			vertex[1]=i_coord.items[i_vertex_index[1]];
			vertex[2]=i_coord.items[i_vertex_index[2]];
			vertex[3] = i_coord.items[i_vertex_index[3]];
			var i:int;

		
			//画像を取得
			if (!this._inst_patt.pickFromRaster(this._last_input_raster,vertex)){
				return;
			}
			//取得パターンをカラー差分データに変換して評価する。
			this._deviation_data.setRaster(this._inst_patt);
			if(!this._match_patt.evaluate(this._deviation_data,mr)){
				return;
			}
			//現在の一致率より低ければ終了
			if (this._confidence > mr.confidence){
				return;
			}
			//一致率の高い矩形があれば、方位を考慮して頂点情報を作成
			var sq:NyARSquare=this._square;
			this._confidence = mr.confidence;
			//directionを考慮して、squareを更新する。
			for(i=0;i<4;i++){
				var idx:int=(i+4 - mr.direction) % 4;
				this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
			}
			//ちょっと、ひっくり返してみようか。
			for (i = 0; i < 4; i++) {
				//直線同士の交点計算
				if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
					throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
				}
			}
		}

		
		private var _is_continue:Boolean = false;
		private var _square_detect:FLARDetector;
		protected var _transmat:INyARTransMat;
		//画処理用
		private var _bin_raster:FLARBinRaster;
		protected var _tobin_filter:INyARRgb2GsFilterArtkTh;

		private var _offset:NyARRectOffset; 


		public function FLARSingleMarkerDetector(i_ref_param:NyARParam,i_ref_code:NyARCode,i_marker_width:Number)
		{
			var patt_inst:INyARColorPatt;
			var sqdetect_inst:FLARDetector;
			var transmat_inst:INyARTransMat;

			sqdetect_inst=new FLARDetector(this,i_ref_param.getScreenSize());
			transmat_inst=new NyARTransMat(i_ref_param);
			initInstance(sqdetect_inst, transmat_inst, i_ref_param, i_ref_code, i_marker_width);
			return;
		}

		protected function initInstance(
			i_sqdetect_inst:FLARDetector,
			i_transmat_inst:INyARTransMat,
			i_ref_param:NyARParam,
			i_ref_code:NyARCode,
			i_marker_width:Number):void
		{
			var scr_size:NyARIntSize=i_ref_param.getScreenSize();		
			// 解析オブジェクトを作る
			this._inst_patt=new NyARColorPatt_Perspective(i_ref_code.getWidth(), i_ref_code.getHeight(),4,25);
			this._square_detect = i_sqdetect_inst;
			this._transmat = i_transmat_inst;
			//２値画像バッファを作る
			this._bin_raster=new FLARBinRaster(scr_size.w,scr_size.h);
			//パターンの一致検索処理用
			this._deviation_data=new NyARMatchPattDeviationColorData(i_ref_code.getWidth(),i_ref_code.getHeight());
			this._coordline=new NyARCoord2Linear(i_ref_param.getScreenSize(),i_ref_param.getDistortionFactor());
			this._match_patt=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code);
			//オフセットを作成
			this._offset=new NyARRectOffset();
			this._offset.setSquare(i_marker_width);			
			return;
			
		}
		/** 参照インスタンス*/
		private var _last_input_raster:INyARRgbRaster=null;
		private var _bin_filter:INyARRgb2GsFilterArtkTh=null;		
		/**
		 * i_imageにマーカー検出処理を実行し、結果を記録します。
		 * 
		 * @param i_raster
		 * マーカーを検出するイメージを指定します。イメージサイズは、カメラパラメータ
		 * と一致していなければなりません。
		 * @return マーカーが検出できたかを真偽値で返します。
		 * @throws NyARException
		 */
		public function detectMarkerLite(i_raster:INyARRgbRaster,i_threshold:int):Boolean
		{
			//サイズチェック
			if(!this._bin_raster.getSize().isEqualSize_2(i_raster.getSize())){
				throw new NyARException();
			}
			//最終入力ラスタを更新
			if(this._last_input_raster!=i_raster){
				this._bin_filter=INyARRgb2GsFilterArtkTh(i_raster.createInterface(INyARRgb2GsFilterArtkTh));
				this._last_input_raster=i_raster;
			}
			//ラスタを２値イメージに変換する.
			this._bin_filter.doFilter(i_threshold,this._bin_raster);

			//コールバックハンドラの準備
			this._confidence=0;
			this._last_input_raster=i_raster;
			//
			//マーカ検出器をコール
			this._square_detect.detectMarker(this._bin_raster,this._square_detect);
			if(this._confidence==0){
				return false;
			}
			return true;
		}
		/**
		 * 検出したマーカーの変換行列を計算して、o_resultへ値を返します。
		 * 直前に実行したdetectMarkerLiteが成功していないと使えません。
		 * 
		 * @param o_result
		 * 変換行列を受け取るオブジェクトを指定します。
		 * @throws NyARException
		 */
		public function getTransformMatrix(o_result:NyARTransMatResult):void
		{
			// 一番一致したマーカーの位置とかその辺を計算
			if (this._is_continue) {
				this._transmat.transMatContinue(this._square,this._offset,o_result, o_result);
			} else {
				this._transmat.transMat(this._square,this._offset, o_result);
			}
			return;
		}
		/**
		 * 現在の矩形を返します。
		 * @return
		 */
		public function refSquare():NyARSquare
		{
			return this._square;
		}
		/**
		 * 検出したマーカーの一致度を返します。
		 * 
		 * @return マーカーの一致度を返します。0～1までの値をとります。 一致度が低い場合には、誤認識の可能性が高くなります。
		 * @throws NyARException
		 */
		public function getConfidence():Number
		{
			return this._confidence;
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
}

























import jp.nyatla.nyartoolkit.as3.detector.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.detector.*;









/**
 * Rleラ矩形Detectorのブリッジ
 *
 */
class FLARDetector extends FLARSquareContourDetector_FlaFill  implements NyARSquareContourDetector_CbHandler
{
	private var _parent:FLARSingleMarkerDetector;
	public function FLARDetector(i_parent:FLARSingleMarkerDetector,i_size:NyARIntSize):void
	{
		super(i_size);
		this._parent=i_parent;
	}
	public function detectMarkerCallback(i_coord:NyARIntCoordinates, i_vertex_index:Vector.<int>):void
	{

		this._parent.updateSquareInfo(i_coord, i_vertex_index);
	}	
}
	