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
* ...
* @author John Grden
* @author De'Angelo Richardson
* @version 0.1
*/
package org.papervision3d.utils
{
	import flash.display.Sprite;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * InteractiveSprite is used whenever a face container is created whether in the ISM or with DO3D's.
	 * 
	 * It provides a pointer reference back to the DO3D using it as well as the InteractiveContainerData that might be associated with it
	 * @author John
	 * 
	 */	
	public class InteractiveSprite extends Sprite
	{
		public var obj:DisplayObject3D = null;
		public var interactiveContainerData:InteractiveContainerData = null;
		
		public var x0:Number;
		public var x1:Number;
		public var x2:Number;
		public var y0:Number;
		public var y1:Number;
		public var y2:Number;	
		
		public function InteractiveSprite(obj:DisplayObject3D=null):void
		{
			this.obj = obj;
		}
	}
}