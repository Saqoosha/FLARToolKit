
package org.papervision3d.materials 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.NumberUV;
		
	public interface IPreciseMaterial 
	{		
		function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
		
		function renderRec(graphics:Graphics, ta:Number, tb:Number, tc:Number, td:Number, tx:Number, ty:Number, 
            ax:Number, ay:Number, az:Number, bx:Number, by:Number, bz:Number, cx:Number, cy:Number, cz:Number, index:Number):void
		
		function renderTriangleBitmap(graphics:Graphics,a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number, 
            v0x:Number, v0y:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number, smooth:Boolean, repeat:Boolean):void
	}	
}
