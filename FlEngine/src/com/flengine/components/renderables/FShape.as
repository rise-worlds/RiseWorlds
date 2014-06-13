package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FShape extends FRenderable
    {
        protected var _cMaterial:FCameraTexturedPolygonMaterial;
        var cTexture:FTexture;
        protected var _iMaxVertices:int = 0;
        protected var _iCurrentVertices:int = 0;
        protected var _aVertices:Vector.<Number>;
        protected var _aUVs:Vector.<Number>;
        protected var _bDirty:Boolean = false;
        private static var cTransformVector:Vector.<Number> = new Vector.<Number>(16);

        public function FShape(param1:FNode)
        {
            super(param1);
            _cMaterial = new FCameraTexturedPolygonMaterial();
            return;
        }

        public function setTexture(param1:FTexture) : void
        {
            cTexture = param1;
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (cTexture == null || _iMaxVertices == 0)
            {
                return;
            }
            param1.checkAndSetupRender(_cMaterial, iBlendMode, cTexture.premultiplied, param3);
            _cMaterial.bind(param1.cContext, param1.bReinitialize, param2, _iMaxVertices);
            var _loc_4:* = cNode.cTransform;
            cTransformVector[0] = _loc_4.nWorldX;
            cTransformVector[1] = _loc_4.nWorldY;
            cTransformVector[2] = _loc_4.nWorldScaleX;
            cTransformVector[3] = _loc_4.nWorldScaleY;
            cTransformVector[4] = cTexture.nUvX;
            cTransformVector[5] = cTexture.nUvY;
            cTransformVector[6] = cTexture.nUvScaleX;
            cTransformVector[7] = cTexture.nUvScaleY;
            cTransformVector[8] = _loc_4.nWorldRotation;
            cTransformVector[10] = cTexture.nPivotX * _loc_4.nWorldScaleX;
            cTransformVector[11] = cTexture.nPivotY * _loc_4.nWorldScaleY;
            cTransformVector[12] = _loc_4.nWorldRed * _loc_4.nWorldAlpha;
            cTransformVector[13] = _loc_4.nWorldGreen * _loc_4.nWorldAlpha;
            cTransformVector[14] = _loc_4.nWorldBlue * _loc_4.nWorldAlpha;
            cTransformVector[15] = _loc_4.nWorldAlpha;
            _cMaterial.draw(cTransformVector, cTexture.cContextTexture.tTexture, cTexture.iFilteringType, _aVertices, _aUVs, _iCurrentVertices, _bDirty);
            _bDirty = false;
            return;
        }

        public function init(param1:Vector.<Number>, param2:Vector.<Number>) : void
        {
            var _loc_3:* = 0;
            _bDirty = true;
            _iCurrentVertices = param1.length / 2;
            if (param1.length / 2 > _iMaxVertices)
            {
                _iMaxVertices = param1.length / 2;
                _aVertices = param1;
                _aUVs = param2;
            }
            else
            {
                _loc_3 = 0;
                while (_loc_3 < _iCurrentVertices * 2)
                {
                    
                    _aVertices[_loc_3] = param1[_loc_3];
                    _aUVs[_loc_3] = param2[_loc_3];
                    _loc_3++;
                }
            }
            return;
        }

        new Vector.<Number>(16)[0] = 0;
        new Vector.<Number>(16)[1] = 0;
        new Vector.<Number>(16)[2] = 0;
        new Vector.<Number>(16)[3] = 0;
        new Vector.<Number>(16)[4] = 0;
        new Vector.<Number>(16)[5] = 0;
        new Vector.<Number>(16)[6] = 0;
        new Vector.<Number>(16)[7] = 0;
        new Vector.<Number>(16)[8] = 0;
        new Vector.<Number>(16)[9] = 1;
        new Vector.<Number>(16)[10] = 1;
        new Vector.<Number>(16)[11] = 1;
        new Vector.<Number>(16)[12] = 1;
        new Vector.<Number>(16)[13] = 1;
        new Vector.<Number>(16)[14] = 1;
        new Vector.<Number>(16)[15] = 1;
    }
}
