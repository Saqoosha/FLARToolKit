/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core
{	
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.nyartoolkit.as3.utils.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.as3utils.*;
	/**
	 * ARMat構造体に対応するクラス typedef struct { double *m; int row; int clm; }ARMat;
	 * 
	 */
	public class NyARMat
	{
		/**
		 * 配列サイズと行列サイズは必ずしも一致しないことに注意 返された配列のサイズを行列の大きさとして使わないこと！
		 * 
		 */
		protected var _m:Vector.<Vector.<Number>>; 
		private var __matrixSelfInv_nos:Vector.<Number>;

		private var clm:int;
		private var row:int;
		
		public function NyARMat(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 2:
				overload_NyARMat_2ii(int(args[0]), int(args[1]));
				break;
			case 4:
				overload_NyARMat_4iiao(int(args[0]), int(args[1]),Vector.<Vector.<Number>>(args[2]),Boolean(args[3]));
				break;
			default:
				throw new NyARException();
			}			
		}		

		private function overload_NyARMat_2ii(i_row:int,i_clm:int):void
		{
			this._m = ArrayUtils.create2dNumber(i_row, i_clm);
			this.__matrixSelfInv_nos=new Vector.<Number>(i_row);
			this.clm = i_clm;
			this.row = i_row;
			return;
		}
		/**
		 * 配列i_mをラップしてインスタンスを生成します。
		 * 
		 * @param i_row
		 * 行列の行数です。
		 * @param i_clm
		 * 行列の列数です。
		 * @param i_m
		 * 行列の　バッファです。double[i_row][i_clm]の配列を指定します。
		 * @param i_is_attached_buffer
		 * i_mをインスタンスが管理するかを示します。trueの場合、i_mの所有権はインスタンスに移ります。
		 */
		private function overload_NyARMat_4iiao(i_row:int,i_clm:int,i_m:Vector.<Vector.<Number>>,i_is_attached_buffer:Boolean):void
		{
			this.clm=i_clm;
			this.row=i_row;
			this._m=i_m;
		}
		/**
		 * 行列の列数を返します。
		 * @return
		 */
		public function getClm():int
		{
			return clm;
		}
		/**
		 * 行列の行数を返します。
		 * @return
		 */
		public function getRow():int
		{
			return row;
		}
		public function getArray():Vector.<Vector.<Number>>
		{
			return this._m;
		}
		public function mul(i_mat_a:NyARMat,i_mat_b:NyARMat):void
		{
			NyAS3Utils.assert(i_mat_a.clm == i_mat_b.row && this.row==i_mat_a.row && this.clm==i_mat_b.clm);

			var w:Number;
			var r:int, c:int, i:int;
			var am:Vector.<Vector.<Number>> = i_mat_a._m;
			var bm:Vector.<Vector.<Number>>  = i_mat_b._m;
			var dm:Vector.<Vector.<Number>> = this._m;
			// For順変更禁止
			for (r = 0; r < this.row; r++) {
				for (c = 0; c < this.clm; c++) {
					w = 0.0;
					for (i = 0; i < i_mat_a.clm; i++) {
						w += am[r][i] * bm[i][c];
					}
					dm[r][c] = w;
				}
			}
			return;
		}		
		/**
		 * 逆行列を計算して、thisへ格納します。
		 * @throws NyARException
		 */
		public function inverse():Boolean
		{
			var ap:Vector.<Vector.<Number>> = this._m;
			var dimen:int = this.row;
			var dimen_1:int = dimen - 1;
			var ap_n:Vector.<Number>, ap_ip:Vector.<Number>, ap_i:Vector.<Number>;// wap;
			var j:int, ip:int, nwork:int;
			var nos:Vector.<Number> = this.__matrixSelfInv_nos;//ワーク変数
			// double epsl;
			var p:Number, pbuf:Number, work:Number;

			/* check size */
			switch (dimen) {
			case 0:
				throw new NyARException();
			case 1:
				ap[0][0] = 1.0 / ap[0][0];// *ap = 1.0 / (*ap);
				return true;/* 1 dimension */
			}
			var n:int;
			for (n = 0; n < dimen; n++) {
				nos[n] = n;
			}

			/*
			 * nyatla memo ipが定まらないで計算が行われる場合があるので挿入。 ループ内で0初期化していいかが判らない。
			 */
			ip = 0;
			// For順変更禁止
			for (n = 0; n < dimen; n++) {
				ap_n = ap[n];// wcp = ap + n * rowa;
				p = 0.0;
				for (var i:int = n; i < dimen; i++) {
					if (p < (pbuf = Math.abs(ap[i][0]))) {
						p = pbuf;
						ip = i;
					}
				}
				// if (p <= matrixSelfInv_epsl){
				if (p == 0.0) {
					return false;
					// throw new NyARException();
				}

				nwork = nos[ip];
				nos[ip] = nos[n];
				nos[n] = nwork;

				ap_ip = ap[ip];
				for (j = 0; j < dimen; j++) {// for(j = 0, wap = ap + ip * rowa,
												// wbp = wcp; j < dimen ; j++) {
					work = ap_ip[j]; // work = *wap;
					ap_ip[j] = ap_n[j];
					ap_n[j] = work;
				}

				work = ap_n[0];
				for (j = 0; j < dimen_1; j++) {
					ap_n[j] = ap_n[j + 1] / work;// *wap = *(wap + 1) / work;
				}
				ap_n[j] = 1.0 / work;// *wap = 1.0 / work;
				for (i = 0; i < dimen; i++) {
					if (i != n) {
						ap_i = ap[i];// wap = ap + i * rowa;
						work = ap_i[0];
						for (j = 0; j < dimen_1; j++) {// for(j = 1, wbp = wcp,work = *wap;j < dimen ;j++, wap++, wbp++)
							ap_i[j] = ap_i[j + 1] - work * ap_n[j];// wap = *(wap +1) - work *(*wbp);
						}
						ap_i[j] = -work * ap_n[j];// *wap = -work * (*wbp);
					}
				}
			}

			for (n = 0; n < dimen; n++) {
				for (j = n; j < dimen; j++) {
					if (nos[j] == n) {
						break;
					}
				}
				nos[j] = nos[n];
				for (i = 0; i < dimen; i++) {
					ap_i = ap[i];
					work = ap_i[j];// work = *wap;
					ap_i[j] = ap_i[n];// *wap = *wbp;
					ap_i[n] = work;// *wbp = work;
				}
			}
			return true;
		}

		/**
		 * i_copy_fromの内容を、thisへコピーします。 
		 * @param i_copy_from
		 * コピー元の行列です。
		 * この行列のサイズは、thisと同じでなければなりません。
		 */
		public function setValue(i_copy_from:NyARMat):void
		{
			// サイズ確認
			if (this.row != i_copy_from.row || this.clm != i_copy_from.clm) {
				throw new NyARException();
			}
			// 値コピー
			for (var r:int = this.row - 1; r >= 0; r--) {
				for (var c:int = this.clm - 1; c >= 0; c--) {
					this._m[r][c] = i_copy_from._m[r][c];
				}
			}
		}

		/**
		 * 行列の要素を、全て0にします。
		 */
		public function loadZero():void
		{
			// For順変更OK
			for (var i:int = this.row - 1; i >= 0; i--) {
				for (var i2:int = this.clm - 1; i2 >= 0; i2--) {
					this._m[i][i2] = 0.0;
				}
			}
		}
		/**
		 * i_srcの転置行列をインスタンスにセットします。
		 * @param i_src
		 * 入力元のオブジェクト。(i_src.row == this.clm)&&(i_src.clm == this.row)でなければなりません。
		 */
		public function transpose(i_src:NyARMat):void
		{
			if (this.row != i_src.clm || this.clm != i_src.row) {
				throw new NyARException();
			}
			for (var r:int = 0; r < this.row; r++) {
				for (var c:int = 0; c < this.clm; c++) {
					this._m[r][c] = i_src._m[c][r];
				}
			}		
		}
//		***************************************
//		There are not used by NyARToolKit.
//		***************************************
//		public function realloc(i_row:int,i_clm:int):void
//		public function matrixMul(i_mat_a:NyARMat,i_mat_b:NyARMat):void
//		public function zeroClear():void
//		public function copyFrom(NyARMat i_copy_from):void
//		public static function matrixTrans(dest:NyARMat,source:NyARMat):void
//		public static function matrixUnit(uint:NyARMat):void
//		public function matrixDup(i_source:NyARMat):void
//		public function matrixAllocDup():NyARMat
//		private static const PCA_EPS:Number = 1e-6; // #define EPS 1e-6
//		private static const PCA_MAX_ITER:int = 100; // #define MAX_ITER 100
//		private static const PCA_VZERO:Number = 1e-16; // #define VZERO 1e-16
//		private function PCA_EX(mean:NyARVec):void
//		private static function PCA_CENTER(inout:NyARMat,mean:NyARMat):void
//		private static function PCA_x_by_xt(input:NyARMat,output:NyARMat):void
//		private static function PCA_xt_by_x(input:NyARMat,i_output:NyARMat):void
//		private var wk_PCA_QRM_ev:NyARVec = new NyARVec(1);
//		private function PCA_QRM(dv:NyARVec):void
//		private function flipRow(i_row_1:int,i_row_2:int):void
//		private static function PCA_EV_create(input:NyARMat,u:NyARMat,output:NyARMat,ev:NyARVec):void
//		private function PCA_PCA(o_output:NyARMat,o_ev:NyARVec):void
//		public function pca(o_evec:NyARMat, o_ev:NyARVec, o_mean:NyARVec):void
//		private var wk_vecTridiagonalize_vec:NyARVec = new NyARVec(0);
//		private var wk_vecTridiagonalize_vec2:NyARVec = new NyARVec(0);
//		private function vecTridiagonalize(d:NyARVec,e:NyARVec,i_e_start:int):void
	}

}