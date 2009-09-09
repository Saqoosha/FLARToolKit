package org.papervision3d.objects
{
	import org.papervision3d.objects.particles.StarParticle;
	import flash.display.Sprite;
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	public class ParticleField extends VertexParticles
	{
		
		private var fieldDepth:Number;
		private var fieldHeight:Number;
		private var fieldWidth:Number;
		private var quantity:int;		
		private var color:int;
		
		/**
		* The ParticleField class creates an object with an amount of particles randomly distributed over a specied 3d area.
		*
		* @param	quantity	The amount of particles to create
		* @param	color		The color of the created particles
		* @param	container	An alternate container to render to, if needed.
		* @param	fieldWidth 	The width of the area
		* @param 	fieldHeight The height of the area
		* @param	fieldDepth	The depth of the area 
		*/
		public function ParticleField(quantity:int = 200, color:int = 0xFFFFFF, container:Sprite = null, fieldWidth:Number = 2000, fieldHeight:Number = 2000, fieldDepth:Number = 2000)
		{
			super("ParticleField");
			
			this.quantity = quantity;
			this.color = color;
			this.container = container;
			
			this.fieldWidth = fieldWidth;
			this.fieldHeight = fieldHeight;
			this.fieldDepth = fieldDepth;
			
			createParticles();
		}
		
		private function createParticles():void
		{
			var vertices:Array = this.geometry.vertices;
			var width2  :Number = fieldWidth /2;
			var height2 :Number = fieldHeight /2;
			var depth2  :Number = fieldDepth /2;
			var c:int;
			var r:int;
			for( var i:Number = 0; i < quantity; i++ )
			{
				addParticle(new StarParticle(color, 1,Math.random() * fieldWidth  - width2, Math.random() * fieldHeight - height2, Math.random() * fieldDepth  - depth2 ));
			}
		}
		
	}
}