package jp.nyatla.nyartoolkit.as3.core.types 
{
	/**
	 * ...
	 * @author nyatla
	 */
	public class NyARQuaternion 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function setFromMatrix(i_mat:NyARDoubleMatrix44)
		{
			// 最大成分を検索
			var elem0:Number = i_mat.m00 - i_mat.m11 - i_mat.m22 + 1.0;
			var elem1:Number = -i_mat.m00 + i_mat.m11 - i_mat.m22 + 1.0;
			var elem2:Number = -i_mat.m00 - i_mat.m11 + i_mat.m22 + 1.0;
			var elem3:Number = i_mat.m00 + i_mat.m11 + i_mat.m22 + 1.0;
			if(elem0>elem1 && elem0>elem2 && elem0>elem3){
				var v:Number = Math.sqrt(elem0) * 0.5;
				var mult:Number = 0.25 / v;
				this.x = v;
				this.y = ((i_mat.m10 + i_mat.m01) * mult);
				this.z = ((i_mat.m02 + i_mat.m20) * mult);
				this.w = ((i_mat.m21 - i_mat.m12) * mult);
			}else if(elem1>elem2 && elem1>elem3){
				var v:Number = Math.sqrt(elem1) * 0.5;
				var mult:Number = 0.25 / v;
				this.x = ((i_mat.m10 + i_mat.m01) * mult);
				this.y = (v);
				this.z = ((i_mat.m21 + i_mat.m12) * mult);
				this.w = ((i_mat.m02 - i_mat.m20) * mult);
			}else if(elem2>elem3){
				var v:Number = Math.sqrt(elem2) * 0.5;
				var mult:Number = 0.25 / v;
				this.x =((i_mat.m02 + i_mat.m20) * mult);
				this.y =((i_mat.m21 + i_mat.m12) * mult);
				this.z =(v);
				this.w =((i_mat.m10 - i_mat.m01) * mult);
			}else{
				var v:Number = Math.sqrt(elem3) * 0.5;
				var mult:Number = 0.25 / v;
				this.x =((i_mat.m21 - i_mat.m12) * mult);
				this.y =((i_mat.m02 - i_mat.m20) * mult);
				this.z =((i_mat.m10 - i_mat.m01) * mult);
				this.w =v;
			}
			return;
		}
	}

}