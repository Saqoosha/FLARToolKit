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
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.*;
	/**
	 * 遠近法を用いたPerspectiveパラメータを計算するクラスのテンプレートです。
	 * 任意頂点四角系と矩形から、遠近法の変形パラメータを計算します。
	 * このクラスはリファレンス実装のため、パフォーマンスが良くありません。実際にはFLARPerspectiveParamGenerator_O1を使ってください。
	 */	
	public class FLARPerspectiveParamGenerator 
	{
		protected var _local_x:int ; 
		protected var _local_y:int ; 
		public function FLARPerspectiveParamGenerator( i_local_x:int , i_local_y:int )
		{ 
			this._local_x = i_local_x ;
			this._local_y = i_local_y ;
			return;
		}
		public function getParam( i_size:FLARIntSize , i_vertex:Vector.<FLARIntPoint2d> , o_param:Vector.<Number>):Boolean
		{
			//assert( ! (( i_vertex.length == 4 ) ));
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param);
		}
		public function getParam_2( i_size:FLARIntSize , i_vertex:Vector.<FLARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_3( i_width:int , i_height:int , i_vertex:Vector.<FLARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_4( i_width:int , i_height:int , i_vertex:Vector.<FLARIntPoint2d> , o_param:Vector.<Number> ):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_5( i_dest_w:int , i_dest_h:int , x1:Number , y1:Number , x2:Number , y2:Number , x3:Number , y3:Number , x4:Number , y4:Number , o_param:Vector.<Number>):Boolean
		{
			throw new FLARException("getParam not implemented.");
		}
		
	}


}