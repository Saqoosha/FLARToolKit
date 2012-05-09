package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.*;

	public class NyARRectTargetList extends NyARTargetList
	{
		public function NyARRectTargetList(iMaxTarget:int)
		{
			super(iMaxTarget);
		}
		/**
		 * super classの機能に、予測位置からの探索を追加します。
		 */
		public override function getMatchTargetIndex(i_item:LowResolutionLabelingSamplerOut_Item):int
		{
			//1段目:通常の検索
			var ret:int=super.getMatchTargetIndex(i_item);
			if(ret>=0){
				return ret;
			}
			//2段目:予測位置から検索
			var iitem:NyARRectTargetStatus;
			var min_d:int=int.MAX_VALUE;

			//対角範囲の距離が、対角距離の1/2以下で、最も小さいこと。
			for(var i:int=this._length-1;i>=0;i--)
			{
				iitem=(NyARRectTargetStatus)(this._items[i]._ref_status);
				var d:int;
				d=i_item.base_area.sqDiagonalPointDiff(iitem.estimate_rect);	
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