package com.flengine.context.postprocesses
{
   import com.flengine.context.filters.FBloomPassFilter;
   import com.flengine.context.filters.FBrightPassFilter;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   import com.flengine.context.filters.FFilter;
   
   public class FBloomPP extends FPostProcess
   {
      
      public function FBloomPP(param1:int = 2, param2:int = 2, param3:int = 1, param4:Number = 0.75) {
         super(2);
         _cBlur = new FBlurPP(param1,param2,param3);
         _cBright = new FFilterPP(new <FFilter>[new FBrightPassFilter(param4)]);
         _cBloomFilter = new FBloomPassFilter();
         _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _cBright.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      protected var _cBlur:FBlurPP;
      
      protected var _cBright:FFilterPP;
      
      protected var _cBloomFilter:FBloomPassFilter;
      
      public function get blurX() : int {
         return _cBlur.blurX;
      }
      
      public function set blurX(param1:int) : void {
         _cBlur.blurX = param1;
         _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _cBright.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      public function get blurY() : int {
         return _cBlur.blurY;
      }
      
      public function set blurY(param1:int) : void {
         _cBlur.blurY = param1;
         _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _cBright.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      public function get brightTreshold() : Number {
         return (_cBright.getPassFilter(0) as FBrightPassFilter).treshold;
      }
      
      public function set brightTreshold(param1:Number) : void {
         (_cBright.getPassFilter(0) as FBrightPassFilter).treshold = param1;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void {
         var _loc8_:Rectangle = _rDefinedBounds?_rDefinedBounds:param4.getWorldBounds(_rActiveBounds);
         if(_loc8_.x == 1.7976931348623157E308)
         {
            return;
         }
         updatePassTextures(_loc8_);
         _cBright.render(param1,param2,param3,param4,_loc8_,null,_aPassTextures[0]);
         _cBlur.render(param1,param2,param3,param4,_loc8_,_aPassTextures[0],_aPassTextures[1]);
         _cBloomFilter.texture = _cBright.getPassTexture(0);
         param1.setRenderTarget(null);
         param1.setCamera(param2);
         param1.draw(_aPassTextures[1],_loc8_.x - _iLeftMargin,_loc8_.y - _iTopMargin,1,1,0,1,1,1,1,1,param3,_cBloomFilter);
      }
      
      override public function dispose() : void {
         _cBlur.dispose();
         _cBright.dispose();
         super.dispose();
      }
   }
}
