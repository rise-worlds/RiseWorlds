package com.flengine.components.light
{
   import com.flengine.components.FComponent;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FNode;
   
   public class FLight extends FComponent
   {
      
      public function FLight(param1:FNode) {
         super(param1);
         radius = 100;
      }
      
      public var shadows:Boolean = true;
      
      var cTexture:FTexture;
      
      var iRadius:int;
      
      var iRadiusSquared:int;
      
      public function get radius() : int {
         return iRadius;
      }
      
      public function set radius(param1:int) : void {
         iRadius = param1;
         iRadiusSquared = iRadius * iRadius;
      }
      
      public function getTexture() : FTexture {
         return cTexture;
      }
      
      public function set textureId(param1:String) : void {
         cTexture = FTexture.getTextureById(param1);
      }
      
      public function get textureId() : String {
         if(cTexture)
         {
            return cTexture.id;
         }
         return "";
      }
      
      public function toString() : String {
         return node.transform.x + ":" + node.transform.y;
      }
   }
}
