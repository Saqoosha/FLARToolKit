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
* @author John Grden
*/

package org.papervision3d.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.SpreadMethod;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.objects.DisplayObject3D;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import org.papervision3d.utils.InteractiveSprite;
	
	/**
	 * InteractiveContainerData is a data object for a face or do3d that's passed to the ISM for interaction.  It contains the information that glues all objects involved, together.
	 * @author John
	 * 
	 */	
	
	public class InteractiveContainerData extends EventDispatcher
	{
		public var displayObject3D							:DisplayObject3D = null;
		public var container								:InteractiveSprite;
		public var face3d									:Face3D;
		
		/**
		* Used in the initial reset of the scene and then in the drawing stage.  if set to true, then it'll be sorted
		*/		
		public var isDrawn									:Boolean = false;
		
		/**
		* used in the sort method of the ISM - if true, it's included in the sorted array
		*/		
		public var sort										:Boolean = false;
		
		/**
		* color used for the fill of the face
		*/		
		public var color									:Number = InteractiveSceneManager.DEFAULT_FILL_COLOR;
		/**
		* Alpha value 0-1 of the fill
		*/		
		public var fillAlpha								:Number = InteractiveSceneManager.DEFAULT_FILL_ALPHA;
		/**
		* Line color for the outline of the drawing
		*/		
		public var lineColor								:Number = InteractiveSceneManager.DEFAULT_LINE_COLOR;
		/**
		* Line size to be used
		*/		
		public var lineSize									:Number = InteractiveSceneManager.DEFAULT_LINE_SIZE;
		/**
		* Lind Alpha to be used
		*/		
		public var lineAlpha								:Number = InteractiveSceneManager.DEFAULT_LINE_ALPHA;
		
		/**
		 * Used in the ISM's sort method to sort the containers
		 * @return 
		 * 
		 */		
		public function get screenZ():Number
		{
			return displayObject3D != null ? displayObject3D.screenZ : face3d.screenZ;
		}
		
		public function InteractiveContainerData(container3d:*, p_color:Number=0x000000, target:IEventDispatcher=null)
		{
			super(target);

			displayObject3D = container3d is DisplayObject3D == true ? container3d : null;
			face3d = container3d is Face3D == true ? container3d : null;
			
			if( displayObject3D != null ) this.container = new InteractiveSprite(container3d);
			if( face3d != null )
			{
				if( face3d.face3DInstance.container != null )
				{
					this.container = InteractiveSprite(face3d.face3DInstance.container);
				}
				else
				{
					this.container = new InteractiveSprite();
				}
			}
			color = p_color;
			
			container.alpha = InteractiveSceneManager.DEFAULT_SPRITE_ALPHA;
			container.interactiveContainerData = this;
		}		
	}
}