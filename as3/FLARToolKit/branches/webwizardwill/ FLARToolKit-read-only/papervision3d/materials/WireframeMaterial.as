/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org  blog.papervision3d.org  osflash.org/papervision3d
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

// __________________________________________________________________________ WIREFRAME MATERIAL

package org.papervision3d.materials
{
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.draw.IFaceDrawer;
	import org.papervision3d.core.geom.Face3D;
	import flash.display.Graphics;
	import org.papervision3d.core.geom.Vertex2D;
	import flash.geom.Matrix;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	* The WireframeMaterial class creates a wireframe material, where only the outlines of the faces are drawn.
	* <p/>
	* Materials collects data about how objects appear when rendered.
	*/
	public class WireframeMaterial extends MaterialObject3D implements IFaceDrawer
	{
		// ______________________________________________________________________ NEW

		/**
		* The WireframeMaterial class creates a wireframe material, where only the outlines of the faces are drawn.
		*
		* @param	asset				A BitmapData object.
		* @param	initObject			[optional] - An object that contains additional properties with which to populate the newly created material.
		*/
		public function WireframeMaterial( color:Number=0xFF00FF, alpha:Number=100 )
		{
			this.lineColor   = color;
			this.lineAlpha   = alpha;

			this.doubleSided = false;
		}
		
		/**
		 *  drawFace3D
		 */
		override public function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
		{
			var x0:Number = v0.x;
			var y0:Number = v0.y;
			var x1:Number = v1.x;
			var y1:Number = v1.y;
			var x2:Number = v2.x;
			var y2:Number = v2.y;

			if( lineAlpha )
			{
				graphics.lineStyle( 0, lineColor, lineAlpha );
				graphics.moveTo( x0, y0 );
				graphics.lineTo( x1, y1 );
				graphics.lineTo( x2, y2 );
				graphics.lineTo( x0, y0 );
				graphics.lineStyle();

				return 1;
			}
			else
				return 0;
		}

		// ______________________________________________________________________ TO STRING

		/**
		* Returns a string value representing the material properties in the specified WireframeMaterial object.
		*
		* @return	A string.
		*/
		public override function toString(): String
		{
			return 'WireframeMaterial - color:' + this.lineColor + ' alpha:' + this.lineAlpha;
		}
	}
}