/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
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

package org.papervision3d.events
{
	import flash.events.Event;

	/**
	* The FileLoadEvent class represents events that are dispatched when files are loaded.
	*/
	public class FileLoadEvent extends Event
	{
		public static var LOAD_COMPLETE 				:String = "loadComplete";
		public static var LOAD_ERROR    				:String = "loadError";
		public static var SECURITY_LOAD_ERROR			:String = "securityLoadError";
		public static var COLLADA_MATERIALS_DONE		:String = "colladaMaterialsDone";
		public static var LOAD_PROGRESS 				:String = "loadProgress";
		
		public var file:String = "";
		public var bytesLoaded:Number = -1;
		public var bytesTotal:Number = -1;	
		public var message:String = "";	
		public var dataObj:Object = null;

		public function FileLoadEvent( type:String, file:String="", bytesLoaded:Number=-1, bytesTotal:Number=-1, message:String="", dataObj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( type, bubbles, cancelable );
			this.file = file;
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			this.message = message;
			this.dataObj = dataObj;
		}
	}
}