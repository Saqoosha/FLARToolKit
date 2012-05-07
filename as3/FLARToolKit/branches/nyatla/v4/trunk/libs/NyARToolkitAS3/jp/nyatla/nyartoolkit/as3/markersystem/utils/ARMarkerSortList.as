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
package jp.nyatla.nyartoolkit.as3.markersystem.utils
{

	import jp.nyatla.nyartoolkit.as3.core.utils.*;

	/**
	 * このクラスは、ARマーカの検出結果をマッピングするためのリストです。
	 */
	public class ARMarkerSortList extends NyARLinkList
	{
		/**
		 * 指定個数のリンクリストを生成。
		 * @param i_num_of_item
		 */
		public function ARMarkerSortList()
		{
			super(1);
		}
		protected override function createElement():NyARLinkList_Item
		{
			return new ARMarkerSortList_Item();
		}
		/**
		 * 挿入ポイントを返す。挿入ポイントは、i_sd_point(距離点数)が
		 * 登録済のポイントより小さい場合のみ返却する。
		 * @return
		 */
		public function getInsertPoint(i_cf:Number):ARMarkerSortList_Item
		{
			var ptr:ARMarkerSortList_Item=ARMarkerSortList_Item(_head_item);
			//先頭の場合
			if(ptr.cf<i_cf){
				return ptr;
			}
			//それ以降
			ptr=ARMarkerSortList_Item(ptr.next);
			for(var i:int=this._num_of_item-2;i>=0;i--)
			{
				if(ptr.cf<i_cf){
					return ptr;
				}
				ptr=ARMarkerSortList_Item(ptr.next);
			}
			//対象外。
			return null;		
		}		
		public function reset():void
		{
			var ptr:ARMarkerSortList_Item=ARMarkerSortList_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{
				ptr.cf=0;
				ptr.marker=null;
				ptr.ref_sq=null;
				ptr=ARMarkerSortList_Item(ptr.next);
			}
			
		}
		/**
		 * リストから最も高い一致率のアイテムを取得する。
		 */
		public function getTopItem():ARMarkerSortList_Item
		{
			var ptr:ARMarkerSortList_Item=ARMarkerSortList_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{
				if(ptr.marker==null){
					ptr=ARMarkerSortList_Item(ptr.next);
					continue;
				}
				return ptr;
			}
			return null;
		}
		/**
		 * リスト中の、i_itemと同じマーカIDか、同じ矩形情報を参照しているものを無効に(ptr.idを-1)する。
		 */
		public function disableMatchItem(i_item:ARMarkerSortList_Item):void
		{
			var ptr:ARMarkerSortList_Item=ARMarkerSortList_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{			
				if((ptr.marker==i_item.marker) || (ptr.ref_sq==i_item.ref_sq)){
					ptr.marker=null;
				}
				ptr=ARMarkerSortList_Item(ptr.next);
			}
		}
		public function getLength():int
		{
			return this._num_of_item;
		}
	}
}