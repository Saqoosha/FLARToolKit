package org.libspark.flartoolkit.core.labeling.rlelabeling 
{
	import org.libspark.flartoolkit.core.types.stack.*;
	/**
	 * ...
	 * @author 
	 */
	public class FLARRleLabelFragmentInfoPtrStack extends FLARPointerStack 
	{
		public function FLARRleLabelFragmentInfoPtrStack( i_length:int )
		{ 
			this.initInstance(i_length) ;
			return  ;
		}
		
		public function sortByArea():void
		{ 
			var len:int = this._length ;
			if( len < 1 ) {
				return  ;
			}
			
			var h:int = len * 13 / 10 ;
			var item:Vector.<Object> = this._items ;
			for(  ;  ;  ) {
				var swaps:int = 0 ;
				for( var i:int = 0 ; i + h < len ; i++ ){
					if( ((FLARRleLabelFragmentInfo)(item[i + h])).area > item[i].area ){
						var temp:Object = item[i + h] ;
						item[i + h] = item[i] ;
						item[i] = temp ;
						swaps++ ;
					}
					
				}
				if( h == 1 ) {
					if( swaps == 0 ) {
						break ;
					}
					
				}
				else {
					h = h * 10 / 13 ;
				}
			}
		}
		
	}


}