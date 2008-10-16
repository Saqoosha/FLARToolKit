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

package org.libspark.flartoolkit.core {
	import org.libspark.flartoolkit.utils.ArrayUtil;	

	/**
	 * ARToolKitのマーカーコードを1個保持します。
	 * 
	 */
	public class FLARCode {

		//	private int[][][][] pat;// static int
		// pat[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
		private var pat:Array;

		//	private double[] patpow = new double[4];// static double patpow[AR_PATT_NUM_MAX][4];
		private var patpow:Array = new Array(4);

		//	private short[][][] patBW;// static int patBW[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
		private var patBW:Array;

		//	private double[] patpowBW = new double[4];// static double patpowBW[AR_PATT_NUM_MAX][4];
		private var patpowBW:Array = new Array(4);

		private var width:int;
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
			//		pat = new int[4][height][width][3];// static int pat[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
			pat = ArrayUtil.createJaggedArray(4, height, width, 3);
			//		patBW = new short[4][height][width];// static int patBW[AR_PATT_NUM_MAX][4][AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3];
			patBW = ArrayUtil.createJaggedArray(4, height, width);
		}

		/**
		 * int arLoadPatt( const char *filename ); ARToolKitのパターンファイルをロードする。
		 * ファイル形式はBGR形式で記録されたパターンファイルであること。
		 * 
		 * @param filename
		 * @return
		 * @throws Exception
		 */
		//		public function loadARPattFromFile(filename:String):void {
		//			try {
		//				loadARPatt(new FileInputStream(filename));
		//			} catch (e:Error) {
		//				// throw new FLARException(e);
		//				throw e;
		//			}
		//		}

		/**
		 * 
		 * @param i_stream
		 * @throws FLARException
		 */
		public function loadARPatt(i_stream:String):void {
			//			try {
			//				var st:StreamTokenizer = new StreamTokenizer(new InputStreamReader(i_stream));
			var token:Array = i_stream.match(/\d+/g);
			// パターンデータはGBRAで並んでる。
			
			var h:int;
			var l:int = 0;
			var i3:int;
			var i2:int;
			var i1:int;
			var val:int;
			var j:int;
			for (h = 0;h < 4; h++) {
				
				for (i3 = 0;i3 < 3; i3++) {
					for (i2 = 0;i2 < height; i2++) {
						for (i1 = 0;i1 < width; i1++) {
							// 数値のみ読み出す
							val = parseInt(token.shift());
							if (isNaN(val)) {
								throw new Error();
							}
							//								switch (st.nextToken()) {// if( fscanf(fp, "%d",&j) != 1 ) {
							//									case StreamTokenizer.TT_NUMBER:
							//										break;
							//									default:
							//										throw new FLARException();
							//								}
							j = 255 - val;
							// j = 255-j;
							// 標準ファイルのパターンはBGRでならんでるからRGBに並べなおす
							switch (i3) {
								case 0:
									pat[h][i2][i1][2] = j;
									break;// pat[patno][h][(i2*Config.AR_PATT_SIZE_X+i1)*3+2]= j;break;
								case 1:
									pat[h][i2][i1][1] = j;
									break;// pat[patno][h][(i2*Config.AR_PATT_SIZE_X+i1)*3+1]= j;break;
								case 2:
									pat[h][i2][i1][0] = j;
									break;// pat[patno][h][(i2*Config.AR_PATT_SIZE_X+i1)*3+0]= j;break;
							}
							// pat[patno][h][(i2*Config.AR_PATT_SIZE_X+i1)*3+i3]= j;
							if (i3 == 0) {
								patBW[h][i2][i1] = j;// patBW[patno][h][i2*Config.AR_PATT_SIZE_X+i1] = j;
							} else {
								patBW[h][i2][i1] += j;// patBW[patno][h][i2*Config.AR_PATT_SIZE_X+i1] += j;
							}
							if (i3 == 2) {
								patBW[h][i2][i1] /= 3;// patBW[patno][h][i2*Config.AR_PATT_SIZE_X+i1]/= 3;
							}
							l += j;
						}
					}
				}

				l /= (height * width * 3);

				var m:int = 0;
				for (var i:int = 0;i < height; i++) {
					// for( i = 0; i < AR_PATT_SIZE_Y*AR_PATT_SIZE_X*3;i++ ) {
					for (i2 = 0;i2 < width; i2++) {
						for (i3 = 0;i3 < 3; i3++) {
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
				for (i = 0;i < height; i++) {
					for (i2 = 0;i2 < width; i2++) {
						patBW[h][i][i2] -= l;
						m += (patBW[h][i][i2] * patBW[h][i][i2]);
					}
				}
				patpowBW[h] = Math.sqrt(m);
				if (patpowBW[h] == 0.0) {
					patpowBW[h] = 0.0000001;
				}
			}
//			} catch (e:Error) {
//				//				throw new FLARException(e);
//				throw e;
//			}
		}
	}
}