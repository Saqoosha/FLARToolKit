package com.libspark.flartoolkit.util {
	
	public class ArrayUtil {
		
		public static function createMultidimensionalArray(len:int, ...args):Array {
			var arr:Array = new Array(len);
//			if (args.length) {
				while (len--) {
					arr[len] = args.length ? createMultidimensionalArray.apply(null, args) : 0;
				}
//			}
			return arr;
		}
		
		public static function create2d(height:int, width:int):Array {
			return createMultidimensionalArray(height, width);
		}
		
		public static function create3d(depth:int, height:int, width:int):Array {
			return createMultidimensionalArray(depth, height, width);
		}
		
		public static function copy(src:Array, srcPos:int, dest:Array, destPos:int, length:int):void {
			for (var i:int = 0; i < length; i++) {
				dest[destPos + i] = src[srcPos + i]; 
			}
		}

	}
	
}