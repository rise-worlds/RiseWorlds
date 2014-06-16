package com.flengine.components.light
{
   import com.flengine.components.renderables.FRenderable;
   import com.flengine.textures.FTexture;
   import com.flengine.context.filters.FBlurPassFilter;
   import com.flengine.core.FNode;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FlEngine;
   import flash.display3D.Context3D;
   import com.flengine.components.renderables.FSprite;
   import com.flengine.components.renderables.FTexturedQuad;
   import com.flengine.components.renderables.FMovieClip;
   import flash.display3D.Context3DClearMask;
   import com.flengine.textures.factories.FTextureFactory;
   
   public class FLightMap extends FRenderable
   {
      
      public function FLightMap(param1:FNode) {
         _aLights = new Vector.<FLight>();
         _aSpotVertices = new Vector.<Number>(6);
         super(param1);
         __iCount = __iCount + 1;
         _cLightMap = FTextureFactory.createRenderTexture("lightMap_gen" + __iCount,node.core.config.viewRect.width + pad,node.core.config.viewRect.height + pad,false);
         _cLightMap.filteringType = 1;
         _cLightMapBlurred = FTextureFactory.createRenderTexture("lightMapBlurred_gen" + __iCount,node.core.config.viewRect.width + pad,node.core.config.viewRect.height + pad,false);
         _cLightMapBlurred.filteringType = 1;
         _cBlurV = new FBlurPassFilter(4,0);
         _cBlurH = new FBlurPassFilter(4,1);
      }
      
      private static var __iCount:int = 0;
      
      protected var _cLightMap:FTexture;
      
      protected var _cLightMapBlurred:FTexture;
      
      protected var _nLightMapScale:Number = 1;
      
      protected var _cBlurV:FBlurPassFilter;
      
      protected var _cBlurH:FBlurPassFilter;
      
      public var ambientRed:Number = 0;
      
      public var ambientGreen:Number = 0;
      
      public var ambientBlue:Number = 0;
      
      public var ambientAlpha:Number = 1;
      
      public var softShadows:Boolean = false;
      
      public var stencilOverdraw:Boolean = false;
      
      public var pad:int = 20;
      
      protected var _aLights:Vector.<FLight>;
      
      protected var _cCasterContainer:FNode;
      
      protected var _aSpotVertices:Vector.<Number>;
      
      public function get lights() : Vector.<FLight> {
         return _aLights;
      }
      
      public function set casterContainer(param1:FNode) : void {
         _cCasterContainer = param1;
      }
      
      public function addLight(param1:FLight) : void {
         _aLights.push(param1);
      }
      
      public function removeLight(param1:FLight) : void {
         _aLights.splice(_aLights.indexOf(param1),1);
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         var _loc7_:* = 0;
         var _loc6_:* = null;
         param1.setRenderTarget(_cLightMap,null,ambientRed,ambientGreen,ambientBlue,ambientAlpha);
         var _loc5_:FCamera = node.core.defaultCamera;
         _loc5_.aCameraVector[4] = param2.cNode.cTransform.nWorldX;
         _loc5_.aCameraVector[5] = param2.cNode.cTransform.nWorldY;
         var _loc4_:int = _aLights.length;
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc6_ = _aLights[_loc7_];
            if(!(_loc6_.active == false || !_loc6_.node.isOnStage()))
            {
               if(_loc6_ is FSpotLight)
               {
                  drawSpotLight(param1,_loc6_ as FSpotLight);
               }
               else
               {
                  drawOmniLight(param1,_loc6_,param2.zoom);
               }
            }
            _loc7_++;
         }
         if(softShadows)
         {
            param1.setRenderTarget(_cLightMapBlurred,null,ambientRed,ambientGreen,ambientBlue,ambientAlpha);
            param1.setCamera(FlEngine.getInstance().defaultCamera);
            param1.draw(_cLightMap,_nLightMapScale * _cLightMap.width * 0.5,_nLightMapScale * _cLightMap.height * 0.5,1,1,0,1,1,1,1,1,null,_cBlurV);
            param1.setRenderTarget(null);
            param1.setCamera(param2);
            param1.draw(_cLightMapBlurred,param2.cNode.cTransform.nWorldX,param2.cNode.cTransform.nWorldY,1 / _nLightMapScale,1 / _nLightMapScale,0,1,1,1,1,3,null,_cBlurH);
         }
         else
         {
            param1.setRenderTarget(null);
            param1.setCamera(param2);
            param1.draw(_cLightMap,param2.cNode.cTransform.nWorldX,param2.cNode.cTransform.nWorldY,1 / (param2.zoom * _nLightMapScale),1 / (param2.zoom * _nLightMapScale),0,1,1,1,1,3);
         }
      }
      
      protected function drawOmniLight(param1:FContext, param2:FLight, param3:Number) : void {
         var _loc10_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc11_:Number = param2.cNode.cTransform.nWorldX;
         var _loc9_:Number = param2.cNode.cTransform.nWorldY;
         var _loc8_:Context3D = param1.context;
         if(param2.shadows)
         {
            param1.push();
            _loc8_.setCulling("front");
            _loc8_.setStencilReferenceValue(1);
            _loc8_.setStencilActions("frontAndBack","always","set");
            _loc8_.setColorMask(false,false,false,false);
            _loc4_ = _cCasterContainer.firstChild;
            while(_loc4_)
            {
               _loc5_ = _loc4_.getComponent(FSprite) as FTexturedQuad;
               if(_loc5_ == null)
               {
               }
               if(_loc5_ != null)
               {
                  _loc6_ = Math.abs(_loc11_ - _loc4_.cTransform.x);
                  _loc7_ = Math.abs(_loc9_ - _loc4_.cTransform.y);
                  if(_loc6_ * _loc6_ + _loc7_ * _loc7_ < param2.iRadiusSquared)
                  {
                     param1.drawShadow(_loc4_.cTransform.nWorldX * _nLightMapScale,_loc4_.cTransform.nWorldY * _nLightMapScale,_loc5_.getTexture().width * _nLightMapScale * _loc4_.cTransform.nWorldScaleX,_loc5_.getTexture().height * _nLightMapScale * _loc4_.cTransform.nWorldScaleY,_loc4_.transform.rotation,_loc11_ * _nLightMapScale,_loc9_ * _nLightMapScale,_loc4_.userData.shadowDepth);
                  }
               }
               _loc4_ = _loc4_.next;
            }
            param1.push();
            if(stencilOverdraw)
            {
               _loc8_.setCulling("back");
               _loc8_.setStencilReferenceValue(0);
               _loc4_ = _cCasterContainer.firstChild;
               while(_loc4_)
               {
                  _loc5_ = _loc4_.getComponent(FSprite) as FTexturedQuad;
                  if(_loc5_ == null)
                  {
                  }
                  if(_loc5_ != null)
                  {
                     _loc6_ = Math.abs(_loc11_ - _loc4_.transform.x);
                     _loc7_ = Math.abs(_loc9_ - _loc4_.transform.y);
                     if(_loc6_ * _loc6_ + _loc7_ * _loc7_ < param2.iRadiusSquared)
                     {
                        param1.drawColorQuad(_loc4_.cTransform.nWorldX * _nLightMapScale,_loc4_.cTransform.nWorldY * _nLightMapScale,_loc5_.getTexture().width * _nLightMapScale,_loc5_.getTexture().height * _nLightMapScale,_loc4_.transform.rotation);
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               param1.push();
            }
            _loc8_.setCulling("back");
            _loc8_.setStencilReferenceValue(0);
            _loc8_.setColorMask(true,true,true,true);
            _loc8_.setStencilActions("frontAndBack","equal","keep");
         }
         param1.draw(param2.getTexture(),_loc11_ * _nLightMapScale,_loc9_ * _nLightMapScale,_nLightMapScale * param2.cNode.cTransform.nWorldScaleX,_nLightMapScale * param2.cNode.cTransform.nWorldScaleY,param2.cNode.cTransform.nWorldRotation,param2.cNode.cTransform.nWorldRed,param2.cNode.cTransform.nWorldGreen,param2.cNode.cTransform.nWorldBlue,param2.cNode.cTransform.nWorldAlpha,2);
         if(param2.shadows)
         {
            param1.push();
            _loc8_.clear(0,0,0,1,1,0,Context3DClearMask.STENCIL);
         }
      }
      
      protected function drawSpotLight(param1:FContext, param2:FSpotLight) : void {
         var _loc7_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc11_:* = NaN;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc13_:Number = param2.cNode.cTransform.nWorldX;
         var _loc12_:Number = param2.cNode.cTransform.nWorldY;
         var _loc6_:Context3D = param1.context;
         _loc6_.clear(0,0,0,1,1,1,Context3DClearMask.STENCIL);
         _loc6_.setCulling("front");
         _loc6_.setStencilReferenceValue(1);
         _loc6_.setStencilActions("frontAndBack","always","set");
         _loc6_.setColorMask(false,false,false,false);
         var _loc8_:* = 0;
         var _loc3_:Number = param2.dispersion;
         _aSpotVertices[0] = 0;
         _aSpotVertices[1] = 0;
         _aSpotVertices[2] = Math.cos(_loc8_ + _loc3_) * 1000;
         _aSpotVertices[3] = Math.sin(_loc8_ + _loc3_) * 1000;
         _aSpotVertices[4] = Math.cos(_loc8_ - _loc3_) * 1000;
         _aSpotVertices[5] = Math.sin(_loc8_ - _loc3_) * 1000;
         param1.drawColorPoly(_aSpotVertices,_loc13_ * _nLightMapScale,_loc12_ * _nLightMapScale,1,1,param2.cNode.cTransform.nWorldRotation - 1.570796326794895);
         param1.push();
         _loc6_.setStencilReferenceValue(0);
         _loc9_ = _cCasterContainer.firstChild;
         while(_loc9_)
         {
            _loc10_ = _loc9_.getComponent(FSprite) as FTexturedQuad;
            if(_loc10_ == null)
            {
            }
            if(_loc10_ != null)
            {
               _loc7_ = 10.0;
               _loc4_ = Math.abs(_loc13_ - _loc9_.transform.x);
               _loc5_ = Math.abs(_loc12_ - _loc9_.transform.y);
               _loc11_ = _loc9_.userData.shadowPad;
               if(_loc4_ * _loc4_ + _loc5_ * _loc5_ < param2.iRadiusSquared)
               {
                  param1.drawShadow(_loc9_.transform.x * _nLightMapScale,_loc9_.transform.y * _nLightMapScale,_loc11_ + _loc10_.getTexture().width * _nLightMapScale * _loc9_.cTransform.nWorldScaleX,_loc11_ + _loc10_.getTexture().height * _nLightMapScale * _loc9_.cTransform.nWorldScaleY,_loc9_.transform.rotation,_loc13_ * _nLightMapScale,_loc12_ * _nLightMapScale,_loc9_.userData.shadowDepth);
               }
            }
            _loc9_ = _loc9_.next;
         }
         param1.push();
         if(stencilOverdraw)
         {
            _loc6_.setCulling("back");
            _loc6_.setStencilReferenceValue(1);
            _loc9_ = _cCasterContainer.firstChild;
            while(_loc9_)
            {
               _loc10_ = _loc9_.getComponent(FSprite) as FTexturedQuad;
               if(_loc10_ == null)
               {
               }
               if(_loc10_ != null)
               {
                  _loc4_ = Math.abs(_loc13_ - _loc9_.transform.x);
                  _loc5_ = Math.abs(_loc12_ - _loc9_.transform.y);
                  if(_loc4_ * _loc4_ + _loc5_ * _loc5_ < param2.iRadiusSquared)
                  {
                     param1.drawColorQuad(_loc9_.transform.x * _nLightMapScale,_loc9_.transform.y * _nLightMapScale,_loc10_.getTexture().width * _nLightMapScale,_loc10_.getTexture().height * _nLightMapScale,_loc9_.transform.rotation);
                  }
               }
               _loc9_ = _loc9_.next;
            }
            param1.push();
         }
         _loc6_.setCulling("back");
         _loc6_.setColorMask(true,true,true,true);
         _loc6_.setStencilReferenceValue(1);
         _loc6_.setStencilActions("frontAndBack","equal","keep");
         param1.draw(param2.getTexture(),_loc13_ * _nLightMapScale,_loc12_ * _nLightMapScale,_nLightMapScale * param2.cNode.cTransform.nWorldScaleX,_nLightMapScale * param2.cNode.cTransform.nWorldScaleY,param2.cNode.cTransform.nWorldRotation,param2.cNode.cTransform.nWorldRed,param2.cNode.cTransform.nWorldGreen,param2.cNode.cTransform.nWorldBlue,param2.cNode.cTransform.nWorldAlpha,2);
         param1.push();
         _loc6_.setStencilReferenceValue(0);
         _loc6_.clear(0,0,0,1,1,0,Context3DClearMask.STENCIL);
      }
   }
}
