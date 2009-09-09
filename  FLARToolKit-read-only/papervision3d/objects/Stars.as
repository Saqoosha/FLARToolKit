package org.papervision3d.objects
{
	// ______________________________________________________________________________

	// PAPER     ON    ERVIS   NPAPER  ISION   PE  IS  ON   PERVI  IO   APER   SI  PA
	// AP  VI   ONPA   RV  IO  PA      SI  PA  ER  SI  NP  PE      ON  AP  VI  ION AP
	// PERVI   ON  PE  VISIO   APER    IONPA   RV  IO  PA   RVIS   NP  PE  IS  ONPAPE
	// ER      NPAPER  IS      PE      ON  PE   ISIO   AP      IO  PA  ER  SI  NP PER
	// RV      PA  RV  SI      ERVISI  NP  ER    IO    PE  VISIO   AP   VISI   PA  RV

	// PAPERVISION 5 Alpha
	// Carlos Ulloa Matesanz

	// C4RL054321@gmail.com
	// www.noventaynueve.com
	// noventaynueve.com/blog

	import org.papervision3d.scenes.*;
	import org.papervision3d.core.proto.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.core.geom.*;
	import org.papervision3d.Papervision3D;
	//import org.papervision3d.core.*;
	//import org.papervision3d.core.proto.*;

	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import com.blitzagency.xray.logger.XrayLog;


	/**
	* The Stars GeometryObject3D class lets you create and display 3D starfields.
	* <p/>
	*/
	import flash.display.MovieClip;

	public class Stars extends org.papervision3d.core.geom.Vertices3D
	{
		/**
		* A BitmapMaterial object that contains the material properties of the triangle.
		*/
		//public var material   :BitmapMaterial;

		/**
		* The number of stars.
		*/
		public var quantity :Number;

		/**
		* The width.
		*/
		public var width :Number;

		/**
		* Height
		*/
		public var height :Number;

		/**
		* Depth
		*/
		public var depth :Number;

		public var target:Sprite;


		/**
		* Default size of Plane if not texture is defined.
		*/
		static public var DEFAULT_SIZE :Number = 1000;

		/**
		* Default size of Plane if not texture is defined.
		*/
		static public var DEFAULT_STAGE_WIDTH :Number = 2048;
		static public var DEFAULT_STAGE_HEIGHT :Number = 2048;


		/**
		* Size of the stage.
		*/
		public var stageWidth  :Number;

		/**
		* Size of the stage.
		*/
		public var stageHeight :Number;

		private var log:XrayLog = new XrayLog();



		private var _bdCanvas :BitmapData;
		private var bm:Bitmap = new Bitmap();

		// ___________________________________________________________________________________________________
		//                                                                                               N E W
		// NN  NN EEEEEE WW    WW
		// NNN NN EE     WW WW WW
		// NNNNNN EEEE   WWWWWWWW
		// NN NNN EE     WWW  WWW
		// NN  NN EEEEEE WW    WW

		/**
		* Create new Stars object.
		* <p/>
		* @param	material	A BitmapMaterial object that contains the material properties of the object.
		* <p/>
		* @param	width		Width.
		* <p/>
		* @param	height		Height.
		* <p/>
		* @param	depth		Depth.
		* <p/>
		* @param	initObject	[optional] - An object that contains user defined properties with which to populate the newly created GeometryObject3D.
		* <p/>
		* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined data object.
		* <p/>
		* If data is not an object, it is ignored. All properties of the data field are copied into the new instance. The properties specified with data are publicly available.
		*/
		public function Stars( material:ColorMaterial, target:Sprite, quantity:Number=900, width:Number=1000, height:Number=1000, depth:Number=1000, initObject:Object=null )
		{
			if( target is Sprite )
			{
				super( new Array(), "Stars", initObject );

				this.material = material// || BitmapMaterial.DEFAULT;
				this.target = target;
				this.quantity = quantity || DEFAULT_SIZE;

				this.width  = width  || DEFAULT_SIZE;
				this.height = height || DEFAULT_SIZE;
				this.depth  = depth  || DEFAULT_SIZE;

				this.stageWidth  = target.width || DEFAULT_STAGE_WIDTH;
				this.stageHeight = target.height || DEFAULT_STAGE_HEIGHT;

				buildStars();

				_bdCanvas = new BitmapData( this.stageWidth, this.stageHeight, false, 0x00000000);
//				_bdCanvas.copyPixels( this.material.texture, this.material.texture.rect, new Point( 0, 0 ) );

				// Attach bitmap to canvas
				//var canvas :Sprite = target; //.createEmptyMovieClip( "iCentered", 10 );
				//canvas.addChildAt( _bdCanvas, canvas.getNextHighestDepth() );

				bm.bitmapData = _bdCanvas;
				target.addChild(bm);
				bm.x = -stageWidth/2; // - this.stageWidth /2;
				bm.y = -stageHeight/2;// - this.stageHeight /2;


				//target.graphics.beginBitmapFill( _bdCanvas );
				//target.graphics.endFill();

				//canvas.x = 0;//stage.stageWidth/2  - this.stageWidth /2;
				//canvas.y = 0; //stage.stageHeight/2 - this.stageHeight /2;
				//this.canvas = canvas;

//				this.screenZ = 66666666; // Backdrop
			}
			//else if( Papervision3D.VERBOSE )
				//log.debug( "Stars: Canvas not found" );
		}

		private function buildStars():void
		{
			var quantity:Number = this.quantity;
			var vertices:Array = this.geometry.vertices;

			var width  :Number = this.width;
			var height :Number = this.height;
			var depth  :Number = this.depth;

			var width2  :Number = width /2;
			var height2 :Number = height /2;
			var depth2  :Number = depth /2;

			// Vertices
			for( var i:Number = 0; i < quantity; i++ )
			{
				var x :Number = Math.random() * width  - width2;
				var y :Number = Math.random() * height - height2;
				var z :Number = Math.random() * depth  - depth2;

				var v :Vertex3D = new Vertex3D( x, y, z );
//v.data = new Object();
//v.data.color =(Math.floor( 0x60 + 0x80 * Math.random() ) << 24) + 0xFFFFFF;
				//var data:Object = new Object();
				//data.color =(Math.floor( 0x60 + 0x80 * Math.random() ) << 24) + 0xFFFFFF;
				//v.extra = data;
				vertices.push( v );
			}
		}

		public override function render( scene :SceneObject3D ):void
		{
			try
			{
				// Clear bitmap
				var sW2: Number = this.stageWidth /2;
				var sH2: Number = this.stageHeight /2;
				//log.debug("0", sW2 + ", " + sH2);
				var bd:BitmapData = this._bdCanvas;
				bd.fillRect( bd.rect, 0x000000);
				//log.debug("1", bd.width);
				// Paint stars
				
				var pixels :Number = 0;

				//log.debug("2");

				var color:int = material.fillColor || 0xFFFFFF;
				//log.debug("3");
				var v3d:Vertex3D;
				var v2d:Vertex2D;
				for each(v3d in geometry.vertices)
				{
					v2d = v3d.vertex2DInstance; 
					//log.debug("4", v.visible);
					if( v2d.visible )
					{
						_bdCanvas.setPixel( sW2 + v2d.x, sH2 + v2d.y, color );
						pixels++;
					}
				}
			}catch(e:Error)
			{
				log.error("stars.render error", e.message);
			}

			// Update stats
			scene.stats.pixels += pixels;
		}

	}
}