package jp.nyatla.nyartoolkit.as3.rpf.utils 
{
	public class VecLinearCoordinates
	{	
	
		public var length:int;
		public var items:Vector.<VecLinearCoordinatePoint>;
		public function VecLinearCoordinates(i_length:int)
		{
			this.length = 0;
			this.items = VecLinearCoordinatePoint.createArray(i_length);
		}
		/**
		 * ベクトルを1,2象限に制限します。
		 */
		public function limitQuadrantTo12():void
		{
			for (var i:int = this.length - 1; i >= 0; i--) {
				var target1:VecLinearCoordinatePoint  = this.items[i];
				if (target1.dy < 0) {
					target1.dy *= -1;
					target1.dx *= -1;
				}
			}
		}
		/**
		 * 輪郭配列から、から、キーのベクトル(絶対値の大きいベクトル)を順序を壊さずに抽出します。
		 * 
		 * @param i_vecpos
		 *            抽出元の
		 * @param i_len
		 * @param o_index
		 *            インデクス番号を受け取る配列。受け取るインデックスの個数は、この配列の数と同じになります。
		 */
		public function getOrderdKeyCoordIndexes(o_index:Vector.<int>):void
		{
			getKeyCoordIndexes(o_index);
			// idxでソート
			var out_len_1:int = o_index.length - 1;
			for (var i:int = 0; i < out_len_1;) {
				if (o_index[i] > o_index[i + 1]) {
					var t:int = o_index[i];
					o_index[i] = o_index[i + 1];
					o_index[i + 1] = t;
					i = 0;
					continue;
				}
				i++;
			}
			return;
		}
		public function getKeyCoordIndexes(o_index:Vector.<int>):void
		{
			var vp:Vector.<VecLinearCoordinatePoint> = this.items;
//			assert (o_index.length <= this.length);
			var i:int;
			var out_len:int = o_index.length;
			var out_len_1:int = out_len - 1;
			for (i = out_len - 1; i >= 0; i--) {
				o_index[i] = i;
			}
			// sqdistでソートする(B->S)
			for (i = 0; i < out_len_1;) {
				if (vp[o_index[i]].scalar < vp[o_index[i + 1]].scalar) {
					var t:int = o_index[i];
					o_index[i] = o_index[i + 1];
					o_index[i + 1] = t;
					i = 0;
					continue;
				}
				i++;
			}
			// 先に4個をsq_distでソートしながら格納
			for (i = out_len; i < this.length; i++) {
				// 配列の値と比較
				for (var i2:int = 0; i2 < out_len; i2++) {
					if (vp[i].scalar > vp[o_index[i2]].scalar) {
						// 値挿入の為のシフト
						for (var i3:int = out_len - 1; i3 > i2; i3--) {
							o_index[i3] = o_index[i3 - 1];
						}
						// 設定
						o_index[i2] = i;
						break;
					}
				}
			}
			return;
		}
		public function getKeyCoord(o_index:Vector.<VecLinearCoordinatePoint>):void
		{
			var vp:Vector.<VecLinearCoordinatePoint> = this.items;
			//assert (o_index.length <= this.length);
			var i:int;
			var out_len:int = o_index.length;
			var out_len_1:int = out_len - 1;
			for (i = out_len - 1; i >= 0; i--) {
				o_index[i] = vp[i];
			}
			// sqdistでソートする(B->S)
			for (i = 0; i < out_len_1;) {
				if (o_index[i].scalar < o_index[i + 1].scalar) {
					var t:VecLinearCoordinatePoint = o_index[i];
					o_index[i] = o_index[i + 1];
					o_index[i + 1] = t;
					i = 0;
					continue;
				}
				i++;
			}
			// 先に4個をsq_distでソートしながら格納
			for (i = out_len; i < this.length; i++) {
				// 配列の値と比較
				for (var i2:int = 0; i2 < out_len; i2++) {
					if (vp[i].scalar > o_index[i2].scalar) {
						// 値挿入の為のシフト
						for (var i3:int = out_len - 1; i3 > i2; i3--) {
							o_index[i3] = o_index[i3 - 1];
						}
						// 設定
						o_index[i2] = vp[i];
						break;
					}
				}
			}
			return;
		} 	
		
		/**
		 * 最も大きいベクトル成分のインデクスを返します。
		 * 
		 * @return
		 */
		public function getMaxCoordIndex():int
		{
			var vp:Vector.<VecLinearCoordinatePoint> = this.items;
			var index:int = 0;
			var max_dist:Number = vp[0].scalar;
			for (var i:int = this.length - 1; i > 0; i--) {
				if (max_dist < vp[i].scalar) {
					max_dist = vp[i].scalar;
					index = i;
				}
			}
			return index;
		}


		/**
		 * ノイズレベルを指定して、ノイズ（だと思われる）ベクトルを削除します。
		 */
		/**
		 * 大きさ(sq_dist)が0のベクトルを削除して、要素を前方に詰めます。
		 */
		public function removeZeroDistItem():void
		{
			//前方詰め
			var idx:int=0;
			var len:int=this.length;
			for(var i:int=0;i<len;i++){
				if(this.items[i].scalar!=0){
					idx++;
					continue;
				}
				for(i=i+1;i<len;i++){
					if(this.items[i].scalar!=0){
						var temp:VecLinearCoordinatePoint = this.items[i];
						this.items[i]=this.items[idx];
						this.items[idx]=temp;
						idx++;
						i--;
						break;
					}
				}
			}
			this.length=idx;
			return;
		}
	}

}