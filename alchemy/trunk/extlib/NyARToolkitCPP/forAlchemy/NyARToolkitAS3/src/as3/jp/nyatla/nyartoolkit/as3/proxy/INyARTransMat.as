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
	
	public class INyARTransMat extends AlchemyClassProxy
	{	
		public function INyARTransMat(...args:Array)
		{
			switch(args.length){
			case 1:
				if(args[0] is CONST_BASECLASS)
				{
					//Base Class
					return;
				}else if(args[0] is CONST_WRAPCLASS){
					//function INyARTransMat(arg:CONST_WRAPCLASS)
					//Empty Wrapper
					return;
				}
				break;
			default:
			}
			throw new Error("INyARTransMat");
		}
		public function transMat(i_square:NyARSquare,i_direction:int,i_width:Number,o_result:NyARTransMatResult):void
		{
			this._alchemy_stub.transMat(
				this._alchemy_stub._native,
				i_square._alchemy_stub._native,
				i_direction,
				i_width,
				o_result._alchemy_stub._native);
			return;
		}

		public function transMatContinue(i_square:NyARSquare,i_direction:int,i_width:Number,o_result:NyARTransMatResult):void
		{
			this._alchemy_stub.transMat(
				this._alchemy_stub._native,
				i_square._alchemy_stub._native,
				i_direction,
				i_width,
				o_result._alchemy_stub._native);
			return;
		}		
	}
}