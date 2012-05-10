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
package org.libspark.flartoolkit.core.types.matrix 
{
	public class FLARDoubleMatrix22 implements IFLARDoubleMatrix
	{
		public var m00:Number;
		public var m01:Number;
		public var m10:Number;
		public var m11:Number;
		/**
		 * 遅いからあんまり使わないでね。
		 */
		public function setValue(i_value:Vector.<Number>):void
		{
			this.m00=i_value[0];
			this.m01=i_value[1];
			this.m10=i_value[3];
			this.m11=i_value[4];
			return;
		}
		/**
		 * 遅いからあんまり使わないでね。
		 */
		public function getValue(o_value:Vector.<Number>):void
		{
			o_value[0]=this.m00;
			o_value[1]=this.m01;
			o_value[3]=this.m10;
			o_value[4]=this.m11;
			return;
		}
		public function inverse(i_src:FLARDoubleMatrix22):Boolean
		{
			var a11:Number,a12:Number,a21:Number,a22:Number;
			a11=i_src.m00;
			a12=i_src.m01;
			a21=i_src.m10;
			a22=i_src.m11;
			var det:Number=a11*a22-a12*a21;
			if(det==0){
				return false;
			}
			det=1/det;
			this.m00=a22*det;
			this.m01=-a12*det;
			this.m10=-a21*det;
			this.m11=a11*det;
			return true;
		}	
		/**
		 * この関数は、インスタンスに単位行列をロードします。
		 */
		public function loadIdentity():void
		{
			this.m00=this.m11=1;
			this.m01=
			this.m10=0;
		}
	}


}