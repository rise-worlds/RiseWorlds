package com.flengine.components.renderables
{
   import flash.utils.Dictionary;
   import com.flengine.textures.FTexture;
   import com.flengine.context.materials.FCameraTexturedParticlesBatchMaterial;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.FTransform;
   import com.flengine.core.FNode;
   
   public class FEmitterGPU extends FRenderable
   {
      
      public function FEmitterGPU(param1:FNode) {
         super(param1);
      }
      
      private static var __aCached:Dictionary;
      
      fl2d  static var aTransformVector:Vector.<Number>;
      
      fl2d var aParticles:Vector.<Number>;
      
      fl2d var nCurrentTime:int = 0;
      
      fl2d var iMaxParticles:int;
      
      fl2d var iActiveParticles:int;
      
      public function get activeParticles() : int {
         return iActiveParticles;
      }
      
      public function set activeParticles(param1:int) : void {
         iActiveParticles = param1;
      }
      
      fl2d var cTexture:FTexture;
      
      fl2d var sHash:String;
      
      public function setTexture(param1:FTexture) : void {
         cTexture = param1;
      }
      
      public function get textureId() : String {
         if(cTexture)
         {
            return cTexture.id;
         }
         return "";
      }
      
      public function set textureId(param1:String) : void {
         cTexture = FTexture.getTextureById(param1);
      }
      
      public function initialize(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Number, param8:Number, param9:Number, param10:Number, param11:Boolean, param12:Number, param13:Number, param14:int, param15:int, param16:int, param17:int = 0) : void {
         var _loc21_:* = 0;
         var _loc20_:* = NaN;
         var _loc22_:* = NaN;
         var _loc19_:* = NaN;
         var _loc23_:* = NaN;
         var _loc18_:* = NaN;
         sHash = param1 + "|" + param2 + "|" + param3 + "|" + param4 + "|" + param5 + "|" + param6 + "|" + param7 + "|" + param8 + "|" + param9 + "|" + param10 + "|" + param11 + "|" + param12 + "|" + param13 + "|" + param14 + "|" + param15 + "|" + param16 + "|" + param17;
         iMaxParticles = param16;
         aParticles = __aCached[sHash];
         if(aParticles != null)
         {
            return;
         }
         aParticles = new Vector.<Number>();
         cRenderData = null;
         _loc21_ = 0;
         while(_loc21_ < iMaxParticles)
         {
            aParticles.push(Math.random() * param2 - param2 * 0.5,Math.random() * param3 - param3 * 0.5);
            _loc20_ = Math.random() * param4 - param4 * 0.5;
            _loc22_ = Math.sin(_loc20_);
            _loc19_ = Math.cos(_loc20_);
            _loc23_ = Math.random() * (param6 - param5) + param5;
            aParticles.push(_loc23_ * _loc19_,_loc23_ * _loc22_);
            if(!param11)
            {
               aParticles.push(Math.random() * (param8 - param7) + param7,Math.random() * (param10 - param9) + param9);
            }
            else
            {
               _loc18_ = Math.random() * (param8 - param7) + param7;
               aParticles.push(_loc18_,_loc18_);
            }
            aParticles.push(param12,param13);
            aParticles.push(_loc21_ * param1,Math.random() * (param15 - param14) + param14);
            _loc21_++;
         }
         __aCached[sHash] = aParticles;
         iActiveParticles = iMaxParticles;
         _cMaterial = FCameraTexturedParticlesBatchMaterial.getByHash(sHash);
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         nCurrentTime = nCurrentTime + param1;
      }
      
      protected var _cMaterial:FCameraTexturedParticlesBatchMaterial;
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(cTexture == null || iMaxParticles == 0 || _cMaterial == null)
         {
            return;
         }
         if(param1.checkAndSetupRender(_cMaterial,iBlendMode,cTexture.premultiplied,param3))
         {
            _cMaterial.bind(param1.cContext,param1.bReinitialize,param2,aParticles);
         }
         var _loc4_:FTransform = cNode.cTransform;
         aTransformVector[0] = _loc4_.nWorldX;
         aTransformVector[1] = _loc4_.nWorldY;
         aTransformVector[2] = cTexture.iWidth * _loc4_.nWorldScaleX;
         aTransformVector[3] = cTexture.iHeight * _loc4_.nWorldScaleY;
         aTransformVector[4] = cTexture.nUvX;
         aTransformVector[5] = cTexture.nUvY;
         aTransformVector[6] = cTexture.nUvScaleX;
         aTransformVector[7] = cTexture.nUvScaleY;
         aTransformVector[8] = _loc4_.nWorldRotation;
         aTransformVector[9] = nCurrentTime;
         aTransformVector[10] = 2;
         aTransformVector[11] = 1;
         aTransformVector[12] = 1;
         aTransformVector[13] = 1;
         aTransformVector[14] = 1;
         aTransformVector[15] = 0.1;
         _cMaterial.draw(aTransformVector,cTexture.cContextTexture.tTexture,cTexture.iFilteringType,iActiveParticles);
      }
   }
}
