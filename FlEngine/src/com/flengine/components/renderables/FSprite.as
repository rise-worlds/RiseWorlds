package com.flengine.components.renderables
{
   import com.flengine.textures.FTextureBase;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FNode;
   import com.flengine.fl2d;
   use namespace fl2d;
   public class FSprite extends FTexturedQuad
   {
      
      public function FSprite(param1:FNode) {
         super(param1);
      }
      
      public function get textureId() : String {
         if(cTexture)
         {
            return cTexture.id;
         }
         return "";
      }
      
      public function set textureId(param1:String) : void {
         cTexture = FTextureBase.getTextureBaseById(param1) as FTexture;
      }
      
      public function setTexture(param1:FTexture) : void {
         cTexture = param1;
      }
   }
}
