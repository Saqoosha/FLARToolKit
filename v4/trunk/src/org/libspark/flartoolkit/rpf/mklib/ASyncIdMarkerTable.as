/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.rpf.mklib 
{
	/**
	 * 外部パターン認識のサンプルです。非同期にIDマーカを認識します。
	 * このクラスはサンプルなので、マーカ判定を非同期なスレッドに問い合わせて、3秒後に結果を返却します。
	 * このシーケンスを応用すると、外部サーバで高精度な画像一致探索等ができます。
	 * 
	 * 但し、毎回外部サーバに問い合わせるとパフォーマンスの劣化が激しいので、実際には結果をキャッシュ
	 * するなどの対策が必要になります。
	 * @author nyatla
	 *
	 */
	public class ASyncIdMarkerTable
	{
//		var _mklib:RawbitSerialIdTable;
//		var _listener:IResultListener;
//
//		public ASyncIdMarkerTable(IResultListener i_listener) throws FLARException
//		{
//			this._mklib=new RawbitSerialIdTable(1);	
//			this._mklib.addAnyItem("ANY ID",40);
//			this._listener=i_listener;
//		}
//		private void callListener(boolean i_result,long i_serial,int i_dir,double i_width,long i_id)
//		{
//			//ON/OFFスイッチつけるならココ
//			this._listener.OnDetect(i_result, i_serial, i_dir, i_width,i_id);
//		}
//		/**
//		 * このターゲットについて、非同期に認識依頼を出します。このプログラムはサンプルなので、別スレッドでIDマーカ判定をして、
//		 * 三秒後に適当なサイズとDirectionを返却するだけです。
//		 * @param i_target
//		 * @return
//		 * @throws FLARException 
//		 */
//		public function requestAsyncMarkerDetect(FLARReality i_reality,FLARRealitySource i_source,FLARRealityTarget i_target):void
//		{
//			//ターゲットから画像データなどを取得するときは、スレッドからではなく、ここで同期して取得してコピーしてからスレッドに引き渡します。
//
//			//100x100の領域を切りだして、Rasterを作る。
//			var raster:FLARRgbRaster=new FLARRgbRaster(100,100,FLARBufferType.INT1D_X8R8G8B8_32);
//			i_reality.getRgbPatt2d(i_source, i_target.refTargetVertex(),1, raster);
//			//コピーしたラスタとターゲットのIDをスレッドへ引き渡す。
//			Thread t=new AsyncThread(this,i_target.getSerialId(),raster);
//			t.start();
//			return;
//		}
	}
}

//public interface IResultListener
//{
//	public function OnDetect(i_result:Boolean,i_serial:Number,i_dir:int,i_width:Number,id:Number):void;
//}
//
//class AsyncThread extends Thread
//{
//	private ASyncIdMarkerTable _parent;
//	private long _serial;
//	private FLARRgbRaster _source;
//	public AsyncThread(ASyncIdMarkerTable i_parent,long i_serial,FLARRgbRaster i_raster)
//	{
//		this._parent=i_parent;
//		this._serial=i_serial;
//		this._source=i_raster;
//	}
//	public void run()
//	{
//		try {
//			sleep(3000);
//			RawbitSerialIdTable.IdentifyIdResult ret=new RawbitSerialIdTable.IdentifyIdResult();
//			boolean res;
//			synchronized(this._parent._mklib){
//				FLARDoublePoint2d[] vx=FLARDoublePoint2d.createArray(4);
//				//反時計まわり
//				vx[0].x=0; vx[0].y=0;
//				vx[1].x=99;vx[1].y=0;
//				vx[2].x=99;vx[2].y=99;
//				vx[3].x=0; vx[3].y=99;
//				res=this._parent._mklib.identifyId(vx,this._source,ret);
//			}
//			this._parent.callListener(res,this._serial,ret.artk_direction,ret.marker_width,ret.id);
//		} catch (Exception e){
//			e.printStackTrace();
//		}
//		
//	}
//}
