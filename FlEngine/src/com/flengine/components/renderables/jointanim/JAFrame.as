package com.flengine.components.renderables.jointanim
{
   public class JAFrame extends Object
   {
      
      public function JAFrame() {
         super();
         commandVector = new Vector.<JACommand>();
         frameObjectPosVector = new Vector.<JAObjectPos>();
      }
      
      public var hasStop:Boolean;
      
      public var commandVector:Vector.<JACommand>;
      
      public var frameObjectPosVector:Vector.<JAObjectPos>;
   }
}
