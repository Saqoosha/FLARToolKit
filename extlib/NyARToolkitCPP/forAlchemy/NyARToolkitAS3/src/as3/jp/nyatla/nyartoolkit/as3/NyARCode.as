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
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	
	public class NyARCode extends AlchemyClassProxy
	{
		public static function createInstance(i_width:int,i_height:int):NyARCode
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			return new NyARCode(NyARToolkitAS3._cmodule.NyARCode_createInstance(i_width,i_height));
		}
		public function NyARCode(i_alchemy_stub:Object)
		{
			this._alchemy_stub=i_alchemy_stub;
			this._alchemy_ptr=this._alchemy_stub.ptr;
			return;
		}
		//i_streamのカレント位置から読みだします。
		public function loadARPattFromFile(i_stream:String):void
		{
			var width:int=this._alchemy_stub.getWidth(this._alchemy_ptr);
			var height:int=this._alchemy_stub.getHeight(this._alchemy_ptr);
			
			var token:Array = i_stream.match(/\d+/g);
			var ma:Marshal=this._ma;
			ma.position=0;//MA:INIT POS
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
			ma.position=0;//MA:INIT POS
			this._alchemy_stub.loadARPatt(this._alchemy_ptr,ma);
			return;	
		}
		public function getPatPow(o_value:Array):void
		{
			var ma:Marshal=this._ma;
			ma.position=0;//MA:INIT POS
			this._alchemy_stub.getPatPow(this._alchemy_ptr,ma);
			ma.position=0;//MA:INIT POS
			for(var i:int=0;i<4;i++){
				o_value[i]=ma.readDouble();
			}
			return;
		}		
		public override function dispose():void
		{
			super.dispose();
			return;
		}
	}
}
