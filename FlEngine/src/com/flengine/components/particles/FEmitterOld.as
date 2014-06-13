package com.flengine.components.particles
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.particles.fields.*;
    import com.flengine.core.*;
    import com.flengine.error.*;

    public class FEmitterOld extends FComponent
    {
        public var emit:Boolean = true;
        public var angle:Number = 0;
        public var uniformScale:Boolean = true;
        private var __nMinScaleX:Number = 1;
        private var __nMaxScaleX:Number = 1;
        private var __nMinScaleY:Number = 1;
        private var __nMaxScaleY:Number = 1;
        private var __nMinEnergy:Number = 1;
        private var __nMaxEnergy:Number = 1;
        private var __iMinEmission:Number = 1;
        private var __iMaxEmission:Number = 1;
        private var __nMinWorldVelocityX:Number = 0;
        private var __nMaxWorldVelocityX:Number = 0;
        private var __nMinWorldVelocityY:Number = 0;
        private var __nMaxWorldVelocityY:Number = 0;
        private var __nMinLocalVelocityX:Number = 0;
        private var __nMaxLocalVelocityX:Number = 0;
        private var __nMinLocalVelocityY:Number = 0;
        private var __nMaxLocalVelocityY:Number = 0;
        private var __nMinAngularVelocity:Number = 0;
        private var __nMaxAngularVelocity:Number = 0;
        public var initialParticleRed:Number = 1;
        public var initialParticleGreen:Number = 1;
        public var initialParticleBlue:Number = 1;
        public var initialParticleAlpha:Number = 1;
        public var endParticleRed:Number = 1;
        public var endParticleGreen:Number = 1;
        public var endParticleBlue:Number = 1;
        public var endParticleAlpha:Number = 1;
        public var initialDispersionX:Number = 0;
        public var initialDispersionY:Number = 0;
        public var initialAngle:Number = 0;
        public var burst:Boolean = false;
        public var useWorldSpace:Boolean = false;
        private var _aPreviousParticlePools:Array;
        protected var _xParticlePrototype:XML;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _aParticles:Vector.<FParticleOld>;
        protected var _iActiveParticles:int = 0;
        protected var _cParticlePool:FNodePool;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FEmitterOld(param1:FNode)
        {
            _aPreviousParticlePools = [];
            _aParticles = new Vector.<FParticleOld>;
            aFields = new Vector.<FField>;
            super(param1);
            return;
        }// end function

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
        }// end function

        override public function bindFromPrototype(param1:XML) : void
        {
            super.bindFromPrototype(param1);
            if (param1.particlesPrototype != null)
            {
                setParticlePrototype(param1.particlePrototype.node[0]);
            }
            return;
        }// end function

        public function set minScaleX(param1:Number) : void
        {
            __nMinScaleX = param1;
            if (__nMaxScaleX < __nMinScaleX)
            {
                __nMaxScaleX = __nMinScaleX;
            }
            return;
        }// end function

        public function get minScaleX() : Number
        {
            return __nMinScaleX;
        }// end function

        public function set maxScaleX(param1:Number) : void
        {
            __nMaxScaleX = param1;
            if (__nMinScaleX > __nMaxScaleX)
            {
                __nMinScaleX = __nMaxScaleX;
            }
            return;
        }// end function

        public function get maxScaleX() : Number
        {
            return __nMaxScaleX;
        }// end function

        public function set minScaleY(param1:Number) : void
        {
            __nMinScaleY = param1;
            if (__nMaxScaleY < __nMinScaleY)
            {
                __nMaxScaleY = __nMinScaleY;
            }
            return;
        }// end function

        public function get minScaleY() : Number
        {
            return __nMinScaleY;
        }// end function

        public function set maxScaleY(param1:Number) : void
        {
            __nMaxScaleY = param1;
            if (__nMinScaleY > __nMaxScaleY)
            {
                __nMinScaleY = __nMaxScaleY;
            }
            return;
        }// end function

        public function get maxScaleY() : Number
        {
            return __nMaxScaleY;
        }// end function

        public function set minEnergy(param1:Number) : void
        {
            __nMinEnergy = param1;
            if (__nMaxEnergy < __nMinEnergy)
            {
                __nMaxEnergy = __nMinEnergy;
            }
            return;
        }// end function

        public function get minEnergy() : Number
        {
            return __nMinEnergy;
        }// end function

        public function set maxEnergy(param1:Number) : void
        {
            __nMaxEnergy = param1;
            if (__nMinEnergy > __nMaxEnergy)
            {
                __nMinEnergy = __nMaxEnergy;
            }
            return;
        }// end function

        public function get maxEnergy() : Number
        {
            return __nMaxEnergy;
        }// end function

        public function set minEmission(param1:int) : void
        {
            __iMinEmission = param1;
            if (__iMaxEmission < __iMinEmission)
            {
                __iMaxEmission = __iMinEmission;
            }
            return;
        }// end function

        public function get minEmission() : int
        {
            return __iMinEmission;
        }// end function

        public function set maxEmission(param1:int) : void
        {
            __iMaxEmission = param1;
            if (__iMinEmission > __iMaxEmission)
            {
                __iMinEmission = __iMaxEmission;
            }
            return;
        }// end function

        public function get maxEmission() : int
        {
            return __iMaxEmission;
        }// end function

        public function set minWorldVelocityX(param1:Number) : void
        {
            __nMinWorldVelocityX = param1;
            if (__nMaxWorldVelocityX < __nMinWorldVelocityX)
            {
                __nMaxWorldVelocityX = __nMinWorldVelocityX;
            }
            return;
        }// end function

        public function get minWorldVelocityX() : Number
        {
            return __nMinWorldVelocityX;
        }// end function

        public function set maxWorldVelocityX(param1:Number) : void
        {
            __nMaxWorldVelocityX = param1;
            if (__nMinWorldVelocityX > __nMaxWorldVelocityX)
            {
                __nMinWorldVelocityX = __nMaxWorldVelocityX;
            }
            return;
        }// end function

        public function get maxWorldVelocityX() : Number
        {
            return __nMaxWorldVelocityX;
        }// end function

        public function set minWorldVelocityY(param1:Number) : void
        {
            __nMinWorldVelocityY = param1;
            if (__nMaxWorldVelocityY < __nMinWorldVelocityY)
            {
                __nMaxWorldVelocityY = __nMinWorldVelocityY;
            }
            return;
        }// end function

        public function get minWorldVelocityY() : Number
        {
            return __nMinWorldVelocityY;
        }// end function

        public function set maxWorldVelocityY(param1:Number) : void
        {
            __nMaxWorldVelocityY = param1;
            if (__nMinWorldVelocityY > __nMaxWorldVelocityY)
            {
                __nMinWorldVelocityY = __nMaxWorldVelocityY;
            }
            return;
        }// end function

        public function get maxWorldVelocityY() : Number
        {
            return __nMaxWorldVelocityY;
        }// end function

        public function set minLocalVelocityX(param1:Number) : void
        {
            __nMinLocalVelocityX = param1;
            if (__nMaxLocalVelocityX < __nMinLocalVelocityX)
            {
                __nMaxLocalVelocityX = __nMinLocalVelocityX;
            }
            return;
        }// end function

        public function get minLocalVelocityX() : Number
        {
            return __nMinLocalVelocityX;
        }// end function

        public function set maxLocalVelocityX(param1:Number) : void
        {
            __nMaxLocalVelocityX = param1;
            if (__nMinLocalVelocityX > __nMaxLocalVelocityX)
            {
                __nMinLocalVelocityX = __nMaxLocalVelocityX;
            }
            return;
        }// end function

        public function get maxLocalVelocityX() : Number
        {
            return __nMaxLocalVelocityX;
        }// end function

        public function set minLocalVelocityY(param1:Number) : void
        {
            __nMinLocalVelocityY = param1;
            if (__nMaxLocalVelocityY < __nMinLocalVelocityY)
            {
                __nMaxLocalVelocityY = __nMinLocalVelocityY;
            }
            return;
        }// end function

        public function get minLocalVelocityY() : Number
        {
            return __nMinLocalVelocityY;
        }// end function

        public function set maxLocalVelocityY(param1:Number) : void
        {
            __nMaxLocalVelocityY = param1;
            if (__nMinLocalVelocityY > __nMaxLocalVelocityY)
            {
                __nMinLocalVelocityY = __nMaxLocalVelocityY;
            }
            return;
        }// end function

        public function get maxLocalVelocityY() : Number
        {
            return __nMaxLocalVelocityY;
        }// end function

        public function set minAngularVelocity(param1:Number) : void
        {
            __nMinAngularVelocity = param1;
            if (__nMaxAngularVelocity < __nMinLocalVelocityY)
            {
                __nMaxAngularVelocity = __nMinAngularVelocity;
            }
            return;
        }// end function

        public function get minAngularVelocity() : Number
        {
            return __nMinAngularVelocity;
        }// end function

        public function set maxAngularVelocity(param1:Number) : void
        {
            __nMaxAngularVelocity = param1;
            if (__nMinAngularVelocity > __nMaxAngularVelocity)
            {
                __nMinAngularVelocity = __nMaxAngularVelocity;
            }
            return;
        }// end function

        public function get maxAngularVelocity() : Number
        {
            return __nMaxAngularVelocity;
        }// end function

        public function setParticlePrototype(param1:XML) : void
        {
            _xParticlePrototype = param1;
            return;
        }// end function

        public function get particlesCachedCount() : int
        {
            return _cParticlePool.cachedCount;
        }// end function

        override public function set active(param1:Boolean) : void
        {
            active = param1;
            if (_cParticlePool)
            {
                _cParticlePool.deactivate();
            }
            return;
        }// end function

        public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void
        {
            if (_cParticlePool)
            {
                if (param3)
                {
                    _cParticlePool.dispose();
                }
                else
                {
                    _aPreviousParticlePools.push({pool:_cParticlePool, time:__nMaxEnergy * 1000});
                }
            }
            _cParticlePool = new FNodePool(_xParticlePrototype, param1, param2);
            return;
        }// end function

        public function forceBurst() : void
        {
            var _loc_2:* = 0;
            if (!_cParticlePool)
            {
                return;
            }
            var _loc_1:* = minEmission + (maxEmission - minEmission) * Math.random();
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                activateParticle();
                emit = false;
                _loc_2++;
            }
            return;
        }// end function

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            var _loc_4:* = 0;
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
                _loc_4 = minEmission + (maxEmission - minEmission) * Math.random();
                _nAccumulatedEmission = _nAccumulatedEmission + _loc_4 * param1 * 0.001;
                while (_nAccumulatedEmission > 0)
                {
                    
                    activateParticle();
                    (_nAccumulatedEmission - 1);
                }
            }
            return;
        }// end function

        private function activateParticle() : void
        {
            var _loc_10:* = NaN;
            var _loc_15:* = NaN;
            var _loc_4:* = NaN;
            var _loc_13:* = _cParticlePool.getNext();
            if (_cParticlePool.getNext() == null)
            {
                return;
            }
            var _loc_11:* = _loc_13.getComponent(FParticleOld) as FParticleOld;
            if (_loc_13.getComponent(FParticleOld) as FParticleOld == null)
            {
                throw new FError("FError: Cannot instantiate abstract class.");
            }
            var _loc_1:* = __nMinScaleX + (__nMaxScaleX - __nMinScaleX) * Math.random();
            var _loc_2:* = uniformScale ? (_loc_1) : (__nMinScaleY + (__nMaxScaleY - __nMinScaleY) * Math.random());
            _loc_13.transform.useWorldSpace = useWorldSpace;
            if (useWorldSpace)
            {
                _loc_13.transform.x = cNode.transform.nWorldX + Math.random() * initialDispersionX - initialDispersionX * 0.5;
                _loc_13.transform.y = cNode.transform.nWorldY + Math.random() * initialDispersionY - initialDispersionY * 0.5;
            }
            else
            {
                _loc_13.transform.x = Math.random() * initialDispersionX - initialDispersionX * 0.5;
                _loc_13.transform.y = Math.random() * initialDispersionY - initialDispersionY * 0.5;
            }
            _loc_13.transform.scaleX = _loc_1;
            _loc_13.transform.scaleY = _loc_2;
            _loc_13.transform.rotation = initialAngle > 0 ? (initialAngle * Math.random()) : (0);
            var _loc_16:* = Math.sin(cNode.transform.nWorldRotation);
            var _loc_3:* = Math.cos(cNode.transform.nWorldRotation);
            var _loc_6:* = __nMinLocalVelocityX + Math.random() * (__nMaxLocalVelocityX - __nMinLocalVelocityX);
            var _loc_8:* = __nMinLocalVelocityY + Math.random() * (__nMaxLocalVelocityY - __nMinLocalVelocityY);
            var _loc_14:* = __nMinWorldVelocityX + Math.random() * (__nMaxWorldVelocityX - __nMinWorldVelocityX);
            var _loc_12:* = __nMinWorldVelocityY + Math.random() * (__nMaxWorldVelocityY - __nMinWorldVelocityY);
            _loc_10 = _loc_14 + (_loc_6 * _loc_3 - _loc_8 * _loc_16);
            var _loc_5:* = _loc_10;
            _loc_15 = _loc_12 + (_loc_8 * _loc_3 + _loc_6 * _loc_16);
            var _loc_7:* = _loc_15;
            if (angle != 0)
            {
                _loc_4 = Math.random() * angle - angle / 2;
                _loc_16 = Math.sin(_loc_4);
                _loc_3 = Math.cos(_loc_4);
                _loc_10 = _loc_5 * _loc_3 - _loc_7 * _loc_16;
                _loc_15 = _loc_7 * _loc_3 + _loc_5 * _loc_16;
            }
            var _loc_9:* = __nMinAngularVelocity + Math.random() * (__nMaxAngularVelocity - __nMinAngularVelocity);
            _loc_11.init((__nMinEnergy + (__nMaxEnergy - __nMinEnergy) * Math.random()) * 1000, _loc_10 * 0.001, _loc_15 * 0.001, _loc_9, initialParticleRed, initialParticleGreen, initialParticleBlue, initialParticleAlpha, endParticleRed, endParticleGreen, endParticleBlue, endParticleAlpha);
            cNode.addChild(_loc_13);
            return;
        }// end function

        override public function dispose() : void
        {
            if (_cParticlePool != null)
            {
                _cParticlePool.dispose();
            }
            _cParticlePool = null;
            super.dispose();
            return;
        }// end function

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
        }// end function

        public function addField(param1:FField) : void
        {
            (iFieldsCount + 1);
            aFields.push(param1);
            return;
        }// end function

    }
}
