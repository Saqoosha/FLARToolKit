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
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.labeling.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.*;
	import jp.nyatla.as3utils.*;
	
	public class FLARContourPickup
	{

		/** 最後に処理したラスタ*/
		private var _ref_last_input_raster:IFLARRaster=null;
		private var _imdriver:FLARContourPickup_IRasterDriver;
		
		/**
		 * この関数は、ラスタの指定点を基点に、輪郭線を抽出します。
		 * 開始点は、輪郭の一部である必要があります。
		 * 通常は、ラべリングの結果の上辺クリップとX軸エントリポイントを開始点として入力します。
		 * @param i_raster
		 * 輪郭線を抽出するラスタを指定します。
		 * @param i_th
		 * 輪郭とみなす暗点の敷居値を指定します。
		 * @param i_entry_x
		 * 輪郭抽出の開始点です。
		 * @param i_entry_y
		 * 輪郭抽出の開始点です。
		 * @param o_coord
		 * 輪郭点を格納する配列を指定します。i_array_sizeよりも大きなサイズの配列が必要です。
		 * @return
		 * 輪郭の抽出に成功するとtrueを返します。輪郭抽出に十分なバッファが無いと、falseになります。
		 * @throws FLARException
		 */
		public function getContour(i_raster:IFLARGrayscaleRaster,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:FLARIntCoordinates):Boolean
		{
			var s:FLARIntSize=i_raster.getSize();
			//ラスタドライバの切り替え
			if(i_raster!=this._ref_last_input_raster){
				this._imdriver=FLARContourPickup_IRasterDriver(i_raster.createInterface(FLARContourPickup_IRasterDriver));
				this._ref_last_input_raster=i_raster;
			}
			return this._imdriver.getContour(0,0,s.w-1,s.h-1,i_entry_x,i_entry_y,i_th,o_coord);
		}
		/**
		 * この関数は、ラスタの指定点を基点に、画像の特定の範囲内から輪郭線を抽出します。
		 * 開始点は、輪郭の一部である必要があります。
		 * 通常は、ラべリングの結果の上辺クリップとX軸エントリポイントを開始点として入力します。
		 * @param i_raster
		 * 輪郭線を抽出するラスタを指定します。
		 * @param i_area
		 * 輪郭線の抽出範囲を指定する矩形。i_rasterのサイズ内である必要があります。
		 * @param i_th
		 * 輪郭とみなす暗点の敷居値を指定します。
		 * @param i_entry_x
		 * 輪郭抽出の開始点です。
		 * @param i_entry_y
		 * 輪郭抽出の開始点です。
		 * @param o_coord
		 * 輪郭点を格納するオブジェクトを指定します。
		 * @return
		 * 輪郭線がo_coordの長さを超えた場合、falseを返します。
		 * @throws FLARException
		 */
		public function getContour_2(i_raster:IFLARGrayscaleRaster,i_area:FLARIntRect,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:FLARIntCoordinates):Boolean
		{
			//ラスタドライバの切り替え
			if(i_raster!=this._ref_last_input_raster){
				this._imdriver=FLARContourPickup_IRasterDriver(i_raster.createInterface(FLARContourPickup_IRasterDriver));
				this._ref_last_input_raster=i_raster;
			}		
			return this._imdriver.getContour(i_area.x,i_area.y,i_area.x+i_area.w-1,i_area.h+i_area.y-1,i_entry_x,i_entry_y,i_th,o_coord);
		}
	}
}
