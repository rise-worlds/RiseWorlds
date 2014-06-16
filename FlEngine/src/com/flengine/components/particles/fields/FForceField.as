package com.flengine.components.particles.fields
{
   import com.flengine.components.particles.FParticle;
   import com.flengine.components.particles.FSimpleParticle;
   import com.flengine.core.FNode;
   
   public class FForceField extends FField
   {
      
      public function FForceField(param1:FNode) {
         super(param1);
      }
      
      public var radius:Number = 0;
      
      public var forceX:Number = 0;
      
      public var forceXVariance:Number = 0;
      
      public var forceY:Number = 0;
      
      public var forceYVariance:Number = 0;
      
      override public function updateParticle(param1:FParticle, param2:Number) : void {
         if(!_bActive)
         {
            return;
         }
         var _loc3_:Number = cNode.cTransform.nWorldX - param1.cNode.cTransform.nWorldX;
         var _loc4_:Number = cNode.cTransform.nWorldY - param1.cNode.cTransform.nWorldY;
         var _loc5_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         if(_loc5_ > radius * radius && radius > 0)
         {
            return;
         }
         param1.nVelocityX = param1.nVelocityX + forceX * 0.001 * param2;
         param1.nVelocityY = param1.nVelocityY + forceY * 0.001 * param2;
      }
      
      override public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void {
         if(!_bActive)
         {
            return;
         }
         var _loc3_:Number = cNode.cTransform.nWorldX - param1.nX;
         var _loc4_:Number = cNode.cTransform.nWorldY - param1.nY;
         var _loc5_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         if(_loc5_ > radius * radius && radius > 0)
         {
            return;
         }
         param1.nVelocityX = param1.nVelocityX + forceX * 0.001 * param2;
         param1.nVelocityY = param1.nVelocityY + forceY * 0.001 * param2;
      }
   }
}
