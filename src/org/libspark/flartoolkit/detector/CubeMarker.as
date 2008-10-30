/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 *
 */
package org.libspark.flartoolkit.detector {

	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.FLARException;
	
	/**
	 * キューブ型のマーカー
	 * @author 太郎(tarotaro.org)
	 */
	public class CubeMarker 
	{
		private var _top:FLARCode;
		private var _bottom:FLARCode;
		private var _front:FLARCode;
		private var _back:FLARCode;
		private var _left:FLARCode;
		private var _right:FLARCode;
		private var _size:int;
		private var _space:int;

		/**
		 * キューブ型マーカを新規作成
		 * @param	top
		 * @param	bottom
		 * @param	front
		 * @param	back
		 * @param	left
		 * @param	right
		 * @param	size
		 * @param	space
		 */
		public function CubeMarker(top:FLARCode,
									bottom:FLARCode = null,
									front:FLARCode = null,
									back:FLARCode = null,
									left:FLARCode = null,
									right:FLARCode = null,
									size:int = 80,
									space:int = 20 ) 
		{
			this.top = top;
			this.bottom = bottom;
			this.front = front;
			this.back = back;
			this.left = left;
			this.right = right;
			this.size = size;
			
			// 比較コードの解像度は全部同じかな？（違うとパターンを複数種つくらないといけないから）
			const cw:int = this.top.getWidth();
			const ch:int = this.top.getHeight();
			for (var key:Object in this) {
				var code:FLARCode = this[key] as FLARCode;
				if (code != null && code != this.top) {
					if (!this.checkResolution(this.top,code)) {
						// 違う解像度のが混ざっている。
						throw new FLARException("コード[" + key + "]の解像度が不正です。");
					}
				}
			}
		}

		private function checkResolution(src:FLARCode,dest:FLARCode):Boolean 
		{
			const cw:int = src.getWidth();
			const ch:int = src.getHeight();
			return (cw == dest.getWidth() && ch == dest.getHeight());
		}

		public function get top():FLARCode { return _top; }
		
		public function set top(value:FLARCode):void 
		{
			if (_top == null || this.checkResolution(_top, value)) _top = value;
			else throw new FLARException("コード[top]の解像度が不正です。");
		}
		
		public function get bottom():FLARCode { return _bottom; }
		
		public function set bottom(value:FLARCode):void 
		{
			if (_bottom == null || this.checkResolution(_bottom, value)) _bottom = value;
			else throw new FLARException("コード[bottom]の解像度が不正です。");
		}
		
		public function get front():FLARCode { return _front; }
		
		public function set front(value:FLARCode):void 
		{
			if (_front == null || this.checkResolution(_front, value)) _front = value;
			else throw new FLARException("コード[front]の解像度が不正です。");
		}
		
		public function get back():FLARCode { return _back; }
		
		public function set back(value:FLARCode):void 
		{
			if (_back == null || this.checkResolution(_back, value)) _back = value;
			else throw new FLARException("コード[back]の解像度が不正です。");
		}
		
		public function get left():FLARCode { return _left; }
		
		public function set left(value:FLARCode):void 
		{
			if (_left == null || this.checkResolution(_left, value)) _left = value;
			else throw new FLARException("コード[left]の解像度が不正です。");
		}
		
		public function get right():FLARCode { return _right; }
		
		public function set right(value:FLARCode):void 
		{
			if (_right == null || this.checkResolution(_right, value)) _right = value;
			else throw new FLARException("コード[right]の解像度が不正です。");
		}
		
		public function get size():int { return _size; }
		
		public function set size(value:int):void 
		{
			_size = value;
		}
		
	}
	
}