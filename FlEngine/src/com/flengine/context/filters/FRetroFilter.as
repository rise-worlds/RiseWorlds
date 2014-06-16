package com.flengine.context.filters
{
   public class FRetroFilter extends FFilter
   {
      
      public function FRetroFilter() {
         super();
         iId = 12;
         fragmentCode = "dp3 ft2.x, ft0.xyz, fc1.xyz    \nsub ft3.xyz, fc1.www, ft2.xxx  \nsub ft4.xyz, fc1.www, ft0.xyz  \nmul ft3.xyz, ft3.xyz, ft4.xyz  \nadd ft3.xyz, ft3.xyz, ft3.xyz  \nsub ft3.xyz, fc1.www, ft3.xyz  \nmul ft4.xyz, ft2.xxx, ft0.xyz  \nadd ft4.xyz, ft4.xyz, ft4.xyz  \nsge ft1.xyz, ft0.xyz, fc2.www  \nslt ft5.xyz, ft0.xyz, fc2.www  \nmul ft1.xyz, ft1.xyz, ft3.xyz  \nmul ft5.xyz, ft5.xyz, ft4.xyz  \nadd ft1.xyz, ft1.xyz, ft5.xyz  \nmul ft1.xyz, ft1.xyz, fc2.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc3.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc4.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmov ft0.xyz, ft1.xyz           \n";
         _aFragmentConstants = new <Number>[0.3,0.59,0.11,1,0.5790077843137255,0.5582465490196078,0.37600903921568624,0.5,0.8180392156862745,0.9207843137254902,0.8596078431372549,0,0.9940484588235294,0.9517263882352941,0.8459212117647059,0];
      }
   }
}
