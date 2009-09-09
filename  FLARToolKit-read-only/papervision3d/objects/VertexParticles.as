package org.papervision3d.objects
{
	/**
	 * @Author Ralph Hauwert
	 */
	
	import flash.display.Sprite;
	
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.geom.Vertex3D;
	import org.papervision3d.core.geom.Vertices3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.objects.particles.AbstractParticle;
	import org.papervision3d.objects.particles.IParticle;
	
	public class VertexParticles extends Vertices3D
	{
		
		private var vertices:Array;
		private var particles:Array;
		
		/**
		 * VertexParticles
		 * 
		 * A simple Particle Renderer for Papervision3D.
		 * 
		 * Renders added particles to a given container using Flash's drawing API.
		 */
		public function VertexParticles(name:String = "VertexParticles")
		{
			this.vertices = new Array();
			this.particles = new Array();
			super(vertices, name);
		}
		
		/**
		 *	render(scene);
		 *
		 * Renders the particles added to this VertexParticles Object
		 */
		public override function render(scene:SceneObject3D ):void
		{
			var vertices:Array = this.geometry.vertices;
			var container:Sprite = this.container || scene.container;
			var particle:IParticle;
			if(this.container){
				container.graphics.clear();
			}
			for each(particle in particles)
			{
				scene.stats.particles += particle.render(container);
			}
		}
		
		/**
		 * addParticle(particle);
		 * 
		 * @param	particle	partical to be added and rendered by to this VertexParticles Object.
		 */
		public function addParticle(particle:AbstractParticle):void
		{
			particles.push(particle);
			vertices.push(particle.vertex3D);
		}
		
		/**
		 * removeParticle(particle);
		 * 
		 * @param	particle	partical to be removed from this VertexParticles Object.
		 */
		public function removeParticle(particle:AbstractParticle):void
		{
			particles.splice(particles.indexOf(particle,0));
			vertices.splice(vertices.indexOf(particle.vertex3D,0));
		}
		
		/**
		 * removeAllParticles()
		 * 
		 * removes all particles in this VertexParticles Object.
		 */
		public function removeAllParticles():void
		{
			particles = new Array();
			vertices = new Array();
		}
		
	}
}