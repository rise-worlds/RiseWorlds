package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FPixelateFilter extends FFilter
    {
        public var pixelSize:int = 1;

        public function FPixelateFilter(param1:int)
        {
            iId = 10;
            bOverrideFragmentShader = true;
            fragmentCode = "div ft0, v0, fc1                       \nfrc ft1, ft0                           \nsub ft0, ft0, ft1                      \nmul ft1, ft0, fc1                      \nadd ft0.xy, ft1,xy, fc1.zw \t\t\t\ntex oc, ft0, fs0<2d, clamp, nearest>";
            pixelSize = param1;
            return;
        }

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            new Vector.<Number>(4)[0] = pixelSize / param2.gpuWidth;
            new Vector.<Number>(4)[1] = pixelSize / param2.gpuHeight;
            new Vector.<Number>(4)[2] = pixelSize / (param2.gpuWidth * 2);
            new Vector.<Number>(4)[3] = pixelSize / (param2.gpuHeight * 2);
            _aFragmentConstants = new Vector.<Number>(4);
            super.bind(param1, param2);
            return;
        }

    }
}
