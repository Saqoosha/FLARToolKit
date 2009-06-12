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
	
	public class NyARDoubleMatrix34 extends AlchemyClassProxy
	{
		public static function createInstance():NyARDoubleMatrix34
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			return new NyARDoubleMatrix34(NyARToolkitAS3._cmodule.NyARDoubleMatrix34_createInstance());
		}
		public function NyARDoubleMatrix34(i_alchemy_stub:Object)
		{
			this._alchemy_stub=i_alchemy_stub;
			this._alchemy_ptr=this._alchemy_stub.ptr;
			return;
		}
		//OK
		public function setValue(i_value:Array):void
		{
			var ma:Marshal=this._ma;
			ma.position=0;//MA:INIT POS
			for(var i:int=0;i<12;i++){
				ma.writeDouble(i_value[i]);
			}
			ma.position=0;//MA:INIT POS
			this._alchemy_stub.setValue(this._alchemy_ptr,ma);
			return;
		}
		//OK
		public function getValue(o_value:Array):void
		{
			var ma:Marshal=this._ma;
			ma.position=0;//MA:INIT POS
			this._alchemy_stub.getValue(this._alchemy_ptr,ma);
			ma.position=0;//MA:INIT POS
			for(var i:int=0;i<12;i++){
				o_value[i]=ma.readDouble();
			}
			return;
		}
		
	}
}
