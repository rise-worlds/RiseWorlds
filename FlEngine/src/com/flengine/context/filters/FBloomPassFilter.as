package com.flengine.context.filters
{
   import com.flengine.textures.FTexture;
   import flash.display3D.Context3D;
   import com.flengine.error.FError;
   
   public class FBloomPassFilter extends FFilter
   {
      
      public function FBloomPassFilter() {
         super();
         iId = 2;
         fragmentCode = "tex ft1, v0, fs1 <2d,linear,mipnone,clamp>\t\ndp3 ft2.x, ft0.xyz, fc1.xyz                \nsub ft3.xyz, ft0.xyz, ft2.xxx              \nmul ft3.xyz, ft3.xyz, fc2.zzz              \nadd ft3.xyz, ft3.xyz, ft2.xxx              \nmul ft0.xyz, ft3.xytz, fc2.xxx             \ndp3 ft2.x, ft1.xyz, fc1.xyz                \nsub ft3.xyz, ft1.xyz, ft2.xxx              \nmul ft3.xyz, ft3.xyz, fc2.www              \nadd ft3.xyz, ft3.xyz, ft2.xxx              \nmul ft1.xyz, ft3.xyz, fc2.yyy              \nsat ft2.xyz, ft0.xyz                       \nsub ft2.xyz, fc0.www, ft2.xyz              \nmul ft1.xyz, ft1.xyz, ft2.xyz              \nadd ft0, ft0, ft1              \t\t\t\n";
         _aFragmentConstants = new <Number>[0.3,0.59,0.11,1,1.25,1,1,1];
      }
      
      public var texture:FTexture;
      
      override public function bind(param1:Context3D, param2:FTexture) : void {
         super.bind(param1,param2);
         if(texture == null)
         {
            throw FError("There is no texture set for bloom pass.");
         }
         else
         {
            param1.setTextureAt(1,texture.cContextTexture.tTexture);
            return;
         }
      }
      
      override public function clear(param1:Context3D) : void {
         param1.setTextureAt(1,null);
      }
   }
}
