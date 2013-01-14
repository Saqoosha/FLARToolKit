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
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.param.*;
	public class FLARSingleCameraSystem
	{
		/** 定数値。視錐台のFARパラメータの初期値[mm]です。*/
		public static const FRUSTUM_DEFAULT_FAR_CLIP:Number=10000;
		/** 定数値。視錐台のNEARパラメータの初期値[mm]です。*/
		public static const FRUSTUM_DEFAULT_NEAR_CLIP:Number=10;
		
		protected var _ref_param:FLARParam;
		protected var _frustum:FLARFrustum;	
		public function FLARSingleCameraSystem(i_ref_cparam:FLARParam)
		{
			this._observer=new ObserverList(3);
			this._ref_param=i_ref_cparam;
			this._frustum=new FLARFrustum();
			this.setProjectionMatrixClipping(FRUSTUM_DEFAULT_NEAR_CLIP, FRUSTUM_DEFAULT_FAR_CLIP);
			
		}
		/**
		 * [readonly]
		 * 現在のフラスタムオブジェクトを返します。
		 * @return
		 */
		public function getFrustum():FLARFrustum
		{
			return this._frustum;
		}
		/**
		 * [readonly]
		 * 現在のカメラパラメータオブジェクトを返します。
		 * @return
		 */
		public function getARParam():FLARParam
		{
			return this._ref_param;
		}
		/**
		 * 視錐台パラメータを設定します。
		 * この関数は、値を更新後、登録済の{@link IObserver}オブジェクトへ、{@link #EV_UPDATE}通知を送信します。
		 * @param i_near
		 * 新しいNEARパラメータ
		 * @param i_far
		 * 新しいFARパラメータ
		 */
		public function setProjectionMatrixClipping(i_near:Number,i_far:Number):void
		{
			var s:FLARIntSize=this._ref_param.getScreenSize();
			this._frustum.setValue_2(this._ref_param.getPerspectiveProjectionMatrix(),s.w,s.h,i_near,i_far);
			//イベントの通知
			this._observer.notifyOnUpdateCameraParametor(this._ref_param,i_near,i_far);
		}	
		
		

		protected var _observer:ObserverList;
		/**
		 * {@link FLARSingleCameraSystem}のイベント通知リストへオブザーバを追加します。
		 * この関数は、オブザーバが起動時に使用します。ユーザが使用することは余りありません。
		 * @param i_observer
		 * 通知先のオブザーバオブジェクト
		 */
		public function addObserver(i_observer:IFLARSingleCameraSystemObserver):void
		{
			this._observer.pushAssert(i_observer);
			var f:FLARFrustum_FrustumParam=this.getFrustum().getFrustumParam(new FLARFrustum_FrustumParam());
			i_observer.onUpdateCameraParametor(this._ref_param, f.near, f.far);		
		}
	}
}
import org.libspark.flartoolkit.core.types.stack.*;
import org.libspark.flartoolkit.core.param.*;
//
//	イベント通知系
//
class ObserverList extends FLARPointerStack
{
	public function ObserverList(i_length:int)
	{
		super.initInstance(i_length);
	}
	public function notifyOnUpdateCameraParametor(i_param:FLARParam,i_near:Number,i_far:Number):void
	{
		for(var i:int=0;i<this._length;i++){
			this._items[i].onUpdateCameraParametor(i_param,i_near,i_far);
		}
	}
}
