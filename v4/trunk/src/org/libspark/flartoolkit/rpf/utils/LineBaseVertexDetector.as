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
package org.libspark.flartoolkit.rpf.utils 
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.rpf.utils.*;
	/**
	 * このクラスは、直線式の集合から頂点集合を計算する関数を提供します。
	 */
	public class LineBaseVertexDetector
	{
		/**
		 * 頂点パターンテーブル
		 * 頂点用の、存在しないIDに対応した、調査テーブル。4頂点の時も使う。
		 */
		private static const _45vertextable:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			Vector.<int>([1,2,4,3]),Vector.<int>([0,2,5,3]),Vector.<int>([0,1,5,4]),Vector.<int>([0,1,5,4]),Vector.<int>([0,2,5,3]),Vector.<int>([1,2,4,3])]);
		/**
		 * 頂点パターンテーブル(6用)
		 */
		private static const _order_table:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			Vector.<int>([0,1,5,4]),Vector.<int>([0,2,5,3]),Vector.<int>([1,2,4,3])]);

		private var __tmp_v:Vector.<FLARDoublePoint2d> = FLARDoublePoint2d.createArray(6);
		/**
		 * 適当に与えられた4線分から、四角形の頂点を計算する。
		 * @param i_line
		 * 4線分を格納した配列
		 * @param o_point
		 * 検出した4頂点
		 * @return
		 * 四角形を検出したらtrue
		 * @throws FLARException
		 */
		public function line2SquareVertex(i_line:Vector.<VecLinearCoordinatePoint>,o_point:Vector.<FLARDoublePoint2d>):Boolean
		{
			var v:Vector.<FLARDoublePoint2d>=this.__tmp_v;
			var number_of_vertex:int=0;
			var non_vertexid:int=0;
			var ptr:int = 0;
			var i:int, i2:int;
			for(i=0;i<3;i++){
				for(i2=i+1;i2<4;i2++){
					if(i_line[i].crossPos(i_line[i2],v[ptr])){
						number_of_vertex++;
					}else{
						non_vertexid=ptr;
					}
					ptr++;
				}
			}
			var num_of_plus:int=-1;
			var target_order:Vector.<int>;
			switch(number_of_vertex){
			case 4:
			case 5:
				//正の外積の数を得る。0,4ならば、目的の図形
				num_of_plus=countPlusExteriorProduct(v,_45vertextable[non_vertexid]);
				target_order=_45vertextable[non_vertexid];
				break;
			case 6:
				//(0-5),(1-4),(2-3)の頂点ペアの組合せを試す。頂点の検索順は、(0,1,5,4),(0,2,5,3),(1,2,4,3)
				//3パターンについて、正の外積の数を得る。0,4のものがあればOK
				var order_id:int=-1;
				num_of_plus=-1;
				for(i=0;i<3;i++){
					num_of_plus=countPlusExteriorProduct(v,_order_table[i]);
					if(num_of_plus%4==0){
						order_id=i;
						break;
					}
				}
				if(order_id==-1){
					return false;
				}
				target_order=_order_table[order_id];
				break;
			default:
				//他の頂点数の時はNG
				return false;
			}
			//回転方向の正規化(ここパラメータ化しようよ)
			switch(num_of_plus){
			case  0:
				//逆回転で検出した場合
				for(i=0;i<4;i++){
					o_point[i].setValue(v[target_order[3-i]]);
				}
				break;
			case  4:
				//正回転で検出した場合
				for(i=0;i<4;i++){
					o_point[i].setValue(v[target_order[i]]);
				}
				break;
			default:
				return false;
			}
			return true;
		}

		/**
		 * 4頂点を巡回して、正の外積の個数を数える。
		 * @param p
		 * @param order
		 * @return
		 */
		private static function countPlusExteriorProduct(p:Vector.<FLARDoublePoint2d>,order:Vector.<int>):int
		{
			var ret:int=0;
			for(var i:int=0;i<4;i++){
				if(0<FLARDoublePoint2d.crossProduct3Point(p[order[i+0]],p[order[(i+1)%4]],p[order[(i+2)%4]])){
					ret++;
				}
			}
			return ret;
		}
	}

}