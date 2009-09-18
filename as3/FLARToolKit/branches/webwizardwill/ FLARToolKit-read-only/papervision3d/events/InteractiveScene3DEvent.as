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
* @version 0.1
*/


package org.papervision3d.events
{
	import flash.events.Event;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.objects.DisplayObject3D;
	import flash.display.Sprite;
	import org.papervision3d.utils.InteractiveContainerData;

	public class InteractiveScene3DEvent extends Event
	{
		/**
		 * Dispatched when a container in the ISM recieves a MouseEvent.CLICK event
		* @eventType mouseClick
		*/
		public static const OBJECT_CLICK:String = "mouseClick";
		/**
		 * Dispatched when a container in the ISM receives an MouseEvent.MOUSE_OVER event
		* @eventType mouseOver
		*/
		public static const OBJECT_OVER:String = "mouseOver";
		/**
		 * Dispatched when a container in the ISM receives an MouseEvent.MOUSE_OUT event
		* @eventType mouseOut
		*/
		public static const OBJECT_OUT:String = "mouseOut";
		/**
		 * Dispatched when a container in the ISM receives a MouseEvent.MOUSE_MOVE event
		* @eventType mouseMove
		*/
		public static const OBJECT_MOVE:String = "mouseMove";
		/**
		 * Dispatched when a container in the ISM receives a MouseEvent.MOUSE_PRESS event
		* @eventType mousePress
		*/
		public static const OBJECT_PRESS:String = "mousePress";
		/**
		 * Dispatched when a container in the ISM receives a MouseEvent.MOUSE_RELEASE event
		* @eventType mouseRelease
		*/
		public static const OBJECT_RELEASE:String = "mouseRelease";
		/**
		 * Dispatched when the main container of the ISM is clicked
		* @eventType mouseReleaseOutside
		*/
		public static const OBJECT_RELEASE_OUTSIDE:String = "mouseReleaseOutside";
		/**
		 * Dispatched when a container is created in the ISM for drawing and mouse interaction purposes
		* @eventType objectAdded
		*/
		public static const OBJECT_ADDED:String = "objectAdded";
		
		public var displayObject3D				:DisplayObject3D = null;
		public var sprite						:Sprite = null;
		public var face3d						:Face3D = null;
		public var interactiveContainerData		:InteractiveContainerData = null;
		
		public function InteractiveScene3DEvent(type:String, container3d:DisplayObject3D=null, sprite:Sprite=null, face3d:Face3D=null, interactiveContainerData:InteractiveContainerData=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.displayObject3D = container3d;
			this.sprite = sprite;
			this.face3d = face3d;
			this.interactiveContainerData = interactiveContainerData;
		}		
	}
}