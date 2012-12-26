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
package org.libspark.flartoolkit.core.utils 
{
	import org.libspark.flartoolkit.core.*;
	/**
	 * 参照カウンタ付きのobjectPoolです。FLARManagedObjectから派生したオブジェクトを管理します。
	 * このクラスは、参照カウンタ付きのオブジェクト型Tのオブジェクトプールを実現します。
	 * 
	 * このクラスは、FLARManagedObjectと密接に関連して動作することに注意してください。
	 * 要素の作成関数はこのクラスで公開しますが、要素の解放関数は要素側に公開します。
	 * @param <T>
	 */
	public class FLARManagedObjectPool
	{

		/**
		 * 公開するオペレータオブジェクトです。
		 * このプールに所属する要素以外からは参照しないでください。
		 */
		public var _op_interface:Operator=new Operator();

		/**
		 * プールから型Tのオブジェクトを割り当てて返します。
		 * @return
		 * 新しいオブジェクト
		 */
		public function newObject():FLARManagedObject
		{
			var pool:Operator=this._op_interface;
			if(pool._pool_stock<1){
				return null;
			}
			pool._pool_stock--;
			//参照オブジェクトを作成して返す。
			return (FLARManagedObject)(pool._pool[pool._pool_stock].initObject());
		}
		/**
		 * 実体化の拒否の為に、コンストラクタを隠蔽します。
		 * 継承クラスを作成して、初期化処理を実装してください。
		 */
		public function FLARManagedObjectPool()
		{
		}
		/**
		 * オブジェクトを初期化します。この関数は、このクラスを継承したクラスを公開するときに、コンストラクタから呼び出します。
		 * @param i_length
		 * @param i_element_type
		 * @throws FLARException
		 */
		protected function initInstance(i_length:int):void
		{
			var pool:Operator=this._op_interface;
			//領域確保
			pool._buffer = new Vector.<FLARManagedObject>(i_length);
			pool._pool = new Vector.<FLARManagedObject>(i_length);
			//使用中個数をリセット
			pool._pool_stock=i_length;
			//オブジェクトを作成
			for(var i:int=pool._pool.length-1;i>=0;i--)
			{
				pool._buffer[i]=pool._pool[i]=createElement();
			}
			return;		
		}


		protected function initInstance_2(i_length:int,i_param:Object):void
		{
			var pool:Operator=this._op_interface;
			//領域確保
			pool._buffer = new Vector.<FLARManagedObject>(i_length);
			pool._pool = new Vector.<FLARManagedObject>(i_length);
			//使用中個数をリセット
			pool._pool_stock=i_length;
			//オブジェクトを作成
			for(var i:int=pool._pool.length-1;i>=0;i--)
			{
				pool._buffer[i]=pool._pool[i]=createElement_2(i_param);
			}
			return;		
		}
		/**
		 * オブジェクトを作成します。継承クラス内で、型Tのオブジェクトを作成して下さい。
		 * @return
		 * @throws FLARException
		 */
		protected function createElement():FLARManagedObject
		{
			throw new FLARException();
		}
		protected function createElement_2(i_param:Object):FLARManagedObject
		{
			throw new FLARException();
		}
	}
}
import org.libspark.flartoolkit.core.utils.*;
/**
 * Javaの都合でバッファを所有させていますが、別にこの形で実装しなくてもかまいません。
 */
class Operator implements IFLARManagedObjectPoolOperater
{
	public var _buffer:Vector.<FLARManagedObject>;
	public var _pool:Vector.<FLARManagedObject>;
	public var _pool_stock:int;
	public function deleteObject(i_object:FLARManagedObject):void
	{
		//assert(i_object!=null);
		//assert(this._pool_stock<this._pool.length);
		this._pool[this._pool_stock]=i_object;
		this._pool_stock++;
	}
}