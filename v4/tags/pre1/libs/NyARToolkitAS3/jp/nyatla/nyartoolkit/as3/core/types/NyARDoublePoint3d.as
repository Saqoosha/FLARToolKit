/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.types
{

	public class NyARDoublePoint3d
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		/**
		 * 配列ファクトリ
		 * @param i_number
		 * @return
		 */
		public static function createArray(i_number:int):Vector.<NyARDoublePoint3d>
		{
			var ret:Vector.<NyARDoublePoint3d>=new Vector.<NyARDoublePoint3d>(i_number);
			for(var i:int=0;i<i_number;i++)
			{
				ret[i]=new NyARDoublePoint3d();
			}
			return ret;
		}
		public function setValue(i_in:NyARDoublePoint3d):void
		{
			this.x=i_in.x;
			this.y=i_in.y;
			this.z=i_in.z;
			return;
		}
		/**
		 * p2-p1間の距離の二乗値を計算します。
		 * @param i_p1
		 * @return
		 */	
		public function sqDist(i_p1:NyARDoublePoint3d):Number
		{
			var x:Number,y:Number,z:Number;
			x=this.x-i_p1.x;
			y=this.y-i_p1.y;
			z=this.z-i_p1.z;
			return x*x+y*y+z*z;
		}
		/**
		 * この関数は、頂点を移動します。
		 * @param i_tx
		 * 移動する距離x
		 * @param i_ty
		 * 移動する距離y
		 * @param i_tz
		 * 移動する距離z
		 */
		public function translate(i_tx:Number,i_ty:Number,i_tz:Number):void
		{
			this.x+=i_tx;
			this.y+=i_ty;
			this.z+=i_tz;
		}
	}
}