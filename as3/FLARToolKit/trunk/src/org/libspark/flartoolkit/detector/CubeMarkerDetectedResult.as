﻿/* 
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
 * --------------------------------------------------------------------------------
 * 
 * 
 */
package org.libspark.flartoolkit.detector 
{
	import org.libspark.flartoolkit.core.FLARSquare;
	
	/**
	 * キューブ方マーカ用Detectorの評価結果
	 * @author 太郎(tarotaro.org)
	 */
	public class CubeMarkerDetectedResult 
	{
		internal var _direction:int;
		internal var _confidence:Number;
		internal var _square:FLARSquare;
		internal var _markerDirection:String;
		
		public function get direction():int { return _direction; }
		
		public function get confidence():Number { return _confidence; }
		
		public function get square():FLARSquare { return _square; }
		
		public function set square(value:FLARSquare):void 
		{
			_square = value;
		}
		
		public function get markerDirection():String { return _markerDirection; }
		
		public function set markerDirection(value:String):void 
		{
			_markerDirection = value;
		}
		
	}
	
}