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
package jp.nyatla.nyartoolkit.as3.proxy
{
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	
	public class NyARCode extends AlchemyClassProxy
	{
		/**
		 * function NyARCode(width:int,height:int)
		 * 	AlchemyObjectを所有するインスタンスを作成します。
		 * function NyARCode(arg:CONST_BASECLASS) 
		 * 	継承用コンストラクタです。
 		 * function NyARCode(arg:CONST_WRAPCLASS)
 		 * 	AlchemyObjectをラップするインスタンスを作成します。
		 */		
		public function NyARCode(...args:Array)
		{
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyARCode(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			case 2:
				//function NyARCode(width:int,height:int)
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARCode_createInstance(int(args[0]),int(args[1]))
				);
				return;
			default:
				break;
			}
			throw new Error("NyARCode");
		}
		//i_streamのカレント位置から読みだします。
		public function loadARPattFromFile(i_stream:String):void
		{
			var width:int=this._alchemy_stub.getWidth(this._alchemy_stub._native);
			var height:int=this._alchemy_stub.getHeight(this._alchemy_stub._native);
			
			var token:Array = i_stream.match(/\d+/g);
			var ma:Marshal=new Marshal();
			ma.prepareWrite();//データの投入準備
			var h:int;
			var i3:int;
			var i2:int;
			var i1:int;
			var val:int;
			for (h = 0;h < 4; h++) {
				for (i3 = 0;i3 < 3; i3++) {
					for (i2 = 0;i2 < height; i2++) {
						for (i1 = 0;i1 < width; i1++) {
							// 数値のみ読み出す
							val = parseInt(token.shift());
							if(isNaN(val)){
								throw new Error("syntax error in pattern file.");
							}
							ma.writeInt(val);
						}
					}
				}
			}
			ma.prepareCallAlchmy();//Alchemyのコール準備
			this._alchemy_stub.loadARPatt(this._alchemy_stub._native,ma);
			return;	
		}
		public function getWidth():int
		{
			return this._alchemy_stub.getWidth(this._alchemy_stub._native);
		}
		public function getHeight():int
		{
			return this._alchemy_stub.getHeight(this._alchemy_stub._native);
		}		
		public override function dispose():void
		{
			super.dispose();
			return;
		}
	}
}
