package org.libspark.flartoolkit.sandy3D {
	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import sandy.core.data.*;
	import sandy.core.scenegraph.*;
	
	/**
	 * @author	Makc the Great
	 * @url		http://makc3d.wordpress.com/
	 */
	public class FLARBaseNode extends TransformGroup {
		
		public function FLARBaseNode() {
			super();
		}
		
		public function setTransformMatrix(r:FLARTransMatResult):void {
			var m:Matrix4 = new Matrix4;
			m.n11 =  r.m01; m.n12 =  r.m00; m.n13 =  r.m02; m.n14 =  r.m03;
			m.n21 = -r.m11; m.n22 = -r.m10; m.n23 = -r.m12; m.n24 = -r.m13;
			m.n31 =  r.m21; m.n32 =  r.m20; m.n33 =  r.m22; m.n34 =  r.m23;
			resetCoords (); matrix = m;
			// update scales?
			scaleX = Math.sqrt(m.n11 * m.n11 + m.n21 * m.n21 + m.n31 * m.n31);
			scaleY = Math.sqrt(m.n12 * m.n12 + m.n22 * m.n22 + m.n32 * m.n32);
			scaleZ = Math.sqrt(m.n13 * m.n13 + m.n23 * m.n23 + m.n33 * m.n33);
		}
	}
}