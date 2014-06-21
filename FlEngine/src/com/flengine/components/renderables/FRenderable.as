package com.flengine.components.renderables
{
   import com.flengine.components.FComponent;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.fl2d;
	use namespace fl2d;
   public class FRenderable extends FComponent
   {
      
      public function FRenderable(param1:FNode) {
         super(param1);
      }
      
      fl2d var iBlendMode:int = 1;
      
      public function set blendMode(param1:int) : void {
         iBlendMode = param1;
      }
      
      public function get blendMode() : int {
         return iBlendMode;
      }
      
      public function getWorldBounds(param1:Rectangle = null) : Rectangle {
         if(param1)
         {
            param1.setTo(cNode.cTransform.nWorldX,cNode.cTransform.nWorldY,0,0);
         }
         else
         {
            param1 = new Rectangle(cNode.cTransform.nWorldX,cNode.cTransform.nWorldY,0,0);
         }
         return param1;
      }
   }
}
