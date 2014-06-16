package com.flengine.context.filters
{
   public class FPosterizeFilter extends FFilter
   {
      
      public function FPosterizeFilter(param1:int, param2:int, param3:int) {
         super();
         iId = 11;
         fragmentCode = "mul ft0.xyz, ft0.xyz, fc1.xyz \nfrc ft1.xyz, ft0.xyz \t\t   \nsub ft0.xyz, ft0.xyz, ft1.xyz \ndiv ft0.xyz, ft0.xyz, fc1.xyz \n";
         _aFragmentConstants = new <Number>[0,0,0,0];
         red = param1;
         green = param2;
         blue = param3;
      }
      
      protected var _iRed:int = 0;
      
      public function get red() : int {
         return _iRed;
      }
      
      public function set red(param1:int) : void {
         _iRed = param1;
         _aFragmentConstants[0] = _iRed;
      }
      
      protected var _iGreen:int = 0;
      
      public function get green() : int {
         return _iGreen;
      }
      
      public function set green(param1:int) : void {
         _iGreen = param1;
         _aFragmentConstants[1] = _iGreen;
      }
      
      protected var _iBlue:int = 0;
      
      public function get blue() : int {
         return _iBlue;
      }
      
      public function set blue(param1:int) : void {
         _iBlue = param1;
         _aFragmentConstants[2] = _iBlue;
      }
   }
}
