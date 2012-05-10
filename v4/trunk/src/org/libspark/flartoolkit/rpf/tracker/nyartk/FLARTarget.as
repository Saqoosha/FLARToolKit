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
package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.types.FLARDoublePoint2d;
	import org.libspark.flartoolkit.core.types.FLARIntRect;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.status.FLARTargetStatus;

	/**
	 * トラッキングターゲットのクラスです。
	 * {@link #tag}以外の要素については、ユーザからの直接アクセスを推奨しません。
	 *
	 */
	public class FLARTarget extends FLARManagedObject
	{
		/**
		 * システム動作中に一意なシリアル番号
		 */
		private static var _serial_counter:Number=0;
		/**
		 * 新しいシリアルIDを返します。この値は、FLARTargetを新規に作成したときに、Poolクラスがserialプロパティに設定します。
		 * @return
		 */
		public static function createSerialId():Number
		{
			//マルチスレッドをサポートする環境では、排他ロックをかけること。
			return FLARTarget._serial_counter++;
		}
		////////////////////////
		//targetの基本情報
		/**
		 * ステータスのタイプを表します。この値はref_statusの型と同期しています。
		 */
		public var _st_type:int;
		/**
		 * Targetを識別するID値
		 */
		public var _serial:Number;
		/**
		 * 認識サイクルの遅延値。更新ミスの回数と同じ。
		 */
		public var _delay_tick:int;

		/**
		 * 現在のステータスの最大寿命。
		 */
		public var _status_life:int;

		////////////////////////
		//targetの情報
		public var _ref_status:FLARTargetStatus;
		
		/**
		 * ユーザオブジェクトを配置するポインタータグです。リリース時にNULL初期化されます。
		 */
		public var tag:Object;
	//	//Samplerからの基本情報
		
		/**
		 * サンプリングエリアを格納する変数です。
		 */
		public var _sample_area:FLARIntRect=new FLARIntRect();
		//アクセス用関数
		
		/**
		 * Constructor
		 */
		public function FLARTarget(iRefPoolOperator:IFLARManagedObjectPoolOperater)
		{
			super(iRefPoolOperator);
			this.tag=null;
		}
		/**
		 * この関数は、ref_statusの内容を安全に削除します。
		 */
		public override function releaseObject():int
		{
			var ret:int=super.releaseObject();
			if(ret==0 && this._ref_status!=null)
			{
				this._ref_status.releaseObject();
			}
			return ret;
		}
		
		/**
		 * 頂点情報を元に、sampleAreaにRECTを設定します。
		 * @param i_vertex
		 */
		public function setSampleArea(i_vertex:Vector.<FLARDoublePoint2d>):void
		{
			this._sample_area.setAreaRect(i_vertex,4);
		}	

		/**
		 * LowResolutionLabelingSamplerOut.Itemの値をを元に、sample_areaにRECTを設定します。
		 * @param i_item
		 * 設定する値です。
		 */
		public function setSampleArea_2(i_item:LowResolutionLabelingSamplerOut_Item):void
		{
			this._sample_area.setValue(i_item.base_area);
		}
	}
}
