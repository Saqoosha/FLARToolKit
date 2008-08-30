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

package org.libspark.flartoolkit.detector {
	
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.FLARColorPatt_O3;
	import org.libspark.flartoolkit.core.FLARParam;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARSquareDetector;
	import org.libspark.flartoolkit.core.FLARSquareList;
	import org.libspark.flartoolkit.core.FLARTransMatResult;
	import org.libspark.flartoolkit.core.FLARTransMat_O2;
	import org.libspark.flartoolkit.core.IFLARColorPatt;
	import org.libspark.flartoolkit.core.IFLARTransMat;
	import org.libspark.flartoolkit.core.match.FLARMatchPatt_BlackWhite;
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;

	/**
	 * 複数のマーカーを検出し、それぞれに最も一致するARコードを、コンストラクタで登録したARコードから
	 * 探すクラスです。最大300個を認識しますが、ゴミラベルを認識したりするので100個程度が限界です。
	 *
	 */
	public class FLARMultiMarkerDetector {
		
	    private static const AR_SQUARE_MAX:int = 300;
	    private var is_continue:Boolean = false;
	    private var match_patt:FLARMatchPatt_BlackWhite;
	    private var square:FLARSquareDetector;
	    private const square_list:FLARSquareList = new FLARSquareList(AR_SQUARE_MAX);
	    private var codes:Array;
	    protected var transmat:IFLARTransMat;
	    private var marker_width:Array;
	    private var number_of_code:int;
	    //検出結果の保存用
	    private var patt:IFLARColorPatt;
	    
	    private var result_holder:FLARDetectedMarkerResultHolder = new FLARDetectedMarkerResultHolder();
	    
	    /**
	     * 複数のマーカーを検出し、最も一致するARCodeをi_codeから検索するオブジェクトを作ります。
	     * @param i_param
	     * カメラパラメータを指定します。
	     * @param i_code
	     * 検出するマーカーのARCode配列を指定します。配列要素のインデックス番号が、そのままgetARCodeIndex関数で
	     * 得られるARCodeインデックスになります。
	     * 例えば、要素[1]のARCodeに一致したマーカーである場合は、getARCodeIndexは1を返します。
	     * 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。
	     * @param i_marker_width
	     * i_codeのマーカーサイズをミリメートルで指定した配列を指定します。
	     * 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。
	     * @param i_number_of_code
	     * i_codeに含まれる、ARCodeの数を指定します。
	     * @throws FLARException
	     */
	    public function FLARMultiMarkerDetector(i_param:FLARParam, i_code:Array, i_marker_width:Array) {
			//解析オブジェクトを作る
			this.square = new FLARSquareDetector(i_param);
			this.transmat = new FLARTransMat_O2(i_param);
			//比較コードを保存
			this.codes = i_code;
			//比較コードの解像度は全部同じかな？（違うとパターンを複数種つくらないといけないから）
			var cw:int = i_code[0].getWidth();
			var ch:int = i_code[0].getHeight();
			this.number_of_code = this.codes.length;
			for (var i:int = 1; i < this.number_of_code; i++) {
			    if (cw != i_code[i].getWidth() || ch != i_code[i].getHeight()) {
					//違う解像度のが混ざっている。
					throw new FLARException();
			    }
			}	
			//評価パターンのホルダを作る
			this.patt = new FLARColorPatt_O3(cw,ch);
		
			this.marker_width = i_marker_width;
			//評価器を作る。
//			this.match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();
			this.match_patt = new FLARMatchPatt_BlackWhite();	
	    }
	    
	    /**
	     * i_imageにマーカー検出処理を実行し、結果を記録します。
	     * @param i_image
	     * マーカーを検出するイメージを指定します。
	     * @param i_thresh
	     * 検出閾値を指定します。0～255の範囲で指定してください。
	     * 通常は100～130くらいを指定します。
	     * @return
	     * 見つかったマーカーの数を返します。
	     * マーカーが見つからない場合は0を返します。
	     * @throws FLARException
	     */
	    public function detectMarkerLite(i_image:FLARBitmapData, i_thresh:int):int {
			var l_square_list:FLARSquareList = this.square_list;
			//スクエアコードを探す
			square.detectSquare(i_image, i_thresh, l_square_list);
			
			const number_of_square:int = l_square_list.getSquareNum();
			//コードは見つかった？
			if (number_of_square < 1) {
			    //ないや。おしまい。
			    return 0;
			}
			//保持リストのサイズを調整
			this.result_holder.reservHolder(number_of_square);	
			
			//1スクエア毎に、一致するコードを決定していく
			for (var i:int = 0; i < number_of_square; i++) {
			    var square:FLARSquare = l_square_list.getSquare(i);
			    //評価基準になるパターンをイメージから切り出す
		            if (!this.patt.pickFromRaster(i_image,square)) {
			        	//イメージの切り出しは失敗することもある。
			        	continue;
		            }
		            //パターンを評価器にセット
		            if (!this.match_patt.setPatt(this.patt)) {
		                //計算に失敗した。    	
		                throw new FLARException();
		            }
		            //コードと順番に比較していく
		            var code_index:int = 0;
		            match_patt.evaluate(codes[0]);
		            var confidence:Number = match_patt.getConfidence();
		            var direction:int = match_patt.getDirection();
		            for (var i2:int = 1; i2 < this.number_of_code; i2++) {
		                //コードと比較する
		                match_patt.evaluate(codes[i2]);
		                var c2:Number = match_patt.getConfidence();
		                if (confidence > c2) {
		                    continue;
		                }
		                //より一致するARCodeの情報を保存
		                code_index  = i2;
		                direction   = match_patt.getDirection();
		                confidence  = c2;
		            }
		            //i番目のパターン情報を保存する。
		            const result:FLARDetectedMarkerResult = this.result_holder.result_array[i];
		            result.arcode_id  = code_index;
		            result.confidence = confidence;
		            result.direction  = direction;
		            result.ref_square = square;
			}
			return number_of_square;
	    }
	    
	    /**
	     * i_indexのマーカーに対する変換行列を計算し、結果値をo_resultへ格納します。
	     * 直前に実行したdetectMarkerLiteが成功していないと使えません。
	     * @param i_index
	     * マーカーのインデックス番号を指定します。
	     * 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
	     * @param o_result
	     * 結果値を受け取るオブジェクトを指定してください。
	     * @throws FLARException
	     */
	    public function getTranslationMatrix(i_index:int, o_result:FLARTransMatResult):void {
			const result:FLARDetectedMarkerResult = this.result_holder.result_array[i_index];
			//一番一致したマーカーの位置とかその辺を計算
			if (is_continue) {
			    transmat.transMatContinue(result.ref_square, result.direction, marker_width[result.arcode_id], o_result);
			} else {
			    transmat.transMat(result.ref_square, result.direction, marker_width[result.arcode_id], o_result);
			}
			return;
	    }
	    
	    /**
	     * i_indexのマーカーの一致度を返します。
	     * @param i_index
	     * マーカーのインデックス番号を指定します。
	     * 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
	     * @return
	     * マーカーの一致度を返します。0～1までの値をとります。
	     * 一致度が低い場合には、誤認識の可能性が高くなります。
	     * @throws FLARException
	     */
	    public function getConfidence(i_index:int):Number {
			return this.result_holder.result_array[i_index].confidence;
	    }
	    
	    /**
	     * i_indexのマーカーの方位を返します。
	     * @param i_index
	     * マーカーのインデックス番号を指定します。
	     * 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
	     * @return
	     * 0,1,2,3の何れかを返します。
	     */    
	    public function getDirection(i_index:int):int {
			return this.result_holder.result_array[i_index].direction;
	    }
	    
	    /**
	     * i_indexのマーカーのARCodeインデックスを返します。
	     * @param i_index
	     * マーカーのインデックス番号を指定します。
	     * 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。
	     * @return
	     */    
	    public function getARCodeIndex(i_index:int):int {
			return this.result_holder.result_array[i_index].arcode_id;
	    }
	     
	    /**
	     * getTransmationMatrixの計算モードを設定します。
	     * @param i_is_continue
	     * TRUEなら、transMatContinueを使用します。
	     * FALSEなら、transMatを使用します。
	     */
	    public function setContinueMode(i_is_continue:Boolean):void {
			this.is_continue = i_is_continue;
	    }
		
	}

}	
