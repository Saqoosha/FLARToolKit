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
 */

package org.libspark.flartoolkit.alchemy.core.param
{
	import org.libspark.flartoolkit.FLARException;
	import jp.nyatla.nyartoolkit.as3.*;
	import org.libspark.flartoolkit.alchemy.IFLxAR;
	import org.libspark.flartoolkit.core.FLARMat;
	import org.libspark.flartoolkit.core.types.matrix.FLARDoubleMatrix34;
	

	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class FLxARPerspectiveProjectionMatrix implements IFLxAR
	{
		public var _ny:NyARPerspectiveProjectionMatrix;
		private var _disposable:Boolean;
		public function FLxARPerspectiveProjectionMatrix(i_ref:NyARPerspectiveProjectionMatrix=null)
		{
			//create AlchemyMaster class
			if(i_ref==null){
				this._ny = NyARPerspectiveProjectionMatrix.createInstance();
				this._disposable = true;
			}else{
				this._ny = i_ref;
				this._disposable = false;
			}
			return;
		}
		public function dispose():void
		{
			//dispose AlchemyMaster class
			if(this._disposable){
				this._ny.dispose();
			}
			this._ny = null;
			return;
		}
		public function decompMat(o_cpara:FLARMat, o_trans:FLARMat):void
		{
			FLARException.notImplement();
		}

		public function changeScale(i_scale:Number):void
		{
			FLARException.notImplement();
		}
	}
}
