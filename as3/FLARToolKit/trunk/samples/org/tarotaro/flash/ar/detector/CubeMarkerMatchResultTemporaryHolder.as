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
	import org.libspark.flartoolkit.core.FLARSquare;

	/**
	 * キューブ型マーカの探索結果を一時的にためておくホルダ
	 */
	internal class CubeMarkerMatchResultTemporaryHolder {

		public var topConf:Number;
		public var bottomConf:Number;
		public var frontConf:Number;
		public var backConf:Number;
		public var leftConf:Number;
		public var rightConf:Number;

		public var topDir:int;
		public var bottomDir:int;
		public var frontDir:int;
		public var backDir:int;
		public var leftDir:int;
		public var rightDir:int;

		public var topSq:FLARSquare;
		public var bottomSq:FLARSquare;
		public var frontSq:FLARSquare;
		public var backSq:FLARSquare;
		public var leftSq:FLARSquare;
		public var rightSq:FLARSquare;

		private var _currentMaxConfidenceMarkerDirection:String;
		private var _currentMaxConfidence:Number;
		private var _currentMaxConfidenceDirection:int;
		private var _currentMaxConfidenceSquare:FLARSquare;

		/**
		 * 現在保持している一致度の中で、最も一致度が高い面を調べる。
		 * 結果は、currentMax～プロパティで保持する。
		 * @return
		 */
		public function checkMaxConfidenceDirection():void
		{
			trace("top:", topConf, "front:", frontConf, "back:", backConf, "left:", leftConf, "right:", rightConf);
			_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.TOP;
			_currentMaxConfidence = topConf;
			_currentMaxConfidenceDirection = topDir;
			_currentMaxConfidenceSquare = topSq;
			
			if (bottomConf > _currentMaxConfidence) {
				_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.BOTTOM;
				_currentMaxConfidence = bottomConf;
				_currentMaxConfidenceDirection = bottomDir;
				_currentMaxConfidenceSquare = bottomSq;
			}
			if (frontConf > _currentMaxConfidence) {
				_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.FRONT;
				_currentMaxConfidence = frontConf;
				_currentMaxConfidenceDirection = frontDir;
				_currentMaxConfidenceSquare = frontSq;
			}
			if (backConf > _currentMaxConfidence) {
				_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.BACK;
				_currentMaxConfidence = backConf;
				_currentMaxConfidenceDirection = backDir;
				_currentMaxConfidenceSquare = backSq;
			}
			if (leftConf > _currentMaxConfidence) {
				_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.LEFT;
				_currentMaxConfidence = leftConf;
				_currentMaxConfidenceDirection = leftDir;
				_currentMaxConfidenceSquare = leftSq;
			}
			if (rightConf > _currentMaxConfidence) {
				_currentMaxConfidenceMarkerDirection = CubeMarkerDirection.RIGHT;
				_currentMaxConfidence = rightConf;
				_currentMaxConfidenceDirection = rightDir;
				_currentMaxConfidenceSquare = rightSq;
			}
		}
		
		/**
		 * 保持している情報を全て消去する。
		 */
		public function reset():void
		{
			topConf = 0;
			bottomConf = 0;
			frontConf = 0;
			backConf = 0;
			leftConf = 0;
			rightConf = 0;

			topDir = 0;
			bottomDir = 0;
			frontDir = 0;
			backDir = 0;
			leftDir = 0;
			rightDir = 0;
		}
		/**
		 * 現在、最も一致度の高いマーカの面
		 */
		public function get currentMaxConfidenceMarkerDirection():String { return _currentMaxConfidenceMarkerDirection; }
		
		public function get currentMaxConfidence():Number { return _currentMaxConfidence; }
		
		public function get currentMaxConfidenceDirection():int { return _currentMaxConfidenceDirection; }
		
		public function get currentMaxConfidenceSquare():FLARSquare { return _currentMaxConfidenceSquare; }
	}
}