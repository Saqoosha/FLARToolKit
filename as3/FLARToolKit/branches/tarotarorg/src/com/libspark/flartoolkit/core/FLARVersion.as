/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */

package com.libspark.flartoolkit.core {

	/**
	 * ARUint32 arGetVersion(char **versionStringRef);
	 * 関数の置き換え
	 */
	public class FLARVersion {
		
	    private static const AR_HEADER_VERSION_MAJOR:int = 2; //#define AR_HEADER_VERSION_MAJOR		2
	    private static const AR_HEADER_VERSION_MINOR:int = 72;//#define AR_HEADER_VERSION_MINOR		72   
	    private static const AR_HEADER_VERSION_TINY:int = 0;//#define AR_HEADER_VERSION_TINY		0
	    private static const AR_HEADER_VERSION_BUILD:int = 0;//#define AR_HEADER_VERSION_BUILD		0
	    private static const AR_HEADER_VERSION_STRING:String = "2.72.0";//#define AR_HEADER_VERSION_STRING	"2.72.0"
	    public static const AR_HAVE_HEADER_VERSION_2:Boolean = true;//#define AR_HAVE_HEADER_VERSION_2
	    public static const AR_HAVE_HEADER_VERSION_2_72:Boolean = true;//#define AR_HAVE_HEADER_VERSION_2_72
	
	    public static function getARVersion():String {
			return AR_HEADER_VERSION_STRING;
	    }
	    
	    public static function getARVersionInt():int {
			// Represent full version number (major, minor, tiny, build) in
			// binary coded decimal. N.B: Integer division.
			return	int(0x10000000 * (AR_HEADER_VERSION_MAJOR / 10)) +
					int(0x01000000 * (AR_HEADER_VERSION_MAJOR % 10)) +
					int(0x00100000 * (AR_HEADER_VERSION_MINOR / 10)) +
					int(0x00010000 * (AR_HEADER_VERSION_MINOR % 10)) +
					int(0x00001000 * (AR_HEADER_VERSION_TINY /  10)) +
					int(0x00000100 * (AR_HEADER_VERSION_TINY %  10)) +
					int(0x00000010 * (AR_HEADER_VERSION_BUILD / 10)) +
					int(0x00000001 * (AR_HEADER_VERSION_BUILD % 10));
	    }
	}

}
