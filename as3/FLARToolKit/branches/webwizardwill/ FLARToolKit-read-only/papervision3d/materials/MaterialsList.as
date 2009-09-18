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

// _______________________________________________________________________ MaterialsList

package org.papervision3d.materials
{
import org.papervision3d.core.proto.*;

import flash.utils.Dictionary;

/**
* The MaterialsList class contains a list of materials.
* <p/>
* Each MaterialsList object has its own materials list.
*/
public class MaterialsList
{
	/**
	* List of materials indexed by name.
	*/
	public var materialsByName :Dictionary;

	/**
	* Returns the number of children of this object.
	*/
	public function get numMaterials():int
	{
		return this._materialsTotal;
	}

	// ___________________________________________________________________________________________________
	//                                                                                               N E W
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* Creates a list of materials.
	*
	* @param	materials	An array or name indexed object with materials to populate the list with.
	*/
	public function MaterialsList( materials :*=null ):void
	{
		this.materialsByName  = new Dictionary(true);
		this._materials       = new Dictionary(false);
		this._materialsTotal  = 0;

		if( materials )
		{
			if( materials is Array )
			{
				for( var i:String in materials )
				{
					this.addMaterial( materials[i] );
				}
			}
			else if( materials is Object )
			{
				for( var name:String in materials )
				{
					this.addMaterial( materials[ name ], name );
				}
			}
		}
	}

	/**
	* Adds a material to this MaterialsList object.
	*
	* @param	material	The material to add.
	* @param	name		An optional name of the material. If no name is provided, the material name will be used.
	* @return	The material you have added.
	*/
	public function addMaterial( material:MaterialObject3D, name:String=null ):MaterialObject3D
	{
		name = name || material.name || String( material.id );

		this._materials[ material ] = name;
		this.materialsByName[ name ] = material;
		this._materialsTotal++;

		return material;
	}

	/**
	* Removes the specified material from the materials list.
	*
	* @param	material	The material to remove.
	* @return	The material you have removed.
	*/
	public function removeMaterial( material:MaterialObject3D ):MaterialObject3D
	{
		delete this.materialsByName[ this._materials[ material ] ];
		delete this._materials[ material ];

		return material;
	}

	/**
	* Returns the material that exists with the specified name.
	* </p>
	* @param	name	The name of the material to return.
	* @return	The material with the specified name.
	*/
	public function getMaterialByName( name:String ):MaterialObject3D
	{
		return this.materialsByName[name] ? this.materialsByName[name] : this.materialsByName["all"];
		//return this.materialsByName[ name ];
	}

	/**
	* Removes the material that exists with the specified name.
	* </p>
	* The material object is garbage collected if no other references to the material exist.
	* </p>
	* The garbage collector is the process by which Flash Player reallocates unused memory space. When a variable or object is no longer actively referenced or stored somewhere, the garbage collector sweeps through and wipes out the memory space it used to occupy if no other references to it exist.
	* </p>
	* @param	name	The name of the material to remove.
	* @return	The material object that was removed.
	*/
	public function removeMaterialByName( name:String ):MaterialObject3D
	{
		return removeMaterial( getMaterialByName( name ) );
	}

	/**
	* Creates a copy of the materials list.
	*
	* @return	A newly created materials list that contains a duplicate of each of its materials.
	*/
	public function clone():MaterialsList
	{
		var cloned:MaterialsList = new MaterialsList();

		for each( var m:MaterialObject3D in this.materialsByName )
			cloned.addMaterial( m.clone(), this._materials[ m ] );

		return cloned;
	}

	// ___________________________________________________________________________________________________

	/**
	* Returns a string with the names of the materials in the list.
	*
	* @return	A string.
	*/
	public function toString():String
	{
		var list:String = "";

		for each( var m:MaterialObject3D in this.materialsByName )
			list += this._materials[ m ] + "\n";

		return list;
	}

	// ___________________________________________________________________________________________________
	//                                                                                       P R I V A T E

	/**
	* [internal-use] List of materials.
	*/
	protected var _materials       :Dictionary;

	private   var _materialsTotal  :int;
}
}