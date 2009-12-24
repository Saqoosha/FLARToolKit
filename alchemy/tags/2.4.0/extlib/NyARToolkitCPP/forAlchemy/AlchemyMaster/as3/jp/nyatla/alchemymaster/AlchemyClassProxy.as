/* 
 * PROJECT: AlchemyMaster
 * --------------------------------------------------------------------------------
 * The AlchemyMaster is helper classes and templates for Adobe Alchemy.
 *
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as 
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this program. If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/
 *	<airmail(at)ebony.plala.or.jp>
 */

package jp.nyatla.alchemymaster
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;	
	
	public class AlchemyClassProxy
	{
		public var _alchemy_stub:Object;
		public var _has_alchemy_object:Boolean=false;
		public var debug_str:String=new String();
		/**
		 * 現在取り付けてあるAlchemyオブジェクトがdisposableならば解放し、
		 * Alchemyオブジェクトとのリンクを切断します。
		 */
		public function dispose():void
		{
			if(this._alchemy_stub==null){
				return;
			}
			if(this._alchemy_stub._is_disposable==1){
				this._alchemy_stub.dispose(
					this._alchemy_stub,
					this._alchemy_stub._is_disposable,
					this._alchemy_stub._native);
			}
			this._alchemy_stub=null;
			return;
		}
		/**
		 * ProxyにAlchemyオブジェクトを取り付けます。
		 * 一度取り付けると、他のAlchemyオブジェクトとリンクさせることが出来なくなります。
		 */
		public final function attachAlchemyObject(i_alchemy_stub:Object):void
		{
			//有効なオブジェクトしかアタッチできない。
			if(i_alchemy_stub==null){
				throw new Error("AlchemyClassProxy::attachAlchemyObject failed");
			}
			setAlchemyObject(i_alchemy_stub);
			//保持フラグをON
			this._has_alchemy_object=true;
			this._alchemy_stub=i_alchemy_stub;
			return;
		}

		/**
		 * ProxyにAlchemyオブジェクトを参照させます。
		 */
		public final function setAlchemyObject(i_alchemy_stub:Object):void
		{
			//既にアタッチ済みのオブジェクトにアタッチすることはできない。
			if(this._has_alchemy_object==true){
				throw new Error("AlchemyClassProxy::setAlchemyObject failed");
			}
			//参照をセットする。
			if(i_alchemy_stub!=null){
				this._alchemy_stub=i_alchemy_stub;
			}else{
				this._alchemy_stub=null;
			}
			return;
		}
/*		
		//このインスタンスに、新しいアルケミオブジェクトを作成します。
		public function createObject()
		{
			throw new Error("AlchemyClassProxy::createObject");
			//この関数をオーバライドして下さい。
		}
		//このインスタンスに、引数のアルケミオブジェクトを設定します。
		public function wrapObject(i_alchemy_stub:Object)
		{
			//この関数をオーバライドして下さい。
			throw new Error("AlchemyClassProxy::wrapObject");
		}
*/		
	}
}
