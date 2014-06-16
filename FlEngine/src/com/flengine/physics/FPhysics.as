package com.flengine.physics
{
   public class FPhysics extends Object
   {
      
      public function FPhysics() {
         super();
      }
      
      protected var _bRunning:Boolean = true;
      
      public var minimumTimeStep:int = 0;
      
      fl2d function step(param1:Number) : void {
      }
      
      public function setGravity(param1:Number, param2:Number) : void {
      }
      
      public function stop() : void {
         _bRunning = false;
      }
      
      public function start() : void {
         _bRunning = true;
      }
      
      public function pause() : void {
         _bRunning = !_bRunning;
      }
      
      public function dispose() : void {
      }
   }
}
