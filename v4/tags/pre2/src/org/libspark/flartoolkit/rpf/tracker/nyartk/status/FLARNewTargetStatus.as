/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
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