package com.flengine.components.particles
{
   public class FSimpleParticle extends Object
   {
      
      public function FSimpleParticle() {
         super();
         count = count + 1;
         __iId = count;
      }
      
      private static var availableInstance:FSimpleParticle;
      
      private static var count:int = 0;
      
      public static function precache(param1:int) : void {
         var _loc4_:* = null;
         var _loc2_:* = null;
         if(param1 < count)
         {
            return;
         }
         var _loc3_:FSimpleParticle = get();
         while(count < param1)
         {
            _loc4_ = get();
            _loc4_.cPrevious = _loc3_;
            _loc3_ = _loc4_;
         }
         while(_loc3_)
         {
            _loc2_ = _loc3_;
            _loc3_ = _loc2_.cPrevious;
            _loc2_.dispose();
         }
      }
      
      fl2d  static function get() : FSimpleParticle {
         var _loc1_:FSimpleParticle = availableInstance;
         if(_loc1_)
         {
            availableInstance = _loc1_.__cNextInstance;
            _loc1_.__cNextInstance = null;
         }
         else
         {
            _loc1_ = new FSimpleParticle();
         }
         return _loc1_;
      }
      
      fl2d var cNext:FSimpleParticle;
      fl2d var cPrevious:FSimpleParticle;
      fl2d var nX:Number;
      fl2d var nY:Number;
      fl2d var nRotation:Number;
      fl2d var nScaleX:Number;
      fl2d var nScaleY:Number;
      fl2d var nRed:Number;
      fl2d var nGreen:Number;
      fl2d var nBlue:Number;
      fl2d var nAlpha:Number;
      fl2d var nVelocityX:Number = 0;
      fl2d var nVelocityY:Number = 0;
      fl2d var nAccelerationX:Number;
      fl2d var nAccelerationY:Number;
      fl2d var nEnergy:Number = 0;
      fl2d var nInitialScale:Number = 1;
      fl2d var nEndScale:Number = 1;
      fl2d var nInitialVelocityX:Number;
      fl2d var nInitialVelocityY:Number;
      fl2d var nInitialVelocityAngular:Number;
      fl2d var nInitialAccelerationX:Number;
      fl2d var nInitialAccelerationY:Number;
      fl2d var nInitialRed:Number;
      fl2d var nInitialGreen:Number;
      fl2d var nInitialBlue:Number;
      fl2d var nInitialAlpha:Number;
      fl2d var nEndRed:Number;
      fl2d var nEndGreen:Number;
      fl2d var nEndBlue:Number;
      fl2d var nEndAlpha:Number;
      private var __nRedDif:Number;
      private var __nGreenDif:Number;
      private var __nBlueDif:Number;
      private var __nAlphaDif:Number;
      private var __nScaleDif:Number;
      fl2d var nAccumulatedEnergy:Number = 0;
      private var __cNextInstance:FSimpleParticle;
      private var __iId:int = 0;
      
      public function toString() : String {
         return "[" + __iId + "]";
      }
      
      fl2d function init(param1:FSimpleEmitter, param2:Boolean = true) : void {
         var _loc5_:* = NaN;
         var _loc3_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc16_:* = NaN;
         var _loc7_:* = NaN;
         var _loc11_:* = NaN;
         nAccumulatedEnergy = 0;
         nEnergy = param1.energy * 1000;
         if(param1.energyVariance > 0)
         {
            nEnergy = nEnergy + param1.energyVariance * 1000 * Math.random();
         }
         nInitialScale = param1.initialScale;
         if(param1.initialScaleVariance > 0)
         {
            nInitialScale = nInitialScale + param1.initialScaleVariance * Math.random();
         }
         nEndScale = param1.endScale;
         if(param1.endScaleVariance > 0)
         {
            nEndScale = nEndScale + param1.endScaleVariance * Math.random();
         }
         var _loc13_:Number = param1.initialVelocity;
         if(param1.initialVelocityVariance > 0)
         {
            _loc13_ = _loc13_ + param1.initialVelocityVariance * Math.random();
         }
         var _loc10_:Number = param1.initialAcceleration;
         if(param1.initialAccelerationVariance > 0)
         {
            _loc10_ = _loc10_ + param1.initialAccelerationVariance * Math.random();
         }
         _loc5_ = _loc13_;
         var _loc15_:Number = _loc5_;
         _loc3_ = 0;
         var _loc14_:Number = 0;
         _loc8_ = _loc10_;
         var _loc12_:Number = _loc8_;
         _loc9_ = 0;
         var _loc4_:Number = 0;
         var _loc6_:Number = param1.cNode.transform.nWorldRotation;
         if(_loc6_ != 0)
         {
            _loc16_ = Math.sin(_loc6_);
            _loc7_ = Math.cos(_loc6_);
            _loc5_ = _loc13_ * _loc7_;
            _loc15_ = _loc13_ * _loc7_;
            _loc3_ = _loc13_ * _loc16_;
            _loc14_ = _loc13_ * _loc16_;
            _loc8_ = _loc10_ * _loc7_;
            _loc12_ = _loc10_ * _loc7_;
            _loc9_ = _loc10_ * _loc16_;
            _loc4_ = _loc10_ * _loc16_;
         }
         if(!(param1.dispersionAngle == 0) || !(param1.dispersionAngleVariance == 0))
         {
            _loc11_ = param1.dispersionAngle;
            if(param1.dispersionAngleVariance > 0)
            {
               _loc11_ = _loc11_ + param1.dispersionAngleVariance * Math.random();
            }
            _loc16_ = Math.sin(_loc11_);
            _loc7_ = Math.cos(_loc11_);
            _loc5_ = _loc15_ * _loc7_ - _loc14_ * _loc16_;
            _loc3_ = _loc14_ * _loc7_ + _loc15_ * _loc16_;
            _loc8_ = _loc12_ * _loc7_ - _loc4_ * _loc16_;
            _loc9_ = _loc4_ * _loc7_ + _loc12_ * _loc16_;
         }
         nVelocityX = _loc5_ * 0.001;
         nInitialVelocityX = _loc5_ * 0.001;
         nVelocityY = _loc3_ * 0.001;
         nInitialVelocityY = _loc3_ * 0.001;
         nAccelerationX = _loc8_ * 0.001;
         nInitialAccelerationX = _loc8_ * 0.001;
         nAccelerationY = _loc9_ * 0.001;
         nInitialAccelerationY = _loc9_ * 0.001;
         nInitialVelocityAngular = param1.initialAngularVelocity;
         if(param1.initialAngularVelocityVariance > 0)
         {
            nInitialVelocityAngular = nInitialVelocityAngular + param1.initialAngularVelocityVariance * Math.random();
         }
         nInitialRed = param1.initialRed;
         if(param1.initialRedVariance > 0)
         {
            nInitialRed = nInitialRed + param1.initialRedVariance * Math.random();
         }
         nInitialGreen = param1.initialGreen;
         if(param1.initialGreenVariance > 0)
         {
            nInitialGreen = nInitialGreen + param1.initialGreenVariance * Math.random();
         }
         nInitialBlue = param1.initialBlue;
         if(param1.initialBlueVariance > 0)
         {
            nInitialBlue = nInitialBlue + param1.initialBlueVariance * Math.random();
         }
         nInitialAlpha = param1.initialAlpha;
         if(param1.initialAlphaVariance > 0)
         {
            nInitialAlpha = nInitialAlpha + param1.initialAlphaVariance * Math.random();
         }
         nEndRed = param1.endRed;
         if(param1.endRedVariance > 0)
         {
            nEndRed = nEndRed + param1.endRedVariance * Math.random();
         }
         nEndGreen = param1.endGreen;
         if(param1.endGreenVariance > 0)
         {
            nEndGreen = nEndGreen + param1.endGreenVariance * Math.random();
         }
         nEndBlue = param1.endBlue;
         if(param1.endBlueVariance > 0)
         {
            nEndBlue = nEndBlue + param1.endBlueVariance * Math.random();
         }
         nEndAlpha = param1.endAlpha;
         if(param1.endAlphaVariance > 0)
         {
            nEndAlpha = nEndAlpha + param1.endAlphaVariance * Math.random();
         }
         __nRedDif = nEndRed - nInitialRed;
         __nGreenDif = nEndGreen - nInitialGreen;
         __nBlueDif = nEndBlue - nInitialBlue;
         __nAlphaDif = nEndAlpha - nInitialAlpha;
         __nScaleDif = nEndScale - nInitialScale;
      }
      
      fl2d function update(param1:FSimpleEmitter, param2:Number) : void {
         var _loc5_:* = 0;
         var _loc4_:* = NaN;
         nAccumulatedEnergy = nAccumulatedEnergy + param2;
         if(nAccumulatedEnergy >= nEnergy)
         {
            param1.deactivateParticle(this);
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < param1.iFieldsCount)
         {
            param1.aFields[_loc5_].updateSimpleParticle(this,param2);
            _loc5_++;
         }
         var _loc3_:Number = nAccumulatedEnergy / nEnergy;
         nVelocityX = nVelocityX + nAccelerationX * param2;
         nVelocityY = nVelocityY + nAccelerationY * param2;
         nRed = __nRedDif * _loc3_ + nInitialRed;
         nGreen = __nGreenDif * _loc3_ + nInitialGreen;
         nBlue = __nBlueDif * _loc3_ + nInitialBlue;
         nAlpha = __nAlphaDif * _loc3_ + nInitialAlpha;
         nX = nX + nVelocityX * param2;
         nY = nY + nVelocityY * param2;
         nRotation = nRotation + nInitialVelocityAngular * param2;
         nScaleY = __nScaleDif * _loc3_ + nInitialScale;
         nScaleX = __nScaleDif * _loc3_ + nInitialScale;
         if(param1.special)
         {
            _loc4_ = Math.sqrt(nVelocityX * nVelocityX + nVelocityY * nVelocityY);
            nScaleY = _loc4_ * 10;
            nRotation = -Math.atan2(nVelocityX,nVelocityY);
         }
      }
      
      fl2d function dispose() : void {
         if(cNext)
         {
            cNext.cPrevious = cPrevious;
         }
         if(cPrevious)
         {
            cPrevious.cNext = cNext;
         }
         cNext = null;
         cPrevious = null;
         __cNextInstance = availableInstance;
         availableInstance = this;
      }
   }
}
