package org.libspark.flartoolkit.rpf.tracker.nyartk.status
{

	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
	import org.libspark.flartoolkit.rpf.utils.*;

	/**
	 * 輪郭ソース1個を格納するクラスです。
	 *
	 */
	public class FLARContourTargetStatus extends FLARTargetStatus
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
		public function FLARContourTargetStatus(i_ref_pool_operator:IFLARManagedObjectPoolOperater)
		{
			super(i_ref_pool_operator);
		}
		/**
		 * @param i_vecreader
		 * @param i_sample
		 * @return
		 * @throws FLARException
		 */
		public function setValue(i_vecreader:IFLARVectorReader,i_sample:LowResolutionLabelingSamplerOut_Item):Boolean
		{
			return i_vecreader.traceConture(i_sample.lebeling_th, i_sample.entry_pos, this.vecpos);
		}	
	}
}