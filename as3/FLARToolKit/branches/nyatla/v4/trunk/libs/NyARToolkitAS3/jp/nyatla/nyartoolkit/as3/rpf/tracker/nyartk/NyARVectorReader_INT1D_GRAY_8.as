/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.param.NyARCameraDistortionFactor;
	import jp.nyatla.nyartoolkit.as3.core.raster.NyARGrayscaleRaster;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.NyARContourPickup;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.NyARMath;
	import jp.nyatla.nyartoolkit.as3.rpf.utils.*;

	/**
	 * グレイスケールラスタに対する、特殊な画素アクセス手段を提供します。
	 *
	 */
	public class NyARVectorReader_INT1D_GRAY_8 extends NyARVectorReader_Basic
	{
		/**
		 * 
		 * @param i_ref_raster
		 * 基本画像
		 * @param i_ref_raster_distortion
		 * 歪み解除オブジェクト(nullの場合歪み解除を省略)
		 * @param i_ref_rob_raster
		 * エッジ探索用のROB画像
		 * @param 
		 */
		public function NyARVectorReader_INT1D_GRAY_8(i_ref_raster:NyARGrayscaleRaster,i_ref_raster_distortion:NyARCameraDistortionFactor,i_ref_rob_raster:NyARGrayscaleRaster)
		{
			super(i_ref_raster,i_ref_raster_distortion,i_ref_rob_raster, new NyARContourPickup());
			//assert (i_ref_raster.getBufferType() == NyARBufferType.INT1D_GRAY_8);
		}
		/**
		 * RECT範囲内の画素ベクトルの合計値と、ベクトルのエッジ中心を取得します。 320*240の場合、
		 * RECTの範囲は(x>=0 && x<319 x+w>=0 && x+w<319),(y>=0 && y<239 x+w>=0 && x+w<319)となります。
		 * @param ix
		 * ピクセル取得を行う位置を設定します。
		 * @param iy
		 * ピクセル取得を行う位置を設定します。
		 * @param iw
		 * ピクセル取得を行う範囲を設定します。
		 * @param ih
		 * ピクセル取得を行う範囲を設定します。
		 * @param o_posvec
		 * エッジ中心とベクトルを返します。
		 * @return
		 * ベクトルの強度を返します。強度値は、差分値の二乗の合計です。
		 */
		public override function getAreaVector33(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			//assert (ih >= 3 && iw >= 3);
			//assert ((ix >= 0) && (iy >= 0) && (ix + iw) <= this._ref_base_raster.getWidth() && (iy + ih) <= this._ref_base_raster.getHeight());
			var buf:Vector.<int> =(Vector.<int>)(this._ref_base_raster.getBuffer());
			var stride:int =this._ref_base_raster.getWidth();
			// x=(Σ|Vx|*Xn)/n,y=(Σ|Vy|*Yn)/n
			// x=(ΣVx)^2/(ΣVx+ΣVy)^2,y=(ΣVy)^2/(ΣVx+ΣVy)^2
			var sum_x:int, sum_y:int, sum_wx:int, sum_wy:int, sum_vx:int, sum_vy:int;
			sum_x = sum_y = sum_wx = sum_wy = sum_vx = sum_vy = 0;
			var lw:int=iw - 3;
			var vx:int, vy:int;
			for (var i:int = ih - 3; i >= 0; i--) {
				var idx_0:int = stride * (i + 1 + iy) + (iw - 3 + 1 + ix);
				for (var i2:int = lw; i2 >= 0; i2--){
					// 1ビット分のベクトルを計算
					var idx_p1:int = idx_0 + stride;
					var idx_m1:int = idx_0 - stride;
					var b:int = buf[idx_m1 - 1];
					var d:int = buf[idx_m1 + 1];
					var h:int = buf[idx_p1 - 1];
					var f:int = buf[idx_p1 + 1];
					vx = ((buf[idx_0 + 1] - buf[idx_0 - 1]) >> 1)+ ((d - b + f - h) >> 2);
					vy = ((buf[idx_p1] - buf[idx_m1]) >> 1)+ ((f - d + h - b) >> 2);
					idx_0--;

					// 加重はvectorの絶対値
					var wx:int = vx * vx;
					var wy:int = vy * vy;
					sum_wx += wx; //加重値
					sum_wy += wy; //加重値
					sum_vx += wx * vx; //加重*ベクトルの積
					sum_vy += wy * vy; //加重*ベクトルの積
					sum_x += wx * (i2 + 1);//位置
					sum_y += wy * (i + 1); //
				}
			}
			//x,dx,y,dyの計算
			var xx:Number,yy:Number;
			if (sum_wx == 0) {
				xx = ix + (iw >> 1);
				o_posvec.dx = 0;
			} else {
				xx = ix+Number(sum_x) / Number(sum_wx);
				o_posvec.dx = Number(sum_vx) / Number(sum_wx);
			}
			if (sum_wy == 0) {
				yy = iy + (ih >> 1);
				o_posvec.dy = 0;
			} else {
				yy = iy+Number(sum_y) / Number(sum_wy);
				o_posvec.dy = Number(sum_vy) / Number(sum_wy);
			}
			//必要なら歪みを解除
			if(this._factor!=null){
				this._factor.observ2Ideal_2(xx, yy, o_posvec);
			}else{
				o_posvec.x=xx;
				o_posvec.y=yy;
			}
			//加重平均の分母を返却
			return sum_wx+sum_wy;
		}
		public override function getAreaVector22(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			//assert (ih >= 3 && iw >= 3);
			//assert ((ix >= 0) && (iy >= 0) && (ix + iw) <= this._ref_base_raster.getWidth() && (iy + ih) <= this._ref_base_raster.getHeight());
			var buf:Vector.<int> =(Vector.<int>)(this._ref_base_raster.getBuffer());
			var stride:int =this._ref_base_raster.getWidth();
			var sum_x:int, sum_y:int, sum_wx:int, sum_wy:int, sum_vx:int, sum_vy:int;
			sum_x = sum_y = sum_wx = sum_wy = sum_vx = sum_vy = 0;
			var vx:int, vy:int;
			var ll:int=iw-1;
			for (var i:int = 0; i<ih-1; i++) {
				var idx_0:int = stride * (i+iy) + ix+1;
				var a:int=buf[idx_0-1];
				var b:int=buf[idx_0];
				var c:int=buf[idx_0+stride-1];
				var d:int=buf[idx_0+stride];
				for (var i2:int = 0; i2<ll; i2++){
					// 1ビット分のベクトルを計算
					vx=(b-a+d-c)>>2;
					vy=(c-a+d-b)>>2;
					idx_0++;
					a=b;
					c=d;
					b=buf[idx_0];
					d=buf[idx_0+stride];

					// 加重はvectorの絶対値
					var wx:int = vx * vx;
					sum_wx += wx; //加重値
					sum_vx += wx * vx; //加重*ベクトルの積
					sum_x += wx * i2;//位置

					var wy:int = vy * vy;
					sum_wy += wy; //加重値
					sum_vy += wy * vy; //加重*ベクトルの積
					sum_y += wy * i; //
				}
			}
			//x,dx,y,dyの計算
			var xx:Number,yy:Number;
			if (sum_wx == 0) {
				xx = ix + (iw >> 1);
				o_posvec.dx = 0;
			} else {
				xx = ix+Number(sum_x) / Number(sum_wx);
				o_posvec.dx = Number(sum_vx) / Number(sum_wx);
			}
			if (sum_wy == 0) {
				yy = iy + (ih >> 1);
				o_posvec.dy = 0;
			} else {
				yy = iy+Number(sum_y) / Number(sum_wy);
				o_posvec.dy = Number(sum_vy) / Number(sum_wy);
			}
			//必要なら歪みを解除
			if(this._factor!=null){
				this._factor.observ2Ideal_2(xx, yy, o_posvec);
			}else{
				o_posvec.x=xx;
				o_posvec.y=yy;
			}
			//加重平均の分母を返却
			return sum_wx+sum_wy;
		}
	}
}