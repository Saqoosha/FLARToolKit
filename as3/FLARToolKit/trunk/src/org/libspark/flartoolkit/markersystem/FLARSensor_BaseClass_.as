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



	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.types.*;



	/**
	 * このクラスは、{@link FLARMarkerSystem}へ入力するセンサ情報（画像）を管理します。
	 * センサ情報のスナップショットに対するアクセサ、形式変換機能を提供します。
	 * 管理している情報は、元画像（カラー）、グレースケール画像、ヒストグラムです。
	 * このインスタンスは{@link FLARMarkerSystem#update(FLARSensor)}関数により、{@link FLARMarkerSystem}に入力します。
	 */
	public class FLARSensor_BaseClass_
	{
		protected var _gs_hist:FLARHistogram;
		protected var _ref_raster:IFLARRgbRaster;
		protected var _gs_raster:IFLARGrayscaleRaster;
		protected var _src_ts:int;
		protected var _gs_id_ts:int;
		protected var _gs_hist_ts:int;
		/**
		 * 画像サイズ（スクリーンサイズ）を指定して、インスタンスを生成します。
		 * @param i_size
		 * 画像のサイズ。
		 * @throws FLARException
		 */
		public function FLARSensor_BaseClass_(i_size:FLARIntSize)
		{
			this.initInstance(i_size);
			this._hist_drv=IFLARHistogramFromRaster(this._gs_raster.createInterface(IFLARHistogramFromRaster));
		}
		/**
		 * この関数は、画像ドライバに依存するインスタンスを生成する。
		 * 継承クラスで上書きする。
		 * @param s
		 * @throws FLARException
		 */
		protected function initResource(s:FLARIntSize):void
		{
			this._gs_raster=new FLARGrayscaleRaster(s.w,s.h,FLARBufferType.INT1D_GRAY_8);
		}
		/**
		 * 
		 * @param i_size
		 * @throws FLARException
		 */
		private function initInstance(i_size:FLARIntSize):void
		{
			//リソースの生成
			this.initResource(i_size);
			this._gs_hist=new FLARHistogram(256);
			this._src_ts=0;
			this._gs_id_ts=0;
			this._gs_hist_ts=0;
		}
		/**
		 * この関数は、現在のカラー画像の射影変換ドライバを返します。
		 * この関数は、内部処理向けの関数です。
		 * @return
		 * [readonly]
		 * 射影変換ドライバのオブジェクト。
		 */
		public function getPerspectiveCopy():IFLARPerspectiveCopy
		{
			return this._pcopy;
		}	
		private var _hist_drv:IFLARHistogramFromRaster=null;	
		private var _last_input_rasster:IFLARRaster=null;
		private var _pcopy:IFLARPerspectiveCopy;
		private var _rgb2gs:IFLARRgb2GsFilter=null;
		/**
		 * この関数は、入力画像を元に、インスタンスの状態を更新します。
		 * この関数は、タイムスタンプをインクリメントします。
		 * @param i_input
		 * カラー画像。画像のサイズは、コンストラクタに設定したスクリーンサイズと同じである必要があります。
		 * この画像は、次回の{@link #update}まで、インスタンスから参照されます。
		 * @throws FLARException 
		 */
		public function update(i_input:IFLARRgbRaster):void
		{
			//ラスタドライバの準備
			if(this._last_input_rasster!=i_input){
				this._rgb2gs=IFLARRgb2GsFilter(i_input.createInterface(IFLARRgb2GsFilter));
				this._pcopy=IFLARPerspectiveCopy(i_input.createInterface(IFLARPerspectiveCopy));
				this._last_input_rasster=i_input;
			}
			//RGB画像の差し替え
			this._ref_raster=i_input;
			//ソースidのインクリメント
			this._src_ts++;
		}
		/**
		 * この関数は、タイムスタンプを強制的にインクリメントします。
		 */
		public function updateTimeStamp():void
		{
			this._src_ts++;
		}
		/**
		 * この関数は、現在のタイムスタンプを返します。
		 * タイムスタンプは0から始まる整数値で、{@link #update(IFLARRgbRaster)},{@link #updateTimeStamp()}
		 * 関数をコールするごとにインクリメントされます。
		 * @return
		 * タイムスタンプ値
		 */
		public function getTimeStamp():int
		{
			return this._src_ts;
		}
		/**
		 * この関数は、グレースケールに変換した現在の画像を返します。
		 * @return
		 * [readonly]
		 * グレースケールに変換した現在の画像
		 * @throws FLARException 
		 */
		public function getGsImage():IFLARGrayscaleRaster
		{
			//必要に応じてグレースケール画像の生成
			if(this._src_ts!=this._gs_id_ts){
				this._rgb2gs.convert(this._gs_raster);
				this._gs_id_ts=this._src_ts;
			}
			return this._gs_raster;
			//
		}
		/**
		 * この関数は、現在のGS画像のﾋｽﾄｸﾞﾗﾑを返します。
		 * @return
		 * [readonly]
		 * 256スケールのヒストグラム。
		 * @throws FLARException 
		 */
		public function getGsHistogram():FLARHistogram
		{
			//必要に応じてヒストグラムを生成
			if(this._gs_id_ts!=this._gs_hist_ts){
				this._hist_drv.createHistogram_2(4,this._gs_hist);
				this._gs_hist_ts=this._gs_id_ts;
			}
			return this._gs_hist;
		}
		/**
		 * この関数は、現在の入力画像の参照値を返します。
		 * @return
		 * [readonly]
		 * {@link #update}に最後に入力した画像。一度も{@link #update}をコールしなかったときは未定。
		 */
		public function getSourceImage():IFLARRgbRaster
		{
			return this._ref_raster;
		}
		
		/**
		 * この関数は、RGB画像の任意の4頂点領域を、射影変換してi_raster取得します。
		 * {@link #getPerspectiveImage(double, double, double, double, double, double, double, double, IFLARRgbRaster)}
		 * のint引数版です。
		 * @param i_x1
		 * @param i_y1
		 * @param i_x2
		 * @param i_y2
		 * @param i_x3
		 * @param i_y3
		 * @param i_x4
		 * @param i_y4
		 * @param i_raster
		 * @return
		 * @throws FLARException 
		 */
		public function getPerspectiveImage_1(
			i_x1:int,i_y1:int,
			i_x2:int,i_y2:int,
			i_x3:int,i_y3:int,
			i_x4:int,i_y4:int,
			i_raster:IFLARRgbRaster):IFLARRgbRaster
		{
			this._pcopy.copyPatt_3(i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4,0,0,1, i_raster);
			return i_raster;
		}
		/**
		 * この関数は、RGB画像の任意の4頂点領域を、射影変換してi_raster取得します。
		 * 出力画像の解像度は、i_rasterに一致します。
		 * @param i_x1
		 * 頂点1[pixel]
		 * @param i_y1
		 * 頂点1[pixel]
		 * @param i_x2
		 * 頂点2[pixel]
		 * @param i_y2
		 * 頂点2[pixel]
		 * @param i_x3
		 * 頂点3[pixel]
		 * @param i_y3
		 * 頂点3[pixel]
		 * @param i_x4
		 * 頂点4[pixel]
		 * @param i_y4
		 * 頂点4[pixel]
		 * @param i_raster
		 * 射影変換した画像を受け取るオブジェクト
		 * @return
		 * 結果を格納したi_rasterオブジェクト。
		 * @throws FLARException 
		 */
		public function getPerspectiveImage_2(
				i_x1:Number,i_y1:Number,
				i_x2:Number,i_y2:Number,
				i_x3:Number,i_y3:Number,
				i_x4:Number,i_y4:Number,
				i_raster:IFLARRgbRaster):IFLARRgbRaster
			{
				this._pcopy.copyPatt_3(i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4,0,0,1, i_raster);
				return i_raster;
			}	
	}
}
