package com.flengine.context.filters
{
   import flash.display3D.Context3D;
   import com.flengine.textures.FTexture;
   
   public class FPixelateFilter extends FFilter
   {
      
      public function FPixelateFilter(param1:int) {
         super();
         iId = 10;
         bOverrideFragmentShader = true;
         fragmentCode = "div ft0, v0, fc1                       \nfrc ft1, ft0                           \nsub ft0, ft0, ft1                      \nmul ft1, ft0, fc1                      \nadd ft0.xy, ft1,xy, fc1.zw \t\t\t\ntex oc, ft0, fs0<2d, clamp, nearest>";
         pixelSize = param1;
      }
      
      public var pixelSize:int = 1;
      
      override public function bind(param1:Context3D, param2:FTexture) : void {
         _aFragmentConstants = new <Number>[pixelSize / param2.gpuWidth,pixelSize / param2.gpuHeight,pixelSize / (param2.gpuWidth * 2),pixelSize / (param2.gpuHeight * 2)];
         super.bind(param1,param2);
      }
   }
}
