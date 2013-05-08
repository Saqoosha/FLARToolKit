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
package org.libspark.flartoolkit.support.away3dv40 
{
	import away3d.cameras.Camera3D;
	import flash.accessibility.Accessibility;
	import flash.media.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import jp.nyatla.as3utils.sketch.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.support.away3dv40.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.math.*;
	import away3d.textures.*;
	
	public class FLARWebCamTexture extends BitmapTexture
	{
		private var _clippingRect:Rectangle;
		private var _ts:int;
		public function FLARWebCamTexture(i_w:int, i_h:int)
		{
			super(get2PowBitmap(i_w, i_h));
			this.bitmapData.floodFill(0, 0, 0x00ff00);
			this._clippingRect = new Rectangle(0, 0, i_w, i_h);
		}
		public function get2PowBitmap(i_w:int, i_h:int ):BitmapData
		{
			var s:int = i_w>i_h?i_w:i_h;
			var ts:int = 1;
			while (ts < s) {
				ts *= 2;
			}
			this._ts = ts;
			return new BitmapData(ts,ts,false);
		}
		public function update(value : IBitmapDrawable) : void
		{
			bitmapData.lock();
			var m:Matrix = new Matrix();
			if (value is Video) {
				var v:Video = Video(value);
				m.scale(this._ts / v.width, this._ts / v.height);
			}else if (value is Bitmap) {
				var b:Bitmap = Bitmap(value);
				m.scale(this._ts / b.width, this._ts / b.height);
			}
			bitmapData.draw(value, m, null, null);
			bitmapData.unlock();
			invalidateContent();
		}
	}

}