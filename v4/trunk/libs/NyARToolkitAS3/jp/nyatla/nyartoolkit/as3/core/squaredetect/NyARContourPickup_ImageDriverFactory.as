package jp.nyatla.nyartoolkit.as3.core.squaredetect 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class NyARContourPickup_ImageDriverFactory 
	{
		
		public static function createDriver(i_ref_raster:INyARGrayscaleRaster):NyARContourPickup_IRasterDriver
		{
			switch(i_ref_raster.getBufferType()){
			case NyARBufferType.INT1D_GRAY_8:
			case NyARBufferType.INT1D_BIN_8:
				return new NyARContourPickup_BIN_GS8(i_ref_raster);
			default:
				if(i_ref_raster is NyARContourPickup_GsReader){
					return new NyARContourPickup_GsReader(INyARGrayscaleRaster(i_ref_raster));
				}
				break;
			}
			throw new NyARException();
		}
	}

}


	
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	
	


class NyARContourPickup_Base implements NyARContourPickup_IRasterDriver
{
	//巡回参照できるように、テーブルを二重化
	//                                           0  1  2  3  4  5  6  7   0  1  2  3  4  5  6
	/** 8方位探索の座標マップ*/
	protected static var _getContour_xdir:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0,-1,-1,-1 , 0, 1, 1, 1, 0,-1,-1]);
	/** 8方位探索の座標マップ*/
	protected static var _getContour_ydir:Vector.<int> = Vector.<int>([-1,-1, 0, 1, 1, 1, 0,-1 ,-1,-1, 0, 1, 1, 1, 0]);
	public function getContour(i_l:int, i_t:int, i_r:int, i_b:int, i_entry_x:int, i_entry_y:int, i_th:int, o_coord:NyARIntCoordinates):Boolean 
	{
		throw new NyARException();
	}
}



/**
 * (INT_BIN_8とINT_GS_8に対応)
 */
class NyARContourPickup_BIN_GS8 extends NyARContourPickup_Base
{
	private var _ref_raster:INyARRaster;
	public function NyARContourPickup_BIN_GS8(i_ref_raster:INyARRaster)
	{
		this._ref_raster=i_ref_raster;
	}
	public override function getContour(i_l:int, i_t:int, i_r:int, i_b:int, i_entry_x:int, i_entry_y:int, i_th:int, o_coord:NyARIntCoordinates):Boolean
	{
		//assert(i_t<=i_entry_x);
		var buf:Vector.<int>=Vector.<int>(this._ref_raster.getBuffer());
		var xdir:Vector.<int> = _getContour_xdir;// static int xdir[8] = { 0, 1, 1, 1, 0,-1,-1,-1};
		var ydir:Vector.<int> = _getContour_ydir;// static int ydir[8] = {-1,-1, 0, 1, 1, 1, 0,-1};
		var width:int=this._ref_raster.getWidth();
		//クリップ領域の上端に接しているポイントを得る。
		var coord:Vector.<NyARIntPoint2d>=o_coord.items;
		var max_coord:int=o_coord.items.length;
		coord[0].x = i_entry_x;
		coord[0].y = i_entry_y;
		var coord_num:int = 1;
		var dir:int = 5;

		var c:int = i_entry_x;
		var r:int = i_entry_y;
		for (;;) {
			dir = (dir + 5) % 8;//dirの正規化
			//ここは頑張ればもっと最適化できると思うよ。
			//4隅以外の境界接地の場合に、境界チェックを省略するとかね。
			if(c>i_l && c<i_r && r>i_t && r<i_b){
				for(;;){//gotoのエミュレート用のfor文
					//境界に接していないとき(暗点判定)
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					dir++;
					if (buf[(r + ydir[dir])*width+(c + xdir[dir])] <= i_th) {
						break;
					}
					//8方向全て調べたけどラベルが無いよ？
					throw new NyARException();			
				}
			}else{
				//境界に接しているとき
				var i:int;
				for (i = 0; i < 8; i++){				
					var x:int= c + xdir[dir];
					var y:int=r + ydir[dir];
					//境界チェック
					if(x>=i_l && x<=i_r && y>=i_t && y<=i_b){
						if (buf[(y)*width+(x)] <= i_th) {
							break;
						}
					}
					dir++;//倍長テーブルを参照するので問題なし
				}
				if (i == 8) {
					//8方向全て調べたけどラベルが無いよ？
					throw new NyARException();// return(-1);
				}				
			}
			// xcoordとycoordをc,rにも保存
			c = c + xdir[dir];
			r = r + ydir[dir];
			coord[coord_num].x = c;
			coord[coord_num].y = r;
			//終了条件判定
			if (c == i_entry_x && r == i_entry_y){
				//開始点と同じピクセルに到達したら、終点の可能性がある。
				coord_num++;
				//末端のチェック
				if (coord_num == max_coord) {
					//輪郭bufが末端に達した
					return false;
				}				
				//末端候補の次のピクセルを調べる
				dir = (dir + 5) % 8;//dirの正規化
				for (i = 0; i < 8; i++){				
					x=c + xdir[dir];
					y=r + ydir[dir];
					//境界チェック
					if(x>=i_l && x<=i_r && y>=i_t && y<=i_b){
						if (buf[(y)*width+(x)] <= i_th) {
							break;
						}
					}
					dir++;//倍長テーブルを参照するので問題なし
				}
				if (i == 8) {
					//8方向全て調べたけどラベルが無いよ？
					throw new NyARException();
				}
				//得たピクセルが、[1]と同じならば、末端である。
				c = c + xdir[dir];
				r = r + ydir[dir];
				if(coord[1].x ==c && coord[1].y ==r){
					//終点に達している。
					o_coord.length=coord_num;
					break;
				}else{
					//終点ではない。
					coord[coord_num].x = c;
					coord[coord_num].y = r;
				}
			}
			coord_num++;
			//末端のチェック
			if (coord_num == max_coord) {
				//輪郭が末端に達した
				return false;
			}
		}
		return true;
	}
}

/**
 * (INT_BIN_8とINT_GS_8に対応)
 */
class NyARContourPickup_GsReader extends NyARContourPickup_Base
{
	private var _ref_raster:INyARGrayscaleRaster;
	public function NyARContourPickup_GsReader(i_ref_raster:INyARGrayscaleRaster)
	{
		this._ref_raster=i_ref_raster;
	}
	public override function getContour(i_l:int,i_t:int,i_r:int,i_b:int,i_entry_x:int,i_entry_y:int,i_th:int,o_coord:NyARIntCoordinates):Boolean
	{
		//assert(i_t<=i_entry_x);
		var reader:INyARGsPixelDriver=this._ref_raster.getGsPixelDriver();
		var xdir:Vector.<int> = _getContour_xdir;// static int xdir[8] = { 0, 1, 1, 1, 0,-1,-1,-1};
		var ydir:Vector.<int> = _getContour_ydir;// static int ydir[8] = {-1,-1, 0, 1, 1, 1, 0,-1};
		//クリップ領域の上端に接しているポイントを得る。
		var coord:Vector.<NyARIntPoint2d>=o_coord.items;
		var max_coord:int=o_coord.items.length;
		coord[0].x = i_entry_x;
		coord[0].y = i_entry_y;
		var coord_num:int = 1;
		var dir:int = 5;

		var c:int = i_entry_x;
		var r:int = i_entry_y;
		var x:int, y:int;
		for (;;) {
			dir = (dir + 5) % 8;//dirの正規化
			//境界に接しているとき
			var i:int;
			for (i = 0; i < 8; i++){				
				x=c + xdir[dir];
				y=r + ydir[dir];
				//境界チェック
				if(x>=i_l && x<=i_r && y>=i_t && y<=i_b){
					if (reader.getPixel(x, y) <= i_th) {
						break;
					}
				}
				dir++;//倍長テーブルを参照するので問題なし
			}
			if (i == 8) {
				//8方向全て調べたけどラベルが無いよ？
				throw new NyARException();// return(-1);
			}				
			// xcoordとycoordをc,rにも保存
			c = c + xdir[dir];
			r = r + ydir[dir];
			coord[coord_num].x = c;
			coord[coord_num].y = r;
			//終了条件判定
			if (c == i_entry_x && r == i_entry_y){
				//開始点と同じピクセルに到達したら、終点の可能性がある。
				coord_num++;
				//末端のチェック
				if (coord_num == max_coord) {
					//輪郭bufが末端に達した
					return false;
				}				
				//末端候補の次のピクセルを調べる
				dir = (dir + 5) % 8;//dirの正規化
				for (i = 0; i < 8; i++){				
					x=c + xdir[dir];
					y=r + ydir[dir];
					//境界チェック
					if(x>=i_l && x<=i_r && y>=i_t && y<=i_b){
						if (reader.getPixel(x, y) <= i_th) {
							break;
						}
					}
					dir++;//倍長テーブルを参照するので問題なし
				}
				if (i == 8) {
					//8方向全て調べたけどラベルが無いよ？
					throw new NyARException();
				}
				//得たピクセルが、[1]と同じならば、末端である。
				c = c + xdir[dir];
				r = r + ydir[dir];
				if(coord[1].x ==c && coord[1].y ==r){
					//終点に達している。
					o_coord.length=coord_num;
					break;
				}else{
					//終点ではない。
					coord[coord_num].x = c;
					coord[coord_num].y = r;
				}
			}
			coord_num++;
			//末端のチェック
			if (coord_num == max_coord) {
				//輪郭が末端に達した
				return false;
			}
		}
		return true;
	}
}