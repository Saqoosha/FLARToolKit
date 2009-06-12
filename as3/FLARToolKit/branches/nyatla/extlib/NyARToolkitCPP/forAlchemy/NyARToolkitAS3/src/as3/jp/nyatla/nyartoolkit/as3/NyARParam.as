/* 
 * PROJECT: NyARToolkitCPP Alchemy bind
 * --------------------------------------------------------------------------------
 * The NyARToolkitCPP Alchemy bind is stub/proxy classes for NyARToolkitCPP and Adobe Alchemy.
 * 
 * Copyright (C)2009 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	
	public class NyARParam extends AlchemyClassProxy
	{
		private var _projection_matrix:NyARPerspectiveProjectionMatrix;
		private var _screen_size:NyARIntSize;
		public static function createInstance():NyARParam
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			return new NyARParam(NyARToolkitAS3._cmodule.NyARParam_createInstance());
		}
		public function NyARParam(i_alchemy_stub:Object)
		{
			this._alchemy_stub=i_alchemy_stub;
			this._alchemy_ptr=this._alchemy_stub.ptr;
			this._screen_size=new NyARIntSize(this._alchemy_stub.getScreenSize(this._alchemy_ptr));
			this._projection_matrix=new NyARPerspectiveProjectionMatrix(this._alchemy_stub.getPerspectiveProjectionMatrix(this._alchemy_ptr));
			return;
		}

		public function changeScreenSize(i_xsize:int, i_ysize:int):void
		{
			this._alchemy_stub.changeScreenSize(this._alchemy_ptr,i_xsize,i_ysize);
			return;	
		}
		//リファレンスを返すので、disposeしないこと。
		public function getPerspectiveProjectionMatrix():NyARPerspectiveProjectionMatrix
		{
			return this._projection_matrix;
		}
		public function getScreenSize():NyARIntSize
		{
			return this._screen_size;
		}
		
		//OK
		//i_streamのカレント位置から読みだします。
		public function loadARParamFile(i_stream:ByteArray):void
		{
			var old_pos:int=i_stream.position;
			this._alchemy_stub.loadARParamFile(this._alchemy_ptr,i_stream);
			i_stream.position=old_pos;
			return;	
		}
		public override function dispose():void
		{
			this._projection_matrix.dispose();
			this._projection_matrix=null;
			this._screen_size.dispose();
			this._screen_size=null;
			super.dispose();
			return;
		}
	}
}
