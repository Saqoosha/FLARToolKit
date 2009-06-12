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
package jp.nyatla.nyartoolkit.as3{
	import jp.nyatla.alchemymaster.*;
	
	public class NyARRgbRaster extends AlchemyClassProxy
	{		
		public static const BYTE1D:int =0x00010000;
		public static const INT2D:int  =0x00020000;
		public static const SHORT1D:int=0x00030000;
		public static const INT1D:int  =0x00040000;
		public static const BUFFERFORMAT_INT1D_X8R8G8B8_32:int = INT1D|0x0102;
		public static const BUFFERFORMAT_BYTE1D_B8G8R8X8_32:int = BYTE1D|0x0101;
		public static const BUFFERFORMAT_BYTE1D_X8R8G8B8_32:int = BYTE1D|0x0102;
	}
}

