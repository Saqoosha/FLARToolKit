package org.papervision3d.core.culling
{
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.geom.Face3DInstance;
	import org.papervision3d.objects.DisplayObject3D;
	
	public interface ITriangleCuller
	{
		function testFace(displayObject:DisplayObject3D, faceInstance:Face3DInstance, vertex0:Vertex2D, vertex1:Vertex2D, vertex2:Vertex2D):Boolean;
	}
}