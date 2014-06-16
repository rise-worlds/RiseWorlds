package com.flengine.context.filters
{
   import flash.display3D.Context3D;
   import com.flengine.textures.FTexture;
   
   public class FFilter extends Object
   {
      
      public function FFilter() {
         super();
         iId = 0;
         _aFragmentConstants = new Vector.<Number>();
      }
      
      public var fragmentCode:String;
      
      protected var _aFragmentConstants:Vector.<Number>;
      
      fl2d var iId:int;
      
      fl2d var bOverrideFragmentShader:Boolean = false;
      
      public function bind(param1:Context3D, param2:FTexture) : void {
         param1.setProgramConstantsFromVector("fragment",1,_aFragmentConstants,_aFragmentConstants.length / 4);
      }
      
      public function clear(param1:Context3D) : void {
      }
   }
}
