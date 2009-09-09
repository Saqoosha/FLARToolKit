package org.papervision3d.materials
{
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3D;
	import flash.display.Graphics;
	import org.papervision3d.core.geom.Vertex2D;
	import flash.geom.Matrix;
	
	public class InteractiveMovieAssetMaterial extends MovieAssetMaterial
	{
		public function InteractiveMovieAssetMaterial(linkageID:String, transparent:Boolean=false, animated:Boolean=false)
		{
			super(linkageID, transparent, animated);
		}
		
		/**
		 *  drawFace3D
		 */
		override public function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
		{
			var result:int = super.drawFace3D(instance, face3D, graphics, v0, v1,v2);
			if(instance.interactiveSceneManager != null && result) instance.interactiveSceneManager.drawFace(instance,face3D,v0.x, v1.x, v2.x, v0.y, v1.y, v2.y);
			return result;
		}	
	}
}