package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
{

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.types.NyARDoublePoint2d;
import jp.nyatla.nyartoolkit.as3.core.types.NyARLinear;
import jp.nyatla.nyartoolkit.as3.core.utils.*;
import jp.nyatla.nyartoolkit.as3.rpf.utils.*;


public class NyARRectTargetStatusPool extends NyARManagedObjectPool
{
	/**
	 * 要素間で共有するオブジェクト。この変数は、NyARRectTargetStatus以外から使わないでください。
	 */
	public var _vecpos:VecLinearCoordinates=new VecLinearCoordinates(100);
	public var _line_detect:LineBaseVertexDetector=new LineBaseVertexDetector();
	public var _vecpos_op:VecLinearCoordinatesOperator=new VecLinearCoordinatesOperator(); 
	public var _indexbuf:Vector.<VecLinearCoordinatePoint>=new Vector.<VecLinearCoordinatePoint>(4);
	public var _line:Vector.<NyARLinear>=NyARLinear.createArray(4);
	/**
	 * @param i_size
	 * スタックの最大サイズ
	 * @param i_cood_max
	 * 輪郭ベクトルの最大数
	 * @throws NyARException
	 */
	public function NyARRectTargetStatusPool(i_size:int)
	{
		super.initInstance(i_size);
	}
	protected override function createElement():NyARManagedObject
	{
		return new NyARRectTargetStatus(this);
	}

	private var __sq_table:Vector.<int>=new Vector.<int>(4);
	/**
	 * 頂点セット同士の差分を計算して、極端に大きな誤差を持つ点が無いかを返します。
	 * チェックルールは、頂点セット同士の差のうち一つが、全体の一定割合以上の誤差を持つかです。
	 * @param i_point1
	 * @param i_point2
	 * @return
	 * @todo 展開して最適化
	 */
	public function checkLargeDiff(i_point1:Vector.<NyARDoublePoint2d>,i_point2:Vector.<NyARDoublePoint2d>):Boolean
	{
		//assert(i_point1.length==i_point2.length);
		var sq_tbl:Vector.<int>=this.__sq_table;
		var all:int = 0;
		var i:int;
		for(i=3;i>=0;i--){
			sq_tbl[i]=(int)(i_point1[i].sqDist(i_point2[i]));
			all+=sq_tbl[i];
		}
		//移動距離の2乗の平均値
		if(all<4){
			return true;
		}
		for(i=3;i>=0;i--){
			//1個が全体の75%以上を持っていくのはおかしい。
			if(sq_tbl[i]*100/all>70){
				return false;
			}
		}
		return true;
	}	

}
}