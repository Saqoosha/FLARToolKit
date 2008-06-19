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

package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.util.ArrayUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	[Event(name="complete",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]
	
	/**
	 * ARToolKitのマーカーコードを1個保持します。
	 *
	 */
	public class FLARCode extends EventDispatcher {
		
		private var pat:Array;//private int[][][][]	pat;//static int    pat[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
		private var patpow:Array;//private double[]		patpow=new double[4];//static double patpow[AR_PATT_NUM_MAX][4];
		private var patBW:Array;//private short[][][]	patBW;//static int    patBW[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
		private var patpowBW:Array;//private double[]		patpowBW=new double[4];//static double patpowBW[AR_PATT_NUM_MAX][4];	
		private var width:int;//private int width,height;
		private var height:int;
		
		public function getPat():Array {
			return pat;
		}
		
		public function getPatPow():Array {
			return patpow;
		}
		
		public function getPatBW():Array {
			return patBW;
		}
		
		public function getPatPowBW():Array {
			return patpowBW;
		}
		
		public function getWidth():int {
			return width;
		}
		
		public function getHeight():int {
			return height;
		}
	    
		public function FLARCode(i_width:int, i_height:int) {
			width = i_width;
			height = i_height;
			pat = ArrayUtil.createMultidimensionalArray(4, height, width, 3);//new int[4][height][width][3];//static int    pat[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
			patpow = new Array(4);
			patBW = ArrayUtil.createMultidimensionalArray(4, height, width);//new short[4][height][width];//static int    patBW[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
			patpowBW = new Array(4);
		}
	
	
		/**
		 * int arLoadPatt(const char *filename);
		 * ARToolKitのパターンファイルをロードする。
		 * @param filename
		 * @return
		 * @throws Exception
		 */
		public function loadFromARFile(filedata:String):void {
			var i:int, i1:int, i2:int, i3:int;
			var token:Array = filedata.match(/\d+/g);
			for (var h:int = 0; h < 4; h++) {
				var l:int = 0;
				for (i3 = 0; i3 < 3; i3++) {
					for (i2 = 0; i2 < height; i2++) {
						for (i1 = 0; i1 < width; i1++) {
							//数値のみ読み出す
							var val:int = parseInt(token.shift());
							if (isNaN(val)) {
								throw new Error();
							}
							var j:int = 255 - val;
							//標準ファイルのパターンはBGRでならんでるからRGBに並べなおす
							switch (i3) {
								case 0: pat[h][i2][i1][2] = j; break;
								case 1: pat[h][i2][i1][1] = j; break;
								case 2: pat[h][i2][i1][0] = j; break;
							}
							if (i3 == 0) {
								patBW[h][i2][i1]  = j;
							} else {
								patBW[h][i2][i1] += j;
							}
							if (i3 == 2) {
								patBW[h][i2][i1] /= 3;
							}
							l += j;
						}
					}
				}
			  
				l /= (height * width * 3);
				   
				var m:int = 0;
				for (i = 0; i < height; i++) {
					for (i2 = 0; i2 < width; i2++) {
						for (i3 = 0; i3 < 3; i3++) {
							pat[h][i][i2][i3] -= l;
							m += (pat[h][i][i2][i3] * pat[h][i][i2][i3]);
						}
					}
				}
				patpow[h] = Math.sqrt(m);
				if (patpow[h] == 0.0) {
					patpow[h] = 0.0000001;
				}
				
				m = 0;
				for (i = 0; i < height; i++) {
					for (i2 = 0; i2 < width; i2++) {
						patBW[h][i][i2] -= l;
						m += (patBW[h][i][i2]*patBW[h][i][i2]);
					}
				}
				patpowBW[h] = Math.sqrt(m);
				if (patpowBW[h] == 0.0) {
					patpowBW[h] = 0.0000001;
				}
			}
	    }
	    
		/**
		 * FLARColorPatt_O3インスタンスからパターンを作る
		 * @param	pattern
		 * @see FLARColorPatt_03
		 */
		public function fromPattern(pattern:FLARColorPatt_O3):void 
		{
			var patArray:Array = pattern.getPatArray();
			var l:int;
			var m:int;
			var mbw:int;

			l = 0;
			m = 0;
			mbw = 0;

			//幅・高さのチェック
			if (this.height != patArray.length || this.width != patArray[0].length) {
				throw new ArgumentError("パターンの幅・高さが、Codeの幅・高さと異なっています");
			}
			if (this.height != this.width) {
				throw new ArgumentError("正方形のインスタンスのみ有効です。");
			}
			for (var y:int = 0; y < this.height; y++) {//y : 行方向の添え字
				for (var x:int = this.width - 1; x >= 0 ; x--) {//x : 列方向の添え字
					patBW[0][this.height - 1 - x][y] = 0;
					patBW[1][this.height - 1 - y][this.width -1 - x] = 0;
					patBW[2][x][this.width - 1 - y] = 0;
					patBW[3][y][x] = 0;
					for (var c:int = 0; c < 3; c++) {//c : 色情報(0:R/1:G/2:B)
						//傾き情報(0:上/1:左/2:下/3:右)
						//全方向に1度に値を代入している
						var j:int = 255 - int(patArray[y][x][c]);

						pat[0][this.height - 1 - x][y][c] = j;
						pat[1][this.height - 1 - y][this.width - 1 - x][c] = j;
						pat[2][x][this.width - 1 - y][c] = j;
						pat[3][y][x][c] = j
						patBW[0][this.height - 1 - x][y] += j;
						patBW[1][this.height - 1 - y][this.width -1 - x] += j;
						patBW[2][x][this.width - 1 - y] += j;
						patBW[3][y][x] += j;
						l += j;
					}
					patBW[0][this.height - 1 - x][y] /= 3;
					patBW[1][this.height - 1 - y][this.width -1 - x] /= 3;
					patBW[2][x][this.width - 1 - y] /= 3;
					patBW[3][y][x] /= 3;
				}
			}
			l /= (this.width * this.height * 3);
			for (y = 0; y < this.height; y++) {
				for (x = 0; x < this.width; x++) {
					patBW[0][this.height - 1 - x][y] -= l;
					patBW[1][this.height - 1 - y][this.width - 1 - x] -= l;
					patBW[2][x][this.width - 1 - y] -= l;
					patBW[3][y][x] -= l;
					mbw += (patBW[3][y][x] * patBW[3][y][x]);
					for (c = 0; c < 3;c++) {
						pat[0][this.height - 1 - x][y][c] -= l;
						pat[1][this.height - 1 - y][this.width - 1 - x][c] -= l;
						pat[2][x][this.width - 1 - y][c] -= l;
						pat[3][y][x][c] -= l;
						m += (pat[3][y][x][c] * pat[3][y][x][c]);
					}
				}
			}
			patpow[0] = patpow[1] = patpow[2] = patpow[3] = m == 0 ? 0.0000001 : Math.sqrt(m);
			patpowBW[0] = patpowBW[1] = patpowBW[2] = patpowBW[3] = mbw == 0 ? 0.0000001 : Math.sqrt(mbw);
		}
		
		/**
		 * Load code pattern file from specified URL. 
		 * @param url Code pattern file's URL.
		 * 
		 */	    
		public function loadFromURL(url:String):void {
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadFile);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this._onLoadError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onLoadError);
			this._loader.load(new URLRequest(url));
		}
		private var _loader:URLLoader;
		
		private function _onLoadFile(e:Event):void {
			this.loadFromARFile(this._loader.data);
			this._loader.removeEventListener(Event.COMPLETE, this._onLoadFile);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this._onLoadError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._onLoadError);
			this._loader = null;
			this.dispatchEvent(e);
		}
		
		private function _onLoadError(e:Event):void {
			this.dispatchEvent(e);
		}
		
	}
	
}