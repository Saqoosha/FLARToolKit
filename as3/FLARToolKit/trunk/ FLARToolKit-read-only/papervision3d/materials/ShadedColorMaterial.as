package org.papervision3d.materials
{
       import flash.display.Graphics;
       import flash.utils.Dictionary;

       import org.papervision3d.core.Number3D;
       import org.papervision3d.core.geom.Face3D;
       import org.papervision3d.core.geom.Vertex2D;
       import org.papervision3d.core.proto.MaterialObject3D;
       import org.papervision3d.objects.DisplayObject3D;
     
       /**
        *
        */
       public class ShadedColorMaterial extends MaterialObject3D
       {
               public var light:Number3D;

               /**
                *
                * @param       fillColor
                * @param       fillAlpha
                */
               public function ShadedColorMaterial(fillColor:uint, fillAlpha:Number= 1.0):void
               {
                 	   this.fillColor = fillColor;
                       this.fillAlpha = fillAlpha;
                       this.light = new Number3D(0, 0, 100);
					   needsFaceNormals = true;
               }

               /**
                * @param       instance
                * @param       face3D
                * @param       graphics
                * @param       v0
                * @param       v1
                * @param       v2
                * @return
                */
               override public function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
               {
               		
                    var s:Number;
                    var lt:Number3D = new Number3D();
					light.copyTo(lt);
					lt.normalize();
					s = Number3D.dot(face3D.face3DInstance.faceNormal, lt)*255;
					
					if(s>0){
						var c:Number = s<<16|s<<8|s;
					}
                    graphics.beginFill( c, fillAlpha );
                    graphics.moveTo( v0.x, v0.y );
                    graphics.lineTo( v1.x, v1.y );
                    graphics.lineTo( v2.x, v2.y );
                    graphics.lineTo( v0.x, v0.y );
                    graphics.endFill();
                    return 1;
               }
       }
}