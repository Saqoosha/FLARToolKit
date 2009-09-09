package org.papervision3d.objects.particles
{
	import org.papervision3d.core.geom.Vertex3D;
	import flash.display.Sprite;
	
	public class StarParticle extends AbstractParticle implements IParticle
	{
		/**
		 * StarParticle
		 * 
		 * used by the ParticleField as the Particle object to render.
		 */
		public function StarParticle(color:int=0xFFFFFF, size:int=1, x:Number=0, y:Number=0, z:Number=0)
		{
			super(color, size, x, y, z);
		}
		
		override public function render(container:Sprite):int
		{
			if(vertex3D.vertex2DInstance.visible){
				container.graphics.beginFill(color, 1);
				container.graphics.drawCircle(vertex3D.vertex2DInstance.x, vertex3D.vertex2DInstance.y,size);
				container.graphics.endFill();
			}
			return 1;	
		}
	
	}
}