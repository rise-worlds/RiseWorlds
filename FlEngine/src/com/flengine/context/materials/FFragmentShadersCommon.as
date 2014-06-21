package com.flengine.context.materials
{
   import flash.utils.Dictionary;
   import flash.utils.ByteArray;
   import com.adobe.utils.AGALMiniAssembler;
   import com.flengine.context.filters.FFilter;
   import com.flengine.fl2d;
   use namespace fl2d;
   public class FFragmentShadersCommon extends Object
   {
      
      public function FFragmentShadersCommon() {
         super();
      }
      
      private static const COLOR_FRAGMENT_CODE:String = "mov oc, v1";
      private static const ALPHA_FRAGMENT_CODE:String = "mul ft0, ft0, v1";
      private static const FINAL_FRAGMENT_CODE:String = "mov oc, ft0";
      private static var CACHED_CODE:Dictionary = new Dictionary();
      
      private static function getSamplerFragmentCode(param1:Boolean, param2:int, param3:int) : String {
         return "tex ft0, v0, fs0 <2d," + (param1?"repeat":"clamp") + (param3 != 0?"," + (param3 == 1?"dxt1":"dxt5") + ",":",") + (param2 == 0?"nearest":"linear") + ",mipnone>";
      }
      
      public static function getColorShaderCode() : ByteArray {
         var _loc1_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc1_.assemble("fragment","mov oc, v1");
         return _loc1_.agalcode;
      }
      
      public static function getTexturedShaderCode(param1:Boolean, param2:int, param3:Boolean, param4:int = 0, param5:FFilter = null) : ByteArray {
         var _loc6_:String = null;
         if(param5 == null || !param5.bOverrideFragmentShader)
         {
            _loc6_ = getSamplerFragmentCode(param1,param2,param4);
            if(param5)
            {
               _loc6_ += ("\n" + param5.fragmentCode);
            }
            if(param3)
            {
               _loc6_ += "\nmul ft0, ft0, v1";
            }
            _loc6_ += "\nmov oc, ft0";
         }
         else
         {
            _loc6_ = param5.fragmentCode;
         }
         var _loc7_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc7_.assemble("fragment",_loc6_);
         return _loc7_.agalcode;
      }
   }
}
