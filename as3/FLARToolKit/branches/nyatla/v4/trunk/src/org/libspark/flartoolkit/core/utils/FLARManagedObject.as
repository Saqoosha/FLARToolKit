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
package org.libspark.flartoolkit.core.utils 
{
	/**
	 * FLARManagedObjectPoolの要素クラスです。
	 *
	 */
	public class FLARManagedObject
	{
		/**
		 * オブジェクトの参照カウンタ
		 */
		private var _count:int;
		/**
		 * オブジェクトの解放関数へのポインタ
		 */
		private var _pool_operater:IFLARManagedObjectPoolOperater;
		/**
		 * FLARManagedObjectPoolのcreateElement関数が呼び出すコンストラクタです。
		 * @param i_ref_pool_operator
		 * Pool操作の為のインタフェイス
		 */
		public function FLARManagedObject(i_ref_pool_operator:IFLARManagedObjectPoolOperater)
		{
			this._count=0;
			this._pool_operater=i_ref_pool_operator;
		}
		public function initObject():FLARManagedObject
		{
			//assert(this._count==0);
			this._count=1;
			return this;
		}
		/**
		 * このオブジェクトに対する、新しい参照オブジェクトを返します。
		 * @return
		 */
		public function referenceObject():FLARManagedObject
		{
			//assert(this._count>0);
			this._count++;
			return this;
		}
		/**
		 * 参照オブジェクトを開放します。
		 * @return
		 */
		public function releaseObject():int
		{
			//assert(this._count>0);
			this._count--;
			if(this._count==0){
				this._pool_operater.deleteObject(this);
			}
			return this._count;
		}
		/**
		 * 現在の参照カウンタを返します。
		 * @return
		 */
		public function getCount():int
		{
			return this._count;
		}
	}
}