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
	import com.libspark.flartoolkit.FLARException;
	

	public class FLARSquareList extends FLARMarkerList {
		
	    private var square_array:Array;
	    private var square_array_num:int;
	    
	    public function FLARSquareList(i_number_of_holder:int) {
			super(new Array(i_number_of_holder));//NyARSquare[i_number_of_holder]);
			//マーカーホルダに実体を割り当てる。
			for (var i:int = 0; i < this.marker_holder.length; i++) {
			    this.marker_holder[i] = new FLARSquare();
			}
			this.square_array = new Array(i_number_of_holder);//new NyARSquare[i_number_of_holder];
			this.square_array_num = 0;
	    }
	    
	    /**
	     * マーカーアレイをフィルタして、square_arrayを更新する。
	     * [[この関数はマーカー検出処理と密接に関係する関数です。
	     * NyARDetectSquareクラス以外から呼び出さないで下さい。]]
	     */
	    public function updateSquareArray(i_param:FLARParam):void {
			var square:FLARSquare;
			var j:int = 0;
			for (var i:int = 0; i < this.marker_array_num; i++) {
		//	    double[][]  line	=new double[4][3];
		//	    double[][]  vertex	=new double[4][2];
			    //NyARMarker marker=detect.getMarker(i);
			    square = this.marker_array[i];
			    //・・・線の検出？？
	            if (!square.getLine(i_param)) {
	            	continue;
	            }
	            this.square_array[j]=square;
		//ここで計算するのは良くないと思うんだ	
		//		marker_infoL[j].id  = id.get();
		//		marker_infoL[j].dir = dir.get();
		//		marker_infoL[j].cf  = cf.get();	
				j++;
			}
			this.square_array_num = j;
	    }
	    
	    /**
	     * スクエア配列に格納されている要素数を返します。
	     * @return
	     */
	    public function getSquareNum():int {
			return 	this.square_array_num;
	    }
	    
	    /**
	     * スクエア配列の要素を返します。
	     * スクエア配列はマーカーアレイをさらにフィルタした結果です。
	     * マーカーアレイの部分集合になっている点に注意してください。
	     * @param i_index
	     * @return
	     * @throws FLARException
	     */
	    public function getSquare(i_index:int):FLARSquare {
			if (i_index >= this.square_array_num) {
			    throw new FLARException();
			}
			return this.square_array[i_index];
	    }
	    
	}

}