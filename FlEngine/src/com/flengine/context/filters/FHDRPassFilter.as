package com.flengine.context.filters
{
    import __AS3__.vec.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FHDRPassFilter extends FFilter
    {
        public var texture:FTexture;
        private var _nSaturation:Number = 1.3;

        public function FHDRPassFilter(param1:Number = 1.3)
        {
            iId = 8;
            fragmentCode = "tex ft1, v0, fs1 <2d,linear,mipnone,clamp>\t\nsub ft0.xyz, fc1.www, ft0.xyz               \nadd ft0.xyz, ft1.xyz, ft0.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \nsat ft0.xyz, ft0.xyz                        \ndp3 ft2.x, ft1.xyz, fc1.xyz                \nsub ft1.xyz, ft1.xyz, ft2.xxx                \nmul ft1.xyz, ft1.xyz, fc2.xxx                \nadd ft1.xyz, ft1.xyz, ft2.xxx                \nadd ft0.xyz, ft0.xyz, ft1.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \n";
            new Vector.<Number>(8)[0] = 0.2125;
            new Vector.<Number>(8)[1] = 0.7154;
            new Vector.<Number>(8)[2] = 0.0721;
            new Vector.<Number>(8)[3] = 1;
            new Vector.<Number>(8)[4] = param1;
            new Vector.<Number>(8)[5] = 0.5;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            _aFragmentConstants = new Vector.<Number>(8);
            _nSaturation = param1;
            return;
        }// end function

        public function get saturation() : Number
        {
            return _nSaturation;
        }// end function

        public function set saturation(param1:Number) : void
        {
            _nSaturation = param1;
            _aFragmentConstants[4] = _nSaturation;
            return;
        }// end function

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            super.bind(param1, param2);
            if (texture == null)
            {
                throw this.FError("There is no texture set for HDR pass.");
            }
            param1.setTextureAt(1, texture.cContextTexture.tTexture);
            return;
        }// end function

        override public function clear(param1:Context3D) : void
        {
            param1.setTextureAt(1, null);
            return;
        }// end function

    }
}
