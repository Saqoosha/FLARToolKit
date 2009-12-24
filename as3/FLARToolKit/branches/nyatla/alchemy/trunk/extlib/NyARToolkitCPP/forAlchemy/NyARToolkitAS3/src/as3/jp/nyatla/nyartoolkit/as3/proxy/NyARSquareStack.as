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
	
	public class NyARSquareStack extends AlchemyClassProxy
	{	
		public function NyARSquareStack(...args:Array)
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
				}else{
					//function NyARSqureStack(length:int)
					this.attachAlchemyObject(
						NyARToolkitAS3.cmodule.NyARSquareStack_createInstance(int(args[0]))
					);
					return;
				}
				break;
			default:
				break;
			}
			throw new Error("NyARSquareStack");
		}
		public function getLength():int
		{
			return this._alchemy_stub.getLength(this._alchemy_stub._native);
		}
		public function getItem(i_index:int):NyARSquare
		{
			var sq:NyARSquare=new NyARSquare(NyARToolkitAS3.WRAPCLASS);
			sq.setAlchemyObject(this._alchemy_stub.getItem(this._alchemy_stub._native,i_index));
			return sq;
		}		
	}
}
