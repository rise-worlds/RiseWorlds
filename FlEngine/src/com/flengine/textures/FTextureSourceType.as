package com.flengine.textures
{
   import com.flengine.error.FError;
   
   public class FTextureSourceType extends Object
   {
      
      public function FTextureSourceType() {
         super();
         throw new FError("FError: Cannot instantiate abstract class.");
      }
      
      public static const ATF_BGRA:int = 0;
      
      public static const ATF_COMPRESSED:int = 1;
      
      public static const ATF_COMPRESSEDALPHA:int = 2;
      
      public static const BYTEARRAY:int = 2;
      
      public static const BITMAPDATA:int = 3;
      
      public static const RENDER_TARGET:int = 4;
      
      fl2d  static function isValid(param1:int) : Boolean {
         if(param1 == 1 || param1 == 2 || param1 == 2 || param1 == 3 || param1 == 4)
         {
            return true;
         }
         return false;
      }
   }
}
