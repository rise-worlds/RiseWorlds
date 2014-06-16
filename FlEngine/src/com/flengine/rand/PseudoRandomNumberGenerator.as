package com.flengine.rand
{
   public interface PseudoRandomNumberGenerator
   {
      
      function SetSeed(param1:Number) : void;
      
      function Next() : Number;
      
      function Reset() : void;
   }
}
