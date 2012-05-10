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
package org.libspark.flartoolkit.rpf.sampler.lrlabel 
{
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.core.types.*
	/**
	 * クラス内定義ができない処理系では、LowResolutionLabelingSamplerOutItemで定義してください。
	 *
	 */
	public class LowResolutionLabelingSamplerOut_Item extends FLARManagedObject
	{
		/**
		 * ラべリング対象のエントリポイントです。
		 */
		public var entry_pos:FLARIntPoint2d=new FLARIntPoint2d();
		/**
		 * ラべリング対象の範囲を、トップレベル換算した値です。クリップ情報から計算されます。
		 */
		public var base_area:FLARIntRect =new FLARIntRect();
		/**
		 * ラべリング対象の範囲中心を、トップレベルに換算した値です。クリップ情報から計算されます。
		 */
		public var base_area_center:FLARIntPoint2d=new FLARIntPoint2d();
		/**
		 * エリア矩形の対角距離の2乗値
		 */
		public var base_area_sq_diagonal:int;
		
		public var lebeling_th:int;
		
		public function LowResolutionLabelingSamplerOut_Item(i_pool:IFLARManagedObjectPoolOperater)
		{
			super(i_pool);
		}
	}

}