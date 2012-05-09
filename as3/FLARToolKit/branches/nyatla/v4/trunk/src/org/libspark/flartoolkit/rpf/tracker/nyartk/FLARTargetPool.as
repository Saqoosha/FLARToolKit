package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.status.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;

	public class FLARTargetPool extends FLARManagedObjectPool
	{
		public function FLARTargetPool(i_size:int)
		{
			this.initInstance(i_size);
		}
		protected override function createElement():FLARManagedObject
		{
			return new FLARTarget(this._op_interface);
		}
		/**
		 * 新しいターゲットを生成します。ターゲットのserial,tagのみ初期化します。
		 * @param i_clock
		 * @param i_sample
		 * @return
		 * @throws FLARException
		 */
		public function newNewTarget():FLARTarget
		{
			var t:FLARTarget=FLARTarget(super.newObject());
			if(t==null){
				return null;
			}
			t._serial=FLARTarget.createSerialId();
			t._ref_status=null;
			t.tag=null;
			return t;
		}	
	}
}