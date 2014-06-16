package com.flengine.components.particles
{
   import com.flengine.components.renderables.FRenderable;
   import com.flengine.textures.FTexture;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.particles.fields.FField;
   import com.flengine.core.FNode;
   
   public class FSimpleEmitter extends FRenderable
   {
      
      public function FSimpleEmitter(param1:FNode) {
         aFields = new Vector.<FField>();
         super(param1);
      }
      
      override public function bindFromPrototype(param1:XML) : void {
         super.bindFromPrototype(param1);
      }
      
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
      
      public function get initialColor() : int {
         var _loc1_:uint = initialRed * 255 << 16;
         var _loc3_:uint = initialGreen * 255 << 8;
         var _loc2_:uint = initialBlue * 255;
         return _loc1_ + _loc3_ + _loc2_;
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
         var _loc1_:uint = endRed * 255 << 16;
         var _loc3_:uint = endGreen * 255 << 8;
         var _loc2_:uint = endBlue * 255;
         return _loc1_ + _loc3_ + _loc2_;
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
      
      public var special:Boolean = false;
      
      protected var _nAccumulatedTime:Number = 0;
      
      protected var _nAccumulatedEmission:Number = 0;
      
      protected var _cFirstParticle:FSimpleParticle;
      
      protected var _cLastParticle:FSimpleParticle;
      
      protected var _iActiveParticles:int = 0;
      
      private var __nLastUpdateTime:Number;
      
      private var __cTexture:FTexture;
      
      public function get textureId() : String {
         return __cTexture?__cTexture.id:"";
      }
      
      public function set textureId(param1:String) : void {
         __cTexture = FTexture.getTextureById(param1);
      }
      
      public function setTexture(param1:FTexture) : void {
         __cTexture = param1;
      }
      
      protected function setInitialParticlePosition(param1:FSimpleParticle) : void {
         var _loc2_:* = NaN;
         param1.nX = cNode.cTransform.nWorldX;
         if(dispersionXVariance > 0)
         {
            param1.nX = param1.nX + (dispersionXVariance * Math.random() - dispersionXVariance * 0.5);
         }
         param1.nY = cNode.cTransform.nWorldY;
         if(dispersionYVariance > 0)
         {
            param1.nY = param1.nY + (dispersionYVariance * Math.random() - dispersionYVariance * 0.5);
         }
         param1.nRotation = initialAngle;
         if(initialAngleVariance > 0)
         {
            param1.nRotation = param1.nRotation + initialAngleVariance * Math.random();
         }
         var _loc3_:* = initialScale;
         param1.nScaleY = _loc3_;
         param1.nScaleX = _loc3_;
         if(initialScaleVariance > 0)
         {
            _loc2_ = initialScaleVariance * Math.random();
            param1.nScaleX = param1.nScaleX + _loc2_;
            param1.nScaleY = param1.nScaleY + _loc2_;
         }
      }
      
      public function init(param1:int = 0, param2:int = 0, param3:Boolean = true) : void {
         _nAccumulatedTime = 0;
         _nAccumulatedEmission = 0;
      }
      
      private function createParticle() : FSimpleParticle {
         var _loc1_:FSimpleParticle = FSimpleParticle.get();
         if(_cFirstParticle)
         {
            _loc1_.cNext = _cFirstParticle;
            _cFirstParticle.cPrevious = _loc1_;
            _cFirstParticle = _loc1_;
         }
         else
         {
            _cFirstParticle = _loc1_;
            _cLastParticle = _loc1_;
         }
         return _loc1_;
      }
      
      public function forceBurst() : void {
         var _loc1_:* = 0;
         var _loc2_:int = emission + emissionVariance * Math.random();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            activateParticle();
            _loc1_++;
         }
         emit = false;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         var _loc5_:* = NaN;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = null;
         __nLastUpdateTime = param1;
         if(emit)
         {
            if(burst)
            {
               forceBurst();
            }
            else
            {
               _nAccumulatedTime = _nAccumulatedTime + param1 * 0.001;
               _loc5_ = _nAccumulatedTime % (emissionTime + emissionDelay);
               if(_loc5_ <= emissionTime)
               {
                  _loc6_ = emission;
                  if(emissionVariance > 0)
                  {
                     _loc6_ = _loc6_ + emissionVariance * Math.random();
                  }
                  _nAccumulatedEmission = _nAccumulatedEmission + _loc6_ * param1 * 0.001;
                  while(_nAccumulatedEmission > 0)
                  {
                     activateParticle();
                     _nAccumulatedEmission = _nAccumulatedEmission - 1;
                  }
               }
            }
         }
         _loc4_ = _cFirstParticle;
         while(_loc4_)
         {
            _loc7_ = _loc4_.cNext;
            _loc4_.update(this,__nLastUpdateTime);
            _loc4_ = _loc7_;
         }
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc5_:* = NaN;
         var _loc4_:* = NaN;
         if(__cTexture == null)
         {
            return;
         }
         var _loc8_:* = 0;
         _loc6_ = _cFirstParticle;
         while(_loc6_)
         {
            _loc7_ = _loc6_.cNext;
            _loc5_ = cNode.cTransform.nWorldX + (_loc6_.nX - cNode.cTransform.nWorldX) * 1;
            _loc4_ = cNode.cTransform.nWorldY + (_loc6_.nY - cNode.cTransform.nWorldY) * 1;
            param1.draw(__cTexture,_loc5_,_loc4_,_loc6_.nScaleX * cNode.cTransform.nWorldScaleX,_loc6_.nScaleY * cNode.cTransform.nWorldScaleY,_loc6_.nRotation,_loc6_.nRed,_loc6_.nGreen,_loc6_.nBlue,_loc6_.nAlpha,iBlendMode,param3);
            _loc6_ = _loc7_;
         }
      }
      
      private function activateParticle() : void {
         var _loc1_:FSimpleParticle = createParticle();
         setInitialParticlePosition(_loc1_);
         _loc1_.init(this);
      }
      
      fl2d function deactivateParticle(param1:FSimpleParticle) : void {
         if(param1 == _cLastParticle)
         {
            _cLastParticle = _cLastParticle.cPrevious;
         }
         if(param1 == _cFirstParticle)
         {
            _cFirstParticle = _cFirstParticle.cNext;
         }
         param1.dispose();
      }
      
      override public function dispose() : void {
         super.dispose();
      }
      
      public function clear(param1:Boolean = false) : void {
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
