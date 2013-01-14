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
package org.libspark.flartoolkit.markersystem.utils
{
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.types.FLARIntPoint2d;
	import org.libspark.flartoolkit.psarplaycard.*;

	/**
	 * このクラスは、ARプレイカードの検出結果をマッピングします。
	 */
	public class ARPlayCardList extends NyAS3ArrayList
	{
		/**輪郭推定器*/
		private var _pickup:PsARPlayCardPickup;
		private var _id_param:PsARPlayCardPickup_PsArIdParam =new PsARPlayCardPickup_PsArIdParam();
		public function ARPlayCardList()
		{
			this._pickup = new PsARPlayCardPickup();
		}
		public function prepare():void
		{
			//nothing to do
			//sqはtrackingでnull初期化済み
			
		}
		public function update(i_raster:IFLARGrayscaleRaster,i_sq:SquareStack_Item):Boolean
		{
			if(!this._pickup.getARPlayCardId(i_raster.getGsPixelDriver(),i_sq.ob_vertex,this._id_param))
			{
				return false;
			}
			//IDを検出
			var s:int=this._id_param.id;
			for(var i:int=this.size()-1;i>=0;i--){
				var target:ARPlayCardList_Item=ARPlayCardList_Item(this.getItem(i));
				if(target.nyid_range_s>s || s>target.nyid_range_e)
				{
					continue;
				}
				//既に認識済なら無視
				if(target.lost_count==0){
					continue;
				}
				//一致したよー。
				target.id=s;
				target.dir=this._id_param.direction;
				target.sq=i_sq;
				return true;
			}
			return false;
		}
		public function finish():void
		{
			for(var i:int=this.size()-1;i>=0;i--)
			{
				var target:ARPlayCardList_Item=ARPlayCardList_Item(this.getItem(i));
				if(target.sq==null){
					continue;
				}
				if(target.lost_count>0){
					//参照はそのままで、dirだけ調整する。
					target.lost_count=0;
					target.life++;
					target.sq.rotateVertexL(4-target.dir);
					FLARIntPoint2d.shiftCopy_2(target.sq.ob_vertex,target.tl_vertex,4-target.dir);
					target.tl_center.setValue(target.sq.center2d);
					target.tl_rect_area=target.sq.rect_area;
				}
			}
		}	
	}
}