/* 
* PROJECT: FLARToolKit
* --------------------------------------------------------------------------------
* This work is based on the FLARToolKit developed by
*   R.Iizuka (nyatla)
* http://nyatla.jp/nyatoolkit/
*
* The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
* Copyright (C)2008 Saqoosha
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
*/
package org.libspark.flartoolkit.markersystem
{
	import org.libspark.flartoolkit.core.squaredetect.FLARSquareContourDetector_CbHandler;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquareContourDetector_Rle;
	
	internal class SquareDetect implements IFLARMarkerSystemSquareDetect
	{
		private var _sd:FLARSquareContourDetector_Rle;
		public function SquareDetect(i_config:IFLARMarkerSystemConfig)
		{
			this._sd=new FLARSquareContourDetector_Rle(i_config.getScreenSize());
		}
		public function detectMarkerCb(i_sensor:FLARSensor,i_th:int,i_handler:FLARSquareContourDetector_CbHandler):void
		{
			this._sd.detectMarker_2(i_sensor.getGsImage(), i_th,i_handler);
		}
	}
}