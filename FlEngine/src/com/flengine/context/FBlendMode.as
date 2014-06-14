package com.flengine.context
{
    import flash.display3D.*;

    public class FBlendMode extends Object
    {
        private static var blendFactors:Array = [[[Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO], [Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], [Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA], [Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], [Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE], [Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA]], [[Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO], [Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], [Context3DBlendFactor.ONE, Context3DBlendFactor.ONE], [Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], [Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR], [Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA]]];
        public static const NONE:int = 0;
        public static const NORMAL:int = 1;
        public static const ADD:int = 2;
        public static const MULTIPLY:int = 3;
        public static const SCREEN:int = 4;
        public static const ERASE:int = 5;

        public function FBlendMode()
        {
            return;
        }

        public static function addBlendMode(param1:Array, param2:Array) : int
        {
            blendFactors[0].push(param1);
            blendFactors[1].push(param2);
            return blendFactors[0].length;
        }

        public static function setBlendMode(param1:Context3D, param2:int, param3:Boolean) : void
        {
            param1.setBlendFactors(blendFactors[param3][param2][0], blendFactors[param3][param2][1]);
            return;
        }

    }
}
