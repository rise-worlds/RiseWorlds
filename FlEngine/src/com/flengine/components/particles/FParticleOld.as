package com.flengine.components.particles
{
   import com.flengine.components.FComponent;
   import com.flengine.core.FNode;
   
   public class FParticleOld extends FComponent
   {
      
      public function FParticleOld(param1:FNode) {
         super(param1);
      }
      
      var cNextParticle:FParticle;
      
      var cPreviousParticle:FParticle;
      
      var nVelocityX:Number = 0;
      
      var nVelocityY:Number = 0;
      
      protected var _nEnergy:Number = 0;
      
      protected var _nInitialVelX:Number = 0;
      
      protected var _nInitialVelY:Number = 0;
      
      protected var _nInitialVelAngular:Number = 0;
      
      protected var _nInitialRed:Number;
      
      protected var _nInitialGreen:Number;
      
      protected var _nInitialBlue:Number;
      
      protected var _nInitialAlpha:Number;
      
      protected var _nEndRed:Number;
      
      protected var _nEndGreen:Number;
      
      protected var _nEndBlue:Number;
      
      protected var _nEndAlpha:Number;
      
      var cEmitter:FEmitter;
      
      protected var _nAccumulatedEnergy:Number = 0;
      
      override public function set active(param1:Boolean) : void {
         _bActive = param1;
         _nAccumulatedEnergy = 0;
         cNode.transform.alpha = 1;
      }
      
      function init(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number) : void {
         _nEnergy = param1;
         nVelocityX = param2;
         _nInitialVelX = param2;
         nVelocityY = param3;
         _nInitialVelY = param3;
         _nInitialVelAngular = param4;
         _nInitialRed = param5;
         _nInitialGreen = param6;
         _nInitialBlue = param7;
         _nInitialAlpha = param8;
         _nEndRed = param9;
         _nEndGreen = param10;
         _nEndBlue = param11;
         _nEndAlpha = param12;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         _nAccumulatedEnergy = _nAccumulatedEnergy + param1;
         if(_nAccumulatedEnergy >= _nEnergy)
         {
            cNode.active = false;
            return;
         }
         var _loc4_:Number = _nAccumulatedEnergy / _nEnergy;
         cNode.cTransform.red = (_nEndRed - _nInitialRed) * _loc4_ + _nInitialRed;
         cNode.cTransform.green = (_nEndGreen - _nInitialGreen) * _loc4_ + _nInitialGreen;
         cNode.cTransform.blue = (_nEndBlue - _nInitialBlue) * _loc4_ + _nInitialBlue;
         cNode.cTransform.alpha = (_nEndAlpha - _nInitialAlpha) * _loc4_ + _nInitialAlpha;
         cNode.cTransform.x = cNode.cTransform.x + nVelocityX * param1;
         cNode.cTransform.y = cNode.cTransform.y + nVelocityY * param1;
         cNode.cTransform.rotation = cNode.cTransform.rotation + _nInitialVelAngular * param1;
      }
   }
}
