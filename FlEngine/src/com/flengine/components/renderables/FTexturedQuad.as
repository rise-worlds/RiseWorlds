package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.events.*;
    import flash.geom.*;

    public class FTexturedQuad extends FRenderable
    {
        public var filter:FFilter;
        var cTexture:FTexture;
        protected var _aTransformedVertices:Vector.<Number>;
        public var mousePixelEnabled:Boolean = false;
        private static const NORMALIZED_VERTICES_3D:Vector.<Number> = FTexturedQuad.Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, 0.5, 0]);

        public function FTexturedQuad(param1:FNode)
        {
            _aTransformedVertices = new Vector.<Number>;
            super(param1);
            return;
        }

        public function getTexture() : FTexture
        {
            return cTexture;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (cTexture == null)
            {
                return;
            }
            var _loc_4:* = cNode.cTransform;
            param1.draw(cTexture, _loc_4.nWorldX, _loc_4.nWorldY, _loc_4.nWorldScaleX, _loc_4.nWorldScaleY, _loc_4.nWorldRotation, _loc_4.nWorldRed, _loc_4.nWorldGreen, _loc_4.nWorldBlue, _loc_4.nWorldAlpha, iBlendMode, param3, filter);
            return;
        }

        override public function getWorldBounds(param1:Rectangle = null) : Rectangle
        {
            var _loc_4:* = 0;
            var _loc_2:* = getTransformedVertices3D();
            if (_loc_2 == null)
            {
                return param1;
            }
            if (param1)
            {
                param1.setTo(_loc_2[0], _loc_2[1], 0, 0);
            }
            else
            {
                param1 = new Rectangle(_loc_2[0], _loc_2[1], 0, 0);
            }
            var _loc_3:* = _loc_2.length;
            _loc_4 = 3;
            while (_loc_4 < _loc_3)
            {
                
                if (param1.left > _loc_2[_loc_4])
                {
                    param1.left = _loc_2[_loc_4];
                }
                if (param1.right < _loc_2[_loc_4])
                {
                    param1.right = _loc_2[_loc_4];
                }
                if (param1.top > _loc_2[(_loc_4 + 1)])
                {
                    param1.top = _loc_2[(_loc_4 + 1)];
                }
                if (param1.bottom < _loc_2[(_loc_4 + 1)])
                {
                    param1.bottom = _loc_2[(_loc_4 + 1)];
                }
                _loc_4 = _loc_4 + 3;
            }
            return param1;
        }

        function getTransformedVertices3D() : Vector.<Number>
        {
            if (cTexture == null)
            {
                return null;
            }
            var _loc_1:* = cTexture.region;
            var _loc_2:* = cNode.cTransform.worldTransformMatrix;
            _loc_2.prependTranslation(-cTexture.nPivotX, -cTexture.nPivotY, 0);
            _loc_2.prependScale(_loc_1.width, _loc_1.height, 1);
            _loc_2.transformVectors(NORMALIZED_VERTICES_3D, _aTransformedVertices);
            _loc_2.prependScale(1 / _loc_1.width, 1 / _loc_1.height, 1);
            _loc_2.prependTranslation(cTexture.nPivotX, cTexture.nPivotY, 0);
            return _aTransformedVertices;
        }

        public function hitTestObject(param1:FTexturedQuad) : Boolean
        {
            var _loc_3:* = param1.getTransformedVertices3D();
            var _loc_2:* = getTransformedVertices3D();
            var _loc_5:* = (_loc_3[0] + _loc_3[3] + _loc_3[6] + _loc_3[9]) / 4;
            var _loc_4:* = (_loc_3[1] + _loc_3[4] + _loc_3[7] + _loc_3[10]) / 4;
            if (isSeparating(_loc_3[3], _loc_3[4], _loc_3[0] - _loc_3[3], _loc_3[1] - _loc_3[4], _loc_5, _loc_4, _loc_2))
            {
                return false;
            }
            if (isSeparating(_loc_3[6], _loc_3[7], _loc_3[3] - _loc_3[6], _loc_3[4] - _loc_3[7], _loc_5, _loc_4, _loc_2))
            {
                return false;
            }
            if (isSeparating(_loc_3[9], _loc_3[10], _loc_3[6] - _loc_3[9], _loc_3[7] - _loc_3[10], _loc_5, _loc_4, _loc_2))
            {
                return false;
            }
            if (isSeparating(_loc_3[0], _loc_3[1], _loc_3[9] - _loc_3[0], _loc_3[10] - _loc_3[1], _loc_5, _loc_4, _loc_2))
            {
                return false;
            }
            _loc_5 = (_loc_2[0] + _loc_2[3] + _loc_2[6] + _loc_2[9]) / 4;
            _loc_4 = (_loc_2[1] + _loc_2[4] + _loc_2[7] + _loc_2[10]) / 4;
            if (isSeparating(_loc_2[3], _loc_2[4], _loc_2[0] - _loc_2[3], _loc_2[1] - _loc_2[4], _loc_5, _loc_4, _loc_3))
            {
                return false;
            }
            if (isSeparating(_loc_2[6], _loc_2[7], _loc_2[3] - _loc_2[6], _loc_2[4] - _loc_2[7], _loc_5, _loc_4, _loc_3))
            {
                return false;
            }
            if (isSeparating(_loc_2[9], _loc_2[10], _loc_2[6] - _loc_2[9], _loc_2[7] - _loc_2[10], _loc_5, _loc_4, _loc_3))
            {
                return false;
            }
            if (isSeparating(_loc_2[0], _loc_2[1], _loc_2[9] - _loc_2[0], _loc_2[10] - _loc_2[1], _loc_5, _loc_4, _loc_3))
            {
                return false;
            }
            return true;
        }

        private function isSeparating(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Vector.<Number>) : Boolean
        {
            var _loc_13:* = -param4;
            var _loc_14:* = param3;
            var _loc_8:* = _loc_13 * (param5 - param1) + _loc_14 * (param6 - param2);
            var _loc_11:* = _loc_13 * (param7[0] - param1) + _loc_14 * (param7[1] - param2);
            var _loc_12:* = _loc_13 * (param7[3] - param1) + _loc_14 * (param7[4] - param2);
            var _loc_9:* = _loc_13 * (param7[6] - param1) + _loc_14 * (param7[7] - param2);
            var _loc_10:* = _loc_13 * (param7[9] - param1) + _loc_14 * (param7[10] - param2);
            if (_loc_8 < 0 && _loc_11 >= 0 && _loc_12 >= 0 && _loc_9 >= 0 && _loc_10 >= 0)
            {
                return true;
            }
            if (_loc_8 > 0 && _loc_11 <= 0 && _loc_12 <= 0 && _loc_9 <= 0 && _loc_10 <= 0)
            {
                return true;
            }
            return false;
        }

        public function hitTestPoint(param1:Vector3D, param2:Boolean = false) : Boolean
        {
            var _loc_4:* = cTexture.width;
            var _loc_6:* = cTexture.height;
            var _loc_5:* = cNode.cTransform.getTransformedWorldTransformMatrix(_loc_4, _loc_6, 0, true);
            var _loc_3:* = _loc_5.transformVector(param1);
            _loc_3.x = _loc_3.x + 0.5;
            _loc_3.y = _loc_3.y + 0.5;
            if (_loc_3.x >= (-cTexture.nPivotX) / _loc_4 && _loc_3.x <= 1 - cTexture.nPivotX / _loc_4 && _loc_3.y >= (-cTexture.nPivotY) / _loc_6 && _loc_3.y <= 1 - cTexture.nPivotY / _loc_6)
            {
                if (mousePixelEnabled && cTexture.getAlphaAtUV(_loc_3.x + cTexture.pivotX / _loc_4, _loc_3.y + cTexture.nPivotY / _loc_6) == 0)
                {
                    return false;
                }
                return true;
            }
            return false;
        }

        override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean
        {
            if (param1 && param2.type == "mouseUp")
            {
                cNode.cMouseDown = null;
            }
            if (param1 || cTexture == null)
            {
                if (cNode.cMouseOver == cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOut", NaN, NaN, param2.buttonDown, param2.ctrlKey);
                }
                return false;
            }
            var _loc_4:* = cTexture.width;
            var _loc_7:* = cTexture.height;
            var _loc_5:* = cNode.cTransform.getTransformedWorldTransformMatrix(_loc_4, _loc_7, 0, true);
            var _loc_6:* = _loc_5.transformVector(param3);
            _loc_6.x = _loc_6.x + 0.5;
            _loc_6.y = _loc_6.y + 0.5;
            if (_loc_6.x >= (-cTexture.nPivotX) / _loc_4 && _loc_6.x <= 1 - cTexture.nPivotX / _loc_4 && _loc_6.y >= (-cTexture.nPivotY) / _loc_7 && _loc_6.y <= 1 - cTexture.nPivotY / _loc_7)
            {
                if (mousePixelEnabled && cTexture.getAlphaAtUV(_loc_6.x + cTexture.pivotX / _loc_4, _loc_6.y + cTexture.nPivotY / _loc_7) == 0)
                {
                    if (cNode.cMouseOver == cNode)
                    {
                        cNode.handleMouseEvent(cNode, "mouseOut", _loc_6.x * _loc_4 + cTexture.nPivotX, _loc_6.y * _loc_7 + cTexture.nPivotY, param2.buttonDown, param2.ctrlKey);
                    }
                    return false;
                }
                cNode.handleMouseEvent(cNode, param2.type, _loc_6.x * _loc_4 + cTexture.nPivotX, _loc_6.y * _loc_7 + cTexture.nPivotY, param2.buttonDown, param2.ctrlKey);
                if (cNode.cMouseOver != cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOver", _loc_6.x * _loc_4 + cTexture.nPivotX, _loc_6.y * _loc_7 + cTexture.nPivotY, param2.buttonDown, param2.ctrlKey);
                }
                return true;
            }
            if (cNode.cMouseOver == cNode)
            {
                cNode.handleMouseEvent(cNode, "mouseOut", _loc_6.x * _loc_4 + cTexture.nPivotX, _loc_6.y * _loc_7 + cTexture.nPivotY, param2.buttonDown, param2.ctrlKey);
            }
            return false;
        }

        override public function dispose() : void
        {
            super.dispose();
            cTexture = null;
            return;
        }

    }
}
