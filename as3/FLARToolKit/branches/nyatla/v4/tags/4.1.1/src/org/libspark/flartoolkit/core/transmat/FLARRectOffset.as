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
	/**
	 * 矩形の頂点情報を格納します。
	 */
	final public class FLARRectOffset
	{
		public var vertex:Vector.<FLARDoublePoint3d>=FLARDoublePoint3d.createArray(4);
		public static function createArray(i_number:int):Vector.<FLARRectOffset>
		{
			var ret:Vector.<FLARRectOffset>=new Vector.<FLARRectOffset>(i_number);
			for(var i:int=0;i<i_number;i++)
			{
				ret[i]=new FLARRectOffset();
			}
			return ret;
		}	
		/**
		 * 中心位置と辺長から、オフセット情報を作成して設定する。
		 * @param i_width
		 */
		public function setSquare(i_width:Number):void
		{
			var w_2:Number = i_width / 2.0;
			
			var vertex3d_ptr:FLARDoublePoint3d;
			vertex3d_ptr= this.vertex[0];
			vertex3d_ptr.x = -w_2;
			vertex3d_ptr.y =  w_2;
			vertex3d_ptr.z = 0.0;
			vertex3d_ptr= this.vertex[1];
			vertex3d_ptr.x = w_2;
			vertex3d_ptr.y = w_2;
			vertex3d_ptr.z = 0.0;
			vertex3d_ptr= this.vertex[2];
			vertex3d_ptr.x =  w_2;
			vertex3d_ptr.y = -w_2;
			vertex3d_ptr.z = 0.0;
			vertex3d_ptr= this.vertex[3];
			vertex3d_ptr.x = -w_2;
			vertex3d_ptr.y = -w_2;
			vertex3d_ptr.z = 0.0;
			
			return;
		}
		/**
		 * 辺長から、オフセット情報を作成して設定します。
		 * 作成するオフセット情報は、マーカ中心を0,0としたi_width*i_heightのマーカです。
		 * @param i_width
		 * マーカの横サイズ(mm単位)
		 * @param i_height
		 * マーカの縦サイズ(mm単位)
		 */
		public function setSquare_2( i_width:Number , i_height:Number ):void
		{ 
			var w_2:Number = i_width / 2.0 ;
			var h_2:Number = i_height / 2.0 ;
			var vertex3d_ptr:FLARDoublePoint3d ;
			vertex3d_ptr = this.vertex[0] ;
			vertex3d_ptr.x = -w_2 ;
			vertex3d_ptr.y = h_2 ;
			vertex3d_ptr.z = 0.0 ;
			vertex3d_ptr = this.vertex[1] ;
			vertex3d_ptr.x = w_2 ;
			vertex3d_ptr.y = h_2 ;
			vertex3d_ptr.z = 0.0 ;
			vertex3d_ptr = this.vertex[2] ;
			vertex3d_ptr.x = w_2 ;
			vertex3d_ptr.y = -h_2 ;
			vertex3d_ptr.z = 0.0 ;
			vertex3d_ptr = this.vertex[3] ;
			vertex3d_ptr.x = -w_2 ;
			vertex3d_ptr.y = -h_2 ;
			vertex3d_ptr.z = 0.0 ;
			return  ;
		}
		
	}


}