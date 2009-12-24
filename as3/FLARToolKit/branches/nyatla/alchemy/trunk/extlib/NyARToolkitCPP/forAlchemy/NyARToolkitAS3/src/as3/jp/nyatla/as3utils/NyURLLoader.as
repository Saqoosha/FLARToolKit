package jp.nyatla.as3utils{
    import flash.utils.*;
	import 	flash.net.*;
    import 	flash.events.*;

	public class NyURLLoader extends URLLoader
	{
		public var _parent:NyMultiFileLoader;
		public var _index:int;
		public var _accept:Function;
		public var _target:String;	
	}

}

