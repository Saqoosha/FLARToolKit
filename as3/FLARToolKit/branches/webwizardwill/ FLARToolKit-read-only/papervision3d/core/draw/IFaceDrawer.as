package org.papervision3d.core.draw
{
	import flash.display.Graphics;
	
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex2D;
	import flash.geom.Matrix;
	import org.papervision3d.objects.DisplayObject3D;
	
	public interface IFaceDrawer
	{
		function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int;
	}
}