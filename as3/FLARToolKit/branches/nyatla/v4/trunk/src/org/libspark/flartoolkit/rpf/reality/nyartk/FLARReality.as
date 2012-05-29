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
package org.libspark.flartoolkit.rpf.reality.nyartk 
{
	import org.libspark.flartoolkit.rpf.reality.nyartk.FLARReality;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;

	/**
	 * ...
	 * @author 
	 */
	public class FLARReality extends FLARReality_BaseClass_
	{
		
		public function FLARReality(...args:Array)
		{
			super(new NyAS3Const_Inherited());
			switch(args.length) {
			case 5:
				if((args[0] is FLARParam) && (args[1] is Number) && (args[2] is Number) && (args[3] is int) && (args[4] is int))
				{
					override_FLARReality(FLARParam(args[0]), Number(args[1]), Number(args[2]), int(args[3]), int(args[4]));
					return;
				}
				break;
			case 7:
				if ((args[0] is FLARIntSize) && (args[1] is Number) && (args[2] is Number) && (args[3] is FLARPerspectiveProjectionMatrix) && ((args[4] is FLARCameraDistortionFactor) || (args[4] == null)) && (args[5] is int) && (args[6] is int))
				{
					override_FLARReality_2(FLARIntSize(args[0]), Number(args[1]), Number(args[2]), FLARPerspectiveProjectionMatrix(args[3]), FLARCameraDistortionFactor(args[4]), int(args[5]), int(args[6]));
					return;
				}
			default:
				break;
			}
			throw new FLARException();			
		}
		
	}

}