package jp.nyatla.nyartoolkit.as3.markersystem.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class MultiResolutionPattProvider_Item 
	{
		public var _patt:INyARRgbRaster;
		public var _patt_d:NyARMatchPattDeviationColorData;
		public var _patt_edge:int;
		public var _patt_resolution:int;
		public function MultiResolutionPattProvider_Item(i_patt_w:int, i_patt_h:int, i_edge_percentage:int)
		{
			var r:int=1;
			//解像度は幅を基準にする。
			while(i_patt_w*r<64){
				r*=2;
			}
			this._patt=new NyARRgbRaster(i_patt_w,i_patt_h,NyARBufferType.INT1D_X8R8G8B8_32,true);
			this._patt_d=new NyARMatchPattDeviationColorData(i_patt_w,i_patt_h);
			this._patt_edge=i_edge_percentage;
			this._patt_resolution=r;
		}
	}

}