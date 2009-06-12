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

package org.libspark.flartoolkit.alchemy.core.param
{
	import jp.nyatla.nyartoolkit.as3.*;
	import org.libspark.flartoolkit.FLARException;
	import org.libspark.flartoolkit.core.param.FLARPerspectiveProjectionMatrix;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	import org.libspark.flartoolkit.core.param.FLARCameraDistortionFactor;
	import org.libspark.flartoolkit.alchemy.*;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;	
	
	/**
	 * typedef struct { int xsize, ysize; double mat[3][4]; double dist_factor[4]; } ARParam;
	 * FLARの動作パラメータを格納するクラス
	 *
	 */
	public class FLxARParam implements IFLxAR
	{
		public var _ny:NyARParam;
		public function FLxARParam()
		{
			//create AlchemyMaster class
			this._ny = NyARParam.createInstance();
			return;
		}
		public function dispose():void
		{
			//dispose AlchemyMaster class
			this._ny.dispose();
			this._ny = null;
			return;
		}
		
		public function changeScreenSize(i_xsize:int, i_ysize:int):void
		{
			//call AlchemyMaster class
			this._ny.changeScreenSize(i_xsize,i_ysize);
			return;
		}
		public function loadARParam(i_stream:ByteArray):void
		{
			//call AlchemyMaster class
			this._ny.loadARParamFile(i_stream);
			return;
		}
		public function getPerspectiveProjectionMatrix():FLxARPerspectiveProjectionMatrix
		{
			//returned object has not unmanaged resource.
			return new FLxARPerspectiveProjectionMatrix(this._ny.getPerspectiveProjectionMatrix());
		}

		public function getScreenSize():FLARIntSize	{FLARException.notImplement(); return null; }
		public function getDistortionFactor():FLARCameraDistortionFactor{FLARException.notImplement(); return null; }
	}
}