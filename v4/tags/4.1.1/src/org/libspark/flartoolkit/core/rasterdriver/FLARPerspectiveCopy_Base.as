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
package org.libspark.flartoolkit.core.rasterdriver 
{
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.utils.*;

	/**
	 * このクラスは、IFLARPerspectiveCopyの基本機能を実装したベースクラスです。
	 * {@link #onePixel(int, int, double[], IFLARRaster)}と{@link #multiPixel(int, int, double[], int, IFLARRaster)}
	 * を実装して、クラスを完成させます。
	 * 
	 */
	public class FLARPerspectiveCopy_Base implements IFLARPerspectiveCopy
	{
		private static const LOCAL_LT:int=1;
		protected var _perspective_gen:FLARPerspectiveParamGenerator;
		protected var __pickFromRaster_cpara:Vector.<Number>=new Vector.<Number>(8);	
		public function FLARPerspectiveCopy_Base()
		{
			this._perspective_gen=new FLARPerspectiveParamGenerator_O1(LOCAL_LT,LOCAL_LT);		
		}
		public function copyPatt_3(i_x1:Number,i_y1:Number,i_x2:Number,i_y2:Number,i_x3:Number,i_y3:Number,i_x4:Number,i_y4:Number,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean
		{
			var out_size:FLARIntSize=i_out.getSize();
			var xe:int=out_size.w*i_edge_x/50;
			var ye:int=out_size.h*i_edge_y/50;

			//サンプリング解像度で分岐
			if(i_resolution==1){
				if (!this._perspective_gen.getParam_5((xe * 2 + out_size.w), (ye * 2 + out_size.h), i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4, this.__pickFromRaster_cpara))
				{
					return false;
				}
				this.onePixel(xe+LOCAL_LT,ye+LOCAL_LT,this.__pickFromRaster_cpara,i_out);
			}else{
				if (!this._perspective_gen.getParam_5((xe*2+out_size.w)*i_resolution,(ye*2+out_size.h)*i_resolution,i_x1,i_y1,i_x2,i_y2,i_x3,i_y3,i_x4,i_y4, this.__pickFromRaster_cpara)) {
					return false;
				}
				this.multiPixel(xe*i_resolution+LOCAL_LT,ye*i_resolution+LOCAL_LT,this.__pickFromRaster_cpara,i_resolution,i_out);
			}
			return true;
		}

		public function copyPatt_2(i_vertex:Vector.<FLARDoublePoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean
		{
			return this.copyPatt_3(i_vertex[0].x,i_vertex[0].y,i_vertex[1].x,i_vertex[1].y,i_vertex[2].x,i_vertex[2].y,i_vertex[3].x,i_vertex[3].y, i_edge_x, i_edge_y, i_resolution, i_out);
		}
		public function copyPatt(i_vertex:Vector.<FLARIntPoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:IFLARRgbRaster):Boolean
		{
			return this.copyPatt_3(i_vertex[0].x,i_vertex[0].y,i_vertex[1].x,i_vertex[1].y,i_vertex[2].x,i_vertex[2].y,i_vertex[3].x,i_vertex[3].y, i_edge_x, i_edge_y, i_resolution, i_out);
		}
		protected function onePixel(pk_l:int, pk_t:int, cpara:Vector.<Number>, o_out:IFLARRaster):Boolean
		{
			throw new FLARException();
		}
		protected function multiPixel(pk_l:int, pk_t:int, cpara:Vector.<Number>, i_resolution:int, o_out:IFLARRaster):Boolean
		{
			throw new FLARException();
		}
	}
}