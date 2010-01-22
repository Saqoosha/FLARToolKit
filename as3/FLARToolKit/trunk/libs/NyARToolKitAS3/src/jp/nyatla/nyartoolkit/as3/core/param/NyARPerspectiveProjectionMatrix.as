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
package jp.nyatla.nyartoolkit.as3.core.param
{
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;	

	final public class NyARPerspectiveProjectionMatrix extends NyARDoubleMatrix34
	{
		/*
		 * static double dot( double a1, double a2, double a3,double b1, double b2,double b3 )
		 */
		private static function dot(a1:Number,a2:Number,a3:Number,b1:Number,b2:Number,b3:Number):Number
		{
			return (a1 * b1 + a2 * b2 + a3 * b3);
		}

		/* static double norm( double a, double b, double c ) */
		private static function norm(a:Number,b:Number,c:Number):Number
		{
			return Math.sqrt(a * a + b * b + c * c);
		}

		/**
		 * int arParamDecompMat( double source[3][4], double cpara[3][4], double trans[3][4] ); 関数の置き換え Optimize STEP[754->665]
		 * 
		 * @param o_cpara
		 *            戻り引数。3x4のマトリクスを指定すること。
		 * @param o_trans
		 *            戻り引数。3x4のマトリクスを指定すること。
		 * @return
		 */
		public function decompMat(o_cpara:NyARMat,o_trans:NyARMat):void
		{
			var r:Number, c:Number;
			var rem1:Number, rem2:Number, rem3:Number;
			var c00:Number,c01:Number,c02:Number,c03:Number,c10:Number,c11:Number,c12:Number,c13:Number,c20:Number,c21:Number,c22:Number,c23:Number;
			if (this.m23>= 0) {// if( source[2][3] >= 0 ) {
				// <Optimize>
				// for(int r = 0; r < 3; r++ ){
				// for(int c = 0; c < 4; c++ ){
				// Cpara[r][c]=source[r][c];//Cpara[r][c] = source[r][c];
				// }
				// }
				c00=this.m00;
				c01=this.m01;
				c02=this.m02;
				c03=this.m03;
				c10=this.m10;
				c11=this.m11;
				c12=this.m12;
				c13=this.m13;
				c20=this.m20;
				c21=this.m21;
				c22=this.m22;
				c23=this.m23;
			} else {
				// <Optimize>
				// for(int r = 0; r < 3; r++ ){
				// for(int c = 0; c < 4; c++ ){
				// Cpara[r][c]=-source[r][c];//Cpara[r][c] = -(source[r][c]);
				// }
				// }
				c00=-this.m00;
				c01=-this.m01;
				c02=-this.m02;
				c03=-this.m03;
				c10=-this.m10;
				c11=-this.m11;
				c12=-this.m12;
				c13=-this.m13;
				c20=-this.m20;
				c21=-this.m21;
				c22=-this.m22;
				c23=-this.m23;
			}

			var cpara:Vector.<Vector.<Number>>= o_cpara.getArray();
			var trans:Vector.<Vector.<Number>>= o_trans.getArray();
			for (r = 0; r < 3; r++) {
				for (c = 0; c < 4; c++) {
					cpara[r][c] = 0.0;// cpara[r][c] = 0.0;
				}
			}
			cpara[2][2] = norm(c20, c21, c22);// cpara[2][2] =norm( Cpara[2][0],Cpara[2][1],Cpara[2][2]);
			trans[2][0] = c20 / cpara[2][2];// trans[2][0] = Cpara[2][0] /cpara[2][2];
			trans[2][1] = c21 / cpara[2][2];// trans[2][1] = Cpara[2][1] / cpara[2][2];
			trans[2][2] = c22 / cpara[2][2];// trans[2][2] =Cpara[2][2] /cpara[2][2];
			trans[2][3] = c23 / cpara[2][2];// trans[2][3] =Cpara[2][3] /cpara[2][2];

			cpara[1][2] = dot(trans[2][0], trans[2][1], trans[2][2], c10, c11, c12);// cpara[1][2]=dot(trans[2][0],trans[2][1],trans[2][2],Cpara[1][0],Cpara[1][1],Cpara[1][2]);
			rem1 = c10 - cpara[1][2] * trans[2][0];// rem1 =Cpara[1][0] -cpara[1][2] *trans[2][0];
			rem2 = c11 - cpara[1][2] * trans[2][1];// rem2 =Cpara[1][1] -cpara[1][2] *trans[2][1];
			rem3 = c12 - cpara[1][2] * trans[2][2];// rem3 =Cpara[1][2] -cpara[1][2] *trans[2][2];
			cpara[1][1] = norm(rem1, rem2, rem3);// cpara[1][1] = norm( rem1,// rem2, rem3 );
			trans[1][0] = rem1 / cpara[1][1];// trans[1][0] = rem1 / cpara[1][1];
			trans[1][1] = rem2 / cpara[1][1];// trans[1][1] = rem2 / cpara[1][1];
			trans[1][2] = rem3 / cpara[1][1];// trans[1][2] = rem3 / cpara[1][1];

			cpara[0][2] = dot(trans[2][0], trans[2][1], trans[2][2], c00, c01, c02);// cpara[0][2] =dot(trans[2][0], trans[2][1],trans[2][2],Cpara[0][0],Cpara[0][1],Cpara[0][2]);
			cpara[0][1] = dot(trans[1][0], trans[1][1], trans[1][2], c00, c01, c02);// cpara[0][1]=dot(trans[1][0],trans[1][1],trans[1][2],Cpara[0][0],Cpara[0][1],Cpara[0][2]);
			rem1 = c00 - cpara[0][1] * trans[1][0] - cpara[0][2]* trans[2][0];// rem1 = Cpara[0][0] - cpara[0][1]*trans[1][0]- cpara[0][2]*trans[2][0];
			rem2 = c01 - cpara[0][1] * trans[1][1] - cpara[0][2]* trans[2][1];// rem2 = Cpara[0][1] - cpara[0][1]*trans[1][1]- cpara[0][2]*trans[2][1];
			rem3 = c02 - cpara[0][1] * trans[1][2] - cpara[0][2]* trans[2][2];// rem3 = Cpara[0][2] - cpara[0][1]*trans[1][2] - cpara[0][2]*trans[2][2];
			cpara[0][0] = norm(rem1, rem2, rem3);// cpara[0][0] = norm( rem1,rem2, rem3 );
			trans[0][0] = rem1 / cpara[0][0];// trans[0][0] = rem1 / cpara[0][0];
			trans[0][1] = rem2 / cpara[0][0];// trans[0][1] = rem2 / cpara[0][0];
			trans[0][2] = rem3 / cpara[0][0];// trans[0][2] = rem3 / cpara[0][0];

			trans[1][3] = (c13 - cpara[1][2] * trans[2][3])/ cpara[1][1];// trans[1][3] = (Cpara[1][3] -cpara[1][2]*trans[2][3]) / cpara[1][1];
			trans[0][3] = (c03 - cpara[0][1] * trans[1][3] - cpara[0][2]* trans[2][3])/ cpara[0][0];// trans[0][3] = (Cpara[0][3] -cpara[0][1]*trans[1][3]-cpara[0][2]*trans[2][3]) / cpara[0][0];

			for (r = 0; r < 3; r++) {
				for (c = 0; c < 3; c++) {
					cpara[r][c] /= cpara[2][2];// cpara[r][c] /= cpara[2][2];
				}
			}
			return;
		}
		/**
		 * int arParamChangeSize( ARParam *source, int xsize, int ysize, ARParam *newparam );
		 * Matrixのスケールを変換します。
		 * @param i_scale
		 * 
		 */
		public function changeScale(i_scale:Number):void
		{
			this.m00=this.m00*i_scale;
			this.m10=this.m10*i_scale;
			this.m01=this.m01*i_scale;
			this.m11=this.m11*i_scale;
			this.m02=this.m02*i_scale;
			this.m12=this.m12*i_scale;
			this.m03=this.m03*i_scale;
			this.m13=this.m13*i_scale;
			//for (int i = 0; i < 4; i++) {
			//	array34[0 * 4 + i] = array34[0 * 4 + i] * scale;// newparam->mat[0][i]=source->mat[0][i]* scale;
			//	array34[1 * 4 + i] = array34[1 * 4 + i] * scale;// newparam->mat[1][i]=source->mat[1][i]* scale;
			//	array34[2 * 4 + i] = array34[2 * 4 + i];// newparam->mat[2][i] = source->mat[2][i];
			//}
			return;
		}
		/**
		 * 現在の行列で３次元座標を射影変換します。
		 * @param i_3dvertex
		 * @param o_2d
		 */
		public function projectionConvert_NyARDoublePoint3d(i_3dvertex:NyARDoublePoint3d,o_2d:NyARDoublePoint2d):void
		{
			var w:Number=i_3dvertex.z*this.m22;
			o_2d.x=(i_3dvertex.x*this.m00+i_3dvertex.y*this.m01+i_3dvertex.z*this.m02)/w;
			o_2d.y=(i_3dvertex.y*this.m11+i_3dvertex.z*this.m12)/w;
			return;
		}
		public function projectionConvert_Number(i_x:Number,i_y:Number,i_z:Number,o_2d:NyARDoublePoint2d):void
		{
			var w:Number=i_z*this.m22;
			o_2d.x=(i_x*this.m00+i_y*this.m01+i_z*this.m02)/w;
			o_2d.y=(i_y*this.m11+i_z*this.m12)/w;
			return;
		}	
		
		
	}
}