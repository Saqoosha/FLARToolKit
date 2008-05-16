package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.FLARException;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FLARLabeling implements IFLARLabeling {

	    private static const WORK_SIZE:int = 1024*32;//#define WORK_SIZE   1024*32
//	    private var glabel_img:Array;//static ARInt16 l_imageL[HARDCODED_BUFFER_WIDTH*HARDCODED_BUFFER_HEIGHT];
	
//	    private const work_holder:FLARWorkHolder = new FLARWorkHolder(WORK_SIZE);
//	    private const label_holder:FLARLabelHolder = new FLARLabelHolder(WORK_SIZE);
		private const label_holder:Array = [];
	
	    private var label_num:int;
	    //
	    private var width:int;
	    private var height:int;
	    
	    private var label_img:BitmapData;
	    private var tmp_img:BitmapData;
	    
	    /**
	     * @param i_width
	     * ラベリング画像の幅。解析するラスタの幅より大きいこと。
	     * @param i_height
	     * ラベリング画像の高さ。解析するラスタの高さより大きいこと。
	     */
	    public function FLARLabeling(i_width:int, i_height:int) {
			width = i_width;
			height = i_height;
//			glabel_img = new int[height][width];
//			this.wk_reservLineBuffer_buf = new Array(width);//new int[width];
			this.tmp_img = new BitmapData(i_width, i_height, false, 0x0);
			label_num = 0;
		
//			//ワークイメージに枠を書く
//			var label_img:Array = this.glabel_img;
//			for (var i:int = 0; i < i_width; i++) {
//			    label_img[0][i] = 0;
//			    label_img[i_height-1][i] = 0;
//			}
//			//</Optimize>
//			for (var i:int = 0; i < i_height; i++) {
//			    label_img[i][0] = 0;
//			    label_img[i][i_width-1] = 0;			    
//			}
	    }
	    
	    /**
	     * 検出したラベルの数を返す
	     * @return
	     */
	    public function getLabelNum():int {
			return label_num;
	    }
	    
	    /**
	     * 検出したエリア配列？
	     * @return
	     * @throws FLARException
	     */
	    public function getLabel():Array {
			if (label_num < 1) {
			    throw new FLARException();
			}
			return this.label_holder;
	    }
	    
	    /**
	     * 
	     * @return
	     * @throws FLARException
	     */
	    public function getLabelRef():Array {
			if (label_num < 1) {
			    throw new FLARException();
			}
			return null;//work_holder.work;
	    }
	    
	    /**
	     * ラベリング済みイメージを返す
	     * @return
	     * @throws FLARException
	     */
	    public function getLabelImg():BitmapData {
			return this.label_img;
	    }
	    
	    //コンストラクタで作ること
//	    private var wk_reservLineBuffer_buf:Array = null;
	
	    /**
	     * static ARInt16 *labeling2(ARUint8 *image, int thresh,int *label_num, int **area, double **pos, int **clip,int **label_ref, int LorR)
	     * 関数の代替品
	     * ラスタimageをラベリングして、結果を保存します。
	     * Optimize:STEP[1514->1493]
	     * @param image
	     * @param thresh
	     * @throws FLARException
	     */
//	    public function labeling(image:FLARBitmapData, thresh:int):void {
//		int wk_max;                   /*  work                */
//		int m,n;                      /*  work                */
//		int lxsize, lysize;
//		int thresht3 = thresh * 3;
//		int i,j,k;
//		lxsize=image.getWidth();//lxsize = arUtil_c.arImXsize;
//		lysize=image.getHeight();//lysize = arUtil_c.arImYsize;
//		//画素数の一致チェック
//		if (lxsize!=this.width || lysize!=this.height) {
//		    throw new FLARException();
//		}	
//		//ラベル数を0に初期化
//		this.label_num=0;
//	
//	
//	
//		int[][] label_img=this.glabel_img;
//		
//	
//		//枠作成はインスタンスを作った直後にやってしまう。
//		
//		int[] work2_pt;
//		wk_max = 0;
//	
//		int label_pixel;
//		
//		int[] work=this.work_holder.work;
//		int[][] work2=this.work_holder.work2;
//		int[] line_bufferr=this.wk_reservLineBuffer_buf;
//		
//		int[] label_img_pt0,label_img_pt1;
//		for (j = 1; j < lysize - 1; j++) {//for (int j = 1; j < lysize - 1; j++, pnt += poff*2, pnt2 += 2) {
//	            label_img_pt0=label_img[j];
//	            label_img_pt1=label_img[j-1];
//	            image.getPixelTotalRowLine(j,line_bufferr);
//	
//		    for (i = 1; i < lxsize-1; i++) {//for (int i = 1; i < lxsize-1; i++, pnt+=poff, pnt2++) {
//			//RGBの合計値が閾値より大きいかな？
//			if (line_bufferr[i]<=thresht3) {
//			    //pnt1 = ShortPointer.wrap(pnt2, -lxsize);//pnt1 = &(pnt2[-lxsize]);
//			    if (label_img_pt1[i]>0) {//if (*pnt1 > 0) {
//				label_pixel=label_img_pt1[i];//*pnt2 = *pnt1;
//	
//	
//				work2_pt=work2[label_pixel-1];
//				work2_pt[0]++;//work2[((*pnt2)-1)*7+0] ++;
//				work2_pt[1]+=i;//work2[((*pnt2)-1)*7+1] += i;
//				work2_pt[2]+=j;//work2[((*pnt2)-1)*7+2] += j;
//				work2_pt[6]=j;//work2[((*pnt2)-1)*7+6] = j;
//			    }else if (label_img_pt1[i+1]> 0) {//}else if (*(pnt1+1) > 0) {
//				if (label_img_pt1[i-1] > 0) {//if (*(pnt1-1) > 0) {
//				    m = work[label_img_pt1[i+1]-1];//m = work[*(pnt1+1)-1];
//				    n = work[label_img_pt1[i-1]-1];//n = work[*(pnt1-1)-1];
//				    if (m > n) {
//					label_pixel=n;//*pnt2 = n;
//					//wk=IntPointer.wrap(work, 0);//wk = &(work[0]);
//					for (k = 0; k < wk_max; k++) {
//					    if (work[k] == m) {//if (*wk == m) 
//						work[k]=n;//*wk = n;
//					    }
//					}
//				    }else if (m < n) {
//					label_pixel=m;//*pnt2 = m;
//					//wk=IntPointer.wrap(work,0);//wk = &(work[0]);
//					for (k = 0; k < wk_max; k++) {
//					    if (work[k]==n) {//if (*wk == n) {
//						work[k]=m;//*wk = m;
//					    }
//					}
//				    } else {
//					label_pixel=m;//*pnt2 = m;
//				    }
//				    work2_pt=work2[label_pixel-1];
//				    work2_pt[0] ++;
//				    work2_pt[1] += i;
//				    work2_pt[2] += j;
//				    work2_pt[6] = j;
//				}else if ((label_img_pt0[i-1]) > 0) {//}else if (*(pnt2-1) > 0) {
//				    m = work[(label_img_pt1[i+1])-1];//m = work[*(pnt1+1)-1];
//				    n = work[label_img_pt0[i-1]-1];//n = work[*(pnt2-1)-1];
//				    if (m > n) {
//	
//					label_pixel=n;//*pnt2 = n;
//					for (k = 0; k < wk_max; k++) {
//					    if (work[k]==m) {//if (*wk == m) {
//						work[k]=n;//*wk = n;
//					    }
//					}
//				    }else if (m < n) {
//					label_pixel=m;//*pnt2 = m;
//					for (k = 0; k < wk_max; k++) {
//					    if (work[k]==n) {//if (*wk == n) {
//						work[k]=m;//*wk = m;
//					    }
//					}
//				    } else {
//					label_pixel=m;//*pnt2 = m;
//				    }
//				    work2_pt=work2[label_pixel-1];
//				    work2_pt[0] ++;//work2[((*pnt2)-1)*7+0] ++;
//				    work2_pt[1] += i;//work2[((*pnt2)-1)*7+1] += i;
//				    work2_pt[2] += j;//work2[((*pnt2)-1)*7+2] += j;
//				} else {
//	
//				    label_pixel=label_img_pt1[i+1];//*pnt2 = *(pnt1+1);
//	
//				    work2_pt=work2[label_pixel-1];
//				    work2_pt[0] ++;//work2[((*pnt2)-1)*7+0] ++;
//				    work2_pt[1] += i;//work2[((*pnt2)-1)*7+1] += i;
//				    work2_pt[2] += j;//work2[((*pnt2)-1)*7+2] += j;
//				    if (work2_pt[3] > i) {//if (work2[((*pnt2)-1)*7+3] > i) {		
//					work2_pt[3] = i;//	work2[((*pnt2)-1)*7+3] = i;
//				    }
//				    work2_pt[6] = j;//work2[((*pnt2)-1)*7+6] = j;
//				}
//			    }else if ((label_img_pt1[i-1]) > 0) {//}else if (*(pnt1-1) > 0) {
//				label_pixel=label_img_pt1[i-1];//*pnt2 = *(pnt1-1);
//	
//				work2_pt=work2[label_pixel-1];
//				work2_pt[0] ++;//work2[((*pnt2)-1)*7+0] ++;
//				work2_pt[1] += i;//work2[((*pnt2)-1)*7+1] += i;
//				work2_pt[2] += j;//work2[((*pnt2)-1)*7+2] += j;
//				if (work2_pt[4] < i) {//if (work2[((*pnt2)-1)*7+4] < i) {
//				    work2_pt[4] = i;//	work2[((*pnt2)-1)*7+4] = i;
//				}
//				work2_pt[6] = j;//work2[((*pnt2)-1)*7+6] = j;
//			    }else if (label_img_pt0[i-1] > 0) {//}else if (*(pnt2-1) > 0) {
//				label_pixel=label_img_pt0[i-1];//*pnt2 = *(pnt2-1);
//	
//				work2_pt=work2[label_pixel-1];
//				work2_pt[0] ++;//work2[((*pnt2)-1)*7+0] ++;
//				work2_pt[1] += i;//work2[((*pnt2)-1)*7+1] += i;
//				work2_pt[2] += j;//work2[((*pnt2)-1)*7+2] += j;
//				if (work2_pt[4] < i) {//if (work2[((*pnt2)-1)*7+4] < i) {
//				    work2_pt[4] = i;//	work2[((*pnt2)-1)*7+4] = i;
//				}
//			    } else {
//				//現在地までの領域を予約
//				this.work_holder.reserv(wk_max);
//				wk_max++;
//				work[wk_max-1] = wk_max;
//				label_pixel=wk_max;//work[wk_max-1] = *pnt2 = wk_max;
//				work2_pt=work2[wk_max-1];
//				work2_pt[0] = 1;
//				work2_pt[1] = i;
//				work2_pt[2] = j;
//				work2_pt[3] = i;
//				work2_pt[4] = i;
//				work2_pt[5] = j;
//				work2_pt[6] = j;
//			    }
//			    label_img_pt0[i]=label_pixel;
//			}else {
//			    label_img_pt0[i]=0;//*pnt2 = 0;
//			}
//			
//		    }
//		}
//		j = 1;
//		for (i = 0; i < wk_max; i++) {//for (int i = 1; i <= wk_max; i++, wk++) {
//		    work[i]=(work[i]==i+1)? j++: work[work[i]-1];//*wk = (*wk==i)? j++: work[(*wk)-1];
//		}
//	
//		int wlabel_num=j - 1;//*label_num = *wlabel_num = j - 1;
//	
//		if (wlabel_num==0) {//if (*label_num == 0) {
//		    //発見数0
//		    return;
//		}
//	
//		
//		
//		//ラベルバッファを予約&初期化
//		this.label_holder.init(wlabel_num, lxsize, lysize);
//	//	
//	//	putZero(warea,wlabel_num);//put_zero((ARUint8 *)warea, *label_num *     sizeof(int));
//	//	for (i=0;i<wlabel_num;i++) {
//	//	    wpos[i*2+0]=0;
//	//	    wpos[i*2+1]=0;
//	//	}
//	//	for (i = 0; i < wlabel_num; i++) {//for (i = 0; i < *label_num; i++) {
//	//	    wclip[i][0] = lxsize;//wclip[i*4+0] = lxsize;
//	//	    wclip[i][1] = 0;//wclip[i*4+1] = 0;
//	//	    wclip[i][2] = lysize;//wclip[i*4+2] = lysize;
//	//	    wclip[i][3] = 0;//wclip[i*4+3] = 0;
//	//	}
//		FLARLabel label_pt;
//		FLARLabel[] labels=this.label_holder.labels;
//		
//		for (i = 0; i < wk_max; i++) {
//		    label_pt=labels[work[i] - 1];
//		    work2_pt=work2[i];
//		    label_pt.area  += work2_pt[0];
//		    label_pt.pos_x += work2_pt[1];
//		    label_pt.pos_y += work2_pt[2];
//		    if (label_pt.clip0 > work2_pt[3]) {
//			label_pt.clip0 = work2_pt[3];
//		    }
//		    if (label_pt.clip1 < work2_pt[4]) {
//			label_pt.clip1 = work2_pt[4];
//		    }
//		    if (label_pt.clip2 > work2_pt[5]) {
//			label_pt.clip2 = work2_pt[5];
//		    }
//		    if (label_pt.clip3 < work2_pt[6]) {
//			label_pt.clip3 = work2_pt[6];
//		    }
//		}
//	
//		for (i = 0; i < wlabel_num; i++) {//for (int i = 0; i < *label_num; i++) {
//		    label_pt=labels[i];
//		    label_pt.pos_x /= label_pt.area;
//		    label_pt.pos_y /= label_pt.area;
//		}
//	
//		label_num=wlabel_num;
//		return;
//	    }



		private static const ZERO_POINT:Point = new Point();
		private static const ONE_POINT:Point = new Point(1, 1);
		public function labeling(image:FLARBitmapData, thresh:int):void {
			if (this.label_img) {
				this.label_img.dispose();
			}
			
			this.label_img = image.bitmapData.clone();
			this.tmp_img.applyFilter(this.label_img, this.label_img.rect, ZERO_POINT, new ColorMatrixFilter([
				0.2989, 0.5866, 0.1145, 0, 0,
				0.2989, 0.5866, 0.1145, 0, 0,
				0.2989, 0.5866, 0.1145, 0, 0,
				0, 0, 0, 1, 0
			]));
			this.label_img.fillRect(this.label_img.rect, 0x0);
			var rect:Rectangle = this.tmp_img.rect;
			rect.inflate(-1, -1);
			this.label_img.threshold(this.tmp_img, rect, ONE_POINT, '<=', thresh, 0xffffffff, 0xff);
//			this.label_img.threshold(this.tmp_img, rect, ONE_POINT, '>', thresh, 0xff00000, 0xff);
			
			this.label_num = 0;
			this.label_holder.splice(0, this.label_holder.length);
//			this.area = [];
//			this.clip = [];
//			this.pos = []
			
			var hSearch:BitmapData = new BitmapData(this.label_img.width, 1, false, 0x000000);
			var currentRect:Rectangle = this.label_img.getColorBoundsRect(0xffffff, 0xffffff, true);
			var hLineRect:Rectangle = new Rectangle(0, 0, this.label_img.width, 1);
			var hSearchRect:Rectangle;
			var labelRect:Rectangle;
			while (!currentRect.isEmpty()) {
				hLineRect.y = currentRect.top;
				hSearch.copyPixels(this.label_img, hLineRect, ZERO_POINT);
				hSearchRect = hSearch.getColorBoundsRect(0xffffff, 0xffffff, true);
				
				var label:FLARLabel = new FLARLabel();//this.label_holder.labels[this.label_num];
				this.label_img.floodFill(hSearchRect.x, hLineRect.y, ++this.label_num);
				labelRect = this.label_img.getColorBoundsRect(0xffffff, this.label_num, true);
				label.area = labelRect.width * labelRect.height;
				label.clip0 = labelRect.left;
				label.clip1 = labelRect.right - 1;
				label.clip2 = labelRect.top;
				label.clip3 = labelRect.bottom - 1;
				label.pos_x = (labelRect.left + labelRect.right - 1) * 0.5;// / label.area;
				label.pos_y = (labelRect.top + labelRect.bottom - 1) * 0.5;// / label.area;
				this.label_holder.push(label);
//				this.area.push(labelRect.width * labelRect.height);
//				this.clip.push([labelRect.left, labelRect.right - 1, labelRect.top, labelRect.bottom - 1]);
//				this.pos.push((labelRect.left + labelRect.right - 1) * 0.5, (labelRect.top + labelRect.bottom - 1) * 0.5);
				currentRect = this.label_img.getColorBoundsRect(0xffffff, 0xffffff, true);
			}
			hSearch.dispose();
		}
		
	}
	
}

import com.libspark.flartoolkit.core.FLARLabel;
import com.libspark.flartoolkit.FLARException;

//class FLARWorkHolder
//{
//    private final static int ARRAY_APPEND_STEP=256;
//    public final int[] work;
//    public final int[][] work2;
//    private int allocate_size;
//    /**
//     * 最大i_holder_size個の動的割り当てバッファを準備する。
//     * @param i_holder_size
//     */
//    public FLARWorkHolder(int i_holder_size)
//    {
//	//ポインタだけははじめに確保しておく
//	this.work=new int[i_holder_size];
//	this.work2=new int[i_holder_size][];
//	this.allocate_size=0;
//    }
//    /**
//     * i_indexで指定した番号までのバッファを準備する。
//     * @param i_index
//     */
//    public final void reserv(int i_index) throws FLARException
//    {
//	//アロケート済みなら即リターン
//	if (this.allocate_size>i_index) {
//	    return;
//	}
//	//要求されたインデクスは範囲外
//	if (i_index>=this.work.length) {
//	    throw new FLARException();
//	}	
//	//追加アロケート範囲を計算
//	int range=i_index+ARRAY_APPEND_STEP;
//	if (range>=this.work.length) {
//	    range=this.work.length;
//	}
//	//アロケート
//	for (int i=this.allocate_size;i<range;i++)
//	{
//	    this.work2[i]=new int[7];
//	}
//	this.allocate_size=range;
//    }
//}

class FLARLabelHolder {
	
    private static const ARRAY_APPEND_STEP:int = 128;
    public var labels:Array;
    private var allocate_size:int;
    
    /**
     * 最大i_holder_size個の動的割り当てバッファを準備する。
     * @param i_holder_size
     */
    public function FLARLabelHolder(i_holder_size:int) {
		//ポインタだけははじめに確保しておく
		this.labels = new Array(i_holder_size);//new FLARLabel[i_holder_size];
		this.allocate_size = 0;
    }
    
    /**
     * i_indexで指定した番号までのバッファを準備する。
     * @param i_index
     */
    private function reserv(i_index:int):void {
		//アロケート済みなら即リターン
		if (this.allocate_size > i_index) {
		    return;
		}
		//要求されたインデクスは範囲外
		if (i_index >= this.labels.length) {
		    throw new FLARException();
		}	
		//追加アロケート範囲を計算
		var range:int = i_index + ARRAY_APPEND_STEP;
		if (range >= this.labels.length) {
		    range = this.labels.length;
		}
		//アロケート
		for (var i:int = this.allocate_size; i < range; i++) {
		    this.labels[i] = new FLARLabel();
		}
		this.allocate_size = range;
    }
    
    /**
     * i_reserv_sizeまでのバッファを、初期条件i_lxsizeとi_lysizeで初期化する。
     * @param i_reserv_size
     * @param i_lxsize
     * @param i_lysize
     * @throws FLARException
     */
    public function init(i_reserv_size:int, i_lxsize:int, i_lysize:int):void {
		reserv(i_reserv_size);
		var l:FLARLabel;
		for (var i:int = 0; i < i_reserv_size; i++) {
		    l = this.labels[i];
		    l.area = 0;
		    l.pos_x = 0;
		    l.pos_y = 0;
		    l.clip0 = i_lxsize;//wclip[i*4+0] = lxsize;
		    l.clip1 = 0;//wclip[i*4+0] = lxsize;
		    l.clip2 = i_lysize;//wclip[i*4+2] = lysize;
		    l.clip3 = 0;//wclip[i*4+3] = 0;
		}
    }
    
}
