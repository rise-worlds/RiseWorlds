package com.flengine.context.materials
{
    import com.adobe.utils.*;
    import com.flengine.context.filters.*;
    import flash.utils.*;

    public class FFragmentShadersCommon extends Object
    {
        private static const COLOR_FRAGMENT_CODE:String = "mov oc, v1";
        private static const ALPHA_FRAGMENT_CODE:String = "mul ft0, ft0, v1";
        private static const FINAL_FRAGMENT_CODE:String = "mov oc, ft0";
        private static var CACHED_CODE:Dictionary = new Dictionary();

        public function FFragmentShadersCommon()
        {
            return;
        }// end function

        private static function getSamplerFragmentCode(param1:Boolean, param2:int, param3:int) : String
        {
            return "tex ft0, v0, fs0 <2d," + (param1 ? ("repeat") : ("clamp")) + (param3 != 0 ? ("," + (param3 == 1 ? ("dxt1") : ("dxt5")) + ",") : (",")) + (param2 == 0 ? ("nearest") : ("linear")) + ",mipnone>";
        }// end function

        public static function getColorShaderCode() : ByteArray
        {
            var _loc_1:* = new AGALMiniAssembler();
            _loc_1.assemble("fragment", "mov oc, v1");
            return _loc_1.agalcode;
        }// end function

        public static function getTexturedShaderCode(param1:Boolean, param2:int, param3:Boolean, param4:int = 0, param5:FFilter = null) : ByteArray
        {
            var _loc_6:* = null;
            if (param5 == null || !param5.bOverrideFragmentShader)
            {
                _loc_6 = getSamplerFragmentCode(param1, param2, param4);
                if (param5)
                {
                    _loc_6 = _loc_6 + ("\n" + param5.fragmentCode);
                }
                if (param3)
                {
                    _loc_6 = _loc_6 + "\nmul ft0, ft0, v1";
                }
                _loc_6 = _loc_6 + "\nmov oc, ft0";
            }
            else
            {
                _loc_6 = param5.fragmentCode;
            }
            var _loc_7:* = new AGALMiniAssembler();
            _loc_7.assemble("fragment", _loc_6);
            return _loc_7.agalcode;
        }// end function

    }
}
