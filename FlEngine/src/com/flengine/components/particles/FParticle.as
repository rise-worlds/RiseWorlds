package com.flengine.components.particles
{
    import com.flengine.components.*;
    import com.flengine.core.*;

    public class FParticle extends FComponent
    {
        var nVelocityX:Number = 0;
        var nVelocityY:Number = 0;
        var nAccelerationX:Number;
        var nAccelerationY:Number;
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
        var cEmitter:FEmitter;
        protected var _nAccumulatedEnergy:Number = 0;

        public function FParticle(param1:FNode)
        {
            super(param1);
            return;
        }

        override public function set active(param1:Boolean) : void
        {
            _bActive = param1;
            _nAccumulatedEnergy = 0;
            return;
        }

        function init(param1:Boolean = true) : void
        {
            var _loc_4:* = NaN;
            var _loc_2:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_9:* = NaN;
            _nEnergy = (cEmitter.energy + cEmitter.energyVariance * Math.random()) * 1000;
            if (cEmitter.energyVariance > 0)
            {
                _nEnergy = _nEnergy + cEmitter.energyVariance * Math.random();
            }
            _nInitialScale = cEmitter.initialScale;
            if (cEmitter.initialScaleVariance > 0)
            {
                _nInitialScale = _nInitialScale + cEmitter.initialScaleVariance * Math.random();
            }
            _nEndScale = cEmitter.endScale;
            if (cEmitter.endScaleVariance > 0)
            {
                _nEndScale = _nEndScale + cEmitter.endScaleVariance * Math.random();
            }
            var _loc_14:* = Math.sin(cEmitter.cNode.transform.nWorldRotation);
            var _loc_5:* = Math.cos(cEmitter.cNode.transform.nWorldRotation);
            var _loc_11:* = cEmitter.initialVelocity;
            if (cEmitter.initialVelocityVariance > 0)
            {
                _loc_11 = _loc_11 + cEmitter.initialVelocityVariance * Math.random();
            }
            var _loc_8:* = cEmitter.initialAcceleration;
            if (cEmitter.initialAccelerationVariance > 0)
            {
                _loc_8 = _loc_8 + cEmitter.initialAccelerationVariance * Math.random();
            }
            _loc_4 = _loc_11 * _loc_5;
            var _loc_13:* = _loc_11 * _loc_5;
            _loc_2 = _loc_11 * _loc_14;
            var _loc_12:* = _loc_11 * _loc_14;
            _loc_6 = _loc_8 * _loc_5;
            var _loc_10:* = _loc_8 * _loc_5;
            _loc_7 = _loc_8 * _loc_14;
            var _loc_3:* = _loc_8 * _loc_14;
            if (cEmitter.dispersionAngle != 0 || cEmitter.dispersionAngleVariance != 0)
            {
                _loc_9 = cEmitter.dispersionAngle;
                if (cEmitter.dispersionAngleVariance > 0)
                {
                    _loc_9 = _loc_9 + cEmitter.dispersionAngleVariance * Math.random();
                }
                _loc_14 = Math.sin(_loc_9);
                _loc_5 = Math.cos(_loc_9);
                _loc_4 = _loc_13 * _loc_5 - _loc_12 * _loc_14;
                _loc_2 = _loc_12 * _loc_5 + _loc_13 * _loc_14;
                _loc_6 = _loc_10 * _loc_5 - _loc_3 * _loc_14;
                _loc_7 = _loc_3 * _loc_5 + _loc_10 * _loc_14;
            }
            nVelocityX = _loc_4 * 0.001;
            _nInitialVelocityX = _loc_4 * 0.001;
            nVelocityY = _loc_2 * 0.001;
            _nInitialVelocityY = _loc_2 * 0.001;
            nAccelerationX = _loc_6 * 0.001;
            _nInitialAccelerationX = _loc_6 * 0.001;
            nAccelerationY = _loc_7 * 0.001;
            _nInitialAccelerationY = _loc_7 * 0.001;
            _nInitialVelocityAngular = cEmitter.angularVelocity;
            if (cEmitter.angularVelocityVariance > 0)
            {
                _nInitialVelocityAngular = _nInitialVelocityAngular + cEmitter.angularVelocityVariance * Math.random();
            }
            _nInitialRed = cEmitter.initialRed;
            if (cEmitter.initialRedVariance > 0)
            {
                _nInitialRed = _nInitialRed + cEmitter.initialRedVariance * Math.random();
            }
            _nInitialGreen = cEmitter.initialGreen;
            if (cEmitter.initialGreenVariance > 0)
            {
                _nInitialGreen = _nInitialGreen + cEmitter.initialGreenVariance * Math.random();
            }
            _nInitialBlue = cEmitter.initialBlue;
            if (cEmitter.initialBlueVariance > 0)
            {
                _nInitialBlue = _nInitialBlue + cEmitter.initialBlueVariance * Math.random();
            }
            _nInitialAlpha = cEmitter.initialAlpha;
            if (cEmitter.initialAlphaVariance > 0)
            {
                _nInitialAlpha = _nInitialAlpha + cEmitter.initialAlphaVariance * Math.random();
            }
            _nEndRed = cEmitter.endRed;
            if (cEmitter.endRedVariance > 0)
            {
                _nEndRed = _nEndRed + cEmitter.endRedVariance * Math.random();
            }
            _nEndGreen = cEmitter.endGreen;
            if (cEmitter.endGreenVariance > 0)
            {
                _nEndGreen = _nEndGreen + cEmitter.endGreenVariance * Math.random();
            }
            _nEndBlue = cEmitter.endBlue;
            if (cEmitter.endBlueVariance > 0)
            {
                _nEndBlue = _nEndBlue + cEmitter.endBlueVariance * Math.random();
            }
            _nEndAlpha = cEmitter.endAlpha;
            if (cEmitter.endAlphaVariance > 0)
            {
                _nEndAlpha = _nEndAlpha + cEmitter.endAlphaVariance * Math.random();
            }
            return;
        }

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            var _loc_5:* = 0;
            _nAccumulatedEnergy = _nAccumulatedEnergy + param1;
            if (_nAccumulatedEnergy >= _nEnergy)
            {
                cNode.active = false;
                return;
            }
            _loc_5 = 0;
            while (_loc_5 < cEmitter.iFieldsCount)
            {
                
                cEmitter.aFields[_loc_5].updateParticle(this, param1);
                _loc_5++;
            }
            var _loc_4:* = _nAccumulatedEnergy / _nEnergy;
            nVelocityX = nVelocityX + nAccelerationX * param1;
            nVelocityY = nVelocityY + nAccelerationY * param1;
            cNode.cTransform.red = (_nEndRed - _nInitialRed) * _loc_4 + _nInitialRed;
            cNode.cTransform.green = (_nEndGreen - _nInitialGreen) * _loc_4 + _nInitialGreen;
            cNode.cTransform.blue = (_nEndBlue - _nInitialBlue) * _loc_4 + _nInitialBlue;
            cNode.cTransform.alpha = (_nEndAlpha - _nInitialAlpha) * _loc_4 + _nInitialAlpha;
            cNode.cTransform.x = cNode.cTransform.x + nVelocityX * param1;
            cNode.cTransform.y = cNode.cTransform.y + nVelocityY * param1;
            cNode.cTransform.rotation = cNode.cTransform.rotation + _nInitialVelocityAngular * param1;
            var _loc_6:* = (_nEndScale - _nInitialScale) * _loc_4 + _nInitialScale;
            cNode.cTransform.scaleY = (_nEndScale - _nInitialScale) * _loc_4 + _nInitialScale;
            cNode.cTransform.scaleX = _loc_6;
            return;
        }

    }
}
