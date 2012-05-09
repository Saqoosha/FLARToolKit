package org.libspark.flartoolkit.rpf.tracker.nyartk.status
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.utils.*;



	/*
	 * 輪郭情報を保管します。
	 * このクラスの要素は、他の要素から参照する可能性があります。
	 */
	public final class FLARContourTargetStatusPool extends FLARManagedObjectPool
	{	
		/**
		 * @param i_size
		 * スタックの最大サイズ
		 * @throws FLARException
		 */
		public function FLARContourTargetStatusPool(i_size:int)
		{
			super.initInstance(i_size);
		}
		/**
		 * @Override
		 */
		protected override function createElement():FLARManagedObject
		{
			return new FLARContourTargetStatus(this._op_interface);
		}
	}
}