package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import flash.geom.*;

    public class FColorQuad extends FRenderable
    {
        private static var cMaterial:FDrawColorCameraVertexShaderBatchMaterial;
        private static var cTransformVector:Vector.<Number> = new Vector.<Number>(12);

        public function FColorQuad(param1:FNode)
        {
            super(param1);
            if (cMaterial == null)
            {
                cMaterial = new FDrawColorCameraVertexShaderBatchMaterial();
            }
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (param1.checkAndSetupRender(cMaterial, iBlendMode, true, param3))
            {
                cMaterial.bind(param1.cContext, param1.bReinitialize, param2);
            }
            var _loc_4:* = cNode.cTransform;
            cMaterial.draw(_loc_4.nWorldX, _loc_4.nWorldY, _loc_4.nWorldScaleX, _loc_4.nWorldScaleY, _loc_4.nWorldRotation, _loc_4.nWorldRed, _loc_4.nWorldGreen, _loc_4.nWorldBlue, _loc_4.nWorldAlpha);
            return;
        }

        new Vector.<Number>(12)[0] = 0;
        new Vector.<Number>(12)[1] = 0;
        new Vector.<Number>(12)[2] = 0;
        new Vector.<Number>(12)[3] = 0;
        new Vector.<Number>(12)[4] = 0;
        new Vector.<Number>(12)[5] = 1;
        new Vector.<Number>(12)[6] = 1;
        new Vector.<Number>(12)[7] = 1;
        new Vector.<Number>(12)[8] = 1;
        new Vector.<Number>(12)[9] = 1;
        new Vector.<Number>(12)[10] = 1;
        new Vector.<Number>(12)[11] = 1;
    }
}
