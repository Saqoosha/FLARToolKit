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
	import jp.nyatla.as3utils.*;
	/**
	 * ヒストグラムを格納するクラスです。
	 */
	public class FLARHistogram
	{
		/**
		 * サンプリング値の格納変数
		 */
		public var data:Vector.<int>;
		/**
		 * 有効なサンプリング値の範囲。[0-data.length-1]
		 */
		public var length:int;
		/**
		 * 有効なサンプルの総数 data[i]
		 */
		public var total_of_data:int;
		
		
		
		public function FLARHistogram(i_length:int)
		{
			this.data=new Vector.<int>(i_length);
			this.length=i_length;
			this.total_of_data=0;
		}
		/**
		 * 区間i_stからi_edまでの総データ数を返します。
		 * @param i_st
		 * @param i_ed
		 * @return
		 */
		public function getTotal(i_st:int,i_ed:int):int
		{
			NyAS3Utils.assert(i_st<i_ed && i_ed<this.length);
			var result:int=0;
			var s:Vector.<int>=this.data;
			for(var i:int=i_st;i<=i_ed;i++){
				result+=s[i];
			}
			return result;
		}
		/**
		 * 指定したi_pos未満サンプルを０にします。
		 * @param i_pos
		 */
		public function lowCut(i_pos:int):void
		{
			var s:int= 0;
			for(var i:int=0;i<i_pos;i++){
				s+=this.data[i];
				this.data[i]=0;
			}
			this.total_of_data-=s;
		}
		/**
		 * 指定したi_pos以上のサンプルを０にします。
		 * @param i_pos
		 */
		public function highCut(i_pos:int):void
		{
			var s:int=0;
			for(var i:int=this.length-1;i>=i_pos;i--){
				s+=this.data[i];
				this.data[i]=0;
			}
			this.total_of_data-=s;
		}
		/**
		 * 最小の値が格納されているサンプル番号を返します。
		 */
		public function getMinSample():int
		{
			var data:Vector.<int>=this.data;
			var ret:int=this.length-1;
			var min:int=data[ret];
			for(var i:int=this.length-2;i>=0;i--)
			{
				if(data[i]<min){
					min=data[i];
					ret=i;
				}
			}
			return ret;
		}
		/**
		 * サンプルの中で最小の値を返します。
		 * @return
		 */
		public function getMinData():int
		{
			return this.data[this.getMinSample()];
		}
		/**
		 * 平均値を計算します。
		 * @return
		 */
		public function getAverage():int
		{
			var sum:Number=0;
			for(var i:int=this.length-1;i>=0;i--)
			{
				sum+=this.data[i]*i;
			}
			return (int)(sum/this.total_of_data);
		}
		/**
		 * この関数は、ヒストグラムを初期化します。
		 */
		public function reset():void
		{
			var d:Vector.<int>=this.data;
			for(var i:int=this.length-1;i>=0;i--){
				d[i]=0;
			}
			this.total_of_data=0;
		}
	}


}