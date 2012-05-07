package jp.nyatla.nyartoolkit.as3.core.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * 2つの点集合同士を比較して、集合の各点同士の距離が最も近くになる組み合わせを計算
	 * するためのクラスです。
	 * 点集合の2次元距離マップを作成して、そこから最適な組み合わせを計算します。
	 */
	public class NyARDistMap
	{
		protected var _map:Vector.<NyARDistMap_DistItem>;

		protected var _min_dist:int;
		protected var _min_dist_index:int;
		protected var _size_row:int;
		protected var _size_col:int;

		public function NyARDistMap(i_max_col:int,i_max_row:int)
		{
			this._min_dist=int.MAX_VALUE;
			this._min_dist_index=0;
			this._size_col=i_max_col;
			this._size_row=i_max_row;
			this._map=new Vector.<NyARDistMap_DistItem>(i_max_col*i_max_row);
			for(var i:int=0;i<i_max_col*i_max_row;i++){
				this._map[i]=new NyARDistMap_DistItem();
			}
		}
		/**
		 * マップのサイズを再設定します。内容は不定になり、距離マップの再設定が必要です。
		 * @param i_col
		 * 列数
		 * @param i_row
		 */
		public function setMapSize(i_col:int ,i_row:int ):void
		{
			this._size_row=i_row;
			this._size_col=i_col;
		}
		/**
		 * 列と行を指定して、距離値をマップに値をセットします。
		 * このAPIは低速です。setPointsDistsを参考に、マップに直接距離値を置く関数を検討してください。
		 * @param i_col
		 * @param i_row
		 * @param i_dist
		 */
		public function setDist(i_col:int,i_row:int,i_dist:int):void
		{
			this._min_dist_index=this._size_col*i_row+i_col;
			var item:NyARDistMap_DistItem=this._map[this._min_dist_index];
			item.col=i_col;
			item.row=i_row;
			item.dist=i_dist;
			//最小値・最大値の再計算
			if(i_dist<this._min_dist){
				this._min_dist=i_dist;
			}
			return;
		}
		/**
		 * 2つの点集合同士の距離を計算して、距離マップに値をセットします。
		 * 点の座標が他の表現で実装されている場合は、この関数をオーバーロードして実装してください。
		 * @param i_vertex_r
		 * @param i_row_len
		 * @param i_vertex_c
		 * @param i_col_len
		 * @param o_rowindex
		 */
		public function setPointDists(i_vertex_r:Vector.<NyARIntPoint2d>,i_row_len:int,i_vertex_c:Vector.<NyARIntPoint2d>,i_col_len:int):void
		{
			var map:Vector.<NyARDistMap_DistItem>=this._map;
			//distortionMapを作成。ついでに最小値のインデクスも取得
			var min_index:int=0;
			var min_dist:int =int.MAX_VALUE;
			var idx:int=0;
			for(var r:int=0;r<i_row_len;r++){
				for(var c:int=0;c<i_col_len;c++){
					map[idx].col=c;
					map[idx].row=r;
					var d:int= i_vertex_r[r].sqDist(i_vertex_c[c]);
					map[idx].dist=d;
					if(min_dist>d){
						min_index=idx;
						min_dist=d;
					}
					idx++;
				}
			}
			this._min_dist=min_dist;
			this._min_dist_index=min_index;
			this._size_col=i_col_len;
			this._size_row=i_row_len;
			return;
		}
		/**
		 * 現在の距離マップから、colに対するrowの組み合わせを計算します。
		 * colに対して最適なものが無い場合は、o_rowindexの値に-1がセットされます。
		 * この関数は内部データを不可逆に変更します。計算後は、距離マップの再セットが必要です。
		 * @param o_rowindex
		 */
		public function getMinimumPair(o_rowindex:Vector.<int>):void
		{
			var map:Vector.<NyARDistMap_DistItem>=this._map;
			var map_length:int=this._size_col*this._size_row;
			var col_len:int=this._size_col;
			//[0]と差し替え
			var temp_map:NyARDistMap_DistItem;
			var i:int;
			temp_map=map[0];
			map[0]=map[this._min_dist_index];
			map[this._min_dist_index]=temp_map;
			for(i=0;i<o_rowindex.length;i++){
				o_rowindex[i]=-1;
			}
			if(map_length==0){
				return;
			}
			//値の保管
			o_rowindex[map[0].col]=map[0].row;
			
			//ソートして、0番目以降のデータを探す
			for(i=1;i<col_len;i++){
				var min_index:int=0;
				//r,cのものを除外しながら最小値を得る。
				var reject_c:int=map[i-1].col;
				var reject_r:int=map[i-1].row;
				var min_dist:int=int.MAX_VALUE;
				if(1>=map_length-col_len){
					break;
				}
				for(var i2:int=i;i2<map_length;){
					//除外条件？
					if(map[i2].col==reject_c || map[i2].row==reject_r){
						//非検索対象→インスタンスの差し替えと、検索長の減算
						temp_map=map[i2];
						map[i2]=map[map_length-1];
						map[map_length-1]=temp_map;
						map_length--;
					}else{
						var d:int=map[i2].dist;
						if(min_dist>d){
							min_index=i2;
							min_dist=d;
						}
						i2++;
					}
				}
				//[i]の値の差し替え
				temp_map=map[i];
				map[i]=map[min_index];
				map[min_index]=temp_map;
				//値の保管
				o_rowindex[map[i].col]=map[i].row;
			}
			return;		
		}
	}
}


