package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.*;
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;

	public class NyARTargetPool extends NyARManagedObjectPool
	{
		public function NyARTargetPool(i_size:int)
		{
			this.initInstance(i_size);
		}
		protected override function createElement():NyARManagedObject
		{
			return new NyARTarget(this._op_interface);
		}
		/**
		 * 新しいターゲットを生成します。ターゲットのserial,tagのみ初期化します。
		 * @param i_clock
		 * @param i_sample
		 * @return
		 * @throws NyARException
		 */
		public function newNewTarget():NyARTarget
		{
			var t:NyARTarget=NyARTarget(super.newObject());
			if(t==null){
				return null;
			}
			t._serial=NyARTarget.createSerialId();
			t._ref_status=null;
			t.tag=null;
			return t;
		}	
	}
}