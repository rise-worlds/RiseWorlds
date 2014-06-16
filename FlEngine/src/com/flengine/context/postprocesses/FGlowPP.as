package com.flengine.context.postprocesses
{
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   import com.flengine.context.filters.FFilter;
   
   public class FGlowPP extends FPostProcess
   {
      
      public function FGlowPP(param1:int = 2, param2:int = 2, param3:int = 1) {
         super(2);
         _cEmpty = new FFilterPP(new <FFilter>[null]);
         _cBlur = new FBlurPP(param1,param2,param3);
         _cBlur.colorize = true;
         _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      protected var _cEmpty:FFilterPP;
      
      protected var _cBlur:FBlurPP;
      
      protected var _iOffsetX:int;
      
      protected var _iOffsetY:int;
      
      public function get color() : int {
         var _loc1_:uint = _cBlur.red * 255 << 16;
         var _loc3_:uint = _cBlur.green * 255 << 8;
         var _loc2_:uint = _cBlur.blue * 255;
         return _loc1_ + _loc3_ + _loc2_;
      }
      
      public function set color(param1:int) : void {
         _cBlur.red = (param1 >> 16 & 255) / 255;
         _cBlur.green = (param1 >> 8 & 255) / 255;
         _cBlur.blue = (param1 & 255) / 255;
      }
      
      public function get alpha() : Number {
         return _cBlur.alpha;
      }
      
      public function set alpha(param1:Number) : void {
         _cBlur.alpha = param1;
      }
      
      public function get blurX() : Number {
         return _cBlur.blurX;
      }
      
      public function set blurX(param1:Number) : void {
         _cBlur.blurX = param1;
         _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
      }
      
      public function get blurY() : int {
         return _cBlur.blurY;
      }
      
      public function set blurY(param1:int) : void {
         _cBlur.blurY = param1;
         _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
         _cEmpty.setMargins(_iLeftMargin,_iRightMargin,_iTopMargin,_iBottomMargin);
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
         param1.setRenderTarget(null);
         param1.setCamera(param2);
         param1.draw(_aPassTextures[1],_loc8_.x - _iLeftMargin + _iOffsetX,_loc8_.y - _iTopMargin + _iOffsetY,1,1,0,1,1,1,1,1,param3);
         param1.draw(_aPassTextures[0],_loc8_.x - _iLeftMargin,_loc8_.y - _iTopMargin,1,1,0,1,1,1,1,1,param3);
      }
      
      override public function dispose() : void {
         _cEmpty.dispose();
         _cBlur.dispose();
         super.dispose();
      }
   }
}
