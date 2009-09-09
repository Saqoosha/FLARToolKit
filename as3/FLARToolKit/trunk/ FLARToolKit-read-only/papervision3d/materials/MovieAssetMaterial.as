/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org • blog.papervision3d.org • osflash.org/papervision3d
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

// __________________________________________________________________________ MOVIE ASSET MATERIAL

package org.papervision3d.materials
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;	
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import org.papervision3d.Papervision3D;


	/**
	* The MovieAssetMaterial class creates a texture from a MovieClip library symbol.
	* <p/>
	* The texture can be animated and/or transparent.
	* <p/>
	* The MovieClip's content needs to be top left aligned with the registration point.
	* <p/>
	* Materials collects data about how objects appear when rendered.
	*/
	public class MovieAssetMaterial extends MovieMaterial
	{
		
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
			if( asset is String == false )
			{
				Papervision3D.log("Error: MovieAssetMaterial.texture requires a String to be passed to create the MovieClip reference from the library");
				return;
			}
			
			movie = Sprite(createMovie( String( asset ) ));
			bitmap = createBitmapFromSprite( movie );
			_texture = asset;
		}

		// ______________________________________________________________________ NEW

		/**
		* The MovieAssetMaterial class creates a texture from a MovieClip library id.
		*
		* @param	linkageID			The linkage name of the MovieClip symbol in the library.
		* @param	transparent			[optional] - If it's not transparent, the empty areas of the MovieClip will be of fill32 color. Default value is false.
		* @param	initObject			[optional] - An object that contains additional properties with which to populate the newly created material.
		*/
		
		public function MovieAssetMaterial( linkageID:String="", transparent:Boolean=false, animated:Boolean=false )
		{
			movieTransparent = transparent;
			this.animated = animated;
			if( linkageID.length > 0 ) texture = linkageID;
		}


		// ______________________________________________________________________ CREATE BITMAP
		
		/*
		* since we need to pass a movieclip reference to MovieMaterial, I changed this method
		* from createBitmap, to createMovie.  the super's constructor will take care of
		* creating the actual bitmap reference
		*  
		*/
		protected function createMovie( asset:* ):MovieClip
		{
			// Remove previous bitmap
			if( this._texture != asset )
			{
				_count[this._texture]--;

				var prevMovie:MovieClip = _library[this._texture];

				if( prevMovie && _count[this._texture] == 0 )
				{
					_library[this._texture] = null;
				}
			}
			
			// Retrieve from library or...
			var movie:MovieClip = _library[asset];
			
			// ...attachMovie
			if( ! movie )
			{
				var MovieAsset:Class = getDefinitionByName( asset ) as Class;
				movie = new MovieAsset();
				_library[asset] = movie;
				_count[asset] = 0;
			}
			else
			{
				_count[asset]++;
			}

			// Create Bitmap
			return  movie;
		}

		static private var _library :Object = new Object();
		static private var _count   :Object = new Object();
	}
}