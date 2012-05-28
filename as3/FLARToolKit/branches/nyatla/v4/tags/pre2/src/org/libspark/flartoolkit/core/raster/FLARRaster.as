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
package org.libspark.flartoolkit.core.raster 
{
	import jp.nyatla.as3utils.*;
	
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.types.*;

	/**このクラスは、単機能のFLARRasterです。
	 *
	 */
	public class FLARRaster extends FLARRaster_BasicClass
	{
		protected var _buf:Object;
		/**
		 * バッファオブジェクトがアタッチされていればtrue
		 */
		protected var _is_attached_buffer:Boolean;
		public function FLARRaster(...args:Array)
		{
			super(NyAS3Const_Inherited);
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 3:
				overload_FLARRaster3(int(args[0]), int(args[1]),int(args[2]));
				break;
			case 4:
				overload_FLARRaster4(int(args[0]), int(args[1]),int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new FLARException();
			}			
		}

		/**
		 * 指定したバッファタイプのラスタを作成します。
		 * @param i_width
		 * @param i_height
		 * @param i_buffer_type
		 * FLARBufferTypeに定義された定数値を指定してください。
		 * @param i_is_alloc
		 * @throws FLARException
		 */
		protected function overload_FLARRaster4(i_width:int, i_height:int, i_buffer_type:int, i_is_alloc:Boolean):void
		{
			super.overload_FLARRaster_BasicClass(i_width,i_height,i_buffer_type);
			if(!initInstance(this._size,i_buffer_type,i_is_alloc)){
				throw new FLARException();
			}
			return;
		}	

		protected function overload_FLARRaster3(i_width:int, i_height:int, i_buffer_type:int):void
		{
			super.overload_FLARRaster_BasicClass(i_width,i_height,i_buffer_type);
			if(!initInstance(this._size,i_buffer_type,true)){
				throw new FLARException();
			}
			return;
		}	
		protected function initInstance(i_size:FLARIntSize,i_buf_type:int,i_is_alloc:Boolean):Boolean
		{
			switch(i_buf_type)
			{
				case FLARBufferType.INT1D:
				case FLARBufferType.INT1D_X8R8G8B8_32:
					this._buf=i_is_alloc?new Vector.<int>(i_size.w*i_size.h):null;
					break;
				default:
					return false;
			}
			this._is_attached_buffer=i_is_alloc;
			return true;
		}
		public override function getBuffer():Object
		{
			return this._buf;
		}
		/**
		 * インスタンスがバッファを所有するかを返します。
		 * コンストラクタでi_is_allocをfalseにしてラスタを作成した場合、
		 * バッファにアクセスするまえに、バッファの有無をこの関数でチェックしてください。
		 * @return
		 */	
		public override function hasBuffer():Boolean
		{
			return this._buf!=null;
		}
		public override function wrapBuffer(i_ref_buf:Object):void
		{
			NyAS3Utils.assert(!this._is_attached_buffer);//バッファがアタッチされていたら機能しない。
			this._buf=i_ref_buf;
		}
		public override function createInterface(i_iid:Class):Object
		{
			// TODO Auto-generated method stub
			return null;
		}
	}	
 

}