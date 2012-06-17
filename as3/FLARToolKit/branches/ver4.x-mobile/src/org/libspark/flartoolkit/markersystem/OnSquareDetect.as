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
package org.libspark.flartoolkit.markersystem
{
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.rasterdriver.IFLARPerspectiveCopy;
	import org.libspark.flartoolkit.core.squaredetect.FLARCoord2Linear;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquareContourDetector_CbHandler;
	import org.libspark.flartoolkit.core.types.FLARIntCoordinates;
	import org.libspark.flartoolkit.markersystem.utils.ARMarkerList;
	import org.libspark.flartoolkit.markersystem.utils.NyIdList;
	import org.libspark.flartoolkit.markersystem.utils.SquareStack;
	import org.libspark.flartoolkit.markersystem.utils.SquareStack_Item;
	import org.libspark.flartoolkit.markersystem.utils.TrackingList;
	
	internal class OnSquareDetect implements FLARSquareContourDetector_CbHandler
	{
		private var _ref_tracking_list:TrackingList;
		private var _ref_armk_list:ARMarkerList;
		private var _ref_idmk_list:NyIdList;
		private var _ref_sq_stack:SquareStack;
		public var _ref_input_rfb:IFLARPerspectiveCopy;
		public var _ref_input_gs:IFLARGrayscaleRaster;	
		
		private var _coordline:FLARCoord2Linear;
		
		public function OnSquareDetect(i_config:IFLARMarkerSystemConfig,i_armk_list:ARMarkerList,i_idmk_list:NyIdList,i_tracking_list:TrackingList ,i_ref_sq_stack:SquareStack)
		{
			this._coordline=new FLARCoord2Linear(i_config.getFLARParam().getScreenSize(),i_config.getFLARParam().getDistortionFactor());
			this._ref_armk_list=i_armk_list;
			this._ref_idmk_list=i_idmk_list;
			this._ref_tracking_list=i_tracking_list;
			//同時に判定待ちにできる矩形の数
			this._ref_sq_stack=i_ref_sq_stack;
		}
		public function detectMarkerCallback(i_coord:FLARIntCoordinates,i_vertex_index:Vector.<int>):void
		{
			var i2:int;
			//とりあえずSquareスタックを予約
			var sq_tmp:SquareStack_Item=SquareStack_Item(this._ref_sq_stack.prePush());
			//観測座標点の記録
			for(i2=0;i2<4;i2++){
				sq_tmp.ob_vertex[i2].setValue(i_coord.items[i_vertex_index[i2]]);
			}
			//頂点分布を計算
			sq_tmp.vertex_area.setAreaRect_2(sq_tmp.ob_vertex,4);
			//頂点座標の中心を計算
			sq_tmp.center2d.setCenterPos(sq_tmp.ob_vertex,4);
			//矩形面積
			sq_tmp.rect_area=sq_tmp.vertex_area.w*sq_tmp.vertex_area.h;
			
			var is_target_marker:Boolean=false;
			for(;;){
				//トラッキング対象か確認する。
				if(this._ref_tracking_list.update(sq_tmp)){
					//トラッキング対象ならブレーク
					is_target_marker=true;
					break;
				}
				//@todo 複数マーカ時に、トラッキング済のarmarkerを探索対象外に出来ない？
				
				//nyIdマーカの特定(IDマーカの特定はここで完結する。)
				if(this._ref_idmk_list.size()>0){
					if(this._ref_idmk_list.update(this._ref_input_gs,sq_tmp)){
						is_target_marker=true;
						break;//idマーカを特定
					}
				}
				//ARマーカの特定
				if(this._ref_armk_list.size()>0){
					if(this._ref_armk_list.update(this._ref_input_rfb,sq_tmp)){
						is_target_marker=true;
						break;
					}
				}
				break;
			}
			//この矩形が検出対象なら、矩形情報を精密に再計算
			if(is_target_marker){
				//矩形は検出対象にマークされている。
				for(i2=0;i2<4;i2++){
					this._coordline.coord2Line(i_vertex_index[i2],i_vertex_index[(i2+1)%4],i_coord,sq_tmp.line[i2]);
				}
				for (i2 = 0; i2 < 4; i2++) {
					//直線同士の交点計算
					if(!sq_tmp.line[i2].crossPos(sq_tmp.line[(i2 + 3) % 4],sq_tmp.sqvertex[i2])){
						throw new FLARException();//まずない。ありえない。
					}
				}
			}else{
				//この矩形は検出対象にマークされなかったので、解除
				this._ref_sq_stack.pop();
			}
		}
	}
}