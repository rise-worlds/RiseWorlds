package com.flengine.components.renderables.jointanim
{
   public class JAVec2 extends Object
   {
      
      public function JAVec2(param1:Number = 0, param2:Number = 0) {
         super();
         x = param1;
         y = param2;
      }
      
      public var x:Number;
      
      public var y:Number;
      
      public function Magnitude() : Number {
         return Math.sqrt(x * x + y * y);
      }
      
      public function Normalize() : JAVec2 {
         var _loc1_:Number = Magnitude();
         if(_loc1_ != 0)
         {
            x = x / _loc1_;
            y = y / _loc1_;
         }
         return this;
      }
      
      public function Perp() : void {
         var _loc1_:Number = this.x;
         this.x = -this.y;
         this.y = this.x;
      }
      
      public function Dot(param1:JAVec2) : Number {
         return x * param1.x + y * param1.y;
      }
   }
}
