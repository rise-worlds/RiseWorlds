package com.flengine.textures
{
   import com.flengine.error.FError;
   import com.flengine.fl2d;
   use namespace fl2d;
   
   public class FTextureFilteringType extends Object
   {
      
      public function FTextureFilteringType() {
         super();
         throw new FError("FError: Cannot instantiate abstract class.");
      }
      
      public static const NEAREST:int = 0;
      
      public static const LINEAR:int = 1;
      
      fl2d  static function isValid(param1:int) : Boolean {
         if(param1 == 0 || param1 == 1)
         {
            return true;
         }
         return false;
      }
   }
}
