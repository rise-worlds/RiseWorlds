package com.flengine.components.light
{
    import com.flengine.components.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;

    public class FLight extends FComponent
    {
        public var shadows:Boolean = true;
        var cTexture:FTexture;
        var iRadius:int;
        var iRadiusSquared:int;

        public function FLight(param1:FNode)
        {
            super(param1);
            radius = 100;
            return;
        }// end function

        public function get radius() : int
        {
            return iRadius;
        }// end function

        public function set radius(param1:int) : void
        {
            iRadius = param1;
            iRadiusSquared = iRadius * iRadius;
            return;
        }// end function

        public function getTexture() : FTexture
        {
            return cTexture;
        }// end function

        public function set textureId(param1:String) : void
        {
            cTexture = FTexture.getTextureById(param1);
            return;
        }// end function

        public function get textureId() : String
        {
            if (cTexture)
            {
                return cTexture.id;
            }
            return "";
        }// end function

        public function toString() : String
        {
            return node.transform.x + ":" + node.transform.y;
        }// end function

    }
}
