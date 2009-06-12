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
 * 2009.06.11:nyatla
 * Branched for Alchemy version FLARToolKit.
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
 */

package org.libspark.flartoolkit.alchemy.core
{
	import jp.nyatla.nyartoolkit.as3.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.alchemy.*;
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.pickup.IFLARColorPatt;
	/**
	 * ARToolKitのマーカーコードを1個保持します。
	 * 
	 */
	public class FLxARCode implements IFLxAR
	{
		public var _ny:NyARCode;
		public function FLxARCode(i_width:int, 
								 i_height:int, 
								 i_markerPercentWidth:uint = 50, 
								 i_markerPercentHeight:uint = 50)
		{
			if (i_markerPercentHeight != 50 || i_markerPercentWidth != 50)
			{
				throw new FLARException("i_markerPercentHeight != 50 || i_markerPercentWidth != 50");
			}
			//bind AlchemyMaster class
			this._ny = NyARCode.createInstance(i_width, i_height);
			return;
		}
		public function dispose():void
		{
			//dispose AlchemyMaster class
			this._ny.dispose();
			this._ny = null;
			return;
		}

		
		public function get averageOfPattern():int { FLARException.notImplement(); return 0; }
		public function get markerPercentWidth():uint {FLARException.notImplement();return 0;}
		public function get markerPercentHeight():uint{FLARException.notImplement();return 0;}
		public function set markerPercentHeight(value:uint):void {FLARException.notImplement();return;}
		public function getPat():Array{FLARException.notImplement(); return null; }
		public function getPatPow():Array {FLARException.notImplement();return null;}
		public function getPatBW():Array{FLARException.notImplement();return null;}
		public function getPatPowBW():Array { FLARException.notImplement(); return null;}
		
		public function getWidth():int { FLARException.notImplement(); return -1;}

		public function getHeight():int {FLARException.notImplement(); return -1;}

		public function loadARPatt(i_stream:String):void
		{
			//call AlchemyMaster Class 
			this._ny.loadARPattFromFile(i_stream);
			return;
		}

		public function fromPattern(pattern:IFLARColorPatt):void{FLARException.notImplement();}
		public function toString():String{FLARException.notImplement(); return null; }
		private function generatePatFileString(pat:Array):String{FLARException.notImplement(); return null; }
	}
}