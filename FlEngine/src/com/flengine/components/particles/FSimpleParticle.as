package com.flengine.components.particles
{

    public class FSimpleParticle extends Object
    {
        var cNext:FSimpleParticle;
        var cPrevious:FSimpleParticle;
        var nX:Number;
        var nY:Number;
        var nRotation:Number;
        var nScaleX:Number;
        var nScaleY:Number;
        var nRed:Number;
        var nGreen:Number;
        var nBlue:Number;
        var nAlpha:Number;
        var nVelocityX:Number = 0;
        var nVelocityY:Number = 0;
        var nAccelerationX:Number;
        var nAccelerationY:Number;
        var nEnergy:Number = 0;
        var nInitialScale:Number = 1;
        var nEndScale:Number = 1;
        var nInitialVelocityX:Number;
        var nInitialVelocityY:Number;
        var nInitialVelocityAngular:Number;
        var nInitialAccelerationX:Number;
        var nInitialAccelerationY:Number;
        var nInitialRed:Number;
        var nInitialGreen:Number;
        var nInitialBlue:Number;
        var nInitialAlpha:Number;
        var nEndRed:Number;
        var nEndGreen:Number;
        var nEndBlue:Number;
        var nEndAlpha:Number;
        private var __nRedDif:Number;
        private var __nGreenDif:Number;
        private var __nBlueDif:Number;
        private var __nAlphaDif:Number;
        private var __nScaleDif:Number;
        var nAccumulatedEnergy:Number = 0;
        private var __cNextInstance:FSimpleParticle;
        private var __iId:int = 0;
        private static var availableInstance:FSimpleParticle;
        private static var count:int = 0;

        public function FSimpleParticle() : void
        {
            (count + 1);
            __iId = count;
            return;
        }// end function

        public function toString() : String
        {
            return "[" + __iId + "]";
        }// end function

        function init(param1:FSimpleEmitter, param2:Boolean = true) : void
        {
            var _loc_5:* = NaN;
            var _loc_3:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_16:* = NaN;
            var _loc_7:* = NaN;
            var _loc_11:* = NaN;
            nAccumulatedEnergy = 0;
            nEnergy = param1.energy * 1000;
            if (param1.energyVariance > 0)
            {
                nEnergy = nEnergy + param1.energyVariance * 1000 * Math.random();
            }
            nInitialScale = param1.initialScale;
            if (param1.initialScaleVariance > 0)
            {
                nInitialScale = nInitialScale + param1.initialScaleVariance * Math.random();
            }
            nEndScale = param1.endScale;
            if (param1.endScaleVariance > 0)
            {
                nEndScale = nEndScale + param1.endScaleVariance * Math.random();
            }
            var _loc_13:* = param1.initialVelocity;
            if (param1.initialVelocityVariance > 0)
            {
                _loc_13 = _loc_13 + param1.initialVelocityVariance * Math.random();
            }
            var _loc_10:* = param1.initialAcceleration;
            if (param1.initialAccelerationVariance > 0)
            {
                _loc_10 = _loc_10 + param1.initialAccelerationVariance * Math.random();
            }
            _loc_5 = _loc_13;
            var _loc_15:* = _loc_5;
            _loc_3 = 0;
            var _loc_14:* = 0;
            _loc_8 = _loc_10;
            var _loc_12:* = _loc_8;
            _loc_9 = 0;
            var _loc_4:* = 0;
            var _loc_6:* = param1.cNode.transform.nWorldRotation;
            if (param1.cNode.transform.nWorldRotation != 0)
            {
                _loc_16 = Math.sin(_loc_6);
                _loc_7 = Math.cos(_loc_6);
                _loc_5 = _loc_13 * _loc_7;
                _loc_15 = _loc_13 * _loc_7;
                _loc_3 = _loc_13 * _loc_16;
                _loc_14 = _loc_13 * _loc_16;
                _loc_8 = _loc_10 * _loc_7;
                _loc_12 = _loc_10 * _loc_7;
                _loc_9 = _loc_10 * _loc_16;
                _loc_4 = _loc_10 * _loc_16;
            }
            if (param1.dispersionAngle != 0 || param1.dispersionAngleVariance != 0)
            {
                _loc_11 = param1.dispersionAngle;
                if (param1.dispersionAngleVariance > 0)
                {
                    _loc_11 = _loc_11 + param1.dispersionAngleVariance * Math.random();
                }
                _loc_16 = Math.sin(_loc_11);
                _loc_7 = Math.cos(_loc_11);
                _loc_5 = _loc_15 * _loc_7 - _loc_14 * _loc_16;
                _loc_3 = _loc_14 * _loc_7 + _loc_15 * _loc_16;
                _loc_8 = _loc_12 * _loc_7 - _loc_4 * _loc_16;
                _loc_9 = _loc_4 * _loc_7 + _loc_12 * _loc_16;
            }
            nVelocityX = _loc_5 * 0.001;
            nInitialVelocityX = _loc_5 * 0.001;
            nVelocityY = _loc_3 * 0.001;
            nInitialVelocityY = _loc_3 * 0.001;
            nAccelerationX = _loc_8 * 0.001;
            nInitialAccelerationX = _loc_8 * 0.001;
            nAccelerationY = _loc_9 * 0.001;
            nInitialAccelerationY = _loc_9 * 0.001;
            nInitialVelocityAngular = param1.initialAngularVelocity;
            if (param1.initialAngularVelocityVariance > 0)
            {
                nInitialVelocityAngular = nInitialVelocityAngular + param1.initialAngularVelocityVariance * Math.random();
            }
            nInitialRed = param1.initialRed;
            if (param1.initialRedVariance > 0)
            {
                nInitialRed = nInitialRed + param1.initialRedVariance * Math.random();
            }
            nInitialGreen = param1.initialGreen;
            if (param1.initialGreenVariance > 0)
            {
                nInitialGreen = nInitialGreen + param1.initialGreenVariance * Math.random();
            }
            nInitialBlue = param1.initialBlue;
            if (param1.initialBlueVariance > 0)
            {
                nInitialBlue = nInitialBlue + param1.initialBlueVariance * Math.random();
            }
            nInitialAlpha = param1.initialAlpha;
            if (param1.initialAlphaVariance > 0)
            {
                nInitialAlpha = nInitialAlpha + param1.initialAlphaVariance * Math.random();
            }
            nEndRed = param1.endRed;
            if (param1.endRedVariance > 0)
            {
                nEndRed = nEndRed + param1.endRedVariance * Math.random();
            }
            nEndGreen = param1.endGreen;
            if (param1.endGreenVariance > 0)
            {
                nEndGreen = nEndGreen + param1.endGreenVariance * Math.random();
            }
            nEndBlue = param1.endBlue;
            if (param1.endBlueVariance > 0)
            {
                nEndBlue = nEndBlue + param1.endBlueVariance * Math.random();
            }
            nEndAlpha = param1.endAlpha;
            if (param1.endAlphaVariance > 0)
            {
                nEndAlpha = nEndAlpha + param1.endAlphaVariance * Math.random();
            }
            __nRedDif = nEndRed - nInitialRed;
            __nGreenDif = nEndGreen - nInitialGreen;
            __nBlueDif = nEndBlue - nInitialBlue;
            __nAlphaDif = nEndAlpha - nInitialAlpha;
            __nScaleDif = nEndScale - nInitialScale;
            return;
        }// end function

        function update(param1:FSimpleEmitter, param2:Number) : void
        {
            var _loc_5:* = 0;
            var _loc_4:* = NaN;
            nAccumulatedEnergy = nAccumulatedEnergy + param2;
            if (nAccumulatedEnergy >= nEnergy)
            {
                param1.deactivateParticle(this);
                return;
            }
            _loc_5 = 0;
            while (_loc_5 < param1.iFieldsCount)
            {
                
                param1.aFields[_loc_5].updateSimpleParticle(this, param2);
                _loc_5++;
            }
            var _loc_3:* = nAccumulatedEnergy / nEnergy;
            nVelocityX = nVelocityX + nAccelerationX * param2;
            nVelocityY = nVelocityY + nAccelerationY * param2;
            nRed = __nRedDif * _loc_3 + nInitialRed;
            nGreen = __nGreenDif * _loc_3 + nInitialGreen;
            nBlue = __nBlueDif * _loc_3 + nInitialBlue;
            nAlpha = __nAlphaDif * _loc_3 + nInitialAlpha;
            nX = nX + nVelocityX * param2;
            nY = nY + nVelocityY * param2;
            nRotation = nRotation + nInitialVelocityAngular * param2;
            nScaleY = __nScaleDif * _loc_3 + nInitialScale;
            nScaleX = __nScaleDif * _loc_3 + nInitialScale;
            if (param1.special)
            {
                _loc_4 = Math.sqrt(nVelocityX * nVelocityX + nVelocityY * nVelocityY);
                nScaleY = _loc_4 * 10;
                nRotation = -Math.atan2(nVelocityX, nVelocityY);
            }
            return;
        }// end function

        function dispose() : void
        {
            if (cNext)
            {
                cNext.cPrevious = cPrevious;
            }
            if (cPrevious)
            {
                cPrevious.cNext = cNext;
            }
            cNext = null;
            cPrevious = null;
            __cNextInstance = availableInstance;
            availableInstance = this;
            return;
        }// end function

        public static function precache(param1:int) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = null;
            if (param1 < count)
            {
                return;
            }
            var _loc_3:* = get();
            while (count < param1)
            {
                
                _loc_4 = get();
                _loc_4.cPrevious = _loc_3;
                _loc_3 = _loc_4;
            }
            while (_loc_3)
            {
                
                _loc_2 = _loc_3;
                _loc_3 = _loc_2.cPrevious;
                _loc_2.dispose();
            }
            return;
        }// end function

        static function get() : FSimpleParticle
        {
            var _loc_1:* = availableInstance;
            if (_loc_1)
            {
                availableInstance = _loc_1.__cNextInstance;
                _loc_1.__cNextInstance = null;
            }
            else
            {
                _loc_1 = new FSimpleParticle;
            }
            return _loc_1;
        }// end function

    }
}
