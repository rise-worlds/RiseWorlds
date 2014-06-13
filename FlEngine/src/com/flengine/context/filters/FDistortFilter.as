package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FDistortFilter extends FFilter
    {
        public var redOffset:Number = 8;
        public var greenOffset:Number = 16;
        public var blueOffset:Number = 12;
        public var frequency:int = 40;

        public function FDistortFilter()
        {
            iId = 7;
            bOverrideFragmentShader = true;
            fragmentCode = "mul ft3, v0, fc2.x\t\t\t\t\t\t\t\nsin ft3, ft3\t\t\t\t\t\t\t\t\nmul ft4, ft3.y, fc1\t\t\t\t\t\t\nadd ft0, v0, ft4.xwww \t\t\t\t\t\t\ntex ft1, ft0, fs0 <2d,linear,mipnone,clamp>\nadd ft0, v0, ft4.ywww\t\t\t\t\t\t\ntex ft2, ft0, fs0 <2d,linear,mipnone,clamp>\nmov ft1.y, ft2.xy\t\t\t\t\t\t\t\nadd ft0, v0, ft4.zwww\t\t\t\t\t\t\ntex ft2, ft0, fs0 <2d,linear,mipnone,clamp>\nmov ft1.z, ft2.xyz\t\t\t\t\t\t\t\nmov oc, ft1";
            new Vector.<Number>(8)[0] = 0.1;
            new Vector.<Number>(8)[1] = 0.05;
            new Vector.<Number>(8)[2] = 0.2;
            new Vector.<Number>(8)[3] = 0;
            new Vector.<Number>(8)[4] = 4;
            new Vector.<Number>(8)[5] = 0;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            _aFragmentConstants = new Vector.<Number>(8);
            return;
        }

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            var _loc_3:* = 1 / param2.gpuWidth;
            new Vector.<Number>(8)[0] = redOffset * _loc_3;
            new Vector.<Number>(8)[1] = greenOffset * _loc_3;
            new Vector.<Number>(8)[2] = blueOffset * _loc_3;
            new Vector.<Number>(8)[3] = 0;
            new Vector.<Number>(8)[4] = frequency;
            new Vector.<Number>(8)[5] = 0;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            _aFragmentConstants = new Vector.<Number>(8);
            super.bind(param1, param2);
            return;
        }

    }
}
