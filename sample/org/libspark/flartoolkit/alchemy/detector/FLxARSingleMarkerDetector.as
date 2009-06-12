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

package org.libspark.flartoolkit.alchemy.detector
{
	import org.libspark.flartoolkit.alchemy.*;
	import org.libspark.flartoolkit.alchemy.core.*;
	import org.libspark.flartoolkit.alchemy.core.param.*;
	import org.libspark.flartoolkit.alchemy.core.raster.rgb.*;
	import org.libspark.flartoolkit.alchemy.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.IFLARRasterFilter_RgbToBin;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARSquareStack;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;

	/**
	 * 画像からARCodeに最も一致するマーカーを1個検出し、その変換行列を計算するクラスです。
	 * 
	 */
	public class FLxARSingleMarkerDetector implements IFLxAR
	{
		public var _ny:NyARSingleDetectMarker;
		
		
		/**
		 * 
		 * @param	i_param
		 * @param	i_code
		 * コンストラクタはi_codeのアンマネージオブジェクトの所有権を奪い、disposeします。
		 * 関数からもどったら、渡した変数に必ずnullを代入して、使わないでください。
		 * @param	i_marker_width
		 */
		public function FLxARSingleMarkerDetector(i_param:FLxARParam, i_code:FLxARCode, i_marker_width:Number)
		{
			this._ny = NyARSingleDetectMarker.createInstance(i_param._ny, i_code._ny, i_marker_width,NyARRgbRaster.BUFFERFORMAT_BYTE1D_X8R8G8B8_32);
			return;
		}
		public function dispose():void
		{
			//dispose AlchemyMaster class
			this._ny.dispose();
			this._ny = null;
			return;
		}
		
		
		
		
		
		public function get filter ():IFLARRasterFilter_RgbToBin { FLARException.notImplement(); return null; }
		public function set filter (f:IFLARRasterFilter_RgbToBin):void {FLARException.notImplement();}

		public function detectMarkerLite(i_raster:FLxARRgbRaster, i_threshold:int):Boolean
		{
			return this._ny.detectMarkerLite(i_raster._ny, i_threshold);
		}

		public function getTransformMatrix(o_result:FLxARTransMatResult):void
		{
			this._ny.getTransmationMatrix(o_result._ny);
			return;
		}

		public function getConfidence():Number
		{
			return this._ny.getConfidence();
		}
		public function getDirection():int
		{
			return this._ny.getDirection();
		}
		
		public function setContinueMode(i_is_continue:Boolean):void {FLARException.notImplement();}
		public function getSquare():FLARSquare{FLARException.notImplement();return null;}
		public function getSquareList():FLARSquareStack{FLARException.notImplement();return null;}
		public function get sizeCheckEnabled():Boolean { FLARException.notImplement(); return false; }
		public function set sizeCheckEnabled(value:Boolean):void {FLARException.notImplement();}
	}
}