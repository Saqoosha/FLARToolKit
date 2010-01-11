/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.raster
{
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.*;	
	import jp.nyatla.nyartoolkit.as3.*;

	public class NyARBinRaster extends NyARRaster_BasicClass
	{
		protected var _buf:Object;
		protected var _buffer_reader:INyARBufferReader;

		public function NyARBinRaster(...args:Array)
		{
			super(new NyARIntSize(int(args[0]),int(args[1])));
			switch(args.length){
			case 2:
				{	//public function NyARBinRaster(i_width:int,i_height:int)
					if(!initInstance(this._size,INyARBufferReader.BUFFERFORMAT_INT1D_BIN_8)){
						throw new NyARException();
					}
					return;
				}
				break;
			case 3:
				{	//public function NyARBinRaster(i_width:int,i_height:int,i_raster_type:int)
					if(!initInstance(this._size,int(args[2]))){
						throw new NyARException();
					}	
					return;				
				}
				break;
			default:
				break;
			}
			throw new NyARException();
		}		

		public override function getBufferReader():INyARBufferReader 
		{
			return this._buffer_reader;
		}
		protected function initInstance(i_size:NyARIntSize,i_buf_type:int):Boolean
		{
			switch(i_buf_type)
			{
				case INyARBufferReader.BUFFERFORMAT_INT1D_BIN_8:
					this._buf = new Vector.<int>(i_size.w*i_size.h);
					this._buffer_reader=new NyARBufferReader(this._buf,INyARBufferReader.BUFFERFORMAT_INT1D_BIN_8);
					break;
				default:
					return false;
			}
			this._buffer_reader=new NyARBufferReader(this._buf,i_buf_type);
			return true;
		}	
	}


}