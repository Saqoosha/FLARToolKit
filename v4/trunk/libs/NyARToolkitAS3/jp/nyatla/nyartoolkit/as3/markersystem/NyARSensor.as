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
package jp.nyatla.nyartoolkit.as3.markersystem
{



	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;



	/**
	 * このクラスは、{@link NyARMarkerSystem}へ入力するセンサ情報（画像）を管理します。
	 * センサ情報のスナップショットに対するアクセサ、形式変換機能を提供します。
	 * 管理している情報は、元画像（カラー）、グレースケール画像、ヒストグラムです。
	 * このインスタンスは{@link NyARMarkerSystem#update(NyARSensor)}関数により、{@link NyARMarkerSystem}に入力します。
	 */
	public class NyARSensor
	{
		protected var _gs_hist:NyARHistogram;
		protected var _ref_raster:INyARRgbRaster;
		protected var _gs_raster:INyARGrayscaleRaster;
		protected var _src_ts:int;
		protected var _gs_id_ts:int;
		protected var _gs_hist_ts:int;
		/**
		 * 画像サイズ（スクリーンサイズ）を指定して、インスタンスを生成します。
		 * @param i_size
		 * 画像のサイズ。
		 * @throws NyARException
		 */
		public function NyARSensor(i_size:NyARIntSize)
		{
			this.initInstance(i_size);
			this._hist_drv=INyARHistogramFromRaster(this._gs_raster.createInterface(INyARHistogramFromRaster));
		}
		/**
		 * この関数は、画像ドライバに依存するインスタンスを生成する。
		 * 継承クラスで上書きする。
		 * @param s
		 * @throws NyARException
		 */
		protected function initResource(s:NyARIntSize):void
		{
			this._gs_raster=new NyARGrayscaleRaster(s.w,s.h,NyARBufferType.INT1D_GRAY_8,true);
		}
		/**
		 * 
		 * @param i_size
		 * @throws NyARException
		 */
		private function initInstance(i_size:NyARIntSize):void
		{
			//リソースの生成
			this.initResource(i_size);
			this._gs_hist=new NyARHistogram(256);
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
		public function getPerspectiveCopy():INyARPerspectiveCopy
		{
			return this._pcopy;
		}	
		private var _hist_drv:INyARHistogramFromRaster=null;	
		private var _last_input_rasster:INyARRaster=null;
		private var _pcopy:INyARPerspectiveCopy;
		private var _rgb2gs:INyARRgb2GsFilter=null;
		/**
		 * この関数は、入力画像を元に、インスタンスの状態を更新します。
		 * この関数は、タイムスタンプをインクリメントします。
		 * @param i_input
		 * カラー画像。画像のサイズは、コンストラクタに設定したスクリーンサイズと同じである必要があります。
		 * この画像は、次回の{@link #update}まで、インスタンスから参照されます。
		 * @throws NyARException 
		 */
		public function update(i_input:INyARRgbRaster):void
		{
			//ラスタドライバの準備
			if(this._last_input_rasster!=i_input){
				this._rgb2gs=INyARRgb2GsFilter(i_input.createInterface(INyARRgb2GsFilter));
				this._pcopy=INyARPerspectiveCopy(i_input.createInterface(INyARPerspectiveCopy));
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
		 * タイムスタンプは0から始まる整数値で、{@link #update(INyARRgbRaster)},{@link #updateTimeStamp()}
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
		 * @throws NyARException 
		 */
		public function getGsImage():INyARGrayscaleRaster
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
		 * @throws NyARException 
		 */
		public function getGsHistogram():NyARHistogram
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
		public function getSourceImage():INyARRgbRaster
		{
			return this._ref_raster;
		}
		
		/**
		 * この関数は、RGB画像の任意の4頂点領域を、射影変換してi_raster取得します。
		 * {@link #getPerspectiveImage(double, double, double, double, double, double, double, double, INyARRgbRaster)}
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
		 * @throws NyARException 
		 */
		public function getPerspectiveImage_1(
			i_x1:int,i_y1:int,
			i_x2:int,i_y2:int,
			i_x3:int,i_y3:int,
			i_x4:int,i_y4:int,
			i_raster:INyARRgbRaster):INyARRgbRaster
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
		 * @throws NyARException 
		 */
		public function getPerspectiveImage_2(
				i_x1:Number,i_y1:Number,
				i_x2:Number,i_y2:Number,
				i_x3:Number,i_y3:Number,
				i_x4:Number,i_y4:Number,
				i_raster:INyARRgbRaster):INyARRgbRaster
			{
				this._pcopy.copyPatt_3(i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4,0,0,1, i_raster);
				return i_raster;
			}	
	}
}
