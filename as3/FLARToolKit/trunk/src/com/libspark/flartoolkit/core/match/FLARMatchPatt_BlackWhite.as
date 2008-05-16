/* 
 * PROJECT: NyARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkit is Java version ARToolkit class library.
 * Copyright (C)2008 R.Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package com.libspark.flartoolkit.core.match {
	
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.IFLARColorPatt;
	import com.libspark.flartoolkit.util.ArrayUtil;
	
	/**
	 * AR_TEMPLATE_MATCHING_BWと同等のルールで
	 * マーカーを評価します。
	 *
	 */
	public class FLARMatchPatt_BlackWhite implements IFLARMatchPatt {
		
	    private var datapow:Number;
	    private var width:int;
	    private var height:int;
	    private var cf:Number = 0;
	    private var dir:int =0;
	    private var ave:int;
	    private var input:Array;// = ArrayUtil.createMultidimensionalArray(height, width, 3);//new int[height][width][3];
	    
	    public function setPatt(i_target_patt:IFLARColorPatt):Boolean {
			width = i_target_patt.getWidth();
			height = i_target_patt.getHeight();
			var data:Array = i_target_patt.getPatArray(); 	
			input = ArrayUtil.createMultidimensionalArray(height, width, 3);//new int[height][width][3];
	 
	        var sum:int = ave = 0;
	        for (var i:int = 0; i < height; i++) {//for (int i=0;i<Config.AR_PATT_SIZE_Y;i++) {
	            for (var i2:int = 0; i2 < width; i2++) {//for (int i2=0;i2<Config.AR_PATT_SIZE_X;i2++) {
	                ave += (255 - data[i][i2][0]) + (255 - data[i][i2][1]) + (255 - data[i][i2][2]);
	            }
	        }
	        ave /= (height * width * 3);
	
	        for (i = 0; i < height; i++) {//for (int i=0;i<Config.AR_PATT_SIZE_Y;i++) {
	            for (i2 = 0; i2 < width; i2++) {//for (int i2=0;i2<Config.AR_PATT_SIZE_X;i2++) {
	                input[i][i2][0] = ((255 - data[i][i2][0]) + (255 - data[i][i2][1]) + (255 - data[i][i2][2])) / 3 - ave;
	                sum += input[i][i2][0] * input[i][i2][0];
	            }
	        }
	        
	        datapow = Math.sqrt(sum);
	        if (datapow == 0.0) {
	            return false;//            throw new FLARException();
	//            dir.set(0);//*dir  = 0;
	//            cf.set(-1.0);//*cf   = -1.0;
	//            return -1;
	        }
	        return true;
	    }
	    
	    public function getConfidence():Number {
			return cf;
	    }
	    
	    public function getDirection():int {
			return dir;
	    }
	    
	    public function evaluate(i_code:FLARCode):void {
			var patBW:Array = i_code.getPatBW();//static int    patBW[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
			var patpowBW:Array = i_code.getPatPowBW();//static double patpowBW[AR_PATT_NUM_MAX][4];
		
			var max:Number = 0.0;
			var res:int = -1;
	        //本家が飛ぶ。試験データで0.77767376888がが出ればOKってことで
	        for (var j:int = 0; j < 4; j++) {
	            var sum:int = 0;
	            for (var i:int = 0; i < height; i++) {
	                for (var i2:int = 0; i2 < width; i2++) {
	            	sum += input[i][i2][0] * patBW[j][i][i2];
	                }
	            }
	            var sum2:Number = sum / patpowBW[j] / datapow;
	            if (sum2 > max) {
	            	max = sum2;
	            	res = j;
	            }
	        }
	        dir = res;
	        cf = max;       
	    }
	    
	}

}