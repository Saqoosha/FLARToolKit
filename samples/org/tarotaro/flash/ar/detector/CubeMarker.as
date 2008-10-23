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
package org.tarotaro.flash.ar.detector 
{
	import org.libspark.flartoolkit.core.FLARCode;
	
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

		/**
		 * キューブ型マーカを新規作成
		 * @param	top
		 * @param	bottom
		 * @param	front
		 * @param	back
		 * @param	left
		 * @param	right
		 * @param	size
		 */
		public function CubeMarker(top:FLARCode = null,
									bottom:FLARCode = null,
									front:FLARCode = null,
									back:FLARCode = null,
									left:FLARCode = null,
									right:FLARCode = null,
									size:int = 80) 
		{
			this.top = top;
			this.bottom = bottom;
			this.front = front;
			this.back = back;
			this.left = left;
			this.right = right;
			this.size = size;
		}
		
		public function get top():FLARCode { return _top; }
		
		public function set top(value:FLARCode):void 
		{
			_top = value;
		}
		
		public function get bottom():FLARCode { return _bottom; }
		
		public function set bottom(value:FLARCode):void 
		{
			_bottom = value;
		}
		
		public function get front():FLARCode { return _front; }
		
		public function set front(value:FLARCode):void 
		{
			_front = value;
		}
		
		public function get back():FLARCode { return _back; }
		
		public function set back(value:FLARCode):void 
		{
			_back = value;
		}
		
		public function get left():FLARCode { return _left; }
		
		public function set left(value:FLARCode):void 
		{
			_left = value;
		}
		
		public function get right():FLARCode { return _right; }
		
		public function set right(value:FLARCode):void 
		{
			_right = value;
		}
		
		public function get size():int { return _size; }
		
		public function set size(value:int):void 
		{
			_size = value;
		}
		
	}
	
}