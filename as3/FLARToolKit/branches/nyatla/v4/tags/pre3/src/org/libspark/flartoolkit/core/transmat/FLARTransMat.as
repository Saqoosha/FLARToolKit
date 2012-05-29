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
package org.libspark.flartoolkit.core.transmat
{
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.transmat.rotmatrix.*;
	import org.libspark.flartoolkit.core.transmat.optimize.*;
	import org.libspark.flartoolkit.core.transmat.solver.*;
	/**
	 * This class calculates ARMatrix from square information and holds it. --
	 * 変換行列を計算して、結果を保持するクラス。
	 * 
	 */
	public class FLARTransMat implements IFLARTransMat
	{	
		private var _ref_projection_mat:FLARPerspectiveProjectionMatrix;
		protected var _rotmatrix:FLARRotMatrix;
		protected var _transsolver:IFLARTransportVectorSolver;
		protected var _mat_optimize:FLARPartialDifferentiationOptimize;


		private var _ref_dist_factor:FLARCameraDistortionFactor;

		/**
		 * この関数は、コンストラクタから呼び出してください。
		 * @param i_distfactor
		 * 歪みの逆矯正に使うオブジェクト。
		 * @param i_projmat
		 * @throws FLARException
		 */
		private function initInstance(i_distfactor:FLARCameraDistortionFactor,i_projmat:FLARPerspectiveProjectionMatrix):void
		{
			this._transsolver=new FLARTransportVectorSolver(i_projmat,4);
			//互換性が重要な時は、FLARRotMatrix_ARToolKitを使うこと。
			//理屈はFLARRotMatrix_FLARToolKitもFLARRotMatrix_ARToolKitも同じだけど、少しだけ値がずれる。
			this._rotmatrix = new FLARRotMatrix(i_projmat);
			this._mat_optimize=new FLARPartialDifferentiationOptimize(i_projmat);
			this._ref_dist_factor=i_distfactor;
			this._ref_projection_mat=i_projmat;
			return;
		}
		public function FLARTransMat(...args:Array)
		{
			switch(args.length){
			case 1:
				{	//FLARTransMat(FLARParam i_param) throws FLARException
					var i_param:FLARParam = FLARParam(args[0]);
					//最適化定数の計算
					this.initInstance(i_param.getDistortionFactor(),i_param.getPerspectiveProjectionMatrix());
					return;
				}
				break;
			case 2:
				{	//FLARTransMat(FLARCameraDistortionFactor i_ref_distfactor,FLARPerspectiveProjectionMatrix i_ref_projmat)
					//最適化定数の計算	
					this.initInstance(FLARCameraDistortionFactor(args[0]),FLARPerspectiveProjectionMatrix(args[1]));
					return;				
				}
				break;
			default:
				break;
			}
			throw new FLARException();
		}		

		private var __transMat_vertex_2d:Vector.<FLARDoublePoint2d> = FLARDoublePoint2d.createArray(4);
		private var __transMat_vertex_3d:Vector.<FLARDoublePoint3d> = FLARDoublePoint3d.createArray(4);
		private var __transMat_trans:FLARDoublePoint3d=new FLARDoublePoint3d();
		
		/**
		 * 頂点情報を元に、エラー閾値を計算します。
		 * @param i_vertex
		 */
		private function makeErrThreshold(i_vertex:Vector.<FLARDoublePoint2d>):Number
		{
			var a:Number,b:Number,l1:Number,l2:Number;
			a=i_vertex[0].x-i_vertex[2].x;
			b=i_vertex[0].y-i_vertex[2].y;
			l1=a*a+b*b;
			a=i_vertex[1].x-i_vertex[3].x;
			b=i_vertex[1].y-i_vertex[3].y;
			l2=a*a+b*b;
			return (Math.sqrt(l1>l2?l1:l2))/200;
		}
		
		/**
		 * double arGetTransMat( ARMarkerInfo *marker_info,double center[2], double width, double conv[3][4] )
		 * 
		 * @param i_square
		 * 計算対象のFLARSquareオブジェクト
		 * @param i_direction
		 * @param i_width
		 * @return
		 * @throws FLARException
		 */
		public function transMat(i_square:FLARSquare,i_offset:FLARRectOffset,o_result:FLARTransMatResult):Boolean
		{
			var trans:FLARDoublePoint3d=this.__transMat_trans;
			var err_threshold:Number=makeErrThreshold(i_square.sqvertex);

			var vertex_2d:Vector.<FLARDoublePoint2d>;
			if(this._ref_dist_factor!=null){
				//歪み復元必要
				vertex_2d=this.__transMat_vertex_2d;
				this._ref_dist_factor.ideal2ObservBatch(i_square.sqvertex, vertex_2d,4);
			}else{
				//歪み復元は不要
				vertex_2d=i_square.sqvertex;
			}
			//平行移動量計算機に、2D座標系をセット
			this._transsolver.set2dVertex(vertex_2d,4);


			//回転行列を計算
			this._rotmatrix.initRotBySquare(i_square.line,i_square.sqvertex);
			//回転後の3D座標系から、平行移動量を計算
			var vertex_3d:Vector.<FLARDoublePoint3d>=this.__transMat_vertex_3d;
			this._rotmatrix.getPoint3dBatch(i_offset.vertex,vertex_3d,4);
			this._transsolver.solveTransportVector(vertex_3d,trans);
			
			//計算結果の最適化(平行移動量と回転行列の最適化)
			this.optimize(this._rotmatrix, trans, this._transsolver,i_offset.vertex, vertex_2d,err_threshold,o_result);
			return true;
		}

		/*
		 * (non-Javadoc)
		 * @see jp.nyatla.nyartoolkit.core.transmat.IFLARTransMat#transMatContinue(jp.nyatla.nyartoolkit.core.FLARSquare, int, double, jp.nyatla.nyartoolkit.core.transmat.FLARTransMatResult)
		 */
		public function transMatContinue(i_square:FLARSquare,i_offset:FLARRectOffset,i_prev_result:FLARTransMatResult,o_result:FLARTransMatResult):Boolean
		{
			var trans:FLARDoublePoint3d=this.__transMat_trans;
			// io_result_convが初期値なら、transMatで計算する。
			if (!i_prev_result.has_value) {
				return this.transMat(i_square,i_offset, o_result);
			}
			//過去のエラーレートを記録(ここれやるのは、i_prev_resultとo_resultに同じインスタンスを指定できるようにするため)
			var last_error:Number=i_prev_result.last_error;
			
			//最適化計算の閾値を決定
			var err_threshold:Number=makeErrThreshold(i_square.sqvertex);

			
			//平行移動量計算機に、2D座標系をセット
			var vertex_2d:Vector.<FLARDoublePoint2d>;
			if(this._ref_dist_factor!=null){
				vertex_2d=this.__transMat_vertex_2d;
				this._ref_dist_factor.ideal2ObservBatch(i_square.sqvertex, vertex_2d,4);		
			}else{
				vertex_2d=i_square.sqvertex;
			}
			this._transsolver.set2dVertex(vertex_2d,4);

			//回転行列を計算
			var rot:FLARRotMatrix=this._rotmatrix;
			rot.initRotByPrevResult(i_prev_result);
			
			//回転後の3D座標系から、平行移動量を計算
			var vertex_3d:Vector.<FLARDoublePoint3d>=this.__transMat_vertex_3d;
			rot.getPoint3dBatch(i_offset.vertex,vertex_3d,4);
			this._transsolver.solveTransportVector(vertex_3d,trans);

			//現在のエラーレートを計算
			var min_err:Number=errRate(this._rotmatrix,trans,i_offset.vertex, vertex_2d,4,vertex_3d);
			//結果をストア
			o_result.setValue_3(rot,trans,min_err);
			//エラーレートの判定
			if(min_err<last_error+err_threshold){
	//			System.out.println("TR:ok");
				//最適化してみる。
				for (var i:int = 0;i<5; i++) {
					//変換行列の最適化
					this._mat_optimize.modifyMatrix(rot, trans, i_offset.vertex, vertex_2d, 4);
					var err:Number=errRate(rot,trans,i_offset.vertex, vertex_2d,4,vertex_3d);
					//System.out.println("E:"+err);
					if(min_err-err<err_threshold/2){
						//System.out.println("BREAK");
						break;
					}
					this._transsolver.solveTransportVector(vertex_3d, trans);				
					o_result.setValue_3(rot,trans,err);
					min_err=err;
				}
			}else{
	//			System.out.println("TR:again");
				//回転行列を計算
				rot.initRotBySquare(i_square.line,i_square.sqvertex);
				
				//回転後の3D座標系から、平行移動量を計算
				rot.getPoint3dBatch(i_offset.vertex,vertex_3d,4);
				this._transsolver.solveTransportVector(vertex_3d,trans);
				
				//計算結果の最適化(平行移動量と回転行列の最適化)
				this.optimize(rot,trans, this._transsolver,i_offset.vertex, vertex_2d,err_threshold,o_result);
			}
			return true;
		}
		private var __rot:FLARDoubleMatrix33=new FLARDoubleMatrix33();
		private function optimize(iw_rotmat:FLARRotMatrix,iw_transvec:FLARDoublePoint3d,i_solver:IFLARTransportVectorSolver,i_offset_3d:Vector.<FLARDoublePoint3d>,i_2d_vertex:Vector.<FLARDoublePoint2d>,i_err_threshold:Number,o_result:FLARTransMatResult):void
		{
			//System.out.println("START");
			var vertex_3d:Vector.<FLARDoublePoint3d>=this.__transMat_vertex_3d;
			//初期のエラー値を計算
			var min_err:Number=errRate(iw_rotmat, iw_transvec, i_offset_3d, i_2d_vertex,4,vertex_3d);
			o_result.setValue_3(iw_rotmat,iw_transvec,min_err);

			for (var i:int = 0;i<5; i++) {
				//変換行列の最適化
				this._mat_optimize.modifyMatrix(iw_rotmat,iw_transvec, i_offset_3d, i_2d_vertex,4);
				var err:Number=errRate(iw_rotmat,iw_transvec, i_offset_3d, i_2d_vertex,4,vertex_3d);
				//System.out.println("E:"+err);
				if(min_err-err<i_err_threshold){
					//System.out.println("BREAK");
					break;
				}
				i_solver.solveTransportVector(vertex_3d,iw_transvec);
				o_result.setValue_3(iw_rotmat,iw_transvec,err);
				min_err=err;
			}
			//System.out.println("END");
			return;
		}
		
		//エラーレート計算機
		public function errRate(i_rot:FLARDoubleMatrix33,i_trans:FLARDoublePoint3d,i_vertex3d:Vector.<FLARDoublePoint3d>,i_vertex2d:Vector.<FLARDoublePoint2d>,i_number_of_vertex:int,o_rot_vertex:Vector.<FLARDoublePoint3d>):Number
		{
			var cp:FLARPerspectiveProjectionMatrix = this._ref_projection_mat;
			var cp00:Number=cp.m00;
			var cp01:Number=cp.m01;
			var cp02:Number=cp.m02;
			var cp11:Number=cp.m11;
			var cp12:Number=cp.m12;

			var err:Number=0;
			for(var i:int=0;i<i_number_of_vertex;i++){
				var x3d:Number,y3d:Number,z3d:Number;
				o_rot_vertex[i].x=x3d=i_rot.m00*i_vertex3d[i].x+i_rot.m01*i_vertex3d[i].y+i_rot.m02*i_vertex3d[i].z;
				o_rot_vertex[i].y=y3d=i_rot.m10*i_vertex3d[i].x+i_rot.m11*i_vertex3d[i].y+i_rot.m12*i_vertex3d[i].z;
				o_rot_vertex[i].z=z3d=i_rot.m20*i_vertex3d[i].x+i_rot.m21*i_vertex3d[i].y+i_rot.m22*i_vertex3d[i].z;
				x3d+=i_trans.x;
				y3d+=i_trans.y;
				z3d+=i_trans.z;
				
				//射影変換
				var x2d:Number=x3d*cp00+y3d*cp01+z3d*cp02;
				var y2d:Number=y3d*cp11+z3d*cp12;
				var h2d:Number=z3d;
				
				//エラーレート計算
				var t1:Number=i_vertex2d[i].x-x2d/h2d;
				var t2:Number=i_vertex2d[i].y-y2d/h2d;
				err+=t1*t1+t2*t2;
				
			}
			return err/i_number_of_vertex;
		}	
	}

}