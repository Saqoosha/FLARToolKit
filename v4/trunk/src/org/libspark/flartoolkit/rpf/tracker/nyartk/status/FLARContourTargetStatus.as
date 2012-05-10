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