package org.papervision3d.objects.particles
{
	import flash.display.Sprite;
	
	public interface IParticle
	{
		function render(container:Sprite):int;
		function update():void;
	}
}