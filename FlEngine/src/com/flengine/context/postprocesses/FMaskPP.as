package com.flengine.context.postprocesses
{
   import com.flengine.core.FNode;
   import com.flengine.context.filters.FMaskPassFilter;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FlEngine;
   
   public class FMaskPP extends FPostProcess
   {
      
      public function FMaskPP() {
         super(2);
         _cMaskFilter = new FMaskPassFilter(_aPassTextures[1]);
      }
      
      protected var _cMask:FNode;
      
      public function get mask() : FNode {
         return _cMask;
      }
      
      public function set mask(param1:FNode) : void {
         if(_cMask != null)
         {
            _cMask.iUsedAsPPMask--;
         }
         _cMask = param1;
         _cMask.iUsedAsPPMask++;
      }
      
      protected var _cMaskFilter:FMaskPassFilter;
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void {
         var _loc10_:* = 0;
         var _loc8_:* = param5;
         if(_loc8_ == null)
         {
            _loc8_ = _rDefinedBounds?_rDefinedBounds:param4.getWorldBounds(_rActiveBounds);
         }
         if(_loc8_.x == 1.7976931348623157E308)
         {
            return;
         }
         updatePassTextures(_loc8_);
         if(param6 == null)
         {
            _cMatrix.identity();
            _cMatrix.prependTranslation(-_loc8_.x + _iLeftMargin,-_loc8_.y + _iTopMargin,0);
            param1.setRenderTarget(_aPassTextures[0],_cMatrix);
            param1.setCamera(FlEngine.getInstance().defaultCamera);
            param4.render(param1,param2,_aPassTextures[0].region,false);
         }
         var _loc9_:FTexture = _aPassTextures[0];
         if(param6)
         {
            _aPassTextures[0] = param6;
         }
         var _loc11_:FMaskPassFilter = null;
         if(_cMask != null)
         {
            param1.setRenderTarget(_aPassTextures[1]);
            _loc10_ = _cMask.iUsedAsPPMask;
            _cMask.iUsedAsPPMask = 0;
            _cMask.render(param1,param2,_aPassTextures[1].region,false);
            _cMask.iUsedAsPPMask = _loc10_;
            _loc11_ = _cMaskFilter;
         }
         if(param7 == null)
         {
            param1.setRenderTarget(null);
            param1.setCamera(param2);
            param1.draw(_aPassTextures[0],_loc8_.x - _iLeftMargin,_loc8_.y - _iTopMargin,1,1,0,1,1,1,1,1,param3,_loc11_);
         }
         else
         {
            param1.setRenderTarget(param7);
            param1.draw(_aPassTextures[0],0,0,1,1,0,1,1,1,1,1,param7.region,_loc11_);
         }
         _aPassTextures[0] = _loc9_;
      }
   }
}
