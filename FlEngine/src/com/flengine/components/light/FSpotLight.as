package com.flengine.components.light
{
   import com.flengine.core.FNode;
   
   public class FSpotLight extends FLight
   {
      
      public function FSpotLight(param1:FNode) {
         super(param1);
      }
      
      public var dispersion:Number = 0.4;
   }
}
