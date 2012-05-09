package jp.nyatla.nyartoolkit.as3.rpf.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
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
		private static const _SQ_ANG_TH:Number=NyARMath.COS_DEG_10;

		//ワーク
		private var _l1:NyARLinear = new NyARLinear();
		private var _l2:NyARLinear = new NyARLinear();
		private var _p:NyARDoublePoint2d = new NyARDoublePoint2d();
		
		/**
		 * 配列の前方に、似たベクトルを集めます。似たベクトルの判定基準は、2線の定義点における直線の法線上での距離の二乗和です。
		 * ベクトルの統合と位置情報の計算には、加重平均を用います。
		 * @param i_vector
		 * 編集するオブジェクトを指定します。
		 */
		public function margeResembleCoords(i_vector:VecLinearCoordinates):void
		{
			var items:Vector.<VecLinearCoordinatePoint>=i_vector.items;
			var l1:NyARLinear  = this._l1;
			var l2:NyARLinear = this._l2;
			var p:NyARDoublePoint2d = this._p;
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