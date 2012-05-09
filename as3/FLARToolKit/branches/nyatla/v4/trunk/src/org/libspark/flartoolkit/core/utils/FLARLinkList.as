/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.utils
{
	import jp.nyatla.nyartoolkit.as3.core.*;



	/**
	 * このクラスは、可変長のリンクリストです。
	 */
	public class NyARLinkList
	{

		/**
		 * この関数は、クラスが新しい要素を要求するときに呼び出されます。
		 * 要素のインスタンスを返す関数を実装します。
		 * @return
		 * new T()を実装してください。
		 */
		protected function createElement():NyARLinkList_Item
		{
			throw new NyARException("abstract method!");
		}
		/**
		 * リンクリストの要素数の合計です。
		 */
		protected var _num_of_item:int;
		protected var _head_item:NyARLinkList_Item;
		/**
		 * i_num_of_item以上の要素を予約する。
		 * @param i_num_of_item
		 */
		public function reserv(i_num_of_item:int):void
		{
			if(this._num_of_item<i_num_of_item){
				this._head_item=this.createElement();
				var ptr:NyARLinkList_Item=this._head_item;
				for(var i:int=1;i<i_num_of_item;i++){
					var n:NyARLinkList_Item=this.createElement();
					ptr.next=n;
					n.prev=ptr;
					ptr=n;
				}
				ptr.next=this._head_item;
				this._head_item.prev=ptr;
				this._num_of_item=i_num_of_item;
			}
		}
		/**
		 * リストを1拡張する。
		 * @param i_num_of_item
		 */
		public function append():void
		{
			var new_element:NyARLinkList_Item=this.createElement();
			var tail:NyARLinkList_Item=NyARLinkList_Item(this._head_item.prev);
			tail.next=new_element;
			new_element.next=this._head_item;
			new_element.prev=tail;
			this._head_item.prev=new_element;
			this._num_of_item++;
			
		}
		/**
		 * 初期値を指定してリンクリストを生成する。
		 * @param i_num_of_item
		 * 要素数の初期値。
		 */
		public function NyARLinkList(i_num_of_item:int)
		{
			this._num_of_item=0;
			reserv(1);
		}

		/**
		 * 最後尾のリストを削除して、リストのi_itemの直前に要素を追加する。
		 * @param i_id
		 * @param i_cf
		 * @param i_dir
		 * @return
		 * 追加した要素
		 */
		public function insertFromTailBefore(i_item:NyARLinkList_Item):NyARLinkList_Item
		{
			var ptr:NyARLinkList_Item=this._head_item;
			//先頭の場合
			if(ptr==i_item){
				//リストを後方にシフトする。
				ptr=ptr.prev;
				this._head_item=ptr;
				return this._head_item;
			}
			//最後尾なら、そのまま返す
			if(i_item==this._head_item.prev){
				return i_item;
			}
			//最後尾切り離し
			var n:NyARLinkList_Item=NyARLinkList_Item(this._head_item.prev);
			n.prev.next=this._head_item;
			this._head_item.prev=n.prev;
			
			n.next=i_item;
			n.prev=i_item.prev;
			i_item.prev=n;
			n.prev.next=n;
			return n;
		}
	}
}