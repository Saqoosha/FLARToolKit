/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org ? blog.papervision3d.org ? osflash.org/papervision3d
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
 
 /**
 * @author Alexander Zadorozhny - Away3D
 * @author John Grden
 * NOTE: ported by Andy Zupko
 */
package org.papervision3d.materials 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.materials.IPreciseMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.NumberUV;
	
	public class PreciseMovieAssetMaterial extends MovieAssetMaterial implements IPreciseMaterial
	{
		public var precision:Number = 1;
		public var uv0:NumberUV;
        public var uv1:NumberUV;
        public var uv2:NumberUV;
		public var focus:Number = 100;

		
		public function PreciseMovieAssetMaterial( linkageID:String="", transparent:Boolean=false, animated:Boolean=false )
		{
			super( linkageID, transparent, animated );
			
			precision = precision * precision * 1.4;
		}
		
		public override function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
        {
            var mapping:Matrix = transformUV(face3D);

            renderRec(graphics, mapping.a, mapping.b, mapping.c, mapping.d, mapping.tx, mapping.ty, v0.x, v0.y, v0.z, v1.x, v1.y, v1.z, v2.x, v2.y, v2.z,0);
			return 1;
        }
	
        public function renderRec(graphics:Graphics, ta:Number, tb:Number, tc:Number, td:Number, tx:Number, ty:Number, 
            ax:Number, ay:Number, az:Number, bx:Number, by:Number, bz:Number, cx:Number, cy:Number, cz:Number, index:Number):void
        {

            if ((az <= 0) && (bz <= 0) && (cz <= 0))
                return;

           
            if (index >= 100 || (focus == Infinity) || (Math.max(Math.max(ax, bx), cx) - Math.min(Math.min(ax, bx), cx) < 1) || (Math.max(Math.max(ay, by), cy) - Math.min(Math.min(ay, by), cy) < 1))
            {
                renderTriangleBitmap(graphics, ta, tb, tc, td, tx, ty, ax, ay, bx, by, cx, cy, smooth, tiled);
               
                return;
            }


           
			var faz:Number = focus + az;
            var fbz:Number = focus + bz;
            var fcz:Number = focus + cz;

			var mabz:Number = 2 / (faz + fbz);
            var mbcz:Number = 2 / (fbz + fcz);
            var mcaz:Number = 2 / (fcz + faz);

            var mabx:Number = (ax*faz + bx*fbz)*mabz;
            var maby:Number = (ay*faz + by*fbz)*mabz;
            var mbcx:Number = (bx*fbz + cx*fcz)*mbcz;
            var mbcy:Number = (by*fbz + cy*fcz)*mbcz;
            var mcax:Number = (cx*fcz + ax*faz)*mcaz;
            var mcay:Number = (cy*fcz + ay*faz)*mcaz;

            var dabx:Number = ax + bx - mabx;
            var daby:Number = ay + by - maby;
            var dbcx:Number = bx + cx - mbcx;
            var dbcy:Number = by + cy - mbcy;
            var dcax:Number = cx + ax - mcax;
            var dcay:Number = cy + ay - mcay;
            
            var dsab:Number = (dabx*dabx + daby*daby);
            var dsbc:Number = (dbcx*dbcx + dbcy*dbcy);
            var dsca:Number = (dcax*dcax + dcay*dcay);

            if ((dsab <= precision) && (dsca <= precision) && (dsbc <= precision))
            {
               renderTriangleBitmap(graphics, ta, tb, tc, td, tx, ty, ax, ay, bx, by, cx, cy, smooth, tiled);
               
                return;
            }

            //Debug.trace(num(ta)+" "+num(tb)+" "+num(tc)+" "+num(td)+" "+num(tx)+" "+num(ty));

            if ((dsab > precision) && (dsca > precision) && (dsbc > precision))
            {
                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2, ty*2,
                    ax, ay, az, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, index+1);

                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2-1, ty*2,
                    mabx * 0.5, maby * 0.5, (az+bz) * 0.5, bx, by, bz, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, index+1);

                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2, ty*2-1,
                    mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, cx, cy, cz, index+1);

                renderRec(graphics, -ta*2, -tb*2, -tc*2, -td*2, -tx*2+1, -ty*2+1,
                    mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, index+1);

                return;
            }

            var dmax:Number = Math.max(dsab, Math.max(dsca, dsbc));
            if (dsab == dmax)
            {
                renderRec(graphics, ta*2, tb*1, tc*2, td*1, tx*2, ty*1,
                    ax, ay, az, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, cx, cy, cz, index+1);

                renderRec(graphics, ta*2+tb, tb*1, 2*tc+td, td*1, tx*2+ty-1, ty*1,
                    mabx * 0.5, maby * 0.5, (az+bz) * 0.5, bx, by, bz, cx, cy, cz, index+1);
            
                return;
            }

            if (dsca == dmax)
            {
                renderRec(graphics, ta*1, tb*2, tc*1, td*2, tx*1, ty*2,
                    ax, ay, az, bx, by, bz, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, index+1);

                renderRec(graphics, ta*1, tb*2 + ta, tc*1, td*2 + tc, tx, ty*2+tx-1,
                    mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, bx, by, bz, cx, cy, cz, index+1);
            
                return;
            }


            renderRec(graphics, ta-tb, tb*2, tc-td, td*2, tx-ty, ty*2,
                ax, ay, az, bx, by, bz, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, index+1);

            renderRec(graphics, 2*ta, tb-ta, tc*2, td-tc, 2*tx, ty-tx,
                ax, ay, az, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, cx, cy, cz, index+1);
        }
		
		public function renderTriangleBitmap(graphics:Graphics,a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number, 
            v0x:Number, v0y:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number, smooth:Boolean, repeat:Boolean):void
        {
           

            var a2:Number = v1x - v0x;
            var b2:Number = v1y - v0y;
            var c2:Number = v2x - v0x;
            var d2:Number = v2y - v0y;
                                   
            var matrix:Matrix = new Matrix(a*a2 + b*c2, 
                                           a*b2 + b*d2, 
                                           c*a2 + d*c2, 
                                           c*b2 + d*d2,
                                           tx*a2 + ty*c2 + v0x, 
                                           tx*b2 + ty*d2 + v0y);

            //graphics.lineStyle();
            graphics.beginBitmapFill(bitmap, matrix, repeat, smooth && (v0x*(v2y - v1y) + v1x*(v0y - v2y) + v2x*(v1y - v0y) > 400));
            graphics.moveTo(v0x, v0y);
            graphics.lineTo(v1x, v1y);
            graphics.lineTo(v2x, v2y);
            graphics.endFill();

        }

        private static function num(n:Number):Number
        {
            return int(n*1000)/1000;
        }		
	}	
}
