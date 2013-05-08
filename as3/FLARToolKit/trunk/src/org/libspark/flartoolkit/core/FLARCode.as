/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.core
{
	import jp.nyatla.as3utils.NyAS3Utils;
	
	import org.libspark.flartoolkit.core.match.FLARMatchPattDeviationBlackWhiteData;
	import org.libspark.flartoolkit.core.match.FLARMatchPattDeviationColorData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	/**
	 * ARToolKitのマーカーコードを1個保持します。
	 * 
	 */
	public class FLARCode
	{
		private var _color_pat:Vector.<FLARMatchPattDeviationColorData>=new Vector.<FLARMatchPattDeviationColorData>(4);
		private var _bw_pat:Vector.<FLARMatchPattDeviationBlackWhiteData>=new Vector.<FLARMatchPattDeviationBlackWhiteData>(4);
		private var _width:int;
		private var _height:int;
	
		public static function createFromARPattFile(i_stream:String,i_width:int,i_height:int):FLARCode
		{
			//ラスタにパターンをロードする。
			var ret:FLARCode=new FLARCode(i_width,i_height);
			FLARCodeFileReader.loadFromARToolKitFormFile(i_stream,ret);
			return ret;
		}		
		public function getColorData(i_index:int):FLARMatchPattDeviationColorData
		{
			return this._color_pat[i_index];
		}
		public function getBlackWhiteData(i_index:int):FLARMatchPattDeviationBlackWhiteData
		{
			return this._bw_pat[i_index];
		}
		public function getWidth():int
		{
			return _width;
		}

		public function getHeight():int
		{
			return _height;
		}
		public function FLARCode(i_width:int, i_height:int)
		{
			this._width = i_width;
			this._height = i_height;
			//空のラスタを4個作成
			for(var i:int=0;i<4;i++){
				this._color_pat[i]=new FLARMatchPattDeviationColorData(i_width,i_height);
				this._bw_pat[i]=new FLARMatchPattDeviationBlackWhiteData(i_width,i_height);
			}
			return;
		}
		/**
		 * 4枚のラスタから、マーカーパターンを生成して格納します。
		 * @param i_raster
		 * direction毎のパターンを格納したラスタ配列を指定します。
		 * ラスタは同一なサイズ、かつマーカーパターンと同じサイズである必要があります。
		 * 格納順は、パターンの右上が、1,2,3,4象限になる順番です。
		 * @throws FLARException
		 */
		public function setRaster(i_raster:Vector.<IFLARRgbRaster>):void
		{
			NyAS3Utils.assert(i_raster.length!=4);
			//ラスタにパターンをロードする。
			for(var i:int=0;i<4;i++){
				this._color_pat[i].setRaster(i_raster[i]);				
			}
			return;
		}
		/**
		 * inputStreamから、パターンデータをロードします。
		 * ロードするパターンのサイズは、現在の値と同じである必要があります。
		 * @param i_stream
		 * @throws FLARException
		 */
		public function setRaster_2(i_raster:IFLARRgbRaster):void
		{
			//ラスタにパターンをロードする。
			for(var i:int=0;i<4;i++){
				this._color_pat[i].setRaster_2(i_raster,i);
			}
			return;
		}
	}
}

import org.libspark.flartoolkit.core.FLARCode;
import org.libspark.flartoolkit.core.FLARException;
import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster;
import org.libspark.flartoolkit.core.types.FLARBufferType;
	
class FLARCodeFileReader
{
	/**
	 * ARコードファイルからデータを読み込んでo_codeに格納します。
	 * @param i_stream
	 * @param o_code
	 * @throws FLARException
	 */
	public static function loadFromARToolKitFormFile(i_stream:String,o_code:FLARCode):void
	{
		var width:int=o_code.getWidth();
		var height:int=o_code.getHeight();
		var tmp_raster:FLARRgbRaster=new FLARRgbRaster(width,height,FLARBufferType.INT1D_X8R8G8B8_32);
		//4個の要素をラスタにセットする。
		var token:Array = i_stream.match(/\d+/g);
		var buf:Vector.<int>=Vector.<int>(tmp_raster.getBuffer());
		//GBRAで一度読みだす。
		for (var h:int = 0; h < 4; h++){
			readBlock(token,width,height,buf);
			//ARCodeにセット(カラー)
			o_code.getColorData(h).setRaster(tmp_raster);
			o_code.getBlackWhiteData(h).setRaster(tmp_raster);
		}
		tmp_raster=null;//ポイ
		return;
	}
	 
	/**
	 * 1ブロック分のXRGBデータをi_stからo_bufへ読みだします。
	 * @param i_st
	 * @param o_buf
	 */
	private static function readBlock(i_st:Array, i_width:int, i_height:int, o_buf:Vector.<int>):void
	{
		var pixels:int = i_width * i_height;
		var i3:int;
		for (i3 = 0; i3 < 3; i3++) {
			for (var i2:int = 0; i2 < pixels; i2++){
				// 数値のみ読み出す
				var val:int = parseInt(i_st.shift());
				if(isNaN(val)){
					throw new FLARException("syntax error in pattern file.");
				}
				o_buf[i2]=(o_buf[i2]<<8)|((0x000000ff&(int)(val)));
			}
		}
		//GBR→RGB
		for(i3=0;i3<pixels;i3++){
			o_buf[i3]=((o_buf[i3]<<16)&0xff0000)|(o_buf[i3]&0x00ff00)|((o_buf[i3]>>16)&0x0000ff);
		}
		return;
	}
}
