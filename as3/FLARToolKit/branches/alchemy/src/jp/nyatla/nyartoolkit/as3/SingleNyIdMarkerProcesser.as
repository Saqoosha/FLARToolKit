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
	
	public class SingleNyIdMarkerProcesser extends AlchemyClassProxy
	{
		private var _listener:SingleNyIdMarkerProcesserListener;
		private var _wrap_data:INyIdMarkerData;
		private var _wrap_sq:NyARSquare;
		private var _wrap_tramsmat:NyARTransMatResult;
		/**
		 * function NyIdMarkerDataEncoder_RawBit(param:NyARParam,encoder:INyIdMarkerDataEncoder,raster_type:int)
		 * 	AlchemyObjectを所有するインスタンスを作成します。
		 * function NyIdMarkerDataEncoder_RawBit(arg:CONST_BASECLASS,encoder:INyIdMarkerDataEncoder) 
		 * 	継承用コンストラクタです。
		 */						
		public function SingleNyIdMarkerProcesser(...args:Array)
		{
			this._wrap_sq=new NyARSquare(NyARToolkitAS3.WRAPCLASS);
			this._wrap_tramsmat=new NyARTransMatResult(NyARToolkitAS3.WRAPCLASS);				
			var encoder:INyIdMarkerDataEncoder;
			switch(args.length){
			case 2:
				if(args[0] is CONST_BASECLASS)
				{
					//Base Class
					encoder=INyIdMarkerDataEncoder(args[1]);
					this._wrap_data=encoder.createIdMarkerDataWrapper();
					return;
				}
				break;
			case 3:
				encoder=INyIdMarkerDataEncoder(args[1]);
				this._wrap_data=encoder.createIdMarkerDataWrapper();
				//function SingleNyIdMarkerProcesser(param:NyARParam,encoder:INyIdMarkerDataEncoder,)
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.SingleNyIdMarkerProcesser_createInstance(
					this,
					NyARParam(args[0])._alchemy_ptr,
					encoder._alchemy_ptr,
					int(args[2]))
				);
				return;
			default:
			}
			throw new Error();
		}		
		/*
		
		public static function createInstance(
			i_param:NyARParam,
			i_encoder:INyIdMarkerDataEncoder,
			i_raster_type:int):SingleNyIdMarkerProcesser
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			var inst:SingleNyIdMarkerProcesser=new SingleNyIdMarkerProcesser();
			inst.attachAlchemyObject(
				NyARToolkitAS3._cmodule.SingleNyIdMarkerProcesser_createInstance(
					inst,
					i_param._alchemy_ptr,
					i_encoder._alchemy_ptr,
					i_raster_type)
				);
			//クラス本体メンバを初期化している。このせいでクラスのfinal指定が掛かる。
			inst._wrap_data=i_encoder.createIdMarkerData();
			inst._wrap_sq=new NyARSquare();
			inst._wrap_tramsmat=new NyARTransMatResult();

			return inst;
		}*/
		public function setListener(i_listener:SingleNyIdMarkerProcesserListener):void
		{
			this._listener=i_listener;
		}
		public function setMarkerWidth(i_width:int):void
		{
			this._alchemy_stub.setMarkerWidth(this._alchemy_ptr,i_width);
			return;
		}
		public function reset(i_is_force:Boolean):void
		{
			this._alchemy_stub.reset(this._alchemy_ptr,i_is_force?1:0);
			return;
		}
		public function detectMarker(i_raster:NyARRgbRaster):void
		{
			this._alchemy_stub.detectMarker(this._alchemy_ptr,i_raster._alchemy_ptr);
			return;			
		}		
	
		public function onEnterHandler(i_param:Object):void
		{
			if(this._listener==null){
				return;
			}
			this._wrap_data.setAlchemyObject(i_param);
			this._listener.onEnterHandler(this._wrap_data);
			this._wrap_data.setAlchemyObject(null);
			
		}
		public function onLeaveHandler():void
		{
			if(this._listener==null){
				return;
			}
			this._listener.onLeaveHandler();
		}
		public function onUpdateHandler(i_param1:Object,i_param2:Object):void
		{
			if(this._listener==null){
				return;
			}
			this._wrap_sq.setAlchemyObject(i_param1);
			this._wrap_tramsmat.setAlchemyObject(i_param2);
			this._listener.onUpdateHandler(this._wrap_sq,this._wrap_tramsmat);
			this._wrap_sq.setAlchemyObject(null);
			this._wrap_tramsmat.setAlchemyObject(null);
		}
		public override function dispose():void
		{
			this._wrap_data.dispose();
			this._wrap_sq.dispose();
			this._wrap_tramsmat.dispose();

			super.dispose();
			return;
		}		
	}
}