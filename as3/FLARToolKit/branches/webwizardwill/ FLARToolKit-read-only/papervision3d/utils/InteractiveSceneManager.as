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

package org.papervision3d.utils 
{
	import com.blitzagency.xray.logger.XrayLog;
	import com.blitzagency.xray.logger.util.ObjectTools;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.papervision3d.core.geom.Mesh3D;
	import org.papervision3d.core.geom.Face3DInstance;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.utils.InteractiveSprite;
	import org.papervision3d.materials.InteractiveMovieMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.components.as3.utils.CoordinateTools;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.geom.Vertex3D;
	import org.papervision3d.utils.virtualmouse.VirtualMouse;
	
	
	/**
	* Dispatched when an InteractiveSprite container in the ISM recieves a MouseEvent.CLICK
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_CLICK
	*/
	[Event(name="mouseClick", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite in the ISM receives an MouseEvent.MOUSE_OVER event
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_OVER
	*/
	[Event(name="mouseOver", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite in the ISM receives an MouseEvent.MOUSE_OUT event
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_OUT
	*/
	[Event(name="mouseOut", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite in the ISM receives a MouseEvent.MOUSE_MOVE event
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_MOVE
	*/
	[Event(name="mouseMove", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite in the ISM receives a MouseEvent.MOUSE_PRESS event
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_PRESS
	*/
	[Event(name="mousePress", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite in the ISM receives a MouseEvent.MOUSE_RELEASE event
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_RELEASE
	*/
	[Event(name="mouseRelease", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when the main container of the ISM is clicked
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE
	*/
	[Event(name="mouseReleaseOutside", type="org.papervision3d.events.InteractiveScene3DEvent")]
	/**
	* Dispatched when an InteractiveSprite is created in the ISM for drawing and mouse interaction purposes
	* 
	* @eventType org.papervision3d.events.InteractiveScene3DEvent.OBJECT_ADDED
	*/
	[Event(name="objectAdded", type="org.papervision3d.events.InteractiveScene3DEvent")]
	
	/**
	 * InteractiveSceneManager handles all the traffic and sub rendering of faces for mouse interactivity within an interactive scene.
	 * </p>
	 * <p>
	 * When you create an InteractiveScene3D object, it automatically creates the InteractiveSceneManager (ISM for short) for you.  From there on, any 3D object using an interactive material
	 * will automatically be given mouse events that are dispatched through the ISM OR the DisplayObject3D itself.  The event type is InteractiveScene3DEvent.
	 * </p>
	 * <p>
	 * ISM has 2 modes:
	 * <ul>
	 * <li>Object level mode</li>
	 * <li>Face level mode</li>
	 * </ul>
	 * </p>
	 * <p>
	 * Object level mode is a bit faster in that sprite containers for the objects are created and then all faces are drawn in that container.  You're able to receive mouse 
	 * events based on the objects, but not the contents of the materials used on the objects.
	 * </P>
	 * <p>
	 * For example, if you created a movieclip, put UI components in it and applied it to a DisplayObject3D (DO3D for short), you would not be able to interact with those elements in
	 * your movieclip.  But you WOULD be able to have mouse events on the entire DO3D.
	 * </p>
	 * <p>
	 * Face level mode creates sprite containers for each face of a DO3D that uses an interactive material and gives you the ability to interact with a movieclips objects like UI components.
	 * </p>
	 * <p>
	 * For example, if you created a movieclip, put UI components in it and applied it to a DO3D, you would be able to interact with those elements in
	 * your movieclip and receive their mouse events like you normally would.
	 * </p>
	 * <p>There is one other option for faceLevelMode and that's directly on the DO3D's themselves.  This is even heavier in terms of speed, but its there if you need face level access to all DO3D's.
	 * DisplayObject3D.faceLevelMode is a public static property that when set to true, causes all DO3D's do create their own sprite containers for their faces.  The difference between
	 * this and what the ISM does is that, the ISM only draws faces for DO3D's that have interactive materials - giving you the control you need to dictate what needs interactivity and what doesn't.
	 * </p>
	 * @author John Grden
	 * 
	 */	
	public class InteractiveSceneManager extends EventDispatcher
	{
		/**
		* The ISM, by default, uses a BlendMode.ERASE to hide the hit area of the drawn face.
		* Setting this to true will show the drawn faces and give you the ability to add whatever type effects/filters you want
		* over your scene and 3D objects.
		* </p>
		* <p>
		* When set to true, you should set DEFAULT_SPRITE_ALPHA, DEFAULT_FILL_ALPHA and DEFAULT_FILL_COLOR as these will dictate how the faces are drawn over the scene.
		* </p>
		* <p>
		* Setting DEFAULT_SPRITE_ALPHA = 0 will give you the same effect as the blendmode, but only slower.  A combination of DEFAULT_SPRITE_ALPHA and DEFAULT_FILL_ALPHA along with filters
		 * can really give you some nice visual affects over your scene for your 3D objects.
		*/
		public static var SHOW_DRAWN_FACES							:Boolean = false;
		
		/**
		* Alpha value 0-1 of the sprite container created for DO3D's or Face3D containers in the ISM
		*/		
		public static var DEFAULT_SPRITE_ALPHA						:Number = 1;
		/**
		* Alpha value 0-1 of the drawn face
		*/		
		public static var DEFAULT_FILL_ALPHA						:Number = 1;
		/**
		* Color used to draw the face in the sprite container
		*/		
		public static var DEFAULT_FILL_COLOR						:Number = 0xFFFFFF;
		/**
		* Color used for the line drawn around the face
		*/		
		public static var DEFAULT_LINE_COLOR						:Number = -1;
		/**
		* Line size of the line drawn around the face
		*/		
		public static var DEFAULT_LINE_SIZE 						:Number = 1;
		/**
		* Alpha value 0-1 of the line drawn around the face
		*/		
		public static var DEFAULT_LINE_ALPHA						:Number = 1;
		/**
		* MOUSE_IS_DOWN is a quick static property to check and is maintained by the ISM
		*/
		public static var MOUSE_IS_DOWN								:Boolean = false;
		/**
		* When set to true, the hand cursor is shown over objects that have mouse events assigned to it.
		*/
		public var buttonMode										:Boolean = false;		
		/**
		* This allows objects faces to have their own containers.  When set to true
		* and the DisplayObject3D.faceLevelMode = false, the faces will be drawn in ISM's layer of containers
		*/
		public var faceLevelMode  									:Boolean = false;		
		
		private var _mouseInteractionMode							:Boolean = false;
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set mouseInteractionMode(value:Boolean):void
		{
			_mouseInteractionMode = value;
			allowDraw = !value;
			if( value ) container.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleStageMouseMove);
			if( !value ) container.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleStageMouseMove);
		}
		/**
		* If the user sets this to true, then we monitor the allowDraw flag via mouse interaction and we only draw the faces if there's mouse interaction with the scene.
		 * This is meant to maximize CPU for interactivity
		* If set to true, then leave SHOW_DRAWN_FACES set to false to avoid odd drawings over the 3D scene
		*/
		public function get mouseInteractionMode():Boolean { return _mouseInteractionMode; }
		
		/**
		* A dictionary where the InteractiveContainerData objects are stored for DO3D's or Face3D objects.  You can get to a DO3D or Face3D's InteractiveContainerDate object
		 * with:
		 * </P>
		 * <p>
		 * <code>
		 * var icd:InteractiveContainerData = faceDictionary[do3dInstance];
		 * </code>
		 * </p>
		*/		
		public var faceDictionary									:Dictionary = new Dictionary();
		/**
		* A dictionary where the DO3D's and Face3D objects are stored.  You can get to a DO3D or Face3D by supplying the sprite container reference:
		 * </P>
		 * <p>
		 * <code>
		 * var do3d:DisplayObject3D = containerDictionary[spriteInstance];
		 * or
		 * var face3d:Face3D = containerDictionary[spriteInstance];
		 * </code>
		 * </p>
		*/	
		public var containerDictionary								:Dictionary = new Dictionary();
		/**
		* Main container for ISM to create the sub InteractiveSprite containers for the faces and DO3D objects passed in during the render loop
		*/		
		public var container										:Sprite = new InteractiveSprite();
		/**
		* InteractiveScene3D instance, usually passed in by the constructor
		*/		
		public var scene											:SceneObject3D;
		/**
		* Mouse3D gives you a pointer in 3D space that orients itself to a face your mouse is currently over.  It copy's the transform information of the face giving you the ability to do something in 3D at that same location
		*/		
		public var mouse3D											:Mouse3D = new Mouse3D();
		/**
		* VirtualMouse is used with faceLevelMode of ISM or DO3D's.  Its a virtual mouse that causes the objects in your materials movieclip containers to fire off their mouse events such as click, over, out, release, press etc
		 * </p>
		 * <p>
		 * Using these events requires you only to do what you normally do - establish listeners with your objects like you normally would, and you'll receive them!
		*/		
		public var virtualMouse										:VirtualMouse = new VirtualMouse();
		/**
		 * @private 
		 */		
		public function set enableMouse(value:Boolean):void
		{
			Mouse3D.enabled = value;
		}
		/**
		* Boolean value that sets Mouse3D.enabled = true
		*/
		public function get enableMouse():Boolean { return Mouse3D.enabled; }
		
		/**
		* Setting to true will show output via trace window in IDE or Xray's output
		*/
		public var debug											:Boolean = false;
		
		/**
		* @private
		* Boolean flag used internally to turn off ISM drawing when it's not needed in the render loop.  This only applies if mouseInteractionMode is set to true.
		*/
		protected var allowDraw										:Boolean = true;
		
		/**
		* @private
		* When mouseInteractionMode is turned on, this tells ISM's MouseOver event to dispatch a click event
		*/
		protected var evaluateClick									:Boolean = false;
		
		/**
		* @private
		*/		
		protected var log											:XrayLog = new XrayLog();
		
		/**
		* 
		* @param	p_scene The InteractiveScene3D object instance.  This is passed in via the constructor of InteractiveScene3D when you create a new one.
		* @return
		*/
		public function InteractiveSceneManager(p_scene:SceneObject3D):void
		{
			container.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			scene = p_scene;
			scene.container.parent.addChild(container);
			container.x = scene.container.x;
			container.y = scene.container.y;			
		
			enableMouse = false;
		}
		
		/**
		* Convenience method to help set the default parameters of the ISM.
		* This gives you faceLevelMode and buttonMode interaction on your scene.  Setting faceLevelMode = false reverts ISM to Object level mode
		* @return
		*/
		public function setInteractivityDefaults():void 
		{
		   SHOW_DRAWN_FACES = false;
		   DEFAULT_SPRITE_ALPHA = 1;
		   DEFAULT_FILL_ALPHA = 1;

		   BitmapMaterial.AUTO_MIP_MAPPING = false;
		   DisplayObject3D.faceLevelMode = false;

		   buttonMode = true;
		   faceLevelMode = true;
		   mouseInteractionMode = false;
		}

		/**
		* Adds a DisplayObject3D or Face3D object to the ISM
		* @param	container3d
		* @return
		*/
		public function addInteractiveObject(container3d:Object):void
		{
			if(faceDictionary[container3d] == null) 
			{
				var icd:InteractiveContainerData = faceDictionary[container3d] = new InteractiveContainerData(container3d);
				
				// for reverse lookup when you have the sprite container
				containerDictionary[icd.container] = container3d;
				
				// add mouse events to be captured and passed along
				var icdContainer:InteractiveSprite = icd.container;
				icdContainer.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
				icdContainer.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
				icdContainer.addEventListener(MouseEvent.CLICK, handleMouseClick);
				icdContainer.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
				icdContainer.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
				icdContainer.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				
				icdContainer.buttonMode = buttonMode;
				if( !SHOW_DRAWN_FACES && !DisplayObject3D.faceLevelMode ) icdContainer.blendMode = BlendMode.ERASE;
				
				// need to let virtualMouse know what to ignore
				virtualMouse.ignore(icdContainer);
				
				// let others know we've added a container
				dispatchEvent(new InteractiveScene3DEvent(InteractiveScene3DEvent.OBJECT_ADDED, null, icdContainer));
				
				if(debug) log.debug("addDisplayObject id", container3d.id, container3d.name, DEFAULT_SPRITE_ALPHA);
			}
		}
		
		/**
		* drawFace is called from each of the interactive materials in the render loop.  It either receives DisplayObject3D or a Face3D object reference.  It then creates a container
		 * if one doesn't exist.  Then, it draws the face into the designated container which is an InteractiveSprite.
		* 
		* @param	container3d
		* @param	face3d
		* @param	x0
		* @param	x1
		* @param	x2
		* @param	y0
		* @param	y1
		* @param	y2
		* @return
		*/
		public function drawFace(container3d:DisplayObject3D, face3d:Face3D, x0:Number, x1:Number, x2:Number, y0:Number, y1:Number, y2:Number ):void
		{
			// if we're face level on this DO3D, then we switch to the face3D object
			var container:Object = container3d;
			if(faceLevelMode || DisplayObject3D.faceLevelMode) container = face3d;
			
			// add to the dictionary if not added already
			if(faceDictionary[container] == null) addInteractiveObject(container);

			if( allowDraw && !DisplayObject3D.faceLevelMode )
			{
				var drawingContainer:InteractiveContainerData = faceDictionary[container];
				var iContainer:InteractiveSprite = drawingContainer.container;
				var graphics:Graphics = iContainer.graphics;
				
				
				iContainer.x0 = x0;
				iContainer.x1 = x1;
				iContainer.x2 = x2;
				iContainer.y0 = y0;
				iContainer.y1 = y1;
				iContainer.y2 = y2;
				
				graphics.beginFill(drawingContainer.color, drawingContainer.fillAlpha);
				if( drawingContainer.lineColor != -1 && SHOW_DRAWN_FACES ) graphics.lineStyle(drawingContainer.lineSize, drawingContainer.lineColor, drawingContainer.lineAlpha);
				graphics.moveTo( x0, y0 );
				graphics.lineTo( x1, y1 );
				graphics.lineTo( x2, y2 );
				graphics.endFill();
				drawingContainer.isDrawn = true;
			}
		}
		
		/*
		public function getSprite(container3d:DisplayObject3D):InteractiveSprite
		{
			return InteractiveContainerData(faceDictionary[container3d]).container;
		}
		
		public function getDisplayObject3D(sprite:InteractiveSprite):DisplayObject3D
		{
			return DisplayObject3D(containerDictionary[sprite]);
		}
		*/
		
		/**
		 * When called, aligns the ISM's container with the scene's container to make sure faces drawn in the ISM are aligned with the scene perfectly
		 * 
		 */		
		public function resizeStage():void
		{
			container.x = scene.container.x;
			container.y = scene.container.y;
		}
		
		/**
		 * When called, all faces are cleared and the isDrawn flag is reset on the InteractiveContainerData objects to ready them for the next loop.
		 * 
		 * This is called via InteractiveScene3D before the render.
		 * 
		 */		
		public function resetFaces():void
		{			
			// clear all triangles/faces that have been drawn
			for each( var item:InteractiveContainerData in faceDictionary)
			{
				item.container.graphics.clear();
				item.sort = item.isDrawn;
				item.isDrawn = false;
			}
			
			// make sure the sprite is aligned with the scene's canvas
			resizeStage();
		}
		
		/**
		 * After the render loop is completed, InteractiveScene3D calls this method to sort the interactive scene objects.  If nothing was drawn into a container, it's completely 
		 * ignored at this level as well.
		 * 
		 */		
		public function sortObjects():void
		{
			// called from the scene after the render loop is completed
			var sort:Array = [];
			
			for each( var item:InteractiveContainerData in faceDictionary)
			{
				if(!item.sort) continue;
				var distance:Number = item.face3d == null ? item.screenZ : item.face3d.face3DInstance.screenZ;
				sort.push({container:item.container, distance:distance});
			}
			
			sort.sortOn("distance", Array.DESCENDING | Array.NUMERIC);
			
			for(var i:uint=0;i<sort.length;i++) container.addChild(sort[i].container);
			
			// after the render loop is complete, and we've sorted, we reset the allowDraw flag
			if( mouseInteractionMode ) allowDraw = false;
		}
		
		/**
		 * @private
		 * @param e
		 * 
		 */		
		protected function handleAddedToStage(e:Event):void
		{
			container.stage.addEventListener (Event.RESIZE, handleResize);
			container.stage.addEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside);
			
			virtualMouse.stage = container.stage;
		}
		
		/**
		 * Handles the MOUSE_DOWN event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMousePress(e:MouseEvent):void
		{
			MOUSE_IS_DOWN = true;
			if( virtualMouse ) virtualMouse.press();
			dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_PRESS, Sprite(e.currentTarget));
		}
		/**
		 * Handles the MOUSE_UP event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseRelease(e:MouseEvent):void
		{
			MOUSE_IS_DOWN = false;
			if( virtualMouse ) virtualMouse.release();
			dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_RELEASE, Sprite(e.currentTarget));
		}
		/**
		 * Handles the MOUSE_CLICK event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseClick(e:MouseEvent):void
		{
			dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_CLICK, Sprite(e.currentTarget));
		}
		/**
		 * Handles the MOUSE_OVER event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseOver(e:MouseEvent):void
		{
			var eventType:String
			eventType = !evaluateClick || !mouseInteractionMode ? InteractiveScene3DEvent.OBJECT_OVER : InteractiveScene3DEvent.OBJECT_CLICK;
			evaluateClick = false;
			
			if( virtualMouse && eventType == InteractiveScene3DEvent.OBJECT_CLICK ) virtualMouse.click()
			dispatchObjectEvent(eventType, Sprite(e.currentTarget));
		}
		/**
		 * Handles the MOUSE_OUT event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseOut(e:MouseEvent):void
		{
			if( VirtualMouse && ( faceLevelMode || DisplayObject3D.faceLevelMode ))
			{
				try
				{
					var face3d:Face3D = containerDictionary[e.currentTarget];
					var p:Object = InteractiveUtils.getMapCoordAtPoint(face3d, container.mouseX, container.mouseY);
					
					var mat:InteractiveMovieMaterial = InteractiveMovieMaterial(face3d.face3DInstance.instance.material);
					var rect:Rectangle = new Rectangle(0, 0, mat.movie.width, mat.movie.height);
					var contains:Boolean = rect.contains(p.x, p.y);
					
					if (!contains) virtualMouse.exitContainer();
				}catch(err:Error)
				{
					log.error("material type is not Interactive.  If you're using a Collada object, you may have to reassign the material to the object after the collada scene is loaded", err.message);
				}
			}
			
			dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OUT, Sprite(e.currentTarget));
		}
		/**
		 * Handles the MOUSE_MOVE event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseMove(e:MouseEvent):void
		{	
			var point:Object;
			if( VirtualMouse && ( faceLevelMode || DisplayObject3D.faceLevelMode ))
			{
				// need the face3d for the coordinate conversion
				var face3d:Face3D = containerDictionary[e.currentTarget];
				
				// get 2D coordinates
				point = InteractiveUtils.getMapCoordAtPoint(face3d, container.mouseX, container.mouseY);
				
				//log.debug("material type", ObjectTools.getImmediateClassPath(face3d.face3DInstance.instance.material), face3d.face3DInstance.instance.material is InteractiveMovieMaterial);
				try
				{
					// locate the material's movie
					var mat:MovieMaterial = face3d.face3DInstance.instance.material as MovieMaterial;

					// set the location where the calcs should be performed
					virtualMouse.container = mat.movie as Sprite;
						
					// update virtual mouse so it can test
					if( virtualMouse.container ) virtualMouse.setLocation(point.x, point.y);
				}catch(err:Error)
				{
					log.error("material type is not Inter active.  If you're using a Collada object, you may have to reassign the material to the object after the collada scene is loaded", err.message);
				}
			}
			
			dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE, Sprite(e.currentTarget));
			
			if( Mouse3D.enabled && ( faceLevelMode || DisplayObject3D.faceLevelMode ) ) 
			{
				mouse3D.updatePosition(Face3D(containerDictionary[e.currentTarget]), e.currentTarget as Sprite);
			}
		}
		/**
		 * Handles mouse clicks on the stage.  If so, we release a releaseOutside event
		 * @param e
		 * 
		 */		
		protected function handleReleaseOutside(e:MouseEvent):void
		{	
			if(debug) log.debug("releaseOutside");
			dispatchEvent(new InteractiveScene3DEvent(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE));
			MOUSE_IS_DOWN = false;
			evaluateClick = true
			allowDraw = true;
		}
		/**
		 * When ISM is in mouseInteractionMode, we capture mouse move events from the stage to trigger a draw
		 * @param e
		 * 
		 */		
		protected function handleStageMouseMove(e:MouseEvent):void
		{
			allowDraw = true;
		}
		
		/**
		 * @private
		 * @param event
		 * @param currentTarget
		 * 
		 */		
		protected function dispatchObjectEvent(event:String, currentTarget:Sprite):void
		{
			if(debug) log.debug(event, DisplayObject3D(containerDictionary[currentTarget]).name);
			
			if(containerDictionary[currentTarget] is DisplayObject3D)
			{
				containerDictionary[currentTarget].dispatchEvent(new InteractiveScene3DEvent(event, containerDictionary[currentTarget], InteractiveSprite(currentTarget)));
				dispatchEvent(new InteractiveScene3DEvent(event, containerDictionary[currentTarget], InteractiveSprite(currentTarget), null, null));
			}else if(containerDictionary[currentTarget] is Face3D)
			{
				var face3d:Face3D = containerDictionary[currentTarget];
				var face3dContainer:InteractiveContainerData = faceDictionary[face3d];
				dispatchEvent(new InteractiveScene3DEvent(event, null, InteractiveSprite(currentTarget), face3d, face3dContainer));
			}
		}
		
		/**
		 * @private
		 * @param e
		 * 
		 */		
		protected function handleResize(e:Event):void
		{
			resizeStage();
		}
	}
}
