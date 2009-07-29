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
	import cmodule.nyartoolkit.CLibInit;
	public class NyARToolkitAS3
	{
		public static const WRAPCLASS:CONST_WRAPCLASS=new CONST_WRAPCLASS();
		public static const BASECLASS:CONST_BASECLASS=new CONST_BASECLASS();
		
		public static const cmodule:Object=(new CLibInit()).init();
//		public static function initialize():void
//		{
//			trace('initialize');
//			if(NyARToolkitAS3.cmodule!=null)
//			{
//				return;
//			}
//			NyARToolkitAS3.cmodule=(new CLibInit()).init();
//		}
//		public static function finalize():void
//		{
//			//no work!
//		}
	}
}
