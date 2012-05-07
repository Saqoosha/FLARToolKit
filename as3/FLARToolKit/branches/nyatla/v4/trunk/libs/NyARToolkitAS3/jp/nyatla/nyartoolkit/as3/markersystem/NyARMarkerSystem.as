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





	/**
	 * このクラスは、マーカベースARの制御クラスです。
	 * 複数のARマーカとNyIDの検出情報の管理機能、撮影画像の取得機能を提供します。
	 * このクラスは、ARToolKit固有の座標系を出力します。他の座標系を出力するときには、継承クラスで変換してください。
	 * レンダリングシステム毎にクラスを派生させて使います。Javaの場合には、OpenGL用の{@link NyARGlMarkerSystem}クラスがあります。
	 */
	public class NyARMarkerSystem
	{
		/**　定数値。自動敷居値を示す値です。　*/
		public const THLESHOLD_AUTO:int=0xffffffff;
		/** 定数値。視錐台のFARパラメータの初期値[mm]です。*/
		public const FRUSTUM_DEFAULT_FAR_CLIP:Number=10000;
		/** 定数値。視錐台のNEARパラメータの初期値[mm]です。*/
		public const FRUSTUM_DEFAULT_NEAR_CLIP:Number=10;
		/** マーカ消失時の、消失までのﾃﾞｨﾚｲ(フレーム数)の初期値です。*/
		public const LOST_DELAY_DEFAULT:int=5;
		
		
		private const MASK_IDTYPE:int=0xfffff000;
		private const MASK_IDNUM:int =0x00000fff;
		private const IDTYPE_ARTK:int=0x00000000;
		private const IDTYPE_NYID:int=0x00001000;

		protected var _sqdetect:INyARMarkerSystemSquareDetect;
		protected var _ref_param:NyARParam;
		protected var _frustum:NyARFrustum;
		private var _last_gs_th:int;
		private var _bin_threshold:int=THLESHOLD_AUTO;

		private var _tracking_list:TrackingList;
		private var _armk_list:ARMarkerList;
		private var _idmk_list:NyIdList;
		
		private var lost_th:int=5;
		private var _transmat:INyARTransMat;
		private static const INITIAL_MARKER_STACK_SIZE:int=10;
		private var _sq_stack:SquareStack;
		/**
		 * コンストラクタです。{@link INyARMarkerSystemConfig}を元に、インスタンスを生成します。
		 * @param i_config
		 * 初期化済の{@link MarkerSystem}を指定します。
		 * @throws NyARException
		 */
		public function NyARMarkerSystem(i_config:INyARMarkerSystemConfig)
		{
			this._ref_param=i_config.getNyARParam();
			this._frustum=new NyARFrustum();
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
		protected function initInstance(i_ref_config:INyARMarkerSystemConfig):void
		{
			this._sqdetect=new SquareDetect(i_ref_config);
			this._hist_th=i_ref_config.createAutoThresholdArgorism();
		}
		/**
		 * 現在のフラスタムオブジェクトを返します。
		 * @return
		 * [readonly]
		 */
		public function getFrustum():NyARFrustum
		{
			return this._frustum;
		}
		/**
		 * 現在のカメラパラメータオブジェクトを返します。
		 * @return
		 * [readonly]
		 */
		public function getARParam():NyARParam
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
			var s:NyARIntSize=this._ref_param.getScreenSize();
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
		 * @throws NyARException
		 */
		public function addNyIdMarker(i_id:Number,i_marker_size:Number):int
		{
			var target:MarkerInfoNyId=new MarkerInfoNyId(i_id,i_id,i_marker_size);
			if(!this._idmk_list.add(target)){
				throw new NyARException();
			}
			if(!this._tracking_list.add(target)){
				throw new NyARException();
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
		 * @throws NyARException
		 */
		public function addNyIdMarker_2(i_id_s:Number,i_id_e:Number,i_marker_size:Number):int
		{
			var target:MarkerInfoNyId=new MarkerInfoNyId(i_id_s,i_id_e,i_marker_size);
			if(!this._idmk_list.add(target)){
				throw new NyARException();
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
		 * @throws NyARException
		 */
		public function addARMarker(i_code:NyARCode,i_patt_edge_percentage:int,i_marker_size:Number):int
		{
			var target:MarkerInfoARMarker=new MarkerInfoARMarker(i_code,i_patt_edge_percentage,i_marker_size);
			if(!this._armk_list.add(target)){
				throw new NyARException();
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
		 * @throws NyARException
		 */
		public function addARMarker_2(i_stream:String,i_patt_resolution:int,i_patt_edge_percentage:int,i_marker_size:Number):int
		{
			var c:NyARCode=new NyARCode(i_patt_resolution,i_patt_resolution);
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
		 * @throws NyARException
		 */
		public function addARMarker_3(i_raster:INyARRgbRaster, i_patt_resolution:int, i_patt_edge_percentage:int, i_marker_size:Number):int
		{
			var c:NyARCode=new NyARCode(i_patt_resolution,i_patt_resolution);
			var s:NyARIntSize=i_raster.getSize();
			//ラスタからマーカパターンを切り出す。
			var pc:INyARPerspectiveCopy=INyARPerspectiveCopy(i_raster.createInterface(INyARPerspectiveCopy));
			var tr:NyARRgbRaster=new NyARRgbRaster(i_patt_resolution,i_patt_resolution);
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
			throw new NyARException();
		}
		/**
		 * この関数は、NyIdマーカのID値を返します。
		 * 範囲指定で登録したNyIdマーカから、実際のIDを得るために使います。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @return
		 * 現在のNyIdの値
		 * @throws NyARException
		 */
		public function getNyId(i_id:int):Number
		{
			if((i_id & MASK_IDTYPE)==IDTYPE_NYID){
				//Idマーカ
				return MarkerInfoNyId(this._idmk_list.getItem(i_id &MASK_IDNUM)).nyid;
			}
			//ARマーカ？
			throw new NyARException();
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
		public function getMarkerPlanePos(i_id:int,i_x:int,i_y:int,i_out:NyARDoublePoint3d):NyARDoublePoint3d
		{
			this._frustum.unProjectOnMatrix(i_x, i_y,this.getMarkerMatrix(i_id),i_out);
			return i_out;
		}
		private var _wk_3dpos:NyARDoublePoint3d=new NyARDoublePoint3d();
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
		public function getScreenPos(i_id:int,i_x:Number,i_y:Number,i_z:Number,i_out:NyARDoublePoint2d):NyARDoublePoint2d
		{
			var _wk_3dpos:NyARDoublePoint3d=this._wk_3dpos;
			this.getMarkerMatrix(i_id).transform3d(i_x, i_y, i_z,_wk_3dpos);
			this._frustum.project_2(_wk_3dpos,i_out);
			return i_out;
		}	
		private var __pos3d:Vector.<NyARDoublePoint3d>=NyARDoublePoint3d.createArray(4);
		private var __pos2d:Vector.<NyARDoublePoint2d>=NyARDoublePoint2d.createArray(4);

		
		/**
		 * この関数は、マーカ平面上の任意の４点で囲まれる領域から、画像を射影変換して返します。
		 * {@link #isExistMarker(int)}がtrueの時にだけ使用できます。
		 * @param i_id
		 * マーカID（ハンドル）値。
		 * @param i_sensor
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(NyARSensor)}関数に入力したものと同じものを指定します。
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
		 * @throws NyARException
		 */
		public function getMarkerPlaneImage(
			i_id:int,
			i_sensor:NyARSensor,
			i_x1:int,i_y1:int,
			i_x2:int,i_y2:int,
			i_x3:int,i_y3:int,
			i_x4:int,i_y4:int,
			i_raster:INyARRgbRaster):INyARRgbRaster
		{
			var pos:Vector.<NyARDoublePoint3d>  = this.__pos3d;
			var pos2:Vector.<NyARDoublePoint2d> = this.__pos2d;
			var tmat:NyARDoubleMatrix44=this.getMarkerMatrix(i_id);
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
		 * 画像を取得するセンサオブジェクト。通常は{@link #update(NyARSensor)}関数に入力したものと同じものを指定します。
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
		 * @throws NyARException
		 */
		public function getMarkerPlaneImage_2(
			i_id:int,
			i_sensor:NyARSensor,
			i_l:int,i_t:int,
			i_w:int,i_h:int,
			i_raster:INyARRgbRaster ):INyARRgbRaster
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
		public function getMarkerMatrix(i_id:int):NyARDoubleMatrix44
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
		public function getMarkerVertex2D(i_id:int):Vector.<NyARIntPoint2d>
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
		 * 2値化敷居値。{@link NyARMarkerSystem#THLESHOLD_AUTO}を指定すると、自動調整になります。
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
		 * デフォルト値は、{@link NyARMarkerSystem#LOST_DELAY_DEFAULT}です。
		 * MarkerSystemは、ここで指定した回数を超えて連続でマーカを検出できないと、マーカが消失したと判定します。
		 * @param i_delay
		 * 回数を指定します。
		 */
		public function setLostDelay(i_delay:int):void
		{
			this.lost_th=i_delay;
		}
		private var _time_stamp:int=-1;
		protected var _hist_th:INyARHistogramAnalyzer_Threshold;
		private var _on_sq_handler:OnSquareDetect;
		/**
		 * この関数は、入力したセンサ入力値から、インスタンスの状態を更新します。
		 * 関数は、センサオブジェクトから画像を取得して、マーカ検出、一致判定、トラッキング処理を実行します。
		 * @param i_sensor
		 * {@link MarkerSystem}に入力する画像を含むセンサオブジェクト。
		 * @throws NyARException 
		 */
		public function update(i_sensor:NyARSensor):void
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


/**
 * コールバック関数の隠蔽用クラス。
 * このクラスは、{@link NyARMarkerSystem}からプライベートに使います。
 */
class OnSquareDetect implements NyARSquareContourDetector_CbHandler
{
	private var _ref_tracking_list:TrackingList;
	private var _ref_armk_list:ARMarkerList;
	private var _ref_idmk_list:NyIdList;
	private var _ref_sq_stack:SquareStack;
	public var _ref_input_rfb:INyARPerspectiveCopy;
	public var _ref_input_gs:INyARGrayscaleRaster;	
	
	private var _coordline:NyARCoord2Linear;
	public function OnSquareDetect(i_config:INyARMarkerSystemConfig,i_armk_list:ARMarkerList,i_idmk_list:NyIdList,i_tracking_list:TrackingList ,i_ref_sq_stack:SquareStack)
	{
		this._coordline=new NyARCoord2Linear(i_config.getNyARParam().getScreenSize(),i_config.getNyARParam().getDistortionFactor());
		this._ref_armk_list=i_armk_list;
		this._ref_idmk_list=i_idmk_list;
		this._ref_tracking_list=i_tracking_list;
		//同時に判定待ちにできる矩形の数
		this._ref_sq_stack=i_ref_sq_stack;
	}
	public function detectMarkerCallback(i_coord:NyARIntCoordinates,i_vertex_index:Vector.<int>):void
	{
		var i2:int;
		//とりあえずSquareスタックを予約
		var sq_tmp:SquareStack_Item=SquareStack_Item(this._ref_sq_stack.prePush());
		//観測座標点の記録
		for(i2=0;i2<4;i2++){
			sq_tmp.ob_vertex[i2].setValue(i_coord.items[i_vertex_index[i2]]);
		}
		//頂点分布を計算
		sq_tmp.vertex_area.setAreaRect_2(sq_tmp.ob_vertex,4);
		//頂点座標の中心を計算
		sq_tmp.center2d.setCenterPos(sq_tmp.ob_vertex,4);
		//矩形面積
		sq_tmp.rect_area=sq_tmp.vertex_area.w*sq_tmp.vertex_area.h;

		var is_target_marker:Boolean=false;
		for(;;){
			//トラッキング対象か確認する。
			if(this._ref_tracking_list.update(sq_tmp)){
				//トラッキング対象ならブレーク
				is_target_marker=true;
				break;
			}
			//@todo 複数マーカ時に、トラッキング済のarmarkerを探索対象外に出来ない？
			
			//nyIdマーカの特定(IDマーカの特定はここで完結する。)
			if(this._ref_idmk_list.size()>0){
				if(this._ref_idmk_list.update(this._ref_input_gs,sq_tmp)){
					is_target_marker=true;
					break;//idマーカを特定
				}
			}
			//ARマーカの特定
			if(this._ref_armk_list.size()>0){
				if(this._ref_armk_list.update(this._ref_input_rfb,sq_tmp)){
					is_target_marker=true;
					break;
				}
			}
			break;
		}
		//この矩形が検出対象なら、矩形情報を精密に再計算
		if(is_target_marker){
			//矩形は検出対象にマークされている。
			for(i2=0;i2<4;i2++){
				this._coordline.coord2Line(i_vertex_index[i2],i_vertex_index[(i2+1)%4],i_coord,sq_tmp.line[i2]);
			}
			for (i2 = 0; i2 < 4; i2++) {
				//直線同士の交点計算
				if(!sq_tmp.line[i2].crossPos(sq_tmp.line[(i2 + 3) % 4],sq_tmp.sqvertex[i2])){
					throw new NyARException();//まずない。ありえない。
				}
			}
		}else{
			//この矩形は検出対象にマークされなかったので、解除
			this._ref_sq_stack.pop();
		}
	}
}




class SquareDetect implements INyARMarkerSystemSquareDetect
{
	private var _sd:NyARSquareContourDetector_Rle;
	public function SquareDetect(i_config:INyARMarkerSystemConfig)
	{
		this._sd=new NyARSquareContourDetector_Rle(i_config.getScreenSize());
	}
	public function detectMarkerCb(i_sensor:NyARSensor,i_th:int,i_handler:NyARSquareContourDetector_CbHandler):void
	{
		this._sd.detectMarker_2(i_sensor.getGsImage(), i_th,i_handler);
	}
}






