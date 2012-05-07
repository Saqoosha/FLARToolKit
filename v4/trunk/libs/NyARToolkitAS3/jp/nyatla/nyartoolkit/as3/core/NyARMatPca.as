/* 
 * PROJECT: NyARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2012 Ryo Iizuka
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
	import jp.nyatla.as3utils.*;

/**
 * このクラスは、主成分機能を追加した{@param NyARMat}です。
 */
public class NyARMatPca extends NyARMat
{
	private var wk_PCA_QRM_ev:NyARVec = new NyARVec(1);
	private var wk_PCA_PCA_u:NyARMatPca = null;
	/**
	 * コンストラクタです。
	 * i_r * i_cの行列を作成します。
	 * @param i_r
	 * @param i_c
	 */
	public function NyARMatPca(i_r:int,i_c:int)
	{
		super(i_r,i_c);
	}

	
	/**
	 * 現在の行列に主成分分析を実行して、結果をthisと引数へ格納します。
	 * 詳細は不明です。
	 * @param o_evec
	 * 不明
	 * @param o_ev
	 * 不明
	 * @param o_mean
	 * 不明
	 * @throws NyARException
	 */
	public function pca(o_evec:NyARMat,o_ev:NyARVec,o_mean:NyARVec):void
	{
		var l_row:Number = this.row;// row = input->row;
		var l_clm:Number = this.clm;// clm = input->clm;
		var check:Number=(l_row < l_clm) ? l_row : l_clm;
		
		NyAS3Utils.assert(l_row >= 2 || l_clm >= 2);
		NyAS3Utils.assert(o_evec.clm == l_clm && o_evec.row == check);
		NyAS3Utils.assert(o_ev.getClm() == check);
		NyAS3Utils.assert(o_mean.getClm() == l_clm);
		
		var srow:Number = Math.sqrt((double) l_row);
		PCA_EX(o_mean);

		PCA_CENTER(this, o_mean);

		var i:int, j:int;
		// For順変更OK
		for (i = 0; i < l_row; i++) {
			for (j = 0; j < l_clm; j++) {
				this._m[i][j] /= srow;// work->m[i] /= srow;
			}
		}

		PCA_PCA(o_evec, o_ev);

		var sum:Number = 0.0;
		var ev_array:Vector.<Number> = o_ev.getArray();
		var ev_clm:int = o_ev.getClm();
		// For順変更禁止
		for (i = 0; i < ev_clm; i++) {// for(int i = 0; i < ev->clm; i++ ){
			sum += ev_array[i];// sum += ev->v[i];
		}
		// For順変更禁止
		for (i = 0; i < ev_clm; i++) {// for(int i = 0; i < ev->clm; i++ ){
			ev_array[i] /= sum;// ev->v[i] /= sum;
		}
		return;
	}
	
	/**
	 * ARToolKitのPCA関数と同等な関数です。
	 * 詳細は不明です。
	 * @param output
	 * 不明
	 * @param o_ev
	 * 不明
	 * @throws NyARException
	 */
	private function PCA_PCA(o_output:NyARMat, o_ev:NyARVec):void
	{

		var l_row:int, l_clm:int, min:int;
		var ev_array:Vector.<Number> = o_ev.getArray();

		l_row = this.row;// row = input->row;
		l_clm = this.clm;// clm = input->clm;
		min = (l_clm < l_row) ? l_clm : l_row;
		if (l_row < 2 || l_clm < 2) {
			throw new NyARException();
		}
		if (o_output.clm != this.clm) {// if( output->clm != input->clm ){
			throw new NyARException();
		}
		if (o_output.row != min) {// if( output->row != min ){
			throw new NyARException();
		}
		if (o_ev.getClm() != min) {// if( ev->clm != min ){
			throw new NyARException();
		}

		var u:NyARMatPca;// u =new NyARMat( min, min );
		if (this.wk_PCA_PCA_u == null) {
			u = new NyARMatPca(min, min);
			this.wk_PCA_PCA_u = u;
		} else {
			u = this.wk_PCA_PCA_u;
			u.realloc(min, min);
		}

		if (l_row < l_clm) {
			NyARException.trap("未チェックのパス");
			PCA_x_by_xt(this, u);// if(x_by_xt( input, u ) < 0 ) {
		} else {
			PCA_xt_by_x(this, u);// if(xt_by_x( input, u ) < 0 ) {
		}
		u.PCA_QRM(o_ev);

		double[][] m1, m2;
		if (l_row < l_clm) {
			NyARException.trap("未チェックのパス");
			PCA_EV_create(this, u, o_output, o_ev);
		} else {
			m1 = u._m;// m1 = u->m;
			m2 = o_output._m;// m2 = output->m;
			int i;
			for (i = 0; i < min; i++) {
				if (ev_array[i] < PCA_VZERO) {// if( ev->v[i] < VZERO ){
					break;
				}
				for (int j = 0; j < min; j++) {
					m2[i][j] = m1[i][j];// *(m2++) = *(m1++);
				}
			}
			for (; i < min; i++) {// for( ; i < min; i++){
				// コードを見た限りあってそうだからコメントアウト(2008/03/26)NyARException.trap("未チェックのパス");
				ev_array[i] = 0.0;// ev->v[i] = 0.0;
				for (int j = 0; j < min; j++) {
					m2[i][j] = 0.0;// *(m2++) = 0.0;
				}
			}
		}
	}
	private static final double PCA_EPS = 1e-6; // #define EPS 1e-6

	private static final int PCA_MAX_ITER = 100; // #define MAX_ITER 100

	private static final double PCA_VZERO = 1e-16; // #define VZERO 1e-16
	/**
	 * ARToolKitのEV_create関数と同等な関数です。
	 * 詳細は不明です。
	 * @param input
	 * 不明。
	 * @param u
	 * 不明。
	 * @param output
	 * 不明。
	 * @param ev
	 * 不明。
	 * @throws NyARException
	 */
	private static void PCA_EV_create(NyARMat input, NyARMat u, NyARMat output,NyARVec ev) throws NyARException
	{
		NyARException.trap("未チェックのパス");
		int row, clm;
		row = input.row;// row = input->row;
		clm = input.clm;// clm = input->clm;
		if (row <= 0 || clm <= 0) {
			throw new NyARException();
		}
		if (u.row != row || u.clm != row) {// if( u->row != row || u->clm !=
											// row ){
			throw new NyARException();
		}
		if (output.row != row || output.clm != clm) {// if( output->row !=
														// row || output->clm !=
														// clm ){
			throw new NyARException();
		}
		if (ev.getClm() != row) {// if( ev->clm != row ){
			throw new NyARException();
		}
		double[][] m, in_;
		double[] m1, ev_array;
		double sum, work;

		NyARException.trap("未チェックのパス");
		m = output._m;// m = output->m;
		in_ = input._m;
		int i;
		ev_array = ev.getArray();
		for (i = 0; i < row; i++) {
			NyARException.trap("未チェックのパス");
			if (ev_array[i] < PCA_VZERO) {// if( ev->v[i] < VZERO ){
				break;
			}
			NyARException.trap("未チェックのパス");
			work = 1 / Math.sqrt(Math.abs(ev_array[i]));// work = 1 /
														// sqrt(fabs(ev->v[i]));
			for (int j = 0; j < clm; j++) {
				sum = 0.0;
				m1 = u._m[i];// m1 = &(u->m[i*row]);
				// m2=input.getPointer(j);//m2 = &(input->m[j]);
				for (int k = 0; k < row; k++) {
					sum += m1[k] + in_[k][j];// sum += *m1 * *m2;
					// m1.incPtr(); //m1++;
					// m2.addPtr(clm);//m2 += clm;
				}
				m1[j] = sum * work;// *(m++) = sum * work;
				// {//*(m++) = sum * work;
				// m.set(sum * work);
				// m.incPtr();}
			}
		}
		for (; i < row; i++) {
			NyARException.trap("未チェックのパス");
			ev_array[i] = 0.0;// ev->v[i] = 0.0;
			for (int j = 0; j < clm; j++) {
				m[i][j] = 0.0;
				// m.set(0.0);//*(m++) = 0.0;
				// m.incPtr();
			}
		}
	}

	/**
	 * ARToolKitのEX関数と同等な関数です。
	 * 詳細は不明です。
	 * @param mean
	 * 不明
	 * @throws NyARException
	 */
	private void PCA_EX(NyARVec mean) throws NyARException
	{
		int lrow, lclm;
		int i, i2;
		lrow = this.row;
		lclm = this.clm;
		double[][] lm = this._m;

		if (lrow <= 0 || lclm <= 0) {
			throw new NyARException();
		}
		if (mean.getClm() != lclm) {
			throw new NyARException();
		}
		// double[] mean_array=mean.getArray();
		// mean.zeroClear();
		final double[] mean_array = mean.getArray();
		double w;
		// For順変更禁止
		for (i2 = 0; i2 < lclm; i2++) {
			w = 0.0;
			for (i = 0; i < lrow; i++) {
				// *(v++) += *(m++);
				w += lm[i][i2];
			}
			mean_array[i2] = w / lrow;// mean->v[i] /= row;
		}
	}

	/**
	 * ARToolKitのCENTER関数と同等な関数です。
	 * 詳細は不明です。
	 * @param inout
	 * 不明
	 * @param mean
	 * 不明
	 */
	private static void PCA_CENTER(NyARMat inout, NyARVec mean)throws NyARException
	{
		double[] v;
		int row, clm;

		row = inout.row;
		clm = inout.clm;
		if (mean.getClm() != clm) {
			throw new NyARException();
		}
		double[][] im = inout._m;
		double[] im_i;
		double w0, w1;
		v = mean.getArray();
		// 特にパフォーマンスが劣化するclm=1と2ときだけ、別パスで処理します。
		switch (clm) {
		case 1:
			w0 = v[0];
			for (int i = 0; i < row; i++) {
				im[i][0] -= w0;
			}
			break;
		case 2:
			w0 = v[0];
			w1 = v[1];
			for (int i = 0; i < row; i++) {
				im_i = im[i];
				im_i[0] -= w0;
				im_i[1] -= w1;
			}
			break;
		default:
			for (int i = 0; i < row; i++) {
				im_i = im[i];
				for (int j = 0; j < clm; j++) {
					// *(m++) -= *(v++);
					im_i[j] -= v[j];
				}
			}
			break;
		}
		return;
	}
	/**
	 * ARToolKitのx_by_xtと同等な関数です。
	 * 詳細は不明です。
	 * この関数は未チェックの為、使用すると例外が発生します。
	 * @param input
	 * 不明
	 * @param output
	 * 不明
	 * @throws NyARException
	 */
	private static void PCA_x_by_xt(NyARMat input, NyARMat output) throws NyARException
	{
		NyARException.trap("動作未チェック/配列化未チェック");
		int row, clm;
		// double[][] out;
		double[] in1, in2;

		NyARException.trap("未チェックのパス");
		row = input.row;
		clm = input.clm;
		NyARException.trap("未チェックのパス");
		if (output.row != row || output.clm != row) {
			throw new NyARException();
		}

		// out = output.getArray();
		for (int i = 0; i < row; i++) {
			for (int j = 0; j < row; j++) {
				if (j < i) {
					NyARException.trap("未チェックのパス");
					output._m[i][j] = output._m[j][i];// *out =
													// output->m[j*row+i];
				} else {
					NyARException.trap("未チェックのパス");
					in1 = input._m[i];// input.getRowArray(i);//in1 = &(input->m[clm*i]);
					in2 = input._m[j];// input.getRowArray(j);//in2 = &(input->m[clm*j]);
					output._m[i][j] = 0;// *out = 0.0;
					for (int k = 0; k < clm; k++) {
						output._m[i][j] += (in1[k] * in2[k]);// *out += *(in1++)
															// * *(in2++);
					}
				}
				// out.incPtr();
			}
		}
	}

	/**
	 * ARToolKitのxt_by_x関数と同等な関数です。
	 * 詳細は不明です。
	 * @param input
	 * 不明
	 * @param i_output
	 * 不明
	 * @throws NyARException
	 */
	private static void PCA_xt_by_x(NyARMat input, NyARMat i_output) throws NyARException
	{
		double[] in_;
		int row, clm;

		row = input.row;
		clm = input.clm;
		if (i_output.row != clm || i_output.clm != clm) {
			throw new NyARException();
		}

		int k, j;
		double[][] out_m = i_output._m;
		double w;
		for (int i = 0; i < clm; i++) {
			for (j = 0; j < clm; j++) {
				if (j < i) {
					out_m[i][j] = out_m[j][i];// *out = output->m[j*clm+i];
				} else {
					w = 0.0;// *out = 0.0;
					for (k = 0; k < row; k++) {
						in_ = input._m[k];// in=input.getRowArray(k);
						w += (in_[i] * in_[j]);// *out += *in1 * *in2;
					}
					out_m[i][j] = w;
				}
			}
		}
	}
	/**
	 * ARToolKitのQRM関数と同等な関数です。
	 * 詳細は不明です。
	 * @param dv
	 * 不明
	 * @throws NyARException
	 */
	private void PCA_QRM(NyARVec dv) throws NyARException
	{
		var w:Number, t:Number, s:Number, x:Number, y:Number, c:Number;
		var dim:int, iter:int;
		var dv_array:Vector.<Number> = dv.getArray();

		dim = this.row;
		if (dim != this.clm || dim < 2) {
			throw new NyARException();
		}
		if (dv.getClm() != dim) {
			throw new NyARException();
		}

		var ev:NyARVec = this.wk_PCA_QRM_ev;
		ev.realloc(dim);
		var ev_array:Vector.<Number> = ev.getArray();
		if (ev == null) {
			throw new NyARException();
		}
		var L_m:Vector.<Vector.<Number>> = this._m;
		this.vecTridiagonalize(dv, ev, 1);

		ev_array[0] = 0.0;// ev->v[0] = 0.0;
		for (var h:int = dim - 1; h > 0; h--) {
			var j:int = h;
			while (j > 0&& Math.abs(ev_array[j]) > PCA_EPS* (Math.abs(dv_array[j - 1]) + Math.abs(dv_array[j]))) {// while(j>0 && fabs(ev->v[j]) >EPS*(fabs(dv->v[j-1])+fabs(dv->v[j])))
				// j--;
				j--;
			}
			if (j == h) {
				continue;
			}
			iter = 0;
			do {
				iter++;
				if (iter > PCA_MAX_ITER) {
					break;
				}
				w = (dv_array[h - 1] - dv_array[h]) / 2;// w = (dv->v[h-1] -dv->v[h]) / 2;//ここ？
				t = ev_array[h] * ev_array[h];// t = ev->v[h] * ev->v[h];
				s = Math.sqrt(w * w + t);
				if (w < 0) {
					s = -s;
				}
				x = dv_array[j] - dv_array[h] + t / (w + s);// x = dv->v[j] -dv->v[h] +t/(w+s);
				y = ev_array[j + 1];// y = ev->v[j+1];
				for (int k = j; k < h; k++) {
					if (Math.abs(x) >= Math.abs(y)) {
						if (Math.abs(x) > PCA_VZERO) {
							t = -y / x;
							c = 1 / Math.sqrt(t * t + 1);
							s = t * c;
						} else {
							c = 1.0;
							s = 0.0;
						}
					} else {
						t = -x / y;
						s = 1.0 / Math.sqrt(t * t + 1);
						c = t * s;
					}
					w = dv_array[k] - dv_array[k + 1];// w = dv->v[k] -dv->v[k+1];
					t = (w * s + 2 * c * ev_array[k + 1]) * s;// t = (w * s +2 * c *ev->v[k+1]) *s;
					dv_array[k] -= t;// dv->v[k] -= t;
					dv_array[k + 1] += t;// dv->v[k+1] += t;
					if (k > j) {
						NyARException.trap("未チェックパス");
						{
							ev_array[k] = c * ev_array[k] - s * y;// ev->v[k]= c *ev->v[k]- s * y;
						}
					}
					ev_array[k + 1] += s * (c * w - 2 * s * ev_array[k + 1]);// ev->v[k+1]+= s * (c* w- 2* s *ev->v[k+1]);

					for (var i:int = 0; i < dim; i++) {
						x = L_m[k][i];// x = a->m[k*dim+i];
						y = L_m[k + 1][i];// y = a->m[(k+1)*dim+i];
						L_m[k][i] = c * x - s * y;// a->m[k*dim+i] = c * x - s* y;
						L_m[k + 1][i] = s * x + c * y;// a->m[(k+1)*dim+i] = s* x + c * y;
					}
					if (k < h - 1) {
						NyARException.trap("未チェックパス");
						{
							x = ev_array[k + 1];// x = ev->v[k+1];
							y = -s * ev_array[k + 2];// y = -s * ev->v[k+2];
							ev_array[k + 2] *= c;// ev->v[k+2] *= c;
						}
					}
				}
			} while (Math.abs(ev_array[h]) > PCA_EPS
					* (Math.abs(dv_array[h - 1]) + Math.abs(dv_array[h])));
		}
		for (var k:int = 0; k < dim - 1; k++) {
			var h:int = k;
			t = dv_array[h];// t = dv->v[h];
			for (int i = k + 1; i < dim; i++) {
				if (dv_array[i] > t) {// if( dv->v[i] > t ) {
					h = i;
					t = dv_array[h];// t = dv->v[h];
				}
			}
			dv_array[h] = dv_array[k];// dv->v[h] = dv->v[k];
			dv_array[k] = t;// dv->v[k] = t;
			this.flipRow(h, k);
		}
	}	
	/**
	 *　行列のうち、指定した２列の値を入れ替えます。
	 * @param i_row_1
	 * 入れ替える行番号1
	 * @param i_row_2
	 * 入れ替える行番号2
	 */
	private function flipRow(i_row_1:int,i_row_2:int):void
	{
		var i:int;
		var w:Number;
		var r1:Vector.<Number> = this._m[i_row_1], r2 = this._m[i_row_2];
		// For順変更OK
		for (i = clm - 1; i >= 0; i--) {
			w = r1[i];
			r1[i] = r2[i];
			r2[i] = w;
		}
	}
	private var wk_vecTridiagonalize_vec:NyARVec = new NyARVec(0);
	private var wk_vecTridiagonalize_vec2:NyARVec  = new NyARVec(0);

	/**
	 * ARToolKitの、arVecTridiagonalize関数と同等な関数です。
	 * 詳細は不明です。
	 * @param d
	 * 不明
	 * @param e
	 * 不明
	 * @param i_e_start
	 * 演算開始列(よくわからないけどarVecTridiagonalizeの呼び出し元でなんかしてる)
	 * @throws NyARException
	 */
	private void vecTridiagonalize( d:NyARVec, e:NyARVec , i_e_start:int):void
	{
		var vec:NyARVec = wk_vecTridiagonalize_vec;
		// double[][] a_array=a.getArray();
		var s:Number, t:Number, p:Number, q:Number;
		var dim:int;

		if (this.clm != this.row) {// if(a.getClm()!=a.getRow()){
			throw new NyARException();
		}
		if (this.clm != d.getClm()) {// if(a.getClm() != d.clm){
			throw new NyARException();
		}
		if (this.clm != e.getClm()) {// if(a.getClm() != e.clm){
			throw new NyARException();
		}
		dim = this.getClm();

		var d_vec:Vector.<Number>, e_vec:Vector.<Number>;
		d_vec = d.getArray();
		e_vec = e.getArray();
		var a_vec_k:Vector.<Number>;

		for (var k:int = 0; k < dim - 2; k++) {

			a_vec_k = this._m[k];
			vec.setNewArray(a_vec_k, clm);// vec=this.getRowVec(k);//double[]
											// vec_array=vec.getArray();
			NyARException.trap("未チェックパス");
			d_vec[k] = a_vec_k[k];// d.v[k]=vec.v[k];//d.set(k,v.get(k));
									// //d->v[k] = v[k];

			// wv1.clm = dim-k-1;
			// wv1.v = &(v[k+1]);
			NyARException.trap("未チェックパス");
			e_vec[k + i_e_start] = vec.vecHousehold(k + 1);// e.v[k+i_e_start]=vec.vecHousehold(k+1);//e->v[k]= arVecHousehold(&wv1);
			if (e_vec[k + i_e_start] == 0.0) {// if(e.v[k+i_e_start]== 0.0){//if(e.v[k+i_e_start]== 0.0){
				continue;
			}

			for (var i:int = k + 1; i < dim; i++) {
				s = 0.0;
				for (int j = k + 1; j < i; j++) {
					NyARException.trap("未チェックのパス");
					s += this._m[j][i] * a_vec_k[j];// s += a_array[j][i] *vec.v[j];//s +=a.get(j*dim+i) *v.get(j);//s +=a->m[j*dim+i] * v[j];
				}
				for (var j:int = i; j < dim; j++) {
					NyARException.trap("未チェックのパス");
					s += this._m[i][j] * a_vec_k[j];// s += a_array[i][j] *vec.v[j];//s +=a.get(i*dim+j) *v.get(j);//s +=a->m[i*dim+j] * v[j];
				}
				NyARException.trap("未チェックのパス");
				d_vec[i] = s;// d.v[i]=s;//d->v[i] = s;
			}

			// wv1.clm = wv2.clm = dim-k-1;
			// wv1.v = &(v[k+1]);
			// wv2.v = &(d->v[k+1]);
			a_vec_k = this._m[k];
			vec.setNewArray(a_vec_k, clm);// vec=this.getRowVec(k);
			// vec_array=vec.getArray();
			NyARException.trap("未チェックパス");
			t = vec.vecInnerproduct(d, k + 1) / 2;
			for (var i:int = dim - 1; i > k; i--) {
				NyARException.trap("未チェックパス");
				p = a_vec_k[i];// p = v.get(i);//p = v[i];
				d_vec[i] -= t * p;
				q = d_vec[i];// d.v[i]-=t*p;q=d.v[i];//q = d->v[i] -= t*p；
				for (var j:int = i; j < dim; j++) {
					NyARException.trap("未チェックパス");
					this._m[i][j] -= p * (d_vec[j] + q * a_vec_k[j]);// a.m[i][j]-=p*(d.v[j] +q*vec.v[j]);//a->m[i*dim+j] -=p*(d->v[j]) + q*v[j];
				}
			}
		}

		if (dim >= 2) {
			d_vec[dim - 2] = this._m[dim - 2][dim - 2];// d.v[dim-2]=a.m[dim-2][dim-2];//d->v[dim-2]=a->m[(dim-2)*dim+(dim-2)];
			e_vec[dim - 2 + i_e_start] = this._m[dim - 2][dim - 1];// e.v[dim-2+i_e_start]=a.m[dim-2][dim-1];//e->v[dim-2] = a->m[(dim-2)*dim+(dim-1)];
		}

		if (dim >= 1) {
			d_vec[dim - 1] = this._m[dim - 1][dim - 1];// d.v[dim-1]=a_array[dim-1][dim-1];//d->v[dim-1] =a->m[(dim-1)*dim+(dim-1)];
		}
		var vec2:NyARVec = this.wk_vecTridiagonalize_vec2;
		for (var k:int = dim - 1; k >= 0; k--) {
			a_vec_k = this._m[k];
			vec.setNewArray(a_vec_k, clm);// vec=this.getRowVec(k);//v =a.getPointer(k*dim);//v = &(a->m[k*dim]);
			if (k < dim - 2) {
				for (var i:int = k + 1; i < dim; i++) {
					// wv1.clm = wv2.clm = dim-k-1;
					// wv1.v = &(v[k+1]);
					// wv2.v = &(a->m[i*dim+k+1]);
					vec2.setNewArray(this._m[i], clm);// vec2=this.getRowVec(i);

					t = vec.vecInnerproduct(vec2, k + 1);
					for (var j:int = k + 1; j < dim; j++) {
						NyARException.trap("未チェックパス");
						this._m[i][j] -= t * a_vec_k[j];// a_array[i][j]-=t*vec.v[j];//a.subValue(i*dim+j,t*v.get(j));//a->m[i*dim+j]-= t * v[j];
					}
				}
			}
			for (var i:int = 0; i < dim; i++) {
				a_vec_k[i] = 0.0;// v.set(i,0.0);//v[i] = 0.0;
			}
			a_vec_k[k] = 1;// v.set(k,1);//v[k] = 1;
		}
		return;
	}	
}
