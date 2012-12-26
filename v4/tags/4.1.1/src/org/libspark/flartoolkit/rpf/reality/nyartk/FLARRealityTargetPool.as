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
package org.libspark.flartoolkit.rpf.reality.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.FLARPerspectiveProjectionMatrix;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;

	public class FLARRealityTargetPool extends FLARManagedObjectPool
	{
		//targetでの共有オブジェクト
		public var _ref_prj_mat:FLARPerspectiveProjectionMatrix;
		/** Target間での共有ワーク変数。*/
		public var _wk_da3_4:Vector.<FLARDoublePoint3d>=FLARDoublePoint3d.createArray(4);
		public var _wk_da2_4:Vector.<FLARDoublePoint2d>=FLARDoublePoint2d.createArray(4);
		
		public function FLARRealityTargetPool(i_size:int, i_ref_prj_mat:FLARPerspectiveProjectionMatrix)
		{
			this.initInstance(i_size);
			this._ref_prj_mat=i_ref_prj_mat;
			return;
		}
		protected override function createElement():FLARManagedObject
		{
			return new FLARRealityTarget(this);
		}
		/**
		 * 新しいRealityTargetを作って返します。
		 * @param tt
		 * @return
		 * @throws FLARException 
		 */
		public function newNewTarget(tt:FLARTarget):FLARRealityTarget
		{
			var ret:FLARRealityTarget=FLARRealityTarget(super.newObject());
			if(ret==null){
				return null;
			}
			ret.grab_rate=50;//開始時の捕捉レートは10%
			ret._ref_tracktarget=(FLARTarget)(tt.referenceObject());
			ret._serial=FLARRealityTarget.createSerialId();
			ret.tag=null;
			tt.tag=ret;//トラックターゲットのタグに自分の値設定しておく。
			return ret;
		}	
	}
}