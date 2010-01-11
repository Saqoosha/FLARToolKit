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
	import jp.nyatla.nyartoolkit.as3.*;
	
	/**このクラスは、単機能のNyARRasterです。
	 * 特定タイプのバッファをラップする、INyARBufferReaderインタフェイスを提供します。
	 *
	 */
	public final class NyARRaster extends NyARRaster_BasicClass
	{
		protected var _reader:NyARBufferReader;
		protected var _buf:Object;
		
		public function NyARRaster(i_size:NyARIntSize, i_buf_type:int)
		{
			super(i_size);
			if(!initInstance(i_size,i_buf_type)){
				throw new NyARException();
			}
			return;
		}
		protected function initInstance(i_size:NyARIntSize,i_buf_type:int):Boolean
		{
			switch(i_buf_type)
			{
				case INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32:
					this._buf=new Vector.<int>(i_size.w*i_size.h);
					break;
				default:
					return false;
			}
			this._reader=new NyARBufferReader(this._buf,i_buf_type);
			return true;
		}
		public override function getBufferReader():INyARBufferReader
		{
			return this._reader;
		}	
	}

}