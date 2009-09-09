/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org � blog.papervision3d.org � osflash.org/papervision3d
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

// __________________________________________________________________________ MOVIE MATERIAL

package org.papervision3d.materials
{
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import org.papervision3d.Papervision3D;

	/**
	* The MovieMaterial class creates a texture from an existing MovieClip instance.
	* <p/>
	* The texture can be animated and/or transparent. Current scale and color values of the MovieClip instance will be used. Rotation will be discarded.
	* <p/>
	* The MovieClip's content needs to be top left aligned with the registration point.
	* <p/>
	* Materials collects data about how objects appear when rendered.
	*/
	public class MovieMaterial extends BitmapMaterial
	{
		// ______________________________________________________________________ PUBLIC

		/**
		* The MovieClip that is used as a texture.
		*/
		public var movie :DisplayObject;

		/**
		* A Boolean value that determines whether the MovieClip is transparent. The default value is false, which is much faster.
		*/
		public var movieTransparent :Boolean;
		
		/**
		* When updateBitmap() is called on an animated material, it looks to handle a change in size on the texture.
		* 
		* This is true by default, but in certain situations, like drawing on an object, you wouldn't want the size to change
		*/
		public var allowAutoResize:Boolean = true;


		// ______________________________________________________________________ ANIMATED

		/**
		* A Boolean value that determines whether the texture is animated.
		*
		* If set, the material must be included into the scene so the BitmapData texture can be updated when rendering. For performance reasons, the default value is false.
		*/
		public function get animated():Boolean
		{
			return animatedMaterials[ this ];
		}

		public function set animated( status:Boolean ):void
		{
			animatedMaterials[ this ] = status;
		}
		
		/**
		* A texture object.
		*/		
		override public function get texture():Object
		{
			return this._texture;
		}
		/**
		* @private
		*/
		override public function set texture( asset:Object ):void
		{
			if( asset is DisplayObject == false )
			{
				Papervision3D.log("Error: MovieMaterial.texture requires a Sprite to be passed as the object");
				return;
			}
			bitmap = createBitmapFromSprite( DisplayObject(asset) );
			_texture = asset;
		}

		// ______________________________________________________________________ NEW

		/**
		* The MovieMaterial class creates a texture from an existing MovieClip instance.
		*
		* @param	movieAsset		A reference to an existing MovieClip loaded into memory or on stage
		* @param	transparent		[optional] - If it's not transparent, the empty areas of the MovieClip will be of fill32 color. Default value is false.
		* @param	animated		[optional] - a flag setting whether or not this material has animation.  If set to true, it will be updated during each render loop
		*/
		public function MovieMaterial( movieAsset:DisplayObject=null, transparent:Boolean=false, animated:Boolean=false )
		{
			movieTransparent = transparent;
			this.animated = animated;
			if( movieAsset ) texture = movieAsset
		}
		
		// ______________________________________________________________________ CREATE BITMAP

		/**
		* 
		* @param	asset
		* @return
		*/
		protected function createBitmapFromSprite( asset:DisplayObject ):BitmapData
		{
			// Set the new movie reference
			movie = asset;
			
			// initialize the bitmap since it's new
			initBitmap( movie );
			
			// Draw
			drawBitmap();

			// Call super.createBitmap to centralize the bitmap specific code.
			// Here only MovieClip specific code, all bitmap code (maxUVs, AUTO_MIP_MAP, correctBitmap) in BitmapMaterial.
			bitmap = super.createBitmap( bitmap );

			return bitmap;
		}
		
		protected function initBitmap( asset:DisplayObject ):void
		{
			// Cleanup previous bitmap if needed
			if( bitmap )
				bitmap.dispose();

			// Create new bitmap
			bitmap = new BitmapData( asset.width, asset.height, this.movieTransparent );
		}

		// ______________________________________________________________________ UPDATE

		/**
		* Updates animated MovieClip bitmap.
		*
		* Draws the current MovieClip image onto bitmap.
		*/
		public override function updateBitmap():void
		{
			// using int is much faster than using Math.floor. And casting the variable saves in speed from having the avm decide what to cast it as
			var mWidth:int = int(movie.width);
			var mHeight:int = int(movie.height);
			
			if( allowAutoResize && ( mWidth != bitmap.width || mHeight != bitmap.height ) )
			{
				// Init new bitmap size
				initBitmap( movie );
			}
			
			drawBitmap();			
		}
		
		public function drawBitmap():void
		{
			bitmap.fillRect( bitmap.rect, this.fillColor );

			var mtx:Matrix = new Matrix();
			mtx.scale( movie.scaleX, movie.scaleY );

			bitmap.draw( movie, mtx, movie.transform.colorTransform );
		}

		// ______________________________________________________________________ CREATE BITMAP

		/**
		* Updates bitmap on all animated MovieMaterial instances.
		*/
		static public function updateAnimatedBitmaps():void
		{
			for( var material:Object in animatedMaterials )
			{
				if( animatedMaterials[ material ] )
				{
					material.updateBitmap();
				}
			}
		}

		// ______________________________________________________________________ PRIVATE

		
		
		static private var animatedMaterials :Dictionary = new Dictionary( false );
	}
}