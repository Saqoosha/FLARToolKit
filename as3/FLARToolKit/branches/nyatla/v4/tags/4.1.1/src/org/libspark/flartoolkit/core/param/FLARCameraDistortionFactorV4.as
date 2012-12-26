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
package org.libspark.flartoolkit.core.param 
{
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.matrix.*;

	/**
	 * このクラスは、OpenCV distortion modelの樽型歪み設定/解除クラスです。
	 */
	public class FLARCameraDistortionFactorV4 implements IFLARCameraDistortionFactor
	{	
		public static const NUM_OF_FACTOR:int=9;
		private var _k1:Number;
		private var _k2:Number;
		private var _p1:Number;
		private var _p2:Number;
		private var _fx:Number;
		private var _fy:Number;
		private var _x0:Number;
		private var _y0:Number;
		private var _s:Number;
		private function getSizeFactor(x0:Number,y0:Number, xsize:int,ysize:int):Number
		{
			var ox:Number, oy:Number;
			var olen:Number, ilen:Number;
			var sf1:Number;

			var sf:Number = 100.0;

			ox = 0.0;
			oy = y0;
			olen = x0;
			var itmp:FLARDoublePoint2d=new FLARDoublePoint2d();
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = x0 - itmp.x;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = xsize;
			oy = y0;
			olen = xsize - x0;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = itmp.x - x0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = x0;
			oy = 0.0;
			olen = y0;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = y0 - itmp.y;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = x0;
			oy = ysize;
			olen = ysize - y0;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = itmp.y - y0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}


			ox = 0.0;
			oy = 0.0;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = x0 - itmp.x;
			olen = x0;
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}
			ilen = y0 - itmp.y;
			olen = y0;
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = xsize;
			oy = 0.0;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = itmp.x - x0;
			olen = xsize - x0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}
			ilen = y0 - itmp.y;
			olen = y0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = 0.0;
			oy = ysize;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = x0 - itmp.x;
			olen = x0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}
			ilen = itmp.y - y0;
			olen = ysize - y0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}

			ox = xsize;
			oy = ysize;
			this.observ2Ideal_3(ox, oy,itmp);
			ilen = itmp.x - x0;
			olen = xsize - x0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ) sf = sf1;
			}
			ilen = itmp.y - y0;
			olen = ysize - y0;
			//printf("Olen = %f, Ilen = %f, s = %f\n", olen, ilen, ilen / olen);
			if( ilen > 0 ) {
				sf1 = ilen / olen;
				if( sf1 < sf ){
					sf = sf1;
				}
			}

			if( sf == 100.0 ){
				sf = 1.0;
			}

			return sf;
		}

		public function getS():Number
		{
			return this._s;
		}
		/**
		 * この関数は、参照元から歪みパラメータ値をコピーします。
		 * @param i_ref
		 * コピー元のオブジェクト。
		 */
		public function copyFrom(i_ref:IFLARCameraDistortionFactor):void
		{
			var src:FLARCameraDistortionFactorV4=FLARCameraDistortionFactorV4(i_ref);
			this._k1=src._k1;
			this._k2=src._k2;
			this._p1=src._p1;
			this._p2=src._p2;
			this._fx=src._fx;
			this._fy=src._fy;
			this._x0=src._x0;
			this._y0=src._y0;
			this._s=src._s;
		}
		/**
		 * @param i_size
		 * @param i_intrinsic_matrix
		 * 3x3 matrix
		 * このパラメータは、OpenCVのcvCalibrateCamera2関数が出力するintrinsic_matrixの値と合致します。
		 * @param i_distortion_coeffs
		 * 4x1 vector
		 * このパラメータは、OpenCVのcvCalibrateCamera2関数が出力するdistortion_coeffsの値と合致します。
		 */
		public function setValue_2(i_size:FLARIntSize,i_intrinsic_matrix:Vector.<Number>,i_distortion_coeffs:Vector.<Number>):void
		{
			this._k1=i_distortion_coeffs[0];
			this._k2=i_distortion_coeffs[1];
			this._p1=i_distortion_coeffs[2];
			this._p2=i_distortion_coeffs[3];
			this._fx=i_intrinsic_matrix[0*3+0];//0,0
			this._fy=i_intrinsic_matrix[1*3+1];//1,1
			this._x0=i_intrinsic_matrix[0*3+2];//0,2
			this._y0=i_intrinsic_matrix[1*3+2];//1,2
			this._s=1.0;
			//update s
			this._s=this.getSizeFactor(this._x0, this._y0, i_size.w,i_size.h);		
		}

		/**
		 * この関数は、配列の値を歪みパラメータ値として、このインスタンスにセットします。
		 * @param i_factor
		 * 歪みパラメータ値を格納した配列。
		 */
		public function setValue(i_factor:Vector.<Number>):void
		{
			this._k1=i_factor[0];
			this._k2=i_factor[1];
			this._p1=i_factor[2];
			this._p2=i_factor[3];
			this._fx=i_factor[4];
			this._fy=i_factor[5];
			this._x0=i_factor[6];
			this._y0=i_factor[7];
			this._s =i_factor[8];
		}
		
		/**
		 * この関数は、パラメータ値を配列へ返します。
		 * o_factorには要素数{@link #NUM_OF_FACTOR}の
		 * @param o_factor
		 * 歪みパラメータ値の出力先配列。
		 */
		public function getValue(o_factor:Vector.<Number>):void
		{
			o_factor[0]=this._k1;
			o_factor[1]=this._k2;
			o_factor[2]=this._p1;
			o_factor[3]=this._p2;
			o_factor[4]=this._fx;
			o_factor[5]=this._fy;
			o_factor[6]=this._x0;
			o_factor[7]=this._y0;
			o_factor[8]=this._s;
		}
		
		/**
		 */
		public function changeScale(i_x_scale:Number,i_y_scale:Number):void
		{
			this._fx = this._fx * i_x_scale;   /*  fx  */
			this._fy = this._fy * i_y_scale;   /*  fy  */
			this._x0 = this._x0 * i_x_scale;   /*  x0  */
			this._y0 = this._y0 * i_y_scale;   /*  y0  */
			return;
		}

		public function ideal2Observ(i_in:FLARDoublePoint2d,o_out:FLARDoublePoint2d):void
		{
			this.ideal2Observ_4(i_in.x,i_in.y,o_out);
		}
		
		public function ideal2Observ_2(i_in:FLARDoublePoint2d,o_out: FLARIntPoint2d):void
		{
			this.ideal2Observ_3(i_in.x,i_in.y,o_out);
		}
		
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 * @param i_in
		 * 変換元の座標
		 * @param o_out
		 * 変換後の座標を受け取るオブジェクト
		 */
		public function ideal2Observ_4(i_x:Number,i_y:Number,o_out:FLARDoublePoint2d):void
		{
			var k1:Number = this._k1;
			var k2:Number = this._k2;
			var p1:Number = this._p1;
			var p2:Number = this._p2;
			var fx:Number = this._fx;
			var fy:Number = this._fy;
			var x0:Number = this._x0;
			var y0:Number = this._y0;
			var s:Number  = this._s;
		  
			var x:Number = (i_x - x0)*s/fx;
			var y:Number = (i_y - y0)*s/fy;
			var l:Number = x*x + y*y;
			o_out.x = (x*(1.0+k1*l+k2*l*l)+2.0*p1*x*y+p2*(l+2.0*x*x))*fx+x0;
			o_out.y = (y*(1.0+k1*l+k2*l*l)+p1*(l+2.0*y*y)+2.0*p2*x*y)*fy+y0;
		}
		

		public function ideal2Observ_3(i_x:Number,i_y:Number,o_out:FLARIntPoint2d):void
		{
			var k1:Number = this._k1;
			var k2:Number = this._k2;
			var p1:Number = this._p1;
			var p2:Number = this._p2;
			var fx:Number = this._fx;
			var fy:Number = this._fy;
			var x0:Number = this._x0;
			var y0:Number = this._y0;
			var s:Number  = this._s;
		  
			var x:Number = (i_x - x0)*s/fx;
			var y:Number = (i_y - y0)*s/fy;
			var l:Number = x*x + y*y;
			o_out.x =int((x*(1.0+k1*l+k2*l*l)+2.0*p1*x*y+p2*(l+2.0*x*x))*fx+x0);
			o_out.y =int((y*(1.0+k1*l+k2*l*l)+p1*(l+2.0*y*y)+2.0*p2*x*y)*fy+y0);
		}
		
		/**
		 * この関数は、複数の座標点を、一括して理想座標系から観察座標系へ変換します。
		 * i_inとo_outには、同じインスタンスを指定できます。
		 * @param i_in
		 * 変換元の座標配列
		 * @param o_out
		 * 変換後の座標を受け取る配列
		 * @param i_size
		 * 変換する座標の個数。
		 * @todo should optimize!
		 */
		public function ideal2ObservBatch(i_in:Vector.<FLARDoublePoint2d>,o_out:Vector.<FLARDoublePoint2d>, i_size:int ):void
		{
			var k1:Number = this._k1;
			var k2:Number = this._k2;
			var p1:Number = this._p1;
			var p2:Number = this._p2;
			var fx:Number = this._fx;
			var fy:Number = this._fy;
			var x0:Number = this._x0;
			var y0:Number = this._y0;
			var s:Number  = this._s;
		  
			for (var i:int = 0; i < i_size; i++) {
				var x:Number = (i_in[i].x - x0)*s/fx;
				var y:Number = (i_in[i].y - y0)*s/fy;
				var l:Number = x*x + y*y;
				o_out[i].x =((x*(1.0+k1*l+k2*l*l)+2.0*p1*x*y+p2*(l+2.0*x*x))*fx+x0);
				o_out[i].y =((y*(1.0+k1*l+k2*l*l)+p1*(l+2.0*y*y)+2.0*p2*x*y)*fy+y0);
			}
			return;
		}

		/**
		 * この関数は、複数の座標点を、一括して理想座標系から観察座標系へ変換します。
		 * i_inとo_outには、同じインスタンスを指定できます。
		 * @param i_in
		 * 変換元の座標配列
		 * @param o_out
		 * 変換後の座標を受け取る配列
		 * @param i_size
		 * 変換する座標の個数。
		 * @todo should optimize!
		 */
		public function ideal2ObservBatch_2(i_in:Vector.<FLARDoublePoint2d>, o_out:Vector.<FLARIntPoint2d>, i_size:int):void
		{
			var k1:Number = this._k1;
			var k2:Number = this._k2;
			var p1:Number = this._p1;
			var p2:Number = this._p2;
			var fx:Number = this._fx;
			var fy:Number = this._fy;
			var x0:Number = this._x0;
			var y0:Number = this._y0;
			var s:Number  = this._s;
		  
			for (var i:int = 0; i < i_size; i++) {
				var x:Number = (i_in[i].x - x0)*s/fx;
				var y:Number = (i_in[i].y - y0)*s/fy;
				var l:Number = x*x + y*y;
				o_out[i].x =(int)((x*(1.0+k1*l+k2*l*l)+2.0*p1*x*y+p2*(l+2.0*x*x))*fx+x0);
				o_out[i].y =(int)((y*(1.0+k1*l+k2*l*l)+p1*(l+2.0*y*y)+2.0*p2*x*y)*fy+y0);
			}
			return;
		}	
		private static const PD_LOOP2:int=4;
		/**
		 * この関数は、座標を観察座標系から理想座標系へ変換します。
		 * @param ix
		 * 変換元の座標
		 * @param iy
		 * 変換元の座標
		 * @param o_point
		 * 変換後の座標を受け取るオブジェクト
		 * @todo should optimize!
		 */
		public function observ2Ideal_3(ix:Number,iy:Number, o_point:FLARDoublePoint2d ):void
		{
			// OpenCV distortion model, with addition of a scale factor so that
			// entire image fits onscreen.

			var k1:Number =this._k1;
			var k2:Number =this._k2;
			var p1:Number =this._p1;
			var p2:Number =this._p2;
			var fx:Number =this._fx;
			var fy:Number =this._fy;
			var x0:Number =this._x0;
			var y0:Number =this._y0;

			var px:Number = (ix - x0)/fx;
			var py:Number = (iy - y0)/fy;

			var x02:Number = px*px;
			var y02:Number = py*py;
		  
			for(var i:int = 1; ; i++ ) {
				if( x02 != 0.0 || y02 != 0.0 ) {
					px = px - ((1.0 + k1*(x02+y02) + k2*(x02+y02)*(x02+y02))*px + 2.0*p1*px*py + p2*(x02 + y02 + 2.0*x02)-((ix - x0)/fx))/(1.0+k1*(3.0*x02+y02)+k2*(5.0*x02*x02+3.0*x02*y02+y02*y02)+2.0*p1*py+6.0*p2*px);
					py = py - ((1.0 + k1*(x02+y02) + k2*(x02+y02)*(x02+y02))*py + p1*(x02 + y02 + 2.0*y02) + 2.0*p2*px*py-((iy - y0)/fy))/(1.0+k1*(x02+3.0*y02)+k2*(x02*x02+3.0*x02*y02+5.0*y02*y02)+6.0*p1*py+2.0*p2*px);
				}
				else {
				  px = 0.0;
				  py = 0.0;
				  break;
				}
				if( i == PD_LOOP2 ) break;
			
				x02 = px*px;
				y02 = py*py;
			}
		  
			o_point.x = px*fx/this._s + x0;
			o_point.y = py*fy/this._s + y0;

			return;		
		}

		public function observ2Ideal_2(i_in:FLARDoublePoint2d,o_point:FLARDoublePoint2d):void
		{
			this.observ2Ideal_3(i_in.x,i_in.y, o_point);
		}

		/**
		 * 座標配列全てに対して、{@link #observ2Ideal(double, double, FLARDoublePoint2d)}を適応します。
		 * @param i_in
		 * @param o_out
		 * @param i_size
		 */
		public function observ2IdealBatch(i_in:Vector.<FLARDoublePoint2d>, o_out:Vector.<FLARDoublePoint2d>,i_size:int):void
		{
			for(var i:int=i_size-1;i>=0;i--){
				this.observ2Ideal_3(i_in[i].x,i_in[i].y,o_out[i]);
			}
			return;
		}


	}
}