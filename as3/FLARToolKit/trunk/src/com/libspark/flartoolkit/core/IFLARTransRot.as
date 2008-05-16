package com.libspark.flartoolkit.core {
	
	public interface IFLARTransRot {
	    function getArray():Array;
	    /**
	     * 
	     * @param trans
	     * @param vertex
	     * @param pos2d
	     * [n*2]配列
	     * @return
	     * @throws NyARException
	     */
	    function modifyMatrix(trans:Array, vertex:Array, pos2d:Array):Number;
	    function initRot(marker_info:FLARSquare, i_direction:int):void;
	    function initRotByPrevResult(i_prev_result:FLARTransMatResult):void;
	}
	
}