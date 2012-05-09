/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.types.stack
{	
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	/**
	 * スタック型の可変長配列。
	 * 配列には実体を格納します。
	 * AS3にはテンプレートが無いので、全てobject型の要素で実装します。
	 */
	public class NyARObjectStack extends NyARPointerStack
	{
		public function NyARObjectStack()
		{
			return;
		}
		/**
		 * パラメータが不要なインスタンスを作るためのinitInstance
		 * コンストラクタから呼び出します。この関数を使うときには、 createElement()をオーバライドしてください。
		 * @param i_length
		 * @param i_element_type
		 * @param i_param
		 * @throws NyARException
		 */
		protected override function initInstance(i_length:int):void
		{
			//領域確保
			super.initInstance(i_length);
			for (var i:int=0; i < i_length; i++){
				this._items[i] =createElement();
			}
			return;
		}
		/**
		 * パラメータが必要なインスタンスを作るためのinitInstance
		 * コンストラクタから呼び出します。この関数を使うときには、 createElement(Object i_param)をオーバライドしてください。
		 * @param i_length
		 * @param i_element_type
		 * @param i_param
		 * @throws NyARException
		 */
		protected function initInstance_2(i_length:int,i_param:Object):void
		{
			//領域確保
			super.initInstance(i_length);
			for (var i:int =0; i < i_length; i++){
				this._items[i] =createElement_2(i_param);
			}
			return;
		}
		protected function createElement():Object
		{
			throw new NyARException();
		}
		protected function createElement_2(i_param:Object):Object
		{
			throw new NyARException();
		}
		
		/**
		 * 新しい領域を予約します。
		 * @return
		 * 失敗するとnull
		 * @throws NyARException
		 */
		public function prePush():Object
		{
			// 必要に応じてアロケート
			if (this._length >= this._items.length){
				return null;
			}
			// 使用領域を+1して、予約した領域を返す。
			var ret:Object = this._items[this._length];
			this._length++;
			return ret;
		}
		/**
		 * このクラスは、オブジェクトをpushすることはできません。
		 * prePush()を使用してください。
		 */
		public override function push(i_object:Object):Object
		{
			return null;
		}
		/**
		 * スタックを初期化します。
		 * @param i_reserv_length
		 * 使用済みにするサイズ
		 * @return
		 */
		public function init(i_reserv_length:int):void
		{
			// 必要に応じてアロケート
			if (i_reserv_length >= this._items.length){
				throw new NyARException();
			}
			this._length=i_reserv_length;
		}	
		/**
		 * 指定した要素を削除します。
		 * 削除した要素は前方詰めで詰められます。
		 */
		public override function remove(i_index:int):void
		{
			if(i_index!=this._length-1){
				var item:Object=this._items[i_index];
				//要素をシフト
				super.remove(i_index);
				//外したオブジェクトを末端に取り付ける
				this._items[i_index]=item;
			}
			this._length--;
		}
		/**
		 * 指定した要素を順序を無視して削除します。
		 * 削除後のスタックの順序は保証されません。
		 * このAPIは、最後尾の有効要素と、削除対象の要素を交換することで、削除を実現します。
		 * @param i_index
		 */
		public override function removeIgnoreOrder(i_index:int):void
		{
			//assert(this._length>i_index && i_index>=0);
			if(i_index!=this._length-1){
				//削除対象のオブジェクトを取り外す
				var item:Object=this._items[i_index];
				//値の交換
				this._items[i_index]=this._items[this._length-1];
				this._items[this._length-1]=item;
			}
			this._length--;
		}
	}
}