package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;

	public class NyARTargetList extends NyARPointerStack
	{
		public function NyARTargetList(i_max_target:int)
		{
			super.initInstance(i_max_target);
		}
		/**
		 * Sampleの位置キーに一致する可能性の高い要素のインデクスを１つ返します。
		 * @param i_item
		 * @return
		 * 一致する可能性が高い要素のインデクス番号。見つからないときは-1
		 */
		public function getMatchTargetIndex(i_item:LowResolutionLabelingSamplerOut_Item):int
		{
			var iitem:NyARTarget;

			var ret:int=-1;
			var min_d:int=int.MAX_VALUE;

			//対角範囲の距離が、対角距離の1/2以下で、最も小さいこと。
			for(var i:int=this._length-1;i>=0;i--)
			{
				iitem=NyARTarget(this._items[i]);
				var d:int;
				d=i_item.base_area.sqDiagonalPointDiff(iitem._sample_area);	
				if(d<min_d){
					min_d=d;
					ret=i;
				}
			}
			//許容距離誤差の2乗を計算(対角線の20%以内)
			//(Math.sqrt((i_item.area.w*i_item.area.w+i_item.area.h*i_item.area.h))/5)^2
			if(min_d<(2*(i_item.base_area_sq_diagonal)/25)){
				return ret;
			}
			return -1;
		}
	}
}