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
	 * このクラスは、近距離頂点トラッキングのマッピングをすうリストです。
	 *
	 */
	public class VertexSortTable extends NyARLinkList
	{
		public function VertexSortTable(iNumOfItem:int)
		{
			super(iNumOfItem);
		}
//		protected function createElement():VertexSortTable_Item
		protected override function createElement():NyARLinkList_Item
		{
			return new VertexSortTable_Item();
		}
		public function reset():void
		{
			var ptr:VertexSortTable_Item=VertexSortTable_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{
				ptr.sq_dist=int.MAX_VALUE;
				ptr=VertexSortTable_Item(ptr.next);
			}
		}
		/**
		 * 挿入ポイントを返す。挿入ポイントは、i_sd_point(距離点数)が
		 * 登録済のポイントより小さい場合のみ返却する。
		 * @return
		 */
		public function getInsertPoint(i_sd_point:int):VertexSortTable_Item
		{
			var ptr:VertexSortTable_Item=VertexSortTable_Item(_head_item);
			//先頭の場合
			if(ptr.sq_dist>i_sd_point){
				return ptr;
			}
			//それ以降
			ptr=VertexSortTable_Item(ptr.next);
			for(var i:int=this._num_of_item-2;i>=0;i--)
			{
				if(ptr.sq_dist>i_sd_point){
					return ptr;
				}
				ptr=VertexSortTable_Item(ptr.next);
			}
			//対象外。
			return null;		
		}
		/**
		 * 指定したターゲットと同じマーカと同じ矩形候補を参照している
		 * @param i_topitem
		 */
		public function disableMatchItem(i_topitem:VertexSortTable_Item):void
		{
			var ptr:VertexSortTable_Item=VertexSortTable_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{
				if(ptr.marker!=null){
					if(ptr.marker==i_topitem.marker || ptr.marker.sq==i_topitem.ref_sq){
						ptr.marker=null;
					}
				}
				ptr=VertexSortTable_Item(ptr.next);
			}	
		}
		public function getTopItem():VertexSortTable_Item
		{
			var ptr:VertexSortTable_Item=VertexSortTable_Item(this._head_item);
			for(var i:int=this._num_of_item-1;i>=0;i--)
			{
				if(ptr.marker==null){
					ptr=VertexSortTable_Item(ptr.next);
					continue;
				}
				return ptr;
			}
			return null;
		}
	}
}