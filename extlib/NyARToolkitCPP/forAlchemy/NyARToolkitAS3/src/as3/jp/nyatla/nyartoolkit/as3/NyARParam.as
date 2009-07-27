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
		/**
		 * function NyARParam()
		 * 	AlchemyObjectを所有するインスタンスを作成します。
		 * function NyARParam(arg:CONST_BASECLASS) 
		 * 	継承用コンストラクタです。
		 */
		public function NyARParam(...args:Array)
		{
			//メンバオブジェクト
			this._screen_size=new NyARIntSize(NyARToolkitAS3.WRAPCLASS);
			this._projection_matrix=new NyARPerspectiveProjectionMatrix(NyARToolkitAS3.WRAPCLASS);
			//
			switch(args.length){
			case 0:
				//function NyARParam()
				this.attachAlchemyObject(
					NyARToolkitAS3._cmodule.NyARParam_createInstance()
				);
				return;
			case 1:
				//function NyARParam(i_class:CONST_BASECLASS)
				if(args[0] is CONST_BASECLASS)
				{	//Base Class
					return;
				}
				return;			
			default:
			}
			throw new Error();
		}
/*


		public static function createInstance():NyARParam
		{
			NyAS3Utils.assert(NyARToolkitAS3._cmodule!=null);
			var inst:NyARParam=new NyARParam();
			inst.attachAlchemyObject(
				NyARToolkitAS3._cmodule.NyARParam_createInstance()
				);
			return inst;
		}
		public override function setAlchemyObject(i_alchemy_stub:Object):void
		{
			super.setAlchemyObject(i_alchemy_stub);			

			return;
		}
*/

		public function changeScreenSize(i_xsize:int, i_ysize:int):void
		{
			this._alchemy_stub.changeScreenSize(this._alchemy_ptr,i_xsize,i_ysize);
			return;	
		}
		/**
		 * この関数の返すオブジェクトの寿命は、NyARParamと同期しています。
		 * NyARParamをdisposeした瞬間に、オブジェクトは正しい値を返さなくなります。注意してください。
		 */
		public function getPerspectiveProjectionMatrix():NyARPerspectiveProjectionMatrix
		{
			this._projection_matrix.setAlchemyObject(this._alchemy_stub.getPerspectiveProjectionMatrix(this._alchemy_ptr))
			return this._projection_matrix;
		}
		/**
		 * この関数の返すオブジェクトの寿命は、NyARParamと同期しています。
		 * NyARParamをdisposeした瞬間に、オブジェクトは正しい値を返さなくなります。注意してください。
		 */
		public function getScreenSize():NyARIntSize
		{
			this._screen_size.setAlchemyObject(this._alchemy_stub.getScreenSize(this._alchemy_ptr));
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
			this._projection_matrix=null;
			this._screen_size=null;
			super.dispose();
			return;
		}
	}
}
