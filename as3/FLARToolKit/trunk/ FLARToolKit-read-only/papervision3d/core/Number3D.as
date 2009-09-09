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

// ______________________________________________________________________
//                                                               Number3D

package org.papervision3d.core
{
/**
* The Number3D class represents a value in a three-dimensional coordinate system.
*
* Properties x, y and z represent the horizontal, vertical and z the depth axes respectively.
*
*/
public class Number3D
{
	/**
	* The horizontal coordinate value.
	*/
	public var x: Number;

	/**
	* The vertical coordinate value.
	*/
	public var y: Number;

	/**
	* The depth coordinate value.
	*/
	public var z: Number;


	/**
	* Creates a new Number3D object whose three-dimensional values are specified by the x, y and z parameters. If you call this constructor function without parameters, a Number3D with x, y and z properties set to zero is created.
	*
	* @param	x	The horizontal coordinate value. The default value is zero.
	* @param	y	The vertical coordinate value. The default value is zero.
	* @param	z	The depth coordinate value. The default value is zero.
	*/
	public function Number3D( x: Number=0, y: Number=0, z: Number=0 )
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}


	/**
	* Returns a new Number3D object that is a clone of the original instance with the same three-dimensional values.
	*
	* @return	A new Number3D instance with the same three-dimensional values as the original Number3D instance.
	*/
	public function clone():Number3D
	{
		return new Number3D( this.x, this.y, this.z );
	}
	
	/**
	 * Copies the values of this number3d to the passed number3d.
	 * 
	 */
	public function copyTo(n:Number3D):void
	{
		n.x = x;
		n.y = y;
		n.z = z;
	}



	// ______________________________________________________________________ MATH

	/**
	* Modulo
	*/
	public function get modulo():Number
	{
		return Math.sqrt( this.x*this.x + this.y*this.y + this.z*this.z );
	}

	/**
	* Add
	*/
	public static function add( v:Number3D, w:Number3D ):Number3D
	{
		return new Number3D
		(
			v.x + w.x,
			v.y + w.y,
			v.z + w.z
		);
	}

	/**
	 * Substract.
	 */
	public static function sub( v:Number3D, w:Number3D ):Number3D
	{
		return new Number3D
		(
			v.x - w.x,
			v.y - w.y,
			v.z - w.z
		);
	}

	/**
	 * Dot product.
	 */
	public static function dot( v:Number3D, w:Number3D ):Number
	{
		return ( v.x * w.x + v.y * w.y + w.z * v.z );
	}

	/**
	 * Cross product.
	 */
	public static function cross( v:Number3D, w:Number3D ):Number3D
	{
		return new Number3D((w.y * v.z) - (w.z * v.y), (w.z * v.x) - (w.x * v.z), (w.x * v.y) - (w.y * v.x));
	}

	/**
	 * Normalize.
	 */
	public function normalize():void
	{
		var mod:Number = this.modulo;

		if( mod != 0 && mod != 1)
		{
			this.x /= mod;
			this.y /= mod;
			this.z /= mod;
		}
	}


	// ______________________________________________________________________



	/**
	* Returns a Number3D object with x, y and z properties set to zero.
	*
	* @return A Number3D object.
	*/
	static public function get ZERO():Number3D
	{
		return new Number3D( 0, 0, 0 );
	}


	/**
	* Returns a string value representing the three-dimensional values in the specified Number3D object.
	*
	* @return	A string.
	*/
	public function toString(): String
	{
		return 'x:' + x + ' y:' + y + ' z:' + z;
	}
}
}