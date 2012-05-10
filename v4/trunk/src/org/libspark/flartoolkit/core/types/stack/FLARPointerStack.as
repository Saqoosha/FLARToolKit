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
package org.libspark.flartoolkit.core.types.stack 
{
	public class FLARPointerStack
	{
		protected var _items:Vector.<Object>;
		protected var _length:int;
		
		/**
		 * このクラスは実体化できません。
		 * @throws FLARException
		 */
		public function FLARPointerStack()
		{
		}

		/**
		 * スタックのメンバ変数を初期化します。この関数は、このクラスを継承したクラスを公開するときに、コンストラクタから呼び出します。
		 * @param i_length
		 * @throws FLARException
		 */
		protected function initInstance(i_length:int):void
		{
			//領域確保
			this._items = new Vector.<Object>(i_length);
			//使用中個数をリセット
			this._length = 0;
			return;
		}

		/**
		 * スタックに参照を積みます。
		 * @return
		 * 失敗するとnull
		 */
		public function push(i_object:Object):Object
		{
			// 必要に応じてアロケート
			if (this._length >= this._items.length){
				return null;
			}
			// 使用領域を+1して、予約した領域を返す。
			this._items[this._length]=i_object;
			this._length++;
			return i_object;
		}
		/**
		 * スタックに参照を積みます。pushとの違いは、失敗した場合にassertすることです。
		 * @param i_object
		 * @return
		 */
		public function pushAssert(i_object:Object):Object
		{
			// 必要に応じてアロケート
			//FLARUtils.assert(this._length < this._items.length);
			// 使用領域を+1して、予約した領域を返す。
			this._items[this._length]=i_object;
			this._length++;
			return i_object;
		}
		
		/** 
		 * 見かけ上の要素数を1減らして、そのオブジェクトを返します。
		 * @return
		 */
		public function pop():Object
		{
			//assert(this._length>=1);
			this._length--;
			return this._items[this._length];
		}
		/**
		 * 見かけ上の要素数をi_count個減らします。
		 * @param i_count
		 * @return
		 */
		public function pops(i_count:int):void
		{
			//assert(this._length>=i_count);
			this._length-=i_count;
			return;
		}	
		/**
		 * 配列を返します。
		 * 
		 * @return
		 */
		public function getArray():Vector.<Object>
		{
			return this._items;
		}
		public function getItem(i_index:int):Object
		{
			return this._items[i_index];
		}
		/**
		 * 配列の見かけ上の要素数を返却します。
		 * @return
		 */
		public function getLength():int
		{
			return this._length;
		}
		/**
		 * この関数は、配列の最大サイズを返します。
		 * @return
		 */
		public function getArraySize():int
		{
			return this._items.length;
		}
		/**
		 * 指定した要素を削除します。
		 * 削除した要素は前方詰めで詰められます。
		 */
		public function remove(i_index:int):void
		{
			//assert(this._length>i_index && i_index>=0);
			if(i_index!=this._length-1){
				var i:int;
				var len:int=this._length-1;
				var items:Vector.<Object>=this._items;
				for(i=i_index;i<len;i++)
				{
					items[i]=items[i+1];
				}
			}
			this._length--;
		}
		/**
		 * 指定した要素を順序を無視して削除します。
		 * @param i_index
		 */
		public function removeIgnoreOrder(i_index:int):void
		{
			//assert(this._length>i_index && i_index>=0);
			//値の交換
			if(i_index!=this._length-1){
				this._items[i_index]=this._items[this._length-1];
			}
			this._length--;
		}
		/**
		 * 見かけ上の要素数をリセットします。
		 */
		public function clear():void
		{
			this._length = 0;
		}
	}

}