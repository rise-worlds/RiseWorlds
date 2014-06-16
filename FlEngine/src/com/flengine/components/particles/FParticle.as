package com.flengine.components.particles
{
   import com.flengine.components.FComponent;
   import com.flengine.core.FNode;
   
   public class FParticle extends FComponent
   {
      
      public function FParticle(param1:FNode) {
         super(param1);
      }
      
      fl2d var nVelocityX:Number = 0;
      
      fl2d var nVelocityY:Number = 0;
      
      fl2d var nAccelerationX:Number;
      
      fl2d var nAccelerationY:Number;
      
      protected var _nEnergy:Number = 0;
      
      protected var _nInitialScale:Number = 1;
      
      protected var _nEndScale:Number = 1;
      
      protected var _nInitialVelocityX:Number;
      
      protected var _nInitialVelocityY:Number;
      
      protected var _nInitialVelocityAngular:Number;
      
      protected var _nInitialAccelerationX:Number;
      
      protected var _nInitialAccelerationY:Number;
      
      protected var _nInitialRed:Number;
      
      protected var _nInitialGreen:Number;
      
      protected var _nInitialBlue:Number;
      
      protected var _nInitialAlpha:Number;
      
      protected var _nEndRed:Number;
      
      protected var _nEndGreen:Number;
      
      protected var _nEndBlue:Number;
      
      protected var _nEndAlpha:Number;
      
      fl2d var cEmitter:FEmitter;
      
      protected var _nAccumulatedEnergy:Number = 0;
      
      override public function set active(param1:Boolean) : void {
         _bActive = param1;
         _nAccumulatedEnergy = 0;
      }
      
      fl2d function init(param1:Boolean = true) : void {
         var _loc4_:* = NaN;
         var _loc2_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc9_:* = NaN;
         _nEnergy = (cEmitter.energy + cEmitter.energyVariance * Math.random()) * 1000;
         if(cEmitter.energyVariance > 0)
         {
            _nEnergy = _nEnergy + cEmitter.energyVariance * Math.random();
         }
         _nInitialScale = cEmitter.initialScale;
         if(cEmitter.initialScaleVariance > 0)
         {
            _nInitialScale = _nInitialScale + cEmitter.initialScaleVariance * Math.random();
         }
         _nEndScale = cEmitter.endScale;
         if(cEmitter.endScaleVariance > 0)
         {
            _nEndScale = _nEndScale + cEmitter.endScaleVariance * Math.random();
         }
         var _loc14_:Number = Math.sin(cEmitter.cNode.transform.nWorldRotation);
         var _loc5_:Number = Math.cos(cEmitter.cNode.transform.nWorldRotation);
         var _loc11_:Number = cEmitter.initialVelocity;
         if(cEmitter.initialVelocityVariance > 0)
         {
            _loc11_ = _loc11_ + cEmitter.initialVelocityVariance * Math.random();
         }
         var _loc8_:Number = cEmitter.initialAcceleration;
         if(cEmitter.initialAccelerationVariance > 0)
         {
            _loc8_ = _loc8_ + cEmitter.initialAccelerationVariance * Math.random();
         }
         _loc4_ = _loc11_ * _loc5_;
         var _loc13_:Number = _loc11_ * _loc5_;
         _loc2_ = _loc11_ * _loc14_;
         var _loc12_:Number = _loc11_ * _loc14_;
         _loc6_ = _loc8_ * _loc5_;
         var _loc10_:Number = _loc8_ * _loc5_;
         _loc7_ = _loc8_ * _loc14_;
         var _loc3_:Number = _loc8_ * _loc14_;
         if(!(cEmitter.dispersionAngle == 0) || !(cEmitter.dispersionAngleVariance == 0))
         {
            _loc9_ = cEmitter.dispersionAngle;
            if(cEmitter.dispersionAngleVariance > 0)
            {
               _loc9_ = _loc9_ + cEmitter.dispersionAngleVariance * Math.random();
            }
            _loc14_ = Math.sin(_loc9_);
            _loc5_ = Math.cos(_loc9_);
            _loc4_ = _loc13_ * _loc5_ - _loc12_ * _loc14_;
            _loc2_ = _loc12_ * _loc5_ + _loc13_ * _loc14_;
            _loc6_ = _loc10_ * _loc5_ - _loc3_ * _loc14_;
            _loc7_ = _loc3_ * _loc5_ + _loc10_ * _loc14_;
         }
         nVelocityX = _loc4_ * 0.001;
         _nInitialVelocityX = _loc4_ * 0.001;
         nVelocityY = _loc2_ * 0.001;
         _nInitialVelocityY = _loc2_ * 0.001;
         nAccelerationX = _loc6_ * 0.001;
         _nInitialAccelerationX = _loc6_ * 0.001;
         nAccelerationY = _loc7_ * 0.001;
         _nInitialAccelerationY = _loc7_ * 0.001;
         _nInitialVelocityAngular = cEmitter.angularVelocity;
         if(cEmitter.angularVelocityVariance > 0)
         {
            _nInitialVelocityAngular = _nInitialVelocityAngular + cEmitter.angularVelocityVariance * Math.random();
         }
         _nInitialRed = cEmitter.initialRed;
         if(cEmitter.initialRedVariance > 0)
         {
            _nInitialRed = _nInitialRed + cEmitter.initialRedVariance * Math.random();
         }
         _nInitialGreen = cEmitter.initialGreen;
         if(cEmitter.initialGreenVariance > 0)
         {
            _nInitialGreen = _nInitialGreen + cEmitter.initialGreenVariance * Math.random();
         }
         _nInitialBlue = cEmitter.initialBlue;
         if(cEmitter.initialBlueVariance > 0)
         {
            _nInitialBlue = _nInitialBlue + cEmitter.initialBlueVariance * Math.random();
         }
         _nInitialAlpha = cEmitter.initialAlpha;
         if(cEmitter.initialAlphaVariance > 0)
         {
            _nInitialAlpha = _nInitialAlpha + cEmitter.initialAlphaVariance * Math.random();
         }
         _nEndRed = cEmitter.endRed;
         if(cEmitter.endRedVariance > 0)
         {
            _nEndRed = _nEndRed + cEmitter.endRedVariance * Math.random();
         }
         _nEndGreen = cEmitter.endGreen;
         if(cEmitter.endGreenVariance > 0)
         {
            _nEndGreen = _nEndGreen + cEmitter.endGreenVariance * Math.random();
         }
         _nEndBlue = cEmitter.endBlue;
         if(cEmitter.endBlueVariance > 0)
         {
            _nEndBlue = _nEndBlue + cEmitter.endBlueVariance * Math.random();
         }
         _nEndAlpha = cEmitter.endAlpha;
         if(cEmitter.endAlphaVariance > 0)
         {
            _nEndAlpha = _nEndAlpha + cEmitter.endAlphaVariance * Math.random();
         }
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         var _loc5_:* = 0;
         _nAccumulatedEnergy = _nAccumulatedEnergy + param1;
         if(_nAccumulatedEnergy >= _nEnergy)
         {
            cNode.active = false;
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < cEmitter.iFieldsCount)
         {
            cEmitter.aFields[_loc5_].updateParticle(this,param1);
            _loc5_++;
         }
         var _loc4_:Number = _nAccumulatedEnergy / _nEnergy;
         nVelocityX = nVelocityX + nAccelerationX * param1;
         nVelocityY = nVelocityY + nAccelerationY * param1;
         cNode.cTransform.red = (_nEndRed - _nInitialRed) * _loc4_ + _nInitialRed;
         cNode.cTransform.green = (_nEndGreen - _nInitialGreen) * _loc4_ + _nInitialGreen;
         cNode.cTransform.blue = (_nEndBlue - _nInitialBlue) * _loc4_ + _nInitialBlue;
         cNode.cTransform.alpha = (_nEndAlpha - _nInitialAlpha) * _loc4_ + _nInitialAlpha;
         cNode.cTransform.x = cNode.cTransform.x + nVelocityX * param1;
         cNode.cTransform.y = cNode.cTransform.y + nVelocityY * param1;
         cNode.cTransform.rotation = cNode.cTransform.rotation + _nInitialVelocityAngular * param1;
         var _loc6_:* = (_nEndScale - _nInitialScale) * _loc4_ + _nInitialScale;
         cNode.cTransform.scaleY = _loc6_;
         cNode.cTransform.scaleX = _loc6_;
      }
   }
}
