/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 * For further information of this class, please contact.
 * http://sixwish.jp
 * <rokubou(at)gmail.com>
 */
package org.libspark.flartoolkit.detector.idmarker
{
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2bin.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.detector.NyARDetectMarker;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.*;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*;
	
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.detector.idmarker.FLARDetectIdMarkerResult;
	import org.libspark.flartoolkit.detector.idmarker.FLARDetectIdMarkerResultStack;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerData;
	import org.libspark.flartoolkit.detector.idmarker.data.FLARIdMarkerDataEncoder_RawBit;

	/**
	 * detectMarkerのコールバック関数
	 */
	internal class FLARMultiIdMarkerDetectCB implements NyARSquareContourDetector_IDetectMarkerCallback
	{
		//公開プロパティ
		public var result_stack:FLARDetectIdMarkerResultStack=new FLARDetectIdMarkerResultStack(NyARDetectMarker.AR_SQUARE_MAX);
		
		public var square:FLARSquare=new FLARSquare();
		public var marker_data:INyIdMarkerData;
		public var threshold:int;
		public var direction:int;
		
		private var _ref_raster:INyARRgbRaster;
		private var _current_data:INyIdMarkerData;
		private var _data_temp:INyIdMarkerData;
		private var _prev_data:INyIdMarkerData;
		private var _id_pickup:NyIdMarkerPickup = new NyIdMarkerPickup();
		private var _coordline:NyARCoord2Linear;
		private var _encoder:INyIdMarkerDataEncoder;
		
		private var __tmp_vertex:Vector.<NyARIntPoint2d>=NyARIntPoint2d.createArray(4);
		private var _marker_param:NyIdMarkerParam=new NyIdMarkerParam();
		private var _maker_pattern:NyIdMarkerPattern =new NyIdMarkerPattern();

		public function FLARMultiIdMarkerDetectCB(i_param:NyARParam,i_encoder:FLARIdMarkerDataEncoder_RawBit)
		{
			this._coordline=new NyARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
			this._data_temp=i_encoder.createDataInstance();
			this._current_data=i_encoder.createDataInstance();
			this._encoder=i_encoder;
			return;
		}
		
		/**
		 * Initialize call back handler.
		 */
		public function init(i_raster:INyARRgbRaster):void
		{
			this.marker_data=null;
			this.result_stack.clear();
			this._ref_raster=i_raster;
		}
		
		/**
		 * 矩形が見付かるたびに呼び出されます。
		 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
		 */
		public function onSquareDetect(i_sender:NyARSquareContourDetector,i_coordx:Vector.<int>,i_coordy:Vector.<int>,i_coor_num:int,i_vertex_index:Vector.<int>):void
		{
			//輪郭座標から頂点リストに変換
			var vertex:Vector.<NyARIntPoint2d>=this.__tmp_vertex;
			vertex[0].x=i_coordx[i_vertex_index[0]];
			vertex[0].y=i_coordy[i_vertex_index[0]];
			vertex[1].x=i_coordx[i_vertex_index[1]];
			vertex[1].y=i_coordy[i_vertex_index[1]];
			vertex[2].x=i_coordx[i_vertex_index[2]];
			vertex[2].y=i_coordy[i_vertex_index[2]];
			vertex[3].x=i_coordx[i_vertex_index[3]];
			vertex[3].y=i_coordy[i_vertex_index[3]];
			
			var param:NyIdMarkerParam=this._marker_param;
			var patt_data:NyIdMarkerPattern=this._maker_pattern;			
			// 評価基準になるパターンをイメージから切り出す
			if (!this._id_pickup.pickFromRaster(this._ref_raster,vertex, patt_data, param)){
				return;
			}
			//エンコード
			if(!this._encoder.encode(patt_data,this._data_temp)){
				return;
			}
			
			this._current_data.copyFrom(this._data_temp);
			this.marker_data=this._current_data;//みつかった。
			this.threshold=param.threshold;
			this.direction = param.direction;
			
			//マーカ情報を記録する。
			var result:FLARDetectIdMarkerResult = this.result_stack.prePush();
			result.direction = this.direction;
			result.markerdata.copyFrom(this.marker_data);
			result.arcode_id = getId(result.markerdata);
			
			
			//新しく認識、または継続認識中に更新があったときだけ、Square情報を更新する。
			//ココから先はこの条件でしか実行されない。
			var sq:NyARSquare = result.square;
			//directionを考慮して、squareを更新する。
			var i:int;
			for(i=0;i<4;i++){
				var idx:int=(i+4 - param.direction) % 4;
				this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coordx,i_coordy,i_coor_num,sq.line[i]);
			}
			for (i= 0; i < 4; i++) {
				//直線同士の交点計算
				if(!NyARLinear.crossPos(sq.line[i],sq.line[(i + 3) % 4],sq.sqvertex[i])){
					throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
				}
			}
		}
		
		private function getId(data:FLARIdMarkerData):int
		{
			var currId:int;
			if (data.packetLength > 4) {
				currId = -1;
			}else{
				currId=0;
				//最大4バイト繋げて１個のint値に変換
				for (var i:int = 0; i < data.packetLength; i++ ) {
					currId = (currId << 8) | data.getPacketData(i);
				}
			}
			return currId;
		}
	}
}