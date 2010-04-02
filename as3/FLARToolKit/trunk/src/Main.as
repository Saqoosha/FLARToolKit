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
 *  rokubou
 */
package {
	import examples.*;
	
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		public function Main():void
		{
			// simply uncomment whichever tutorial/example you would like to launch.
			
			// Papervision3d(Simple cube)
			this.addChild(new FLARToolKitExample_PV3D());
			
			// Papervison3d collada model
//			this.addChild(new FLARToolKitExample_ColladaData());
			
			// Single Marker Manager sample
//			this.addChild(new FLARTK_Example_SingleManager_PV3D());

			// ID Marker Manager sample
//			this.addChild(new FLARTK_Example_SingleNyIDManager());
			
		}
	}
}