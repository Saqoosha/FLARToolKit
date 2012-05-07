package jp.nyatla.nyartoolkit.as3.core.types 
{

	public class NyARIntCoordinates 
	{
		public var items:Vector.<NyARIntPoint2d>; 
		public var length:int ; 
		public function NyARIntCoordinates(i_length:int )
		{ 
			this.items = NyARIntPoint2d.createArray(i_length) ;
			this.length = 0 ;
		}
		public function setLineCoordinates( i_x0:int , i_y0:int , i_x1:int , i_y1:int ):Boolean
		{ 
			var ptr:Vector.<NyARIntPoint2d> = this.items ;
			var dx:int = ( i_x1 > i_x0 ) ? i_x1 - i_x0 : i_x0 - i_x1 ;
			var dy:int = ( i_y1 > i_y0 ) ? i_y1 - i_y0 : i_y0 - i_y1 ;
			var sx:int = ( i_x1 > i_x0 ) ? 1 : -1 ;
			var sy:int = ( i_y1 > i_y0 ) ? 1 : -1 ;
			var idx:int = 0 ;
			var E:int, i:int;
			if( dx >= dy ) {
				if( dx >= ptr.length ) {
					return false ;
				}
				
				E= -dx ;
				for(i = 0 ; i <= dx ; i++ ) {
					ptr[idx].x = i_x0 ;
					ptr[idx].y = i_y0 ;
					idx++ ;
					i_x0 += sx ;
					E += 2 * dy ;
					if( E >= 0 ) {
						i_y0 += sy ;
						E -= 2 * dx ;
					}
					
				}
			}
			else {
				if( dy >= this.items.length ) {
					return false ;
				}
				
				E = -dy ;
				for(i = 0 ; i <= dy ; i++ ) {
					ptr[idx].x = i_x0 ;
					ptr[idx].y = i_y0 ;
					idx++ ;
					i_y0 += sy ;
					E += 2 * dx ;
					if( E >= 0 ) {
						i_x0 += sx ;
						E -= 2 * dy ;
					}
					
				}
			}
			this.length = idx ;
			return true ;
		}	
	}
}