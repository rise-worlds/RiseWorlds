package com.flengine.context.postprocesses
{
   import com.flengine.context.filters.FHDRPassFilter;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   import com.flengine.context.filters.FFilter;
   
   public class FHDRPP extends FPostProcess
   {
      
      public function FHDRPP(param1:int = 3, param2:int = 3, param3:int = 2, param4:Number = 1.3) {
         super(2);
         _iRightMargin = param1 * 2 * param3;
         _iLeftMargin = param1 * 2 * param3;
         _iBottomMargin = param2 * 2 * param3;
         _iTopMargin = param2 * 2 * param3;
         _cEmpty = new FFilterPP(new <FFilter>[null]);
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
         _cBlur = new FBlurPP(param1,param2,param3);
         _cHDRPassFilter = new FHDRPassFilter(param4);
      }
      
      protected var _cEmpty:FFilterPP;
      
      protected var _cBlur:FBlurPP;
      
      protected var _cHDRPassFilter:FHDRPassFilter;
      
      public function get blurX() : int {
         return _cBlur.blurX;
      }
      
      public function set blurX(param1:int) : void {
         _cBlur.blurX = param1;
         _iRightMargin = param1 * 2 * _cBlur.passes;
         _iLeftMargin = param1 * 2 * _cBlur.passes;
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      public function get blurY() : int {
         return _cBlur.blurY;
      }
      
      public function set blurY(param1:int) : void {
         _cBlur.blurY = param1;
         _iBottomMargin = param1 * 2 * _cBlur.passes;
         _iTopMargin = param1 * 2 * _cBlur.passes;
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      public function get saturation() : Number {
         return _cHDRPassFilter.saturation;
      }
      
      public function set saturation(param1:Number) : void {
         _cHDRPassFilter.saturation = param1;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void {
         var _loc8_:Rectangle = _rDefinedBounds?_rDefinedBounds:param4.getWorldBounds(_rActiveBounds);
         if(_loc8_.x == 1.7976931348623157E308)
         {
            return;
         }
         updatePassTextures(_loc8_);
         _cEmpty.render(param1,param2,param3,param4,_loc8_,null,_aPassTextures[0]);
         _cBlur.render(param1,param2,param3,param4,_loc8_,_aPassTextures[0],_aPassTextures[1]);
         _cHDRPassFilter.texture = _cEmpty.getPassTexture(0);
         param1.setRenderTarget(null);
         param1.setCamera(param2);
         param1.draw(_aPassTextures[1],_loc8_.x - _iLeftMargin,_loc8_.y - _iTopMargin,1,1,0,1,1,1,1,1,param3,_cHDRPassFilter);
      }
      
      override public function dispose() : void {
         _cBlur.dispose();
         super.dispose();
      }
   }
}
