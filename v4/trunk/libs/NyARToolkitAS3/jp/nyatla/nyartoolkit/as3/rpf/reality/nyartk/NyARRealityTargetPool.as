package jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.param.NyARPerspectiveProjectionMatrix;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;

	public class NyARRealityTargetPool extends NyARManagedObjectPool
	{
		//targetでの共有オブジェクト
		public var _ref_prj_mat:NyARPerspectiveProjectionMatrix;
		/** Target間での共有ワーク変数。*/
		public var _wk_da3_4:Vector.<NyARDoublePoint3d>=NyARDoublePoint3d.createArray(4);
		public var _wk_da2_4:Vector.<NyARDoublePoint2d>=NyARDoublePoint2d.createArray(4);
		
		public function NyARRealityTargetPool(i_size:int, i_ref_prj_mat:NyARPerspectiveProjectionMatrix)
		{
			this.initInstance(i_size);
			this._ref_prj_mat=i_ref_prj_mat;
			return;
		}
		protected override function createElement():NyARManagedObject
		{
			return new NyARRealityTarget(this);
		}
		/**
		 * 新しいRealityTargetを作って返します。
		 * @param tt
		 * @return
		 * @throws NyARException 
		 */
		public function newNewTarget(tt:NyARTarget):NyARRealityTarget
		{
			var ret:NyARRealityTarget=NyARRealityTarget(super.newObject());
			if(ret==null){
				return null;
			}
			ret.grab_rate=50;//開始時の捕捉レートは10%
			ret._ref_tracktarget=(NyARTarget)(tt.referenceObject());
			ret._serial=NyARRealityTarget.createSerialId();
			ret.tag=null;
			tt.tag=ret;//トラックターゲットのタグに自分の値設定しておく。
			return ret;
		}	
	}
}