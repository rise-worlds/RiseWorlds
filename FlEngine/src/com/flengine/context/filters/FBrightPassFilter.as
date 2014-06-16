package com.flengine.context.filters
{
   public class FBrightPassFilter extends FFilter
   {
      
      public function FBrightPassFilter(param1:Number) {
         super();
         iId = 4;
         fragmentCode = "sub ft0.xyz, ft0.xyz, fc1.xxx    \nmul ft0.xyz, ft0.xyz, fc1.yyy    \nsat ft0, ft0           \t\t\t \n";
         _aFragmentConstants = new <Number>[0.5,2,0,0];
         treshold = param1;
      }
      
      protected var _nTreshold:Number = 0.5;
      
      public function get treshold() : Number {
         return _nTreshold;
      }
      
      public function set treshold(param1:Number) : void {
         _nTreshold = param1;
         _aFragmentConstants[0] = _nTreshold;
         _aFragmentConstants[1] = 1 / (1 - _nTreshold);
      }
   }
}
