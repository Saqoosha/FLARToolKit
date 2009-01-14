package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.libspark.flartoolkit.core.FLARCode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FLARCodeImage extends Sprite
	{
		private var _image:Bitmap;
		private var _code:FLARCode;
		
		public function FLARCodeImage(code:FLARCode,width:uint = 300,height:uint = 300) 
		{
			this._code = code;
			var patBW:Array = this._code.getPatBW()[0];
			var pWidth:int = this._code.getWidth();
			var pHeight:int = this._code.getHeight();

			var bmp:BitmapData = new BitmapData(pWidth, pHeight);
			var bw:uint;
			var color:uint;
			for (var x:uint = 0; x < pWidth; x++) {
				for (var y:uint = 0; y < pHeight; y++) {//(0:R/1:G/2:B)
					bw = (255-((patBW[y][x] & 0xFF) + this._code.averageOfPattern))&0xFF;
					color = (bw << 16) | (bw << 8) | bw;
					bmp.setPixel(x, y, color);
				}
			}
			
			var shape:Shape = new Shape();
			var image:Bitmap = new Bitmap(bmp);
			image.scaleX = width * (this._code.markerPercentWidth / 100) / image.width;
			image.scaleY = height * (this._code.markerPercentHeight / 100) / image.height;
			image.x = (width - image.width) / 2;
			image.y = (height - image.height) / 2;
			
			shape.graphics.beginFill(0x000000);
			shape.graphics.drawRect(0, 0, width, height);
			this.addChild(shape);
			this.addChild(image);
		}
	}
}