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
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARIntSize extends AlchemyClassProxy
	{	
		public function NyARIntSize(...args:Array)
		{
			switch(args.length){
			case 0:
				//function NyARIntSize()
				this.attachAlchemyObject(
					NyARToolkitAS3.cmodule.NyARIntSize_createInstance()
				);
				return;
			case 1:
				if(args[0] is CONST_BASECLASS)
				{
					//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function NyARIntSize(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
				break;
			}
			throw new Error("NyARIntSize");
		}
		/**
		 * Marshaling format
		 * [SET] w:int,h:int		 */
		public function setValue(i_argument:Marshal):void
		{
			i_argument.prepareCallAlchmy();
			this._alchemy_stub.setValue(this._alchemy_stub._native,i_argument);
			return;
		}
		/**
		 * Marshaling format
 		 * [GET] w:int,h:int
		 */
		public function getValue(o_argument:Marshal):void
		{
			o_argument.prepareCallAlchmy();
			this._alchemy_stub.getValue(this._alchemy_stub._native,o_argument);
			return;
		}
		
	}
}