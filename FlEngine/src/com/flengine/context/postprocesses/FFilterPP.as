package com.flengine.context.postprocesses
{
   import com.flengine.context.filters.FFilter;
   
   public class FFilterPP extends FPostProcess
   {
      
      public function FFilterPP(param1:Vector.<FFilter>) {
         super(param1.length);
         _aPassFilters = param1;
      }
   }
}
