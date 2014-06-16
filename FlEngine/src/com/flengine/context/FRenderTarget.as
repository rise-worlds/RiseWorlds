package com.flengine.context
{
   import com.flengine.textures.FTexture;
   import flash.geom.Matrix3D;
   
   public class FRenderTarget extends Object
   {
      
      public function FRenderTarget(param1:FTexture = null, param2:Matrix3D = null) {
         super();
         cTexture = param1;
         mMatrix = param2;
      }
      
      public static const DEFAULT_RENDER_TARGET:FRenderTarget;
      
      var cTexture:FTexture;
      
      var mMatrix:Matrix3D;
      
      var iRenderedTo:int = 0;
      
      public function toString() : String {
         return "[" + (cTexture?cTexture.id:"BackBuffer") + " , " + mMatrix + " , " + iRenderedTo + "]";
      }
   }
}
