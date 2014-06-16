package com.flengine.context.filters
{
   import com.flengine.textures.FTexture;
   import flash.display3D.Context3D;
   import com.flengine.error.FError;
   
   public class FHDRPassFilter extends FFilter
   {
      
      public function FHDRPassFilter(param1:Number = 1.3) {
         super();
         iId = 8;
         fragmentCode = "tex ft1, v0, fs1 <2d,linear,mipnone,clamp>\t\nsub ft0.xyz, fc1.www, ft0.xyz               \nadd ft0.xyz, ft1.xyz, ft0.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \nsat ft0.xyz, ft0.xyz                        \ndp3 ft2.x, ft1.xyz, fc1.xyz                \nsub ft1.xyz, ft1.xyz, ft2.xxx                \nmul ft1.xyz, ft1.xyz, fc2.xxx                \nadd ft1.xyz, ft1.xyz, ft2.xxx                \nadd ft0.xyz, ft0.xyz, ft1.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \n";
         _aFragmentConstants = new <Number>[0.2125,0.7154,0.0721,1,param1,0.5,0,0];
         _nSaturation = param1;
      }
      
      public var texture:FTexture;
      
      private var _nSaturation:Number = 1.3;
      
      public function get saturation() : Number {
         return _nSaturation;
      }
      
      public function set saturation(param1:Number) : void {
         _nSaturation = param1;
         _aFragmentConstants[4] = _nSaturation;
      }
      
      override public function bind(param1:Context3D, param2:FTexture) : void {
         super.bind(param1,param2);
         if(texture == null)
         {
            throw FError("There is no texture set for HDR pass.");
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
