package org.libspark.flartoolkit.detector.single
{
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	
	/**
	 * detectMarkerのコールバック関数
	 */
	internal class DetectSquareCB implements NyARSquareContourDetector_IDetectMarkerCallback
	{
		//公開プロパティ
		public var confidence:Number;
		public var square:NyARSquare=new NyARSquare();
		
		//参照インスタンス
		private var _ref_raster:INyARRgbRaster;
		//所有インスタンス
		private var _inst_patt:INyARColorPatt;
		private var _deviation_data:NyARMatchPattDeviationColorData;
		private var _match_patt:NyARMatchPatt_Color_WITHOUT_PCA;
		private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();
		private var _coordline:NyARCoord2Linear;
		
		public function DetectSquareCB(i_inst_patt:INyARColorPatt,i_ref_code:NyARCode,i_param:NyARParam)
		{
			this._inst_patt=i_inst_patt;
			this._deviation_data=new NyARMatchPattDeviationColorData(i_ref_code.getWidth(),i_ref_code.getHeight());
			this._coordline=new NyARCoord2Linear(i_param.getScreenSize(),i_param.getDistortionFactor());
			this._match_patt=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code);
			return;
		}
		private var __tmp_vertex:Vector.<NyARIntPoint2d>=NyARIntPoint2d.createArray(4);
		/**
		 * 矩形が見付かるたびに呼び出されます。
		 * 発見した矩形のパターンを検査して、方位を考慮した頂点データを確保します。
		 */
		public function onSquareDetect(i_sender:NyARSquareContourDetector,i_coordx:Vector.<int>,i_coordy:Vector.<int>,i_coor_num:int,i_vertex_index:Vector.<int>):void
		{
			var i:int;
			var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
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
			
			//画像を取得
			if (!this._inst_patt.pickFromRaster(this._ref_raster,vertex)){
				return;
			}
			//取得パターンをカラー差分データに変換して評価する。
			this._deviation_data.setRaster(this._inst_patt);
			if(!this._match_patt.evaluate(this._deviation_data,mr)){
				return;
			}
			//現在の一致率より低ければ終了
			if (this.confidence > mr.confidence){
				return;
			}
			//一致率の高い矩形があれば、方位を考慮して頂点情報を作成
			var sq:NyARSquare=this.square;
			this.confidence = mr.confidence;
			//directionを考慮して、squareを更新する。
			for(i=0;i<4;i++){
				var idx:int=(i+4 - mr.direction) % 4;
				this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coordx,i_coordy,i_coor_num,sq.line[i]);
			}
			for (i = 0; i < 4; i++) {
				//直線同士の交点計算
				if(!NyARLinear.crossPos(sq.line[i],sq.line[(i + 3) % 4],sq.sqvertex[i])){
					throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
				}
			}
		}
		public function init(i_raster:INyARRgbRaster):void
		{
			this.confidence=0;
			this._ref_raster=i_raster;
			
		}
	}
}