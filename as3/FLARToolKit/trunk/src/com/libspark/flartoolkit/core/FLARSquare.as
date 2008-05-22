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
	
	import com.libspark.flartoolkit.util.ArrayUtil;

	/**
	 * ARMarkerInfoに相当するクラス。
	 * スクエア情報を保持します。
	 *
	 */
	public class FLARSquare extends FLARMarker {
	//    private NyARMarker marker;
	//    public int area;
	//    public double[] pos;
	    public var line:Array = ArrayUtil.createMultidimensionalArray(4, 3);//new double[4][3];  //double[4][3]
	    public var sqvertex:Array = ArrayUtil.createMultidimensionalArray(4, 2);//new double[4][2];//double[4][2];
	    
	    public function FLARSquare() {
			super();
	    }
	    
	    private const wk_getLine_input:FLARMat = new FLARMat(1,2);
	    private const wk_getLine_evec:FLARMat = new FLARMat(2,2);
	    private const wk_getLine_ev:FLARVec = new FLARVec(2);
	    private const wk_getLine_mean:FLARVec = new FLARVec(2);
	    /**
	     * arGetLine(int x_coord[], int y_coord[], int coord_num,int vertex[], double line[4][3], double v[4][2])
	     * arGetLine2(int x_coord[], int y_coord[], int coord_num,int vertex[], double line[4][3], double v[4][2], double *dist_factor)
	     * の２関数の合成品です。
	     * 格納しているマーカー情報に対して、GetLineの計算を行い、結果を返します。
	     * Optimize:STEP[424->391]
	     * @param i_cparam
	     * @return
	     * @throws FLARException
	     */
	    public function getLine(i_cparam:FLARParam):Boolean {
	    	var w1:Number;
	    	var st:int, ed:int, n:int;
	    	var i:int;

			var l_sqvertex:Array = this.sqvertex;
			var l_line:Array = this.line;
			var l_mkvertex:Array = this.mkvertex;
			var l_x_coord:Array = this.x_coord;
			var l_y_coord:Array = this.y_coord;	
			var ev:FLARVec = this.wk_getLine_ev;  //matrixPCAの戻り値を受け取る
			var mean:FLARVec = this.wk_getLine_mean;//matrixPCAの戻り値を受け取る
			var mean_array:Array = mean.getArray();
			var l_line_i:Array, l_line_2:Array;
	
			var input:FLARMat = this.wk_getLine_input;//次処理で初期化される。
			var evec:FLARMat = this.wk_getLine_evec;//アウトパラメータを受け取るから初期化不要//new FLARMat(2,2);
			var evec_array:Array = evec.getArray();
			for (i = 0; i < 4; i++) {
			    w1 = (l_mkvertex[i+1]-l_mkvertex[i]+1) * 0.05 + 0.5;
			    st = (l_mkvertex[i]   + w1);
			    ed = (l_mkvertex[i+1] - w1);
			    n = ed - st + 1;
			    if (n < 2) {
					//nが2以下でmatrix.PCAを計算することはできないので、エラーにしておく。
					return false;//throw new FLARException();
			    }
			    input.realloc(n,2);
			    //バッチ取得
			    i_cparam.observ2IdealBatch(l_x_coord,l_y_coord,st,n,input.getArray());
		//	    for (j = 0; j < n; j++) {
		//		i_cparam.observ2Ideal(l_x_coord[st+j], l_y_coord[st+j],dv1,dv2);//arParamObserv2Ideal(dist_factor, x_coord[st+j], y_coord[st+j],&(input->m[j*2+0]), &(input->m[j*2+1]));
		//		in_array[j][0]=dv1.value;
		//		in_array[j][1]=dv2.value;
		//	    }
			    input.matrixPCA(evec, ev, mean);
			    l_line_i=l_line[i];
			    l_line_i[0] =  evec_array[0][1];//line[i][0] =  evec->m[1];
			    l_line_i[1] = -evec_array[0][0];//line[i][1] = -evec->m[0];
			    l_line_i[2] = -(l_line_i[0]*mean_array[0] + l_line_i[1]*mean_array[1]);//line[i][2] = -(line[i][0]*mean->v[0] + line[i][1]*mean->v[1]);
			}
		
			for (i = 0; i < 4; i++) {
			    l_line_i = l_line[i];
			    l_line_2 = l_line[(i+3)%4];
			    w1 = l_line_2[0] * l_line_i[1] - l_line_i[0] * l_line_2[1];
			    if (w1 == 0.0) {
					return false;
			    }
			    l_sqvertex[i][0] = ( l_line_2[1] * l_line_i[2]- l_line_i[1] * l_line_2[2]) / w1;
			    l_sqvertex[i][1] = ( l_line_i[0] * l_line_2[2]- l_line_2[0] * l_line_i[2]) / w1;
			}
			return true;
	    }
	    
	}

}