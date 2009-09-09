package org.papervision3d.scenes
{
	import flash.display.Sprite;
	import mx.containers.Canvas;
	import org.papervision3d.objects.DisplayObject3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import mx.core.UIComponent;

	public class FlexScene3D extends Scene3D
	{
		private var containerList : Array;
		private var spriteList : Dictionary;
		
		public function FlexScene3D(container:Sprite)
		{
			super(container);
			
			this.containerList = new Array();
			spriteList = new Dictionary();
		}
		
		// ___________________________________________________________________ A D D C H I L D
		//
		//   AA   DDDDD  DDDDD   CCCC  HH  HH II LL     DDDDD
		//  AAAA  DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
		// AA  AA DD  DD DD  DD CC     HHHHHH II LL     DD  DD
		// AAAAAA DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
		// AA  AA DDDDD  DDDDD   CCCC  HH  HH II LLLLLL DDDDD
	
		/**
		* Adds a child DisplayObject3D instance to the scene.
		*
		* If you add a GeometryObject3D symbol, a new DisplayObject3D instance is created.
		* 
		* CanvasScene3D is a fix for Flex2 - Its Flex2's version of MovieScene3D.  If you want your objects separated into sprite containers, use CanvasScene3D.
		* I DID try using pure Canvas objects where sprite was used, but I kept getting "index out of range errors" and just kept getting internal Flex errors.
		*
		* [TODO: If you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.]
		*
		* @param	child	The GeometryObject3D symbol or DisplayObject3D instance to add as a child of the scene.
		* @param	name	An optional name of the child to add or create. If no name is provided, the child name will be used.
		* @return	The DisplayObject3D instance that you have added or created.
		*/
		public override function addChild( child :DisplayObject3D, name :String=null ):DisplayObject3D
		{
			child = super.addChild( child, name );
			
			// for Flex2 we need to create a UIComponent
			var uiDumby:UIComponent = new UIComponent();
			
			// now create the sprite container
			child.container = new Sprite();
			
			// add the sprite to the UIComponent - which is legal, but adding a sprite to a Canvas or any other sub classed UIComponent is not
			uiDumby.addChild(child.container);
			
			// now add the uiDumby to the canvas container
			container.addChild( uiDumby );
			
			// push for use in the renderer
			this.containerList.push( child.container );
			spriteList[child] = child.container;
			return child;
		}
		
		public function getSprite(child:DisplayObject3D):Canvas
		{
			return spriteList[child];
		}
		
		// ___________________________________________________________________ R E N D E R   C A M E R A
		//
		// RRRRR  EEEEEE NN  NN DDDDD  EEEEEE RRRRR
		// RR  RR EE     NNN NN DD  DD EE     RR  RR
		// RRRRR  EEEE   NNNNNN DD  DD EEEE   RRRRR
		// RR  RR EE     NN NNN DD  DD EE     RR  RR
		// RR  RR EEEEEE NN  NN DDDDD  EEEEEE RR  RR CAMERA
	
		/**
		* Generates an image from the camera's point of view and the visible models of the scene.
		*
		* @param	camera		camera to render from.
		*/
		protected override function renderObjects( sort:Boolean ):void
		{
			var objectsLength :Number = this.objects.length;
	
			// Clear object container
			var gfx          						:Sprite;
			var containerList 						:Array = this.containerList;
			var i            						:Number = 0;
	
			// Clear all known object
			while( gfx = containerList[i++] ) gfx.graphics.clear();
	
			// Render
			var p       							:DisplayObject3D;
			var objects 							:Array  = this.objects;
			i = objects.length;
	
			if( sort )
			{
				while( p = objects[--i] )
				{
					if( p.visible )
					{
						// this keeps the memory consumption stable.  Otherwise, there was a slight memory leak with each render
						if(container.getChildByName("container")) container.removeChild(container.getChildByName("container"));
						
						// same trick: add sprite to a UIComponent stand-in
						var uiDumby:UIComponent = new UIComponent();
						uiDumby.name = "container";
						
						uiDumby.addChild(p.container);
						container.addChild( uiDumby );
						p.render( this );
					}
				}
			}
			else
			{
				while( p = objects[--i] )
				{
					if( p.visible )
					{
						p.render( this );
					}
				}
			}
	
			// Update stats
			var stats:Object  = this.stats;
			stats.performance = getTimer() - stats.performance;
		}		
	}
}