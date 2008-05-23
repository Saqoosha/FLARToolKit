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
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package com.libspark.flartoolkit.detector {
	
	import com.libspark.flartoolkit.FLARException;
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.FLARColorPatt_O3;
	import com.libspark.flartoolkit.core.FLARMat;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARSquare;
	import com.libspark.flartoolkit.core.FLARSquareDetector;
	import com.libspark.flartoolkit.core.FLARSquareList;
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.core.FLARTransMat_O2;
	import com.libspark.flartoolkit.core.IFLARColorPatt;
	import com.libspark.flartoolkit.core.IFLARTransMat;
	import com.libspark.flartoolkit.core.match.FLARMatchPatt_BlackWhite;
	import com.libspark.flartoolkit.core.match.FLARMatchPatt_Color_WITHOUT_PCA;
	import com.libspark.flartoolkit.core.match.IFLARMatchPatt;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.core.raster.IFLARRaster;
	
	/**
	 * 1個のマーカーに対する変換行列を計算するクラスです。
	 *
	 */
	public class FLARSingleMarkerDetector {
		
	    private static const AR_SQUARE_MAX:int = 100;
	    private var is_continue:Boolean = false;
	    private var match_patt:IFLARMatchPatt;
	    private var square:FLARSquareDetector;
	    private var square_list:FLARSquareList = new FLARSquareList(AR_SQUARE_MAX);
	    private var code:FLARCode;
	    protected var transmat:IFLARTransMat;
	    private var marker_width:Number;
	    //検出結果の保存用
	    private var detected_direction:int;
	    private var detected_confidence:Number;
	    private var detected_square:FLARSquare;
	    private var patt:IFLARColorPatt;
	    
	    public function FLARSingleMarkerDetector(i_param:FLARParam, i_code:FLARCode, i_marker_width:Number) {
			//解析オブジェクトを作る
			this.square = new FLARSquareDetector(i_param);
			this.transmat = new FLARTransMat_O2(i_param);
			//比較コードを保存
			this.code = i_code;
			this.marker_width = i_marker_width;
			//評価パターンのホルダを作る
			this.patt = new FLARColorPatt_O3(code.getWidth(), code.getHeight());
			//評価器を作る。
//			this.match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();	
			this.match_patt = new FLARMatchPatt_BlackWhite();
	    }
	    /**
	     * i_imageにマーカー検出処理を実行して、結果を保持します。
	     * @param dataPtr
	     * @param thresh
	     * @return
	     * マーカーが検出できたかを真偽値で返します。
	     * @throws NyARException
	     */
	    public function detectMarkerLite(i_image:FLARBitmapData, i_thresh:int):Boolean {
			detected_square = null;
			var l_square_list:FLARSquareList = this.square_list;
			//スクエアコードを探す
			square.detectSquare(i_image, i_thresh, l_square_list);
			
			var number_of_square:int = l_square_list.getSquareNum();
			//コードは見つかった？
			if (number_of_square < 1) {
			    return false;
			}
	
			//評価基準になるパターンをイメージから切り出す
			if(!patt.pickFromRaster(i_image, l_square_list.getSquare(0))){
			    //パターンの切り出しに失敗
			    return false;
			}
			//パターンを評価器にセット
			if (!this.match_patt.setPatt(patt)) {
			    //計算に失敗した。
			    return false;
//			    throw new FLARException();
			}
			//コードと比較する
			match_patt.evaluate(code);
			var square_index:int = 0;
			var direction:int = match_patt.getDirection();
			var confidence:Number = match_patt.getConfidence();
			for (var i:int = 1; i < number_of_square; i++) {
			    //次のパターンを取得
			    patt.pickFromRaster(i_image, l_square_list.getSquare(i));
			    //評価器にセットする。
			    match_patt.setPatt(patt);
	            //コードと比較する
			    match_patt.evaluate(code);
			    var c2:Number = match_patt.getConfidence();
			    if (confidence > c2) {
					continue;
			    }
			    //もっと一致するマーカーがあったぽい
			    square_index = i;
			    direction = match_patt.getDirection();
			    confidence = c2;
			}
			//マーカー情報を保存
			detected_square = l_square_list.getSquare(square_index);
			detected_direction = direction;
			detected_confidence = confidence;
			return true;
	    }
	    
	    /**
	     * 変換行列を返します。直前に実行したdetectMarkerLiteが成功していないと使えません。
	     * @param i_marker_width
	     * マーカーの大きさを指定します。
	     * @return
	     * double[3][4]の変換行列を返します。
	     * @throws NyARException
	     */
	    public function getTranslationMatrix(o_result:FLARTransMatResult):void {
			//一番一致したマーカーの位置とかその辺を計算
			if (is_continue) { 
			    transmat.transMatContinue(detected_square, detected_direction, marker_width, o_result);
			} else {
			    transmat.transMat(detected_square, detected_direction, marker_width, o_result);
			}
			return;
	    }
	    
	    public function getConfidence():Number {
			return detected_confidence;
	    }
	    
	    public function getDirection():int {
			return detected_direction;
	    }
	    
	    /**
	     * getTransmationMatrixの計算モードを設定します。
	     * 初期値はTRUEです。
	     * @param i_is_continue
	     * TRUEなら、transMatCont互換の計算をします。
	     * FALSEなら、transMat互換の計算をします。
	     */
	    public function setContinueMode(i_is_continue:Boolean):void {
			this.is_continue = i_is_continue;
	    }
    
	    public function getSquare():FLARSquare {
	    	return this.detected_square;
	    }
		
	//	public static class arUtil_c{
	//		public static final int		arFittingMode	=Config.DEFAULT_FITTING_MODE;
	//		private static final int		arImageProcMode	=Config.DEFAULT_IMAGE_PROC_MODE;
	//		public static final int		arTemplateMatchingMode  =Config.DEFAULT_TEMPLATE_MATCHING_MODE;
	//		public static final int		arMatchingPCAMode       =Config.DEFAULT_MATCHING_PCA_MODE;	
			/*int arInitCparam(ARParam *param)*/
		
	}
	
}
