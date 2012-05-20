/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.markersystem 
{
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.core.param.*;
	import flash.utils.*;	
	public class FLARMarkerSystemConfig extends FLARMarkerSystemConfig_BaseClass_
	{
		public function FLARMarkerSystemConfig(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length){
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					break;
					//blank
				}else {
					this.FLARMarkerSystemConfig_1o(FLARParam(args[0]));
					break;
				}
				throw new FLARException();
			case 2:
				this.FLARMarkerSystemConfig_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				this.FLARMarkerSystemConfig_3oii(ByteArray(args[0]), int(args[1]),int(args[2]));
				break;
			default:
				throw new FLARException();
			}
		}		
		
	}

}