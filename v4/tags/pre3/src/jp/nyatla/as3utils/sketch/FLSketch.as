package jp.nyatla.as3utils.sketch
{
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import jp.nyatla.as3utils.*;
	import flash.display.*;
	
	/**
	 * ...
	 * @author nyatla
	 */
	public class FLSketch extends Sprite
	{
		private var _loader:FilesLoader = new FilesLoader();
		public static const DATAFORMAT_AS_OBJECT:String = "AS_OBJECT";
		public function FLSketch() 
		{
			//setup実行
			this.setup();
			this._loader.addEventListener(Event.COMPLETE, endSetup);
			this._loader.loadAll();
			//setupで予約した動作を反映
			//loopコール
			
		}
		public function setup():void
		{
			throw new Error("Must be ovgerride setup()!");
		}
		/**
		 * この関数はsetup関数の中で実行します。
		 * @param	i_name
		 * @param	i_url
		 * @param	i_fmt
		 * 3種類の定数を指定できます。
		 * <ul>
		 * <li>FLSketch.DATAFORMAT_AS_OBJECT - PNG/JPG/SWF等を読み込む時に使います。</li>
		 * <li>URLLoaderDataFormat.BINARY　- バイナリデータをByteArrayで読み込む時に使います。</li>
		 * <li>URLLoaderDataFormat.TEXT - テキストデータをStringへ読み込む時に使います。</li>
		 * </ul>
		 */
		public function setSketchFile(i_url:String,i_fmt:String=URLLoaderDataFormat.VARIABLES):int
		{
			return this._loader.addTarget(i_url, i_fmt);
		}
		public function endSetup(e:Event):void
		{
			this._loader.removeEventListener(Event.COMPLETE, endSetup);
			this.main();
		}
		public function main():void
		{
			throw new Error("Must be ovgerride main()!");
		}
		/**
		 * この関数は、mainの中で実行します。
		 * @param	i_id
		 * @return
		 */
		public function getSketchFile(i_id:int):*
		{
			return this._loader.getData(i_id);
		}

		
	}
}



import flash.utils.*;
import flash.display.*;
import flash.net.*;
import flash.events.*;
import jp.nyatla.as3utils.*;
import jp.nyatla.as3utils.sketch.*;

/**
 * URLリストを登録して一括して実体化するファイルローダです。
 * #addTargetでコンテンツURLを登録して、#loadAllをコールしてください。
 * 終了すると、Event.COMPLETEを発生します。
 */
class FilesLoader extends EventDispatcher
{
	public var _items:Array=new Array(); 
	public function FilesLoader()
	{
	}
	/**
	 * ダウンロードターゲットを追加する。
	 * @param	i_fname
	 * @param	i_format
	 * @return インデクス
	 */
	public function addTarget(i_fname:String,i_format:String):int
	{
		var item:NyURLLoader = new NyURLLoader();
		if (i_format == FLSketch.DATAFORMAT_AS_OBJECT) {
			item._is_img=true;
			item.dataFormat = URLLoaderDataFormat.BINARY;
		}else{
			item.dataFormat = i_format;
			item._is_img=false;
		}
		item.addEventListener(Event.COMPLETE,FilesLoader.onCompleteTarget);
//		item.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
//		item.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
		item._parent=this;
		item._target = i_fname;
		item._is_complete = false;
		return this._items.push(item)-1;
	}
	/**
	 * 実体化したデータを返す。
	 * @return
	 */
	public function getData(i_idx:int):*
	{
		var item:NyURLLoader = this._items[i_idx];
		if (item._is_img) {
			var bmi:BitmapData = new BitmapData(item._ll.width, item._ll.height);
			bmi.draw(item._ll);
			return new Bitmap(bmi);
		}else {
			return item._is_img?item._ll:item.data;
		}
	}
	/**
	 * リストにある実体化していないファイルを実体化する。
	 * @param	i_accept
	 */
	public function loadAll():void
	{
		var c:int=0;
		for (var i:int; i < this._items.length; i++) {
			if(!this._items[i]._is_complete){
				this._items[i].load(new URLRequest(this._items[i]._target));
				c++;
			}
		}
		//1個も対象がなければ、即時イベント発生
		if (c == 0) {
			this.dispatchEvent(new Event(flash.events.Event.COMPLETE));	
		}
	}
	/**
	 * 全てのアイテムをダウンロードしたか返す。
	 * @return
	 */
	public function isComplete():Boolean
	{
		for(var i:int=0;i<this._items.length;i++){
			if(!this._items[i]._is_complete){
				return false;
			}
		}
		return true;
	}
	private function onError(e:Event):void
	{
		throw new Error("Error on loading" + e.toString());
	}
	/**
	 * Completeイベントのハンドラ
	 * @param	e
	 */
	private static function onCompleteTarget(e:Event):void
	{
		var item:NyURLLoader=NyURLLoader(e.currentTarget);
		//イベントリストから除去
		item.removeEventListener(Event.COMPLETE, FilesLoader.onCompleteTarget);
		if (item._is_img) {
			//イベントリレー
			item._ll = new Loader();
			item._ll.loadBytes(item.data);
			item._ll.contentLoaderInfo.addEventListener(Event.INIT,
			function(event:Event):void{
				var item:NyURLLoader = NyURLLoader(e.currentTarget);
				item._is_complete = true;
				//全てcompleteになれば、COMPLETEイベント。
				if(item._parent.isComplete()){
					//イベントを送信
					item._parent.dispatchEvent(new Event(flash.events.Event.COMPLETE));			
				}
			});
		}else{
			item._is_complete = true;
		}
		//全てcompleteになれば、COMPLETEイベント。
		if(item._parent.isComplete()){
			//イベントを送信
			item._parent.dispatchEvent(new Event(flash.events.Event.COMPLETE));			
		}
		return;
	}
}


class NyURLLoader extends URLLoader
{
	public var _is_img:Boolean;
	public var _parent:FilesLoader;
	public var _target:String;
	public var _is_complete:Boolean;
	public var _ll:Loader;
	
}


