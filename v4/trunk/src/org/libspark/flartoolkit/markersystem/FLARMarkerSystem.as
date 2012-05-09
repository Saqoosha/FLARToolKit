package org.libspark.flartoolkit.markersystem 
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.utils.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
	import flash.display.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;





	/**
	 * このクラスは、マーカベースARの制御クラスです。
	 * 複数のARマーカとNyIDの検出情報の管理機能、撮影画像の取得機能を提供します。
	 * このクラスは、ARToolKit固有の座標系を出力します。他の座標系を出力するときには、継承クラスで変換してください。
	 * レンダリングシステム毎にクラスを派生させて使います。Javaの場合には、OpenGL用の{@link NyARGlMarkerSystem}クラスがあります。
	 * 
	 * このクラスは、NyARMarkerSystemをFLARToolkit向けに改造したものです。
	 */
	public class FLARMarkerSystem extends  NyARMarkerSystem
	{
		
		/**
		 * コンストラクタです。{@link INyARMarkerSystemConfig}を元に、インスタンスを生成します。
		 * @param i_config
		 * 初期化済の{@link MarkerSystem}を指定します。
		 * @throws NyARException
		 */
		public function FLARMarkerSystem(i_config:INyARMarkerSystemConfig)
		{
			super(i_config);
		}
		protected override function initInstance(i_ref_config:INyARMarkerSystemConfig):void
		{
			this._sqdetect=new FLDetector(i_ref_config);
			this._hist_th=i_ref_config.createAutoThresholdArgorism();
		}
		/**
		 * BitmapDataを元にARマーカを登録します。
		 * BitmapDataの画像サイズは問いません。画像のうち、外周をi_patt_edge_percentageをエッジとして取り除いたものから、i_resolution^2のマーカを作ります。
		 * @param	i_img
		 * 基にするマーカ画像
		 * @param	i_patt_resolution
		 * 評価パターンの解像度(ex.16)
		 * @param	i_patt_edge_percentage
		 * 外周エッジの割合(ex.20%=20)
		 * @param	i_marker_size
		 * 物理的なマーカサイズ[mm]
		 * @return
		 */
		public function addARMarker_4(i_img:BitmapData, i_patt_resolution:int, i_patt_edge_percentage:int, i_marker_size:Number):int
		{
			var w:int=i_img.width;
			var h:int=i_img.height;
			var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
			var c:NyARCode=new NyARCode(i_patt_resolution,i_patt_resolution);
			//ラスタからマーカパターンを切り出す。
			var pc:INyARPerspectiveCopy=INyARPerspectiveCopy(bmr.createInterface(INyARPerspectiveCopy));
			var tr:INyARRgbRaster=new NyARRgbRaster(i_patt_resolution,i_patt_resolution);
			pc.copyPatt_3(0,0,w,0,w,h,0,h,i_patt_edge_percentage, i_patt_edge_percentage,4, tr);
			//切り出したパターンをセット
			c.setRaster_2(tr);
			return super.addARMarker(c,i_patt_edge_percentage,i_marker_size);
		}
		/**
		 * Bitmap等を元に、ARマーカを登録します。
		 * @param	i_img
		 * @param	i_patt_resolution
		 * @param	i_patt_edge_percentage
		 * @param	i_marker_size
		 * @return
		 */
		public function addARMarker_5(i_img:Object, i_patt_resolution:int, i_patt_edge_percentage:int, i_marker_size:Number):int
		{
			var bm:BitmapData = new BitmapData(i_img.width, i_img.height);
			bm.draw(IBitmapDrawable(i_img));
			return this.addARMarker_4(bm, i_patt_resolution, i_patt_edge_percentage, i_marker_size);
		}
		/**
		 * マーカ平面の任意四角領域から画像を剥がして返します。
		 * @param	i_id
		 * @param	i_sensor
		 * @param	i_x1
		 * @param	i_y1
		 * @param	i_x2
		 * @param	i_y2
		 * @param	i_x3
		 * @param	i_y3
		 * @param	i_x4
		 * @param	i_y4
		 * @param	i_img
		 */
		public function getMarkerPlaneImage_3(
			i_id:int,
			i_sensor:NyARSensor,
			i_x1:Number,i_y1:Number,
			i_x2:Number,i_y2:Number,
			i_x3:Number,i_y3:Number,
			i_x4:Number,i_y4:Number,
			i_img:BitmapData):void
			{
				var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
				super.getMarkerPlaneImage(i_id, i_sensor, i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4,bmr);
				return;
			}
		/**
		 * マーカ平面の任意矩形領域から画像を剥がして返します。
		 * この関数は、{@link #getMarkerPlaneImage(int, NyARSensor, int, int, int, int, INyARRgbRaster)}
		 * のラッパーです。取得画像を{@link #BufferedImage}形式で返します。
		 * @param i_id
		 * マーカid
		 * @param i_sensor
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(NyARSensor)}関数に入力したものと同じものを指定します。
		 * @param i_l
		 * @param i_t
		 * @param i_w
		 * @param i_h
		 * @param i_raster
		 * 出力先のオブジェクト
		 * @throws NyARException
		 */
		public function getMarkerPlaneImage_4(
			i_id:int,
			i_sensor:NyARSensor ,
			i_l:Number,i_t:Number,
			i_w:Number,i_h:Number,
			i_img:BitmapData):void
		{
			var bmr:FLARRgbRaster=new FLARRgbRaster(i_img);
			super.getMarkerPlaneImage_2(i_id, i_sensor, i_l, i_t, i_w, i_h, bmr);
			this.getMarkerPlaneImage(i_id,i_sensor,i_l+i_w-1,i_t+i_h-1,i_l,i_t+i_h-1,i_l,i_t,i_l+i_w-1,i_t,bmr);
			return;
		}
	}
}

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
import jp.nyatla.nyartoolkit.as3.markersystem.utils.*;
import jp.nyatla.nyartoolkit.as3.markersystem.*;
import org.libspark.flartoolkit.core.squaredetect.*;
import org.libspark.flartoolkit.core.rasterfilter.*;
import org.libspark.flartoolkit.markersystem.*;

class FLDetector implements INyARMarkerSystemSquareDetect
{
	private var _sd:FLARSquareContourDetector_FlaFill;
	private var gs2bin:FLARGs2BinFilter;
	public function FLDetector(i_config:INyARMarkerSystemConfig)
	{
		this._sd=new FLARSquareContourDetector_FlaFill(i_config.getScreenSize());
	}
	public function detectMarkerCb(i_sensor:NyARSensor,i_th:int,i_handler:NyARSquareContourDetector_CbHandler):void
	{
		//GS->BIN変換
		this._sd.detectMarker(FLARSensor(i_sensor).getBinImage(i_th),i_handler);
	}
}

