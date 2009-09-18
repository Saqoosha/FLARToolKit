/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org ï¿½ blog.papervision3d.org ï¿½ osflash.org/papervision3d
 */

/*
 * Copyright 2006 (c) Carlos Ulloa Matesanz, noventaynueve.com.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
* @author De'Angelo Richardson 
*/
package org.papervision3d.utils
{
	import com.blitzagency.xray.logger.XrayLog;

	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.Number3D;
	import org.papervision3d.core.Matrix3D;
	import org.papervision3d.scenes.InteractiveScene3D;
	import org.papervision3d.utils.InteractiveSceneManager;
	import org.papervision3d.utils.InteractiveSprite;
	import org.papervision3d.utils.InteractiveUtils;

	public class Mouse3D extends DisplayObject3D
	{
		static private var UP 								:Number3D = new Number3D(0, 1, 0);
		
		static public var enabled							:Boolean = true;
		
		public function Mouse3D(initObject:Object=null):void
		{
			
		}
		
		public function updatePosition( face3d:Face3D, container:Sprite ):void
		{			
			var position:Number3D = new Number3D(0, 0, 0);
			var target:Number3D = new Number3D(face3d.faceNormal.x, face3d.faceNormal.y, face3d.faceNormal.z);
				
			var zAxis:Number3D = Number3D.sub(target, position);
			zAxis.normalize();
				
			if (zAxis.modulo > 0.1)
			{
				var xAxis:Number3D = Number3D.cross(zAxis, UP);
				xAxis.normalize();
				
				var yAxis:Number3D = Number3D.cross(zAxis, xAxis);
				yAxis.normalize();
				
				var look:Matrix3D = this.transform;
					
				look.n11 = xAxis.x;
				look.n21 = xAxis.y;
				look.n31 = xAxis.z;
				
				look.n12 = -yAxis.x;
				look.n22 = -yAxis.y;
				look.n32 = -yAxis.z;
				
				look.n13 = zAxis.x;
				look.n23 = zAxis.y;
				look.n33 = zAxis.z;
			}
			
			
			var m:Matrix3D = Matrix3D.IDENTITY;
			this.transform = Matrix3D.multiply(face3d.face3DInstance.instance.world, look);
			var v:Matrix3D = Matrix3D.IDENTITY;
			
			var mx:Number = container.mouseX;
			var my:Number = container.mouseY;
			
			v.n14 = InteractiveUtils.getCoordAtPoint(face3d, mx, my).x;
			v.n24 = InteractiveUtils.getCoordAtPoint(face3d, mx, my).y;
			v.n34 = InteractiveUtils.getCoordAtPoint(face3d, mx, my).z;
			
			m.calculateMultiply( face3d.face3DInstance.instance.world, v );
			
			x = m.n14;
			y = m.n24;
			z = m.n34;
		}
	}
}