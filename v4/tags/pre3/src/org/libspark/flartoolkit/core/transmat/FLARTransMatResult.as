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
package org.libspark.flartoolkit.core.transmat
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	public class FLARTransMatResult extends FLARDoubleMatrix44
	{
		/**
		 * 観測値とのずれを示すエラーレート値です。SetValueにより更新されます。
		 * {@link #has_value}がtrueの時に使用可能です。
		 */
		public var last_error:Number;

		/**
		 * この行列に1度でも行列をセットしたかを返します。
		 */
		public var has_value:Boolean = false;
		/**
		 * コンストラクタです。
		 */
		public function FLARTransMatResult()
		{
			this.m30=this.m31=this.m32=0;
			this.m33=1.0;
		}
		/**
		 * 平行移動量と回転行列をセットします。この関数は、IFLARTransmatインタフェイスのクラスが結果を保存するために使います。
		 * @param i_rot
		 * @param i_trans
		 */
		public function setValue_3(i_rot:FLARDoubleMatrix33,i_trans:FLARDoublePoint3d ,i_error:Number):void
		{
			this.m00=i_rot.m00;
			this.m01=i_rot.m01;
			this.m02=i_rot.m02;
			this.m03=i_trans.x;

			this.m10 =i_rot.m10;
			this.m11 =i_rot.m11;
			this.m12 =i_rot.m12;
			this.m13 =i_trans.y;

			this.m20 = i_rot.m20;
			this.m21 = i_rot.m21;
			this.m22 = i_rot.m22;
			this.m23 = i_trans.z;

			this.m30=this.m31=this.m32=0;
			this.m33=1.0;		
			this.has_value = true;
			this.last_error=i_error;
			return;
		}
	}

}