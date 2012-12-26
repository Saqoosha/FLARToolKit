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
	 * ARToolKit Version2の樽型歪みを使った歪み補正クラスです。
	 * <p>アルゴリズム - 
	 * このクラスでは、歪み矯正前の座標を観察座標系、歪み矯正後の座標を理想座標系と呼びます。
	 * パラメータと理論については、以下の資料、11pageを参照してください。
	 * http://www.hitl.washington.edu/artoolkit/Papers/ART02-Tutorial.pdf
	 * <pre>
	 * x=x(xi-x0),y=s(yi-y0)
	 * d^2=x^2+y^2
	 * p=(1-fd^2)
	 * xd=px+x0,yd=py+y0
	 * </pre>
	 * </p>
	 */
	public class FLARCameraDistortionFactorV2 implements IFLARCameraDistortionFactor
	{
		public static const NUM_OF_FACTOR:int=4;
		private static const PD_LOOP:int = 3;
		private var _f0:Number;//x0
		private var _f1:Number;//y0
		private var _f2:Number;//100000000.0*f
		private var _f3:Number;//s
		
		
		/**
		 *  コピー元のオブジェクト。{@link FLARCameraDistortionFactorV2}クラスである必要があります。
		 */
		public function copyFrom(i_ref:IFLARCameraDistortionFactor):void
		{
			var inst:FLARCameraDistortionFactorV2=FLARCameraDistortionFactorV2(i_ref);
			this._f0=inst._f0;
			this._f1=inst._f1;
			this._f2=inst._f2;
			this._f3=inst._f3;
			return;
		}

		/**
		 * 歪みパラメータ値を格納した配列。4要素である必要があります。
		 */
		public function setValue(i_factor:Vector.<Number>):void
		{
			this._f0=i_factor[0];
			this._f1=i_factor[1];
			this._f2=i_factor[2];
			this._f3=i_factor[3];
			return;
		}
		
		/**
		 * 歪みパラメータ値の出力先配列。4要素である必要があります。
		 */
		public function getValue(o_factor:Vector.<Number>):void
		{
			o_factor[0]=this._f0;
			o_factor[1]=this._f1;
			o_factor[2]=this._f2;
			o_factor[3]=this._f3;
			return;
		}
		

		public function changeScale(i_x_scale:Number,i_y_scale:Number):void
		{
			this._f0=this._f0*i_x_scale;//X
			this._f1=this._f1*i_y_scale;//Y
			this._f2=this._f2/ (i_x_scale * i_y_scale);
			return;
		}
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 * @param i_in
		 * 変換元の座標
		 * @param o_out
		 * 変換後の座標を受け取るオブジェクト
		 */
		public function ideal2Observ(i_in:FLARDoublePoint2d,o_out:FLARDoublePoint2d):void
		{
			this.ideal2Observ_4(i_in.x,i_in.y, o_out);
			return;
		}
		
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 */
		public function ideal2Observ_2(i_in:FLARDoublePoint2d,o_out:FLARIntPoint2d):void
		{
			this.ideal2Observ_3(i_in.x,i_in.y,o_out);
			return;
		}
		
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 */
		public function ideal2Observ_4(i_x:Number,i_y:Number,o_out:FLARDoublePoint2d):void
		{
			var x:Number = (i_x - this._f0) * this._f3;
			var y:Number = (i_y - this._f1) * this._f3;
			if (x == 0.0 && y == 0.0) {
				o_out.x = this._f0;
				o_out.y = this._f1;
			} else {
				var d:Number = 1.0 - this._f2 / 100000000.0 * (x * x + y * y);
				o_out.x = x * d + this._f0;
				o_out.y = y * d + this._f1;
			}
			return;
		}	
		
		/**
		 * この関数は、座標点を理想座標系から観察座標系へ変換します。
		 */
		public function ideal2Observ_3(i_x:Number,i_y:Number,o_out:FLARIntPoint2d):void
		{
			var x:Number = (i_x - this._f0) * this._f3;
			var y:Number = (i_y - this._f1) * this._f3;
			if (x == 0.0 && y == 0.0) {
				o_out.x = (int)(this._f0);
				o_out.y = (int)(this._f1);
			} else {
				var d:Number = 1.0 - this._f2 / 100000000.0 * (x * x + y * y);
				o_out.x = (int)(x * d + this._f0);
				o_out.y = (int)(y * d + this._f1);
			}
			return;
		}
		
		/**
		 * この関数は、複数の座標点を、一括して理想座標系から観察座標系へ変換します。
		 * i_inとo_outには、同じインスタンスを指定できます。
		 */
		public function ideal2ObservBatch(i_in:Vector.<FLARDoublePoint2d>, o_out:Vector.<FLARDoublePoint2d>,i_size:int):void
		{
			var x:Number, y:Number;
			var d0:Number = this._f0;
			var d1:Number = this._f1;
			var d3:Number = this._f3;
			var d2_w:Number = this._f2 / 100000000.0;
			for (var i:int = 0; i < i_size; i++) {
				x = (i_in[i].x - d0) * d3;
				y = (i_in[i].y - d1) * d3;
				if (x == 0.0 && y == 0.0) {
					o_out[i].x = d0;
					o_out[i].y = d1;
				} else {
					var d :Number= 1.0 - d2_w * (x * x + y * y);
					o_out[i].x = x * d + d0;
					o_out[i].y = y * d + d1;
				}
			}
			return;
		}

		/**
		 * この関数は、複数の座標点を、一括して理想座標系から観察座標系へ変換します。
		 * i_inとo_outには、同じインスタンスを指定できます。
		 */
		public function ideal2ObservBatch_2(i_in:Vector.<FLARDoublePoint2d>, o_out:Vector.<FLARIntPoint2d>, i_size:int):void
		{
			var x:Number, y:Number;
			var d0:Number = this._f0;
			var d1:Number = this._f1;
			var d3:Number = this._f3;
			var d2_w:Number = this._f2 / 100000000.0;
			for (var i:int = 0; i < i_size; i++) {
				x = (i_in[i].x - d0) * d3;
				y = (i_in[i].y - d1) * d3;
				if (x == 0.0 && y == 0.0) {
					o_out[i].x = int(d0);
					o_out[i].y = int(d1);
				} else {
					var d:Number = 1.0 - d2_w * (x * x + y * y);
					o_out[i].x = int(x * d + d0);
					o_out[i].y = int(y * d + d1);
				}
			}
			return;
		}
		
		/**
		 * この関数は、座標を観察座標系から理想座標系へ変換します。
		 */
		public function observ2Ideal_3(ix:Number , iy:Number, o_point:FLARDoublePoint2d ):void
		{
			var z02:Number, z0:Number, p:Number, q:Number, z:Number, px:Number, py:Number, opttmp_1:Number;
			var d0:Number = this._f0;
			var d1:Number = this._f1;

			px = ix - d0;
			py = iy - d1;
			p = this._f2 / 100000000.0;
			z02 = px * px + py * py;
			q = z0 = Math.sqrt(z02);// Optimize//q = z0 = Math.sqrt(px*px+ py*py);
			for (var i:int = 1;; i++) {
				if (z0 != 0.0) {
					// Optimize opttmp_1
					opttmp_1 = p * z02;
					z = z0 - ((1.0 - opttmp_1) * z0 - q) / (1.0 - 3.0 * opttmp_1);
					px = px * z / z0;
					py = py * z / z0;
				} else {
					px = py= 0.0;
					break;
				}
				if (i == PD_LOOP) {
					break;
				}
				z02 = px * px + py * py;
				z0 = Math.sqrt(z02);// Optimize//z0 = Math.sqrt(px*px+ py*py);
			}
			o_point.x = px / this._f3 + d0;
			o_point.y = py / this._f3 + d1;
			return;
		}
		/**
		 * {@link #observ2Ideal(double, double, FLARDoublePoint2d)}のラッパーです。
		 */	
		public function observ2Ideal_2(i_in:FLARDoublePoint2d, o_point:FLARDoublePoint2d ):void
		{
			this.observ2Ideal_3(i_in.x,i_in.y,o_point);
		}
		/**
		 * 座標配列全てに対して、{@link #observ2Ideal(double, double, FLARDoublePoint2d)}を適応します。
		 */
		public function observ2IdealBatch(i_in:Vector.<FLARDoublePoint2d>, o_out:Vector.<FLARDoublePoint2d>, i_size:int):void
		{
			for(var i:int=i_size-1;i>=0;i--){
				this.observ2Ideal_3(i_in[i].x,i_in[i].y,o_out[i]);
			}
			return;
		}
	}
}