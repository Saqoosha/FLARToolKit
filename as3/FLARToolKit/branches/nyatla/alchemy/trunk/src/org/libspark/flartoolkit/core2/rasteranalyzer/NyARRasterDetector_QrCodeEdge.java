/* 
 * PROJECT: FLARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The FLARToolkit is Java version ARToolkit class library.
 * Copyright (C)2008 R.Iizuka
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
package org.libspark.flartoolkit.core2.rasteranalyzer;

import org.libspark.flartoolkit.FLARException;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.types.stack.*;
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.core.rasterreader.*;

/**
 * QRコードの4頂点候補を探そうとするクラス。
 * 未完成
 *
 */
public class FLARRasterDetector_QrCodeEdge
{
	private FLARIntRectStack _result;

	public FLARRasterDetector_QrCodeEdge(int i_result_max)
	{
		this._result = new FLARIntRectStack(i_result_max);
		return;
	}

	public FLARIntRectStack geResult()
	{
		return this._result;
	}

	private boolean check_w1(int i_w1)
	{
		return i_w1>=1;		
	}
	private boolean check_b1(int i_b1)
	{
		return i_b1 >= 2;		
	}
	private boolean check_w2(int i_b1,int i_w2)
	{
		int v=i_w2*100/i_b1;
		return (30<=v && v<=170);
	}
	private boolean check_b2(int i_b1,int i_b2)
	{
		int v=i_b2*100/i_b1;
		//条件:(b1)/2の2～4倍
		return (200<=v && v<=400);
	}
	private boolean check_w3(int i_w2,int i_w3)
	{
		int v=i_w3*100/i_w2;
		return (50<=v && v<=150);
	}
	private boolean check_b3(int i_b3,int i_b1)
	{
		int v=i_b3*100/i_b1;
		return (50<=v && v<=150);
	}	
	public void analyzeRaster(IFLARRaster i_input) throws FLARException
	{
		IFLARBufferReader buffer_reader=i_input.getBufferReader();
		assert (buffer_reader.isEqualBufferType(IFLARBufferReader.BUFFERFORMAT_INT2D_BIN_8));

		// 結果をクリア
		this._result.clear();

		FLARIntSize size = i_input.getSize();
		int x = 0;
		int w1, b1, w2, b2, w3, b3;
		w1 = b1 = w2 = b2 = w3 = b3 = 0;

		FLARIntRect item;
		int[] line;
		int s_pos, b2_spos,b3_spos;
		b2_spos=0;
		for (int y = size.h - 1-8; y >= 8; y--) {
			line = ((int[][]) buffer_reader.getBuffer())[y];
			x = size.w - 1;
			s_pos=0;
			int token_id=0;
			while(x>=0){
				switch(token_id){
				case 0:
					// w1の特定
					w1 = 0;
					for (; x >= 0; x--) {
						if (line[x] == 0) {
							// 検出条件確認:w1は2以上欲しいな。
							if (!check_w1(w1)) {
								// 条件不十分
								continue;
							}else{
								// 検出→次段処理へ
								token_id=1;
							}
							break;
						}
						w1++;
					}
					break;
				case 1:
					// b1の特定
					b1 = 0;
					s_pos = x;
					for (; x >= 0; x--) {
						if (line[x] > 0) {
							// 検出条件確認:b1は1以上欲しいな。
							if (!check_b1(b1)){
								//条件不十分→白検出からやり直し
								token_id=0;
							}else{
								// 検出→次段処理へ
								token_id=2;
							}
							break;
						}
						b1++;
					}
					break;
				case 2:
					// w2の特定
					w2 = 0;
					for (; x >= 0; x--) {
						if (line[x] == 0) {
							// 検出条件確認:w2*10/b1は80-120以上欲しいな。
							if (!check_w2(b1,w2)) {
								//条件不十分→w2→w1として、b1を解析
								w1=w2;
								token_id=1;
							}else{
								// 検出→次段処理へ
//								w1=w2;
//								token_id=11;
								token_id=3;
							}
							break;
						}
						w2++;
					}
					break;
				case 3:
					// b2の特定
					b2 = 0;
					b2_spos=x;
					for (; x >= 0; x--) {
						if (line[x] > 0){
							//条件:(w1+b1)/2の2～4倍

							if (!check_b2(b1,b2)) {
								// b2->b1と仮定して解析しなおす。
								if(check_w1(w2) && check_b1(b2)){
									w1 = w2;
									b1 = b2;
									s_pos=b2_spos;
									token_id=2;
								}else{
									
									token_id=0;
								}
							}else{
								// 検出→次段処理へ
//								token_id=10;
								token_id=4;
							}
							break;
						}
						b2++;
					}
					break;
				case 4:
					// w3の特定
					w3 = 0;
					for (; x >= 0; x--) {
						if (line[x] == 0){
							if (!check_w3(w2,w3)) {
								//w2→w1,b2->b1として解析しなおす。
								if(check_w1(w2) && check_b1(b2)){
									w1 = w2;
									b1 = b2;
									s_pos=b2_spos;
									token_id=2;
								}else{
									token_id=0;
								}
							}else{
								// 検出→次段処理へ
//								w1=w3;
//								token_id=10;
								token_id=5;
							}
							break;
						}
						w3++;
					}
					break;
				case 5:
					// b3の特定
					b3 = 0;
					b3_spos=x;
					for (; x >= 0; x--) {
						if (line[x] > 0) {
							// 検出条件確認
							if (!check_b3(b3,b1)) {
								if(check_w1(w2) && check_b1(b2)){
								//条件不十分→b3->b1,w3->w1として再解析
									w1=w3;
									b1=b3;
									s_pos=b3_spos;
									token_id=2;
								}else{
									token_id=0;
								}
							}else{
								// 検出→次段処理へ
								token_id=10;
							}
							break;
						}
						b3++;
					}
					break;
				case 10:
					/* コード特定→保管 */
					item = (FLARIntRect)this._result.prePush();
					item.x = x;
					item.y = y;
					item.w =s_pos-x;
					item.h=0;
					/* 最大個数？ */
					/* 次のコードを探す */
					token_id=0;
					break;
				default:
					throw new FLARException();
				}
			}
		}
		return;
	}
}
