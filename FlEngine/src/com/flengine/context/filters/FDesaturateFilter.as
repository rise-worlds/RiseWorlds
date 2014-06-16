package com.flengine.context.filters
{
   public class FDesaturateFilter extends FFilter
   {
      
      public function FDesaturateFilter() {
         super();
         iId = 6;
         fragmentCode = "dp3 ft0.xyz, ft0.xyz, fc1.xyz";
         _aFragmentConstants = new <Number>[0.299,0.587,0.114,0];
      }
   }
}
