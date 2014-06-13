package com.flengine.context
{
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FRenderTarget extends Object
    {
        var cTexture:FTexture;
        var mMatrix:Matrix3D;
        var iRenderedTo:int = 0;
        public static const DEFAULT_RENDER_TARGET:FRenderTarget = new FRenderTarget;

        public function FRenderTarget(param1:FTexture = null, param2:Matrix3D = null)
        {
            cTexture = param1;
            mMatrix = param2;
            return;
        }

        public function toString() : String
        {
            return "[" + (cTexture ? (cTexture.id) : ("BackBuffer")) + " , " + mMatrix + " , " + iRenderedTo + "]";
        }

    }
}
