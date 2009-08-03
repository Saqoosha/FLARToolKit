/* 
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
package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARSingleDetectMarker extends AlchemyClassProxy
	{
		/**
		 * function NyARSingleDetectMarker(i_param:NyARParam,i_code:NyARCode,i_width:Number, i_raster_type:int)
		 * 	AlchemyObjectを所有するインスタンスを作成します。
		 * 	i_code,i_paramは生成したNyARSingleDetectMarkerをdisposeするまでの間、disposeしないでください。 		 * function NyARSingleDetectMarker(arg:CONST_BASECLASS) 
		 * 	継承用コンストラクタです。
		 */
		public function NyARSingleDetectMarker(...args:Array)
		{
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}
				break;				
			case 4:
				//function NyARRgbRaster_XRGB32(i_param:NyARParam,i_code:NyARCode,i_width:Number, i_raster_type:int)
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARSingleDetectMarker_createInstance(NyARParam(args[0])._alchemy_ptr,NyARCode(args[1])._alchemy_ptr,Number(args[2]),int(args[3]))
				);
				return;
			default:
			}
			throw new Error();
		}

		public function detectMarkerLite(i_raster:NyARRgbRaster,i_threshold:int):Boolean
		{
			return this._alchemy_stub.detectMarkerLite(this._alchemy_ptr,i_raster._alchemy_ptr,i_threshold);
		}
		public function getConfidence():Number
		{
			return this._alchemy_stub.getConfidence(this._alchemy_ptr);
		}
		public function getDirection():int
		{
			return this._alchemy_stub.getDirection(this._alchemy_ptr);
		}
		public function getTransformMatrix(o_result:NyARTransMatResult):void
		{
			this._alchemy_stub.getTransmationMatrix(this._alchemy_ptr,o_result._alchemy_ptr);
			return;
		}
		public function setContinueMode(i_is_continue:Boolean):void
		{
			this._alchemy_stub.setContinueMode(this._alchemy_ptr,i_is_continue?1:0);
			return;
		}
	}
}
