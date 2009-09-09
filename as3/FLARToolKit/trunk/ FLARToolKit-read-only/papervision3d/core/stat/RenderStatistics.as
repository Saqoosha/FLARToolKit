package org.papervision3d.core.stat
{
	public class RenderStatistics
	{
		public var performance:int = 0;
		public var points:int = 0;
		public var polys:int = 0;
		public var rendered:int = 0;
		public var triangles:int = 0;
		public var culledTriangles:int = 0;
		public var pixels:Number;
		public var particles:Number;
		
		public function RenderStatistics()
		{
			
		}
		
		public function clear():void
		{
			performance = 0;
			points = 0;
			polys = 0;
			rendered = 0;
			triangles = 0;
			pixels = 0;
			particles = 0;
			culledTriangles = 0;
		}
		
		public function toString():String
		{
			return new String("Performance:"+performance+", Points:"+points+" Polys:"+polys+" Rendered:"+rendered+" Culled:"+culledTriangles);
		}
		
	}
}