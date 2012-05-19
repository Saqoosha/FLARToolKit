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
package org.libspark.flartoolkit.rpf.tracker.nyartk 
{
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.FLARCameraDistortionFactor;
	import org.libspark.flartoolkit.core.raster.FLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.squaredetect.FLARContourPickup;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.utils.FLARMath;
	import org.libspark.flartoolkit.rpf.utils.*;
	
	public interface IFLARVectorReader 
	{
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
		function getAreaVector33(ix:int,iy:int,iw:int,ih:int,o_posvec:FLARVecLinear2d):int;
		function getAreaVector22(ix:int,iy:int,iw:int,ih:int,o_posvec:FLARVecLinear2d):int;

		function traceConture(i_th:int,i_entry:FLARIntPoint2d,o_coord:VecLinearCoordinates):Boolean;

		/**
		 * 点1と点2の間に線分を定義して、その線分上のベクトルを得ます。点は、画像の内側でなければなりません。 320*240の場合、(x>=0 &&
		 * x<320 x+w>0 && x+w<320),(y>0 && y<240 y+h>=0 && y+h<=319)となります。
		 * 
		 * @param i_pos1
		 *            点1の座標です。
		 * @param i_pos2
		 *            点2の座標です。
		 * @param i_area
		 *            ベクトルを検出するカーネルサイズです。1の場合(n*2-1)^2のカーネルになります。 点2の座標です。
		 * @param o_coord
		 *            結果を受け取るオブジェクトです。
		 * @return
		 * @throws FLARException
		 */
		function traceLine(i_pos1:FLARIntPoint2d,i_pos2:FLARIntPoint2d,i_edge:int,o_coord:VecLinearCoordinates):Boolean;

		function traceLine_2(i_pos1:FLARDoublePoint2d,i_pos2:FLARDoublePoint2d,i_edge:int,o_coord:VecLinearCoordinates):Boolean;

		/**
		 * 輪郭線を取得します。
		 * 取得アルゴリズムは、以下の通りです。
		 * 1.輪郭座標(n)の画素周辺の画素ベクトルを取得。
		 * 2.輪郭座標(n+1)周辺の画素ベクトルと比較。
		 * 3.差分が一定以下なら、座標と強度を保存
		 * 4.3点以上の集合になったら、最小二乗法で直線を計算。
		 * 5.直線の加重値を個々の画素ベクトルの和として返却。
		 */
		function traceConture_2(i_coord:FLARIntCoordinates,i_pos_mag:int,i_cell_size:int,o_coord:VecLinearCoordinates):Boolean;
		/**
		 * クリッピング付きのライントレーサです。
		 * 
		 * @param i_pos1
		 * @param i_pos2
		 * @param i_edge
		 * @param o_coord
		 * @return
		 * @throws FLARException
		 */
		function traceLineWithClip(i_pos1:FLARDoublePoint2d,i_pos2:FLARDoublePoint2d,i_edge:int,o_coord:VecLinearCoordinates):Boolean;
		
	}
	
}