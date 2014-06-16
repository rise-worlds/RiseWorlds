package com.flengine.components.particles
{
   import com.flengine.components.FComponent;
   import flash.display.BitmapData;
   import com.flengine.core.FNodePool;
   import com.flengine.core.FNode;
   import com.flengine.error.FError;
   import com.flengine.components.particles.fields.FField;
   
   public class FEmitter extends FComponent
   {
      
      public function FEmitter(param1:FNode) {
         _aPreviousParticlePools = [];
         _aParticles = new Vector.<FParticle>();
         aFields = new Vector.<FField>();
         super(param1);
      }
      
      override public function getPrototype() : XML {
         _xPrototype = super.getPrototype();
         if(_xParticlePrototype != null)
         {
            _xPrototype.particlePrototype = <particlePrototype/>
				;
            _xPrototype.particlePrototype.appendChild(_xParticlePrototype);
         }
         return _xPrototype;
      }
      
      override public function bindFromPrototype(param1:XML) : void {
         super.bindFromPrototype(param1);
         if(param1.particlesPrototype != null)
         {
            setParticlePrototype(param1.particlePrototype.node[0]);
         }
      }
      
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
      
      public function get initialColor() : int {
         return initialRed * 16711680 + initialGreen * 65280 + initialBlue * 255;
      }
      
      public function set initialColor(param1:int) : void {
         initialRed = (param1 >> 16 & 255) / 255;
         initialGreen = (param1 >> 8 & 255) / 255;
         initialBlue = (param1 & 255) / 255;
      }
      
      public var endRed:Number = 1;
      
      public var endRedVariance:Number = 0;
      
      public var endGreen:Number = 1;
      
      public var endGreenVariance:Number = 0;
      
      public var endBlue:Number = 1;
      
      public var endBlueVariance:Number = 0;
      
      public var endAlpha:Number = 1;
      
      public var endAlphaVariance:Number = 0;
      
      public function get endColor() : int {
         return endRed * 16711680 + endGreen * 65280 + endBlue * 255;
      }
      
      public function set endColor(param1:int) : void {
         endRed = (param1 >> 16 & 255) / 255;
         endGreen = (param1 >> 8 & 255) / 255;
         endBlue = (param1 & 255) / 255;
      }
      
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
      
      public function invalidateBitmapData() : void {
         var _loc3_:* = 0;
         __aOffsets = new Vector.<int>();
         var _loc1_:int = bitmapData.width;
         var _loc2_:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc2_[_loc3_] >> 24 & 255) > 0)
            {
               __aOffsets.push(_loc3_ % _loc1_,_loc3_ / _loc1_);
            }
            _loc3_++;
         }
      }
      
      private var _aPreviousParticlePools:Array;
      
      protected var _xParticlePrototype:XML;
      
      public function setParticlePrototype(param1:XML) : void {
         _xParticlePrototype = param1;
      }
      
      protected var _nAccumulatedTime:Number = 0;
      
      protected var _nAccumulatedEmission:Number = 0;
      
      protected var _aParticles:Vector.<FParticle>;
      
      protected var _iActiveParticles:int = 0;
      
      protected var _cParticlePool:FNodePool;
      
      public function get particlesCachedCount() : int {
         if(_cParticlePool != null)
         {
            return _cParticlePool.cachedCount;
         }
         return 0;
      }
      
      protected function setInitialParticlePosition(param1:FNode) : void {
         if(useWorldSpace)
         {
            param1.cTransform.x = cNode.cTransform.nWorldX + Math.random() * dispersionXVariance - dispersionXVariance * 0.5;
            param1.cTransform.y = cNode.cTransform.nWorldY + Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
         }
         else
         {
            param1.cTransform.x = Math.random() * dispersionXVariance - dispersionXVariance * 0.5;
            param1.cTransform.y = Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
         }
      }
      
      protected function get initialParticleY() : Number {
         return cNode.cTransform.nWorldY + Math.random() * dispersionYVariance - dispersionYVariance * 0.5;
      }
      
      override public function set active(param1:Boolean) : void {
         .super.active = param1;
         if(_cParticlePool)
         {
            _cParticlePool.deactivate();
         }
      }
      
      public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void {
         _nAccumulatedTime = 0;
         _nAccumulatedEmission = 0;
         if(_cParticlePool)
         {
            if(param3)
            {
               _cParticlePool.dispose();
            }
            else
            {
               _aPreviousParticlePools.push(
                  {
                     "pool":_cParticlePool,
                     "time":(energy + energyVariance) * 1000
                  });
            }
         }
         _cParticlePool = new FNodePool(_xParticlePrototype,param1,param2);
      }
      
      public function forceBurst() : void {
         var _loc2_:* = 0;
         if(!_cParticlePool)
         {
            return;
         }
         var _loc1_:int = emission + emissionVariance * Math.random();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            activateParticle();
            _loc2_++;
         }
         emit = false;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         var _loc4_:* = NaN;
         var _loc5_:* = 0;
         if(_aPreviousParticlePools.length > 0)
         {
            _aPreviousParticlePools[0].time = _aPreviousParticlePools[0].time - param1;
            if(_aPreviousParticlePools[0].time <= 0)
            {
               _aPreviousParticlePools[0].pool.dispose();
               _aPreviousParticlePools.shift();
            }
         }
         if(!emit || _cParticlePool == null)
         {
            return;
         }
         if(burst)
         {
            forceBurst();
         }
         else
         {
            _nAccumulatedTime = _nAccumulatedTime + param1 * 0.001;
            _loc4_ = _nAccumulatedTime % (emissionTime + emissionDelay);
            if(_loc4_ <= emissionTime)
            {
               _loc5_ = emission;
               if(emissionVariance > 0)
               {
                  _loc5_ = _loc5_ + emissionVariance * Math.random();
               }
               _nAccumulatedEmission = _nAccumulatedEmission + _loc5_ * param1 * 0.001;
               while(_nAccumulatedEmission > 0)
               {
                  activateParticle();
                  _nAccumulatedEmission = _nAccumulatedEmission - 1;
               }
            }
         }
      }
      
      private function activateParticle() : void {
         var _loc3_:* = 0;
         var _loc2_:FNode = _cParticlePool.getNext();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc1_:FParticle = _loc2_.getComponent(FParticle) as FParticle;
         if(_loc1_ == null)
         {
            throw new FError("FError: Cannot instantiate abstract class.");
         }
         else
         {
            _loc1_.cEmitter = this;
            _loc2_.cTransform.useWorldSpace = useWorldSpace;
            if(useWorldSpace)
            {
               if(bitmapData)
               {
                  _loc3_ = ((__aOffsets.length - 1) / 2 * Math.random()) * 2;
                  _loc2_.cTransform.x = cNode.cTransform.nWorldX - bitmapData.width / 2 + __aOffsets[_loc3_];
                  _loc2_.cTransform.y = cNode.cTransform.nWorldY - bitmapData.height / 2 + __aOffsets[_loc3_ + 1];
               }
               else
               {
                  setInitialParticlePosition(_loc2_);
               }
            }
            else
            {
               setInitialParticlePosition(_loc2_);
            }
            _loc4_ = initialScale + initialScaleVariance * Math.random();
            _loc2_.transform.scaleY = _loc4_;
            _loc2_.cTransform.scaleX = _loc4_;
            _loc2_.cTransform.rotation = initialAngle + Math.random() * initialAngleVariance;
            _loc1_.init();
            cNode.addChild(_loc2_);
            return;
         }
      }
      
      override public function dispose() : void {
         if(_cParticlePool != null)
         {
            _cParticlePool.dispose();
         }
         _cParticlePool = null;
         super.dispose();
      }
      
      public function clear(param1:Boolean = false) : void {
         if(_cParticlePool == null)
         {
            return;
         }
         if(param1)
         {
            _cParticlePool.dispose();
         }
         else
         {
            _cParticlePool.deactivate();
         }
      }
      
      fl2d var iFieldsCount:int = 0;
      
      fl2d var aFields:Vector.<FField>;
      
      public function addField(param1:FField) : void {
         if(param1 == null)
         {
            throw new Error("Field cannot be null.");
         }
         else
         {
            iFieldsCount = iFieldsCount + 1;
            aFields.push(param1);
            return;
         }
      }
   }
}
