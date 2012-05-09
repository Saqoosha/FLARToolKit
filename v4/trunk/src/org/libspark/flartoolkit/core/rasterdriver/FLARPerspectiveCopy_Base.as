package jp.nyatla.nyartoolkit.as3.core.rasterdriver 
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;

	/**
	 * このクラスは、INyARPerspectiveCopyの基本機能を実装したベースクラスです。
	 * {@link #onePixel(int, int, double[], INyARRaster)}と{@link #multiPixel(int, int, double[], int, INyARRaster)}
	 * を実装して、クラスを完成させます。
	 * 
	 */
	public class NyARPerspectiveCopy_Base implements INyARPerspectiveCopy
	{
		private static const LOCAL_LT:int=1;
		protected var _perspective_gen:NyARPerspectiveParamGenerator;
		protected var __pickFromRaster_cpara:Vector.<Number>=new Vector.<Number>(8);	
		public function NyARPerspectiveCopy_Base()
		{
			this._perspective_gen=new NyARPerspectiveParamGenerator_O1(LOCAL_LT,LOCAL_LT);		
		}
		public function copyPatt_3(i_x1:Number,i_y1:Number,i_x2:Number,i_y2:Number,i_x3:Number,i_y3:Number,i_x4:Number,i_y4:Number,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean
		{
			var out_size:NyARIntSize=i_out.getSize();
			var xe:int=out_size.w*i_edge_x/50;
			var ye:int=out_size.h*i_edge_y/50;

			//サンプリング解像度で分岐
			if(i_resolution==1){
				if (!this._perspective_gen.getParam_5((xe * 2 + out_size.w), (ye * 2 + out_size.h), i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4, this.__pickFromRaster_cpara))
				{
					return false;
				}
				this.onePixel(xe+LOCAL_LT,ye+LOCAL_LT,this.__pickFromRaster_cpara,i_out);
			}else{
				if (!this._perspective_gen.getParam_5((xe*2+out_size.w)*i_resolution,(ye*2+out_size.h)*i_resolution,i_x1,i_y1,i_x2,i_y2,i_x3,i_y3,i_x4,i_y4, this.__pickFromRaster_cpara)) {
					return false;
				}
				this.multiPixel(xe*i_resolution+LOCAL_LT,ye*i_resolution+LOCAL_LT,this.__pickFromRaster_cpara,i_resolution,i_out);
			}
			return true;
		}

		public function copyPatt_2(i_vertex:Vector.<NyARDoublePoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean
		{
			return this.copyPatt_3(i_vertex[0].x,i_vertex[0].y,i_vertex[1].x,i_vertex[1].y,i_vertex[2].x,i_vertex[2].y,i_vertex[3].x,i_vertex[3].y, i_edge_x, i_edge_y, i_resolution, i_out);
		}
		public function copyPatt(i_vertex:Vector.<NyARIntPoint2d>,i_edge_x:int,i_edge_y:int,i_resolution:int,i_out:INyARRgbRaster):Boolean
		{
			return this.copyPatt_3(i_vertex[0].x,i_vertex[0].y,i_vertex[1].x,i_vertex[1].y,i_vertex[2].x,i_vertex[2].y,i_vertex[3].x,i_vertex[3].y, i_edge_x, i_edge_y, i_resolution, i_out);
		}
		protected function onePixel(pk_l:int, pk_t:int, cpara:Vector.<Number>, o_out:INyARRaster):Boolean
		{
			throw new NyARException();
		}
		protected function multiPixel(pk_l:int, pk_t:int, cpara:Vector.<Number>, i_resolution:int, o_out:INyARRaster):Boolean
		{
			throw new NyARException();
		}
	}
}