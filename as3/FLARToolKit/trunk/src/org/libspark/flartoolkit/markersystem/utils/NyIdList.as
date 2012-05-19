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
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.nyidmarker.*;
	import org.libspark.flartoolkit.nyidmarker.data.*;

	/**
	 * このクラスは、NyIdの検出結果をマッピングします。
	 */
	public class NyIdList extends NyAS3ArrayList
	{
		/**輪郭推定器*/
		private var _id_pickup:NyIdMarkerPickup;
		private var _id_patt:NyIdMarkerPattern=new NyIdMarkerPattern();
		private var _id_param:NyIdMarkerParam=new NyIdMarkerParam();
		private var _id_encoder:NyIdMarkerDataEncoder_RawBitId=new NyIdMarkerDataEncoder_RawBitId();
		private var _id_data:NyIdMarkerData_RawBitId=new NyIdMarkerData_RawBitId();
		public function NyIdList()
		{
			this._id_pickup = new NyIdMarkerPickup();
		}
		public function prepare():void
		{
			for(var i:int=this.size()-1;i>=0;i--){
				var target:MarkerInfoNyId=MarkerInfoNyId(this.getItem(i));//get(i);
				if(target.life>0){
					target.lost_count++;
				}
				target.sq=null;
			}
		}
		public function update(i_raster:IFLARGrayscaleRaster,i_sq:SquareStack_Item):Boolean
		{
			if(!this._id_pickup.pickFromRaster_2(i_raster.getGsPixelDriver(),i_sq.ob_vertex, this._id_patt, this._id_param))
			{
				return false;
			}
			if(!this._id_encoder.encode(this._id_patt,this._id_data)){
				return false;
			}
			//IDを検出
			var s:Number=this._id_data.marker_id;
			for(var i:int=this.size()-1;i>=0;i--){
				var target:MarkerInfoNyId=MarkerInfoNyId(this.getItem(i));
				if(target.nyid_range_s>s || s>target.nyid_range_e)
				{
					continue;
				}
				//既に認識済なら無視
				if(target.lost_count==0){
					continue;
				}
				//一致したよー。
				target.nyid=s;
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
				var target:MarkerInfoNyId=MarkerInfoNyId(this.getItem(i));
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