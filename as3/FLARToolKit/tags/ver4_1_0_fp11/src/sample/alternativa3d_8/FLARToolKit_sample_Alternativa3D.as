/**
 * FLARToolKit example launcher
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 * Contributors
 *  saqoosha
 *  nyatla
 *  rokubou
 */
package sample.alternativa3d_8
{
	import flash.display.Sprite;
	
	import sample.alternativa3d_8.sketchSimple.*;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	public class FLARToolKit_sample_Alternativa3D extends Sprite
	{
		public function FLARToolKit_sample_Alternativa3D()
		{
			this.addChild(new SimpleLite());
//			this.addChild(new MarkerPlane());
		}
	}
}