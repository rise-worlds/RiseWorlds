package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FFilter extends Object
    {
        public var fragmentCode:String;
        protected var _aFragmentConstants:Vector.<Number>;
        var iId:int;
        var bOverrideFragmentShader:Boolean = false;

        public function FFilter()
        {
            iId = 0;
            _aFragmentConstants = new Vector.<Number>;
            return;
        }

        public function bind(param1:Context3D, param2:FTexture) : void
        {
            param1.setProgramConstantsFromVector("fragment", 1, _aFragmentConstants, _aFragmentConstants.length / 4);
            return;
        }

        public function clear(param1:Context3D) : void
        {
            return;
        }

    }
}
