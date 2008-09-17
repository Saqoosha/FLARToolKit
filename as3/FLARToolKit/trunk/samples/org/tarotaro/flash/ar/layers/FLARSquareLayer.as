package org.tarotaro.flash.ar.layers 
{
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARSquare;
	import com.libspark.flartoolkit.core.FLARSquareDetector;
	import com.libspark.flartoolkit.core.FLARSquareList;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	
	/**
	* 
	* @author 太郎
	*/
	public class FLARSquareLayer extends FLARLayer
	{
		private var _detector:FLARSquareDetector;
		private var _squareList:FLARSquareList;

		private var _thickness:Number=NaN;
		private var _color:uint=0;
		private var _alpha:Number=1.0;
		private var _pixelHinting:Boolean=false;
		private var _scaleMode:String=LineScaleMode.NORMAL;
		private var _caps:String=null;
		private var _joints:String=null;
		private var _miterLimit:Number = 3;

		public function FLARSquareLayer(src:FLARBitmapData, param:FLARParam, thresh:int=100) 
		{
			super(src,thresh);
			this._squareList = new FLARSquareList(10);
			this._detector = new FLARSquareDetector(param);
		}
		
		/**
		 * sourceに対してSquareの検索を行い、発見したSquareを描画する
		 */
		override public function update():void
		{
			this._detector.detectSquare(this._source, this._thresh, this._squareList);
			this.graphics.clear();
			var squareNum:int = this._squareList.getSquareNum();
			var square:FLARSquare;
			var v:Array;

			for (var i:int = 0; i < squareNum; i++) {
				square = this._squareList.getSquare(i);
				v = square.sqvertex;
				this.graphics.lineStyle(this._thickness, 
										this._color, 
										this._alpha, 
										this._pixelHinting, 
										this._scaleMode, 
										this._caps, 
										this._joints, 
										this._miterLimit);
				this.graphics.moveTo(v[3][0], v[3][1]);
				for (var vi:int = 0; vi < v.length; vi++) {
					this.graphics.lineTo(v[vi][0], v[vi][1]);
				}
			}
			
		}
		
		public function lineStyle(thickness:Number=NaN,color:uint=0,alpha:Number=1.0,pixelHinting:Boolean=false,scaleMode:String=LineScaleMode.NORMAL,caps:String=null,joints:String=null,miterLimit:Number=3) :void
		{
			this._thickness = thickness;
			this._color = color;
			this._alpha = alpha ;
			this._pixelHinting = pixelHinting ;
			this._scaleMode = scaleMode ;
			this._caps = caps ;
			this._joints = joints ;
			this._miterLimit = miterLimit ;
		}

	}
	
}