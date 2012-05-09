package org.libspark.flartoolkit.rpf.tracker.nyartk.status
	{
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.utils.*;


	public class FLARNewTargetStatusPool extends FLARManagedObjectPool
	{
		/**
		 * コンストラクタです。
		 * @param i_size
		 * poolのサイズ
		 * @throws FLARException
		 */
		public function FLARNewTargetStatusPool(i_size:int)
		{
			super.initInstance(i_size);
		}
		/**
		 * @Override
		 */
		protected override function createElement():FLARManagedObject
		{
			return new FLARNewTargetStatus(this._op_interface);
		}

	}
}