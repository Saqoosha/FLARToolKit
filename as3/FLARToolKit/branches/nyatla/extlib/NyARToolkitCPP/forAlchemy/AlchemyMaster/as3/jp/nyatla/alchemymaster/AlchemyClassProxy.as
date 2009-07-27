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
		protected var _alchemy_stub:Object;
		public var _has_alchemy_object:Boolean=false;
		public var _alchemy_ptr:uint;
		protected var _ma:Marshal=new Marshal();
		public var debug_str:String=new String();
		public function dumpMarshalStr():String
		{
			return this._ma.toString();
		}
		public function dumpMarshalInt(i_len:int):String
		{
			var s:String=new String();
			this._ma.position=0;
			for(var i:int=0;i<i_len;i++){
				s+=(this._ma.readInt().toString()+",");
			}
			return s;
		}
		public function dispose():void
		{
			if(this._alchemy_stub==null){
				return;
			}
			//スタブを持っていたら解放
			this._alchemy_stub.dispose(this._alchemy_ptr);

			this._alchemy_stub=null;
			this._alchemy_ptr =0;
			return;
		}
		
		public final function attachAlchemyObject(i_alchemy_stub:Object):void
		{
			//有効なオブジェクトしかアタッチできない。
			if(i_alchemy_stub==null){
				throw new Error("AlchemyClassProxy::attachAlchemyObject failed");
			}
			setAlchemyObject(i_alchemy_stub);
			//保持フラグをON
			this._has_alchemy_object=true;
			return;
		}

		//proxyの初期化
		public final function setAlchemyObject(i_alchemy_stub:Object):void
		{
			//既にアタッチ済みのオブジェクトにアタッチすることはできない。
			if(this._has_alchemy_object==true){
				throw new Error("AlchemyClassProxy::setAlchemyObject failed");
			}
			//参照をセットする。
			if(i_alchemy_stub!=null){
				this._alchemy_stub=i_alchemy_stub;
				this._alchemy_ptr=this._alchemy_stub.ptr;
			}else{
				this._alchemy_stub=null;
				this._alchemy_ptr=0;
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
