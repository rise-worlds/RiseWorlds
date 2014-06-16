package com.flengine.components.renderables.jointanim
{
   public class JATransform2D extends JAMatrix3
   {
      
      public function JATransform2D() {
         super();
      }
      
      private static var _helpMatrix:JAMatrix3 = new JAMatrix3();
      
      public function Scale(param1:Number, param2:Number) : void {
         _helpMatrix.LoadIdentity();
         _helpMatrix.m00 = param1;
         _helpMatrix.m11 = param2;
         MulJAMatrix3(_helpMatrix,this,this);
      }
      
      public function Translate(param1:Number, param2:Number) : void {
         _helpMatrix.LoadIdentity();
         _helpMatrix.m02 = param1;
         _helpMatrix.m12 = param2;
         MulJAMatrix3(_helpMatrix,this,this);
      }
      
      public function RotateDeg(param1:Number) : void {
         RotateRad(0.017453292519943295 * param1);
      }
      
      public function RotateRad(param1:Number) : void {
         _helpMatrix.LoadIdentity();
         var _loc3_:Number = Math.sin(param1);
         var _loc2_:Number = Math.cos(param1);
         _helpMatrix.m00 = _loc2_;
         _helpMatrix.m01 = _loc3_;
         _helpMatrix.m10 = -_loc3_;
         _helpMatrix.m11 = _loc2_;
         MulJAMatrix3(_helpMatrix,this,this);
      }
   }
}
