package com.flengine.components.renderables
{
    import com.flengine.components.*;
    import com.flengine.core.*;
    import flash.geom.*;

    public class FRenderable extends FComponent
    {
        var iBlendMode:int = 1;

        public function FRenderable(param1:FNode)
        {
            super(param1);
            return;
        }// end function

        public function set blendMode(param1:int) : void
        {
            iBlendMode = param1;
            return;
        }// end function

        public function get blendMode() : int
        {
            return iBlendMode;
        }// end function

        public function getWorldBounds(param1:Rectangle = null) : Rectangle
        {
            if (param1)
            {
                param1.setTo(cNode.cTransform.nWorldX, cNode.cTransform.nWorldY, 0, 0);
            }
            else
            {
                param1 = new Rectangle(cNode.cTransform.nWorldX, cNode.cTransform.nWorldY, 0, 0);
            }
            return param1;
        }// end function

    }
}
