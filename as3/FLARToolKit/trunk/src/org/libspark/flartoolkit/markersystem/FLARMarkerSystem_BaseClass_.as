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
	import org.libspark.flartoolkit.core.analyzer.histogram.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.markersystem.utils.*;
	
	/**
	 * このクラスは、マーカベースARの制御クラスです。
	 * 複数のARマーカとNyIDの検出情報の管理機能、撮影画像の取得機能を提供します。
	 * このクラスは、ARToolKit固有の座標系を出力します。他の座標系を出力するときには、継承クラスで変換してください。
	 * レンダリングシステム毎にクラスを派生させて使います。Javaの場合には、OpenGL用の{@link FLARGlMarkerSystem}クラスがあります。
	 */
	public class FLARMarkerSystem_BaseClass_
	{
		/**
		 * 定数値。
		 * 自動敷居値を示す値です。
		 */
		public const THLESHOLD_AUTO:Number=0xffffffff;
		/**
		 * 定数値。
		 * 視錐台のFARパラメータの初期値[mm]です。
		 */
		public const FRUSTUM_DEFAULT_FAR_CLIP:Number=10000;
		
		/**
		 * 定数値。
		 * 視錐台のNEARパラメータの初期値[mm]です。
		 */
		public const FRUSTUM_DEFAULT_NEAR_CLIP:Number=10;
		
		/**
		 * マーカ消失時の、消失までのﾃﾞｨﾚｲ(フレーム数)の初期値です。
		 */
		public const LOST_DELAY_DEFAULT:int=5;
		
		
		private const MASK_IDTYPE:Number=0xfffff000;
		private const MASK_IDNUM:Number =0x00000fff;
		private const IDTYPE_ARTK:Number=0x00000000;
		private const IDTYPE_NYID:Number=0x00001000;

		protected var _sqdetect:IFLARMarkerSystemSquareDetect;
		protected var _ref_param:FLARParam;
		protected var _frustum:FLARFrustum;
		private var _last_gs_th:int;
		private var _bin_threshold:Number=THLESHOLD_AUTO;

		private var _tracking_list:TrackingList;
		private var _armk_list:ARMarkerList;
		private var _idmk_list:NyIdList;
		
		private var lost_th:int=5;
		private var _transmat:IFLARTransMat;
		private static const INITIAL_MARKER_STACK_SIZE:int=10;
		private var _sq_stack:SquareStack;
		/**
		 * コンストラクタです。{@link IFLARMarkerSystemConfig}を元に、インスタンスを生成します。
		 * @param i_config
		 * 初期化済の{@link MarkerSystem}を指定します。
		 * @throws FLARException
		 */
		public function FLARMarkerSystem_BaseClass_(i_config:IFLARMarkerSystemConfig)
		{
			this._ref_param=i_config.getFLARParam();
			this._frustum=new FLARFrustum();
			this.initInstance(i_config);
			this.setProjectionMatrixClipping(FRUSTUM_DEFAULT_NEAR_CLIP, FRUSTUM_DEFAULT_FAR_CLIP);
			
			this._armk_list=new ARMarkerList();
			this._idmk_list=new NyIdList();
			this._tracking_list = new TrackingList();
			
			this._transmat=i_config.createTransmatAlgorism();
			//同時に判定待ちにできる矩形の数
			this._sq_stack=new SquareStack(INITIAL_MARKER_STACK_SIZE);			
			this._on_sq_handler=new OnSquareDetect(i_config,this._armk_list,this._idmk_list,this._tracking_list,this._sq_stack);
		}
		protected function initInstance(i_ref_config:IFLARMarkerSystemConfig):void
		{
			this._sqdetect=new SquareDetect(i_ref_config);
			this._hist_th=i_ref_config.createAutoThresholdArgorism();
		}
		/**
		 * 現在のフラスタムオブジェクトを返します。
		 * @return
		 * [readonly]
		 */
		public function getFrustum():FLARFrustum
		{
			return this._frustum;
		}
		/**
		 * 現在のカメラパラメータオブジェクトを返します。
		 * @return
		 * [readonly]
		 */
		public function getARParam():FLARParam
		{
			return this._ref_param;
		}	
		/**
		 * 視錐台パラメータを設定します。
		 * @param i_near
		 * 新しいNEARパラメータ
		 * @param i_far
		 * 新しいFARパラメータ
		 */
		public function setProjectionMatrixClipping(i_near:Number,i_far:Number):void
		{
			var s:FLARIntSize=this._ref_param.getScreenSize();
			this._frustum.setValue_2(this._ref_param.getPerspectiveProjectionMatrix(),s.w,s.h,i_near,i_far);
		}
		/**
		 * この関数は、1個のIdマーカをシステムに登録して、検出可能にします。
		 * 関数はマーカに対応したID値（ハンドル値）を返します。
		 * @param i_id
		 * 登録するNyIdマーカのid値
		 * @param i_marker_size
		 * マーカの四方サイズ[mm]
		 * @return
		 * マーカID（ハンドル）値。この値はIDの値ではなく、マーカのハンドル値です。
		 * @throws FLARException
		 */
		public function addNyIdMarker(i_id:Number,i_marker_size:Number):int
		{
			var target:MarkerInfoNyId=new MarkerInfoNyId(i_id,i_id,i_marker_size);
			if(!this._idmk_list.add(target)){
				throw new FLARException();
			}
			if(!this._tracking_list.add(target)){
				throw new FLARException();
			}
			return (this._idmk_list.size()-1)|IDTYPE_NYID;
		}
		/**
		 * この関数は、1個の範囲を持つidマーカをシステムに登録して、検出可能にします。
		 * インスタンスは、i_id_s<=n<=i_id_eの範囲にあるマーカを検出します。
		 * 例えば、1番から5番までのマーカを検出する場合に使います。
		 * 関数はマーカに対応したID値（ハンドル値）を返します。
		 * @param i_id_s
		 * Id範囲の開始値
		 * @param i_id_e
		 * Id範囲の終了値
		 * @param i_marker_size
		 * マーカの四方サイズ[mm]
		 * @return
		 * マーカID（ハンドル）値。この値はNyIDの値ではなく、マーカのハンドル値です。
		 * @throws FLARException
		 */
		public function addNyIdMarker_2(i_id_s:Number,i_id_e:Number,i_marker_size:Number):int
		{
			var target:MarkerInfoNyId=new MarkerInfoNyId(i_id_s,i_id_e,i_marker_size);
			if(!this._idmk_list.add(target)){
				throw new FLARException();
			}
			this._tracking_list.add(target);
			return (this._idmk_list.size()-1)|IDTYPE_NYID;
		}
		/**
		 * この関数は、ARToolKitスタイルのマーカーを登録します。
		 * @param i_code
		 * 登録するマーカパターンオブジェクト
		 * @param i_patt_edge_percentage
		 * エッジ割合。ARToolkitと同じ場合は25を指定します。
		 * @param i_marker_size
		 * マーカの平方サイズ[mm]
		 * @return
		 * マーカID（ハンドル）値。
		 * @throws FLARException
		 */
		public function addARMarker(i_code:FLARCode,i_patt_edge_percentage:int,i_marker_size:Number):int
		{
			var target:MarkerInfoARMarker=new MarkerInfoARMarker(i_code,i_patt_edge_percentage,i_marker_size);
			if(!this._armk_list.add(target)){
				throw new FLARException();
			}
			this._tracking_list.add(target);
			return (this._armk_list.size()-1)| IDTYPE_ARTK;
		}
		/**
		 * この関数は、ARToolKitスタイルのマーカーをストリームから読みだして、登録します。
		 * @param i_stream
		 * マーカデータを読み出すストリーム
		 * @param i_patt_edge_percentage
		 * エッジ割合。ARToolkitと同じ場合は25を指定します。
		 * @param i_marker_size
		 * マーカの平方サイズ[mm]
		 * @return
		 * マーカID（ハンドル）値。
		 * @throws FLARException
		 */
		public function addARMarker_2(i_stream:String,i_patt_resolution:int,i_patt_edge_percentage:int,i_marker_size:Number):int
		{
			var c:FLARCode=new FLARCode(i_patt_resolution,i_patt_resolution);
			c.loadARPatt(i_stream);
			return this.addARMarker(c, i_patt_edge_percentage, i_marker_size);
		}
		/**
		 * この関数は、画像からARマーカパターンを生成して、登録します。
		 * ビットマップ等の画像から生成したパターンは、撮影画像から生成したパターンファイルと比較して、撮影画像の色調変化に弱くなります。
		 * 注意してください。
		 * @param i_raster
		 * マーカ画像を格納したラスタオブジェクト
		 * @param i_patt_resolution
		 * マーカの解像度
		 * @param i_patt_edge_percentage
		 * マーカのエッジ領域のサイズ。マーカパターンは、i_rasterからエッジ領域を除いたパターンから生成します。
		 * ARToolKitスタイルの画像を用いる場合は、25を指定します。
		 * @param i_marker_size
		 * マーカの平方サイズ[mm]
		 * @return
		 * マーカID（ハンドル）値。
		 * @throws FLARException
		 */
		public function addARMarker_3(i_raster:IFLARRgbRaster, i_patt_resolution:int, i_patt_edge_percentage:int, i_marker_size:Number):int
		{
			var c:FLARCode=new FLARCode(i_patt_resolution,i_patt_resolution);
			var s:FLARIntSize=i_raster.getSize();
			//ラスタからマーカパターンを切り出す。
			var pc:IFLARPerspectiveCopy=IFLARPerspectiveCopy(i_raster.createInterface(IFLARPerspectiveCopy));
			var tr:FLARRgbRaster=new FLARRgbRaster(i_patt_resolution,i_patt_resolution);
			pc.copyPatt_3(0,0,s.w,0,s.w,s.h,0,s.h,i_patt_edge_percentage, i_patt_edge_percentage,4, tr);
			//切り出したパターンをセット
			c.setRaster_2(tr);
			this.addARMarker(c,i_patt_edge_percentage,i_marker_size);
			return 0;
		}
		
		
		/**
		 * この関数は、 マーカIDに対応するマーカが検出されているかを返します。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * マーカを検出していればtrueを返します。
		 */
		public function isExistMarker(i_id:int):Boolean
		{
			return this.getLife(i_id)>0;
		}
		/**
		 * この関数は、ARマーカの最近の一致度を返します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * 値は初期の一致度であり、トラッキング中は変動しません。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * 0&lt;n&lt;1の一致度。
		 */
		public function getConfidence(i_id:int):Number
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_ARTK){
				//ARマーカ
				return MarkerInfoARMarker(this._armk_list.getItem(i_id &MASK_IDNUM)).cf;
			}
			//Idマーカ？
			throw new FLARException();
		}
		/**
		 * この関数は、NyIdマーカのID値を返します。
		 * 範囲指定で登録したNyIdマーカから、実際のIDを得るために使います。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * 現在のNyIdの値
		 * @throws FLARException
		 */
		public function getNyId(i_id:int):Number
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_NYID){
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id &MASK_IDNUM)).nyid;
			}
			//ARマーカ？
			throw new FLARException();
		}
		/**
		 * この関数は、現在の２値化敷居値を返します。
		 * 自動敷居値を選択している場合は、直近に検出した敷居値を返します。
		 * @return
		 * 敷居値(0-255)
		 */
		public function getCurrentThreshold():int
		{
			return this._last_gs_th;
		}
		/**
		 * この関数は、マーカのライフ値を返します。
		 * ライフ値は、フレーム毎に加算される寿命値です。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * ライフ値
		 */
		public function getLife(i_id:int):int
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_ARTK){
				//ARマーカ
				return MarkerInfoARMarker(this._armk_list.getItem(i_id & MASK_IDNUM)).life;
			}else{
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id & MASK_IDNUM)).life;
			}
		}
		/**
		 * この関数は、マーカの消失カウンタの値を返します。
		 * 消失カウンタの値は、マーカを一時的にロストした時に加算される値です。再度検出した時に0にリセットされます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * 消失カウンタの値
		 */
		public function getLostCount(i_id:int):int
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_ARTK){
				//ARマーカ
				return MarkerInfoARMarker(this._armk_list.getItem(i_id & MASK_IDNUM)).lost_count;
			}else{
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id & MASK_IDNUM)).lost_count;
			}
		}
		/**
		 * この関数は、スクリーン座標点をマーカ平面の点に変換します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @param i_x
		 * 変換元のスクリーン座標
		 * @param i_y
		 * 変換元のスクリーン座標
		 * @param i_out
		 * 結果を格納するオブジェクト
		 * @return
		 * 結果を格納したi_outに設定したオブジェクト
		 */
		public function getMarkerPlanePos(i_id:int,i_x:int,i_y:int,i_out:FLARDoublePoint3d):FLARDoublePoint3d
		{
			this._frustum.unProjectOnMatrix(i_x, i_y,this.getMarkerMatrix(i_id),i_out);
			return i_out;
		}
		private var _wk_3dpos:FLARDoublePoint3d=new FLARDoublePoint3d();
		/**
		 * この関数は、マーカ座標系の点をスクリーン座標へ変換します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @param i_x
		 * マーカ座標系のX座標
		 * @param i_y
		 * マーカ座標系のY座標
		 * @param i_z
		 * マーカ座標系のZ座標
		 * @param i_out
		 * 結果を格納するオブジェクト
		 * @return
		 * 結果を格納したi_outに設定したオブジェクト
		 */
		public function getScreenPos(i_id:int,i_x:Number,i_y:Number,i_z:Number,i_out:FLARDoublePoint2d):FLARDoublePoint2d
		{
			var _wk_3dpos:FLARDoublePoint3d=this._wk_3dpos;
			this.getMarkerMatrix(i_id).transform3d(i_x, i_y, i_z,_wk_3dpos);
			this._frustum.project_2(_wk_3dpos,i_out);
			return i_out;
		}	
		private var __pos3d:Vector.<FLARDoublePoint3d>=FLARDoublePoint3d.createArray(4);
		private var __pos2d:Vector.<FLARDoublePoint2d>=FLARDoublePoint2d.createArray(4);

		
		/**
		 * この関数は、マーカ平面上の任意の４点で囲まれる領域から、画像を射影変換して返します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @param i_sensor
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(FLARSensor)}関数に入力したものと同じものを指定します。
		 * @param i_x1
		 * 頂点1[mm]
		 * @param i_y1
		 * 頂点1[mm]
		 * @param i_x2
		 * 頂点2[mm]
		 * @param i_y2
		 * 頂点2[mm]
		 * @param i_x3
		 * 頂点3[mm]
		 * @param i_y3
		 * 頂点3[mm]
		 * @param i_x4
		 * 頂点4[mm]
		 * @param i_y4
		 * 頂点4[mm]
		 * @param i_raster
		 * 取得した画像を格納するオブジェクト
		 * @return
		 * 結果を格納したi_rasterオブジェクト
		 * @throws FLARException
		 */
		public function getMarkerPlaneImage(
			i_id:int,
			i_sensor:FLARSensor,
			i_x1:int,i_y1:int,
			i_x2:int,i_y2:int,
			i_x3:int,i_y3:int,
			i_x4:int,i_y4:int,
			i_raster:IFLARRgbRaster):IFLARRgbRaster
		{
			var pos:Vector.<FLARDoublePoint3d>  = this.__pos3d;
			var pos2:Vector.<FLARDoublePoint2d> = this.__pos2d;
			var tmat:FLARDoubleMatrix44=this.getMarkerMatrix(i_id);
			tmat.transform3d(i_x1, i_y1,0,	pos[1]);
			tmat.transform3d(i_x2, i_y2,0,	pos[0]);
			tmat.transform3d(i_x3, i_y3,0,	pos[3]);
			tmat.transform3d(i_x4, i_y4,0,	pos[2]);
			for(var i:int=3;i>=0;i--){
				this._frustum.project_2(pos[i],pos2[i]);
			}
			return i_sensor.getPerspectiveImage_1(pos2[0].x, pos2[0].y,pos2[1].x, pos2[1].y,pos2[2].x, pos2[2].y,pos2[3].x, pos2[3].y,i_raster);
		}
		/**
		 * この関数は、マーカ平面上の任意の矩形で囲まれる領域から、画像を射影変換して返します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @param i_sensor
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(FLARSensor)}関数に入力したものと同じものを指定します。
		 * @param i_l
		 * 矩形の左上点です。
		 * @param i_t
		 * 矩形の左上点です。
		 * @param i_w
		 * 矩形の幅です。
		 * @param i_h
		 * 矩形の幅です。
		 * @param i_raster
		 * 出力先のオブジェクト
		 * @return
		 * 結果を格納したi_rasterオブジェクト
		 * @throws FLARException
		 */
		public function getMarkerPlaneImage_2(
			i_id:int,
			i_sensor:FLARSensor,
			i_l:int,i_t:int,
			i_w:int,i_h:int,
			i_raster:IFLARRgbRaster ):IFLARRgbRaster
		{
			return this.getMarkerPlaneImage(i_id,i_sensor,i_l+i_w-1,i_t+i_h-1,i_l,i_t+i_h-1,i_l,i_t,i_l+i_w-1,i_t,i_raster);
		}
		/**
		 * この関数は、マーカの姿勢変換行列を返します。
		 * マーカID（ハンドル）値。
		 * @return
		 * [readonly]
		 * 姿勢行列を格納したオブジェクト。座標系は、ARToolKit座標系です。
		 */
		public function getMarkerMatrix(i_id:int):FLARDoubleMatrix44
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_ARTK){
				//ARマーカ
				return MarkerInfoARMarker(this._armk_list.getItem(i_id &MASK_IDNUM)).tmat;
			}else{
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id &MASK_IDNUM)).tmat;
			}
		}
		/**
		 * この関数は、マーカの4頂点の、スクリーン上の二次元座標を返します。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * [readonly]
		 */
		public function getMarkerVertex2D(i_id:int):Vector.<FLARIntPoint2d>
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_ARTK){
				//ARマーカ
				return MarkerInfoARMarker(this._armk_list.getItem(i_id &MASK_IDNUM)).tl_vertex;
			}else{
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id &MASK_IDNUM)).tl_vertex;
			}
		}
		/**
		 * この関数は、2値化敷居値を設定します。
		 * @param i_th
		 * 2値化敷居値。{@link FLARMarkerSystem#THLESHOLD_AUTO}を指定すると、自動調整になります。
		 */
		public function setBinThreshold(i_th:int):void
		{
			this._bin_threshold=i_th;
		}
		/**
		 * この関数は、ARマーカ検出の、敷居値を設定します。
		 * ここで設定した値以上の一致度のマーカを検出します。
		 * @param i_val
		 * 敷居値。0.0&lt;n&lt;1.0の値を指定すること。
		 */
		public function setConfidenceThreshold(i_val:Number):void
		{
			this._armk_list.setConficenceTh(i_val);
		}
		/**
		 * この関数は、消失時のディレイ値を指定します。
		 * デフォルト値は、{@link FLARMarkerSystem#LOST_DELAY_DEFAULT}です。
		 * MarkerSystemは、ここで指定した回数を超えて連続でマーカを検出できないと、マーカが消失したと判定します。
		 * @param i_delay
		 * 回数を指定します。
		 */
		public function setLostDelay(i_delay:int):void
		{
			this.lost_th=i_delay;
		}
		private var _time_stamp:int=-1;
		protected var _hist_th:IFLARHistogramAnalyzer_Threshold;
		private var _on_sq_handler:OnSquareDetect;
		/**
		 * この関数は、入力したセンサ入力値から、インスタンスの状態を更新します。
		 * 関数は、センサオブジェクトから画像を取得して、マーカ検出、一致判定、トラッキング処理を実行します。
		 * @param i_sensor
		 * {@link MarkerSystem}に入力する画像を含むセンサオブジェクト。
		 * @throws FLARException 
		 */
		public function update(i_sensor:FLARSensor):void
		{
			var time_stamp:int=i_sensor.getTimeStamp();
			//センサのタイムスタンプが変化していなければ何もしない。
			if(this._time_stamp==time_stamp){
				return;
			}
			var th:int=this._bin_threshold==THLESHOLD_AUTO?this._hist_th.getThreshold(i_sensor.getGsHistogram()):this._bin_threshold;

			this._sq_stack.clear();//矩形情報の保持スタック初期化		
			//解析
			this._tracking_list.prepare();
			this._idmk_list.prepare();
			this._armk_list.prepare();
			//検出処理
			this._on_sq_handler._ref_input_rfb=i_sensor.getPerspectiveCopy();
			this._on_sq_handler._ref_input_gs=i_sensor.getGsImage();
			//検出
			this._sqdetect.detectMarkerCb(i_sensor,th,this._on_sq_handler);

			//検出結果の反映処理
			this._tracking_list.finish();
			this._armk_list.finish();
			this._idmk_list.finish();
			//期限切れチェック
			var i:int;
			for(i=this._tracking_list.size()-1;i>=0;i--){
				var item:TMarkerData=TMarkerData(this._tracking_list.getItem(i));
				if(item.lost_count>this.lost_th){
					item.life=0;//活性off
				}
			}
			//各ターゲットの更新
			for(i=this._armk_list.size()-1;i>=0;i--){
				var target1:MarkerInfoARMarker=MarkerInfoARMarker(this._armk_list.getItem(i));
				if(target1.lost_count==0){
					target1.time_stamp=time_stamp;
					this._transmat.transMatContinue(target1.sq,target1.marker_offset,target1.tmat,target1.tmat);
				}
			}
			for(i=this._idmk_list.size()-1;i>=0;i--){
				var target2:MarkerInfoNyId=MarkerInfoNyId(this._idmk_list.getItem(i));
				if(target2.lost_count==0){
					target2.time_stamp=time_stamp;
					this._transmat.transMatContinue(target2.sq,target2.marker_offset,target2.tmat,target2.tmat);
				}
			}
			//タイムスタンプを更新
			this._time_stamp=time_stamp;
			this._last_gs_th=th;
		}

	}

}
