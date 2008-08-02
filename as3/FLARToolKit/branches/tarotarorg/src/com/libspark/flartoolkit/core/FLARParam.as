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
	
	import com.libspark.flartoolkit.FLARException;
	import com.libspark.flartoolkit.util.DoubleValue;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]
	
	public class FLARParam extends EventDispatcher {
		
	    private static const SIZE_OF_PARAM_SET:int = 4+4+(3*4*8)+(4*8);
	    private static const PD_LOOP:int = 3;
	    protected var xsize:int;
	    protected var ysize:int;
	    private var array34:Array = new Array(3*4);
	    private var dist_factor:Array = new Array(4);
	    
	    public function FLARParam() {
	    	super();
	    }
	    
	    public function getX():int {
			return xsize;
	    }
	    
	    public function getY():int {
			return ysize;
	    }
	    
	    public function getDistFactor():Array {
			return dist_factor;
	    }
	    
	    /**
	     * パラメタを格納した[4x3]配列を返します。
	     * @return
	     */
	    public function get34Array():Array {
			return array34;
	    }
	    
	    /**
	     * ARToolKit標準ファイルから1個目の設定をロードする。
	     * @param i_filename
	     * @throws FLARException
	     */
	    public function loadFromARFile(i_stream:ByteArray):void {
            var new_inst:Array = arParamLoad(i_stream, 1);
            xsize = new_inst[0].xsize;
            ysize = new_inst[0].ysize;
            array34 = new_inst[0].array34;
            dist_factor = new_inst[0].dist_factor;
	    }
	    
	    private static function dot(a1:Number, a2:Number, a3:Number, b1:Number, b2:Number, b3:Number):Number {
	        return(a1 * b1 + a2 * b2 + a3 * b3);
	    }
	    
	    private static function norm(a:Number, b:Number, c:Number):Number {
	        return Math.sqrt(a*a + b*b + c*c);
	    }
	    
	    /**
	     * int  arParamDecompMat(double source[3][4], double cpara[3][4], double trans[3][4]);
	     * 関数の置き換え
	     * Optimize STEP[754->665]
	     * @param o_cpara
	     * 戻り引数。3x4のマトリクスを指定すること。
	     * @param o_trans
	     * 戻り引数。3x4のマトリクスを指定すること。
	     * @return
	     */
	    public function decompMat(o_cpara:FLARMat, o_trans:FLARMat):void {
			var source:Array = array34;
	        var Cpara:Array = new Array(3*4);//double    Cpara[3][4];
	        var rem1:Number, rem2:Number, rem3:Number;
	        var i:int;
	        if (source[2*4+3] >= 0) {//if (source[2][3] >= 0) {
	            //<Optimize>
	            //for (int r = 0; r < 3; r++) {
	            //    for (int c = 0; c < 4; c++) {
	            //        Cpara[r][c]=source[r][c];//Cpara[r][c] = source[r][c];
	            //    }
	            //}
	            for (i = 0; i < 12; i++) {
	                Cpara[i]=source[i];//Cpara[r][c] = source[r][c];
	            }
	            //</Optimize>
	        } else {
	            //<Optimize>
	            //for (int r = 0; r < 3; r++) {
	            //	for (int c = 0; c < 4; c++) {
	            //        Cpara[r][c]=-source[r][c];//Cpara[r][c] = -(source[r][c]);
	            //    }
	            //}
	            for (i=0;i<12;i++) {
	                Cpara[i]=source[i];//Cpara[r][c] = source[r][c];
	            }
	            //</Optimize>
	        }
	    
			var cpara:Array = o_cpara.getArray();
			var trans:Array = o_trans.getArray();
	        for (var r:int = 0; r < 3; r++) {
	            for (var c:int = 0; c < 4; c++) {
	                cpara[r][c]=0.0;//cpara[r][c] = 0.0;
	            }
	        }
	        cpara[2][2] = norm(Cpara[2*4+0], Cpara[2*4+1], Cpara[2*4+2]);//cpara[2][2] = norm(Cpara[2][0], Cpara[2][1], Cpara[2][2]);
	        trans[2][0] = Cpara[2*4+0] / cpara[2][2];//trans[2][0] = Cpara[2][0] / cpara[2][2];
	        trans[2][1] = Cpara[2*4+1] / cpara[2][2];//trans[2][1] = Cpara[2][1] / cpara[2][2];
	        trans[2][2] = Cpara[2*4+2] / cpara[2][2];//trans[2][2] = Cpara[2][2] / cpara[2][2];
	        trans[2][3] = Cpara[2*4+3] / cpara[2][2];//trans[2][3] = Cpara[2][3] / cpara[2][2];
	    	
	        cpara[1][2] = dot(trans[2][0], trans[2][1], trans[2][2],Cpara[1*4+0], Cpara[1*4+1], Cpara[1*4+2]);//cpara[1][2] = dot(trans[2][0], trans[2][1], trans[2][2],Cpara[1][0], Cpara[1][1], Cpara[1][2]);
	        rem1 = Cpara[1*4+0]- cpara[1][2] * trans[2][0];//rem1 = Cpara[1][0] - cpara[1][2] * trans[2][0];
	        rem2 = Cpara[1*4+1] - cpara[1][2] * trans[2][1];//rem2 = Cpara[1][1] - cpara[1][2] * trans[2][1];
	        rem3 = Cpara[1*4+2] - cpara[1][2] * trans[2][2];//rem3 = Cpara[1][2] - cpara[1][2] * trans[2][2];
	        cpara[1][1] = norm(rem1, rem2, rem3);//cpara[1][1] = norm(rem1, rem2, rem3);
	        trans[1][0] = rem1 / cpara[1][1];//trans[1][0] = rem1 / cpara[1][1];
	        trans[1][1] = rem2 / cpara[1][1];//trans[1][1] = rem2 / cpara[1][1];
	        trans[1][2] = rem3 / cpara[1][1];//trans[1][2] = rem3 / cpara[1][1];
	    
	        cpara[0][2] = dot(trans[2][0],trans[2][1], trans[2][2],Cpara[0*4+0], Cpara[0*4+1], Cpara[0*4+2]);//cpara[0][2] = dot(trans[2][0], trans[2][1], trans[2][2],Cpara[0][0], Cpara[0][1], Cpara[0][2]);
	        cpara[0][1] = dot(trans[1][0],trans[1][1], trans[1][2],Cpara[0*4+0], Cpara[0*4+1], Cpara[0*4+2]);//cpara[0][1] = dot(trans[1][0], trans[1][1], trans[1][2],Cpara[0][0], Cpara[0][1], Cpara[0][2]);
	        rem1 = Cpara[0*4+0]- cpara[0][1]*trans[1][0] - cpara[0][2]*trans[2][0];//rem1 = Cpara[0][0] - cpara[0][1]*trans[1][0] - cpara[0][2]*trans[2][0];
	        rem2 = Cpara[0*4+1] - cpara[0][1]*trans[1][1] - cpara[0][2]*trans[2][1];//rem2 = Cpara[0][1] - cpara[0][1]*trans[1][1] - cpara[0][2]*trans[2][1];
	        rem3 = Cpara[0*4+2] - cpara[0][1]*trans[1][2] - cpara[0][2]*trans[2][2];//rem3 = Cpara[0][2] - cpara[0][1]*trans[1][2] - cpara[0][2]*trans[2][2];
	        cpara[0][0] = norm(rem1, rem2, rem3);//cpara[0][0] = norm(rem1, rem2, rem3);
	        trans[0][0] = rem1 / cpara[0][0];//trans[0][0] = rem1 / cpara[0][0];
	        trans[0][1] = rem2 / cpara[0][0];//trans[0][1] = rem2 / cpara[0][0];
	        trans[0][2] = rem3 / cpara[0][0];//trans[0][2] = rem3 / cpara[0][0];
	    
	        trans[1][3] = (Cpara[1*4+3] - cpara[1][2]*trans[2][3]) / cpara[1][1];//trans[1][3] = (Cpara[1][3] - cpara[1][2]*trans[2][3]) / cpara[1][1];
	        trans[0][3] = (Cpara[0*4+3] - cpara[0][1]*trans[1][3]- cpara[0][2]*trans[2][3]) / cpara[0][0];//trans[0][3] = (Cpara[0][3] - cpara[0][1]*trans[1][3]- cpara[0][2]*trans[2][3]) / cpara[0][0];
	    
	        for (r = 0; r < 3; r++) {
	            for (c = 0; c < 3; c++) {
	            	cpara[r][c] /= cpara[2][2];//cpara[r][c] /= cpara[2][2];
	            }
	        }
	    }
	
	
	    /*int    arParamDisp(ARParam *param);*/
	    public function paramDisp():int {
	    	var out:String = '';
	    	out += "--------------------------------------\n";//printf("--------------------------------------\n");
	    	out += "SIZE = " + xsize + ", " + ysize + "\n";//printf("SIZE = %d, %d\n", param->xsize, param->ysize);
	    	out += "Distortion factor = " + dist_factor[0] + " " + dist_factor[1] + " " + dist_factor[2] + " "+dist_factor[3] + "\n";//printf("Distortion factor = %f %f %f %f\n", param->dist_factor[0],param->dist_factor[1], param->dist_factor[2], param->dist_factor[3]);
	    	for (var j:int = 0; j < 3; j++) {//for (j = 0; j < 3; j++) {
	    	    for (var i:int = 0; i < 4; i++) {
	    	    	out += array34[j*4+i] + " ";//printf("%7.5f ", param->mat[j][i]);
	    	    }
	    	    out += "\n";//System.out.println();//    printf("\n");
	    	}//}
	    	out += "--------------------------------------\n";//printf("--------------------------------------\n");
	    	trace(out);
	        return 0;
	    }
	    
	//    /*int  arParamDecomp(ARParam *source, ARParam *icpara, double trans[3][4]);*/
	//    private static int arParamDecomp(FLARParam source, FLARParam icpara, double[][] trans)
	//    {
	//        icpara.xsize          = source.xsize;//icpara->xsize          = source->xsize;
	//        icpara.ysize          = source.ysize;//icpara->ysize          = source->ysize;
	//        icpara.dist_factor[0] = source.dist_factor[0];//icpara->dist_factor[0] = source->dist_factor[0];
	//        icpara.dist_factor[1] = source.dist_factor[1];// icpara->dist_factor[1] = source->dist_factor[1];
	//        icpara.dist_factor[2] = source.dist_factor[2];//icpara->dist_factor[2] = source->dist_factor[2];
	//        icpara.dist_factor[3] = source.dist_factor[3];//icpara->dist_factor[3] = source->dist_factor[3];
	//        return arParamDecompMat(source.mat, icpara.mat, trans);
	//    }
	    /**
	     * int arParamChangeSize(ARParam *source, int xsize, int ysize, ARParam *newparam);
	     * 関数の代替関数
	     * サイズプロパティをi_xsize,i_ysizeに変更します。
	     * @param xsize
	     * @param ysize
	     * @param newparam
	     * @return
	     * 
	     */
	    public function changeSize(i_xsize:int, i_ysize:int):void {
	        var scale:Number;    
	        scale = i_xsize / xsize;//scale = (double)xsize / (double)(source->xsize);
	    
	        for (var i:int = 0; i < 4; i++) {
	            array34[0*4+i] = array34[0*4+i]*scale;//newparam->mat[0][i] = source->mat[0][i] * scale;
	            array34[1*4+i] = array34[1*4+i]*scale;//newparam->mat[1][i] = source->mat[1][i] * scale;
	            array34[2*4+i] = array34[2*4+i];//newparam->mat[2][i] = source->mat[2][i];
	        }
	    
	        dist_factor[0] = dist_factor[0] * scale;//newparam->dist_factor[0] = source->dist_factor[0] * scale;
	        dist_factor[1] = dist_factor[1] * scale;//newparam->dist_factor[1] = source->dist_factor[1] * scale;
	        dist_factor[2] = dist_factor[2] / (scale*scale);//newparam->dist_factor[2] = source->dist_factor[2] / (scale*scale);
	        dist_factor[3] = dist_factor[3];//newparam->dist_factor[3] = source->dist_factor[3];
	    
	        xsize = i_xsize;//newparam->xsize = xsize;
	        ysize = i_ysize;//newparam->ysize = ysize;
	    }
	    /**
	     * int arParamIdeal2Observ(const double dist_factor[4], const double ix, const double iy,double *ox, double *oy)
	     * 関数の代替関数
	     * @param ix
	     * @param iy
	     * @param ox
	     * @param oy
	     */
	    public function ideal2Observ(ix:Number, iy:Number, ox:DoubleValue, oy:DoubleValue):void {
			var x:Number, y:Number, d:Number;
			var d0:Number, d1:Number, d3:Number;
			const df:Array = this.dist_factor;
			d0 = df[0];
			d1 = df[1];
			d3 = df[3];
			x = (ix - d0) * d3;
			y = (iy - d1) * d3;
			if (x == 0.0 && y == 0.0) {
			    ox.value=d0;
			    oy.value=d1;
			} else{
			    d = 1.0 - df[2]/100000000.0 * (x*x+y*y);
			    ox.value=x * d + d0;
			    oy.value=y * d + d1;
			}
	    }
	    
	    /**
	     * ideal2Observをまとめて実行します。
	     * @param i_in
	     * double[][2]
	     * @param o_out
	     * double[][2]
	     */
	    public function ideal2ObservBatch(i_in:Array, o_out:Array, i_size:int):void {
			var x:Number, y:Number, d:Number;
			var d0:Number, d1:Number, d3:Number, d2_w:Number;
			var df:Array = this.dist_factor;
			d0 = df[0];
			d1 = df[1];
			d3 = df[3];
			d2_w = df[2] / 100000000.0;
			for (var i:int = 0; i < i_size; i++) {
	            x = (i_in[i][0] - d0) * d3;
	            y = (i_in[i][1] - d1) * d3;
	            if (x == 0.0 && y == 0.0) {
		        	o_out[i][0] = d0;
		        	o_out[i][1] = d1;
	            } else {
	                d = 1.0 - d2_w * (x*x+y*y);
	                o_out[i][0] = x * d + d0;
	                o_out[i][1] = y * d + d1;
	            }
			}
			return;
	    }    
	    
	    /**
	     * int arParamObserv2Ideal(const double dist_factor[4], const double ox, const double oy,double *ix, double *iy);
	     * 
	     * @param ox
	     * @param oy
	     * @param ix
	     * @param iy
	     * @return
	     */
	    public function observ2Ideal(ox:Number, oy:Number, ix:DoubleValue, iy:DoubleValue):int {
	    	var z02:Number, z0:Number, p:Number, q:Number, z:Number, px:Number, py:Number, opttmp_1:Number;
	    	var d0:Number, d1:Number, d3:Number;
	    	var df:Array = this.dist_factor;
			d0 = df[0];
			d1 = df[1];
	    	
	    	px = ox - d0;
	    	py = oy - d1;
	    	p = df[2]/100000000.0;
	    	z02 = px*px+py*py;
	    	q = z0 = Math.sqrt(z02);//Optimize//q = z0 = Math.sqrt(px*px+ py*py);
	    	
	    	for (var i:int = 1; ; i++) {
	            if (z0 != 0.0) {
	        	//Optimize opttmp_1
	        	opttmp_1=p*z02;
	                z = z0 - ((1.0 - opttmp_1)*z0 - q) / (1.0 - 3.0*opttmp_1);
	                px = px*z/z0;
	                py = py*z/z0;
	            } else {
	                px = 0.0;
	                py = 0.0;
	                break;
	            }
	            if (i == PD_LOOP) {
	                break;
	            }
	            z02 = px*px+ py*py;
	            z0 = Math.sqrt(z02);//Optimize//z0 = Math.sqrt(px*px+ py*py);
	    	}
	    	d3=df[3];
	    	ix.value=px / d3 + d0;
	    	iy.value=py / d3 + d1;
	    	return 0;
	    }
	    
	    /**
	     * 指定範囲のobserv2Idealをまとめて実行して、結果をo_idealに格納します。
	     * @param i_x_coord
	     * @param i_y_coord
	     * @param i_start
	     * 開始点
	     * @param i_num
	     * 計算数
	     * @param o_ideal
	     * 出力バッファ[i_num][2]であること。
	     */
	    public function observ2IdealBatch(i_x_coord:Array, i_y_coord:Array, i_start:int, i_num:int, o_ideal:Array):void {
	    	var z02:Number, z0:Number, q:Number, z:Number, px:Number, py:Number, opttmp_1:Number;
	    	var df:Array = this.dist_factor;
	    	var d0:Number = df[0];
	    	var d1:Number = df[1];
	    	var d3:Number = df[3];
	    	var p:Number = df[2] / 100000000.0;
	    	
			for (var j:int = 0; j < i_num; j++) {
		
			    px = i_x_coord[i_start+j] - d0;
			    py = i_y_coord[i_start+j] - d1;
		
			    z02 = px*px+py*py;
			    q = z0 = Math.sqrt(z02);//Optimize//q = z0 = Math.sqrt(px*px+ py*py);
		
			    for (var i:int = 1; ; i++) {
				if (z0 != 0.0) {
				    //Optimize opttmp_1
				    opttmp_1=p*z02;
				    z = z0 - ((1.0 - opttmp_1)*z0 - q) / (1.0 - 3.0*opttmp_1);
				    px = px*z/z0;
				    py = py*z/z0;
				} else {
				    px = 0.0;
				    py = 0.0;
				    break;
				}
				if (i == PD_LOOP) {
				    break;
				}
				z02 = px*px+ py*py;
				z0 = Math.sqrt(z02);//Optimize//z0 = Math.sqrt(px*px+ py*py);
			    }
			    o_ideal[j][0] = px / d3 + d0;
			    o_ideal[j][1] = py / d3 + d1;
			}	
	    }    
	    
	    /**
	     * int    arParamLoad(const char *filename, int num, ARParam *param, ...);
	     * i_streamの入力ストリームからi_num個の設定を読み込み、パラメタを配列にして返します。
	     * @param filename
	     * @param num
	     * @param param
	     * @return
	     * 	設定を格納した配列を返します。
	     * @throws Exception
	     * i_num個の設定が読み出せない場合、JartkExceptionを発生します。
	     */
	    private static function arParamLoad(i_stream:ByteArray, i_num:int):Array {
//	        try{
//	            var read_size:int = SIZE_OF_PARAM_SET * i_num;
//	            byte[] buf=new byte[read_size];
//	            i_stream.read(buf);
//	            //返却配列を確保
//	            FLARParam[] result=new FLARParam[i_num];
				var result:Array = new Array(i_num);
	            
	            //バッファを加工
//	            ByteBuffer bb = ByteBuffer.wrap(buf);
//	            bb.order(ByteOrder.BIG_ENDIAN);
				i_stream.endian = Endian.BIG_ENDIAN;
	    
	            //固定回数パースして配列に格納
	            for (var i:int = 0; i < i_num; i++) {
	                var new_param:FLARParam = new FLARParam();
	                new_param.xsize = i_stream.readInt();//bb.getInt();
	                new_param.ysize = i_stream.readInt();//bb.getInt();
	                for (var i2:int = 0; i2 < 3; i2++) {
	                    for (var i3:int = 0; i3 < 4; i3++) {
	                		new_param.array34[i2*4+i3] = i_stream.readDouble();//bb.getDouble();
	                    }
	                }
		    		for (i2 = 0; i2 < 4; i2++) {
						new_param.dist_factor[i2] = i_stream.readDouble();//bb.getDouble();
		    		}
		    		result[i] = new_param;
	            }
	            return result;
//	        } catch (Exception e) {
//	            throw new FLARException(e);
//	        }
	    }
	    
	    public static function arParamSave(filename:String, num:int, param:Array):int {
			FLARException.trap("未チェックの関数");
//			byte buf[]=new byte[SIZE_OF_PARAM_SET*param.length];
//			//バッファをラップ
//			ByteBuffer bb = ByteBuffer.wrap(buf);
//			bb.order(ByteOrder.BIG_ENDIAN);
//		
//			//書き込み
//			for (int i=0;i<param.length;i++) {
//		            bb.putInt(param[i].xsize);
//		            bb.putInt(param[i].ysize);
//		            for (int i2=0;i2<3;i2++) {
//		                for (int i3=0;i3<4;i3++) {
//		                    bb.putDouble(param[i].array34[i2*4+i3]);
//		                }
//		            }
//		                for (int i2=0;i2<4;i2++) {
//		                    bb.putDouble(param[i].dist_factor[i2]);
//		                }
//		            }
//			//ファイルに保存
//			FileOutputStream fs=new FileOutputStream(filename);
//			fs.write(buf);
//			fs.close();
			return 0;
	    }
	    
		/**
		 * Loads camera parameter file from specified URL. 
		 * @param url Camera parameter file's URL.
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
