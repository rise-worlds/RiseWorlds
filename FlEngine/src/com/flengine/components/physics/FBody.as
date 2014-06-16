package com.flengine.components.physics
{
   import com.flengine.components.FComponent;
   import com.flengine.components.FTransform;
   import com.flengine.core.FNode;
   
   public class FBody extends FComponent
   {
      
      public function FBody(param1:FNode) {
         super(param1);
      }
      
      public function get x() : Number {
         return 0;
      }
      
      public function set x(param1:Number) : void {
      }
      
      public function get y() : Number {
         return 0;
      }
      
      public function set y(param1:Number) : void {
      }
      
      public function get scaleX() : Number {
         return 1;
      }
      
      public function set scaleX(param1:Number) : void {
      }
      
      public function get scaleY() : Number {
         return 1;
      }
      
      public function set scaleY(param1:Number) : void {
      }
      
      public function get rotation() : Number {
         return 0;
      }
      
      public function set rotation(param1:Number) : void {
      }
      
      public function isDynamic() : Boolean {
         return false;
      }
      
      public function isKinematic() : Boolean {
         return false;
      }
      
      fl2d function addToSpace() : void {
      }
      
      fl2d function removeFromSpace() : void {
      }
      
      fl2d function invalidateKinematic(param1:FTransform) : void {
      }
   }
}
