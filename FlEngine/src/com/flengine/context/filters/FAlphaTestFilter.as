package com.flengine.context.filters
{
   public class FAlphaTestFilter extends FFilter
   {
      
      public function FAlphaTestFilter(param1:Number) {
         super();
         iId = 1;
         fragmentCode = "sub ft1.w, ft0.w, fc1.x   \nkil ft1.w                 \n";
         _aFragmentConstants = new <Number>[0.5,0,0,1];
         treshold = param1;
      }
      
      protected var _nTreshold:Number = 0.5;
      
      public function get treshold() : Number {
         return _nTreshold;
      }
      
      public function set treshold(param1:Number) : void {
         _nTreshold = param1;
         _aFragmentConstants[0] = _nTreshold;
      }
   }
}
