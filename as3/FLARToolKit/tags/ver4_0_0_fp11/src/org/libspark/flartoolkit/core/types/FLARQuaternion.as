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
package org.libspark.flartoolkit.core.types 
{
	import org.libspark.flartoolkit.core.types.matrix.FLARDoubleMatrix44;

	/**
	 * ...
	 * @author nyatla
	 */
	public class FLARQuaternion 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function setFromMatrix(i_mat:FLARDoubleMatrix44):void
		{
			// 最大成分を検索
			var elem0:Number = i_mat.m00 - i_mat.m11 - i_mat.m22 + 1.0;
			var elem1:Number = -i_mat.m00 + i_mat.m11 - i_mat.m22 + 1.0;
			var elem2:Number = -i_mat.m00 - i_mat.m11 + i_mat.m22 + 1.0;
			var elem3:Number = i_mat.m00 + i_mat.m11 + i_mat.m22 + 1.0;
			
			var v:Number = 0;
			var mult:Number = 0;
			
			if(elem0>elem1 && elem0>elem2 && elem0>elem3){
				v    = Math.sqrt(elem0) * 0.5;
				mult = 0.25 / v;
				this.x = v;
				this.y = ((i_mat.m10 + i_mat.m01) * mult);
				this.z = ((i_mat.m02 + i_mat.m20) * mult);
				this.w = ((i_mat.m21 - i_mat.m12) * mult);
			}else if(elem1>elem2 && elem1>elem3){
				v    = Math.sqrt(elem1) * 0.5;
				mult = 0.25 / v;
				this.x = ((i_mat.m10 + i_mat.m01) * mult);
				this.y = (v);
				this.z = ((i_mat.m21 + i_mat.m12) * mult);
				this.w = ((i_mat.m02 - i_mat.m20) * mult);
			}else if(elem2>elem3){
				v    = Math.sqrt(elem2) * 0.5;
				mult = 0.25 / v;
				this.x =((i_mat.m02 + i_mat.m20) * mult);
				this.y =((i_mat.m21 + i_mat.m12) * mult);
				this.z =(v);
				this.w =((i_mat.m10 - i_mat.m01) * mult);
			}else{
				v    = Math.sqrt(elem3) * 0.5;
				mult = 0.25 / v;
				this.x =((i_mat.m21 - i_mat.m12) * mult);
				this.y =((i_mat.m02 - i_mat.m20) * mult);
				this.z =((i_mat.m10 - i_mat.m01) * mult);
				this.w =v;
			}
			return;
		}
	}

}