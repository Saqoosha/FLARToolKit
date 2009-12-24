﻿/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 * 
 * 2009.06.11:nyatla
 * Branched for Alchemy version FLARToolKit.
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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package org.libspark.flartoolkit.alchemy.core
{
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import org.libspark.flartoolkit.FLARException;
	public class FLxARCode extends NyARCode
	{
		public var _ny:NyARCode;
		public function FLxARCode(i_width:int, 
								 i_height:int, 
								 i_markerPercentWidth:uint = 50, 
								 i_markerPercentHeight:uint = 50)
		{
			super(i_width,i_height);
			if (i_markerPercentHeight != 50 || i_markerPercentWidth != 50)
			{
				throw new FLARException("i_markerPercentHeight != 50 || i_markerPercentWidth != 50");
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