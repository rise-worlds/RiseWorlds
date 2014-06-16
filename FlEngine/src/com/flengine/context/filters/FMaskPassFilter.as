package com.flengine.context.filters
{
   import com.flengine.textures.FTexture;
   import flash.display3D.Context3D;
   
   public class FMaskPassFilter extends FFilter
   {
      
      public function FMaskPassFilter(param1:FTexture) {
         super();
         _cMaskTexture = param1;
         fragmentCode = "tex ft1, v0, fs1 <2d,clamp,linear,mipnone>\t\nmul ft0, ft0, ft1.wwww                     \n";
      }
      
      protected var _cMaskTexture:FTexture;
      
      override public function bind(param1:Context3D, param2:FTexture) : void {
         super.bind(param1,param2);
         if(_cMaskTexture == null)
         {
            throw Error("There is no mask set.");
         }
         else
         {
            param1.setTextureAt(1,_cMaskTexture.cContextTexture.tTexture);
            return;
         }
      }
      
      override public function clear(param1:Context3D) : void {
         param1.setTextureAt(1,null);
      }
   }
}
