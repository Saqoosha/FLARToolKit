package sketch 
{
	import flash.geom.Rectangle;
	import jp.nyatla.as3utils.sketch.*;
	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.detector.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;	

	/**
	 * デバック用のスケッチ。
	 * 画像表示用のbitmap,メッセージ表示用のtextboxを持つ。
	 */
	public class DebugSketch extends FLSketch
	{
		public static var inst:DebugSketch;
		public var bitmap:Bitmap = new Bitmap(new BitmapData(320,240));
        public var textbox:TextField = new TextField();
		public function DebugSketch()
		{
			//setup UI
			DebugSketch.inst = this;
			this.textbox.x = 0; this.textbox.y = 0;
			this.textbox.width=640,this.textbox.height=480; 
			this.textbox.condenseWhite = true;
			this.textbox.multiline =   true;
			this.textbox.border = true;
			this.textbox.visible = true;
			this.bitmap.x = 640; this.bitmap.y = 0;
			this.bitmap.width = 320;
			this.bitmap.height = 240;
            addChild(textbox);
            addChild(bitmap);			
		}
		public function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}
	}
}