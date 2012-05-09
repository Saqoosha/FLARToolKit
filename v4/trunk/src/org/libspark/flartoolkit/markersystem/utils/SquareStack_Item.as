package jp.nyatla.nyartoolkit.as3.markersystem.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.NyARSquare;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	public class SquareStack_Item extends NyARSquare
	{
		public var center2d:NyARIntPoint2d=new NyARIntPoint2d();
		/** 検出座標系の値*/
		public var ob_vertex:Vector.<NyARIntPoint2d>=NyARIntPoint2d.createArray(4);
		/** 頂点の分布範囲*/
		public var vertex_area:NyARIntRect=new NyARIntRect();
		/** rectの面積*/
		public var rect_area:int;
	}

}