package com.libspark.flartoolkit.core {
	
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.core.raster.IFLARRaster;
	
	import flash.display.BitmapData;
	
	public interface IFLARLabeling {
	
	    /**
	     * 検出したラベルの数を返す
	     * @return
	     */
	    function getLabelNum():int;
	    /**
	     * 
	     * @return
	     * @throws NyARException
	     */
	    function getLabelRef():Array;
	    /**
	     * 検出したラベル配列
	     * @return
	     * @throws NyARException
	     */
	    function getLabel():Array;
	    /**
	     * ラベリング済みイメージを返す
	     * @return
	     * @throws NyARException
	     */
	    function getLabelImg():BitmapData;
	    /**
	     * static ARInt16 *labeling2( ARUint8 *image, int thresh,int *label_num, int **area, double **pos, int **clip,int **label_ref, int LorR )
	     * 関数の代替品
	     * ラスタimageをラベリングして、結果を保存します。
	     * Optimize:STEP[1514->1493]
	     * @param image
	     * @param thresh
	     * @throws NyARException
	     */
	    function labeling(image:FLARBitmapData, thresh:int):void;	
	    
	}
	
}