﻿/* 
 * PROJECT: NyARToolkitCPP Alchemy bind
 * --------------------------------------------------------------------------------
 * The NyARToolkitCPP Alchemy bind is stub/proxy classes for NyARToolkitCPP and Adobe Alchemy.
 * 
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARRgbRaster_XRGB32 extends NyARRgbRaster
	{
		/**
		 * function NyARRgbRaster_XRGB32(i_width:int,i_height:int)
		 * 	AlchemyObjectを所有するインスタンスを作成します。
		 * function NyARRgbRaster_XRGB32(arg:CONST_BASECLASS) 
		 * 	継承用コンストラクタです。
		 */		
		public function NyARRgbRaster_XRGB32(...args:Array)
		{
			super(NyARToolkitAS3.BASECLASS);			
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}
				break;				
			case 2:
				//function NyARRgbRaster_XRGB32(i_width:int,i_height:int)
				this.attachAlchemyObject(
					NyARToolkitAS3._cmodule.NyARRgbRaster_XRGB32_createInstance(int(args[0]),int(args[1]))
				);
				return;
			default:
			}
			throw new Error();
		}		
/*		
		public static function createInstance(i_width:int,i_height:int):NyARRgbRaster_XRGB32
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			var inst:NyARRgbRaster_XRGB32=new NyARRgbRaster_XRGB32();
			inst.attachAlchemyObject(
				NyARToolkitAS3._cmodule.NyARRgbRaster_XRGB32_createInstance(i_width,i_height)
			);
			return inst;			
		}
*/
		//現在の位置からXRGB(BYTE)形式データを読み込みます。
		public function setByteArray(i_source:ByteArray):void
		{
			var old:int=i_source.position;
			this._alchemy_stub.setData(this._alchemy_ptr,i_source);
			i_source.position=old;
			return;
		}
		public function getByteArray(o_dest:ByteArray):void
		{
			var old:int=o_dest.position;
			this._alchemy_stub.getData(this._alchemy_ptr,o_dest);
			o_dest.position=old;
			return;
		}
	}
}
