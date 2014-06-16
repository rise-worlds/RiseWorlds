package com.flengine.components.particles
{
   import com.flengine.components.FComponent;
   import com.flengine.core.FNodePool;
   import com.flengine.components.particles.fields.FField;
   import com.flengine.core.FNode;
   import com.flengine.error.FError;
   
   public class FEmitterOld extends FComponent
   {
      
      public function FEmitterOld(param1:FNode) {
         _aPreviousParticlePools = [];
         _aParticles = new Vector.<FParticleOld>();
         aFields = new Vector.<FField>();
         super(param1);
      }
      
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
      
      fl2d var iFieldsCount:int = 0;
      
      fl2d var aFields:Vector.<FField>;
      
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
      
      public function set minScaleX(param1:Number) : void {
         __nMinScaleX = param1;
         if(__nMaxScaleX < __nMinScaleX)
         {
            __nMaxScaleX = __nMinScaleX;
         }
      }
      
      public function get minScaleX() : Number {
         return __nMinScaleX;
      }
      
      public function set maxScaleX(param1:Number) : void {
         __nMaxScaleX = param1;
         if(__nMinScaleX > __nMaxScaleX)
         {
            __nMinScaleX = __nMaxScaleX;
         }
      }
      
      public function get maxScaleX() : Number {
         return __nMaxScaleX;
      }
      
      public function set minScaleY(param1:Number) : void {
         __nMinScaleY = param1;
         if(__nMaxScaleY < __nMinScaleY)
         {
            __nMaxScaleY = __nMinScaleY;
         }
      }
      
      public function get minScaleY() : Number {
         return __nMinScaleY;
      }
      
      public function set maxScaleY(param1:Number) : void {
         __nMaxScaleY = param1;
         if(__nMinScaleY > __nMaxScaleY)
         {
            __nMinScaleY = __nMaxScaleY;
         }
      }
      
      public function get maxScaleY() : Number {
         return __nMaxScaleY;
      }
      
      public function set minEnergy(param1:Number) : void {
         __nMinEnergy = param1;
         if(__nMaxEnergy < __nMinEnergy)
         {
            __nMaxEnergy = __nMinEnergy;
         }
      }
      
      public function get minEnergy() : Number {
         return __nMinEnergy;
      }
      
      public function set maxEnergy(param1:Number) : void {
         __nMaxEnergy = param1;
         if(__nMinEnergy > __nMaxEnergy)
         {
            __nMinEnergy = __nMaxEnergy;
         }
      }
      
      public function get maxEnergy() : Number {
         return __nMaxEnergy;
      }
      
      public function set minEmission(param1:int) : void {
         __iMinEmission = param1;
         if(__iMaxEmission < __iMinEmission)
         {
            __iMaxEmission = __iMinEmission;
         }
      }
      
      public function get minEmission() : int {
         return __iMinEmission;
      }
      
      public function set maxEmission(param1:int) : void {
         __iMaxEmission = param1;
         if(__iMinEmission > __iMaxEmission)
         {
            __iMinEmission = __iMaxEmission;
         }
      }
      
      public function get maxEmission() : int {
         return __iMaxEmission;
      }
      
      public function set minWorldVelocityX(param1:Number) : void {
         __nMinWorldVelocityX = param1;
         if(__nMaxWorldVelocityX < __nMinWorldVelocityX)
         {
            __nMaxWorldVelocityX = __nMinWorldVelocityX;
         }
      }
      
      public function get minWorldVelocityX() : Number {
         return __nMinWorldVelocityX;
      }
      
      public function set maxWorldVelocityX(param1:Number) : void {
         __nMaxWorldVelocityX = param1;
         if(__nMinWorldVelocityX > __nMaxWorldVelocityX)
         {
            __nMinWorldVelocityX = __nMaxWorldVelocityX;
         }
      }
      
      public function get maxWorldVelocityX() : Number {
         return __nMaxWorldVelocityX;
      }
      
      public function set minWorldVelocityY(param1:Number) : void {
         __nMinWorldVelocityY = param1;
         if(__nMaxWorldVelocityY < __nMinWorldVelocityY)
         {
            __nMaxWorldVelocityY = __nMinWorldVelocityY;
         }
      }
      
      public function get minWorldVelocityY() : Number {
         return __nMinWorldVelocityY;
      }
      
      public function set maxWorldVelocityY(param1:Number) : void {
         __nMaxWorldVelocityY = param1;
         if(__nMinWorldVelocityY > __nMaxWorldVelocityY)
         {
            __nMinWorldVelocityY = __nMaxWorldVelocityY;
         }
      }
      
      public function get maxWorldVelocityY() : Number {
         return __nMaxWorldVelocityY;
      }
      
      public function set minLocalVelocityX(param1:Number) : void {
         __nMinLocalVelocityX = param1;
         if(__nMaxLocalVelocityX < __nMinLocalVelocityX)
         {
            __nMaxLocalVelocityX = __nMinLocalVelocityX;
         }
      }
      
      public function get minLocalVelocityX() : Number {
         return __nMinLocalVelocityX;
      }
      
      public function set maxLocalVelocityX(param1:Number) : void {
         __nMaxLocalVelocityX = param1;
         if(__nMinLocalVelocityX > __nMaxLocalVelocityX)
         {
            __nMinLocalVelocityX = __nMaxLocalVelocityX;
         }
      }
      
      public function get maxLocalVelocityX() : Number {
         return __nMaxLocalVelocityX;
      }
      
      public function set minLocalVelocityY(param1:Number) : void {
         __nMinLocalVelocityY = param1;
         if(__nMaxLocalVelocityY < __nMinLocalVelocityY)
         {
            __nMaxLocalVelocityY = __nMinLocalVelocityY;
         }
      }
      
      public function get minLocalVelocityY() : Number {
         return __nMinLocalVelocityY;
      }
      
      public function set maxLocalVelocityY(param1:Number) : void {
         __nMaxLocalVelocityY = param1;
         if(__nMinLocalVelocityY > __nMaxLocalVelocityY)
         {
            __nMinLocalVelocityY = __nMaxLocalVelocityY;
         }
      }
      
      public function get maxLocalVelocityY() : Number {
         return __nMaxLocalVelocityY;
      }
      
      public function set minAngularVelocity(param1:Number) : void {
         __nMinAngularVelocity = param1;
         if(__nMaxAngularVelocity < __nMinLocalVelocityY)
         {
            __nMaxAngularVelocity = __nMinAngularVelocity;
         }
      }
      
      public function get minAngularVelocity() : Number {
         return __nMinAngularVelocity;
      }
      
      public function set maxAngularVelocity(param1:Number) : void {
         __nMaxAngularVelocity = param1;
         if(__nMinAngularVelocity > __nMaxAngularVelocity)
         {
            __nMinAngularVelocity = __nMaxAngularVelocity;
         }
      }
      
      public function get maxAngularVelocity() : Number {
         return __nMaxAngularVelocity;
      }
      
      public function setParticlePrototype(param1:XML) : void {
         _xParticlePrototype = param1;
      }
      
      public function get particlesCachedCount() : int {
         return _cParticlePool.cachedCount;
      }
      
      override public function set active(param1:Boolean) : void {
         .super.active = param1;
         if(_cParticlePool)
         {
            _cParticlePool.deactivate();
         }
      }
      
      public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void {
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
                     "time":__nMaxEnergy * 1000
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
         var _loc1_:int = minEmission + (maxEmission - minEmission) * Math.random();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            activateParticle();
            emit = false;
            _loc2_++;
         }
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         var _loc4_:* = 0;
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
            _loc4_ = minEmission + (maxEmission - minEmission) * Math.random();
            _nAccumulatedEmission = _nAccumulatedEmission + _loc4_ * param1 * 0.001;
            while(_nAccumulatedEmission > 0)
            {
               activateParticle();
               _nAccumulatedEmission = _nAccumulatedEmission - 1;
            }
         }
      }
      
      private function activateParticle() : void {
         var _loc10_:* = NaN;
         var _loc15_:* = NaN;
         var _loc4_:* = NaN;
         var _loc13_:FNode = _cParticlePool.getNext();
         if(_loc13_ == null)
         {
            return;
         }
         var _loc11_:FParticleOld = _loc13_.getComponent(FParticleOld) as FParticleOld;
         if(_loc11_ == null)
         {
            throw new FError("FError: Cannot instantiate abstract class.");
         }
         else
         {
            _loc1_ = __nMinScaleX + (__nMaxScaleX - __nMinScaleX) * Math.random();
            _loc2_ = uniformScale?_loc1_:__nMinScaleY + (__nMaxScaleY - __nMinScaleY) * Math.random();
            _loc13_.transform.useWorldSpace = useWorldSpace;
            if(useWorldSpace)
            {
               _loc13_.transform.x = cNode.transform.nWorldX + Math.random() * initialDispersionX - initialDispersionX * 0.5;
               _loc13_.transform.y = cNode.transform.nWorldY + Math.random() * initialDispersionY - initialDispersionY * 0.5;
            }
            else
            {
               _loc13_.transform.x = Math.random() * initialDispersionX - initialDispersionX * 0.5;
               _loc13_.transform.y = Math.random() * initialDispersionY - initialDispersionY * 0.5;
            }
            _loc13_.transform.scaleX = _loc1_;
            _loc13_.transform.scaleY = _loc2_;
            _loc13_.transform.rotation = initialAngle > 0?initialAngle * Math.random():0;
            _loc16_ = Math.sin(cNode.transform.nWorldRotation);
            _loc3_ = Math.cos(cNode.transform.nWorldRotation);
            _loc6_ = __nMinLocalVelocityX + Math.random() * (__nMaxLocalVelocityX - __nMinLocalVelocityX);
            _loc8_ = __nMinLocalVelocityY + Math.random() * (__nMaxLocalVelocityY - __nMinLocalVelocityY);
            _loc14_ = __nMinWorldVelocityX + Math.random() * (__nMaxWorldVelocityX - __nMinWorldVelocityX);
            _loc12_ = __nMinWorldVelocityY + Math.random() * (__nMaxWorldVelocityY - __nMinWorldVelocityY);
            _loc10_ = _loc14_ + (_loc6_ * _loc3_ - _loc8_ * _loc16_);
            _loc5_ = _loc10_;
            _loc15_ = _loc12_ + (_loc8_ * _loc3_ + _loc6_ * _loc16_);
            _loc7_ = _loc15_;
            if(angle != 0)
            {
               _loc4_ = Math.random() * angle - angle / 2;
               _loc16_ = Math.sin(_loc4_);
               _loc3_ = Math.cos(_loc4_);
               _loc10_ = _loc5_ * _loc3_ - _loc7_ * _loc16_;
               _loc15_ = _loc7_ * _loc3_ + _loc5_ * _loc16_;
            }
            _loc9_ = __nMinAngularVelocity + Math.random() * (__nMaxAngularVelocity - __nMinAngularVelocity);
            _loc11_.init((__nMinEnergy + (__nMaxEnergy - __nMinEnergy) * Math.random()) * 1000,_loc10_ * 0.001,_loc15_ * 0.001,_loc9_,initialParticleRed,initialParticleGreen,initialParticleBlue,initialParticleAlpha,endParticleRed,endParticleGreen,endParticleBlue,endParticleAlpha);
            cNode.addChild(_loc13_);
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
      
      public function addField(param1:FField) : void {
         iFieldsCount = iFieldsCount + 1;
         aFields.push(param1);
      }
   }
}
