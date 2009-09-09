package org.papervision3d.materials.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.InteractiveBitmapMaterial;
	
	public class BitmapMaterialTools
	{
		public static function createBitmapMaterial(bitmapClass:Class, oneSided:Boolean=true):BitmapMaterial
		{
			var texture:BitmapData = getTexture(bitmapClass);
			var material:BitmapMaterial = new BitmapMaterial(texture);
			material.oneSide = oneSided;
			return material;
		}
		
		public static function createInteractiveBitmapMaterial(bitmapClass:Class, oneSided:Boolean=true):InteractiveBitmapMaterial
		{
			var texture:BitmapData = getTexture(bitmapClass);
			var material:InteractiveBitmapMaterial = new InteractiveBitmapMaterial(texture);
			material.oneSide = oneSided;
			return material;
		}
		
		public static function getTexture(bitmapClass:Class):BitmapData
		{
			var bm:Bitmap = Bitmap(new bitmapClass());
			var texture  :BitmapData = new BitmapData(bm.width, bm.height, true,0xFFFFFF);
			texture.draw(bm, new Matrix());
			return texture;
		}
	}
}