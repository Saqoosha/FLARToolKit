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

package com.libspark.flartoolkit.core {
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.core.raster.IFLARRaster;
	

	public class FLARSquareDetector {
		
	    private var labeling:FLARLabeling;
	    private var detect:FLARMarkerDetector;
	    private var param:FLARParam;
	
	    /**
	     * マーカー抽出インスタンスを作ります。
	     * @param i_param
	     */
	    public function FLARSquareDetector(i_param:FLARParam) {
			param = i_param;
			//解析オブジェクトを作る
			var width:int = i_param.getX();
			var height:int = i_param.getY();
		
			labeling = new FLARLabeling(width, height);
			detect = new FLARMarkerDetector(width, height);
	    }
	    
	    /**
	     * ラスタイメージから矩形を検出して、結果o_square_holderへ格納します。
	     * @param i_marker
	     * @param i_number_of_marker
	     * @param i_square_holder
	     * @throws NyARException
	     */
	    public function detectSquare(i_image:FLARBitmapData, i_thresh:int, o_square_holder:FLARSquareList):void {
		//	number_of_square=0;
			
			labeling.labeling(i_image, i_thresh);
			if (labeling.getLabelNum()<1) {
			    return;
			}
			//ここでマーカー配列を作成する。
			detect.detectMarker(labeling, 1.0, o_square_holder);
			
			//マーカー情報をフィルタして、スクエア配列を更新する。
			o_square_holder.updateSquareArray(param);
		
		//	NyARSquare square;
		//	int j=0;
		//	for (int i = 0; i <number_of_marker; i++) {
		//	double[][]  line	=new double[4][3];
		//	double[][]  vertex	=new double[4][2];
		//	//NyARMarker marker=detect.getMarker(i);
		//	square=square_holder.getSquare(i);
		//	//・・・線の検出？？
		//	if (!square.getLine(param))
		//	{
		//	    continue;
		//	}
		//	ここで計算するのは良くないと思うんだ	
		//	marker_infoL[j].id  = id.get();
		//	marker_infoL[j].dir = dir.get();
		//	marker_infoL[j].cf  = cf.get();	
		//	j++;
		//	//配列数こえたらドゴォォォンしないようにループを抜ける
		//	if (j>=marker_info.length) {
		//	    break;
		//	}
		//    }
		//    number_of_square=j;
	    }
	    
	}

}