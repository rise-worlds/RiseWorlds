package com.flengine.context.filters
{
   public class FColorMatrixFilter extends FFilter
   {
      
      public function FColorMatrixFilter(param1:Vector.<Number> = null) {
         super();
         iId = 5;
         setMatrix(param1 == null?IDENTITY_MATRIX:param1);
         fragmentCode = "max ft0, ft0, fc6             \ndiv ft0.xyz, ft0.xyz, ft0.www \nm44 ft0, ft0, fc1             \nadd ft0, ft0, fc5             \nmul ft0.xyz, ft0.xyz, ft0.www \n";
      }
      
      private static const IDENTITY_MATRIX:Vector.<Number>;
      
      public function setMatrix(param1:Vector.<Number>) : void {
         _aFragmentConstants.unshift(param1[0],param1[1],param1[2],param1[3],param1[5],param1[6],param1[7],param1[8],param1[10],param1[11],param1[12],param1[13],param1[15],param1[16],param1[17],param1[18],param1[4] / 255,param1[9] / 255,param1[14] / 255,param1[19] / 255,0,0,0,1.0E-4);
         _aFragmentConstants.length = 24;
      }
   }
}
