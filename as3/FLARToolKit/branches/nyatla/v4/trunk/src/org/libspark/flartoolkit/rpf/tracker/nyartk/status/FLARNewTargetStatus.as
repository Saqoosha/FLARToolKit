package org.libspark.flartoolkit.rpf.tracker.nyartk.status
{

import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
import org.libspark.flartoolkit.core.utils.*;

public class FLARNewTargetStatus extends FLARTargetStatus
{

	public var current_sampleout:LowResolutionLabelingSamplerOut_Item;
	public function FLARNewTargetStatus(i_ref_pool_operator:IFLARManagedObjectPoolOperater)
	{
		super(i_ref_pool_operator);
		this.current_sampleout=null;
	}
	/**
	 * @Override
	 */
	public override function releaseObject():int
	{
		var ret:int=super.releaseObject();
		if(ret==0 && this.current_sampleout!=null)
		{
			this.current_sampleout.releaseObject();
			this.current_sampleout=null;
		}
		return ret;
	}
	/**
	 * 値をセットします。この関数は、処理の成功失敗に関わらず、内容変更を行います。
	 * @param i_src
	 * セットするLowResolutionLabelingSamplerOut.Itemを指定します。関数は、このアイテムの参照カウンタをインクリメントします。
	 * @throws FLARException
	 */
	public function setValue(i_src:LowResolutionLabelingSamplerOut_Item):void
	{
		if(this.current_sampleout!=null){
			this.current_sampleout.releaseObject();
		}
		if(i_src!=null){
			this.current_sampleout=LowResolutionLabelingSamplerOut_Item(i_src.referenceObject());
		}else{
			this.current_sampleout=null;
		}
	}
	
}

}