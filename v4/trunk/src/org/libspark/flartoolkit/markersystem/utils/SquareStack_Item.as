package org.libspark.flartoolkit.markersystem.utils 
{
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.types.*;

	public class SquareStack_Item extends FLARSquare
	{
		public var center2d:FLARIntPoint2d=new FLARIntPoint2d();
		/** 検出座標系の値*/
		public var ob_vertex:Vector.<FLARIntPoint2d>=FLARIntPoint2d.createArray(4);
		/** 頂点の分布範囲*/
		public var vertex_area:FLARIntRect=new FLARIntRect();
		/** rectの面積*/
		public var rect_area:int;
	}

}