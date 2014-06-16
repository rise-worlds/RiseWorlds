package com.flengine.context.postprocesses
{
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   import com.flengine.context.filters.FBlurPassFilter;
   
   public class FBlurPP extends FPostProcess
   {
      
      public function FBlurPP(param1:int, param2:int, param3:int = 1) {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         super(param3 * 2);
         _nBlurX = 2 * param1 / _iPasses;
         _nBlurY = 2 * param2 / _iPasses;
         _iRightMargin = _nBlurX * _iPasses * 0.5;
         _iLeftMargin = _nBlurX * _iPasses * 0.5;
         _iBottomMargin = _nBlurY * _iPasses * 0.5;
         _iTopMargin = _nBlurY * _iPasses * 0.5;
         _loc5_ = 0;
         while(_loc5_ < _iPasses)
         {
            _loc4_ = new FBlurPassFilter(_loc5_ < _iPasses / 2?_nBlurY:_nBlurX,_loc5_ < _iPasses / 2?0:1);
            _aPassFilters[_loc5_] = _loc4_;
            _loc5_++;
         }
      }
      
      protected var _bInvalidate:Boolean = false;
      
      protected var _bColorize:Boolean = false;
      
      public function get colorize() : Boolean {
         return _bColorize;
      }
      
      public function set colorize(param1:Boolean) : void {
         _bColorize = param1;
         _bInvalidate = true;
      }
      
      protected var _nRed:Number = 0;
      
      public function get red() : Number {
         return _nRed;
      }
      
      public function set red(param1:Number) : void {
         _nRed = param1;
         _bInvalidate = true;
      }
      
      protected var _nGreen:Number = 0;
      
      public function get green() : Number {
         return _nGreen;
      }
      
      public function set green(param1:Number) : void {
         _nGreen = param1;
         _bInvalidate = true;
      }
      
      protected var _nBlue:Number = 0;
      
      public function get blue() : Number {
         return _nBlue;
      }
      
      public function set blue(param1:Number) : void {
         _nBlue = param1;
         _bInvalidate = true;
      }
      
      protected var _nAlpha:Number = 1;
      
      public function get alpha() : Number {
         return _nAlpha;
      }
      
      public function set alpha(param1:Number) : void {
         _nAlpha = param1;
         _bInvalidate = true;
      }
      
      override public function get passes() : int {
         return _iPasses / 2;
      }
      
      protected var _nBlurX:Number = 0;
      
      public function get blurX() : int {
         return _iPasses * _nBlurX / 2;
      }
      
      public function set blurX(param1:int) : void {
         _nBlurX = 2 * param1 / _iPasses;
         _bInvalidate = true;
      }
      
      protected var _nBlurY:Number = 0;
      
      public function get blurY() : int {
         return _iPasses * _nBlurY / 2;
      }
      
      public function set blurY(param1:int) : void {
         _nBlurY = 2 * param1 / _iPasses;
         _bInvalidate = true;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void {
         if(_bInvalidate)
         {
            invalidateBlurFilters();
         }
         super.render(param1,param2,param3,param4,param5,param6,param7);
      }
      
      private function invalidateBlurFilters() : void {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         _loc2_ = _aPassFilters.length - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = _aPassFilters[_loc2_] as FBlurPassFilter;
            _loc1_.blur = _loc2_ < _iPasses / 2?_nBlurY:_nBlurX;
            _loc1_.colorize = _bColorize;
            _loc1_.red = _nRed;
            _loc1_.green = _nGreen;
            _loc1_.blue = _nBlue;
            _loc1_.alpha = _nAlpha;
            _loc2_--;
         }
         _iRightMargin = _nBlurX * _iPasses * 0.5;
         _iLeftMargin = _nBlurX * _iPasses * 0.5;
         _iBottomMargin = _nBlurY * _iPasses * 0.5;
         _iTopMargin = _nBlurY * _iPasses * 0.5;
         _bInvalidate = false;
      }
   }
}
