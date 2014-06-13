package com.flengine.components.particles
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.particles.fields.*;
    import com.flengine.components.renderables.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FSimpleEmitter extends FRenderable
    {
        public var emit:Boolean = false;
        public var initialScale:Number = 1;
        public var initialScaleVariance:Number = 0;
        public var endScale:Number = 1;
        public var endScaleVariance:Number = 0;
        public var energy:Number = 0;
        public var energyVariance:Number = 0;
        public var emission:int = 1;
        public var emissionVariance:int = 0;
        public var emissionTime:Number = 1;
        public var emissionDelay:Number = 0;
        public var initialVelocity:Number = 0;
        public var initialVelocityVariance:Number = 0;
        public var initialAcceleration:Number = 0;
        public var initialAccelerationVariance:Number = 0;
        public var initialAngularVelocity:Number = 0;
        public var initialAngularVelocityVariance:Number = 0;
        public var initialRed:Number = 1;
        public var initialRedVariance:Number = 0;
        public var initialGreen:Number = 1;
        public var initialGreenVariance:Number = 0;
        public var initialBlue:Number = 1;
        public var initialBlueVariance:Number = 0;
        public var initialAlpha:Number = 1;
        public var initialAlphaVariance:Number = 0;
        public var endRed:Number = 1;
        public var endRedVariance:Number = 0;
        public var endGreen:Number = 1;
        public var endGreenVariance:Number = 0;
        public var endBlue:Number = 1;
        public var endBlueVariance:Number = 0;
        public var endAlpha:Number = 1;
        public var endAlphaVariance:Number = 0;
        public var dispersionXVariance:Number = 0;
        public var dispersionYVariance:Number = 0;
        public var dispersionAngle:Number = 0;
        public var dispersionAngleVariance:Number = 0;
        public var initialAngle:Number = 0;
        public var initialAngleVariance:Number = 0;
        public var burst:Boolean = false;
        public var special:Boolean = false;
        protected var _nAccumulatedTime:Number = 0;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _cFirstParticle:FSimpleParticle;
        protected var _cLastParticle:FSimpleParticle;
        protected var _iActiveParticles:int = 0;
        private var __nLastUpdateTime:Number;
        private var __cTexture:FTexture;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FSimpleEmitter(param1:FNode)
        {
            aFields = new Vector.<FField>;
            super(param1);
            return;
        }// end function

        override public function bindFromPrototype(param1:XML) : void
        {
            super.bindFromPrototype(param1);
            return;
        }// end function

        public function get initialColor() : int
        {
            var _loc_1:* = initialRed * 255 << 16;
            var _loc_3:* = initialGreen * 255 << 8;
            var _loc_2:* = initialBlue * 255;
            return _loc_1 + _loc_3 + _loc_2;
        }// end function

        public function set initialColor(param1:int) : void
        {
            initialRed = (param1 >> 16 & 255) / 255;
            initialGreen = (param1 >> 8 & 255) / 255;
            initialBlue = (param1 & 255) / 255;
            return;
        }// end function

        public function get endColor() : int
        {
            var _loc_1:* = endRed * 255 << 16;
            var _loc_3:* = endGreen * 255 << 8;
            var _loc_2:* = endBlue * 255;
            return _loc_1 + _loc_3 + _loc_2;
        }// end function

        public function set endColor(param1:int) : void
        {
            endRed = (param1 >> 16 & 255) / 255;
            endGreen = (param1 >> 8 & 255) / 255;
            endBlue = (param1 & 255) / 255;
            return;
        }// end function

        public function get textureId() : String
        {
            return __cTexture ? (__cTexture.id) : ("");
        }// end function

        public function set textureId(param1:String) : void
        {
            __cTexture = FTexture.getTextureById(param1);
            return;
        }// end function

        public function setTexture(param1:FTexture) : void
        {
            __cTexture = param1;
            return;
        }// end function

        protected function setInitialParticlePosition(param1:FSimpleParticle) : void
        {
            var _loc_2:* = NaN;
            param1.nX = cNode.cTransform.nWorldX;
            if (dispersionXVariance > 0)
            {
                param1.nX = param1.nX + (dispersionXVariance * Math.random() - dispersionXVariance * 0.5);
            }
            param1.nY = cNode.cTransform.nWorldY;
            if (dispersionYVariance > 0)
            {
                param1.nY = param1.nY + (dispersionYVariance * Math.random() - dispersionYVariance * 0.5);
            }
            param1.nRotation = initialAngle;
            if (initialAngleVariance > 0)
            {
                param1.nRotation = param1.nRotation + initialAngleVariance * Math.random();
            }
            var _loc_3:* = initialScale;
            param1.nScaleY = initialScale;
            param1.nScaleX = _loc_3;
            if (initialScaleVariance > 0)
            {
                _loc_2 = initialScaleVariance * Math.random();
                param1.nScaleX = param1.nScaleX + _loc_2;
                param1.nScaleY = param1.nScaleY + _loc_2;
            }
            return;
        }// end function

        public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void
        {
            _nAccumulatedTime = 0;
            _nAccumulatedEmission = 0;
            return;
        }// end function

        private function createParticle() : FSimpleParticle
        {
            var _loc_1:* = FSimpleParticle.get();
            if (_cFirstParticle)
            {
                _loc_1.cNext = _cFirstParticle;
                _cFirstParticle.cPrevious = _loc_1;
                _cFirstParticle = _loc_1;
            }
            else
            {
                _cFirstParticle = _loc_1;
                _cLastParticle = _loc_1;
            }
            return _loc_1;
        }// end function

        public function forceBurst() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = emission + emissionVariance * Math.random();
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                activateParticle();
                _loc_1++;
            }
            emit = false;
            return;
        }// end function

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            var _loc_5:* = NaN;
            var _loc_6:* = 0;
            var _loc_4:* = null;
            var _loc_7:* = null;
            __nLastUpdateTime = param1;
            if (emit)
            {
                if (burst)
                {
                    forceBurst();
                }
                else
                {
                    _nAccumulatedTime = _nAccumulatedTime + param1 * 0.001;
                    _loc_5 = _nAccumulatedTime % (emissionTime + emissionDelay);
                    if (_loc_5 <= emissionTime)
                    {
                        _loc_6 = emission;
                        if (emissionVariance > 0)
                        {
                            _loc_6 = _loc_6 + emissionVariance * Math.random();
                        }
                        _nAccumulatedEmission = _nAccumulatedEmission + _loc_6 * param1 * 0.001;
                        while (_nAccumulatedEmission > 0)
                        {
                            
                            activateParticle();
                            (_nAccumulatedEmission - 1);
                        }
                    }
                }
            }
            _loc_4 = _cFirstParticle;
            while (_loc_4)
            {
                
                _loc_7 = _loc_4.cNext;
                _loc_4.update(this, __nLastUpdateTime);
                _loc_4 = _loc_7;
            }
            return;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_5:* = NaN;
            var _loc_4:* = NaN;
            if (__cTexture == null)
            {
                return;
            }
            var _loc_8:* = 0;
            _loc_6 = _cFirstParticle;
            while (_loc_6)
            {
                
                _loc_7 = _loc_6.cNext;
                _loc_5 = cNode.cTransform.nWorldX + (_loc_6.nX - cNode.cTransform.nWorldX) * 1;
                _loc_4 = cNode.cTransform.nWorldY + (_loc_6.nY - cNode.cTransform.nWorldY) * 1;
                param1.draw(__cTexture, _loc_5, _loc_4, _loc_6.nScaleX * cNode.cTransform.nWorldScaleX, _loc_6.nScaleY * cNode.cTransform.nWorldScaleY, _loc_6.nRotation, _loc_6.nRed, _loc_6.nGreen, _loc_6.nBlue, _loc_6.nAlpha, iBlendMode, param3);
                _loc_6 = _loc_7;
            }
            return;
        }// end function

        private function activateParticle() : void
        {
            var _loc_1:* = createParticle();
            setInitialParticlePosition(_loc_1);
            _loc_1.init(this);
            return;
        }// end function

        function deactivateParticle(param1:FSimpleParticle) : void
        {
            if (param1 == _cLastParticle)
            {
                _cLastParticle = _cLastParticle.cPrevious;
            }
            if (param1 == _cFirstParticle)
            {
                _cFirstParticle = _cFirstParticle.cNext;
            }
            param1.dispose();
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            return;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            return;
        }// end function

        public function addField(param1:FField) : void
        {
            if (param1 == null)
            {
                throw new Error("Field cannot be null.");
            }
            (iFieldsCount + 1);
            aFields.push(param1);
            return;
        }// end function

    }
}
