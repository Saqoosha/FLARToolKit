/* 
 * PROJECT: NyARToolkit
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkit is Java version ARToolkit class library.
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
package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.util.ArrayUtil;

	/**
	 * typedef struct {
	 * 	int     area;
	 * 	double  pos[2];
	 * 	int     coord_num;
	 * 	int     x_coord[AR_CHAIN_MAX];
	 * 	int     y_coord[AR_CHAIN_MAX];
	 * 	int     vertex[5];
	 * } ARMarkerInfo2;
	 * 
	 */
	public class FLARMarker {
	    /**
	     * メモリブロックのサイズ(32*4=128kb)
	     */
	    private static const ALLOCATE_PAGE_SIZE:int = 256;
	    /**
	     * メモリブロックの初期サイズ
	     */
	    private static const INITIAL_SIZE:int = 1;
	    public var x_coord:Array = new Array(INITIAL_SIZE);//int[]	x_coord=new int[INITIAL_SIZE];
	    public var y_coord:Array = new Array(INITIAL_SIZE);//int[]	y_coord=new int[INITIAL_SIZE];
	    public var coord_num:int;
	    public var area:int;
	    public const pos:Array = new Array(2);
	    public const mkvertex:Array = new Array(5);
	    /**
	     * coordバッファをi_chain_num以上のサイズに再アロケートする。
	     * 内容の引継ぎは行われない。
	     * @param i_chain_num
	     */
	    private function reallocCoordArray(i_chain_num:int):void {
			if (x_coord.length < i_chain_num) {
			    //ALLOCATE_PAGE_SIZE単位で確保する。
			    var new_size:int = ((i_chain_num+ALLOCATE_PAGE_SIZE-1)/ALLOCATE_PAGE_SIZE)*ALLOCATE_PAGE_SIZE;
			    x_coord = new Array(new_size);//new int[new_size];
			    y_coord = new Array(new_size);//new int[new_size];
			    coord_num=0;
			}
	    }
	    
	    public function setCoordXY(i_v1:int, i_coord_num:int, i_xcoord:Array, i_ycoord:Array):void {
			//メモリの割り当て保障
			reallocCoordArray(i_coord_num + 1);
			//[A B C]を[B C A]に並べなおす。
			ArrayUtil.copy(i_xcoord, i_v1, x_coord, 0, i_coord_num-i_v1);
			ArrayUtil.copy(i_xcoord, 0, x_coord, i_coord_num-i_v1, i_v1);
//			System.arraycopy(i_xcoord, i_v1, x_coord, 0, i_coord_num-i_v1);
//			System.arraycopy(i_xcoord, 0, x_coord, i_coord_num-i_v1, i_v1);
			x_coord[i_coord_num] = x_coord[0];
			ArrayUtil.copy(i_ycoord, i_v1, y_coord, 0, i_coord_num-i_v1);
			ArrayUtil.copy(i_ycoord, 0, y_coord, i_coord_num-i_v1, i_v1);
//			System.arraycopy(i_ycoord, i_v1, y_coord, 0, i_coord_num-i_v1);
//			System.arraycopy(i_ycoord, 0, y_coord, i_coord_num-i_v1, i_v1);
			y_coord[i_coord_num] = y_coord[0];
			coord_num = i_coord_num + 1;
			return;
	//arGetContour関数から取り外した部分	
	//	int[]      wx=new int[v1];//new int[Config.AR_CHAIN_MAX];
	//	int[]      wy=new int[v1]; //new int[Config.AR_CHAIN_MAX];   
	//	for (i=0;i<v1;i++) {
	//	    wx[i] = marker_ref.x_coord[i];//wx[i] = marker_info2->x_coord[i];
	//	    wy[i] = marker_ref.y_coord[i];//wy[i] = marker_info2->y_coord[i];
	//	}
	//	for (i=0;i<marker_ref.coord_num-v1;i++) {//for (i=v1;i<marker_info2->coord_num;i++) {
	//	    marker_ref.x_coord[i] = marker_ref.x_coord[i+v1];//marker_info2->x_coord[i-v1] = marker_info2->x_coord[i];
	//	    marker_ref.y_coord[i] = marker_ref.y_coord[i+v1];//marker_info2->y_coord[i-v1] = marker_info2->y_coord[i];
	//	}
	//	for (i=0;i<v1;i++) {
	//	    marker_ref.x_coord[i-v1+marker_ref.coord_num] = wx[i];//marker_info2->x_coord[i-v1+marker_info2->coord_num] = wx[i];
	//	    marker_ref.y_coord[i-v1+marker_ref.coord_num] = wy[i];//marker_info2->y_coord[i-v1+marker_info2->coord_num] = wy[i];
	//	}
	//	marker_ref.x_coord[marker_ref.coord_num] = marker_ref.x_coord[0];//marker_info2->x_coord[marker_info2->coord_num] = marker_info2->x_coord[0];
	//	marker_ref.y_coord[marker_ref.coord_num] = marker_ref.y_coord[0];//marker_info2->y_coord[marker_info2->coord_num] = marker_info2->y_coord[0];
	//	marker_ref.coord_num++;//marker_info2->coord_num++;
	    }
	    
	    private const wk_checkSquare_wv1:FLARVertexCounter = new FLARVertexCounter();
	    private const wk_checkSquare_wv2:FLARVertexCounter = new FLARVertexCounter();
	    /**
	     * static int arDetectMarker2_check_square(int area, ARMarkerInfo2 *marker_info2, double factor)
	     * 関数の代替関数
	     * OPTIMIZED STEP [450->415]
	     * @param i_area
	     * @param i_factor
	     * @return
	     */
	    public function checkSquare(i_area:int, i_factor:Number, i_pos_x:Number, i_pos_y:Number):Boolean {
	    	const l_vertex:Array = mkvertex;
	    	const l_x_coord:Array = x_coord;
	    	const l_y_coord:Array = y_coord;
	    	const wv1:FLARVertexCounter = wk_checkSquare_wv1;
	    	const wv2:FLARVertexCounter = wk_checkSquare_wv2;
	    	var sx:int, sy:int;
	    	var dmax:int, d:int, v1:int;
	    	var v2:int;
	    	var i:int;
			
			const L_coord_num_m1:int = this.coord_num-1;
			dmax = 0;
			v1 = 0;
			sx = l_x_coord[0];//sx = marker_info2->x_coord[0];
			sy = l_y_coord[0];//sy = marker_info2->y_coord[0];
			for (i = 1; i < L_coord_num_m1; i++) {//for (i=1;i<marker_info2->coord_num-1;i++) {
	            d = (l_x_coord[i]-sx)*(l_x_coord[i]-sx)+ (l_y_coord[i]-sy)*(l_y_coord[i]-sy);
			    if (d > dmax) {
					dmax = d;
					v1 = i;
			    }
			}
		
			const thresh:Number = (i_area / 0.75) * 0.01 * i_factor;
		
			l_vertex[0] = 0;
		
			if (!wv1.getVertex(l_x_coord,l_y_coord, 0,  v1,thresh)) {	    //if (get_vertex(marker_info2->x_coord, marker_info2->y_coord, 0,  v1,thresh, wv1, &wvnum1) < 0) {
			    return false;
			}
			if (!wv2.getVertex(l_x_coord,l_y_coord,v1,L_coord_num_m1, thresh)) {//if (get_vertex(marker_info2->x_coord, marker_info2->y_coord,v1,  marker_info2->coord_num-1, thresh, wv2, &wvnum2) < 0) {
			    return false;
			}
		
			if (wv1.number_of_vertex==1 && wv2.number_of_vertex==1) {//if (wvnum1 == 1 && wvnum2 == 1) {
			    l_vertex[1] = wv1.vertex[0];
			    l_vertex[2] = v1;
			    l_vertex[3] = wv2.vertex[0];
			}else if (wv1.number_of_vertex>1 && wv2.number_of_vertex==0) {//}else if (wvnum1 > 1 && wvnum2 == 0) {
			    v2 = v1 / 2;
			    if (!wv1.getVertex(l_x_coord,l_y_coord,0,  v2, thresh)) {
					return false;
			    }
			    if (!wv2.getVertex(l_x_coord,l_y_coord,v2,  v1, thresh)) {
					return false;
			    }
			    if (wv1.number_of_vertex==1 && wv2.number_of_vertex==1) {
					l_vertex[1] = wv1.vertex[0];
					l_vertex[2] = wv2.vertex[0];
					l_vertex[3] = v1;
			    } else {
					return false;
			    }
			}else if (wv1.number_of_vertex==0 && wv2.number_of_vertex> 1) {
			    v2 = (v1 + this.coord_num-1) / 2;
		
			    if (!wv1.getVertex(l_x_coord,l_y_coord,v1, v2, thresh)) {
					return false;
			    }
			    if (!wv2.getVertex(l_x_coord,l_y_coord,v2,L_coord_num_m1, thresh)) {
					return false;
			    }
			    if (wv1.number_of_vertex==1 && wv2.number_of_vertex==1) {
					l_vertex[1] = v1;
					l_vertex[2] = wv1.vertex[0];
					l_vertex[3] = wv2.vertex[0];
			    } else {
					return false;
			    }
			} else {
			    return false;
			}
			l_vertex[4] =L_coord_num_m1;//この値使ってるの？
			//
			area   = i_area;
			pos[0] = i_pos_x;
			pos[1] = i_pos_y;
		//      marker_holder[marker_num2].pos[1] = wpos[i*2+1];	
			return true;
	    }
	            
	}
	
}


/**
 * get_vertex関数を切り離すためのクラス
 *
 */
class FLARVertexCounter {
	public var vertex:Array = new Array(10);
    public var number_of_vertex:int;
    private var thresh:Number;
    private var x_coord:Array;
    private var y_coord:Array;

    public function getVertex(i_x_coord:Array, i_y_coord:Array, st:int, ed:int, i_thresh:Number):Boolean {
		this.number_of_vertex = 0;
		this.thresh = i_thresh;
		this.x_coord = i_x_coord;
		this.y_coord = i_y_coord;
		return get_vertex(st, ed);
    }
    
    /**
     * static int get_vertex(int x_coord[], int y_coord[], int st,  int ed,double thresh, int vertex[], int *vnum)
     * 関数の代替関数
     * @param x_coord
     * @param y_coord
     * @param st
     * @param ed
     * @param thresh
     * @return
     */
    private function get_vertex(st:int, ed:int):Boolean {
    	var d:Number, dmax:Number;
    	var a:Number, b:Number, c:Number;
    	var i:int, v1:int = 0;
    	var lx_coord:Array = this.x_coord;
    	var ly_coord:Array = this.y_coord;       
        a = ly_coord[ed] - ly_coord[st];
        b = lx_coord[st] - lx_coord[ed];
        c = lx_coord[ed]*ly_coord[st] - ly_coord[ed]*lx_coord[st];
        dmax = 0;
        for (i = st+1; i < ed; i++) {
            d = a*lx_coord[i] + b*ly_coord[i] + c;
            if (d*d > dmax) {
        	dmax = d*d;
        	v1 = i;
            }
        }
        if (dmax/(a*a+b*b) > thresh) {
            if (!get_vertex(st,  v1)) {
        		return false;
            }
            if (number_of_vertex > 5) {
        		return false;
            }
            vertex[number_of_vertex] = v1;//vertex[(*vnum)] = v1;
            number_of_vertex++;//(*vnum)++;
        
            if (!get_vertex(v1,  ed)) {
               	return false;
            }
        }
        return true;
    }
    
}
