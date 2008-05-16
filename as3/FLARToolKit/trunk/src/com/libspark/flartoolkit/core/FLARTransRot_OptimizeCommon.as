package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.FLARException;
	
	public class FLARTransRot_OptimizeCommon implements IFLARTransRot {

		protected var number_of_vertex:int;
		protected var array:Array = new Array(3);//new double[9];
		protected var cparam:FLARParam;
		
	    public function initRotByPrevResult(i_prev_result:FLARTransMatResult):void {
			var prev_array:Array = i_prev_result.getArray();
			var pt:Array;
			const L_rot:Array = this.array;
			pt = prev_array[0];
			L_rot[0*3+0] = pt[0];
			L_rot[0*3+1] = pt[1];
			L_rot[0*3+2] = pt[2];
			pt = prev_array[1];
			L_rot[1*3+0] = pt[0];
			L_rot[1*3+1] = pt[1];
			L_rot[1*3+2] = pt[2];
			pt = prev_array[2];
			L_rot[2*3+0] = pt[0];
			L_rot[2*3+1] = pt[1];
			L_rot[2*3+2] = pt[2];
	    }
    
		public function getArray():Array {
			return this.array;
		}
		
		/**
		 * インスタンスを準備します。
		 * @param i_param
		 * nullを指定した場合、一部の関数が使用不能になります。
		 */
		public function FLARTransRot_OptimizeCommon(i_param:FLARParam, i_number_of_vertex:int) {
			number_of_vertex = i_number_of_vertex;
			cparam = i_param;
		}
		
		public function modifyMatrix(trans:Array, vertex:Array, pos2d:Array):Number {
			// do nothing;
			return 0;
		}
		
		public function initRot(marker_info:FLARSquare, i_direction:int):void {
			
		}
		
		private const wk_check_dir_world:Array = new Array(6);//new double[6];
		private const wk_check_dir_camera:Array = new Array(4);//new double[4];
		private const wk_check_dir_FLARMat:FLARMat = new FLARMat(3, 3);
		/**
		 * static int check_dir(double dir[3], double st[2], double ed[2],double cpara[3][4])
		 * Optimize:STEP[526->468]
		 * @param dir
		 * @param st
		 * @param ed
		 * @param cpara
		 * 
		 * @throws FLARException
		 */
		protected function check_dir(dir:Array, st:Array, ed:Array, cpara:Array):void {
			var h:Number;
			var i:Number, j:Number;
			
			var mat_a:FLARMat = this.wk_check_dir_FLARMat;//ここ、事前に初期化できそう
			var a_array:Array = mat_a.getArray();
			for (j = 0; j < 3; j++) {
			    for (i = 0; i < 3; i++) {
					a_array[j][i] = cpara[j*4+i];//m[j*3+i] = cpara[j][i];
			    }
			}
			//	JartkException.trap("未チェックのパス");
			mat_a.matrixSelfInv();
			var world:Array = wk_check_dir_world;//[2][3];
			//<Optimize>
			//world[0][0] = a_array[0][0]*st[0]*10.0+ a_array[0][1]*st[1]*10.0+ a_array[0][2]*10.0;//mat_a->m[0]*st[0]*10.0+ mat_a->m[1]*st[1]*10.0+ mat_a->m[2]*10.0;
			//world[0][1] = a_array[1][0]*st[0]*10.0+ a_array[1][1]*st[1]*10.0+ a_array[1][2]*10.0;//mat_a->m[3]*st[0]*10.0+ mat_a->m[4]*st[1]*10.0+ mat_a->m[5]*10.0;
			//world[0][2] = a_array[2][0]*st[0]*10.0+ a_array[2][1]*st[1]*10.0+ a_array[2][2]*10.0;//mat_a->m[6]*st[0]*10.0+ mat_a->m[7]*st[1]*10.0+ mat_a->m[8]*10.0;
			//world[1][0] = world[0][0] + dir[0];
			//world[1][1] = world[0][1] + dir[1];
			//world[1][2] = world[0][2] + dir[2];
			world[0] = a_array[0][0]*st[0]*10.0+ a_array[0][1]*st[1]*10.0+ a_array[0][2]*10.0;//mat_a->m[0]*st[0]*10.0+ mat_a->m[1]*st[1]*10.0+ mat_a->m[2]*10.0;
			world[1] = a_array[1][0]*st[0]*10.0+ a_array[1][1]*st[1]*10.0+ a_array[1][2]*10.0;//mat_a->m[3]*st[0]*10.0+ mat_a->m[4]*st[1]*10.0+ mat_a->m[5]*10.0;
			world[2] = a_array[2][0]*st[0]*10.0+ a_array[2][1]*st[1]*10.0+ a_array[2][2]*10.0;//mat_a->m[6]*st[0]*10.0+ mat_a->m[7]*st[1]*10.0+ mat_a->m[8]*10.0;
			world[3] = world[0] + dir[0];
			world[4] = world[1] + dir[1];
			world[5] = world[2] + dir[2];
			//</Optimize>
			
			var camera:Array = wk_check_dir_camera;//[2][2];
			for (i = 0; i < 2; i++) {
			    h = cpara[2*4+0] * world[i*3+0]+ cpara[2*4+1] * world[i*3+1]+ cpara[2*4+2] * world[i*3+2];
			    if (h == 0.0) {
					throw new FLARException();
			    }
			    camera[i*2+0] = (cpara[0*4+0] * world[i*3+0]+ cpara[0*4+1] * world[i*3+1]+ cpara[0*4+2] * world[i*3+2]) / h;
			    camera[i*2+1] = (cpara[1*4+0] * world[i*3+0]+ cpara[1*4+1] * world[i*3+1]+ cpara[1*4+2] * world[i*3+2]) / h;
			}
			//<Optimize>
			//v[0][0] = ed[0] - st[0];
			//v[0][1] = ed[1] - st[1];
			//v[1][0] = camera[1][0] - camera[0][0];
			//v[1][1] = camera[1][1] - camera[0][1];
			var v:Number = (ed[0]-st[0])*(camera[2]-camera[0])+(ed[1]-st[1])*(camera[3]-camera[1]);
			//</Optimize>
			if (v < 0) {//if (v[0][0]*v[1][0] + v[0][1]*v[1][1] < 0) {
			    dir[0] = -dir[0];
			    dir[1] = -dir[1];
			    dir[2] = -dir[2];
			}
		}
		
		/*int check_rotation(double rot[2][3])*/
		protected static function check_rotation(rot:Array):void {
			var v1:Array = new Array(3), v2:Array = new Array(3), v3:Array = new Array(3);
			var ca:Number, cb:Number, k1:Number, k2:Number, k3:Number, k4:Number;
			var a:Number, b:Number, c:Number, d:Number;
			var p1:Number, q1:Number, r1:Number;
			var p2:Number, q2:Number, r2:Number;
			var p3:Number, q3:Number, r3:Number;
			var p4:Number, q4:Number, r4:Number;
			var w:Number;
			var e1:Number, e2:Number, e3:Number, e4:Number;
			var f:int;
			
			v1[0] = rot[0][0];
			v1[1] = rot[0][1];
			v1[2] = rot[0][2];
			v2[0] = rot[1][0];
			v2[1] = rot[1][1];
			v2[2] = rot[1][2];
			v3[0] = v1[1]*v2[2] - v1[2]*v2[1];
			v3[1] = v1[2]*v2[0] - v1[0]*v2[2];
			v3[2] = v1[0]*v2[1] - v1[1]*v2[0];
			w = Math.sqrt(v3[0]*v3[0]+v3[1]*v3[1]+v3[2]*v3[2]);
			if (w == 0.0) {
			    throw new FLARException();
			}
			v3[0] /= w;
			v3[1] /= w;
			v3[2] /= w;
			
			cb = v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2];
			if (cb < 0) cb *= -1.0;
				ca = (Math.sqrt(cb+1.0) + Math.sqrt(1.0-cb)) * 0.5;
			
			if (v3[1]*v1[0] - v1[1]*v3[0] != 0.0) {
			    f = 0;
			}
			else {
			    if (v3[2]*v1[0] - v1[2]*v3[0] != 0.0) {
					w = v1[1]; v1[1] = v1[2]; v1[2] = w;
					w = v3[1]; v3[1] = v3[2]; v3[2] = w;
					f = 1;
			    }
			    else {
					w = v1[0]; v1[0] = v1[2]; v1[2] = w;
					w = v3[0]; v3[0] = v3[2]; v3[2] = w;
					f = 2;
			    }
			}
			if (v3[1]*v1[0] - v1[1]*v3[0] == 0.0) {
			    throw new FLARException();
			}
			k1 = (v1[1]*v3[2] - v3[1]*v1[2]) / (v3[1]*v1[0] - v1[1]*v3[0]);
			k2 = (v3[1] * ca) / (v3[1]*v1[0] - v1[1]*v3[0]);
			k3 = (v1[0]*v3[2] - v3[0]*v1[2]) / (v3[0]*v1[1] - v1[0]*v3[1]);
			k4 = (v3[0] * ca) / (v3[0]*v1[1] - v1[0]*v3[1]);
			
			a = k1*k1 + k3*k3 + 1;
			b = k1*k2 + k3*k4;
			c = k2*k2 + k4*k4 - 1;
			
			d = b*b - a*c;
			if (d < 0) {
			    throw new FLARException();
			}
			r1 = (-b + Math.sqrt(d))/a;
			p1 = k1*r1 + k2;
			q1 = k3*r1 + k4;
			r2 = (-b - Math.sqrt(d))/a;
			p2 = k1*r2 + k2;
			q2 = k3*r2 + k4;
			if (f == 1) {
			    w = q1; q1 = r1; r1 = w;
			    w = q2; q2 = r2; r2 = w;
			    w = v1[1]; v1[1] = v1[2]; v1[2] = w;
			    w = v3[1]; v3[1] = v3[2]; v3[2] = w;
			    f = 0;
			}
			if (f == 2) {
			    w = p1; p1 = r1; r1 = w;
			    w = p2; p2 = r2; r2 = w;
			    w = v1[0]; v1[0] = v1[2]; v1[2] = w;
			    w = v3[0]; v3[0] = v3[2]; v3[2] = w;
			    f = 0;
			}
			
			if (v3[1]*v2[0] - v2[1]*v3[0] != 0.0) {
			    f = 0;
			} else {
			    if (v3[2]*v2[0] - v2[2]*v3[0] != 0.0) {
				w = v2[1]; v2[1] = v2[2]; v2[2] = w;
				w = v3[1]; v3[1] = v3[2]; v3[2] = w;
				f = 1;
			    }
			    else {
				w = v2[0]; v2[0] = v2[2]; v2[2] = w;
				w = v3[0]; v3[0] = v3[2]; v3[2] = w;
				f = 2;
			    }
			}
			if (v3[1]*v2[0] - v2[1]*v3[0] == 0.0) {
			    throw new FLARException();
			}
			k1 = (v2[1]*v3[2] - v3[1]*v2[2]) / (v3[1]*v2[0] - v2[1]*v3[0]);
			k2 = (v3[1] * ca) / (v3[1]*v2[0] - v2[1]*v3[0]);
			k3 = (v2[0]*v3[2] - v3[0]*v2[2]) / (v3[0]*v2[1] - v2[0]*v3[1]);
			k4 = (v3[0] * ca) / (v3[0]*v2[1] - v2[0]*v3[1]);
			
			a = k1*k1 + k3*k3 + 1;
			b = k1*k2 + k3*k4;
			c = k2*k2 + k4*k4 - 1;
			
			d = b*b - a*c;
			if (d < 0) {
			    throw new FLARException();
			}
			r3 = (-b + Math.sqrt(d))/a;
			p3 = k1*r3 + k2;
			q3 = k3*r3 + k4;
			r4 = (-b - Math.sqrt(d))/a;
			p4 = k1*r4 + k2;
			q4 = k3*r4 + k4;
			if (f == 1) {
			    w = q3; q3 = r3; r3 = w;
			    w = q4; q4 = r4; r4 = w;
			    w = v2[1]; v2[1] = v2[2]; v2[2] = w;
			    w = v3[1]; v3[1] = v3[2]; v3[2] = w;
			    f = 0;
			}
			if (f == 2) {
			    w = p3; p3 = r3; r3 = w;
			    w = p4; p4 = r4; r4 = w;
			    w = v2[0]; v2[0] = v2[2]; v2[2] = w;
			    w = v3[0]; v3[0] = v3[2]; v3[2] = w;
			    f = 0;
			}
			
			e1 = p1*p3+q1*q3+r1*r3;
			if (e1 < 0) {
			    e1 = -e1;
			}
			e2 = p1*p4+q1*q4+r1*r4;
			if (e2 < 0) {
			    e2 = -e2;
			}
			e3 = p2*p3+q2*q3+r2*r3;
			if (e3 < 0) {
			    e3 = -e3;
			}
			e4 = p2*p4+q2*q4+r2*r4;
			if (e4 < 0) {
			    e4 = -e4;
			}
			if (e1 < e2) {
			    if (e1 < e3) {
					if (e1 < e4) {
					    rot[0][0] = p1;
					    rot[0][1] = q1;
					    rot[0][2] = r1;
					    rot[1][0] = p3;
					    rot[1][1] = q3;
					    rot[1][2] = r3;
					}
					else {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p4;
					    rot[1][1] = q4;
					    rot[1][2] = r4;
					}
				    }
				    else {
					if (e3 < e4) {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p3;
					    rot[1][1] = q3;
					    rot[1][2] = r3;
					}
					else {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p4;
					    rot[1][1] = q4;
					    rot[1][2] = r4;
					}
			    }
			}
			else {
			    if (e2 < e3) {
					if (e2 < e4) {
					    rot[0][0] = p1;
					    rot[0][1] = q1;
					    rot[0][2] = r1;
					    rot[1][0] = p4;
					    rot[1][1] = q4;
					    rot[1][2] = r4;
					}
					else {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p4;
					    rot[1][1] = q4;
					    rot[1][2] = r4;
					}
				    }
				    else {
					if (e3 < e4) {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p3;
					    rot[1][1] = q3;
					    rot[1][2] = r3;
					}
					else {
					    rot[0][0] = p2;
					    rot[0][1] = q2;
					    rot[0][2] = r2;
					    rot[1][0] = p4;
					    rot[1][1] = q4;
					    rot[1][2] = r4;
					}
			    }
			}
		}

		/**
		 * パラメタa,b,cからrotを計算してインスタンスに保存する。
		 * rotを1次元配列に変更
		 * Optimize:2008.04.20:STEP[253→186]
		 * @param a
		 * @param b
		 * @param c
		 * @param o_rot
		 */
		protected static function arGetRot(a:Number, b:Number, c:Number, o_rot:Array):void {
			var sina:Number, sinb:Number, sinc:Number;
			var cosa:Number, cosb:Number, cosc:Number;
			
			sina = Math.sin(a);
			cosa = Math.cos(a);
			sinb = Math.sin(b);
			cosb = Math.cos(b);
			sinc = Math.sin(c);
			cosc = Math.cos(c);
			//Optimize
			var CACA:Number, SASA:Number, SACA:Number, SASB:Number, CASB:Number, SACACB:Number;
			CACA   = cosa*cosa;
			SASA   = sina*sina;
			SACA   = sina*cosa;
			SASB   = sina*sinb;
			CASB   = cosa*sinb;
			SACACB = SACA*cosb;
			
			o_rot[0] = CACA*cosb*cosc+SASA*cosc+SACACB*sinc-SACA*sinc;
			o_rot[1] = -CACA*cosb*sinc-SASA*sinc+SACACB*cosc-SACA*cosc;
			o_rot[2] = CASB;
			o_rot[3] = SACACB*cosc-SACA*cosc+SASA*cosb*sinc+CACA*sinc;
			o_rot[4] = -SACACB*sinc+SACA*sinc+SASA*cosb*cosc+CACA*cosc;
			o_rot[5] = SASB;
			o_rot[6] = -CASB*cosc-SASB*sinc;
			o_rot[7] = CASB*sinc-SASB*cosc;
			o_rot[8] = cosb;
		}
		
		/**
		 * int arGetAngle(double rot[3][3], double *wa, double *wb, double *wc)
		 * Optimize:2008.04.20:STEP[481→433]
		 * @param rot
		 * 2次元配列を1次元化してあります。
		 * @param o_abc
		 * @return
		 */
		protected function arGetAngle(o_abc:Array):int {
			var a:Number, b:Number, c:Number, tmp:Number;
			var sina:Number, cosa:Number, sinb:Number, cosb:Number, sinc:Number, cosc:Number;
			var rot:Array = array;
			if (rot[8] > 1.0) {//<Optimize/>if (rot[2][2] > 1.0) {
			    rot[8] = 1.0;//<Optimize/>rot[2][2] = 1.0;
			}else if (rot[8] < -1.0) {//<Optimize/>}else if (rot[2][2] < -1.0) {
			    rot[8] = -1.0;//<Optimize/>rot[2][2] = -1.0;
			}
			cosb = rot[8];//<Optimize/>cosb = rot[2][2];
			b = Math.acos(cosb);
			sinb = Math.sin(b);
			if (b >= 0.000001 || b <= -0.000001) {
			    cosa = rot[2] / sinb;//<Optimize/>cosa = rot[0][2] / sinb;
			    sina = rot[5] / sinb;//<Optimize/>sina = rot[1][2] / sinb;
			    if (cosa > 1.0) {
				/* printf("cos(alph) = %f\n", cosa); */
				cosa = 1.0;
				sina = 0.0;
			    }
			    if (cosa < -1.0) {
				/* printf("cos(alph) = %f\n", cosa); */
				cosa = -1.0;
				sina =  0.0;
			    }
			    if (sina > 1.0) {
				/* printf("sin(alph) = %f\n", sina); */
				sina = 1.0;
				cosa = 0.0;
			    }
			    if (sina < -1.0) {
				/* printf("sin(alph) = %f\n", sina); */
				sina = -1.0;
				cosa =  0.0;
			    }
			    a = Math.acos(cosa);
			    if (sina < 0) {
				a = -a;
			    }
			    //<Optimize>
			    //sinc =  (rot[2][1]*rot[0][2]-rot[2][0]*rot[1][2])/ (rot[0][2]*rot[0][2]+rot[1][2]*rot[1][2]);
			    //cosc =  -(rot[0][2]*rot[2][0]+rot[1][2]*rot[2][1])/ (rot[0][2]*rot[0][2]+rot[1][2]*rot[1][2]);
			    tmp = (rot[2]*rot[2]+rot[5]*rot[5]);
			    sinc =  (rot[7]*rot[2]-rot[6]*rot[5])/ tmp;
			    cosc =  -(rot[2]*rot[6]+rot[5]*rot[7])/ tmp;
			    //</Optimize>
			
			    if (cosc > 1.0) {
				/* printf("cos(r) = %f\n", cosc); */
				cosc = 1.0;
				sinc = 0.0;
			    }
			    if (cosc < -1.0) {
				/* printf("cos(r) = %f\n", cosc); */
				cosc = -1.0;
				sinc =  0.0;
			    }
			    if (sinc > 1.0) {
				/* printf("sin(r) = %f\n", sinc); */
				sinc = 1.0;
				cosc = 0.0;
			    }
			    if (sinc < -1.0) {
				/* printf("sin(r) = %f\n", sinc); */
				sinc = -1.0;
				cosc =  0.0;
			    }
			    c = Math.acos(cosc);
			    if (sinc < 0) {
				c = -c;
			    }
			}else {
			    a = b = 0.0;
			    cosa = cosb = 1.0;
			    sina = sinb = 0.0;
			    cosc = rot[0];//<Optimize/>cosc = rot[0][0];
			    sinc = rot[1];//<Optimize/>sinc = rot[1][0];
			    if (cosc > 1.0) {
				/* printf("cos(r) = %f\n", cosc); */
				cosc = 1.0;
				sinc = 0.0;
			    }
			    if (cosc < -1.0) {
				/* printf("cos(r) = %f\n", cosc); */
				cosc = -1.0;
				sinc =  0.0;
			    }
			    if (sinc > 1.0) {
				/* printf("sin(r) = %f\n", sinc); */
				sinc = 1.0;
				cosc = 0.0;
			    }
			    if (sinc < -1.0) {
				/* printf("sin(r) = %f\n", sinc); */
				sinc = -1.0;
				cosc =  0.0;
			    }
			    c = Math.acos(cosc);
			    if (sinc < 0) {
				c = -c;
			    }
			}
			o_abc[0]=a;//wa.value=a;//*wa = a;
			o_abc[1]=b;//wb.value=b;//*wb = b;
			o_abc[2]=c;//wc.value=c;//*wc = c;
			return 0;
		}    

	}
	
}