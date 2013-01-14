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
package org.libspark.flartoolkit.support.alternativa3d 
{
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
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.controllers.*;
	import alternativa.engine3d.objects.*;
	import alternativa.engine3d.primitives.*;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.resources.*;	
	/**
	 * Bitmapデータ持つPanelです。背景として使います。
	 */
	public class FLARBackgroundPanel extends Plane
	{
		private var _bmd:BitmapData;
		private var _ts:int;
		private var _res:BitmapTextureResource;
		public function FLARBackgroundPanel(i_w:int,i_h:int,i_backbuffer_size:int=512)
		{
			super(i_w,i_h,1, 5);
			this._ts = i_backbuffer_size;
			this._bmd = new BitmapData(i_backbuffer_size,i_backbuffer_size,false,0x00ff00);
			this._res = new BitmapTextureResource(this._bmd);
			this.setMaterialToAllSurfaces(new TextureMaterial(this._res));
		}
		public function update(i_src:IBitmapDrawable,i_s:Stage3D):void
		{
			this._bmd.lock();
			var m:Matrix = new Matrix();
			if (i_src is Video) {
				var v:Video = Video(i_src);
				m.scale(this._ts / v.width, this._ts / v.height);
			}else if (i_src is Bitmap) {
				var b:Bitmap = Bitmap(i_src);
				m.scale(this._ts / b.width, this._ts / b.height);
			}
			this._bmd.draw(i_src, m, null, null);
			this._bmd.unlock();
			this._res.upload(i_s.context3D);
		}
	}

}