package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.core.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FBlurPassFilter extends FFilter
    {
        public var blur:Number = 0;
        public var direction:int = 0;
        public var colorize:Boolean = false;
        public var red:Number = 0;
        public var green:Number = 0;
        public var blue:Number = 0;
        public var alpha:Number = 1;
        public static const VERTICAL:int = 0;
        public static const HORIZONTAL:int = 1;

        public function FBlurPassFilter(param1:int, param2:int)
        {
            iId = 3;
            if (FlEngine.getInstance().cConfig.profile != "baseline")
            {
                throw new FError("FError: Cannot run in constrained mode.", FBlurPassFilter);
            }
            bOverrideFragmentShader = true;
            fragmentCode = "tex ft0, v0, fs0 <2d,linear,mipnone,clamp>     \nmul ft0.xyzw, ft0.xyzw, fc2.y                  \nsub ft1.xy, v0.xy, fc1.xy                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.z                  \nadd ft0, ft0, ft2                              \nadd ft1.xy, v0.xy, fc1.xy                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.z                  \nadd ft0, ft0, ft2                              \nsub ft1.xy, v0.xy, fc1.zw                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.w                  \nadd ft0, ft0, ft2                              \nadd ft1.xy, v0.xy, fc1.zw                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.w                  \nadd ft0, ft0, ft2                              \nmul ft0.xyz, ft0.xyz, fc2.xxx\t\t\t\t\t\nmul ft1.xyz, ft0.www, fc3.xyz\t\t\t\t\t\nadd ft0.xyz, ft0.xyz, ft1.xyz\t\t\t\t\t\nmul oc, ft0, fc3.wwww\t\t\t\t\t\t\t\n";
            new Vector.<Number>(12)[0] = 0;
            new Vector.<Number>(12)[1] = 0;
            new Vector.<Number>(12)[2] = 0;
            new Vector.<Number>(12)[3] = 0;
            new Vector.<Number>(12)[4] = 1;
            new Vector.<Number>(12)[5] = 0.227027;
            new Vector.<Number>(12)[6] = 0.316216;
            new Vector.<Number>(12)[7] = 0.0702703;
            new Vector.<Number>(12)[8] = 0;
            new Vector.<Number>(12)[9] = 0;
            new Vector.<Number>(12)[10] = 0;
            new Vector.<Number>(12)[11] = 1;
            _aFragmentConstants = new Vector.<Number>(12);
            blur = param1;
            direction = param2;
            return;
        }

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            if (direction == 1)
            {
                _aFragmentConstants[0] = 1 / param2.gpuWidth * 1.38462 * blur * 0.5;
                _aFragmentConstants[1] = 0;
                _aFragmentConstants[2] = 1 / param2.gpuWidth * 3.23077 * blur * 0.5;
                _aFragmentConstants[3] = 0;
            }
            else
            {
                _aFragmentConstants[0] = 0;
                _aFragmentConstants[1] = 1 / param2.gpuHeight * 1.38462 * blur * 0.5;
                _aFragmentConstants[2] = 0;
                _aFragmentConstants[3] = 1 / param2.gpuHeight * 3.23077 * blur * 0.5;
            }
            _aFragmentConstants[4] = colorize ? (0) : (1);
            _aFragmentConstants[8] = red;
            _aFragmentConstants[9] = green;
            _aFragmentConstants[10] = blue;
            _aFragmentConstants[11] = alpha;
            super.bind(param1, param2);
            return;
        }

    }
}
