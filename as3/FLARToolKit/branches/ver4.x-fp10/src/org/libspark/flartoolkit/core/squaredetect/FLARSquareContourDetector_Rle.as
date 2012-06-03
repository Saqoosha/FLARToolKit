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
package org.libspark.flartoolkit.core.squaredetect 
{
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.labeling.rlelabeling.*;
	import org.libspark.flartoolkit.core.labeling.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.*;
	
	public class FLARSquareContourDetector_Rle extends FLARSquareContourDetector
	{
		private var _labeling:Labeling ; 
		private var _overlap_checker:FLARLabelOverlapChecker = new FLARLabelOverlapChecker(32) ; 
		private var _cpickup:FLARContourPickup = new FLARContourPickup();
		private var _coord2vertex:FLARCoord2SquareVertexIndexes = new FLARCoord2SquareVertexIndexes(); 
		private var _coord:FLARIntCoordinates ; 
		public function FLARSquareContourDetector_Rle( i_size:FLARIntSize )
		{ 
			this.setupImageDriver(i_size);
			//ラベリングのサイズを指定したいときはsetAreaRangeを使ってね。
			this._coord = new FLARIntCoordinates((i_size.w + i_size.h) * 2);
			return;
		}
		/**
		 * 画像処理オブジェクトの切り替え関数。切り替える場合は、この関数を上書きすること。
		 * @param i_size
		 * @throws FLARException
		 */
		protected function setupImageDriver(i_size:FLARIntSize):void
		{
			//特性確認
			//assert(FLARLabeling_Rle._sf_label_array_safe_reference);
			this._labeling=new Labeling(i_size.w,i_size.h);
			this._cpickup=new FLARContourPickup();
		}
		private var __detectMarker_mkvertex:Vector.<int> = new Vector.<int>(4); 
		public function detectMarker_3( i_raster:IFLARGrayscaleRaster , i_area:FLARIntRect , i_th:int,i_cb:FLARSquareContourDetector_CbHandler):void
		{ 
			//assert( ! (( i_area.w * i_area.h > 0 ) ) );
			var flagment:FLARRleLabelFragmentInfoPtrStack = this._labeling.label_stack ;
			var overlap:FLARLabelOverlapChecker = this._overlap_checker ;
			//ラベルの生成エラーならここまで
			if(!this._labeling.labeling_2(i_raster, i_area, i_th)){
				return;
			}
			var label_num:int = flagment.getLength() ;
			if( label_num < 1 ) {
				return  ;
			}
			
			var labels:Vector.<Object> = flagment.getArray() ;
			var coord:FLARIntCoordinates = this._coord ;
			var mkvertex:Vector.<int> = this.__detectMarker_mkvertex ;
			overlap.setMaxLabels(label_num) ;
			for( var i:int = 0 ; i < label_num ; i++ ) {
				var label_pt:FLARRleLabelFragmentInfo = FLARRleLabelFragmentInfo(labels[i]);
				if ( !overlap.check(label_pt) )
				{
					continue ;
				}
				
				if ( !this._cpickup.getContour_2(i_raster, i_area, i_th, label_pt.entry_x, label_pt.clip_t, coord) )
				{
					continue ;
				}
				
				var label_area:int = label_pt.area ;
				if ( !this._coord2vertex.getVertexIndexes(coord, label_area, mkvertex) )
				{
					continue ;
				}
				
				i_cb.detectMarkerCallback(coord , mkvertex) ;
				overlap.push(label_pt) ;
			}
			return  ;
		}
		
		public function detectMarker_2( i_raster:IFLARGrayscaleRaster,i_th:int,i_cb:FLARSquareContourDetector_CbHandler):void
		{ 
			var flagment:FLARRleLabelFragmentInfoPtrStack = this._labeling.label_stack ;
			var overlap:FLARLabelOverlapChecker = this._overlap_checker ;
			flagment.clear() ;
			//ラベルの生成エラーならここまで
			if(!this._labeling.labeling(i_raster, i_th)){
				return;
			}
			var label_num:int = flagment.getLength() ;
			if( label_num < 1 ) {
				return  ;
			}
			
			flagment.sortByArea() ;
			var labels:Vector.<Object> = flagment.getArray() ;
			var coord:FLARIntCoordinates = this._coord ;
			var mkvertex:Vector.<int> = this.__detectMarker_mkvertex ;
			overlap.setMaxLabels(label_num) ;
			for( var i:int = 0 ; i < label_num ; i++ ) {
				var label_pt:FLARRleLabelFragmentInfo = FLARRleLabelFragmentInfo(labels[i]);
				var label_area:int = label_pt.area ;
				if( !overlap.check(label_pt) ) {
					continue ;
				}
				
				if( !this._cpickup.getContour(i_raster,i_th, label_pt.entry_x, label_pt.clip_t, coord) ) {
					continue ;
				}
				
				if( !this._coord2vertex.getVertexIndexes(coord, label_area, mkvertex) ) {
					continue ;
				}
				
				i_cb.detectMarkerCallback(coord , mkvertex) ;
				overlap.push(label_pt) ;
			}
			return  ;
		}
	

	}
}
import org.libspark.flartoolkit.core.labeling.*;
import org.libspark.flartoolkit.core.labeling.rlelabeling.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.types.*;

class Labeling extends FLARLabeling_Rle 
{
	public var label_stack:FLARRleLabelFragmentInfoPtrStack ; 
	private var _right:int ; 
	private var _bottom:int ; 
	public function Labeling( i_width:int , i_height:int )
	{ 
		super( i_width , i_height ) ;
		this.label_stack = new FLARRleLabelFragmentInfoPtrStack( i_width * i_height * 2048 / ( 320 * 240 ) + 32 ) ;
		this._bottom = i_height - 1 ;
		this._right = i_width - 1 ;
		return  ;
	}
	public override function labeling_2(i_raster:IFLARGrayscaleRaster , i_area:FLARIntRect , i_th:int ):Boolean
	{ 
		this.label_stack.clear() ;
		var ret:Boolean=super.labeling_2(i_raster , i_area , i_th) ;
		this.label_stack.sortByArea() ;
		return ret;
	}
	
	public override function labeling(i_raster:IFLARGrayscaleRaster,i_th:int):Boolean
	{ 
		this.label_stack.clear() ;
		var ret:Boolean=super.labeling(i_raster,i_th) ;
		this.label_stack.sortByArea() ;
		return ret;
	}
	
	protected override function onLabelFound( i_label:FLARRleLabelFragmentInfo ):void
	{ 
		if( i_label.clip_l == 0 || i_label.clip_r == this._right ) {
			return  ;
		}
		
		if( i_label.clip_t == 0 || i_label.clip_b == this._bottom ) {
			return  ;
		}
		this.label_stack.push(i_label) ;
	}
	
}


