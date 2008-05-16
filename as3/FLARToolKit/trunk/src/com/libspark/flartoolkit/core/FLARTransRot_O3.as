package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.FLARException;
	import com.libspark.flartoolkit.util.ArrayUtil;
	
	public class FLARTransRot_O3 extends FLARTransRot_OptimizeCommon {
		
	    public function FLARTransRot_O3(i_param:FLARParam, i_number_of_vertex:int) {
			super(i_param,i_number_of_vertex);
			if (i_number_of_vertex!=4) {
			    //4以外の頂点数は処理しない
			    throw new FLARException();
			}
	    }  
	    
	    //private double CACA,SASA,SACA,CA,SA;    
	    private const wk_initRot_wdir:Array = ArrayUtil.createMultidimensionalArray(3, 3);//new double[3][3];
	    /**
	     * int arGetInitRot(ARMarkerInfo *marker_info, double cpara[3][4], double rot[3][3])
	     * Optimize:2008.04.20:STEP[716→698]
	     * @param marker_info
	     * @param i_direction
	     * @param i_param
	     * @throws FLARException
	     */
	    public override function initRot(marker_info:FLARSquare, i_direction:int):void {
			var cpara:Array = cparam.get34Array();
			var wdir:Array = wk_initRot_wdir;//この関数で初期化される
			var w:Number, w1:Number, w2:Number, w3:Number;
			var dir:int;
			var j:int;
		
			dir = i_direction;
		
			for (j = 0; j < 2; j++) {
			    w1 = marker_info.line[(4-dir+j)%4][0] * marker_info.line[(6-dir+j)%4][1]- marker_info.line[(6-dir+j)%4][0] * marker_info.line[(4-dir+j)%4][1];
			    w2 = marker_info.line[(4-dir+j)%4][1] * marker_info.line[(6-dir+j)%4][2]- marker_info.line[(6-dir+j)%4][1] * marker_info.line[(4-dir+j)%4][2];
			    w3 = marker_info.line[(4-dir+j)%4][2] * marker_info.line[(6-dir+j)%4][0]- marker_info.line[(6-dir+j)%4][2] * marker_info.line[(4-dir+j)%4][0];
		
			    wdir[j][0] =  w1*(cpara[0*4+1]*cpara[1*4+2]-cpara[0*4+2]*cpara[1*4+1])+  w2*cpara[1*4+1]-  w3*cpara[0*4+1];
			    wdir[j][1] = -w1*cpara[0*4+0]*cpara[1*4+2]+  w3*cpara[0*4+0];
			    wdir[j][2] =  w1*cpara[0*4+0]*cpara[1*4+1];
			    w = Math.sqrt(wdir[j][0]*wdir[j][0]+ wdir[j][1]*wdir[j][1]+ wdir[j][2]*wdir[j][2]);
			    wdir[j][0] /= w;
			    wdir[j][1] /= w;
			    wdir[j][2] /= w;
			}
		
			//以下3ケースは、計算エラーのときは例外が発生する。
			check_dir(wdir[0], marker_info.sqvertex[(4-dir)%4],marker_info.sqvertex[(5-dir)%4], cpara);
		
			check_dir(wdir[1], marker_info.sqvertex[(7-dir)%4],marker_info.sqvertex[(4-dir)%4], cpara);
		
			check_rotation(wdir);
		
			wdir[2][0] = wdir[0][1]*wdir[1][2] - wdir[0][2]*wdir[1][1];
			wdir[2][1] = wdir[0][2]*wdir[1][0] - wdir[0][0]*wdir[1][2];
			wdir[2][2] = wdir[0][0]*wdir[1][1] - wdir[0][1]*wdir[1][0];
			w = Math.sqrt(wdir[2][0]*wdir[2][0]+ wdir[2][1]*wdir[2][1]+ wdir[2][2]*wdir[2][2]);
			wdir[2][0] /= w;
			wdir[2][1] /= w;
			wdir[2][2] /= w;
			var rot:Array = this.array;
			rot[0] = wdir[0][0];
			rot[3] = wdir[0][1];
			rot[6] = wdir[0][2];
			rot[1] = wdir[1][0];
			rot[4] = wdir[1][1];
			rot[7] = wdir[1][2];
			rot[2] = wdir[2][0];
			rot[5] = wdir[2][1];
			rot[8] = wdir[2][2];
			//</Optimize>    
	    }
	    
	    private const wk_arModifyMatrix_double1D:Array = ArrayUtil.createMultidimensionalArray(8, 3);//new double[8][3];
	    /**
	     * arGetRot計算を階層化したModifyMatrix
	     * 896
	     * @param nyrot
	     * @param trans
	     * @param vertex
	     * [m][3]
	     * @param pos2d
	     * [n][2]
	     * @return
	     * @throws FLARException
	     */
	    public override function modifyMatrix(trans:Array, vertex:Array, pos2d:Array):Number {
			var factor:Number;
			var a2:Number, b2:Number, c2:Number;
			var ma:Number = 0.0, mb:Number = 0.0, mc:Number = 0.0;
			var h:Number, x:Number, y:Number;
			var err:Number, minerr:Number = 0;
			var t1:int, t2:int, t3:int;
			var s1:int = 0, s2:int = 0, s3:int = 0;
		
			factor = 10.0*Math.PI/180.0;
			var rot0:Number, rot1:Number, rot3:Number, rot4:Number, rot6:Number, rot7:Number;
			var combo00:Number, combo01:Number, combo02:Number, combo03:Number;
			var combo10:Number, combo11:Number, combo12:Number, combo13:Number;
			var combo20:Number, combo21:Number, combo22:Number, combo23:Number;
			var combo02_2:Number, combo02_5:Number, combo02_8:Number, combo02_11:Number;
			var combo22_2:Number, combo22_5:Number, combo22_8:Number, combo22_11:Number;
			var combo12_2:Number, combo12_5:Number, combo12_8:Number, combo12_11:Number;
			//vertex展開
			var VX00:Number, VX01:Number, VX02:Number;
			var VX10:Number, VX11:Number, VX12:Number;
			var VX20:Number, VX21:Number, VX22:Number;
			var VX30:Number, VX31:Number, VX32:Number;
			var d_pt:Array;
			d_pt = vertex[0]; VX00 = d_pt[0]; VX01 = d_pt[1]; VX02 = d_pt[2];
			d_pt = vertex[1]; VX10 = d_pt[0]; VX11 = d_pt[1]; VX12 = d_pt[2];
			d_pt = vertex[2]; VX20 = d_pt[0]; VX21 = d_pt[1]; VX22 = d_pt[2];
			d_pt = vertex[3]; VX30 = d_pt[0]; VX31 = d_pt[1]; VX32 = d_pt[2];
			var P2D00:Number, P2D01:Number, P2D10:Number, P2D11:Number, P2D20:Number, P2D21:Number, P2D30:Number, P2D31:Number;
			d_pt = pos2d[0]; P2D00 = d_pt[0]; P2D01 = d_pt[1];
			d_pt = pos2d[1]; P2D10 = d_pt[0]; P2D11 = d_pt[1];
			d_pt = pos2d[2]; P2D20 = d_pt[0]; P2D21 = d_pt[1];
			d_pt = pos2d[3]; P2D30 = d_pt[0]; P2D31 = d_pt[1];
			var cpara:Array = cparam.get34Array();
			var CP0:Number, CP1:Number, CP2:Number,CP3:Number, CP4:Number, CP5:Number, CP6:Number, CP7:Number, CP8:Number, CP9:Number, CP10:Number;
			CP0 = cpara[0]; CP1 = cpara[1]; CP2 = cpara[2]; CP3 = cpara[3];
			CP4 = cpara[4]; CP5 = cpara[5]; CP6 = cpara[6]; CP7 = cpara[7];
			CP8 = cpara[8]; CP9 = cpara[9]; CP10 = cpara[10];
			combo03 = CP0 * trans[0]+ CP1 * trans[1]+ CP2 * trans[2]+ CP3;
			combo13 = CP4 * trans[0]+ CP5 * trans[1]+ CP6 * trans[2]+ CP7;
			combo23 = CP8 * trans[0]+ CP9 * trans[1]+ CP10 * trans[2]+ cpara[11];
			var CACA:Number, SASA:Number, SACA:Number, CA:Number, SA:Number;
			var CACACB:Number, SACACB:Number, SASACB:Number, CASB:Number, SASB:Number;
			var SACASC:Number, SACACBSC:Number, SACACBCC:Number, SACACC:Number;        
			const double1D:Array = this.wk_arModifyMatrix_double1D;
		
			const abc:Array      = double1D[0];
			const a_factor:Array = double1D[1];
			const sinb:Array     = double1D[2];
			const cosb:Array     = double1D[3];
			const b_factor:Array = double1D[4];
			const sinc:Array     = double1D[5];
			const cosc:Array     = double1D[6];
			const c_factor:Array = double1D[7];
			var w:Number, w2:Number;
			var wsin:Number, wcos:Number;
		
			arGetAngle(abc);//arGetAngle(rot, &a, &b, &c);
			a2 = abc[0];
			b2 = abc[1];
			c2 = abc[2];
			
			//comboの3行目を先に計算
			for (var i:int = 0; i < 10; i++) {
			    minerr = 1000000000.0;
			    //sin-cosテーブルを計算(これが外に出せるとは…。)
			    for (var j:int = 0; j < 3; j++) {
					w2=factor*(j-1);
					w= a2 + w2;
					a_factor[j]=w;
					w= b2 + w2;
					b_factor[j]=w;
					sinb[j]=Math.sin(w);
					cosb[j]=Math.cos(w);
					w= c2 + w2;
					c_factor[j]=w;
					sinc[j]=Math.sin(w);
					cosc[j]=Math.cos(w);
			    }
			    //
			    for (t1 = 0; t1 < 3; t1++) {
					SA = Math.sin(a_factor[t1]);
					CA = Math.cos(a_factor[t1]);
					//Optimize
					CACA=CA*CA;
					SASA=SA*SA;
					SACA=SA*CA;
					for (t2=0;t2<3;t2++) {
					    wsin=sinb[t2];
					    wcos=cosb[t2];
					    CACACB=CACA*wcos;
					    SACACB=SACA*wcos;
					    SASACB=SASA*wcos;
					    CASB=CA*wsin;
					    SASB=SA*wsin;
					    //comboの計算1
					    combo02 = CP0 * CASB+ CP1 * SASB+ CP2 * wcos;
					    combo12 = CP4 * CASB+ CP5 * SASB+ CP6 * wcos;
					    combo22 = CP8 * CASB+ CP9 * SASB+ CP10 * wcos;
			
					    combo02_2 =combo02 * VX02 + combo03;
					    combo02_5 =combo02 * VX12 + combo03;
					    combo02_8 =combo02 * VX22 + combo03;
					    combo02_11=combo02 * VX32 + combo03;
					    combo12_2 =combo12 * VX02 + combo13;
					    combo12_5 =combo12 * VX12 + combo13;
					    combo12_8 =combo12 * VX22 + combo13;
					    combo12_11=combo12 * VX32 + combo13;
					    combo22_2 =combo22 * VX02 + combo23;
					    combo22_5 =combo22 * VX12 + combo23;
					    combo22_8 =combo22 * VX22 + combo23;
					    combo22_11=combo22 * VX32 + combo23;	    
					    for (t3=0;t3<3;t3++) {
							wsin=sinc[t3];
							wcos=cosc[t3];			
							SACASC=SACA*wsin;
							SACACC=SACA*wcos;
							SACACBSC=SACACB*wsin;
							SACACBCC=SACACB*wcos;
				
							rot0 = CACACB*wcos+SASA*wcos+SACACBSC-SACASC;
							rot3 = SACACBCC-SACACC+SASACB*wsin+CACA*wsin;
							rot6 = -CASB*wcos-SASB*wsin;
				
							combo00 = CP0 * rot0+ CP1 * rot3+ CP2 * rot6;
							combo10 = CP4 * rot0+ CP5 * rot3+ CP6 * rot6;
							combo20 = CP8 * rot0+ CP9 * rot3+ CP10 * rot6;
				
							rot1 = -CACACB*wsin-SASA*wsin+SACACBCC-SACACC;
							rot4 = -SACACBSC+SACASC+SASACB*wcos+CACA*wcos;
							rot7 = CASB*wsin-SASB*wcos;
							combo01 = CP0 * rot1+ CP1 * rot4+ CP2 * rot7;
							combo11 = CP4 * rot1+ CP5 * rot4+ CP6 * rot7;
							combo21 = CP8 * rot1+ CP9 * rot4+ CP10 * rot7;
							//
							err = 0.0;
							h  = combo20 * VX00+ combo21 * VX01+ combo22_2;
							x = P2D00 - (combo00 * VX00+ combo01 * VX01+ combo02_2) / h;
							y = P2D01 - (combo10 * VX00+ combo11 * VX01+ combo12_2) / h;
							err += x*x+y*y;
							h  = combo20 * VX10+ combo21 * VX11+ combo22_5;
							x = P2D10 - (combo00 * VX10+ combo01 * VX11+ combo02_5) / h;
							y = P2D11 - (combo10 * VX10+ combo11 * VX11+ combo12_5) / h;
							err += x*x+y*y;
							h  = combo20 * VX20+ combo21 * VX21+ combo22_8;
							x = P2D20 - (combo00 * VX20+ combo01 * VX21+ combo02_8) / h;
							y = P2D21 - (combo10 * VX20+ combo11 * VX21+ combo12_8) / h;
							err += x*x+y*y;
							h  = combo20 * VX30+ combo21 * VX31+ combo22_11;
							x = P2D30 - (combo00 * VX30+ combo01 * VX31+ combo02_11) / h;
							y = P2D31 - (combo10 * VX30+ combo11 * VX31+ combo12_11) / h;
							err += x*x+y*y;
							if (err < minerr) {
							    minerr = err;
							    ma = a_factor[t1];
							    mb = b_factor[t2];
							    mc = c_factor[t3];
							    s1 = t1-1;
							    s2 = t2-1;
							    s3 = t3-1;
							}
					    }
					}
			    }
			    if (s1 == 0 && s2 == 0 && s3 == 0) {
					factor *= 0.5;
			    }
			    a2 = ma;
			    b2 = mb;
			    c2 = mc;
			}
			arGetRot(ma, mb, mc, this.array);
			/*  printf("factor = %10.5f\n", factor*180.0/MD_PI); */
			return minerr / 4;
	    }                       
		
	}
	
}