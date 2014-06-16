package com.flengine.context.postprocesses
{
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   
   public class FComposedPP extends FPostProcess
   {
      
      public function FComposedPP(param1:Vector.<FPostProcess>) {
         super(param1.length + 1);
         throw new Error("Not supported yet.");
      }
      
      protected var _cEmptyPass:FFilterPP;
      
      protected var _aPostProcesses:Vector.<FPostProcess>;
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void {
         var _loc10_:* = 0;
         var _loc8_:Rectangle = _rDefinedBounds?_rDefinedBounds:param4.getWorldBounds(_rActiveBounds);
         if(_loc8_.x == 1.7976931348623157E308)
         {
            return;
         }
         updatePassTextures(_loc8_);
         _cEmptyPass.render(param1,param2,param3,param4,_loc8_,null,_aPassTextures[0]);
         var _loc9_:int = _aPostProcesses.length;
         _loc10_ = 0;
         while(_loc10_ < _loc9_ - 1)
         {
            _aPostProcesses[_loc10_].render(param1,param2,param3,param4,_loc8_,_aPassTextures[_loc10_],_aPassTextures[_loc10_ + 1]);
            _loc10_++;
         }
         _aPostProcesses[_loc9_ - 1].render(param1,param2,param3,param4,_loc8_,_aPassTextures[_loc9_ - 1],null);
      }
   }
}
