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
package org.libspark.flartoolkit.core.transmat.rotmatrix
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.transmat.*;
	/**
	 * 回転行列計算用の、3x3行列
	 *
	 */
	public class FLARRotMatrix extends FLARDoubleMatrix33
	{
		/**
		 * インスタンスを準備します。
		 * 
		 * @param i_param
		 */
		public function FLARRotMatrix(i_matrix:FLARPerspectiveProjectionMatrix)
		{
			this.__initRot_vec1=new FLARRotVectorV2(i_matrix);
			this.__initRot_vec2=new FLARRotVectorV2(i_matrix);
			return;
		}
		private var __initRot_vec1:FLARRotVectorV2;
		private var __initRot_vec2:FLARRotVectorV2;
		/**
		 * FLARTransMatResultの内容からFLARRotMatrixを復元します。
		 * @param i_prev_result
		 */
		public function initRotByPrevResult(i_prev_result:FLARTransMatResult):void
		{

			this.m00=i_prev_result.m00;
			this.m01=i_prev_result.m01;
			this.m02=i_prev_result.m02;

			this.m10=i_prev_result.m10;
			this.m11=i_prev_result.m11;
			this.m12=i_prev_result.m12;

			this.m20=i_prev_result.m20;
			this.m21=i_prev_result.m21;
			this.m22=i_prev_result.m22;
			return;
		}	
		/**
		 * 
		 * @param i_linear
		 * @param i_sqvertex
		 * @throws FLARException
		 */
		public function initRotBySquare(i_linear:Vector.<FLARLinear>, i_sqvertex:Vector.<FLARDoublePoint2d>):void
		{
			var vec1:FLARRotVectorV2=this.__initRot_vec1;
			var vec2:FLARRotVectorV2=this.__initRot_vec2;

			//向かい合った辺から、２本のベクトルを計算
			
			//軸１
			vec1.exteriorProductFromLinear(i_linear[0], i_linear[2]);
			vec1.checkVectorByVertex(i_sqvertex[0], i_sqvertex[1]);

			//軸２
			vec2.exteriorProductFromLinear(i_linear[1], i_linear[3]);
			vec2.checkVectorByVertex(i_sqvertex[3], i_sqvertex[0]);

			//回転の最適化？
			FLARRotVector.checkRotation(vec1,vec2);

			this.m00 =vec1.v1;
			this.m10 =vec1.v2;
			this.m20 =vec1.v3;
			this.m01 =vec2.v1;
			this.m11 =vec2.v2;
			this.m21 =vec2.v3;
			
			//最後の軸を計算
			var w02:Number = vec1.v2 * vec2.v3 - vec1.v3 * vec2.v2;
			var w12:Number = vec1.v3 * vec2.v1 - vec1.v1 * vec2.v3;
			var w22:Number = vec1.v1 * vec2.v2 - vec1.v2 * vec2.v1;
			var w:Number = Math.sqrt(w02 * w02 + w12 * w12 + w22 * w22);
			this.m02 = w02/w;
			this.m12 = w12/w;
			this.m22 = w22/w;
			return;
		}
		public function initRotByAngle(i_angle:FLARDoublePoint3d):void
		{
			this.setZXYAngle(i_angle);
		}
		/**
		 * i_in_pointを変換行列で座標変換する。
		 * @param i_in_point
		 * @param i_out_point
		 */
		public function getPoint3d(i_in_point:FLARDoublePoint3d,i_out_point:FLARDoublePoint3d):void
		{
			var x:Number=i_in_point.x;
			var y:Number=i_in_point.y;
			var z:Number=i_in_point.z;
			i_out_point.x=this.m00 * x + this.m01 * y + this.m02 * z;
			i_out_point.y=this.m10 * x + this.m11 * y + this.m12 * z;
			i_out_point.z=this.m20 * x + this.m21 * y + this.m22 * z;
			return;
		}
		/**
		 * 複数の頂点を一括して変換する
		 * @param i_in_point
		 * @param i_out_point
		 * @param i_number_of_vertex
		 */
		public function getPoint3dBatch(i_in_point:Vector.<FLARDoublePoint3d>,i_out_point:Vector.<FLARDoublePoint3d>,i_number_of_vertex:int):void
		{
			for(var i:int=i_number_of_vertex-1;i>=0;i--){
				var out_ptr:FLARDoublePoint3d =i_out_point[i];
				var in_ptr:FLARDoublePoint3d=i_in_point[i];
				var x:Number=in_ptr.x;
				var y:Number=in_ptr.y;
				var z:Number=in_ptr.z;
				out_ptr.x=this.m00 * x + this.m01 * y + this.m02 * z;
				out_ptr.y=this.m10 * x + this.m11 * y + this.m12 * z;
				out_ptr.z=this.m20 * x + this.m21 * y + this.m22 * z;
			}
			return;
		}
	}

}