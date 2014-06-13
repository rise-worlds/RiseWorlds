package com.flengine.components.particles
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.particles.fields.*;
    import com.flengine.core.*;
    import com.flengine.error.*;
    import flash.display.*;

    public class FEmitter extends FComponent
    {
        public var emit:Boolean = true;
        public var initialScale:Number = 1;
        public var initialScaleVariance:Number = 0;
        public var endScale:Number = 1;
        public var endScaleVariance:Number = 0;
        public var energy:Number = 1;
        public var energyVariance:Number = 0;
        public var emission:int = 1;
        public var emissionVariance:int = 0;
        public var emissionTime:Number = 1;
        public var emissionDelay:Number = 0;
        public var initialVelocity:Number = 0;
        public var initialVelocityVariance:Number = 0;
        public var initialAcceleration:Number = 0;
        public var initialAccelerationVariance:Number = 0;
        public var angularVelocity:Number = 0;
        public var angularVelocityVariance:Number = 0;
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
        public var useWorldSpace:Boolean = false;
        public var bitmapData:BitmapData;
        private var __aOffsets:Vector.<int>;
        private var _aPreviousParticlePools:Array;
        protected var _xParticlePrototype:XML;
        protected var _nAccumulatedTime:Number = 0;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _aParticles:Vector.<FParticle>;
        protected var _iActiveParticles:int = 0;
        protected var _cParticlePool:FNodePool;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FEmitter(param1:FNode)
        {
            _aPreviousParticlePools = [];
            _aParticles = new Vector.<FParticle>;
            aFields = new Vector.<FField>;
            super(param1);
            return;
        }

        override public function getPrototype() : XML
        {
            _xPrototype = super.getPrototype();
            if (_xParticlePrototype != null)
            {
                _xPrototype.particlePrototype = <particlePrototype/>
				;
                _xPrototype.particlePrototype.appendChild(_xParticlePrototype);
            }
            return _xPrototype;
        }

        override public function bindFromPrototype(param1:XML) : void
        {
            super.bindFromPrototype(param1);
            if (param1.particlesPrototype != null)
            {
                setParticlePrototype(param1.particlePrototype.node[0]);
            }
            return;
        }

        public function get initialColor() : int
        {
            return initialRed * 16711680 + initialGreen * 65280 + initialBlue * 255;
        }

        public function set initialColor(param1:int) : void
        {
            initialRed = (param1 >> 16 & 255) / 255;
            initialGreen = (param1 >> 8 & 255) / 255;
            initialBlue = (param1 & 255) / 255;
            return;
        }

        public function get endColor() : int
        {
            return endRed * 16711680 + endGreen * 65280 + endBlue * 255;
        }

        public function set endColor(param1:int) : void
        {
            endRed = (param1 >> 16 & 255) / 255;
            endGreen = (param1 >> 8 & 255) / 255;
            endBlue = (param1 & 255) / 255;
            return;
        }

        public function invalidateBitmapData() : void
        {
            var _loc_3:* = 0;
            __aOffsets = new Vector.<int>;
            var _loc_1:* = bitmapData.width;
            var _loc_2:* = bitmapData.getVector(bitmapData.rect);
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if ((_loc_2[_loc_3] >> 24 & 255) > 0)
                {
                    __aOffsets.push(_loc_3 % _loc_1, _loc_3 / _loc_1);
                }
                _loc_3++;
            }
            return;
        }

        public function setParticlePrototype(param1:XML) : void
        {
            _xParticlePrototype = param1;
            return;
        }

        public function get particlesCachedCount() : int
        {
            if (_cParticlePool != null)
            {
                return _cParticlePool.cachedCount;
            }
            return 0;
        }

        protected function setInitialParticlePosition(param1:FNode) : void
        {
            if (useWorldSpace)
            {
                param1.cTransform.x = cNode.cTransform.nWorldX + Math.random() * dispersionXVariance - dispersionXVariance * 0.5;
                param1.cTransform.y = cNode.cTransform.nWorldY + Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
            }
            else
            {
                param1.cTransform.x = Math.random() * dispersionXVariance - dispersionXVariance * 0.5;
                param1.cTransform.y = Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
            }
            return;
        }

        protected function get initialParticleY() : Number
        {
            return cNode.cTransform.nWorldY + Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
        }

        override public function set active(param1:Boolean) : void
        {
            active = param1;
            if (_cParticlePool)
            {
                _cParticlePool.deactivate();
            }
            return;
        }

        public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void
        {
            _nAccumulatedTime = 0;
            _nAccumulatedEmission = 0;
            if (_cParticlePool)
            {
                if (param3)
                {
                    _cParticlePool.dispose();
                }
                else
                {
                    _aPreviousParticlePools.push({pool:_cParticlePool, time:(energy + energyVariance) * 1000});
                }
            }
            _cParticlePool = new FNodePool(_xParticlePrototype, param1, param2);
            return;
        }

        public function forceBurst() : void
        {
            var _loc_2:* = 0;
            if (!_cParticlePool)
            {
                return;
            }
            var _loc_1:* = emission + emissionVariance * Math.random();
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                activateParticle();
                _loc_2++;
            }
            emit = false;
            return;
        }

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            if (_aPreviousParticlePools.length > 0)
            {
                _aPreviousParticlePools[0].time = _aPreviousParticlePools[0].time - param1;
                if (_aPreviousParticlePools[0].time <= 0)
                {
                    _aPreviousParticlePools[0].pool.dispose();
                    _aPreviousParticlePools.shift();
                }
            }
            if (!emit || _cParticlePool == null)
            {
                return;
            }
            if (burst)
            {
                forceBurst();
            }
            else
            {
                _nAccumulatedTime = _nAccumulatedTime + param1 * 0.001;
                _loc_4 = _nAccumulatedTime % (emissionTime + emissionDelay);
                if (_loc_4 <= emissionTime)
                {
                    _loc_5 = emission;
                    if (emissionVariance > 0)
                    {
                        _loc_5 = _loc_5 + emissionVariance * Math.random();
                    }
                    _nAccumulatedEmission = _nAccumulatedEmission + _loc_5 * param1 * 0.001;
                    while (_nAccumulatedEmission > 0)
                    {
                        
                        activateParticle();
                        (_nAccumulatedEmission - 1);
                    }
                }
            }
            return;
        }

        private function activateParticle() : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = _cParticlePool.getNext();
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_1:* = _loc_2.getComponent(FParticle) as FParticle;
            if (_loc_1 == null)
            {
                throw new FError("FError: Cannot instantiate abstract class.");
            }
            _loc_1.cEmitter = this;
            _loc_2.cTransform.useWorldSpace = useWorldSpace;
            if (useWorldSpace)
            {
                if (bitmapData)
                {
                    _loc_3 = (__aOffsets.length - 1) / 2 * Math.random() * 2;
                    _loc_2.cTransform.x = cNode.cTransform.nWorldX - bitmapData.width / 2 + __aOffsets[_loc_3];
                    _loc_2.cTransform.y = cNode.cTransform.nWorldY - bitmapData.height / 2 + __aOffsets[(_loc_3 + 1)];
                }
                else
                {
                    setInitialParticlePosition(_loc_2);
                }
            }
            else
            {
                setInitialParticlePosition(_loc_2);
            }
            var _loc_4:* = initialScale + initialScaleVariance * Math.random();
            _loc_2.transform.scaleY = initialScale + initialScaleVariance * Math.random();
            _loc_2.cTransform.scaleX = _loc_4;
            _loc_2.cTransform.rotation = initialAngle + Math.random() * initialAngleVariance;
            _loc_1.init();
            cNode.addChild(_loc_2);
            return;
        }

        override public function dispose() : void
        {
            if (_cParticlePool != null)
            {
                _cParticlePool.dispose();
            }
            _cParticlePool = null;
            super.dispose();
            return;
        }

        public function clear(param1:Boolean = false) : void
        {
            if (_cParticlePool == null)
            {
                return;
            }
            if (param1)
            {
                _cParticlePool.dispose();
            }
            else
            {
                _cParticlePool.deactivate();
            }
            return;
        }

        public function addField(param1:FField) : void
        {
            if (param1 == null)
            {
                throw new Error("Field cannot be null.");
            }
            (iFieldsCount + 1);
            aFields.push(param1);
            return;
        }

    }
}
