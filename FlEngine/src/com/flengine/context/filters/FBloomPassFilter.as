package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FBloomPassFilter extends FFilter
    {
        public var texture:FTexture;

        public function FBloomPassFilter()
        {
            iId = 2;
            fragmentCode = "tex ft1, v0, fs1 <2d,linear,mipnone,clamp>\t\ndp3 ft2.x, ft0.xyz, fc1.xyz                \nsub ft3.xyz, ft0.xyz, ft2.xxx              \nmul ft3.xyz, ft3.xyz, fc2.zzz              \nadd ft3.xyz, ft3.xyz, ft2.xxx              \nmul ft0.xyz, ft3.xytz, fc2.xxx             \ndp3 ft2.x, ft1.xyz, fc1.xyz                \nsub ft3.xyz, ft1.xyz, ft2.xxx              \nmul ft3.xyz, ft3.xyz, fc2.www              \nadd ft3.xyz, ft3.xyz, ft2.xxx              \nmul ft1.xyz, ft3.xyz, fc2.yyy              \nsat ft2.xyz, ft0.xyz                       \nsub ft2.xyz, fc0.www, ft2.xyz              \nmul ft1.xyz, ft1.xyz, ft2.xyz              \nadd ft0, ft0, ft1              \t\t\t\n";
            new Vector.<Number>(8)[0] = 0.3;
            new Vector.<Number>(8)[1] = 0.59;
            new Vector.<Number>(8)[2] = 0.11;
            new Vector.<Number>(8)[3] = 1;
            new Vector.<Number>(8)[4] = 1.25;
            new Vector.<Number>(8)[5] = 1;
            new Vector.<Number>(8)[6] = 1;
            new Vector.<Number>(8)[7] = 1;
            _aFragmentConstants = new Vector.<Number>(8);
            return;
        }

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            super.bind(param1, param2);
            if (texture == null)
            {
                throw this.FError("There is no texture set for bloom pass.");
            }
            param1.setTextureAt(1, texture.cContextTexture.tTexture);
            return;
        }

        override public function clear(param1:Context3D) : void
        {
            param1.setTextureAt(1, null);
            return;
        }

    }
}
