package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
{

	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.utils.*;

	/**
	 * 輪郭ソース1個を格納するクラスです。
	 *
	 */
	public class NyARContourTargetStatus extends NyARTargetStatus
	{
		/**
		 * ベクトル要素を格納する配列です。
		 */
		public var vecpos:VecLinearCoordinates=new VecLinearCoordinates(100);

		
		
		//
		//制御部

		/**
		 * @param i_ref_pool_operator
		 * @param i_shared
		 * 共有ワークオブジェクトを指定します。
		 * 
		 */
		public function NyARContourTargetStatus(i_ref_pool_operator:INyARManagedObjectPoolOperater)
		{
			super(i_ref_pool_operator);
		}
		/**
		 * @param i_vecreader
		 * @param i_sample
		 * @return
		 * @throws NyARException
		 */
		public function setValue(i_vecreader:INyARVectorReader,i_sample:LowResolutionLabelingSamplerOut_Item):Boolean
		{
			return i_vecreader.traceConture(i_sample.lebeling_th, i_sample.entry_pos, this.vecpos);
		}	
	}
}