package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FSimpleShape extends FRenderable
    {
        var cTexture:FTexture;
        protected var _aVertices:Vector.<Number>;
        protected var _aUvs:Vector.<Number>;

        public function FSimpleShape(param1:FNode)
        {
            super(param1);
            return;
        }

        public function setTexture(param1:FTexture) : void
        {
            cTexture = param1;
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (cTexture == null || _aVertices == null || _aUvs == null)
            {
                return;
            }
            var _loc_4:* = cNode.cTransform;
            param1.drawPoly(cTexture, _aVertices, _aUvs, _loc_4.nWorldX, _loc_4.nWorldY, _loc_4.nWorldScaleX, _loc_4.nWorldScaleY, _loc_4.nWorldRotation, _loc_4.nWorldRed, _loc_4.nWorldGreen, _loc_4.nWorldBlue, _loc_4.nWorldAlpha, iBlendMode, param3);
            return;
        }

        public function init(param1:Vector.<Number>, param2:Vector.<Number>) : void
        {
            _aVertices = param1;
            _aUvs = param2;
            return;
        }

    }
}
