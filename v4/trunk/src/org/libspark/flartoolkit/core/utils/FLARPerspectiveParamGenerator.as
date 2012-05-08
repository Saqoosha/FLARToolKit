package org.libspark.flartoolkit.core.utils 
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	/**
	 * 遠近法を用いたPerspectiveパラメータを計算するクラスのテンプレートです。
	 * 任意頂点四角系と矩形から、遠近法の変形パラメータを計算します。
	 * このクラスはリファレンス実装のため、パフォーマンスが良くありません。実際にはFLARPerspectiveParamGenerator_O1を使ってください。
	 */	
	public class FLARPerspectiveParamGenerator 
	{
		protected var _local_x:int ; 
		protected var _local_y:int ; 
		public function FLARPerspectiveParamGenerator( i_local_x:int , i_local_y:int )
		{ 
			this._local_x = i_local_x ;
			this._local_y = i_local_y ;
			return;
		}
		public function getParam( i_size:FLARIntSize , i_vertex:Vector.<FLARIntPoint2d> , o_param:Vector.<Number>):Boolean
		{
			//assert( ! (( i_vertex.length == 4 ) ));
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param);
		}
		public function getParam_2( i_size:FLARIntSize , i_vertex:Vector.<FLARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_3( i_width:int , i_height:int , i_vertex:Vector.<FLARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_4( i_width:int , i_height:int , i_vertex:Vector.<FLARIntPoint2d> , o_param:Vector.<Number> ):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_5( i_dest_w:int , i_dest_h:int , x1:Number , y1:Number , x2:Number , y2:Number , x3:Number , y3:Number , x4:Number , y4:Number , o_param:Vector.<Number>):Boolean
		{
			throw new FLARException("getParam not implemented.");
		}
		
	}


}