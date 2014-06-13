package com.flengine.context.filters
{
    import com.flengine.textures.*;
    import flash.display3D.*;

    public class FMaskPassFilter extends FFilter
    {
        protected var _cMaskTexture:FTexture;

        public function FMaskPassFilter(param1:FTexture)
        {
            _cMaskTexture = param1;
            fragmentCode = "tex ft1, v0, fs1 <2d,clamp,linear,mipnone>\t\nmul ft0, ft0, ft1.wwww                     \n";
            return;
        }

        override public function bind(param1:Context3D, param2:FTexture) : void
        {
            super.bind(param1, param2);
            if (_cMaskTexture == null)
            {
                throw this.Error("There is no mask set.");
            }
            param1.setTextureAt(1, _cMaskTexture.cContextTexture.tTexture);
            return;
        }

        override public function clear(param1:Context3D) : void
        {
            param1.setTextureAt(1, null);
            return;
        }

    }
}
