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
package org.libspark.flartoolkit.rpf.reality.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.IFLARDisposable;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARRectOffset;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.FLARDoubleMatrix44;
	import org.libspark.flartoolkit.core.utils.FLARManagedObject;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.FLARRealitySource;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.FLARTarget;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.status.FLARRectTargetStatus;
	import jp.nyatla.as3utils.*;

	/**
	 * Realityターゲットを定義します。
	 * {@link #tag}以外のクラスメンバに対する書き込み操作を行わないでください。
	 *
	 */
	public class FLARRealityTarget extends FLARManagedObject
	{
		/**　ユーザオブジェクトを配置するポインタータグ。ユーザが自由にオブジェクトポインタを配置できる。
		 * {@link IFLARDisposable}インタフェイスを持つオブジェクトを指定すると、このターゲットを開放するときに{@link IFLARDisposable#dispose()}をコールする。
		 * <p>{@link IFLARDisposable}インタフェイスは、Managed環境下では通常不要。</p>
		 */
		public var tag:Object;

		public function FLARRealityTarget(i_pool:FLARRealityTargetPool)
		{
			super(i_pool._op_interface);
			this._ref_pool=i_pool;
		}
		/**
		 * @Override
		 */
		public override function releaseObject():int
		{
			var ret:int=super.releaseObject();
			if(ret==0)
			{
				//TAGオブジェクトがIFLARDisposableインタフェイスを持てば、disposeをコール
				if((this._ref_tracktarget as IFLARDisposable)!=null)
				{
					((IFLARDisposable)(this._ref_tracktarget)).dispose();
				}
				//参照ターゲットのタグをクリアして、参照解除
				this._ref_tracktarget.tag=null;
				this._ref_tracktarget.releaseObject();
			}
			return ret;
		}
		/** 無効なシリアルID値*/
		public static const INVALID_REALITY_TARGET_ID:int=-1;
		private static var _serial_counter:Number=0;
		
		/**
		 * ID生成器。システムの稼働範囲内で一意なIDを持つこと。
		 * @return
		 */
		public static function createSerialId():Number
		{
			//synchronized(FLARRealityTarget._serial_lock){
			return FLARRealityTarget._serial_counter++;
		}
		////////////////////////
		
		/**
		 * 親情報
		 */
		private var _ref_pool:FLARRealityTargetPool;
		////////////////////////
		//targetの基本情報

		/** 内部向けの公開メンバ変数です。{@link #getSerialId}を使ってください。*/
		public var _serial:Number;
		/** 内部向けの公開メンバ変数です。{@link #refTransformMatrix}を使ってください。*/
		public var _transform_matrix:FLARTransMatResult=new FLARTransMatResult();

		/** ターゲットの種類。未知のターゲット。*/
		public static const RT_UNKNOWN:int   =0;
		/** ターゲットの種類。既知のターゲット。*/
		public static const RT_KNOWN:int     =2;
		/** ターゲットの種類。間もなく消失するターゲット。次回のprogressでリストから除去される。*/
		public static const RT_DEAD:int      =4;

		/** 内部向けpublicメンバ変数。{@link #getTargetType()}を使ってください。*/
		public var _target_type:int;
		
		/** 内部向けpublicメンバ。 ターゲットのオフセット位置。*/
		public var _offset:FLARRectOffset=new FLARRectOffset();
		/** 内部向けpublicメンバ。このターゲットが参照しているトラックターゲット*/
		public var _ref_tracktarget:FLARTarget;
		/** 内部向けpublicメンバ。スクリーン上の歪み解除済み矩形。*/
		public var _screen_square:FLARSquare=new FLARSquare();
		/** 内部向けpublicメンバ。getGrabbRateを使ってください。*/
		public var grab_rate:int;
		

		
		/**
		 * カメラ座標系をターゲット座標系に変換する行列の参照値を返します。
		 * この値は変更しないでください。（編集するときは、コピーを作ってください。）
		 * @return
		 */
		public function refTransformMatrix():FLARTransMatResult
		{
			//assert(this._target_type==RT_KNOWN);
			return this._transform_matrix;
		}
		/**
		 * このターゲットのタイプを返します。
		 * {@link #RT_UNKNOWN}=未確定ターゲット。2次元座標利用可能
		 * {@link #RT_KNOWN}  =確定した既知のターゲット。3次元座標利用可能
		 * {@link #RT_DEAD}   =次のprogressで削除するターゲット
		 * @return
		 */
		public function getTargetType():int
		{
			return this._target_type;
		}
		/**
		 * Reality内で一意な、ターゲットのシリアルIDです。
		 * @return
		 */
		public function getSerialId():Number
		{
			return this._serial;
		}

		/**
		 * このターゲットの補足率を返します。0-100の数値です。
		 * 20を切ると消失の可能性が高い？
		 * @return
		 */
		public function getGrabbRate():int
		{
			return this.grab_rate;
		}
		/**
		 * ターゲットの頂点配列への参照値を返します。この値は、二次元検出系の出力値です。
		 * 値が有効なのは、次のサイクルを実行するまでの間です。
		 * @return
		 */
		public function refTargetVertex():Vector.<FLARDoublePoint2d>
		{
			NyAS3Utils.assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			return ((FLARRectTargetStatus)(this._ref_tracktarget._ref_status)).vertex;
		}
		/**
		 * 対象矩形の頂点配列をコピーして返します。
		 * 樽型歪みの逆矯正は行いません。
		 * @param o_vertex
		 */
		public function getTargetVertex(o_vertex:Vector.<FLARDoublePoint2d>):void
		{
			NyAS3Utils.assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			var v:Vector.<FLARDoublePoint2d>=((FLARRectTargetStatus)(this._ref_tracktarget._ref_status)).vertex;
			for(var i:int=3;i>=0;i--){
				o_vertex[i].setValue(v[i]);
			}
		}
		/**
		 * 対象矩形の中央点を返します。
		 * 樽型歪みの逆矯正は行いません。
		 * @param o_center
		 */
		public function getTargetCenter(o_center:FLARDoublePoint2d):void
		{
			NyAS3Utils.assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			FLARDoublePoint2d.makeCenter(((FLARRectTargetStatus)(this._ref_tracktarget._ref_status)).vertex,4,o_center);
		}
		/**
		 * {@link #getTargetCenter}の出力型違いの関数です。
		 * @param o_center
		 */
		public function getTargetCenter_2(o_center:FLARIntPoint2d):void
		{
			NyAS3Utils.assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			FLARDoublePoint2d.makeCenter_2(((FLARRectTargetStatus)(this._ref_tracktarget._ref_status)).vertex,4,o_center);
		}
		/**
		 * 画面上の点が、このターゲットを構成する頂点の内側にあるか判定します。
		 * (範囲ではなく、頂点の内側であることに注意してください。)
		 * この関数は、Known/Unknownターゲットに使用できます。
		 * @param i_x
		 * @param i_y
		 * @return
		 */
		public function isInnerVertexPoint2d(i_x:int,i_y:int):Boolean
		{
			//assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			var vx:Vector.<FLARDoublePoint2d>=(FLARRectTargetStatus(this._ref_tracktarget._ref_status)).vertex;
			for(var i:int=3;i>=0;i--){
				if(FLARDoublePoint2d.crossProduct3Point_2(vx[i],vx[(i+1)%4],i_x,i_y)<0)
				{
					return false;
				}
			}
			return true;
		}
		/**
		 * 画面上の点が、このターゲットを包括する矩形の内側にあるかを判定します。
		 * この関数は、Known/Unknownターゲットに使用できます。
		 * @param i_x
		 * @param i_y
		 * @return
		 * <p>メモ:この関数にはnewが残ってるので注意</p>
		 */
		public function isInnerRectPoint2d(i_x:int,i_y:int):Boolean
		{
			//assert(this._target_type==RT_UNKNOWN || this._target_type==RT_KNOWN);
			var rect:FLARIntRect=new FLARIntRect();
			var vx:Vector.<FLARDoublePoint2d>=((FLARRectTargetStatus(this._ref_tracktarget._ref_status)).vertex);
			rect.setAreaRect(vx,4);
			return rect.isInnerPoint(i_x, i_y);
		}
		
		/**
		 * ターゲット座標系の4頂点でかこまれる領域を射影した平面から、RGB画像をo_rasterに取得します。
		 * @param i_vertex
		 * ターゲットのオフセットを基準値とした、頂点座標。要素数は4であること。(mm単位)
		 * @param i_matrix
		 * i_vertexに適応する変換行列。
		 * ターゲットの姿勢行列を指定すると、ターゲット座標系になります。不要ならばnullを設定してください。
		 * @param i_resolution
		 * 1ピクセルあたりのサンプリング値(n^2表現)
		 * @param o_raster
		 * 出力ラスタ
		 * @return
		 * @throws FLARException
		 * <p>メモ:この関数にはnewが残ってるので注意</p>
		 */
		public function getRgbPatt3d(i_src:FLARRealitySource,i_vertex:Vector.<FLARDoublePoint3d>,i_matrix:FLARDoubleMatrix44,i_resolution:int,o_raster:IFLARRgbRaster):Boolean
		{
			//assert(this._target_type==RT_KNOWN);
			var da4:Vector.<FLARDoublePoint2d>=this._ref_pool._wk_da2_4;
			var v3d:FLARDoublePoint3d=new FLARDoublePoint3d();
			var i:int;
			if(i_matrix!=null){
				//姿勢変換してから射影変換
				for(i=3;i>=0;i--){
					//姿勢を変更して射影変換
					i_matrix.transform3d_2(i_vertex[i],v3d);
					this._transform_matrix.transform3d_2(v3d,v3d);
					this._ref_pool._ref_prj_mat.project(v3d,da4[i]);
				}
			}else{
				//射影変換のみ
				for(i=3;i>=0;i--){
					//姿勢を変更して射影変換
					this._transform_matrix.transform3d_2(i_vertex[i],v3d);
					this._ref_pool._ref_prj_mat.project(v3d,da4[i]);
				}
			}
			//パターンの取得
			return i_src.refPerspectiveRasterReader().copyPatt_2(da4,0,0,i_resolution, o_raster);
		}
		/**
		 * ターゲットと同じ平面に定義した矩形から、パターンを取得します。
		 * @param i_src
		 * @param i_x
		 * ターゲットのオフセットを基準値とした、矩形の左上座標(mm単位)
		 * @param i_y
		 * ターゲットのオフセットを基準値とした、矩形の左上座標(mm単位)
		 * @param i_w
		 * ターゲットのオフセットを基準値とした、矩形の幅(mm単位)
		 * @param i_h
		 * ターゲットのオフセットを基準値とした、矩形の幅(mm単位)
		 * @param i_resolution
		 * 1ピクセルあたりのサンプリング値(n^2表現)
		 * @param o_raster
		 * 出力ラスタ
		 * @return
		 * @throws FLARException
		 */
		public function getRgbRectPatt3d(i_src:FLARRealitySource,i_x:Number,i_y:Number,i_w:Number,i_h:Number,i_resolution:int,o_raster:IFLARRgbRaster):Boolean
		{
			//assert(this._target_type==RT_KNOWN);
			//RECT座標を作成
			var da4:Vector.<FLARDoublePoint3d>=this._ref_pool._wk_da3_4;
			da4[0].x=i_x;    da4[0].y=i_y+i_h;da4[0].z=0;//LB
			da4[1].x=i_x+i_w;da4[1].y=i_y+i_h;da4[1].z=0;//RB
			da4[2].x=i_x+i_w;da4[2].y=i_y;    da4[2].z=0;//RT
			da4[3].x=i_x;    da4[3].y=i_y;    da4[3].z=0;//LT
			return getRgbPatt3d(i_src,da4,null,i_resolution,o_raster);
		}
		
	}
}