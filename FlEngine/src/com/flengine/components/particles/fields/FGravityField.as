package com.flengine.components.particles.fields
{
   import com.flengine.components.particles.FParticle;
   import com.flengine.components.particles.FSimpleParticle;
   import com.flengine.core.FNode;
   
   public class FGravityField extends FField
   {
      
      public function FGravityField(param1:FNode) {
         super(param1);
      }
      
      public var radius:Number = -1;
      
      public var gravity:Number = 0;
      
      public var gravityVariance:Number = 0;
      
      public var inverseGravity:Boolean = false;
      
      override public function updateParticle(param1:FParticle, param2:Number) : void {
         var _loc4_:* = NaN;
         if(!_bActive)
         {
            return;
         }
         var _loc5_:Number = cNode.cTransform.nWorldX - param1.cNode.cTransform.nWorldX;
         var _loc6_:Number = cNode.cTransform.nWorldY - param1.cNode.cTransform.nWorldY;
         var _loc7_:Number = _loc5_ * _loc5_ + _loc6_ * _loc6_;
         if(_loc7_ > radius * radius && radius > 0)
         {
            return;
         }
         if(_loc7_ != 0)
         {
            _loc4_ = Math.sqrt(_loc7_);
            _loc5_ = _loc5_ / (inverseGravity?-_loc4_:_loc4_);
            _loc6_ = _loc6_ / (inverseGravity?-_loc4_:_loc4_);
         }
         var _loc3_:Number = gravity;
         if(gravityVariance > 0)
         {
            _loc3_ = _loc3_ + gravityVariance * Math.random();
         }
         param1.nVelocityX = param1.nVelocityX + _loc3_ * _loc5_ * 0.001 * param2;
         param1.nVelocityY = param1.nVelocityY + _loc3_ * _loc6_ * 0.001 * param2;
      }
      
      override public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void {
         var _loc4_:* = NaN;
         if(!_bActive)
         {
            return;
         }
         var _loc5_:Number = cNode.cTransform.nWorldX - param1.nX;
         var _loc6_:Number = cNode.cTransform.nWorldY - param1.nY;
         var _loc7_:Number = _loc5_ * _loc5_ + _loc6_ * _loc6_;
         if(_loc7_ > radius * radius && radius > 0)
         {
            return;
         }
         if(_loc7_ != 0)
         {
            _loc4_ = Math.sqrt(_loc7_);
            _loc5_ = _loc5_ / (inverseGravity?-_loc4_:_loc4_);
            _loc6_ = _loc6_ / (inverseGravity?-_loc4_:_loc4_);
         }
         var _loc3_:Number = gravity;
         if(gravityVariance > 0)
         {
            _loc3_ = _loc3_ + gravityVariance * Math.random();
         }
         param1.nVelocityX = param1.nVelocityX + _loc3_ * _loc5_ * 0.001 * param2;
         param1.nVelocityY = param1.nVelocityY + _loc3_ * _loc6_ * 0.001 * param2;
      }
   }
}
