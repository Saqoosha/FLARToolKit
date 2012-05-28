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
package org.libspark.flartoolkit.core.squaredetect 
{
	import org.libspark.flartoolkit.core.pca2d.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.core.param.*;
	
	public class FLARCoord2Linear
	{
		private var _xpos:Vector.<Number>;
		private var _ypos:Vector.<Number>;	
		private var _pca:IFLARPca2d;
		private var __getSquareLine_evec:FLARDoubleMatrix22=new FLARDoubleMatrix22();
		private var __getSquareLine_mean:Vector.<Number> = new Vector.<Number>(2);
		private var __getSquareLine_ev:Vector.<Number> = new Vector.<Number>(2);
		private var _dist_factor:FLARObserv2IdealMap;
		/**
		 * @param i_size
		 * @param i_distfactor_ref
		 * カメラ歪みを補正する場合のパラメータを指定します。
		 * nullの場合、補正マップを使用しません。
		 */
		public function FLARCoord2Linear(i_size:FLARIntSize,i_distfactor:FLARCameraDistortionFactor)
		{
			if(i_distfactor!=null){
				this._dist_factor = new FLARObserv2IdealMap(i_distfactor,i_size);
			}else{
				this._dist_factor=null;
			}
			// 輪郭バッファ
			this._pca=new FLARPca2d_MatrixPCA_O2();
			this._xpos=new Vector.<Number>(i_size.w+i_size.h);//最大辺長はthis._width+this._height
			this._ypos=new Vector.<Number>(i_size.w+i_size.h);//最大辺長はthis._width+this._height
			return;
		}


		/**
		 * 輪郭点集合からay+bx+c=0の直線式を計算します。
		 * @param i_st
		 * @param i_ed
		 * @param i_coord
		 * @param o_line
		 * @return
		 * @throws FLARException
		 */
		public function coord2Line(i_st:int,i_ed:int,i_coord:FLARIntCoordinates,o_line:FLARLinear):Boolean
		{
			//頂点を取得
			var n:int,st:int,ed:int;
			var w1:Number;
			var cood_num:int=i_coord.length;
		
			//探索区間の決定
			if(i_ed>=i_st){
				//頂点[i]から頂点[i+1]までの輪郭が、1区間にあるとき
				w1 = (Number) (i_ed - i_st + 1) * 0.05 + 0.5;
				//探索区間の決定
				st = (int) (i_st+w1);
				ed = (int) (i_ed - w1);
			}else{
				//頂点[i]から頂点[i+1]までの輪郭が、2区間に分かれているとき
				w1 = (Number) ((i_ed+cood_num-i_st+1)%cood_num) * 0.05 + 0.5;
				//探索区間の決定
				st = ((int) (i_st+w1))%cood_num;
				ed = ((int) (i_ed+cood_num-w1))%cood_num;
			}
			//探索区間数を確認
			if(st<=ed){
				//探索区間は1区間
				n = ed - st + 1;
				if(this._dist_factor!=null){
					this._dist_factor.observ2IdealBatch(i_coord.items, st, n,this._xpos,this._ypos,0);
				}
			}else{
				//探索区間は2区間
				n=ed+1+cood_num-st;
				if(this._dist_factor!=null){
					this._dist_factor.observ2IdealBatch(i_coord.items, st,cood_num-st,this._xpos,this._ypos,0);
					this._dist_factor.observ2IdealBatch(i_coord.items, 0,ed+1,this._xpos,this._ypos,cood_num-st);
				}
			}
			//要素数の確認
			if (n < 2) {
				// nが2以下でmatrix.PCAを計算することはできないので、エラー
				return false;
			}
			//主成分分析する。
			var evec:FLARDoubleMatrix22=this.__getSquareLine_evec;
			var mean:Vector.<Number>=this.__getSquareLine_mean;

			
			this._pca.pca(this._xpos,this._ypos,n,evec, this.__getSquareLine_ev,mean);
			o_line.a = evec.m01;// line[i][0] = evec->m[1];
			o_line.b = -evec.m00;// line[i][1] = -evec->m[0];
			o_line.c = -(o_line.a * mean[0] + o_line.b * mean[1]);// line[i][2] = -(line[i][0]*mean->v[0] + line[i][1]*mean->v[1]);

			return true;
		}
	}

}