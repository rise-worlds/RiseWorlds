package com.flengine.components.renderables
{
    import com.flengine.core.*;
    import com.flengine.textures.*;

    public class FSprite extends FTexturedQuad
    {

        public function FSprite(param1:FNode)
        {
            super(param1);
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

        public function set textureId(param1:String) : void
        {
            cTexture = FTextureBase.getTextureBaseById(param1) as FTexture;
            return;
        }// end function

        public function setTexture(param1:FTexture) : void
        {
            cTexture = param1;
            return;
        }// end function

    }
}
