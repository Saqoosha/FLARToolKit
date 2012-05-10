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
	import org.libspark.flartoolkit.core.utils.*;
	public class VecLinearCoordinatesOperator
	{
		/**
		 * margeResembleCoordsで使う距離敷居値の値です。
		 * 許容する((距離^2)*2)を指定します。
		 */
		private static const _SQ_DIFF_DOT_TH:int=((10*10) * 2);
		/**
		 * margeResembleCoordsで使う角度敷居値の値です。
		 * Cos(n)の値です。
		 */
		private static const _SQ_ANG_TH:Number=FLARMath.COS_DEG_10;

		//ワーク
		private var _l1:FLARLinear = new FLARLinear();
		private var _l2:FLARLinear = new FLARLinear();
		private var _p:FLARDoublePoint2d = new FLARDoublePoint2d();
		
		/**
		 * 配列の前方に、似たベクトルを集めます。似たベクトルの判定基準は、2線の定義点における直線の法線上での距離の二乗和です。
		 * ベクトルの統合と位置情報の計算には、加重平均を用います。
		 * @param i_vector
		 * 編集するオブジェクトを指定します。
		 */
		public function margeResembleCoords(i_vector:VecLinearCoordinates):void
		{
			var items:Vector.<VecLinearCoordinatePoint>=i_vector.items;
			var l1:FLARLinear  = this._l1;
			var l2:FLARLinear = this._l2;
			var p:FLARDoublePoint2d = this._p;
			var i:int;


			for (i = i_vector.length - 1; i >= 0; i--) {
				var target1:VecLinearCoordinatePoint = items[i];
				if(target1.scalar==0){
					continue;
				}
				var rdx:Number=target1.dx;
				var rdy:Number=target1.dy;
				var rx:Number=target1.x;
				var ry:Number=target1.y;
				l1.setVector_2(target1);
				var s_tmp:Number=target1.scalar;
				target1.dx*=s_tmp;
				target1.dy*=s_tmp;
				target1.x*=s_tmp;
				target1.y*=s_tmp;
				for (var i2:int = i - 1; i2 >= 0; i2--) {
					var target2:VecLinearCoordinatePoint = items[i2];
					if(target2.scalar==0){
						continue;
					}
					if (target2.getVecCos_2(rdx,rdy) >=_SQ_ANG_TH) {
						// それぞれの代表点から法線を引いて、相手の直線との交点を計算する。
						l2.setVector_2(target2);
						l1.normalLineCrossPos(rx, ry,l2, p);
						var wx:Number, wy:Number;
						var l:Number = 0;
						// 交点間の距離の合計を計算。lに2*dist^2を得る。
						wx = (p.x - rx);
						wy = (p.y - ry);
						l += wx * wx + wy * wy;
						l2.normalLineCrossPos(target2.x, target2.y,l2, p);
						wx = (p.x - target2.x);
						wy = (p.y - target2.y);
						l += wx * wx + wy * wy;
						// 距離が一定値以下なら、マージ
						if (l > _SQ_DIFF_DOT_TH) {
							continue;
						}
						// 似たようなベクトル発見したら、後方のアイテムに値を統合。
						s_tmp= target2.scalar;
						target1.x+= target2.x*s_tmp;
						target1.y+= target2.y*s_tmp;
						target1.dx += target2.dx*s_tmp;
						target1.dy += target2.dy*s_tmp;
						target1.scalar += s_tmp;
						//要らない子を無効化しておく。
						target2.scalar=0;
					}
				}
			}
			//前方詰め
			i_vector.removeZeroDistItem();
			//加重平均解除なう(x,y位置のみ)
			for(i=0;i<i_vector.length;i++)
			{
				var ptr:VecLinearCoordinatePoint=items[i];
				var d:Number=1/ptr.scalar;
				ptr.x*=d;
				ptr.y*=d;
				ptr.dx*=d;
				ptr.dy*=d;
			}
		}
	}

}